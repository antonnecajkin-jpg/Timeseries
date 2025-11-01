-- ============================================================
-- 1. БАЗА ДАННЫХ RAW
-- ============================================================
CREATE DATABASE IF NOT EXISTS raw;

-- ============================================================
-- 2. ФАКТОВЫЕ ТАБЛИЦЫ
-- ============================================================

-- Просмотры уроков
CREATE TABLE IF NOT EXISTS raw.fact_lesson_views
(
    user_id   UInt32,     -- уникальный пользователь
    lesson_id UInt16,     -- урок
    course_id UInt16,     -- курс
    viewed_at DateTime    -- время просмотра
)
ENGINE = MergeTree
PARTITION BY toYYYYMM(viewed_at)
ORDER BY (viewed_at, user_id, course_id, lesson_id);

-- Записи на курсы
CREATE TABLE IF NOT EXISTS raw.fact_enrollments
(
    user_id    UInt32,
    course_id  UInt16,
    enrolled_at DateTime
)
ENGINE = MergeTree
PARTITION BY toYYYYMM(enrolled_at)
ORDER BY (enrolled_at, user_id, course_id);

-- ============================================================
-- 3. ИЗМЕРЕНИЯ
-- ============================================================

-- Пользователи
CREATE TABLE IF NOT EXISTS raw.dim_user
(
    user_id           UInt32,
    name              String,
    age               UInt8,
    email             String,
    registration_date Date
)
ENGINE = ReplacingMergeTree
ORDER BY user_id;

-- Курсы
CREATE TABLE IF NOT EXISTS raw.dim_courses
(
    course_id UInt16,
    title     String,
    category  String
)
ENGINE = ReplacingMergeTree
ORDER BY course_id;

-- Уроки
CREATE TABLE IF NOT EXISTS raw.dim_lessons
(
    lesson_id    UInt16,
    title        String,
    duration_min UInt16,
    course_id    UInt16
)
ENGINE = ReplacingMergeTree
ORDER BY lesson_id;

-- ============================================================
-- 4. ВИТРИНА 1: lesson_popularity_summary
-- ============================================================

CREATE TABLE IF NOT EXISTS raw.lesson_popularity_summary
(
    lesson_id     UInt16,
    lesson_title  String,
    course_id     UInt16,
    course_title  String,
    total_views   UInt64,
    unique_users  UInt64,
    first_view    DateTime,
    last_view     DateTime
)
ENGINE = ReplacingMergeTree
ORDER BY (lesson_id, course_id);

CREATE MATERIALIZED VIEW IF NOT EXISTS raw.mv_lesson_popularity_summary
TO raw.lesson_popularity_summary
AS
SELECT
    l.lesson_id AS lesson_id,
    l.title     AS lesson_title,
    l.course_id AS course_id,
    c.title     AS course_title,
    count() AS total_views,
    uniqExact(f.user_id) AS unique_users,
    min(f.viewed_at) AS first_view,
    max(f.viewed_at) AS last_view
FROM raw.fact_lesson_views f
INNER JOIN raw.dim_lessons l ON f.lesson_id = l.lesson_id
INNER JOIN raw.dim_courses c ON l.course_id = c.course_id
GROUP BY l.lesson_id, l.title, l.course_id, c.title;

-- ============================================================
-- 5. ВИТРИНА 2: inactive_users_summary
-- ============================================================

CREATE TABLE IF NOT EXISTS raw.inactive_users_summary
(
    user_id          UInt32,
    name             String,
    email            String,
    age              UInt8,
    courses_enrolled UInt32,
    registration_date Date
)
ENGINE = ReplacingMergeTree
ORDER BY user_id;

CREATE MATERIALIZED VIEW IF NOT EXISTS raw.mv_inactive_users_summary
TO raw.inactive_users_summary
AS
SELECT
    u.user_id,
    u.name,
    u.email,
    u.age,
    countDistinct(CAST(e.course_id AS Nullable(UInt32))) AS courses_enrolled,
    u.registration_date
FROM raw.dim_user u
LEFT JOIN raw.fact_enrollments e ON u.user_id = e.user_id
LEFT JOIN raw.fact_lesson_views v ON u.user_id = v.user_id
WHERE v.user_id IS NULL
GROUP BY
    u.user_id,
    u.name,
    u.email,
    u.age,
    u.registration_date;


-- ============================================================
-- 6. ВИТРИНА 3: course_completion_rate
-- ============================================================

CREATE TABLE IF NOT EXISTS raw.course_completion_rate
(
    user_id          UInt32,
    course_id        UInt16,
    lessons_in_course UInt32,
    lessons_viewed    UInt32,
    completion_rate   Float32
)
ENGINE = ReplacingMergeTree
ORDER BY (user_id, course_id);

CREATE MATERIALIZED VIEW IF NOT EXISTS raw.mv_course_completion_rate
TO raw.course_completion_rate
AS
SELECT
    e.user_id AS user_id,
    e.course_id AS course_id,
    countDistinct(l.lesson_id) AS lessons_in_course,
    countDistinct(v.lesson_id) AS lessons_viewed,
    if(countDistinct(l.lesson_id) = 0, 0,
       countDistinct(v.lesson_id) / countDistinct(l.lesson_id)) AS completion_rate
FROM raw.fact_enrollments e
INNER JOIN raw.dim_courses c ON e.course_id = c.course_id
INNER JOIN raw.dim_lessons l ON c.course_id = l.course_id
LEFT JOIN raw.fact_lesson_views v
       ON e.user_id = v.user_id AND v.course_id = e.course_id
GROUP BY e.user_id, e.course_id;

INSERT INTO raw.inactive_users_summary
SELECT
    u.user_id,
    u.name,
    u.email,
    u.age,
    countDistinct(CAST(e.course_id AS Nullable(UInt32))) AS courses_enrolled,
    u.registration_date
FROM raw.dim_user u
LEFT JOIN raw.fact_enrollments e ON u.user_id = e.user_id
LEFT JOIN raw.fact_lesson_views v ON u.user_id = v.user_id
WHERE v.user_id IS NULL
GROUP BY
    u.user_id,
    u.name,
    u.email,
    u.age,
    u.registration_date;



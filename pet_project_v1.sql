CREATE TABLE users (
    id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    age INT,
    email VARCHAR(255) UNIQUE,
    registration_date DATE NOT NULL
);


INSERT INTO users (id, name, age, email, registration_date) VALUES

(1, 'Alice', 25, 'alice@mail.com', '2023-01-10'),
(2, 'Bob', 30, 'bob@gmail.com', '2023-02-05'),
(3, 'Charlie', 22, 'charlie@mail.com', '2023-02-20'),
(4, 'Diana', 28, 'diana@mail.com', '2023-03-01'),
(5, 'Ethan', 35, 'ethan@gmail.com', '2023-03-10');

CREATE TABLE courses (
    id INT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    created_at DATE NOT NULL
);


INSERT INTO courses (id, title, category, created_at) VALUES
(1, 'SQL для начинающих', 'data', '2023-01-01'),
(2, 'Python для анализа данных', 'programming', '2023-01-15'),
(3, 'BI с нуля', 'business', '2023-03-01');


CREATE TABLE lessons (
    id INT PRIMARY KEY,
    course_id INT NOT NULL,
    title VARCHAR(100) NOT NULL,
    duration_min INT NOT NULL CHECK (duration_min > 0),
    FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE
);


INSERT INTO lessons (id, course_id, title, duration_min) VALUES
(1, 1, 'SELECT и FROM', 10),    
(2, 1, 'JOIN', 15),              
(3, 2, 'Pandas', 20),            
(4, 3, 'Основы BI', 12),         
(5, 3, 'Метрики и дашборды', 18);

-- 
CREATE TABLE enrollments (
    id INT PRIMARY KEY,
    user_id INT NOT NULL,
    course_id INT NOT NULL,
    enrolled_at DATE NOT NULL DEFAULT CURRENT_DATE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
    CONSTRAINT unique_enrollment UNIQUE (user_id, course_id) 
);


INSERT INTO enrollments (id, user_id, course_id, enrolled_at) VALUES
(1, 1, 1, '2023-01-15'),  
(2, 1, 2, '2023-02-01'),  
(3, 2, 1, '2023-01-20'),  
(4, 3, 2, '2023-03-05'),  
(5, 4, 3, '2023-04-01');  


CREATE TABLE lesson_views (
    id INT PRIMARY KEY,
    user_id INT NOT NULL,
    lesson_id INT NOT NULL,
    viewed_at TIMESTAMP NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (lesson_id) REFERENCES lessons(id) ON DELETE CASCADE,
    CONSTRAINT unique_view UNIQUE (user_id, lesson_id, viewed_at) 
);


INSERT INTO lesson_views (id, user_id, lesson_id, viewed_at) VALUES

(1, 1, 1, '2023-01-16 10:00:00'),
(2, 1, 2, '2023-01-16 10:15:00'),
(3, 2, 1, '2023-01-21 09:00:00'),
(4, 3, 3, '2023-03-06 12:00:00'),
(5, 4, 4, '2023-04-02 10:00:00'),
(6, 4, 5, '2023-04-03 10:00:00');



--create materialezed view user_activity_summary as 
--select 




SELECT COUNT(*) as active_connections, usename 
FROM pg_stat_activity 
GROUP BY usename;

SELECT rolname, rolconnlimit FROM pg_roles WHERE rolname = 'gpadmin';

sql
CREATE ROLE gpadmin WITH SUPERUSER LOGIN PASSWORD 'changeme';
ALTER ROLE gpadmin CONNECTION LIMIT -1;

CREATE ROLE gpadmin WITH SUPERUSER LOGIN PASSWORD 'changeme';

ALTER ROLE gpadmin CONNECTION LIMIT -1;



copy (SELECT * FROM public.users) TO 'C:/temp/users.csv' WITH CSV header;
copy (SELECT * FROM public.courses) TO 'C:/temp/courses.csv' WITH CSV header;
copy (SELECT * FROM public.lessons) TO 'C:/temp/lessons.csv' WITH CSV header;
copy (SELECT * FROM public.enrollments) TO 'C:/temp/enrollments.csv' WITH CSV header;
copy (SELECT * FROM public.lesson_views) TO 'C:/temp/lesson_views.csv' WITH CSV header;
















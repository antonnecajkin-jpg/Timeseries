-- Создаем таблицу logs
CREATE TABLE logs (
  dt DateTime,
  user_id UInt32,
  event_type String
) ENGINE = MergeTree
ORDER BY dt;

-- Генерация 10,000 случайных записей за последние 30 дней
INSERT INTO logs
SELECT 
    now() - randUniform(1, 2592000) as dt,  -- случайное время за 30 дней
    rand() % 1000 + 1 as user_id,           -- 1000 уникальных пользователей
    ['login', 'view_page', 'click_button', 'purchase', 'logout'][rand() % 5 + 1] as event_type
FROM numbers(10000);


-- Проверяем, что данные вставились
SELECT count() FROM logs;

-- Смотрим структуру данных
SELECT * FROM logs LIMIT 10;

-- Создаем распределенную таблицу поверх локальной
CREATE TABLE dist_logs AS logs
ENGINE = Distributed(
    'company_cluster',  -- имя кластера в config.xml
    'default',          -- база данных
    'logs',             -- локальная таблица-источник
    rand()              -- ключ шардирования
);


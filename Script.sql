CREATE TABLE users (
  id INT PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  age INT,
  email VARCHAR(100),
  country VARCHAR(50),
  is_active BOOLEAN DEFAULT true,
  created_at DATE NOT NULL
);
psql --username=freecodecamp --dbname=postgres -c "CREATE DATABASE salon;"

psql --username=freecodecamp --dbname=salon -c "
CREATE TABLE IF NOT EXISTS customers (
  customer_id SERIAL PRIMARY KEY,
  phone VARCHAR UNIQUE,
  name VARCHAR
);

CREATE TABLE IF NOT EXISTS services (
  service_id SERIAL PRIMARY KEY,
  name VARCHAR
);

CREATE TABLE IF NOT EXISTS appointments (
  appointment_id SERIAL PRIMARY KEY,
  customer_id INT REFERENCES customers(customer_id),
  service_id INT REFERENCES services(service_id),
  time VARCHAR
);"

psql --username=freecodecamp --dbname=salon -c "
INSERT INTO services(name) VALUES
('cut'), ('color'), ('perm'), ('style'), ('trim')
ON CONFLICT DO NOTHING;"
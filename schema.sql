
DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS employee;
DROP TABLE IF EXISTS customer_acct_num;
DROP TABLE IF EXISTS product;
DROP TABLE IF EXISTS frequency;

CREATE TABLE employee(
id SERIAL PRIMARY KEY,
name_email VARCHAR(100)
);

CREATE TABLE customer_acct_num(
id SERIAL PRIMARY KEY,
name_number VARCHAR(100)
);

CREATE TABLE product(
  id SERIAL PRIMARY KEY,
  product_name VARCHAR(100)
);

CREATE TABLE frequency(
  id SERIAL PRIMARY KEY,
  invoice_frequency VARCHAR(100)
);

CREATE TABLE sales(
id SERIAL PRIMARY KEY,
sale_date DATE,
sale_amount VARCHAR(100),
units_sold INTEGER,
invoice_no INTEGER,
employee_id INTEGER REFERENCEs employee(id),
customer_id INTEGER REFERENCEs customer_acct_num(id),
product_id INTEGER REFERENCEs product(id),
frequency_id INTEGER REFERENCEs frequency(id)
);

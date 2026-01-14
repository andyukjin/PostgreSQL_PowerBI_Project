CREATE DATABASE pizza_analysis;

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    order_date DATE,
    order_time TIME
);

CREATE TABLE pizza_types (
    pizza_type_id TEXT PRIMARY KEY,
    name TEXT,
    category TEXT,
    ingredients TEXT
);

CREATE TABLE pizzas (
    pizza_id TEXT PRIMARY KEY,
    pizza_type_id TEXT,
    size TEXT,
    price NUMERIC,
    FOREIGN KEY (pizza_type_id) REFERENCES pizza_types(pizza_type_id)
);

CREATE TABLE order_details (
    order_details_id INT PRIMARY KEY,
    order_id INT,
    pizza_id TEXT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (pizza_id) REFERENCES pizzas(pizza_id)
);

\copy orders FROM 'C:\Users\61414\Desktop\pizza analysis\orders.csv' CSV HEADER;
\copy pizza_types FROM 'C:\Users\61414\Desktop\pizza analysis\pizza_types.csv' CSV HEADER;
\copy pizzas FROM 'C:\Users\61414\Desktop\pizza analysis\pizzas.csv' CSV HEADER;
\copy order_details FROM 'C:\Users\61414\Desktop\pizza analysis\order_details.csv' CSV HEADER;

SELECT COUNT(*) FROM orders;

CREATE OR REPLACE VIEW v_total_revenue AS
SELECT
  SUM(revenue) AS total_revenue
FROM pizza_sales;

CREATE OR REPLACE VIEW v_avg_order_value AS
SELECT
  SUM(revenue) / COUNT(DISTINCT order_id) AS avg_order_value
FROM pizza_sales;

CREATE OR REPLACE VIEW v_total_pizzas_sold AS
SELECT
  SUM(quantity) AS total_pizzas_sold
FROM pizza_sales;

CREATE OR REPLACE VIEW v_total_orders AS
SELECT
  COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales;

CREATE OR REPLACE VIEW v_avg_pizzas_per_order AS
SELECT
  ROUND(
    SUM(quantity)::numeric / COUNT(DISTINCT order_id),
    2
  ) AS avg_pizzas_per_order
FROM pizza_sales;

CREATE OR REPLACE VIEW v_daily_orders_by_weekday AS
SELECT
  EXTRACT(DOW FROM order_date) AS day_number,
  TO_CHAR(order_date, 'Dy') AS day_name,
  COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales
GROUP BY day_number, day_name
ORDER BY day_number;

CREATE OR REPLACE VIEW v_monthly_orders AS
SELECT
  EXTRACT(MONTH FROM order_date) AS month_number,
  TO_CHAR(order_date, 'Mon') AS month_name,
  COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales
GROUP BY month_number, month_name
ORDER BY month_number;

CREATE OR REPLACE VIEW v_hourly_orders AS
SELECT
  EXTRACT(HOUR FROM order_time) AS order_hour,
  COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales
GROUP BY order_hour
ORDER BY order_hour;

CREATE OR REPLACE VIEW v_daily_orders AS
SELECT
  order_date,
  COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales
GROUP BY order_date
ORDER BY order_date;

CREATE OR REPLACE VIEW v_sales_pct_by_category AS
SELECT
  category,
  ROUND(
    SUM(revenue) * 100.0
    / SUM(SUM(revenue)) OVER (),
    2
  ) AS percent_of_sales
FROM pizza_sales
GROUP BY category
ORDER BY percent_of_sales DESC;

CREATE OR REPLACE VIEW v_sales_pct_by_size AS
SELECT
  size,
  ROUND(
    SUM(revenue) * 100.0
    / SUM(SUM(revenue)) OVER (),
    2
  ) AS percent_of_sales
FROM pizza_sales
GROUP BY size
ORDER BY percent_of_sales DESC;

CREATE OR REPLACE VIEW v_top_5_products_by_revenue AS
SELECT
  pizza_name,
  SUM(revenue) AS total_revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_revenue DESC
LIMIT 5;

CREATE OR REPLACE VIEW v_bottom_5_products_by_revenue AS
SELECT
  pizza_name,
  SUM(revenue) AS total_revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_revenue
LIMIT 5;

CREATE OR REPLACE VIEW v_top_5_products_by_quantity AS
SELECT
  pizza_name,
  SUM(quantity) AS total_quantity
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_quantity DESC
LIMIT 5;


CREATE OR REPLACE VIEW v_bottom_5_products_by_quantity AS
SELECT
  pizza_name,
  SUM(quantity) AS total_quantity
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_quantity
LIMIT 5;

CREATE OR REPLACE VIEW v_top_5_products_by_orders AS
SELECT
  pizza_name,
  COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_orders DESC
LIMIT 5;

CREATE OR REPLACE VIEW v_bottom_5_products_by_orders AS
SELECT
  pizza_name,
  COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_orders
LIMIT 5;

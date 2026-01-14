SELECT * FROM pizza_sales;

-- Key Performance Indicators

--1. Total Revenue
SELECT
	SUM(total_price) AS total_revenue
FROM 
	pizza_sales;
	
--2. Average Order Value
SELECT
	SUM(total_price) / COUNT (DISTINCT order_id)  AS AVG_Order_Value

FROM
	pizza_sales;
	
--3. Total Pizza Sold
SELECT
	SUM(quantity) AS Total_Pizza_Sold
FROM
	pizza_sales;

--4. Total Orders
SELECT
	COUNT(DISTINCT order_id) AS Total_Orders
FROM
	pizza_sales;
	
--5. Average Pizzas Per Order
SELECT
	ROUND(
		ROUND(SUM(quantity),2) / ROUND(COUNT(DISTINCT order_id),2)
		,2) AS Average_pizza_per_order
FROM
	pizza_sales;


--6. Daily Trend for Total Orders (Grouped by date)
SELECT
  EXTRACT(DOW FROM order_date) AS day_number,
  TO_CHAR(order_date, 'Dy') AS order_day,
  COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales
GROUP BY day_number, order_day
ORDER BY day_number;
	
--7. Monthly Trend for Total Orders
SELECT
  EXTRACT(MONTH FROM order_date) AS month_number,
  TO_CHAR(order_date, 'Mon') AS month_name,
  COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales
GROUP BY month_number, month_name
ORDER BY month_number;

--8. Percentage of Sales by Pizza Category
SELECT
  pizza_category,
  ROUND(
    SUM(total_price) * 100.0
    / SUM(SUM(total_price)) OVER (),
      2
  ) AS percent_of_sales
FROM pizza_sales
GROUP BY pizza_category
ORDER BY percent_of_sales DESC;
	
--9. Percentage of Sales by Pizza Size
SELECT
  pizza_size,
  ROUND(
    SUM(total_price) * 100.0
    / SUM(SUM(total_price)) OVER (),
    2
  ) AS percent_of_sales
FROM pizza_sales
GROUP BY pizza_size
ORDER BY percent_of_sales DESC;

--10. 5 Best Product by Revenue
SELECT
	pizza_name, SUM(total_price) AS Total_Revenue
FROM
	pizza_sales
GROUP BY 
	pizza_name
ORDER BY
	Total_Revenue DESC
LIMIT 
	5
	;

--11. 5 Worst Performing Product by Revenue
SELECT
	pizza_name, SUM(total_price) AS Total_Revenue
FROM
	pizza_sales
GROUP BY 
	pizza_name
ORDER BY
	Total_Revenue
LIMIT 
	5
	;

--12. 5 Best Selling Product by Quantity
SELECT
	pizza_name, SUM(quantity) AS Total_Quantity
FROM
	pizza_sales
GROUP BY 
	pizza_name
ORDER BY
	Total_Quantity DESC
LIMIT 
	5
	;

--13. 5 Worst Product by Revenue
SELECT
	pizza_name, SUM(quantity) AS Total_Quantity
FROM
	pizza_sales
GROUP BY 
	pizza_name
ORDER BY
	Total_Quantity 
LIMIT 
	5
	;

--14. 5 Best Product by Total Orders
SELECT
	pizza_name, COUNT(DISTINCT order_id) AS Total_Orders
FROM
	pizza_sales
GROUP BY 
	pizza_name
ORDER BY
	Total_Orders DESC
LIMIT 
	5
	;

--15. 5 Worst Product by Total Orders
SELECT
	pizza_name, COUNT(DISTINCT order_id) AS Total_Orders
FROM
	pizza_sales
GROUP BY 
	pizza_name
ORDER BY
	Total_Orders
LIMIT 
	5
	;

--16. Number of orders each day & hours

SELECT
  order_date,
  COUNT(DISTINCT order_id) AS total_orders
FROM
  pizza_sales
GROUP BY
  order_date
ORDER BY
  order_date;

--17. Number of orders each hours

SELECT
  EXTRACT(HOUR FROM order_time) AS order_hour,
  COUNT(DISTINCT order_id) AS num_orders
FROM
  pizza_sales
GROUP BY
  order_hour
ORDER BY
  num_orders DESC;


--18. Seasonality trends
SELECT
  EXTRACT(MONTH FROM order_date) AS month,
  COUNT(DISTINCT order_id) AS total_orders
FROM
  pizza_sales
GROUP BY
  month
ORDER BY
  month;

--19. Average Daily Orders
WITH daily_orders AS (
  SELECT
    order_date,
    COUNT(DISTINCT order_id) AS daily_orders
  FROM pizza_sales
  GROUP BY order_date
)
SELECT
    ROUND(AVG(daily_orders), 2) AS avg_orders_per_day
FROM daily_orders;

--19)Average number of pizza per day
WITH daily_pizza AS (
  SELECT
    order_date,
    SUM(quantity) AS total_pizzas_per_day
  FROM pizza_sales
  GROUP BY order_date
)
SELECT
  ROUND(AVG(total_pizzas_per_day), 2) AS avg_pizzas_per_day
FROM daily_pizza;


-- View command to see all information

CREATE VIEW pizza_sales AS
SELECT
    o.order_id,
    o.order_date,
    o.order_time,
    pt.category,
    pt.name AS pizza_name,
    p.size,
    od.quantity,
    p.price,
    (od.quantity * p.price) AS revenue
FROM order_details od
JOIN orders o ON od.order_id = o.order_id
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id;
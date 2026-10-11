SELECT DISTINCT p.*
FROM products as p
JOIN product_categories as pc
ON pc.product_id = p.product_id
JOIN categories as c
ON pc.category_id = c.category_id
WHERE c.category_name = 'Footwear';


SELECT * FROM products
WHERE price >= 50 OR price <= 150
ORDER BY price ASC;

SELECT * FROM customers
WHERE last_name ILIKE 'M%' OR last_name ILIKE 'K%';

SELECT * FROM orders
WHERE status IN ('pending', 'shipped')
ORDER BY order_date DESC;

SELECT * FROM products
WHERE name ILIKE '%pro%';

SELECT COUNT(*)
FROM products;

SELECT ROUND(AVG(price), 2)
FROM products;

SELECT 
MIN(price) as smallest_price,
MAX(price) as biggest_price
FROM products;

SELECT
c.first_name || ' ' || c.last_name AS customer_name,
COUNT(o.order_id) AS order_count
from customers AS c
LEFT JOIN orders AS o
ON o.customer_id = c.customer_id
GROUP BY
c.customer_id,
c.first_name,
c.last_name
ORDER BY order_count DESC;

SELECT
o.status,
SUM(item.quantity * item.unit_price) AS total_revenue
FROM orders AS o
JOIN order_items as item
ON
o.order_id = item.order_id
GROUP BY o.status
ORDER BY total_revenue DESC;

SELECT
	p.product_id,
	p.name AS product_name,
	c.category_name as category_name
FROM products AS p
JOIN product_categories AS pc
	ON pc.product_id = p.product_id
JOIN categories AS c
	ON pc.category_id = c.category_id
ORDER BY product_name, category_name;

SELECT c.name AS category_name, p.name AS product_name, p.price AS product_price
FROM pet_categories AS c
JOIN pet_products AS p
ON
c.category_id = p.category_id
ORDER BY c.name, p.price DESC;

SELECT 
c.first_name,
c.last_name,
SUM(sales.quantity * sales.unit_price) AS total
FROM pet_customers AS c
JOIN pet_sales AS sales
ON 
c.customer_id = sales.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total DESC;

SELECT DISTINCT
c.name AS category_name
FROM pet_categories AS c
JOIN pet_products AS p
ON c.category_id = p.category_id
LEFT JOIN
pet_sales AS sales
ON
sales.product_id = p.product_id
WHERE
sales.product_id IS NULL;

SELECT
c.name AS category_name,
COALESCE(SUM(sales.quantity * sales.unit_price), 0) AS total_revenue
FROM pet_categories AS c
LEFT JOIN pet_products AS p
ON
p.category_id = c.category_id
LEFT JOIN pet_sales AS sales
ON
sales.product_id = p.product_id
GROUP BY
c.category_id, category_name
ORDER BY
total_revenue DESC;

SELECT
p.name AS product_name,
COALESCE(SUM(sales.quantity), 0) AS sold
FROM pet_products AS p
LEFT JOIN pet_sales AS sales
ON
sales.product_id = p.product_id
GROUP BY p.product_id, product_name
ORDER BY sold DESC
LIMIT 1;
SELECT *
FROM products
WHERE
price > (SELECT AVG(price) FROM products);

SELECT first_name, last_name
FROM customers
WHERE
customer_id IN (
    SELECT customer_id
    FROM orders
    GROUP BY customer_id
    HAVING COUNT(*) > 2
);

SELECT
    p.name,
    c.category_name,
    p.price,
    p.price - (
        SELECT AVG(p2.price)
        FROM products AS p2
        JOIN product_categories AS pc2
            ON pc2.product_id = p2.product_id
        WHERE pc2.category_id = pc.category_id
    ) AS difference_from_category_average
FROM products AS p
JOIN product_categories AS pc
    ON pc.product_id = p.product_id
JOIN categories AS c
    ON c.category_id = pc.category_id;

SELECT c.first_name, c.last_name
FROM customers AS c
JOIN products AS p
WHERE EXISTS (
    SELECT 1
    FROM orders AS o
    JOIN order_items AS oi
    ON
    oi.order_id = o.order_id
    JOIN product_categories AS pc
    ON
     pc.product_id = oi.product_id
    JOIN categories AS cat
    ON
    cat.category_id = pc.category_id
    WHERE o.customer_id = c.customer_id
    AND
    cat.category_name = 'Footwear'
);

SELECT 
p.name
FROM products AS p
WHERE NOT EXISTS(
    SELECT 1
    FROM order_items AS oi
    WHERE oi.product_id = p.product_id
);

SELECT 
name,
price,
CASE 
WHEN price < 25 THEN ('Budget')
WHEN price >= 25 AND price <= 74.99 THEN ('Standart')
WHEN price >= 75 THEN ('Premium')
END AS price_tier
FROM products;

SELECT
COUNT(
    CASE
    WHEN status = 'pending' THEN 1 END
) AS pending,
COUNT(
    CASE
    WHEN status = 'paid' THEN 1 END
) AS paid,
COUNT(
    CASE
    WHEN status = 'shipped' THEN 1 END
) AS shipped,
COUNT(
    CASE
    WHEN status = 'delivered' THEN 1 END
) AS delivered,
COUNT(
    CASE
    WHEN status = 'cancelled' THEN 1 END
) AS cancelled
FROM orders;

CREATE VIEW v_product_catalog AS
SELECT
p.name AS product_name,
c.category_name AS category_name, 
p.price AS product_price,
CASE
WHEN stock_quantity = 0 THEN ('Out of Stock')
WHEN stock_quantity <= 5 THEN ('Low Stock')
WHEN stock_quantity > 5 THEN ('In Stock')
END AS stock_status
FROM products AS p
LEFT JOIN product_categories AS pc
ON
p.product_id = pc.product_id
LEFT JOIN categories AS c
ON 
c.category_id = pc.category_id
ORDER BY category_name;

CREATE VIEW v_customer_summary AS
SELECT
c.first_name || '' || c.last_name AS full_name,
c.email,
COUNT(o.order_id) AS number_of_orders,
SUM(oi.quantity * oi.unit_price) AS total_spent
FROM customers AS c
LEFT JOIN orders AS o
ON o.customer_id = c.customer_id
LEFT JOIN order_items AS oi
ON oi.order_id = o.order_id
GROUP BY c.customer_id;

CREATE VIEW v_monthly_revenue AS
SELECT
DATE_TRUNC('month', o.order_date) AS month,
SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM orders AS o
LEFT JOIN order_items AS oi
ON oi.order_id = o.order_id
GROUP BY month;

SELECT name 
FROM products
UNION
SELECT category_name FROM categories;
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
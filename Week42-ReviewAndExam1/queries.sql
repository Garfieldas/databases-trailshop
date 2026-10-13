SELECT c.name AS category_name, p.name AS product_name, p.price AS product_price
FROM pet_categories AS c
JOIN pet_products AS p
ON
c.category_id = p.category_id
ORDER BY c.name, p.price DESC;
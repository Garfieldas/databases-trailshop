BEGIN TRANSACTION;

WITH new_order AS (
    INSERT INTO orders (
        customer_id, status, shipping_address
    )
    VALUES (
        1, 'paid', 'Mikkeli'
    )
    RETURNING order_id
)

INSERT INTO order_items (
    order_id, product_id, quantity, unit_price
)
VALUES
    ((SELECT order_id FROM new_order), 1, 2, 100.0),
    ((SELECT order_id FROM new_order), 2, 1, 20.0),
    ((SELECT order_id FROM new_order), 3, 5, 40.0);


SAVEPOINT stock_roll_back;

UPDATE products
SET stock_quantity = stock_quantity - 1
WHERE product_id IN (1, 2, 3);

COMMIT;
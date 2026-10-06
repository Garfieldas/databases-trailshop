INSERT INTO categories (category_name, description)
    VALUES
    
        ('Footwear', 'Lorem ipsum dolor sit amet'),
        ('Backpacks', 'Lorem ipsum dolor sit amet'),
        ('Tents', 'Lorem ipsum dolor sit amet'),
        ('Clothing', 'Lorem ipsum dolor sit amet'),
        ('Accessories', 'Lorem ipsum dolor sit amet');

 INSERT INTO customers (first_name, last_name, email,
     phone, street_address, city, postal_code, country)
 VALUES
     ('John', 'Doe', 'johndoe@gmail.com',
      '+358 40 123 4567', 'Mikpolku 3', 'Mikkeli', '50100', 'Finland'),

     ('Rosa', 'Hinton', 'rosahin@gmail.com',
      NULL, NULL, NULL, NULL, 'Brazil'),

     ('Anna', 'Korhonen', 'anna.korhonen@outlook.com',
      '+358 50 987 6543', 'Satamakatu 12', 'Helsinki', '00160', 'Finland'),

     ('Liam', 'Murphy', 'liam.murphy@yahoo.com',
      '+353 85 111 2233', '14 O''Connell Street', 'Dublin', 'D01', 'Ireland'),

     ('Sofia', 'Silva', 'sofia.silva@gmail.com',
      '+55 11 91234 5678', 'Rua Augusta 500', 'São Paulo', '01304-001','Brazil');

INSERT INTO products (name, description, price, weight_kg, stock_quantity)
    VALUES
        ('Hiking Boots', 'Lorem ipsum dolor sit amet.', 120.00, 1.2, 50),
        ('Trail Sandals', NULL, 69.99, 0.450, 0),

        ('Samsonite Backpack', 'Lorem ipsum dolor sit amet.', 80.00, 0.8, 100),
        ('Hydration Pack 12L', 'Lorem ipsum dolor sit amet', 89.90, 0.600, 0),

        ('Double Tent', NULL, 150.00, 2.5, 30),
        ('Ultralight Bivy Tent', 'Lorem ipsum dolor sit amet', 229.00, 1.100, 0),

        ('Rain Jacket', 'Lorem ipsum dolor sit amet.', 90.00, 0.5, 75),
        ('Thermal Base Layer Set', 'Lorem ipsum dolor sit amet', 54.95, 0.300, 0),

        ('Water Bottle', NULL, 25.00, 0.3, 0),
        ('Headlamp 400lm', NULL, 45.50, 0.090, 0);


INSERT INTO product_categories (category_id, product_id)
SELECT category.category_id, product.product_id
FROM categories AS category
JOIN products AS product ON
    category.category_name = 'Footwear'
    AND (
        product.name ILIKE '%sandals%'
        OR
        product.name ILIKE '%boots%'
    );

INSERT INTO product_categories (category_id, product_id)
SELECT category.category_id, product.product_id
FROM categories AS category
JOIN products AS product
    ON product.name ILIKE '%Backpack%'
    OR product.name ILIKE '%Pack%'
WHERE category.category_name = 'Backpacks';

INSERT INTO product_categories (category_id, product_id)
SELECT category.category_id, product.product_id
FROM categories AS category
JOIN products AS product
    ON product.name ILIKE '%Tent%'
WHERE category.category_name = 'Tents';

INSERT INTO product_categories (category_id, product_id)
SELECT category.category_id, product.product_id
FROM categories AS category
JOIN products AS product
    ON product.name ILIKE '%Jacket%'
    OR product.name ILIKE '%Layer set%'
WHERE category.category_name = 'Clothing';

INSERT INTO product_categories (category_id, product_id)
SELECT category.category_id, product.product_id
FROM categories AS category
JOIN products AS product
    ON product.name ILIKE '%Bottle%'
    OR product.name ILIKE '%Headlamp%'
WHERE category.category_name = 'Accessories';

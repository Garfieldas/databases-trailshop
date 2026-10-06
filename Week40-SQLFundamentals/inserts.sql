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
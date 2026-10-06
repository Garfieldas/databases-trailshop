# Week 40 — Exercises: SQL Fundamentals

> [!IMPORTANT]
> **_How to Complete These Exercises_**
> Write your answers directly in the highlighted **Your Answer** / **Your SQL** fields below each task. Replace the placeholder text with your own work before submitting.

## Exercise 1: TrailShop Project Task

This week you'll build the TrailShop database from scratch and practice manipulating data.

### Task 1.1: Create the Database

1. Open your PostgreSQL terminal (psql) or pgAdmin
2. Create a new database called `trailshop`
3. Connect to it

### Task 1.2: Create All Tables

Write and execute the CREATE TABLE statements for all six TrailShop tables in the correct order:

- categories
- customers
- products
- product_categories
- orders
- order_items

**Requirements:**

- Use appropriate data types for each column
- Include all constraints from the theory (NOT NULL, UNIQUE, CHECK, FOREIGN KEY, DEFAULT)
- Use SERIAL for primary keys
- Ensure foreign keys reference the correct parent tables

**Verify** by running `\dt` in psql to list all tables.

> [!NOTE]
> **_Your SQL_**
>
> ```sql
> CREATE TABLE categories (
>     category_id   SERIAL PRIMARY KEY,
>     category_name VARCHAR(100) NOT NULL UNIQUE,
>     description   VARCHAR(500)
> );
>
> CREATE TABLE customers (
>     customer_id    SERIAL PRIMARY KEY,
>     first_name     VARCHAR(50)  NOT NULL,
>     last_name      VARCHAR(50)  NOT NULL,
>     email          VARCHAR(255) NOT NULL UNIQUE,
>     phone          VARCHAR(25),
>     street_address VARCHAR(150),
>     city           VARCHAR(100),
>     postal_code    VARCHAR(20),
>     country        VARCHAR(100),
>     registered_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),
>     CONSTRAINT chk_customers_email_format
>         CHECK (email ~* '^[^@\s]+@[^@\s]+\.[^@\s]+$')
> );
>
> CREATE TABLE products (
>     product_id     SERIAL PRIMARY KEY,
>     name           VARCHAR(150)  NOT NULL,
>     description    VARCHAR(1000),
>     price          NUMERIC(10,2) NOT NULL CHECK (price >= 0),
>     weight_kg      NUMERIC(8,3)  CHECK (weight_kg > 0),
>     stock_quantity INTEGER       NOT NULL DEFAULT 0
>                    CHECK (stock_quantity >= 0),
>     created_at     TIMESTAMPTZ   NOT NULL DEFAULT now()
> );
>
> CREATE TABLE product_categories (
>     category_id INTEGER NOT NULL,
>     product_id  INTEGER NOT NULL,
>     PRIMARY KEY (category_id, product_id),
>     CONSTRAINT fk_pc_category FOREIGN KEY (category_id)
>         REFERENCES categories (category_id)
>         ON DELETE CASCADE ON UPDATE CASCADE,
>     CONSTRAINT fk_pc_product FOREIGN KEY (product_id)
>         REFERENCES products (product_id)
>         ON DELETE CASCADE ON UPDATE CASCADE
> );
>
> CREATE TABLE orders (
>     order_id         SERIAL PRIMARY KEY,
>     order_date       TIMESTAMPTZ NOT NULL DEFAULT now(),
>     status           VARCHAR(20) NOT NULL DEFAULT 'pending'
>                      CHECK (status IN
>                          ('pending', 'paid', 'shipped', 'delivered', 'cancelled')),
>     shipping_address VARCHAR(300),
>     customer_id      INTEGER NOT NULL,
>     CONSTRAINT fk_orders_customer FOREIGN KEY (customer_id)
>         REFERENCES customers (customer_id)
>         ON DELETE RESTRICT ON UPDATE CASCADE
> );
>
> CREATE TABLE order_items (
>     order_id   INTEGER NOT NULL,
>     product_id INTEGER NOT NULL,
>     quantity   INTEGER       NOT NULL CHECK (quantity > 0),
>     unit_price NUMERIC(10,2) NOT NULL CHECK (unit_price >= 0),
>     PRIMARY KEY (order_id, product_id),
>     CONSTRAINT fk_oi_order FOREIGN KEY (order_id)
>         REFERENCES orders (order_id)
>         ON DELETE CASCADE ON UPDATE CASCADE,
>     CONSTRAINT fk_oi_product FOREIGN KEY (product_id)
>         REFERENCES products (product_id)
>         ON DELETE RESTRICT ON UPDATE CASCADE
> );
> ```

### Task 1.3: Insert Sample Data

Insert the following data:

**Categories** (at least 5):

- Footwear, Backpacks, Tents, Clothing, Accessories

> [!NOTE]
> **_Your SQL_**
>
> ```sql
> INSERT INTO categories (category_name, description)
>    VALUES
>    
>        ('Footwear', 'Lorem ipsum dolor sit amet'),
>        ('Backpacks', 'Lorem ipsum dolor sit amet'),
>        ('Tents', 'Lorem ipsum dolor sit amet'),
>        ('Clothing', 'Lorem ipsum dolor sit amet'),
>        ('Accessories', 'Lorem ipsum dolor sit amet');
> ```

**Customers** (at least 5):

- Use easy to write names with realistic email addresses

> [!NOTE]
> **_Your SQL_**
>
> ```sql
> INSERT INTO customers (first_name, last_name, email,
>     phone, street_address, city, postal_code, country)
> VALUES
>     ('John', 'Doe', 'johndoe@gmail.com',
>      '+358 40 123 4567', 'Mikpolku 3', 'Mikkeli', '50100', 'Finland'),
>
>     ('Rosa', 'Hinton', 'rosahin@gmail.com',
>      NULL, NULL, NULL, NULL, 'Brazil'),
>
>     ('Anna', 'Korhonen', 'anna.korhonen@outlook.com',
>      '+358 50 987 6543', 'Satamakatu 12', 'Helsinki', '00160', 'Finland'),
>
>     ('Liam', 'Murphy', 'liam.murphy@yahoo.com',
>      '+353 85 111 2233', '14 O''Connell Street', 'Dublin', 'D01', 'Ireland'),
>
>     ('Sofia', 'Silva', 'sofia.silva@gmail.com',
>      '+55 11 91234 5678', 'Rua Augusta 500', 'São Paulo', '01304-001','Brazil');
> ```

**Products** (at least 10):

- At least 2 products per category
- At least one product assigned to **two or more** categories
- Prices ranging from €20 to €500
- Various stock levels

> [!NOTE]
> **_Your SQL_**
>
> ```sql
> INSERT INTO products (name, description, price, weight_kg, stock_quantity)
>     VALUES
>         ('Hiking Boots', 'Lorem ipsum dolor sit amet.', 120.00, 1.2, 50),
>         ('Trail Sandals', NULL, 69.99, 0.450, 0),
>
>         ('Samsonite Backpack', 'Lorem ipsum dolor sit amet.', 80.00, 0.8, 100),
>         ('Hydration Pack 12L', 'Lorem ipsum dolor sit amet', 89.90, 0.600, 0),
>
>         ('Double Tent', NULL, 150.00, 2.5, 30),
>         ('Ultralight Bivy Tent', 'Lorem ipsum dolor sit amet', 229.00, 1.100, 0),
>
>         ('Rain Jacket', 'Lorem ipsum dolor sit amet.', 90.00, 0.5, 75),
>         ('Thermal Base Layer Set', 'Lorem ipsum dolor sit amet', 54.95, 0.300, 0),
>
>         ('Water Bottle', NULL, 25.00, 0.3, 0),
>         ('Headlamp 400lm', NULL, 45.50, 0.090, 0);
> ```

**Product categories:**

- Insert rows into `product_categories` so every sample product is linked to at least one category

> [!NOTE]
> **_Your SQL_**
>
> ```sql
> INSERT INTO product_categories (category_id, product_id)
> SELECT category.category_id, product.product_id
> FROM categories AS category
> JOIN products AS product ON
>     category.category_name = 'Footwear'
>     AND (
>         product.name ILIKE '%sandals%'
>         OR
>         product.name ILIKE '%boots%'
>     );
>
> INSERT INTO product_categories (category_id, product_id)
> SELECT category.category_id, product.product_id
> FROM categories AS category
> JOIN products AS product
>     ON product.name ILIKE '%Backpack%'
>     OR product.name ILIKE '%Pack%'
> WHERE category.category_name = 'Backpacks';
>
> INSERT INTO product_categories (category_id, product_id)
> SELECT category.category_id, product.product_id
> FROM categories AS category
> JOIN products AS product
>     ON product.name ILIKE '%Tent%'
> WHERE category.category_name = 'Tents';
>
> INSERT INTO product_categories (category_id, product_id)
> SELECT category.category_id, product.product_id
> FROM categories AS category
> JOIN products AS product
>     ON product.name ILIKE '%Jacket%'
>     OR product.name ILIKE '%Layer set%'
> WHERE category.category_name = 'Clothing';
>
> INSERT INTO product_categories (category_id, product_id)
> SELECT category.category_id, product.product_id
> FROM categories AS category
> JOIN products AS product
>     ON product.name ILIKE '%Bottle%'
>     OR product.name ILIKE '%Headlamp%'
> WHERE category.category_name = 'Accessories';
> ```

**Orders** (at least 5):

- Different customers, different statuses

> [!NOTE]
> **_Your SQL_**
>
> ```sql
> INSERT INTO orders (status, shipping_address, customer_id)
>     VALUES
>         ('pending', 'Mikpolku 3, 50100 Mikkeli, Finland', 1),
>         ('paid', 'Satamakatu 12, 00160 Helsinki, Finland', 3),
>         ('shipped', '14 O''Connell Street, D01 Dublin, Ireland', 4),
>         ('delivered', 'Rua Augusta 500, 01304-001 São Paulo, Brazil', 5),
>         ('cancelled', NULL, 2);
> ```

**Order Items** (at least 10):

- Multiple items in some orders, single items in others

> [!NOTE]
> **_Your SQL_**
>
> ```sql
> INSERT INTO order_items (order_id, product_id, quantity, unit_price)
>     VALUES
>         (1, 1, 1, 120.00),
>         (1, 9, 2, 25.00),
>         (1, 10, 1, 45.50),
>
>         (2, 6, 1, 229.00),
>
>         (3, 3, 1, 80.00),
>         (3, 8, 2, 54.95),
>
>         (4, 5, 1, 150.00),
>         (4, 4, 1, 89.90),
>         (4, 7, 1, 90.00),
>
>         (5, 2, 1, 69.99);
> ```

**Verify** each insert with `SELECT * FROM table_name;`

### Task 1.4: Practice UPDATE

> [!TIP]
> **Recommended practice.** Do Tasks 1.4–1.6. They are not required to finish the TrailShop project. They prepare you for the exams. Task 1.6 renames `stock` to `quantity_in_stock`. Later weeks still use `stock`, so after you practice the rename, change the column name back.

Perform the following updates and verify each one:

1. Increase the price of all products in the Footwear category by 10% (join through `product_categories`)
2. Change customer #3's email to a new address
3. Update the status of order #2 from 'shipped' to 'delivered'
4. Set the stock of 'HydroFlask 1L' to 85
5. Add a description to any product that currently has NULL in description

> [!NOTE]
> **_Your SQL_**
>
> ```sql
> -- Write your queries here
>
>
> ```

### Task 1.5: Practice DELETE

1. Delete the most recently created order (and observe what happens to its order_items if you used CASCADE)
2. Try to delete a product that appears in `order_items` — what error do you get?
3. Delete a category that has products linked through `product_categories`. The products should remain; only the link rows should disappear. Confirm this.
4. Delete a customer who has no orders

### Task 1.6: Practice ALTER TABLE

1. Add a column `phone VARCHAR(20)` to the customers table
2. Add a column `weight_grams INTEGER` to the products table
3. Add a CHECK constraint to ensure `weight_grams > 0` (allow NULL though — not all products have weight recorded yet)
4. Rename the `stock` column in products to `quantity_in_stock`

> [!NOTE]
> **_Your SQL_**
>
> ```sql
> -- Write your queries here
>
>
> ```

---

## Exercise 2: Theory Review Questions

Answer the following questions in your own words using the answer fields below:

1. What does SQL stand for, and why was the language designed to look like English?

> [!NOTE]
> SQL - stand for structured query language.
> SQL was designed for readability and that non programmer's could understand

2. Explain the difference between DDL and DML. Give two example commands for each.

> [!NOTE]
> DDL used for defining database structure ,while DML used to manipulate data inside tables.
> DDL: ALTER TABLLE used to modify table structure. DML: INSERT INTO used to add new rows for a table.
> DDL: DROP TABLE used to remove a table. DML: DELETE used to remove row from a table.

3. What is the difference between DCL and TCL? When would you use each?

> [!NOTE]
> DCL manage permissions and TCL manage transactions. DCL we used to manage access for users inside database. TCL we use to manage ,that if transaction fails to rollback.

4. Why must you create tables in a specific order? What determines that order?

> [!NOTE]
> Tables must be created in dependency order ,because a foreign key references a table that must already exist. If we try to create order_items before orders and products ,postgres gives error that relation does not exist. The order is determined by foreign keys - tables without dependencies first ,then the tables that reference them.

5. What is the difference between a column-level constraint and a table-level constraint? When _must_ you use a table-level constraint?

> [!NOTE]
> Column-level constraint is written right after the columns data type and applies only to that one column. Table-level constraint is written after all columns and can reference multiple columns. We must use table-level when constraint involves more than one column ,like composite primary key or check that compares two columns.

6. Explain the difference between `DELETE FROM products;` and `TRUNCATE TABLE products;`. When would you prefer each?

> [!NOTE]
> Both remove all rows but DELETE works row by row ,is slower and fires triggers ,while TRUNCATE removes everything instantly and can also reset serial with RESTART IDENTITY. I prefer TRUNCATE when testing and I want to empty the table fast ,and DELETE when I need to remove only specific rows with WHERE.

7. What does `ON DELETE CASCADE` do on a foreign key? Give a real-world scenario where it's appropriate and one where it would be dangerous.

> [!NOTE]
> ON DELETE CASCADE automatically deletes all child rows when the parent row is deleted. It is appropriate for order_items ,because items have no meaning without their order. It would be dangerous on customers to orders ,because deleting one customer would silently erase the whole order history which is needed for accounting.

8. Why should you store `unit_price` in the `order_items` table instead of just looking it up from the `products` table?

> [!NOTE]
> Because product prices change over time. If we only looked up the current price from products ,old orders would show wrong totals after a price update. Storing unit_price in order_items preserves the historical price the customer actually paid at the moment of purchase.

9. What is the difference between SERIAL and GENERATED ALWAYS AS IDENTITY? Which would you use in a new project and why?

> [!NOTE]
> SERIAL is postgresql-specific shorthand that creates a sequence and sets it as default ,but it can be overridden accidentally by manual inserts. GENERATED ALWAYS AS IDENTITY is the SQL standard way and blocks manual values unless you explicitly override. For a new project I would use identity ,because its the standard and safer.

10. Explain why `UPDATE products SET price = 9.99;` is dangerous. What steps should you take before running any UPDATE statement?

> [!NOTE]
> Because there is no WHERE clause ,so it updates every single row in the table and sets all prices to 9.99. Before running UPDATE I would write the WHERE first ,run a SELECT with the same condition to check which rows are affected ,and wrap it in a transaction so I can ROLLBACK if something goes wrong.

---

## Exercise 3: SQL Writing Exercises (Optional)

> [!TIP]
> **Recommended practice.** Do this section. It is not required to finish the TrailShop project. It prepares you for the exams.

Write the SQL statements for each task in the **Your SQL** fields below. Verify by running them when ready.

### 3.1 CREATE TABLE

Write a CREATE TABLE statement for a `suppliers` table with the following columns:

- supplier_id (auto-incrementing primary key)
- company_name (required, max 200 characters, must be unique)
- contact_name (max 150 characters)
- email (max 255 characters, required, unique)
- phone (max 20 characters)
- country (max 100 characters, required, default 'Finland')

> [!NOTE]
> **_Your SQL_**
>
> ```sql
> -- Write your query here
>
>
> ```

### 3.2 CREATE TABLE with Foreign Key

Write a CREATE TABLE statement for a `product_reviews` table:

- review_id (auto-incrementing primary key)
- product_id (required, references products)
- customer_id (required, references customers)
- rating (required integer, must be between 1 and 5 inclusive)
- review_text (optional, unlimited length)
- created_at (required, defaults to current timestamp)

> [!NOTE]
> **_Your SQL_**
>
> ```sql
> -- Write your query here
>
>
> ```

### 3.3 INSERT — Single Row

Write an INSERT statement to add a new category called 'Electronics' with description 'GPS devices, solar chargers, and tech gear'.

> [!NOTE]
> **_Your SQL_**
>
> ```sql
> -- Write your query here
>
>
> ```

### 3.4 INSERT — Multiple Rows

Write a single INSERT statement that adds three new customers:

- Eero Lahtinen, eero.l@email.com
- Maria Salminen, maria.s@email.com
- Petri Kallio, petri.k@email.com

> [!NOTE]
> **_Your SQL_**
>
> ```sql
> -- Write your query here
>
>
> ```

### 3.5 INSERT with RETURNING

Write an INSERT statement that adds a new product called 'NorthStar GPS' priced at €229.99 with stock of 12, then assign it to category 'Electronics' (assume `category_id = 6`) using `product_categories`. Return the product_id and created_at.

> [!NOTE]
> **_Your SQL_**
>
> ```sql
> -- Write your query here
>
>
> ```

### 3.6 UPDATE — Simple

Write an UPDATE statement that changes the email of the customer with customer_id = 2 to 'mikko.korhonen@newmail.com'.

> [!NOTE]
> **_Your SQL_**
>
> ```sql
> -- Write your query here
>
>
> ```

### 3.7 UPDATE — Expression

Write an UPDATE statement that reduces the stock of all products by 1 where the stock is currently greater than 0.

> [!NOTE]
> **_Your SQL_**
>
> ```sql
> -- Write your query here
>
>
> ```

### 3.8 UPDATE — Multiple Columns

Write an UPDATE statement that changes order #3 to status 'cancelled' and sets a (hypothetical) cancelled_at timestamp to the current time. (Assume you've already added a cancelled_at column.)

> [!NOTE]
> **_Your SQL_**
>
> ```sql
> -- Write your query here
>
>
> ```

### 3.9 DELETE — With Condition

Write a DELETE statement that removes all orders with status 'cancelled'.

> [!NOTE]
> **_Your SQL_**
>
> ```sql
> -- Write your query here
>
>
> ```

### 3.10 ALTER TABLE

Write the ALTER TABLE statements to:
a) Add a `discount_percent NUMERIC(5,2) DEFAULT 0 CHECK (discount_percent >= 0 AND discount_percent <= 100)` column to products
b) Drop the `description` column from categories
c) Add a composite unique constraint on (customer_id, product_id) in the product_reviews table (preventing a customer from reviewing the same product twice)

> [!NOTE]
> **_Your SQL_**
>
> ```sql
> -- Write your query here
>
>
> ```

---

## Exercise 4: Error Diagnosis (Optional)

> [!TIP]
> **Recommended practice.** Do this section. It is not required to finish the TrailShop project. It prepares you for the exams.

Each of the following SQL statements contains one or more errors. Identify the error(s) and write the corrected version.

### 4.1

```sql
CREATE TABLE warehouses
    warehouse_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    city VARCHAR(100
);
```

> [!NOTE]
> **_Error(s) Identified_**
>
> _(Describe what is wrong.)_

> [!NOTE]
> **_Corrected SQL_**
>
> ```sql
> -- Write the corrected statement here
>
>
> ```

### 4.2

```sql
INSERT INTO products (name, price, stock)
VALUES ("Alpine Sleeping Bag", 89.99, 20);
```

> [!NOTE]
> **_Error(s) Identified_**
>
> _(Describe what is wrong.)_

> [!NOTE]
> **_Corrected SQL_**
>
> ```sql
> -- Write the corrected statement here
>
>
> ```

### 4.3

```sql
CREATE TABLE shipments (
    shipment_id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES orders(order_id)
    shipped_date DATE NOT NULL,
    carrier VARCHAR(100)
);
```

> [!NOTE]
> **_Error(s) Identified_**
>
> _(Describe what is wrong.)_

> [!NOTE]
> **_Corrected SQL_**
>
> ```sql
> -- Write the corrected statement here
>
>
> ```

### 4.4

```sql
UPDATE products
SET price = price * 0.9
SET stock = stock + 10
WHERE product_id = 3;
```

> [!NOTE]
> **_Error(s) Identified_**
>
> _(Describe what is wrong.)_

> [!NOTE]
> **_Corrected SQL_**
>
> ```sql
> -- Write the corrected statement here
>
>
> ```

### 4.5

```sql
CREATE TABLE wishlists (
    wishlist_id SERIAL PRIMARY KEY,
    customer_id INTEGER NOT NULL REFERENCES customers(customer_id),
    product_id INTEGER NOT NULL REFERENCES products(product_id),
    added_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (customer_id, product_id)
);
```

> [!NOTE]
> **_Error(s) Identified_**
>
> _(Describe what is wrong.)_

> [!NOTE]
> **_Corrected SQL_**
>
> ```sql
> -- Write the corrected statement here
>
>
> ```

---

## Submission Checklist

**Required**

- [ ] All 6 TrailShop tables created successfully
- [ ] Sample data inserted (at least 5 categories, 5 customers, 10 products, product_categories links, 5 orders, 10 order items)
- [ ] Theory review questions answered

**Recommended practice**

- [ ] UPDATE exercises completed and verified
- [ ] DELETE exercises completed and verified
- [ ] ALTER TABLE exercises completed, then `quantity_in_stock` renamed back to `stock`
- [ ] SQL writing exercises completed
- [ ] Error diagnosis completed with corrections

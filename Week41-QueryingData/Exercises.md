# Week 41 — Exercises: Querying Data

> [!IMPORTANT]
> **_How to Complete These Exercises_**
> Write your answers directly in the highlighted **Your Answer** / **Your SQL** fields below each task. Replace the placeholder text with your own work before submitting.

## Exercise 1: TrailShop Project Task — Business Questions

Use the TrailShop database you created in Week 40. Write SQL queries to answer each business question below. Run each query and verify the results make sense.

> [!IMPORTANT]
> **_Tools to use_**
> You can use both the pgAdmin or psql (terminal) to test the queries

### Basic Queries (SELECT + WHERE)

1. List all products in the 'Footwear' category (show name, price, stock).

   > [!NOTE]
   > **_Your SQL_**
   >
   > ```sql
   > SELECT DISTINCT p.*
   > FROM products as p
   > JOIN product_categories as pc
   > ON pc.product_id = p.product_id
   > JOIN categories as c
   > ON pc.category_id = c.category_id
   > WHERE c.category_name = 'Footwear';
   > ```

2. Find all products priced between €50 and €150, sorted by price ascending.

   > [!NOTE]
   > **_Your SQL_**
   >
   > ```sql
   > SELECT * FROM products
   > WHERE price >= 50 OR price <= 150
   > ORDER BY price ASC;
   >
   > ```

3. Show all customers whose last name starts with the letter 'M' or 'K'.

   > [!NOTE]
   > **_Your SQL_**
   >
   > ```sql
   > SELECT * FROM customers
   > WHERE last_name ILIKE 'M%' OR last_name ILIKE 'K%';
   >
   > ```

4. List all orders with status 'pending' or 'shipped', sorted by order date (most recent first).

   > [!NOTE]
   > **_Your SQL_**
   >
   > ```sql
   > SELECT * FROM orders
   > WHERE status IN ('pending', 'shipped')
   > ORDER BY order_date DESC;
   > ```

5. Find all products that have the word 'Pro' or 'pro' somewhere in their name.
   > [!NOTE]
   > **_Your SQL_**
   >
   > ```sql
   > SELECT * FROM products
   > WHERE name ILIKE '%pro%';
   >
   > ```

### Aggregate Queries

6. What is the total number of products in the database?

> [!NOTE]
> **_Your SQL_**
>
> ```sql
>  SELECT COUNT(*)
> FROM products;
>
> ```

7. What is the average price of all products? Round to 2 decimal places.

   > [!NOTE]
   > **_Your SQL_**
   >
   > ```sql
   > SELECT ROUND(AVG(price), 2)
   > FROM products;
   >
   > ```

8. Which is the most expensive product and which is the cheapest? Show both in one query.

   > [!NOTE]
   > **_Your SQL_**
   >
   > ```sql
   > SELECT 
   > MIN(price) as smallest_price,
   > MAX(price) as biggest_price
   > FROM products;
   >
   > ```

9. How many orders does each customer have? Show customer name and order count, sorted by count descending.

   > [!NOTE]
   > **_Your SQL_**
   >
   > ```sql
   > SELECT
   > c.first_name || ' ' || c.last_name AS customer_name,
   > COUNT(o.order_id) AS order_count
   > from customers AS c
   > LEFT JOIN orders AS o
   > ON o.customer_id = c.customer_id
   > GROUP BY
   > c.customer_id,
   > c.first_name,
   > c.last_name
   > ORDER BY order_count DESC;
   > ```

10. What is the total revenue (sum of quantity × unit_price from order_items) for each order status?

> [!NOTE]
> **_Your SQL_**
>
> ```sql
> SELECT
> o.status,
> SUM(item.quantity * item.unit_price) AS total_revenue
> FROM orders AS o
> JOIN order_items as item
> ON
> o.order_id = item.order_id
> GROUP BY o.status
> ORDER BY total_revenue DESC;
> ```

### JOIN Queries

11. List all products with their category names (join through `product_categories`). A product in two categories should appear twice. Sort by category name, then product name.

    > [!NOTE]
    > **_Your SQL_**
    >
    > ```sql
   > SELECT
   >     p.product_id,
   >     p.name AS product_name,
   >     c.category_name as category_name
   > FROM products AS p
   > JOIN product_categories AS pc
   >     ON pc.product_id = p.product_id
   > JOIN categories AS c
   >     ON pc.category_id = c.category_id
   > ORDER BY category_name, product_name;
    > ```

12. Show each order with the customer's full name, order date, and status.

    > [!NOTE]
    > **_Your SQL_**
    >
    > ```sql
   > SELECT
   > c.first_name || ' ' || c.last_name AS full_name,
   > o.order_date AS order_date,
   > o.status AS order_status
   > FROM customers AS c
   > JOIN orders AS o
   > ON
   > o.customer_id = c.customer_id;
    > ```

13. Show a detailed breakdown of order #1: product name, quantity, unit price, and line total.

    > [!NOTE]
    > **_Your SQL_**
    >
    > ```sql
    > SELECT 
    > p.name AS product_name,
    > SUM(oi.quantity * oi.unit_price) AS total
    > FROM order_items AS oi
    > JOIN products AS p
    > ON oi.product_id = p.product_id
    > WHERE oi.order_id = 1
    > GROUP BY p.name;
    >
    >
    > ```

14. Find all customers who have NOT placed any orders. (Hint: use LEFT JOIN + IS NULL pattern.)

    > [!NOTE]
    > **_Your SQL_**
    >
    > ```sql
    > SELECT
    > c.customer_id,
    > c.first_name || ' ' || c.last_name AS full_name
    > FROM customers AS c
    > WHERE NOT EXISTS
    > (SELECT *
    > FROM orders
    > WHERE c.customer_id = orders.customer_id);
    >
    > ```

15. For each category, show the category name, number of products, average price, and total inventory value (price × stock summed). Only include categories with total inventory value greater than €500.
    > [!NOTE]
    > **_Your SQL_**
    >
    > ```sql
   > SELECT 
   >  c.category_id,
   >  c.category_name,
   >  COUNT(p) AS products,
   >  ROUND(AVG(p.price), 2) AS average_price,
   >  SUM(p.price * p.stock_quantity) AS inventory_value
   > FROM categories as c
   > JOIN product_categories as pc
   > ON pc.category_id = c.category_id
   > JOIN products as p
   > ON pc.product_id = p.product_id
   > GROUP BY
   > c.category_id,
   > c.category_name
   > HAVING SUM(p.price * p.stock_quantity) > 500;
    > ```

---

## Exercise 2: Theory Review Questions

Answer in your own words:

1. What is the logical execution order of a SQL query? Why does it matter?

> [!NOTE]
> **_Your Answer_**
>
> SQL does not execute in the same order we usually write the statements. The logical order is:
>
> 1. FROM — choose the table(s) involved.
> 2. WHERE — filter individual rows before grouping.
> 3. GROUP BY — group rows with the same values.
> 4. HAVING — filter groups after aggregation.
> 5. SELECT — choose the columns and calculate expressions.
> 6. ORDER BY — sort the final result.
> 7. LIMIT — restrict how many rows are returned.
>
> This matters because it explains why you cannot use an alias created in SELECT in WHERE, and why HAVING is used only after GROUP BY.

2. What is the difference between WHERE and HAVING? Give an example of when you would use each.

> [!NOTE]
> **_Your Answer_**
>
> WHERE filters rows before aggregation. It is used with normal SELECT queries and works on individual records.
>
> Example:
>
> ```sql
> SELECT *
> FROM products
> WHERE price > 100;
> ```
>
> This returns only products whose price is greater than 100.
>
> HAVING filters groups after aggregation, so it is used together with GROUP BY.
>
> Example:
>
> ```sql
> SELECT category_id, COUNT(*) AS number_of_products
> FROM products
> GROUP BY category_id
> HAVING COUNT(*) > 5;
> ```
>
> This shows only categories that contain more than 5 products. In other words, WHERE filters rows, while HAVING filters grouped results.

3. Explain the difference between COUNT(\*), COUNT(column), and COUNT(DISTINCT column).

> [!NOTE]
> **_Your Answer_**
> 1 - Number of rows, 2- number of rows that has not null column specified, 3- number of distinct rows that has columns not null.

4. What is the difference between INNER JOIN and LEFT JOIN? When would you choose one over the other?

> [!NOTE]
> **_Your Answer_**
>
> An `INNER JOIN` returns only rows where there is a matching value in both tables. Use it when you only want records that are related in both tables. For example, this lists only customers who have placed an order:
>
> ```sql
> SELECT c.first_name, c.last_name, o.order_id
> FROM customers AS c
> INNER JOIN orders AS o
>     ON o.customer_id = c.customer_id;
> ```
>
> A `LEFT JOIN` returns every row from the table on the left, including rows with no match in the right table. The right table's columns are `NULL` when there is no match. Use it when you need to keep all records from the left table, such as finding customers who have not placed any orders:
>
> ```sql
> SELECT c.first_name, c.last_name
> FROM customers AS c
> LEFT JOIN orders AS o
>     ON o.customer_id = c.customer_id
> WHERE o.order_id IS NULL;
> ```
>
> In short, choose INNER JOIN for matching records only, and LEFT JOIN when all records from the left table must be included.

5. Why should you avoid SELECT \* in production code?

> [!NOTE]
> **_Your Answer_**
>
> If columns are added/removed, query returns different results.
> More data transfered than needed.
> It makes code harder to understand.

6. What does DISTINCT do? On what level does it operate (columns or entire rows)?

> [!NOTE]
> **_Your Answer_**
> DISTINTC remove duplicated rows. It operates for entire rows

7. Can you use a column alias in a WHERE clause? Why or why not?

> [!NOTE]
> **_Your Answer_**
>
> You can not use alias inside WHERE clause, due tue sql logical execution order.
>
> 8. Explain what happens when you GROUP BY a column and there's a column in SELECT that isn't aggregated and isn't in GROUP BY.

> [!NOTE]
> **_Your Answer_**
>
> SQL returns an error because it cannot determine which value to show for that column within each group.

---

## Exercise 3: Query Writing Exercises (Optional)

> [!TIP]
> **Recommended practice.** Do this section. It is not required to finish the TrailShop project. It prepares you for the exams.

Write the SQL for each task. Use the TrailShop schema (categories, customers, products, product_categories, orders, order_items).

### Simple SELECT + WHERE

**3.1** — Select product names and prices for all products with stock less than 15.

> [!NOTE]
> **_Your SQL_**
>
> ```sql
> -- Write your query here
>
>
> ```

**3.2** — Find all customers who registered (created_at) in 2026. Show first name, last name, and registration date.

> [!NOTE]
> **_Your SQL_**
>
> ```sql
> -- Write your query here
>
>
> ```

**3.3** — Show all products that do NOT have a description (description IS NULL).

> [!NOTE]
> **_Your SQL_**
>
> ```sql
> -- Write your query here
>
>
> ```

### Multi-condition Filtering

**3.4** — Find products in category 1 OR category 2, priced above €100, with stock greater than 0. Sort by price descending.

> [!NOTE]
> **_Your SQL_**
>
> ```sql
> -- Write your query here
>
>
> ```

**3.5** — Find orders that are either 'delivered' or placed by customer_id 1. Show order_id, customer_id, status.

> [!NOTE]
> **_Your SQL_**
>
> ```sql
> -- Write your query here
>
>
> ```

### Aggregation

**3.6** — For each category, show the category name, minimum, maximum, and average product price. Round averages to 2 decimal places. Join through `product_categories`.

> [!NOTE]
> **_Your SQL_**
>
> ```sql
> -- Write your query here
>
>
> ```

**3.7** — Count how many distinct customers have placed at least one order.

> [!NOTE]
> **_Your SQL_**
>
> ```sql
> -- Write your query here
>
>
> ```

**3.8** — Find the total quantity of items sold across all orders.

> [!NOTE]
> **_Your SQL_**
>
> ```sql
> -- Write your query here
>
>
> ```

### JOIN Queries

**3.9** — Show each product name alongside its category name. Include all products (even if somehow a category was deleted — use LEFT JOIN).

> [!NOTE]
> **_Your SQL_**
>
> ```sql
> -- Write your query here
>
>
> ```

**3.10** — List all orders showing: order_id, customer full name, order date, number of items in the order, and order total cost.

> [!NOTE]
> **_Your SQL_**
>
> ```sql
> -- Write your query here
>
>
> ```

**3.11** — Show all products that have NEVER been ordered. (Hint: LEFT JOIN order_items, then IS NULL on order_item_id.)

> [!NOTE]
> **_Your SQL_**
>
> ```sql
> -- Write your query here
>
>
> ```

### GROUP BY + HAVING

**3.12** — Show categories where the average product price exceeds €100. Display category name and average price.

> [!NOTE]
> **_Your SQL_**
>
> ```sql
> -- Write your query here
>
>
> ```

**3.13** — Find customers who have placed more than 1 order. Show their name and order count.

> [!NOTE]
> **_Your SQL_**
>
> ```sql
> -- Write your query here
>
>
> ```

### Pagination

**3.14** — Write a paginated query that returns products 4 through 6 (page 2, page size 3), ordered by product_id.

> [!NOTE]
> **_Your SQL_**
>
> ```sql
> -- Write your query here
>
>
> ```

### Complex

**3.15** — Write a "sales report" query that shows: category name, total units sold (from order_items), total revenue, and number of distinct products sold — for each category. Sort by revenue descending.

> [!NOTE]
> **_Your SQL_**
>
> ```sql
> -- Write your query here
>
>
> ```

---

## Exercise 4: Query Reading Exercise (Optional)

> [!TIP]
> **Recommended practice.** Do this section. It is not required to finish the TrailShop project. It prepares you for the exams.

For each query below, explain in **plain English** what it does and what the result would look like.

### 4.1

```sql
SELECT c.name, COUNT(p.product_id) AS num_products
FROM categories c
LEFT JOIN product_categories pc ON pc.category_id = c.category_id
LEFT JOIN products p ON p.product_id = pc.product_id
GROUP BY c.name
ORDER BY num_products DESC;
```

> [!NOTE]
> **_Error(s) Identified_**
>
> _(Describe what is wrong.)_
>
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
SELECT first_name, last_name
FROM customers
WHERE customer_id NOT IN (
    SELECT DISTINCT customer_id FROM orders
);
```

> [!NOTE]
> **_Error(s) Identified_**
>
> _(Describe what is wrong.)_
>
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
SELECT p.name, p.price, p.stock,
       p.price * p.stock AS inventory_value
FROM products p
WHERE p.stock > 0
ORDER BY inventory_value DESC
LIMIT 3;
```

> [!NOTE]
> **_Error(s) Identified_**
>
> _(Describe what is wrong.)_
>
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
SELECT o.order_id,
       SUM(oi.quantity * oi.unit_price) AS order_total
FROM orders o
INNER JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status <> 'cancelled'
GROUP BY o.order_id
HAVING SUM(oi.quantity * oi.unit_price) > 200
ORDER BY order_total DESC;
```

> [!NOTE]
> **_Error(s) Identified_**
>
> _(Describe what is wrong.)_
>
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
SELECT c.first_name || ' ' || c.last_name AS customer,
       COUNT(DISTINCT o.order_id) AS num_orders,
       SUM(oi.quantity) AS total_items,
       ROUND(SUM(oi.quantity * oi.unit_price), 2) AS total_spent
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
LEFT JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC NULLS LAST;
```

> [!NOTE]
> **_Error(s) Identified_**
>
> _(Describe what is wrong.)_
>
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

- [X] All 15 business questions answered with working SQL
- [X] Theory review questions answered in your own words
- [X] Results of the business questions verified by running them against your TrailShop database

**Recommended practice**

- [ ] All 15 query writing exercises completed
- [ ] All 5 query reading explanations written

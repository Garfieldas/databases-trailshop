# Week 44 — Advanced SQL: Exercises

> [!IMPORTANT]
> **_How to Complete These Exercises_**
> Write your answers directly in the highlighted **Your Answer** / **Your SQL** fields below each task. Replace the placeholder text with your own work before submitting.

---

## 1. TrailShop Project Task

Continue building the TrailShop database. This week, use advanced query techniques to extract meaningful insights.

### Task 1.1: Subqueries

Write the following queries using subqueries:

1. Find all products priced above the average price (use a scalar subquery).
   > [!NOTE]
   > **_Your SQL_**
   >
   > ```sql
   > SELECT *
   > FROM products
   > WHERE
   > price > (SELECT AVG(price) FROM products);
   > ```
2. Find all customers who have placed more than 2 orders (use a subquery in WHERE with IN).
   > [!NOTE]
   > **_Your SQL_**
   >
   > ```sql
   > SELECT first_name, last_name
   > FROM customers
   > WHERE customer_id IN (
   >     SELECT customer_id
   >     FROM orders
   >     GROUP BY customer_id
   >     HAVING COUNT(*) > 2
   > );
   > ```
3. Show each product's name, price, and how much it differs from its category's average price (use a correlated subquery or derived table).
   > [!NOTE]
   > **_Your SQL_**
   >
   > ```sql
   > SELECT
   >     p.name,
   >     p.price,
   >     p.price - (
   >         SELECT AVG(p2.price)
   >         FROM products AS p2
   >         JOIN product_categories AS pc2
   >             ON pc2.product_id = p2.product_id
   >         WHERE pc2.category_id = pc.category_id
   >     ) AS difference_from_category_average
   > FROM products AS p
   > JOIN product_categories AS pc
   >     ON pc.product_id = p.product_id;
   > ```

### Task 1.2: EXISTS

1. Use `EXISTS` to find all customers who have ordered at least one product from the "Footwear" category.
   > [!NOTE]
   > **_Your SQL_**
   >
   > ```sql
   > SELECT c.first_name, c.last_name
   > FROM customers AS c
   > WHERE EXISTS (
   >     SELECT 1
   >     FROM orders AS o
   >     JOIN order_items AS oi
   >         ON oi.order_id = o.order_id
   >     JOIN product_categories AS pc
   >         ON pc.product_id = oi.product_id
   >     JOIN categories AS cat
   >         ON cat.category_id = pc.category_id
   >     WHERE o.customer_id = c.customer_id
   >     AND cat.category_name = 'Footwear'
   > );
   > ```
2. Use `NOT EXISTS` to find all products that have never been ordered.
   > [!NOTE]
   > **_Your SQL_**
   >
   > ```sql
   > SELECT p.name
   > FROM products AS p
   > WHERE NOT EXISTS (
   >     SELECT 1
   >     FROM order_items AS oi
   >     WHERE oi.product_id = p.product_id
   > );
   > ```

### Task 1.3: CASE Expressions

1. Add a `price_tier` column to a product query that labels products as 'Budget' (< €25), 'Standard' (€25–€74.99), or 'Premium' (≥ €75).
   > [!NOTE]
   > **_Your SQL_**
   >
   > ```sql
   > SELECT
   >     name,
   >     price,
   >     CASE
   >         WHEN price < 25 THEN 'Budget'
   >         WHEN price < 75 THEN 'Standard'
   >         ELSE 'Premium'
   >     END AS price_tier
   > FROM products;
   > ```
2. Write a query that counts orders by status using CASE inside COUNT.
   > [!NOTE]
   > **_Your SQL_**
   >
   > ```sql
   > SELECT
   >     COUNT(CASE WHEN status = 'pending' THEN 1 END) AS pending,
   >     COUNT(CASE WHEN status = 'paid' THEN 1 END) AS paid,
   >     COUNT(CASE WHEN status = 'shipped' THEN 1 END) AS shipped,
   >     COUNT(CASE WHEN status = 'delivered' THEN 1 END) AS delivered,
   >     COUNT(CASE WHEN status = 'cancelled' THEN 1 END) AS cancelled
   > FROM orders;
   > ```

### Task 1.4: Create Three Views

Create the following views in your TrailShop database:

1. `v_product_catalog` — Shows product name, category name, price, and stock status ('In Stock', 'Low Stock' for < 5 units, 'Out of Stock' for 0). Join through `product_categories`. A product in two categories may appear twice (once per category).
2. `v_customer_summary` — Shows each customer's full name, email, number of orders, and total spent.
3. `v_monthly_revenue` — Shows revenue grouped by month.

Verify each view works with a simple SELECT.

> [!NOTE]
> **_Your SQL_**
>
> ```sql
> CREATE OR REPLACE VIEW v_product_catalog AS
> SELECT
>     p.name AS product_name,
>     c.category_name,
>     p.price,
>     CASE
>         WHEN p.stock_quantity = 0 THEN 'Out of Stock'
>         WHEN p.stock_quantity < 5 THEN 'Low Stock'
>         ELSE 'In Stock'
>     END AS stock_status
> FROM products AS p
> JOIN product_categories AS pc
>     ON pc.product_id = p.product_id
> JOIN categories AS c
>     ON c.category_id = pc.category_id;
>
> SELECT *
> FROM v_product_catalog;
>
> CREATE OR REPLACE VIEW v_customer_summary AS
> SELECT
>     c.first_name || ' ' || c.last_name AS full_name,
>     c.email,
>     COUNT(DISTINCT o.order_id) AS number_of_orders,
>     COALESCE(SUM(oi.quantity * oi.unit_price), 0) AS total_spent
> FROM customers AS c
> LEFT JOIN orders AS o
>     ON o.customer_id = c.customer_id
> LEFT JOIN order_items AS oi
>     ON oi.order_id = o.order_id
> GROUP BY c.customer_id, c.first_name, c.last_name, c.email;
>
> SELECT *
> FROM v_customer_summary;
>
> CREATE OR REPLACE VIEW v_monthly_revenue AS
> SELECT
>     DATE_TRUNC('month', o.order_date) AS month,
>     SUM(oi.quantity * oi.unit_price) AS total_revenue
> FROM orders AS o
> JOIN order_items AS oi
>     ON oi.order_id = o.order_id
> GROUP BY DATE_TRUNC('month', o.order_date);
>
> SELECT *
> FROM v_monthly_revenue;
> ```

### Task 1.5: UNION

1. Write a UNION query that combines product names from two different categories into one list (without duplicates).
   > [!NOTE]
   > **_Your SQL_**
   >
   > ```sql
   > SELECT p.name
   > FROM products AS p
   > JOIN product_categories AS pc
   >     ON pc.product_id = p.product_id
   > JOIN categories AS c
   >     ON c.category_id = pc.category_id
   > WHERE c.category_name = 'Footwear'
   > UNION
   > SELECT p.name
   > FROM products AS p
   > JOIN product_categories AS pc
   >     ON pc.product_id = p.product_id
   > JOIN categories AS c
   >     ON c.category_id = pc.category_id
   > WHERE c.category_name = 'Accessories';
   > ```
2. Write a query using EXCEPT to find categories that have products but no orders.
   > [!NOTE]
   > **_Your SQL_**
   >
   > ```sql
   > WITH categories_with_products AS (
   >     SELECT DISTINCT category_id
   >     FROM product_categories
   > ),
   > categories_with_orders AS (
   >     SELECT DISTINCT pc.category_id
   >     FROM order_items AS oi
   >     JOIN product_categories AS pc
   >         ON pc.product_id = oi.product_id
   > )
   > SELECT c.category_name
   > FROM categories AS c
   > WHERE c.category_id IN (
   >     SELECT category_id
   >     FROM categories_with_products
   >     EXCEPT
   >     SELECT category_id
   >     FROM categories_with_orders
   > );
   > ```

### Task 1.6: CTE

1. Write a CTE that calculates total revenue per category, then use it to find categories with above-average revenue.
   > [!NOTE]
   > **_Your SQL_**
   >
   > ```sql
   > WITH category_revenue AS (
   >     SELECT
   >         c.category_id,
   >         c.category_name,
   >         SUM(oi.quantity * oi.unit_price) AS total_revenue
   >     FROM categories AS c
   >     JOIN product_categories AS pc
   >         ON pc.category_id = c.category_id
   >     JOIN order_items AS oi
   >         ON oi.product_id = pc.product_id
   >     GROUP BY c.category_id, c.category_name
   > )
   > SELECT *
   > FROM category_revenue
   > WHERE total_revenue > (
   >     SELECT AVG(total_revenue)
   >     FROM category_revenue
   > );
   > ```
2. Write a query with two CTEs: one for customer order counts, another for average order count, then find "top customers" (above average).
   > [!NOTE]
   > **_Your SQL_**
   >
   > ```sql
   > WITH customer_order_counts AS (
   >     SELECT
   >         c.customer_id,
   >         c.first_name,
   >         c.last_name,
   >         COUNT(o.order_id) AS order_count
   >     FROM customers AS c
   >     LEFT JOIN orders AS o
   >         ON o.customer_id = c.customer_id
   >     GROUP BY c.customer_id, c.first_name, c.last_name
   > ),
   > average_order_count AS (
   >     SELECT AVG(order_count) AS average_orders
   >     FROM customer_order_counts
   > )
   > SELECT coc.*
   > FROM customer_order_counts AS coc
   > CROSS JOIN average_order_count AS aoc
   > WHERE coc.order_count > aoc.average_orders;
   > ```

---

## 2. Theory Review Questions

Answer these in your own words (2–4 sentences each):

1. What is the difference between an INNER JOIN and a LEFT JOIN? When would you choose LEFT JOIN?

> [!NOTE]
> **_Your Answer_**
> Inner join returns only matching rows from both sides. Left join returns all rows from left side and any matching rows from left side.
> Use inner join when we want to only find matching from both tables. Use lefft join when we need to see both table info even thougt on right side it will be empty.
> _(Write your answer here.)_

2. Explain what a correlated subquery is. Why can it be slower than an uncorrelated subquery?

> [!NOTE]
> **_Your Answer_**
>
> _(Write your answer here.)_

3. What is the difference between `IN` and `EXISTS`? When might you prefer EXISTS?

> [!NOTE]
> **_Your Answer_**
>
> IN do a lookup between column values choices,while exists searches for True or False by finding entire row matching criteria.
4. What rules must two SELECT statements follow to be combined with UNION?

> [!NOTE]
> **_Your Answer_**
>
> Both Select statements must return same number of columns. Have compatible data types.

5. Explain the difference between UNION and UNION ALL. When would you use each?

> [!NOTE]
> **_Your Answer_**
>
> Union find all results and remove duplicates. Union ALL find all results and keep duplicates. We use UNION ALL when we need dupliocates and Union when we not need them.

6. What is a view? Name two advantages of using views.

> [!NOTE]
> **_Your Answer_**
>
> A view is a named query stored in a database. Views removes abstraction by allowing to write complex query just once and keeping it. More over it provides consistency so that everyone can use a same business logic.
>
> 7. What does `WITH CHECK OPTION` do on an updatable view?

> [!NOTE]
> **_Your Answer_**
>
> Prevents INSERT/UPDATE through a view if the new row wouldn't be visible through the view.

8. How does a CTE differ from a derived table (subquery in FROM)? What's the main advantage of CTEs?

> [!NOTE]
> **_Your Answer_**
>
> A CTE is a named temporary result set available within a single SQL statement. A derived table is a subquery used in the FROM clause. CTEs often make complex queries easier to read and explain.

---

## 3. Query Writing Exercises (Optional)

> [!TIP]
> **Recommended practice.** Do this section. It is not required to finish the TrailShop project. It prepares you for the exams.

Write SQL queries for the following (use the TrailShop schema):

1. Find the most expensive product in each category using a correlated subquery.
   > [!NOTE]
   > **_Your SQL_**
   >
   > ```sql
   > -- Write your query here
   >
   >
   > ```
2. List all customers along with their most recent order date. Include customers who have never ordered (show NULL).
   > [!NOTE]
   > **_Your SQL_**
   >
   > ```sql
   > -- Write your query here
   >
   >
   > ```
3. Find categories where the total revenue exceeds €500 (use a subquery or CTE).
   > [!NOTE]
   > **_Your SQL_**
   >
   > ```sql
   > -- Write your query here
   >
   >
   > ```
4. Write a query that shows each order's total and whether it's 'Small' (< €50), 'Medium' (€50–€149.99), or 'Large' (≥ €150).
   > [!NOTE]
   > **_Your SQL_**
   >
   > ```sql
   > -- Write your query here
   >
   >
   > ```
5. Create a view called `v_never_ordered` that shows products that have never appeared in an order_item.
   > [!NOTE]
   > **_Your SQL_**
   >
   > ```sql
   > -- Write your query here
   >
   >
   > ```
6. Use EXCEPT to find products that exist in the products table but have never been ordered.
   > [!NOTE]
   > **_Your SQL_**
   >
   > ```sql
   > -- Write your query here
   >
   >
   > ```
7. Write a CTE that ranks categories by number of products, then selects only the top 3.
   > [!NOTE]
   > **_Your SQL_**
   >
   > ```sql
   > -- Write your query here
   >
   >
   > ```
8. Use `NOT EXISTS` to find categories that have no products.
   > [!NOTE]
   > **_Your SQL_**
   >
   > ```sql
   > -- Write your query here
   >
   >
   > ```
9. Write a query using CASE that creates a "customer loyalty" label: 'New' (1 order), 'Regular' (2–5 orders), 'VIP' (6+ orders).
   > [!NOTE]
   > **_Your SQL_**
   >
   > ```sql
   > -- Write your query here
   >
   >
   > ```
10. Use GREATEST to find the higher value between each product's current price and the average price of all products in its category.
    > [!NOTE]
    > **_Your SQL_**
    >
    > ```sql
    > -- Write your query here
    >
    >
    > ```
11. Write a query using COALESCE that shows order shipping dates, substituting 'Not yet shipped' for NULL values.
    > [!NOTE]
    > **_Your SQL_**
    >
    > ```sql
    > -- Write your query here
    >
    >
    > ```
12. Use a scalar subquery in the SELECT clause to show each product alongside the total number of times it has been ordered.
    > [!NOTE]
    > **_Your SQL_**
    >
    > ```sql
    > -- Write your query here
    >
    >
    > ```

---

## 4. Query Comparison Exercise (Optional)

> [!TIP]
> **Recommended practice.** Do this section. It is not required to finish the TrailShop project. It prepares you for the exams.

For each pair of queries below, both produce the same result. Explain which approach you'd prefer and why (consider readability, performance, and maintainability).

> [!NOTE]
> **_Your Answer_**
>
> _(Write your answer here.)_

### Pair A: Finding customers with orders

**Version 1 — Subquery with IN:**

```sql
SELECT first_name, last_name
FROM customers
WHERE customer_id IN (SELECT customer_id FROM orders);
```

**Version 2 — JOIN:**

```sql
SELECT DISTINCT c.first_name, c.last_name
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id;
```

### Pair B: Finding products never ordered

**Version 1 — LEFT JOIN + IS NULL:**

```sql
SELECT p.product_name
FROM products p
LEFT JOIN order_items oi ON oi.product_id = p.product_id
WHERE oi.order_item_id IS NULL;
```

**Version 2 — NOT EXISTS:**

```sql
SELECT p.product_name
FROM products p
WHERE NOT EXISTS (
    SELECT 1 FROM order_items oi WHERE oi.product_id = p.product_id
);
```

### Pair C: Customer total spending

**Version 1 — Derived table (subquery in FROM):**

```sql
SELECT sub.full_name, sub.total_spent
FROM (
    SELECT c.first_name || ' ' || c.last_name AS full_name,
           SUM(oi.quantity * oi.unit_price) AS total_spent
    FROM customers c
    JOIN orders o ON o.customer_id = c.customer_id
    JOIN order_items oi ON oi.order_id = o.order_id
    GROUP BY c.customer_id, c.first_name, c.last_name
) sub
WHERE sub.total_spent > 200;
```

**Version 2 — CTE:**

```sql
WITH customer_totals AS (
    SELECT c.first_name || ' ' || c.last_name AS full_name,
           SUM(oi.quantity * oi.unit_price) AS total_spent
    FROM customers c
    JOIN orders o ON o.customer_id = c.customer_id
    JOIN order_items oi ON oi.order_id = o.order_id
    GROUP BY c.customer_id, c.first_name, c.last_name
)
SELECT full_name, total_spent
FROM customer_totals
WHERE total_spent > 200;
```

For each pair, discuss: readability, performance (in PostgreSQL), and when you'd choose one over the other.

> [!NOTE]
> **_Your Answer_**
>
> _(Write your answer here.)_

---

## Submission Checklist

**Required**

- [X] TrailShop queries written for subqueries, EXISTS, and CASE expressions
- [X] Three views created (`v_product_catalog`, `v_customer_summary`, `v_monthly_revenue`)
- [X] UNION/EXCEPT and CTE queries written
- [X] Theory review questions answered

**Recommended practice**

- [ ] Query writing exercises completed
- [ ] Query comparison exercise completed

# Week 37 — Exercises & Project Task

> [!IMPORTANT]
> ***How to Complete These Exercises***
> Write your answers directly in the highlighted **Your Answer** / **Your SQL** fields below each task. Replace the placeholder text with your own work before submitting.

These exercises accompany the Week 37 Theory material. Complete all sections.

---

## Part 1: TrailShop Project Task

### Task 1: Identify Keys

Using the `products`, `categories`, and `customers` tables shown in Section 2 of this week's Theory material, answer:

1. What is the primary key of the `products` table? Why is it a good choice?

> [!NOTE]
> products table primary key is product_id. It is chosen ,because id is a value that never changes and it's always not null.

2. What is the primary key of the `categories` table?

> [!NOTE]
> categories table primary key is category_id.


3. What is the foreign key in the `products` table? What does it reference?

> [!NOTE]
> Products table has a foreig key categry_id. It references categories table.


4. Is `name` in `products` a candidate key? Under what assumption? What would make it unsuitable as a primary key?


> [!NOTE]
> name could be a candidate key only under the assumption that no two products will ever have the same name and that name is never NULL. It would be unsuitable as a primary key ,because uniqueness assumption is fragile in reality different brands can share a name, and typos, case or whitespace differences break it. Also names can change (renaming/rebranding), while a primary key should never need to be updated.
>
5. Give an example of a **superkey** for the `products` table that is NOT a candidate key. Explain why it's not minimal.

> [!NOTE]
> A superkey is any set of columns that uniquely identifies every row in the table. An example for products is {product_id, name} since product_id is already unique, adding name to it still gives a unique combination for every row. It is not a candidate key, because a candidate key must be minimal. We can remove name and {product_id} alone still identifies each row, so the extra column is redundant.
>

6. Give an example of a **composite key** using a hypothetical `order_items` table. Explain why neither column alone would be sufficient.

> [!NOTE]
> order_id alone is not a unique key, because order_id could appear multiple times. product_id is also not a unique key ,because it can appear multiple times.

7. Is `email` in `customers` a candidate key? What makes it different from `customer_id` as a PK choice? *(See Section 6.9 on natural vs surrogate keys.)*

> [!NOTE]
> Yes, email is a candidate key under the assumption that no two customers share the same email and that it is never NULL. The difference is that email is a natural key — it comes from real-world data and has business meaning — while customer_id is a surrogate key, an artificial auto-generated value with no business meaning. As a PK choice, customer_id is safer, because people change email addresses, emails can be typed wrong, while a surrogate id never needs to change and keeps foreign keys (for example in orders) stable even when the customer updates their email.
>

### Task 2: Define Business Rules

List **5 business rules** for TrailShop. For each rule, specify:
- The rule in plain English
- Which constraint type(s) would enforce it
- Which table and column the constraint applies to
- The SQL syntax for the constraint

Example:

| Business Rule | Constraint Type | Table.Column | SQL |
|---|---|---|---|
| Every product must have a price greater than zero | CHECK | products.price | `CHECK (price > 0)` |
| ... | ... | ... | ... |

Think about rules for customers, orders, and categories — not just products.

> [!NOTE]
> | Business Rule | Constraint Type | Table.Column | SQL |
> |---|---|---|---|
> | Every customer must have a unique (and non-null) email address | UNIQUE + NOT NULL | customers.email | email VARCHAR(255) NOT NULL UNIQUE |
> | Category names must be unique — no duplicated category values | UNIQUE + NOT NULL | categories.category_name | category_name VARCHAR(100) NOT NULL UNIQUE |
> | Every order must belong to an existing customer | FOREIGN KEY | orders.customer_id | FOREIGN KEY (customer_id) REFERENCES customers(customer_id) |
> | An order line must contain at least 1 item of the product | CHECK | order_items.quantity | CHECK (quantity > 0) |
> | Every order must have an order date, defaulting to today | NOT NULL + DEFAULT | orders.order_date | order_date DATE NOT NULL DEFAULT CURRENT_DATE |

### Task 3: Integrity Violations

For each SQL statement below, predict whether it will **succeed** or **fail**. If it fails, explain which integrity rule or constraint is violated and what error message you'd expect. Assume the schema from Section 9.8 of the Theory material.

```sql
-- Statement A
INSERT INTO categories (category_id, category_name)
VALUES (NULL, 'Cycling');

-- Statement B
INSERT INTO products (product_id, name, price, stock_quantity, category_id)
VALUES (109, 'AeroLite Tent', 279.00, 10, 2);

-- Statement C
INSERT INTO products (product_id, name, price, stock_quantity, category_id)
VALUES (110, 'BudgetBoots', -5.00, 25, 1);

-- Statement D
INSERT INTO products (product_id, name, price, stock_quantity, category_id)
VALUES (103, 'Duplicate Shoes', 99.99, 5, 3);

-- Statement E
INSERT INTO products (product_id, name, price, stock_quantity, category_id)
VALUES (111, 'CloudWalker Sandals', 65.00, 40, 10);

-- Statement F
INSERT INTO products (product_id, name, price, stock_quantity, category_id)
VALUES (112, NULL, 89.99, 20, 1);

-- Statement G
INSERT INTO products (product_id, name, price, stock_quantity, category_id)
VALUES (113, 'LightStep Shoes', 149.00, -3, 1);

-- Statement H
INSERT INTO order_items (order_id, product_id, quantity, unit_price)
VALUES (1001, 101, 0, 189.50);
```

> [!NOTE]
> A. Fail. null value in column "category_id" of relation "categories" violates not-null constraint
> B. Succeed.
> C. Fail. Violates constraint of products that price should be bigger then 0.
> D. Succeed.
> E. Succeed.
> F. Fail. Violates products name constraint not null.
> G. Fail. Violates products table column stock_quantity constraint that value must be bigger then 0.
> H. Fail. Violates order_items constraint quantity that should be bigger then 0

### Task 4: Foreign Key Actions

Consider the following scenario using the schema from Theory Section 9.8:

1. You want to delete category 2 ("Camping") from the `categories` table. Products 102 and 106 reference this category. What happens with:
   - `ON DELETE RESTRICT`? It will prevent category deletion. The DELETE is rejected with a foreign key violation error while products 102 and 106 still reference category 2.
   - `ON DELETE CASCADE`? It will delete the category and also delete products 102 and 106 that reference it.
   - `ON DELETE SET NULL`? (Assume `category_id` in `products` allows NULL for this question)
   It will delete the category and set the category_id value to NULL on products 102 and 106 — the products stay in the table, they just become uncategorized. This only works because category_id allows NULL; if it were NOT NULL, the delete would fail with a not-null violation instead.

2. Which foreign key action would you recommend for the TrailShop `products.category_id` → `categories.category_id` relationship? Justify your choice in 2–3 sentences.

> [!NOTE]
> For products category foreign key action I would choose the SET NULL action, because it allows us to later add or delete categories easily. If we need to update products that do not have categories, we can easily query those products that have category_id set to NULL.
>

---

## Part 2: Theory Review Questions

Answer each question in 2–4 sentences unless otherwise specified. Reference the Theory material sections as needed.

### Short-Answer Questions

**Q1.** Define the following terms in your own words: relation, tuple, attribute, domain. Give one TrailShop example for each.

> [!NOTE]
>
> A **relation** is a table — a named, two-dimensional structure of rows and columns, for example the products table. A **tuple** is one row in a relation, e.g. (101, 'Alpine Pro Hiking Boots', 189.50, 42, 1). An **attribute** is one column of the table, e.g. price. A **domain** is the pool of all legal values for an attribute, e.g. for price it is positive decimal numbers (NUMERIC(10,2) with CHECK (price > 0)).

*(See Sections 2 and 3 of this week's Theory material.)*

**Q2.** What makes a candidate key different from a primary key? Can a table have more than one candidate key?

> [!NOTE]
>
> A **candidate key** is any minimal superkey — it uniquely identifies every row, and you cannot remove any attribute from it without losing uniqueness. The **primary key** is simply the one candidate key the designer chooses as the official row identifier, and every table has exactly one PK. A table can have several candidate keys, though. For example, in customers both customer_id and email could be candidate keys — choosing customer_id as the PK makes email an alternate key, enforced with a UNIQUE constraint.

*(See Section 6 of this week's Theory material.)*

**Q3.** Explain entity integrity in your own words. Why can't a primary key be NULL?


> [!NOTE]
>
> **Entity integrity** means every table must have a primary key, and no part of that primary key can ever be NULL. If a PK value were NULL, the row could not be uniquely identified — it could not be reliably found, updated, deleted, or referenced by other tables. The rule applies to every column of a composite PK too: in order_items neither order_id nor product_id may be NULL. PostgreSQL enforces this automatically, because PRIMARY KEY implies NOT NULL and UNIQUE.

*(See Section 8.1 of this week's Theory material.)*

**Q4.** What happens when referential integrity is violated? Give a concrete TrailShop example — show the SQL statement and the expected error.

> [!NOTE]
>
> **Referential integrity** says every foreign key value must match an existing primary key value in the referenced table, or be NULL (if the FK column allows it). If it is violated, PostgreSQL rejects the statement so that no orphan record can be created. Example — inserting a product with a category that does not exist:
>
> ```sql
> INSERT INTO products (product_id, name, price, stock_quantity, category_id)
> VALUES (109, 'Ghost Product', 59.99, 5, 99);
> ```
>
> Expected error:
>
> ```text
> ERROR:  insert or update on table "products" violates foreign key constraint "products_category_id_fkey"
> DETAIL:  Key (category_id)=(99) is not present in table "categories".
> ```

*(See Section 8.2 of this week's Theory material.)*

**Q5.** Explain the difference between a surrogate key and a natural key. Give an example of each for a `books` table in a library database.

> [!NOTE]
>
> A **surrogate key** is an artificial identifier with no business meaning — typically an auto-generated integer or a UUID. A **natural key** is drawn from real-world data and carries business meaning. In a books table, book_id INTEGER GENERATED ALWAYS AS IDENTITY would be the surrogate key, while the ISBN is the natural key. In practice you use the surrogate key as the PK and enforce the natural key with a UNIQUE constraint, because surrogate keys are simple, compact, stable, and never need to change.

*(See Section 6.8–6.9 of this week's Theory material.)*

**Q6.** What is a NULL value? Why is `WHERE price = NULL` wrong? What should you write instead?


> [!NOTE]
>
> A **NULL** means the value is unknown or not applicable — it is not the same as zero or an empty string. Any comparison involving NULL returns UNKNOWN instead of TRUE, so WHERE price = NULL never matches any row (even NULL = NULL is UNKNOWN). The correct way to test for it is WHERE price IS NULL (or WHERE price IS NOT NULL).

*(See Section 7 of this week's Theory material.)*

**Q7.** What is a junction table? When is it needed? Give an example.

> [!NOTE]
>
> A **junction table** (also called a linking or bridge table) implements a many-to-many (M:N) relationship, which cannot be represented directly with a single foreign key. It holds foreign keys to both related tables, usually with their combination as a composite primary key. TrailShop example: product_tags(product_id, tag_id) — a product can have many tags and a tag can belong to many products. order_items is also a junction table, implementing the M:N relationship between orders and products.

*(See Section 12.3 of this week's Theory material.)*

**Q8.** Describe the three types of relationships (1:1, 1:N, M:N). For each, give one TrailShop example.

> [!NOTE]
> ***Your Answer***
>
> **1:1** — one row in table A relates to exactly one row in table B, e.g. products ↔ product_details (the detail table's PK is also its FK to `products`). **1:N** — one row in A relates to many rows in B, e.g. one category has many products, or one customer has many orders; the foreign key always sits on the "many" side. **M:N** — many rows on each side relate to many rows on the other, e.g. products ↔ tags, which requires the product_tags junction table.

*(See Section 12 of this week's Theory material.)*

**Q9.** What is the difference between `ON DELETE CASCADE` and `ON DELETE RESTRICT`? When would you use each?


> [!NOTE]
> ***Your Answer***
>
> ON DELETE CASCADE propagates the deletion to the referencing rows: deleting category 2 would also automatically delete products 102 and 106. ON DELETE RESTRICT rejects the deletion while referencing rows exist, forcing you to handle the dependent data explicitly first. CASCADE is appropriate when child rows are meaningless without their parent (e.g. order_items without its order), while RESTRICT is the safest default for relationships like categories → products, where you want to prevent accidental data loss.

*(See Section 10 of this week's Theory material.)*

**Q10.** Explain what "atomic entries" means in the context of relation properties. Give an example of a violation.

> [!NOTE]
> ***Your Answer***
>
> **Atomic entries** means every cell must contain a single, indivisible value — not a list, a set, or a nested structure (this is what First Normal Form requires). A violation would be storing 'Footwear, Hiking' in a single categories cell of the products table. That breaks simple querying — filtering by category would need string parsing instead of a simple WHERE clause — and it also breaks referential integrity. The fix is one row per category, or a junction table when a product can truly have several categories.

*(See Section 5.3 of this week's Theory material.)*

### True/False

For each statement, write **True** or **False** and correct any false statements.

1. A superkey is always a candidate key.
2. A primary key can consist of more than one column.
3. NULL = NULL evaluates to TRUE in SQL.
4. A foreign key must always be NOT NULL.
5. Referential integrity ensures that every FK value matches an existing PK value (or is NULL).
6. The degree of a relation is the number of rows.

> [!NOTE]
> ***Your Answers***
>
> 1. **False** — a candidate key is a *minimal* superkey; a superkey may contain redundant attributes (e.g. {product_id, name} is a superkey, but not a candidate key).
> 2. **True**
> 3. **False** — NULL = NULL evaluates to UNKNOWN, not TRUE; NULL must be tested with IS NULL` / IS NOT NULL.
> 4. **False** — a foreign key can be NULL if the column allows it (e.g. a product that has no category assigned yet).
> 5. **True**
> 6. **False** — the degree is the number of columns (attributes); the number of rows is the cardinality.

### Matching Exercise

Match each term (1–12) with its definition (A–L).

| # | Term |
|---|---|
| 1 | Superkey |
| 2 | Candidate key |
| 3 | Composite key |
| 4 | Foreign key |
| 5 | Alternate key |
| 6 | Surrogate key |
| 7 | Natural key |
| 8 | Orphan record |
| 9 | Domain |
| 10 | Junction table |
| 11 | Cardinality |
| 12 | COALESCE |

| Letter | Definition |
|---|---|
| A | The set of all permitted values for an attribute |
| B | A key composed of two or more attributes |
| C | A row whose FK references a non-existent PK — forbidden by referential integrity |
| D | An artificial key with no business meaning (e.g., auto-generated ID) |
| E | A candidate key not chosen as the primary key |
| F | Any set of attributes that uniquely identifies every tuple |
| G | A minimal superkey — no attribute can be removed without losing uniqueness |
| H | A column that references the primary key of another table |
| I | The number of tuples (rows) in a relation |
| J | A key drawn from real-world data with business meaning |
| K | A table implementing a many-to-many relationship |
| L | A SQL function that returns the first non-NULL argument |


> [!NOTE]
> ***Your Answers***
>
> | # | Your Match |
> |---|---|
> | 1 | F |
> | 2 | G |
> | 3 | B |
> | 4 | H |
> | 5 | E |
> | 6 | D |
> | 7 | J |
> | 8 | C |
> | 9 | A |
> | 10 | K |
> | 11 | I |
> | 12 | L |
>

---

## Part 3: SQL Practice — Constraints in Action

These exercises test your understanding of constraints. You do NOT need to run these in PostgreSQL (but you may if you'd like to verify your answers).

### Exercise 3.1: Predict the Outcome

Given the following table definitions:

```sql
CREATE TABLE departments (
    dept_id   INTEGER      PRIMARY KEY,
    dept_name VARCHAR(50)  NOT NULL UNIQUE
);

CREATE TABLE employees (
    emp_id    INTEGER       PRIMARY KEY,
    name      VARCHAR(100)  NOT NULL,
    salary    NUMERIC(10,2) NOT NULL CHECK (salary >= 0),
    dept_id   INTEGER       NOT NULL REFERENCES departments(dept_id)
);
```

Assume these rows already exist:

```sql
INSERT INTO departments VALUES (1, 'Engineering');
INSERT INTO departments VALUES (2, 'Marketing');
INSERT INTO employees VALUES (100, 'Alice', 75000, 1);
INSERT INTO employees VALUES (101, 'Bob', 65000, 2);
```

For each statement below, predict: **SUCCESS** or **FAIL**? If fail, name the violated constraint.

```sql
-- 1
INSERT INTO employees VALUES (102, 'Carol', 70000, 1);
-- 2
INSERT INTO employees VALUES (103, 'Dan', -5000, 1);

-- 3
INSERT INTO employees VALUES (100, 'Eve', 80000, 2);

-- 4
INSERT INTO employees VALUES (104, 'Frank', 60000, 5);

-- 5
INSERT INTO departments VALUES (3, 'Engineering');

-- 6
INSERT INTO employees VALUES (105, NULL, 55000, 2);

-- 7
DELETE FROM departments WHERE dept_id = 1;

-- 8
INSERT INTO employees VALUES (106, 'Grace', 0, 2);
```

1. **SUCCESS**
2. **FAIL** ERROR:  new row for relation "employees" violates check constraint "employees_salary_check"
3. **FAIL** ERROR:  duplicate key value violates unique constraint "employees_pkey"
4. **FAIL** ERROR:  insert or update on table "employees" violates foreign key constraint "employees_dept_id_fkey"
5. **FAIL** ERROR:  duplicate key value violates unique constraint "departments_dept_name_key"
6. **FAIL** ERROR:  null value in column "name" of relation "employees" violates not-null constraint
7. **FAIL** ERROR:  update or delete on table "departments" violates foreign key constraint "employees_dept_id_fkey" on table "employees"
8. **SUCESS**

### Exercise 3.2: Write the Constraints

Given these business rules for a **bookstore database**, write the `CREATE TABLE` statements with appropriate constraints:

1. Every book has a unique ISBN (13 characters), a title (required), a price (must be positive), and a publication year.
2. Every author has an ID, a first name (required), and a last name (required).
3. A book can have multiple authors, and an author can write multiple books.
4. Every book belongs to exactly one genre. Genres have an ID and a unique name.
5. Publication year must be between 1450 and the current year.

*(Hint: you'll need at least 4 tables, including a junction table for the M:N relationship.)*

---

## Part 4: Design Exercise — Library System

A small public library needs a database. Here is a description of their requirements:

> The library has a collection of **books**. Each book has an ISBN, a title, a publication year, and belongs to one genre (Fiction, Non-Fiction, Science, History, etc.). The library may own multiple **copies** of the same book — each copy has a unique barcode sticker.
>
> The library has registered **members**. Each member has a member number, name, email, and phone. Members can **borrow** copies. Each borrowing records which member borrowed which copy, the borrow date, the due date, and the return date (NULL if not yet returned).
>
> **Rules:**
> - A member can borrow at most 5 copies at any given time.
> - The due date is always 14 days after the borrow date.
> - A copy cannot be borrowed if it's currently not returned (return_date IS NULL).

### Your Tasks

1. **Identify the tables** you would need (list them with their columns).
2. **Identify the primary key** for each table. Are they surrogate or natural keys? Justify your choices.
3. **Identify all foreign keys** and the tables they reference.
4. **Identify any candidate keys** beyond the primary key (alternate keys).
5. **List the business rules** from the description and map each to a constraint type. Which rules cannot be enforced by simple constraints?


> [!NOTE]
> ***Your Answer***
>
> *(Write your answer here.)*
>
>
>
>
6. **Write the CREATE TABLE statements** for at least the `books`, `copies`, and `borrowings` tables with full constraints.

---

## Submission Checklist

- [ ] Task 1: Key identification answers (Part 1)
- [ ] Task 2: Business rules table with 5 rules (Part 1)
- [ ] Task 3: Integrity violation predictions with explanations (Part 1)
- [ ] Task 4: Foreign key action analysis (Part 1)
- [ ] Theory Review Questions answered (Part 2)
- [ ] SQL Practice — constraint predictions and bookstore CREATE TABLE (Part 3)
- [ ] Library System design exercise (Part 4)
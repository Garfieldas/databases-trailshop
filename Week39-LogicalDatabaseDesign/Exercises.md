# Week 39 — Logical Database Design: Exercises

> [!IMPORTANT]
> ***How to Complete These Exercises***
> Write your answers directly in the highlighted **Your Answer** / **Your SQL** fields below each task. Replace the placeholder text with your own work before submitting.

These exercises accompany the Week 39 Theory material. Refer to the theory sections indicated in brackets when you need help.

---

## Exercise 1: TrailShop Project Task — Build the Schema

**Goal:** Convert the TrailShop ER diagram (from Week 38) into a complete PostgreSQL relational schema.

### Instructions

Write `CREATE TABLE` statements for all six TrailShop tables:

1. `categories`
2. `customers`
3. `products`
4. `product_categories`
5. `orders`
6. `order_items`

### Requirements

For each table, you must:

- Choose appropriate PostgreSQL data types for every column (justify at least 3 choices in writing)
- Define primary keys (surrogate or composite as appropriate)
- Define foreign keys with explicit `ON DELETE` and `ON UPDATE` actions (justify each choice)
- Add `NOT NULL`, `UNIQUE`, `CHECK`, and `DEFAULT` constraints where appropriate
- Create tables in the correct dependency order
- Follow the naming conventions from Theory Section 8

### Deliverables

1. A single `.sql` file with all six `CREATE TABLE` statements (executable in PostgreSQL)
2. A short justification for data types, FK actions and design decisions:
   - Justification for 3 data type choices (e.g., why `NUMERIC(10,2)` for price instead of `REAL`)
   - Justification for each FK action choice (e.g., why CASCADE on `order_items.order_id`)
   - One design decision you made that wasn't specified in the requirements (e.g., whether shipping address is optional)

### Bonus Challenge

After creating the tables, insert sample data:
- At least 5 categories
- At least 8 products (across at least 3 categories)
- At least one product assigned to **two or more** categories via `product_categories`
- At least 3 customers
- At least 4 orders (across at least 2 customers)
- At least 10 order items

Verify that your constraints work by attempting at least 2 invalid inserts and showing the error messages.

> [!NOTE]
> ***Your SQL***
>
> ```sql
> -- Paste key CREATE TABLE statements or link to your .sql file contents here
>
>
> ```

> [!NOTE]
> ***Your Answer***
>
> *(Paste written justifications for data types, FK actions, and design decisions here.)*
>
>
>
>

## Exercise 2: Theory Review Questions

Answer each question in 2–4 sentences. Reference the relevant theory section.

1. List the seven phases of the database development lifecycle in order. Which phase is this week's focus? *(Section 1)*

> [!NOTE]
>┌──────────────────────────────────┐
>│  1. Requirements Gathering       │
>├──────────────────────────────────┤
>│  2. Conceptual Design            │
>├──────────────────────────────────┤
>│  3. Logical Design               │  - this week
>├──────────────────────────────────┤
>│  4. Physical Design              │
>├──────────────────────────────────┤
>│  5. Implementation               │
>├──────────────────────────────────┤
>│  6. Testing & Validation         │
>├──────────────────────────────────┤
>│  7. Maintenance & Evolution      │
>└──────────────────────────────────┘
>
>

2. Explain the transformation rule for mapping a 1:N relationship to the relational model. Why is the foreign key placed on the "many" side? *(Section 3.2)*

> [!NOTE]
> Add the primary key of the "one" side as a foreign key column in the "many" side table.
> Example: Customer (1) → Order (N).
> each order belongs to ONE customer — you can store that single reference in the order row. If you tried to store it on the Customer  side, you'd need to store multiple order IDs per customer row, violating atomicity.
>

3. What is a junction table? When is it needed? Give an example not from TrailShop. *(Section 3.3)*

> [!NOTE]
> Junction table represets M:N relationship. It only stores primary keys of both sides without additional attributes.
> Example Rented books: it could store foreign key of a user and a book ,that he has rented. Same could be rented by a lot of users over time.
>
>

4. When mapping a 1:1 relationship, how do you decide which table gets the foreign key? *(Section 3.4)*

> [!NOTE]
> If one side has mandatory participation and the other optional: Put the FK on the mandatory side (it will always have a value).
> If both sides are mandatory: Either side works; choose the side that makes queries more natural.
> If both sides are optional: Put the FK on the side that is more likely to have the value. Mark the FK column as NULL-able.
> Alternative: Merge both entities into one table if they always exist together.
>
>
>
>

5. How does the mapping of a weak entity differ from a strong entity? What happens to the primary key? *(Section 3.5)*

> [!NOTE]
> Create a table for the weak entity. Include the owner entity's primary key as both a foreign key AND part of the composite primary key.
> Owner's entity (strong entity) becomes both a foreign key and the part of composite key.
>
>

6. Why should you never use `REAL` or `DOUBLE PRECISION` for monetary values? What should you use instead? *(Section 4.1)*

> [!NOTE]
> Because you would never get correct accuaracy as those data types are used for scientific data. It's much better to use Numeric type
>
>
>

7. What is the difference between `TIMESTAMP` and `TIMESTAMPTZ`? Which should you prefer and why? *(Section 4.3)*
> [!NOTE]
> Timestamp - is date + time without timezone. 
> TimestampTz - is date + time and timezone. It's always better to use Timestamptz to avoid time zone bugs when users are in different time zones.
>

8. Explain the difference between `CASCADE` and `RESTRICT` as foreign key delete actions. Give a scenario where each is appropriate. *(Section 6)*
> [!NOTE]
> Cascade - delete all child rows automatically
> Restrict - same as no action but checked immediately
> Cascade are used then children values does not have any meaningfull value on their own and it is not very important if they are deleted
> Example of cascade: Book tags table. it is not important to hold that information if the book itself is deleted
> Example of restrict: Invoice. If invoice is unpaid and references a customer it is important to prevent deleting customer while this invoice exists.
>




9. What is an insertion anomaly? Give an example and explain how proper schema design prevents it. *(Section 7)*
> [!NOTE]
> You cannot insert certain data without inserting other unrelated data.
> For example if we create book table and put inside it rented_by_customer column. So in these case we will constanly update same record or if multiple users decide to rent same book at same time our logic would break.
> Proper schema design would elimanate this problem by using normalization, because it will reduce redundancy in our data.




10. What is the difference between a surrogate key and a natural key? Give one advantage of each. *(Section 9)*
> [!NOTE]
> Surrogate Key: An artificial, system-generated value with no business meaning.
> Natural Key: A column (or columns) that has real-world meaning and naturally identifies each row.
> Natural keys has an advantage of being more natural as identifier for example user email address
> Surrogate keys have an advantage of being consitent and much faster on join queries.



11. Why does PostgreSQL fold unquoted identifiers to lowercase? How does `snake_case` naming help? *(Section 8)*

> [!NOTE]
> PostgreSQL folds unquoted identifiers to lowercase.
> snake_case helps here ,because it stores exactly as it was written.
>
>

12. What does `SET NULL` do as a foreign key action? When would you use it instead of `CASCADE`? *(Section 6)*
> [!NOTE]
> Set Null action sets foreign key to null if that entity was deleted. It helps in those scenarios ,then entity on it's own has meaning and relationship not that important.




---

## Exercise 3: Transformation Exercise — Hotel Booking System

### Given ER Diagram

A hotel booking system has the following entities and relationships:

**Entities:**

1. **Hotel** — hotel_id (PK), name, city, star_rating, phone
2. **Room** (weak entity, owned by Hotel) — room_number (partial key), room_type, floor, price_per_night, has_balcony
3. **Guest** — guest_id (PK), first_name, last_name, email, phone, passport_number
4. **Booking** — booking_id (PK), check_in_date, check_out_date, total_amount, status
5. **Service** — service_id (PK), name, description, price (e.g., "Room Service", "Spa", "Airport Shuttle")

**Relationships:**

- Hotel (1) → Room (N): A hotel has many rooms. Each room belongs to exactly one hotel. (Identifying relationship — Room is weak.)
- Guest (1) → Booking (N): A guest can make many bookings. Each booking belongs to one guest.
- Booking (M) ↔ Room (N): A booking can include multiple rooms, and a room can appear in many bookings (over time). The junction records the specific dates.
- Booking (M) ↔ Service (N): A booking can use multiple services, and a service can be used by many bookings. The junction records the date used and quantity.

### Task

1. Write `CREATE TABLE` statements for ALL tables (including junction tables).
2. For each table:
   - Choose appropriate data types
   - Define PK, FK, NOT NULL, UNIQUE, CHECK, and DEFAULT constraints
   - Specify ON DELETE and ON UPDATE actions for all FKs
3. Create the tables in the correct dependency order.
4. Explain why Room is a weak entity and how its PK reflects this.

> [!NOTE]
> ***Your SQL***
>
> ```sql
> -- Write your CREATE TABLE statements here
>
>
> ```

> [!NOTE]
> ***Your Answer***
>
> *(Explain why Room is a weak entity and how its PK reflects this.)*
>
>
>
>

---

## Exercise 4: Data Type Selection

> [!NOTE]
> ***Your Answers***
> Fill in the **Your Data Type** and **Justification** columns in the table below.
>

For each column described below, choose the best PostgreSQL data type and write a brief justification (1–2 sentences). Do NOT just pick `VARCHAR` or `TEXT` for everything — think carefully about validation, storage, and query needs.

| # | Column Description | Your Data Type | Justification |
|---|---|---|---|
| 1 | Employee salary (exact, up to €999,999.99) | | |
| 2 | Number of items in stock (never negative, max ~50,000) | | |
| 3 | Whether a user's email is verified | | |
| 4 | Customer's date of birth | | |
| 5 | Product description (variable length, could be several paragraphs) | | |
| 6 | Country code (always exactly 2 letters, like "FI", "US") | | |
| 7 | IP address of a login attempt | | |
| 8 | Order total (exact, up to €9,999,999.99) | | |
| 9 | GPS latitude of a store location | | |
| 10 | A unique identifier for API tokens that must be globally unique across distributed systems | | |
| 11 | Duration of a video in seconds (always a whole number) | | |
| 12 | Timestamp of when a record was last modified (users in multiple time zones) | | |
| 13 | A Finnish phone number like "+358 40 123 4567" | | |
| 14 | A percentage discount (0.00% to 100.00%) | | |
| 15 | A product's color options (e.g., a product comes in "red", "blue", "green") | | |

---

## Exercise 5: Constraint Design

For each business rule below, write the appropriate PostgreSQL constraint. Provide the constraint as it would appear inside a `CREATE TABLE` statement or as an `ALTER TABLE` statement.

### Part A: Single-Column Constraints

1. "A product's weight must be greater than zero (if provided)."

2. "Every customer must have an email address."

3. "Product names must be unique."

4. "An employee's hire date defaults to today if not specified."

5. "Order status can only be one of: 'new', 'confirmed', 'shipped', 'delivered', 'returned'."

> [!NOTE]
> ***Your SQL***
>
> ```sql
> -- Write constraints 1–5 here
>
>
> ```

### Part B: Multi-Column Constraints

6. "A flight's arrival time must be after its departure time."

7. "In the `enrollments` table, the combination of `student_id` and `course_id` must be unique (a student can only enroll in a course once)."

8. "A discount percentage must be between 0 and 100, inclusive."

> [!NOTE]
> ***Your SQL***
>
> ```sql
> -- Write constraints 6–8 here
>
>
> ```

### Part C: Foreign Key Constraints with Actions

9. "When a department is deleted, all employees in that department should have their `department_id` set to NULL (they become unassigned)."

10. "When a customer is deleted, prevent the deletion if the customer has any orders."

11. "When an author is deleted, all their blog posts should be deleted automatically."

12. "When a course is deleted, all enrollments for that course should be removed."

> [!NOTE]
> ***Your SQL***
>
> ```sql
> -- Write constraints 9–12 here
>
>
> ```

---

## Submission Checklist

- [ ] Exercise 1: `.sql` file with all CREATE TABLE statements + written justifications
- [ ] Exercise 2: All 12 theory review answers
- [ ] Exercise 3: Hotel booking schema with all tables and explanations
- [ ] Exercise 4: Data type selections with justifications for all 15 columns
- [ ] Exercise 5: All 12 constraints written in valid PostgreSQL syntax
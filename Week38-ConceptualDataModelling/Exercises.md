# Week 38 — Conceptual Data Modelling: Exercises

> [!IMPORTANT]
> ***How to Complete These Exercises***
> Write your answers directly in the highlighted **Your Answer** / **Your SQL** fields below each task. Replace the placeholder text with your own work before submitting.

These exercises accompany the Week 38 Theory material. Refer to the theory sections indicated in brackets when you need help.

---

## Exercise 1: TrailShop Project Task — Create the ER Diagram

**Goal:** Create a complete Entity-Relationship diagram for the TrailShop database using crow's foot notation.

> **From Week 37:** Last week each product had a single `category_id` (Category 1:N Product). That cannot store a product in two categories. This week's diagram must **not** put `category_id` on Product. Use **ProductCategory** as the junction that resolves Category M:N Product (see Theory Section 1.4).

### Instructions

Using the entity descriptions from Theory Section 12, create an ER diagram that includes:

1. **All six entities**: Category, Product, ProductCategory, Customer, Order, OrderItem
2. **All attributes** for each entity (as listed in Section 12.1)
3. **Primary keys** clearly marked (underline or "PK" label)
4. **Foreign keys** clearly marked (dashed underline or "FK" label)
5. **Relationships** between entities with:
   - Relationship name (verb)
   - Crow's foot notation showing cardinality and participation
6. **Identify weak / junction entities** — mark OrderItem as a weak entity, and mark ProductCategory as the junction that resolves Category M:N Product. Do **not** draw a direct M:N line between Category and Product.

### Requirements

- Use crow's foot notation (see Theory Section 9)
- You may use any tool: draw.io, Lucidchart, ERDPlus, dbdiagram.io, or even pen and paper (photograph and submit)
- The diagram must be readable — avoid crossing lines where possible
- Include a brief legend explaining your notation if using pen and paper

### Deliverables

- The ER diagram (image or link to online tool)
- A short written paragraph (3–5 sentences) that **must** explain why Week 37's 1:N `products.category_id` is being replaced by ProductCategory. You may also discuss another design decision (for example why OrderItem is a weak entity, or why `unit_price` is stored in OrderItem).

> [!NOTE]
![Screenshot](https://i.ibb.co/wrNqftWQ/Screenshot-2026-09-22-at-22-07-04.png)
>
> In Week 37, products.category_id modeled Category 1:N Product, which forces every product to belong to exactly one category — a single FK column physically cannot store a product in two categories at once. TrailShop's real business rule is that a product can appear in several categories (e.g. a jacket in both "Outerwear" and "Sale") and a category obviously contains many products, which is an M:N relationship. Relational databases cannot implement M:N directly, so it is resolved with the junction entity ProductCategory, whose rows pair a category_id with a product_id and turn the M:N into two 1:N relationships. This also removes category_id from Product, so adding or removing a category membership never requires restructuring the Product table. As another design decision, unit_price is stored in OrderItem rather than being read from Product, because product prices change over time and each order must preserve the historical price the customer actually paid at the moment of purchase.
>
>
>
>

---

## Exercise 2: Theory Review Questions

Answer each question in 2–4 sentences. Reference the relevant theory section. Question 11b is extra: it connects last week's 1:N category FK to this week's junction.

1. Why should you create a conceptual data model before writing SQL? Give two specific reasons. *(Section 1)*

> [!NOTE]
>
> Conceptual data model let's you think how data is structured. How it relates and how rules should be applied.
> Changing already existing database tables in production is risky and can lead into a trouble. Planning in advance helps to mitigate those problems.
>
>
>

2. What is the difference between the conceptual level and the logical level of a data model? *(Section 2)*

> [!NOTE]
>
> Conceptual model just describes what information organization needs to track and how it's related.
> Logical model specifies relations,tables and constraints as a structure.
>
>
>

3. Explain logical data independence with an example. *(Section 3)*

> [!NOTE]
> ***Your Answer***
> Logical Data Independence: You can change the conceptual schema without changing users’ external schemas (views). For example:
> You add a new department_id field to the employees table and move department information into a separate departments table.
> The HR team’s view is redefined to JOIN employees with departments.
> HR users continue to see employee names and department names in the same format, so their applications need no changes
>
>
>
>

4. Explain physical data independence with an example. *(Section 3)*

> [!NOTE]
> Physical Data Independence: You can change how data is physically stored without changing the conceptual schema or user views. For example:
> You partition the orders table by year to improve performance.
> The database stores each year’s orders in a separate partition.
> Applications still query the same orders table.
> No SQL queries or views need to change.
>
>
>

5. What is the difference between a strong entity and a weak entity? Give one example of each (not from TrailShop). *(Section 5)*

> [!NOTE]
> Strong Entity A strong entity can be uniquely identified by its own attributes. It does not depend on any other entity for its existence or identification.
> For example bank account. It has bank_account_id ,due to that it could be identified and is a strong entity.
> Weak entity cannot be uniquely identified by its own attributes alone. It depends on a related strong entity (called the owner or identifying entity) for its identification.
> For example transaction. #1 per account, not globally unique
>

6. What is a composite attribute? How does it differ from a multivalued attribute? Give an example of each. *(Section 6)*

> [!NOTE]
> A composite attribute can be divided into smaller, meaningful sub-attributes.
> Example: full_name could be split into first_name and last_name.
> A multivalued attribute can hold multiple values for a single entity instance.
> A product might have multiple tags: "waterproof", "lightweight", "bestseller
> Main diference is that composite atribute is combination of existing single table atributes, but multivalued atrribute is created using a junction table.

7. What is a derived attribute? Why is it usually not stored in the database? *(Section 6)*

> [!NOTE]
> Derived attribute is an atribute ,which can be calculated from other existing attributes. They are usually not stored ,because in most cases they are dinamic as order total price and can be calculated everytimne.
>
>
>
>

8. Explain the difference between a binary relationship and a unary (recursive) relationship. Give an example of each. *(Section 7)*
> [!NOTE]
> A binary relationship involves exactly two entity types. For example Order contains OrderItem (two entities: Order, OrderItem).
> A unary relationship (also called recursive) involves a single entity type related to itself.
> For example phone is a product and phone case is an accesory for product ,but still both are products.




9. What is the difference between an identifying relationship and a non-identifying relationship? How does this affect the child table's primary key? *(Section 7)*
> [!NOTE]
> Identifying relationship is when foreign key a part of child's primary key. Non-identifying is when foreign key is just atribute and does not serve a purpose of identifycation.
>




10. In crow's foot notation, what does the following endpoint mean: a circle followed by a crow's foot (fork)? *(Section 9)*
> Maximum many
>
>
11. Why can't a many-to-many (M:N) relationship be directly implemented in a relational database? What is the solution? *(Section 10)*

> [!NOTE]
> An M:N relationship cannot be represented directly because one foreign-key value can reference only a single row in another table. Putting several identifiers into one column would break atomicity, and repeating entire rows just to store additional links would create redundant data.
> The solution is to create a junction (associative) table between the two entities. It stores one row per pairing, with foreign keys to both tables and normally their combination as the composite primary key.

11b. Last week TrailShop used products.category_id so each product belonged to exactly one category. Why is that insufficient, and what ER construct replaces it? *(Section 1.4)*

> [!NOTE]
> products.category_id is a scalar foreign key, so every product row can store only one category. That makes it impossible to assign the same product to multiple categories, such as Footwear and Hiking, without duplicating product data.
> The 1:N relationship should be replaced conceptually by an M:N relationship between products and categories. Physically, this is implemented with a product_categories(product_id, category_id) junction table, where both columns are foreign keys and together form the composite primary key.

12. A business rule states: "Every employee must belong to exactly one department, and every department must have at least one employee." Express this using min-max notation for both sides. *(Section 8)*

> [!NOTE]
> On the **EMPLOYEE** side, use **(1,1)**: each employee must participate in exactly one department relationship. On the **DEPARTMENT** side, use **(1,N)**: each department must be related to at least one employee and may be related to many employees.

---

## Exercise 3: ER Diagram Reading Exercise

### Diagram A: Library System

Study the following ER description and answer the questions below.

```
┌──────────┐                        ┌──────────┐
│  AUTHOR  │──||──────O<────────────│   BOOK   │
└──────────┘                        └─────┬────┘
                                          │
                                    ||    │
                                          │
                                    O<    │
                                          │
                                   ┌──────┴─────┐
                                   │    LOAN     │
                                   └──────┬──────┘
                                          │
                                    ||    │
                                          │
                                    O<    │
                                          │
                                   ┌──────┴──────┐
                                   │   MEMBER    │
                                   └─────────────┘
```

Relationships (in crow's foot):
- Author `──||──────O<──` Book
- Book `──||──────O<──` Loan
- Member `──||──────O<──` Loan

**Questions:**

a) Can an author exist without having written any books? Explain using the notation.
> [!NOTE]
>
> Yes, he can 
> AUTHOR ||——O< BOOK
> One author can have zero or many books.
> Every book must have exactly one author.
>
>

b) Can a book exist without being loaned? Explain using the notation.
> [!NOTE]
> One book can appear in zero or many loan records over time.
> Every loan record refers to exactly one book.
> BOOK ||——O< LOAN
>
>
>

c) What type of entity is Loan in this diagram? Is it a junction/associative entity? Why?


> [!NOTE]
> Loan is junction/associative entity as it connects two entities: member and book.
>
>
>
>

d) What is the cardinality of the Author-Book relationship? Is this realistic? What might be a more accurate model?


> [!NOTE]
> It could work, but in real case more practical model would be if one author had many books and one book could have many authors so it would be better to have separate junction table for this.
>
>
>

e) What attributes would you add to the Loan entity?


> [!NOTE]
> loand_id, member_id, book_id, loan_date, return_date, renewal_count, status
>
>
>

### Diagram B: School System

```
STUDENT ──O|──────O<── ENROLLMENT ──>|──||── COURSE
                                        │
                                    ||  │
                                        │
                                    O<  │
                                        │
                                   TEACHER
```

Relationships:
- Student `──O|──────O<──` Enrollment (a student may have zero or many enrollments)
- Enrollment `──||──────||──` Course (each enrollment is for exactly one course)
- Teacher `──||──────O<──` Course (each course has zero or many sections, each taught by exactly one teacher)

**Questions:**

a) Can a student exist without being enrolled in any course?


> [!NOTE]
> According to diagra, yes ,because STUDENT ─O<── ENROLLMENT
>
>
>

b) Can a course exist without having any enrolled students?


> [!NOTE]
> ***Your Answer***
> No, because it requires at least one erollment. ENROLLMENT ──>|─-─ COURSE
>
>
>
>

c) What is the cardinality between Student and Course (through Enrollment)?


> [!NOTE]
> Cardinality is many to many through Enrollment. Student can have 0 or many enrollements. Course can have 1 or many enrollements.
>
>
>

d) Can a teacher exist without teaching any courses?


> [!NOTE]
> Yes, it is possible ,because TEACHER O< Course
>
>
>
>

e) Is the Teacher-Course relationship 1:1 or 1:N? What does this imply about team teaching?


> [!NOTE]
> It is 1:N ,because multiple teachers can teach same course.
>
>
>

---

## Exercise 4: ER Diagram Creation — Gym/Fitness Center

### Scenario

FitZone is a local gym and fitness center. They need a database to manage their operations. Here are the business rules:

1. The gym has **members**. Each member has an ID, first name, last name, email, phone, date of birth, and membership start date.

2. The gym offers **membership plans** (e.g., "Basic", "Premium", "Student"). Each plan has a plan ID, name, monthly price, and description. Each member subscribes to exactly one plan. A plan can have many members.

3. The gym has **trainers** (employees who lead classes). Each trainer has an ID, first name, last name, specialization (e.g., "Yoga", "CrossFit"), and hire date.

4. The gym offers **classes** (e.g., "Morning Yoga", "HIIT Blast"). Each class has an ID, name, day of the week, start time, end time, and maximum capacity. Each class is led by exactly one trainer, but a trainer can lead many classes.

5. Members can **register** for classes. A member can register for many classes, and a class can have many registered members. The registration records the registration date.

6. The gym has **equipment** (treadmills, dumbbells, etc.). Each piece of equipment has an ID, name, type, purchase date, and status ("working", "maintenance", "retired").

7. When equipment breaks, a **maintenance request** is created. Each request has an ID, request date, description of the problem, status ("open", "in progress", "closed"), and resolution date. Each request is for exactly one piece of equipment. One piece of equipment can have many maintenance requests over time.

### Task

1. Identify all entities and their attributes (including key attributes).

> [!NOTE]
> **members:** member_id (PK), first_name, last_name, email, phone, date_of_birth, membership_start_date, plan_id (FK → plan)
>
> **plan:** plan_id (PK), name, monthly_price, description
>
> **trainers:** trainer_id (PK), first_name, last_name, specialization, hire_date
>
> **classes:** classes_id (PK), name, day_of_the_week, start_time, end_time, capacity, trainer_id (FK → trainers)
>
> **register:** register_id (PK), member_id (FK → members), class_id (FK → classes), registration_date
>
> **equipment:** equipment_id (PK), name, type, purchase_date, status
>
> **maintenance_request:** maintenance_id (PK), request_date, description, status, resolution_date, equipment_id (FK → equipment)
>
> ![Screenshot](https://i.ibb.co/twgNc8pb/Screenshot-2026-09-22-at-21-34-59.png)

2. Identify all relationships with their cardinality and participation constraints.

> [!NOTE]
>
> member -> plan N:1. Member can have one plan ,but same plan belongs to a lot of members. Many to One
> trainers -> classes 1:N. One trainer can have many classes. One to many
> members -> register <- classes M:N. Many members can have many clases through junction table register.
> equipment -> maintenance request 1:N. One equipment can have many maintenance requests. One to many.
>

3. Draw a complete ER diagram using crow's foot notation.

> [!NOTE]
> ![Screenshot](https://i.ibb.co/pjfvvhMM/Screenshot-2026-09-22-at-21-53-26.png)
>
>
>

4. Identify any entity that might be considered a weak entity or a junction/associative entity. Justify your answer.

> [!NOTE]
> Weak entity is register ,because it is identified by member_id and class_id foreign keys.
> Strong entity is plan ,because plan has he's it's own unique id identification and could be identified idependantly.
>
>

5. Are there any M:N relationships? If so, what junction entity resolves them?

> [!NOTE]
> Member and class relationship. It is resolved using junction table register
>
>
>
---

## Exercise 5: Find and Correct the Errors

The following ER diagram description contains **four errors**. Find each error, explain why it's wrong, and provide the correction.

### Scenario: Online Bookstore

**Entities and attributes:**

1. **Books**
   - book_id (PK)
   - title
   - author_name
   - price
   - genres (stores "Fiction, Mystery, Thriller" as a comma-separated string)

2. **Customer**
   - customer_id (PK)
   - full_name
   - address

3. **Purchase**
   - purchase_id (PK)
   - purchase_date
   - total_amount

**Relationships:**
- Books to Customer: M:N (implemented directly — no junction table)
- Customer to Purchase: 1:N (one customer, many purchases)
- Books to Purchase: no relationship defined

### Your Task

Find the four errors in this design and for each one:

a) State what the error is
> [!NOTE]
> author_name is specified inside books table. It is better to have separate author table and reference it's foreign key as author_id inside books table.
>
>
>

b) Explain why it's a problem (reference the relevant theory section)

> [!NOTE]
> ***Your Answer***
>
> *(Write your answer here.)*
>
>
>
>

c) Describe how to fix it

> [!NOTE]
> ***Your Answer***
>
> *(Write your answer here.)*
>
>
>
>

**Hints:** Think about multivalued attributes, M:N relationships, entity naming conventions, and missing relationships.

---

## Submission Checklist

- [ ] Exercise 1: ER diagram + design decision paragraph (including why Week 37's category FK is replaced)
- [ ] Exercise 2: All 12 theory review answers, plus 11b
- [ ] Exercise 3: All questions answered for both Diagram A and Diagram B
- [ ] Exercise 4: Entity list, relationship list, ER diagram, and justifications
- [ ] Exercise 5: Four errors identified with explanations and corrections

# Week 46 — Transactions and Concurrency: Exercises

> [!IMPORTANT]
> **_How to Complete These Exercises_**
> Write your answers directly in the highlighted **Your Answer** / **Your SQL** fields below each task. Replace the placeholder text with your own work before submitting.

---

## 1. TrailShop Project Task

### Task 1.1: Write an Order Transaction

Write a complete transaction that processes a new order in TrailShop:

1. Insert a new order for an existing customer.
2. Insert 2–3 order items.
3. Decrease `stock_quantity` for each ordered product.
4. Include a check that stock doesn't go negative (if it would, ROLLBACK).
5. Use a SAVEPOINT before the stock update step.
   > [!NOTE]
   > **_Your SQL_**
   >
   > ```sql
   > BEGIN TRANSACTION;
   >
   > WITH new_order AS (
   >     INSERT INTO orders (
   >         customer_id, status, shipping_address
   >     )
   >     VALUES (
   >         1, 'paid', 'Mikkeli'
   >     )
   >     RETURNING order_id
   > )
   >
   > INSERT INTO order_items (
   >     order_id, product_id, quantity, unit_price
   > )
   > VALUES
   >     ((SELECT order_id FROM new_order), 1, 2, 100.0),
   >     ((SELECT order_id FROM new_order), 2, 1, 20.0),
   >     ((SELECT order_id FROM new_order), 3, 5, 40.0);
   >
   >
   > SAVEPOINT stock_roll_back;
   >
   > UPDATE products
   > SET stock_quantity = stock_quantity - 1
   > WHERE product_id IN (1, 2, 3);
   >
   > COMMIT;
   > ```

Test the transaction by:

- Running it successfully with sufficient stock.
- Running it where stock is insufficient — verify the ROLLBACK works.

### Task 1.2: Observe READ COMMITTED Behavior (Optional)

> [!TIP]
> **Recommended practice.** Do Tasks 1.2–1.4. They are not required to finish the TrailShop project. They prepare you for the exams.

Open two psql sessions (or two query windows). Demonstrate a non-repeatable read:

1. Session A: `BEGIN;` then `SELECT stock_quantity FROM products WHERE product_id = 101;`
2. Session B: `BEGIN;` then `UPDATE products SET stock_quantity = stock_quantity - 5 WHERE product_id = 101;` then `COMMIT;`
3. Session A: `SELECT stock_quantity FROM products WHERE product_id = 101;` (observe different value)
4. Session A: `COMMIT;`

Document what you observe and explain why it happens at READ COMMITTED.

### Task 1.3: Observe Locking (Optional)

Open two sessions and demonstrate row-level locking:

1. Session A: `BEGIN;` then `SELECT * FROM products WHERE product_id = 101 FOR UPDATE;`
2. Session B: Try `UPDATE products SET price = 99.99 WHERE product_id = 101;` — observe it waits.
3. Session A: `COMMIT;` — observe Session B proceeds.

Document the behavior.

### Task 1.4: Experiment with Isolation Levels (Optional)

1. Repeat Task 1.2, but set Session A to `REPEATABLE READ`. Does the non-repeatable read still occur?

> [!NOTE]
> **_Your Answer_**
>
> _(Write your answer here.)_
>
> 2. In a REPEATABLE READ transaction, try to UPDATE a row that another transaction has already committed a change to. What error do you get?

> [!NOTE]
> **_Your Answer_**
>
> _(Write your answer here.)_
>
> 3. Document the differences between READ COMMITTED and REPEATABLE READ behavior.

---

## 2. Theory Review Questions

Answer in your own words (2–4 sentences each):

1. What is a transaction, and why is it important for data integrity?

> [!NOTE]
> **_Your Answer_**
>
> A transaction is a group of SQL statements that are executed as one unit. Either all of them succeed or none of them are applied. It is important because data never stays half updated, for example order created but stock not changed.

2. Explain the Atomicity property using a real-world example (not from the lecture notes).

> [!NOTE]
> **_Your Answer_**
>
> Buying a concert ticket online: money is taken from your card and a seat is reserved for you. If the seat reservation fails, the payment must also be cancelled, so you don't pay for a seat you didn't get. Both steps happen together or not at all.
>
> 3. What does Isolation guarantee? Why is it needed in a multi-user system?

> [!NOTE]
> **_Your Answer_**
>
> Isolation guarantees that transactions running at the same time don't see each other's unfinished changes and don't interfere with each other. It is needed because in a multi-user system many people read and write the same data at once, and without it they could corrupt each other's work.

4. What is the difference between COMMIT and ROLLBACK?

> [!NOTE]
> **_Your Answer_**
>
> COMMIT saves all changes made in the transaction permanently to the database. ROLLBACK cancels all changes made in the transaction and returns the data to the state it was before BEGIN.

5. Explain what a SAVEPOINT is and give a scenario where it's useful.

> [!NOTE]
> **_Your Answer_**
>
> SAVEPOINT is a marker inside a transaction that you can roll back to without cancelling the whole transaction (ROLLBACK TO SAVEPOINT). For example when creating an order, you can set a savepoint before updating stock, so if the stock update fails you only undo that part and keep the order insert.
>
> 6. What is a dirty read? Why does PostgreSQL never allow it?

> [!NOTE]
> **_Your Answer_**
>
> A dirty read is when a transaction reads data that another transaction changed but has not committed yet. PostgreSQL never allows it because of MVCC, it only shows committed row versions, and even READ UNCOMMITTED behaves like READ COMMITTED.

7. Describe the lost update problem. How can SELECT FOR UPDATE prevent it?

> [!NOTE]
> **_Your Answer_**
>
> Lost update happens when two transactions read the same value, both calculate a new value and write it back, so the second write overwrites the first one. SELECT FOR UPDATE locks the selected rows, so the second transaction has to wait until the first one commits and then reads the updated value.

8. What is the default isolation level in PostgreSQL? What concurrency problems does it still allow?

> [!NOTE]
> **_Your Answer_**
>
> Default isolation level is READ COMMITTED. It still allows non-repeatable reads, phantom reads and lost updates (if you don't use locking).

9. Explain MVCC in one paragraph: what is it, and what advantage does it provide?

> [!NOTE]
> **_Your Answer_**
>
> MVCC (Multi-Version Concurrency Control) means PostgreSQL keeps multiple versions of a row instead of overwriting it right away. Each transaction sees a snapshot of committed data at a certain moment. The advantage is that readers don't block writers and writers don't block readers, so many users can work at the same time without waiting.

10. What is a deadlock, and how does PostgreSQL handle it when one is detected?

> [!NOTE]
> **_Your Answer_**
>
> A deadlock is when two transactions are waiting for each other to release locks, so neither of them can continue. PostgreSQL detects it automatically and cancels one of the transactions with an error, so the other one can finish.

---

## 3. Scenario Analysis (Optional)

> [!TIP]
> **Recommended practice.** Do this section. It is not required to finish the TrailShop project. It prepares you for the exams.

For each scenario, identify: (a) which concurrency problem occurs, and (b) at which isolation level(s) it can happen.

### Scenario A

Transaction 1 reads customer 5's order count (3 orders). Transaction 2 inserts a new order for customer 5 and commits. Transaction 1 reads customer 5's order count again and gets 4.

### Scenario B

Transaction 1 reads product 101's price (€89.99). Transaction 2 updates product 101's price to €79.99 but then rolls back. If Transaction 1 had somehow seen €79.99, what problem would that be?

### Scenario C

Two warehouse workers simultaneously check stock for product 101 (both see 10). Worker A ships 3 units and sets stock to 7. Worker B ships 4 units and sets stock to 6. The correct stock should be 3.

---

## 4. Transaction Writing (Optional)

> [!TIP]
> **Recommended practice.** Do this section. It is not required to finish the TrailShop project. It prepares you for the exams.

Write complete SQL transactions for the following TrailShop scenarios. Include BEGIN, appropriate operations, error handling (SAVEPOINT where useful), and COMMIT.

### Transaction 1: Bulk Price Update

Update the price of all products in the "Footwear" category by +10%. If any product's new price would exceed €200, rollback the entire update.

### Transaction 2: Customer Account Deletion

Delete a customer and all their associated data:

1. Delete their order_items (for all their orders)

> [!NOTE]
> **_Your Answer_**
>
> _(Write your answer here.)_
>
> 2. Delete their orders

> [!NOTE]
> **_Your Answer_**
>
> _(Write your answer here.)_
>
> 3. Delete the customer record

> [!NOTE]
> **_Your Answer_**
>
> _(Write your answer here.)_

Use SAVEPOINTs between each step in case of errors.

### Transaction 3: Inventory Restock

Restock 3 products (add specific quantities to stock). Use SELECT FOR UPDATE to lock the rows first, preventing lost updates. Include a check that the new stock doesn't exceed a maximum (e.g., 200).

---

## 5. True/False

For each statement, write TRUE or FALSE and briefly explain why.

1. In PostgreSQL, a single SQL statement outside of an explicit BEGIN/COMMIT is not a transaction. FALSE. PostgreSQL uses autocommit, so every single statement runs as its own transaction.
2. ROLLBACK undoes all changes made since the last SAVEPOINT. FALSE. ROLLBACK undoes the whole transaction, to undo only to a savepoint you need ROLLBACK TO SAVEPOINT.
3. At READ COMMITTED isolation level, a transaction can never see another transaction's uncommitted changes. TRUE. It only sees data that is already committed, so dirty reads are not possible.
4. REPEATABLE READ in PostgreSQL prevents phantom reads. TRUE. In PostgreSQL the transaction uses one snapshot for the whole time, so new rows from other transactions are not visible.
5. SELECT FOR UPDATE blocks other SELECT statements on the same rows. FALSE. Normal SELECTs still work because of MVCC, it only blocks other UPDATE, DELETE and SELECT FOR UPDATE on those rows.
6. If a deadlock occurs, PostgreSQL will wait indefinitely for it to resolve. FALSE. PostgreSQL detects the deadlock and aborts one of the transactions.
7. MVCC means PostgreSQL keeps multiple versions of each row, allowing readers and writers to work concurrently without blocking. TRUE. Readers see an older committed version while the writer creates a new one.
8. Once a transaction is committed, its changes can be undone with ROLLBACK. FALSE. After COMMIT changes are permanent, you would need a new transaction to change the data back.

---

## Submission Checklist

**Required**

- [X] Order transaction written and tested, including the insufficient-stock rollback (Task 1.1)
- [X] Theory review questions answered
- [X] True/False questions answered with a short explanation

**Recommended practice**

- [ ] READ COMMITTED, locking, and isolation-level experiments documented (Tasks 1.2–1.4)
- [ ] Scenario analysis completed
- [ ] Extra transactions written

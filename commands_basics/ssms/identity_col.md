#  Identity Columns in SQL Server

## 1. Introduction

In SQL Server, an **Identity Column** is used to automatically generate unique numeric values for each new row inserted into a table.
It is most commonly used as a **primary key** to uniquely identify records without requiring manual input.

---

## 2. Purpose and Use Case

Identity columns are useful when:

* You need **auto-generated, sequential identifiers** for rows (e.g., CustomerID, EmployeeID).
* You want to **avoid manual entry** of key values.
* You require **guaranteed uniqueness** within a table.

Example use cases:

* Assigning customer IDs in registration systems.
* Generating invoice or order numbers automatically.

---

## 3. Structure and Syntax

An identity column is defined using the `IDENTITY(seed, increment)` property:

```sql
CREATE TABLE Employees (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeName VARCHAR(50)
);
```

| Term          | Meaning                              | Example |
| ------------- | ------------------------------------ | ------- |
| **Seed**      | Starting value of the sequence       | `1`     |
| **Increment** | Step value added for each new record | `1`     |

**Result:**

| Inserted Row | EmployeeID |
| ------------ | ---------- |
| John         | 1          |
| Tom          | 2          |
| Sara         | 3          |

---

## 4. Behavior and Characteristics

### 4.1 Auto-Increment Nature

* SQL Server **automatically assigns** the next sequential number.
* Users do **not** need to provide values for identity columns during insertion.

```sql
INSERT INTO Employees (EmployeeName) VALUES ('Jane');
-- SQL Server automatically assigns EmployeeID = 4
```

---

### 4.2 Primary Key Association

Although identity columns are commonly used as **primary keys**, SQL Server does **not automatically** make them so.
The `PRIMARY KEY` constraint must be explicitly defined.

---

### 4.3 One Identity Column per Table

A table can have **only one** identity column.
Attempting to define multiple identity columns results in an error.

---

## 5. Supplying Explicit Values

By default, SQL Server prevents manual entry into identity columns.
To explicitly insert a value, two steps are required:

```sql
SET IDENTITY_INSERT Employees ON;

INSERT INTO Employees (EmployeeID, EmployeeName)
VALUES (10, 'David');

SET IDENTITY_INSERT Employees OFF;
```

**Rules:**

* Must specify column names in the insert statement.
* Only **one table per database** can have `IDENTITY_INSERT` turned ON at a time.

---

## 6. Resetting and Managing Identity Values

### 6.1 Deletion vs. Truncation

* **DELETE:** Removes rows but **retains the last identity value**.
* **TRUNCATE TABLE:** Removes all rows and **resets identity** to the seed.

Example:

```sql
TRUNCATE TABLE Employees;
-- Next inserted record will restart from seed (e.g., 1)
```

---

### 6.2 Manually Resetting Identity Values

If you delete all rows and want to restart identity numbering manually, use the **DBCC CHECKIDENT** command.

```sql
DBCC CHECKIDENT ('Employees', RESEED, 0);
```

The next inserted record will receive the value `1` (since increment = 1).

---

### 6.3 Custom Reseeding

You can reseed to any desired value:

```sql
DBCC CHECKIDENT ('Employees', RESEED, 100);
```

Next inserted record will get `101`.

---

## 7. Retrieving the Last Generated Identity Value

| Function                     | Description                                                    | Scope                   |
| ---------------------------- | -------------------------------------------------------------- | ----------------------- |
| `SCOPE_IDENTITY()`           | Returns last identity value within current session & scope     | ✅ Recommended           |
| `@@IDENTITY`                 | Returns last identity from current session, including triggers | ⚠️ Risky                |
| `IDENT_CURRENT('TableName')` | Returns last identity value for a specific table, any session  | ✅ Useful for audit logs |

Example:

```sql
INSERT INTO Employees (EmployeeName) VALUES ('Chris');
SELECT SCOPE_IDENTITY();  -- Returns the ID generated for Chris
```

---

## 8. Interaction with Default Constraints

If a column is marked as an **Identity**, any **DEFAULT constraint** specified for that column is **ignored**.
The identity mechanism always takes precedence.

Example:

```sql
CREATE TABLE Test (
    ID INT IDENTITY(1,1) DEFAULT 100  -- DEFAULT ignored
);
```

However, default constraints can still apply to **non-identity columns** within the same table.

---

## 9. Custom and Negative Sequences

Identity columns are not limited to positive increments.
You can define **custom or reverse sequences**:

```sql
CREATE TABLE Orders (
    OrderID INT IDENTITY(1000, 10),
    OrderDesc VARCHAR(50)
);
-- Generates: 1000, 1010, 1020, ...

CREATE TABLE ReverseCount (
    ID INT IDENTITY(10, -2)
);
-- Generates: 10, 8, 6, ...
```

---

## 10. Modifying Identity Columns

Once created, the `IDENTITY` property **cannot be added, removed, or altered** directly.
To modify it, you must:

1. Create a new table or column.
2. Transfer existing data.
3. Drop the old column/table if needed.

---

## 11. Summary Table

| Concept                | Description                           | Example                       |
| ---------------------- | ------------------------------------- | ----------------------------- |
| **Definition**         | Auto-generates sequential values      | `IDENTITY(1,1)`               |
| **Seed / Increment**   | Controls starting and step values     | `(100, 5)` → 100, 105, 110    |
| **Explicit Insert**    | Requires `SET IDENTITY_INSERT ON`     | Manual value insertion        |
| **Reset Identity**     | `DBCC CHECKIDENT` or `TRUNCATE TABLE` | Reseed or restart             |
| **Default Constraint** | Ignored for identity columns          | Only applies to non-identity  |
| **Last Value**         | `SCOPE_IDENTITY()`                    | Retrieve recent identity      |
| **Custom Values**      | Negative or large increments allowed  | `(1000, -10)`                 |
| **Modification**       | Cannot alter after creation           | Must recreate                 |
| **Uniqueness**         | Commonly combined with `PRIMARY KEY`  | Enforces unique, non-null IDs |

---

## 12. Conclusion

Identity columns provide a **simple and efficient mechanism** for generating unique numeric identifiers in SQL Server.
They reduce manual input, ensure uniqueness, and simplify database design.
Understanding how to **control, reset, and manage** identity behavior is essential for maintaining data integrity and consistency, especially in transactional systems.



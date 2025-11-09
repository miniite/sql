
# **Primary Key vs Unique Key Constraints in SQL**

## **Introduction**

In relational databases, maintaining data accuracy and integrity is crucial. One of the most effective ways to ensure this is through the use of **constraints** — rules that govern the values stored in database tables.

Among these, **Primary Key** and **Unique Key** constraints are fundamental in enforcing **uniqueness** of data within a table. While both prevent duplicate entries, they differ in purpose, limitations, and usage. This article explores their definitions, differences, practical use cases, and implementation.

---

## **1. Understanding Primary Key Constraint**

A **Primary Key** is a column (or a set of columns) that uniquely identifies every row in a table. It ensures that:

* Each record can be distinctly recognized.
* No two rows share the same key value.
* The key column does not contain `NULL` values.

Since a table represents a unique set of records, it can have **only one Primary Key**, though that key can include multiple columns (a composite key).

### **Example:**

```sql
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Name NVARCHAR(100),
    Department NVARCHAR(50)
);
```

In this example:

* `EmployeeID` uniquely identifies each employee.
* It cannot be `NULL` or repeated.
* SQL Server automatically creates a **clustered index** for the Primary Key (by default).

---

## **2. Understanding Unique Key Constraint**

A **Unique Key** constraint also enforces data uniqueness, ensuring that the values in the specified column(s) are distinct. However, unlike a Primary Key:

* A table can have **multiple Unique Keys**.
* A Unique Key **can accept a single NULL value**.
* It usually creates a **non-clustered index** by default.

Unique Keys are commonly used for attributes that must remain unique but are not the main identifier of a record (for example, an email address or social security number).

### **Example:**

```sql
CREATE TABLE Persons (
    PersonID INT PRIMARY KEY,
    Name NVARCHAR(100),
    Email NVARCHAR(100) UNIQUE
);
```

Here:

* `PersonID` acts as the Primary Key.
* `Email` has a Unique Key constraint — ensuring no two people share the same email, while allowing one `NULL` value if necessary.

---

## **3. Key Differences Between Primary Key and Unique Key**

| **Aspect**                   | **Primary Key**                                   | **Unique Key**                                   |
| ---------------------------- | ------------------------------------------------- | ------------------------------------------------ |
| **Purpose**                  | Uniquely identifies each record in a table        | Ensures uniqueness of data in a column           |
| **Number Allowed per Table** | Only **one** Primary Key                          | **Multiple** Unique Keys allowed                 |
| **NULL Values**              | Not allowed                                       | Allows **one NULL**                              |
| **Index Type (Default)**     | Clustered Index                                   | Non-Clustered Index                              |
| **Enforcement Level**        | Enforces both uniqueness and non-nullability      | Enforces uniqueness but allows one null entry    |
| **Use Case Example**         | Record identifier such as `EmployeeID`, `OrderID` | Attributes like `Email`, `PhoneNumber`, or `SSN` |

---

## **4. When to Use Each Constraint**

| **Scenario**                                                                    | **Recommended Constraint** |
| ------------------------------------------------------------------------------- | -------------------------- |
| You need a unique identifier for each row                                       | **Primary Key**            |
| You already have a Primary Key but want to ensure uniqueness for another column | **Unique Key**             |
| You want to maintain unique business attributes (email, passport number, etc.)  | **Unique Key**             |

---

## **5. Creating a Unique Key in SQL Server**

You can define a Unique Key constraint either through the **SQL Server Management Studio (SSMS)** interface or directly using a SQL query.

### **a. Using SSMS Designer**

1. Right-click on the target table → **Design**
2. Right-click again → **Indexes/Keys**
3. Click **Add** and choose **Unique Key**
4. Select the column (e.g., `Email`)
5. Save the table to apply the constraint

### **b. Using SQL Query**

```sql
ALTER TABLE TBL_Person
ADD CONSTRAINT UQ_TBL_Person_Email
UNIQUE (Email);
```

In this command:

* `UQ_TBL_Person_Email` is a descriptive name for the constraint.
* The column `Email` is enforced to store only unique values.

---

## **6. Handling Constraint Violations**

When a user attempts to insert a duplicate value into a column governed by a Unique Key, SQL Server returns a constraint violation error.

### **Example:**

```sql
INSERT INTO TBL_Person (ID, Name, Email)
VALUES (1, 'John', 'a@a.com');

INSERT INTO TBL_Person (ID, Name, Email)
VALUES (2, 'Jane', 'a@a.com');
```

**Output:**

```
Violation of UNIQUE KEY constraint 'UQ_TBL_Person_Email'.
Cannot insert duplicate key in object 'dbo.TBL_Person'.
```

This ensures that no two rows have the same email address.

---

## **7. Dropping a Unique Key Constraint**

To remove a Unique Key constraint, use the following command:

```sql
ALTER TABLE TBL_Person
DROP CONSTRAINT UQ_TBL_Person_Email;
```

Once dropped, duplicate entries can again be inserted into that column.

---

## **8. Practical Example: Combining Constraints**

Consider the following table:

```sql
CREATE TABLE TBL_Person (
    ID INT PRIMARY KEY,
    Name NVARCHAR(100),
    Email NVARCHAR(100),
    GenderID INT,
    Age INT
);
```

To enforce that each `Email` is unique:

```sql
ALTER TABLE TBL_Person
ADD CONSTRAINT UQ_TBL_Person_Email UNIQUE (Email);
```

This setup:

* Uses `ID` as the unique identifier (Primary Key).
* Ensures `Email` remains unique across all records.

---

## **9. Summary**

| **Concept**                          | **Description**                                                                 |
| ------------------------------------ | ------------------------------------------------------------------------------- |
| **Primary Key**                      | Ensures each record is unique and non-null; only one per table.                 |
| **Unique Key**                       | Ensures unique values in a column; allows one NULL; multiple allowed per table. |
| **Clustered vs Non-Clustered Index** | Primary Key → Clustered; Unique Key → Non-Clustered.                            |
| **Constraint Violation**             | Duplicate entries or NULLs (for Primary Key) trigger an error.                  |

---

## **Conclusion**

Both **Primary Key** and **Unique Key** constraints play a vital role in maintaining **data integrity and consistency**.

* Use a **Primary Key** to uniquely identify each record in the table.
* Use **Unique Keys** to enforce uniqueness on other important fields that should not duplicate (like Email, Phone, or National ID).

Understanding how and when to apply these constraints is an essential skill for designing reliable, professional, and well-structured databases.



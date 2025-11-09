
## **Advanced Joins in SQL Server: Retrieving Non-Matching Rows**

### **1. Introduction**

In SQL, **joins** allow you to combine data from multiple tables based on related columns.
While basic joins like **INNER**, **LEFT**, **RIGHT**, and **FULL** are commonly used to connect tables, certain scenarios require fetching **only the non-matching rows** — data present in one table but not in the other.

This article covers how to retrieve such **non-matching records** using join logic in SQL Server, and briefly introduces **CROSS JOIN**, which behaves differently from the others.

---

### **2. Recap of Join Types**

| **Join Type**       | **Description**                                                               | **Result Set Includes**                      |
| ------------------- | ----------------------------------------------------------------------------- | -------------------------------------------- |
| **INNER JOIN**      | Returns only rows where there is a match between both tables.                 | Matching rows only                           |
| **LEFT JOIN**       | Returns all rows from the left table and matching rows from the right table.  | Matching + non-matching left rows            |
| **RIGHT JOIN**      | Returns all rows from the right table and matching rows from the left table.  | Matching + non-matching right rows           |
| **FULL OUTER JOIN** | Returns all rows from both tables, whether matching or not.                   | Matching + non-matching rows from both sides |
| **CROSS JOIN**      | Returns all possible combinations between the two tables (Cartesian product). | Every row from left × every row from right   |

---

### **3. Retrieving Only Non-Matching Rows**

In normal use, **LEFT**, **RIGHT**, and **FULL OUTER JOIN** include both matching and non-matching rows.
However, you can extract **only the non-matching rows** by adding a `WHERE` condition that checks for `NULL` in the foreign key column — which indicates no matching record.

---

#### **3.1 Non-Matching Rows from the Left Table**

To get only non-matching rows from the **left table**:

```sql
SELECT 
    e.Name, e.Gender, e.Salary, d.DepartmentName
FROM 
    TBL_Employee e
LEFT JOIN 
    TBL_Department d
ON 
    e.DepartmentID = d.DepartmentID
WHERE 
    d.DepartmentID IS NULL;
```

**Explanation:**

* The `LEFT JOIN` retrieves all employees, even those without departments.
* The condition `d.DepartmentID IS NULL` filters out matching records.
* Result: employees without a corresponding department.

---

#### **3.2 Non-Matching Rows from the Right Table**

To get only non-matching rows from the **right table**:

```sql
SELECT 
    e.Name, d.DepartmentName
FROM 
    TBL_Employee e
RIGHT JOIN 
    TBL_Department d
ON 
    e.DepartmentID = d.DepartmentID
WHERE 
    e.DepartmentID IS NULL;
```

**Explanation:**

* The `RIGHT JOIN` retrieves all departments and their employees (if any).
* The `WHERE e.DepartmentID IS NULL` filters out departments that already have employees.
* Result: departments without employees.

---

#### **3.3 Non-Matching Rows from Both Tables**

To get all **unmatched records** (from both sides):

```sql
SELECT 
    e.Name, d.DepartmentName
FROM 
    TBL_Employee e
FULL JOIN 
    TBL_Department d
ON 
    e.DepartmentID = d.DepartmentID
WHERE 
    e.DepartmentID IS NULL 
    OR d.DepartmentID IS NULL;
```

**Explanation:**

* `FULL JOIN` returns all data from both tables.
* The `WHERE` clause keeps only records without matches on either side.
* Result: employees without departments **and** departments without employees.

---

### **4. Important: Handling NULLs**

In SQL Server, `NULL` represents *unknown* or *missing* data.
When filtering for unmatched rows:

* ✅ Always use `IS NULL` or `IS NOT NULL`.
* ❌ Never use `=` or `<>` with NULL, as these will return no results.

**Example (Correct):**

```sql
WHERE DepartmentID IS NULL
```

**Example (Incorrect):**

```sql
WHERE DepartmentID = NULL
```

---

### **5. CROSS JOIN Explained**

A **CROSS JOIN** combines every row from one table with every row from another, forming a **Cartesian product**.

**Syntax:**

```sql
SELECT 
    e.Name, d.DepartmentName
FROM 
    TBL_Employee e
CROSS JOIN 
    TBL_Department d;
```

**Example:**
If `TBL_Employee` has 10 rows and `TBL_Department` has 5, the result will have **10 × 5 = 50 rows**.

**Key Characteristics:**

* No `ON` condition is used.
* No concept of “matching” or “non-matching” rows — hence **no NULL filtering applies**.
* Commonly used for generating combinations (e.g., schedules, matrix reports).

| **Aspect**         | **CROSS JOIN**            | **Other Joins**                  |
| ------------------ | ------------------------- | -------------------------------- |
| **Join Condition** | None                      | Required (e.g., `A.ID = B.ID`)   |
| **Output Size**    | Cartesian product (A × B) | Depends on key matches           |
| **NULL Relevance** | None                      | Determines non-matching rows     |
| **Common Use**     | Generate all combinations | Retrieve or compare related data |

---

### **6. Summary of Join Behaviors**

| **Objective**                 | **Join Type**     | **Condition Used**                            | **Result**                               |
| ----------------------------- | ----------------- | --------------------------------------------- | ---------------------------------------- |
| Only matching rows            | `INNER JOIN`      | —                                             | Intersection of both tables              |
| All rows from left + matches  | `LEFT JOIN`       | —                                             | All left rows, matched data if present   |
| All rows from right + matches | `RIGHT JOIN`      | —                                             | All right rows, matched data if present  |
| All rows from both            | `FULL OUTER JOIN` | —                                             | All data, with NULLs for missing matches |
| Only non-matching left rows   | `LEFT JOIN`       | `WHERE right_table.key IS NULL`               | Left-only records                        |
| Only non-matching right rows  | `RIGHT JOIN`      | `WHERE left_table.key IS NULL`                | Right-only records                       |
| Non-matching from both sides  | `FULL OUTER JOIN` | `WHERE left.key IS NULL OR right.key IS NULL` | All unmatched records                    |

---

### **7. Key Takeaways**

* Use **LEFT**, **RIGHT**, and **FULL OUTER JOIN** with `IS NULL` filters to isolate non-matching rows.
* Avoid using equality (`=`) with NULLs — always use `IS NULL`.
* **CROSS JOIN** has no concept of NULL or matching data, as it produces every possible row combination.
* For efficiency, use only the join type necessary for your requirement — e.g., prefer `LEFT JOIN` for left-side non-matches instead of full joins.

---


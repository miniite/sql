

# SQL Server — Sorting Results and Using the TOP Clause

### **1. Sorting Query Results with ORDER BY**

* The `ORDER BY` clause sorts the results of a query **based on one or more columns**.
* **Default sorting** is in **ascending order (ASC)**.
* You can explicitly sort in **descending order (DESC)** using the keyword `DESC`.

**Example:**

```sql
SELECT * FROM TBL_Person ORDER BY Name;
```

👉 Sorts all records by `Name` in ascending (A–Z) order.

**Descending Order Example:**

```sql
SELECT * FROM TBL_Person ORDER BY Name DESC;
```

### **2. Sorting by Multiple Columns**

* You can sort results by **more than one column**.
* The first column determines the main order, and the second column applies when there are duplicates in the first.

**Example:**

```sql
SELECT * FROM TBL_Person
ORDER BY Name DESC, Age ASC;
```

👉 Sorts by `Name` (Z–A). If two people share the same name, those rows are further sorted by `Age` (smallest to largest).

---

### **3. Selecting a Subset of Rows with the TOP Keyword**

The `TOP` keyword limits the number (or percentage) of rows returned in the result set — very useful when working with **large tables** or when you only need a **sample or top results**.

#### **a. Selecting Top N Rows**

```sql
SELECT TOP 2 * FROM TBL_Person;
```

👉 Returns only the **first 2 records** from the result set.

#### **b. Selecting Top N Percentage of Rows**

```sql
SELECT TOP 50 PERCENT * FROM TBL_Person;
```

👉 Returns the **top 50% of rows** from the total dataset.
This is often used for sampling data.

---

### **4. Combining TOP with ORDER BY**

`TOP` works best when used with `ORDER BY` — to ensure that you’re selecting the “top” based on a particular **criterion**.

**Example: Find the eldest person**

```sql
SELECT TOP 1 * 
FROM TBL_Person
ORDER BY Age DESC;
```

👉 Sorts all people by age in descending order and then picks **only the first (oldest)** record.

**Similarly:**

* To find the **highest salary**:

  ```sql
  SELECT TOP 1 * FROM Employee ORDER BY Salary DESC;
  ```
* To find the **youngest employee**:

  ```sql
  SELECT TOP 1 * FROM Employee ORDER BY Age ASC;
  ```

---

### **5. Practical Uses of TOP**

* Quickly preview data from a large table.
* Find top or bottom performers (e.g., highest marks, top customers, etc.).
* Use in **subqueries** to retrieve best-performing items or most recent records.

---

✅ **Key Takeaways**

* Use `ORDER BY` to organize query results logically.
* Use `TOP` to control how many rows you see.
* Combine them to extract **specific ranked results** (like “top 3 salaries”).
* `TOP` supports both **absolute numbers** (e.g., `TOP 5`) and **percentages** (e.g., `TOP 10 PERCENT`).


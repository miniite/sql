
# Inline Table-Valued Functions (TVFs) in SQL Server 
## Introduction

In SQL Server, functions are reusable database objects designed to encapsulate logic and return values based on given inputs. While **scalar functions** return a single value (such as an integer, string, or date), **table-valued functions (TVFs)** return an entire result set in the form of a table.
This article focuses on **Inline Table-Valued Functions (iTVFs)** — their creation, usage, advantages, and scenarios where they serve as a powerful alternative to parameterized views.

---

## Understanding Inline Table-Valued Functions

An **Inline Table-Valued Function (iTVF)** is a type of user-defined function that returns a **table** as its output. Unlike scalar functions, which return only one value, iTVFs can return multiple rows and columns.

Key characteristics include:

* Defined using the `CREATE FUNCTION` statement.
* Accepts parameters like other functions.
* Uses the `RETURNS TABLE` clause to indicate that it returns a table.
* Contains a **single SELECT statement** — there are no `BEGIN` or `END` blocks.
* The structure of the returned table is determined by the **SELECT statement** inside the function.

---

## Example: Creating an Inline Table-Valued Function

Suppose we have an **Employees** table:

| ID | Name  | DateOfBirth | Gender | DepartmentID |
| -- | ----- | ----------- | ------ | ------------ |
| 1  | John  | 1990-01-10  | Male   | 2            |
| 2  | Sara  | 1988-07-25  | Female | 1            |
| 3  | David | 1992-03-16  | Male   | 3            |

We can create a TVF that returns employees filtered by gender:

```sql
CREATE FUNCTION dbo.FN_EmployeesByGender(@Gender NVARCHAR(10))
RETURNS TABLE
AS
RETURN
(
    SELECT ID, Name, DateOfBirth, Gender, DepartmentID
    FROM dbo.TBL_Employees
    WHERE Gender = @Gender
);
```

### Key Points:

1. **@Gender** is a parameter input to the function.
2. The **RETURNS TABLE** clause specifies that the function returns a table.
3. The **SELECT** statement defines the structure of the returned table.
4. No `BEGIN` or `END` keywords are allowed — the query must be a single inline SELECT statement.

---

## Calling an Inline Table-Valued Function

Since iTVFs return a table, they can be queried just like any other table or view.

```sql
SELECT * FROM dbo.FN_EmployeesByGender('Male');
```

This statement returns all male employees. Similarly:

```sql
SELECT * FROM dbo.FN_EmployeesByGender('Female');
```

will return all female employees.

---

## Treating iTVFs as Tables

You can perform additional operations on the returned result just as you would with a physical table:

### 1. Using WHERE Clause

```sql
SELECT * 
FROM dbo.FN_EmployeesByGender('Male')
WHERE Name = 'David';
```

### 2. Joining with Other Tables

You can join the function output with other tables since it returns a tabular dataset:

```sql
SELECT e.Name, e.Gender, d.DepartmentName
FROM dbo.FN_EmployeesByGender('Male') e
JOIN dbo.TBL_Department d
ON e.DepartmentID = d.DepartmentID;
```

This flexibility makes iTVFs an excellent tool for modular, reusable query design.

---

## Comparing Inline TVFs with Scalar Functions

| Aspect               | Scalar Function                           | Inline Table-Valued Function            |
| -------------------- | ----------------------------------------- | --------------------------------------- |
| Return Type          | Single scalar value (int, nvarchar, etc.) | Table (multiple rows & columns)         |
| Usage Context        | In SELECT, WHERE, or computed column      | In FROM clause, JOINs, or subqueries    |
| Syntax               | Requires `BEGIN...END` block              | No `BEGIN` or `END` block               |
| Performance          | Slower (executes row-by-row)              | Optimized by SQL Server query optimizer |
| Structure Definition | Defined by return data type               | Defined by internal SELECT statement    |

---

## Selecting Specific Columns from a TVF

Since an Inline Table-Valued Function behaves like a **virtual table**, you can easily select specific columns from it instead of fetching all columns.

### Example

Using the same function:

```sql
SELECT Name, DepartmentID
FROM dbo.FN_EmployeesByGender('Male');
```

This retrieves only the **Name** and **DepartmentID** columns, just like querying a physical table.

You can also apply standard SQL clauses such as:

```sql
SELECT Name
FROM dbo.FN_EmployeesByGender('Male')
WHERE DepartmentID = 3
ORDER BY Name;
```

Or even use it in joins:

```sql
SELECT e.Name, d.DepartmentName
FROM dbo.FN_EmployeesByGender('Female') e
JOIN dbo.TBL_Department d
ON e.DepartmentID = d.DepartmentID;
```

### Important Notes:

* You **cannot** select columns not defined within the TVF’s internal SELECT statement.
* The output schema is strictly determined by the columns listed in the function definition.

---

## Practical Use Cases of Inline TVFs

1. **Parameterized Views**: Inline TVFs serve as replacements for parameterized views, which SQL Server doesn’t natively support.
2. **Simplifying Complex Queries**: Encapsulate repetitive logic into reusable, parameter-driven functions.
3. **Performance Optimization**: Inline TVFs are expanded by the SQL Server optimizer, often yielding better performance than scalar functions or multi-statement TVFs.
4. **Joining and Filtering**: Use them in joins or nested queries without sacrificing execution speed.

---

## Conclusion

Inline Table-Valued Functions in SQL Server are an elegant, efficient, and modular way to return table-form results from parameterized logic.
They combine the flexibility of stored queries with the performance efficiency of SQL’s native optimization engine.
By understanding their syntax, limitations, and usage, database developers can design cleaner, faster, and more maintainable data access layers.


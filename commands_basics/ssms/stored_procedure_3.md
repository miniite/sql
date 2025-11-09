# **Stored Procedures in SQL Server – Part 3: Advanced Parameter Handling and Multiple Output Scenarios**

## **1. Introduction**

As discussed in earlier parts of this series, stored procedures (SPs) enhance SQL Server’s performance, reusability, and maintainability.
In this section, we progress to **advanced parameter handling**, focusing on how to effectively use **multiple OUTPUT parameters**, control **conditional logic**, and integrate **validation and decision-making** within stored procedures.

Understanding these techniques allows developers to design flexible, modular, and business-oriented SQL operations.

---

## **2. Revisiting Parameters in Stored Procedures**

Stored procedures can accept **input**, **output**, and **return values**, enabling two-way communication between the application and database.
While input parameters customize execution, **multiple output parameters** allow a single procedure to return several related values at once.

This reduces the need for multiple queries and improves performance by encapsulating all required results within one execution.

---

## **3. Using Multiple OUTPUT Parameters**

A stored procedure can return **more than one output value**, each corresponding to a specific variable declared in the caller.

### **3.1 Example – Returning Multiple Employee Details**

```sql
CREATE PROCEDURE spGetEmployeeProfile
    @EmpID INT,
    @EmpName NVARCHAR(100) OUTPUT,
    @Dept NVARCHAR(50) OUTPUT,
    @Salary MONEY OUTPUT,
    @Experience INT OUTPUT
AS
BEGIN
    SELECT
        @EmpName = Name,
        @Dept = Department,
        @Salary = Salary,
        @Experience = DATEDIFF(YEAR, JoinDate, GETDATE())
    FROM Employees
    WHERE EmployeeID = @EmpID;
END
```

### **Execution:**

```sql
DECLARE 
    @Name NVARCHAR(100),
    @Dept NVARCHAR(50),
    @Sal MONEY,
    @Exp INT;

EXEC spGetEmployeeProfile 
    @EmpID = 105,
    @EmpName = @Name OUTPUT,
    @Dept = @Dept OUTPUT,
    @Salary = @Sal OUTPUT,
    @Experience = @Exp OUTPUT;

PRINT 'Name: ' + @Name;
PRINT 'Department: ' + @Dept;
PRINT 'Salary: ' + CAST(@Sal AS NVARCHAR(20));
PRINT 'Experience: ' + CAST(@Exp AS NVARCHAR(10)) + ' years';
```

### **Result**

```
Name: John Mathews  
Department: Finance  
Salary: 58000  
Experience: 6 years
```

Here, one stored procedure efficiently returns **four values** — demonstrating its ability to serve as a single point of computation for complex business logic.

---

## **4. Conditional Logic: IF...ELSE and CASE**

Stored procedures often need to make decisions based on parameter values or query results.
SQL Server provides two ways to handle such logic:

### **4.1 Using IF...ELSE**

```sql
CREATE PROCEDURE spCheckEmployeeStatus
    @EmpID INT,
    @Status NVARCHAR(20) OUTPUT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Employees WHERE EmployeeID = @EmpID AND IsActive = 1)
        SET @Status = 'Active';
    ELSE
        SET @Status = 'Inactive';
END
```

**Execution:**

```sql
DECLARE @EmpStatus NVARCHAR(20);
EXEC spCheckEmployeeStatus @EmpID = 102, @Status = @EmpStatus OUTPUT;
PRINT @EmpStatus;
```

**Output:**

```
Active
```

The **IF...ELSE** construct is suitable when evaluating logical conditions that may alter control flow.

---

### **4.2 Using CASE for Inline Decisions**

For column-level evaluations or return calculations, `CASE` can be used inside queries.

```sql
CREATE PROCEDURE spGetSalaryCategory
    @EmpID INT,
    @Category NVARCHAR(20) OUTPUT
AS
BEGIN
    DECLARE @Salary MONEY;
    SELECT @Salary = Salary FROM Employees WHERE EmployeeID = @EmpID;

    SET @Category = CASE
        WHEN @Salary >= 80000 THEN 'High'
        WHEN @Salary BETWEEN 40000 AND 79999 THEN 'Medium'
        ELSE 'Low'
    END;
END
```

While **CASE** is inline and compact, **IF...ELSE** is preferred for procedural or multi-step logic.

---

## **5. Combining RETURN and OUTPUT Values**

It is common to combine a **RETURN** value with multiple **OUTPUT** parameters for more descriptive responses.

### **Example**

```sql
CREATE PROCEDURE spProcessEmployeeBonus
    @EmpID INT,
    @Bonus MONEY OUTPUT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Employees WHERE EmployeeID = @EmpID)
        RETURN -1;  -- Invalid ID

    SELECT @Bonus = Salary * 0.10 FROM Employees WHERE EmployeeID = @EmpID;
    RETURN 1;  -- Success
END
```

**Execution:**

```sql
DECLARE @Bonus MONEY, @Result INT;

EXEC @Result = spProcessEmployeeBonus @EmpID = 106, @Bonus = @Bonus OUTPUT;

IF @Result = 1
    PRINT 'Bonus calculated: ' + CAST(@Bonus AS NVARCHAR(20));
ELSE
    PRINT 'Invalid Employee ID';
```

This approach allows both **status reporting** (via `RETURN`) and **data retrieval** (via `OUTPUT`) in the same procedure.

---

## **6. Best Practices for Multiple OUTPUTs**

* Use multiple OUTPUT parameters **only when necessary** — returning a single dataset (e.g., via `SELECT`) is often simpler.
* Always declare **clear, descriptive parameter names**.
* Maintain consistency in data types between input and output parameters.
* Include **validation logic** (using `IF EXISTS` or `TRY...CATCH`) to avoid null or undefined outputs.
* Use OUTPUT parameters to return **business results**, not full datasets — for large data, prefer returning result sets.

---

## **7. Comparison: RETURN vs OUTPUT**

| Feature              | RETURN                      | OUTPUT                                |
| -------------------- | --------------------------- | ------------------------------------- |
| **Purpose**          | Status or success indicator | Return computed or descriptive values |
| **Data Type**        | Always `INT`                | Any SQL data type                     |
| **Number of Values** | Single                      | Multiple                              |
| **Use Case**         | Success/failure tracking    | Returning multiple computed results   |
| **Scope**            | Global to the procedure     | Explicitly defined per variable       |

---

## **8. Summary**

In this part, we expanded the understanding of stored procedures by mastering **multiple OUTPUT parameters**, **conditional logic**, and the **integration of RETURN values**.
These techniques make procedures more powerful and adaptive, allowing developers to design SQL logic that reacts intelligently to input conditions and returns comprehensive results.

In practice, such design patterns reduce network calls, consolidate logic, and promote modular database programming.

The next installment, **Part 4**, will explore the **performance, maintainability, and security advantages** of stored procedures — including execution plan reuse, network efficiency, and protection against SQL injection attacks.



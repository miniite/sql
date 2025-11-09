
# **Stored Procedures in SQL Server – Part 2: Parameters, Return Values, and Modification**

## **1. Introduction**

Building upon the fundamentals discussed in **Part 1**, this section explores how stored procedures handle **parameters**, **output values**, and **return codes**, along with how they can be **modified (ALTERED)** and **secured** using encryption.

Understanding these aspects is essential to writing dynamic, reusable, and secure SQL code that can communicate results between database and application layers.

---

## **2. Parameters in Stored Procedures**

Parameters in stored procedures allow users to pass input values and receive output results.
There are two main types of parameters:

1. **Input Parameters** – Accept values when the procedure is called.
2. **Output Parameters** – Return values from the procedure back to the caller.

---

### **2.1 Input Parameters**

Input parameters are declared within the procedure definition using the `@` symbol. They are used to filter or customize query execution.

**Example:**

```sql
CREATE PROCEDURE spGetEmployeeByDept
    @Department NVARCHAR(50)
AS
BEGIN
    SELECT Name, JobTitle
    FROM Employees
    WHERE Department = @Department;
END
```

**Execution:**

```sql
EXEC spGetEmployeeByDept @Department = 'Finance';
```

This retrieves only employees belonging to the Finance department.

---

### **2.2 Output Parameters**

Output parameters are used to send data **from** the procedure **back to** the caller.
They must be explicitly marked with the **OUTPUT** or **OUT** keyword both during **procedure creation** and **execution**.

**Example:**

```sql
CREATE PROCEDURE spGetEmployeeSalary
    @EmployeeID INT,
    @Salary MONEY OUTPUT
AS
BEGIN
    SELECT @Salary = Salary FROM Employees WHERE EmployeeID = @EmployeeID;
END
```

**Execution:**

```sql
DECLARE @EmpSalary MONEY;
EXEC spGetEmployeeSalary @EmployeeID = 101, @Salary = @EmpSalary OUTPUT;
PRINT @EmpSalary;
```

Here, the stored procedure assigns the employee’s salary to the `@EmpSalary` variable.

---

## **3. Return Values vs. Output Parameters**

SQL Server procedures can return a **single integer value** using the `RETURN` statement or **multiple results** via `OUTPUT` parameters.

| Feature              | RETURN                             | OUTPUT                         |
| -------------------- | ---------------------------------- | ------------------------------ |
| **Data Type**        | Always an `INT`                    | Can be any valid SQL data type |
| **Number of Values** | One                                | Multiple                       |
| **Purpose**          | Indicate success/failure or status | Return computed values         |
| **Usage**            | Simple result or status flag       | Detailed output data           |

### **Example – RETURN**

```sql
CREATE PROCEDURE spCheckEmployeeExists
    @EmpID INT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Employees WHERE EmployeeID = @EmpID)
        RETURN 1;   -- Employee exists
    ELSE
        RETURN 0;   -- Employee not found
END
```

**Execution:**

```sql
DECLARE @Result INT;
EXEC @Result = spCheckEmployeeExists @EmpID = 103;
PRINT @Result;  -- Prints 1 or 0
```

### **Example – OUTPUT with Multiple Variables**

```sql
CREATE PROCEDURE spGetEmployeeDetails
    @EmpID INT,
    @Name NVARCHAR(100) OUTPUT,
    @Department NVARCHAR(50) OUTPUT,
    @Salary MONEY OUTPUT
AS
BEGIN
    SELECT 
        @Name = Name,
        @Department = Department,
        @Salary = Salary
    FROM Employees WHERE EmployeeID = @EmpID;
END
```

This allows multiple outputs to be returned simultaneously — more flexible than a single `RETURN` value.

---

## **4. Altering an Existing Stored Procedure**

Stored procedures can be **modified** without dropping and recreating them using the `ALTER PROCEDURE` statement.

**Example:**

```sql
ALTER PROCEDURE spGetEmployeeByDept
    @Department NVARCHAR(50)
AS
BEGIN
    SELECT Name, JobTitle, Salary
    FROM Employees
    WHERE Department = @Department
    ORDER BY Salary DESC;
END
```

This updates the existing procedure definition while preserving its permissions and dependencies.

---

## **5. Encryption and Modification**

You can secure your stored procedure using the `WITH ENCRYPTION` clause, which hides its definition from tools like `sp_helptext`.

**Example:**

```sql
CREATE PROCEDURE spSensitiveData
WITH ENCRYPTION
AS
BEGIN
    SELECT * FROM ConfidentialReports;
END
```

**Note:**

* Once encrypted, the source code **cannot be viewed** directly in SQL Server.
* However, you can still **ALTER** the procedure, **only if** you have the **original source code** stored elsewhere.
* It’s best practice to **maintain a backup copy** of all stored procedure scripts externally before encrypting them.

---

## **6. Viewing Stored Procedure Details**

SQL Server provides built-in commands to inspect or manage stored procedures.

| Command                | Description                                                      |
| ---------------------- | ---------------------------------------------------------------- |
| `sp_help 'spName'`     | Shows metadata (parameter names, data types, output indicators). |
| `sp_helptext 'spName'` | Displays the SQL definition (hidden if encrypted).               |
| `sp_depends 'spName'`  | Lists dependent tables, views, and objects.                      |

---

## **7. Best Practices**

* Use clear, descriptive names for parameters (e.g., `@CustomerID`, not `@C1`).
* Always specify data types for both input and output parameters.
* Avoid overuse of OUTPUT parameters — use them only when multiple return values are truly required.
* Always **backup** your procedure definitions before applying encryption.
* Keep business logic inside SPs modular and focused on specific tasks.

---

## **8. Summary**

Stored Procedures in SQL Server offer powerful mechanisms to handle **input**, **output**, and **return values**, enabling flexible communication between applications and databases.

They can be modified safely using `ALTER PROCEDURE`, and encryption ensures that sensitive logic remains secure.
Understanding the distinction between RETURN values and OUTPUT parameters helps developers design efficient and maintainable procedures.

This concludes **Part 2** of the Stored Procedure series.
Next, **Part 3** will explore **advanced parameter handling, multiple OUTPUT scenarios, and real-world implementation examples**.


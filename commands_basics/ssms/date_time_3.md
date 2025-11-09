
# SQL Server Date Functions – Part 3 : Working with `DATEPART()`, `DATEADD()`, and `DATEDIFF()`

In the previous parts of this series, we explored SQL Server date and time data types, validation and extraction functions such as `ISDATE()`, `DAY()`, `MONTH()`, `YEAR()`, and `DATENAME()`.

In this section, we focus on three key functions that allow for analytical and arithmetic operations on date values:
**`DATEPART()`**, **`DATEADD()`**, and **`DATEDIFF()`**.
These functions are fundamental for computing intervals, scheduling logic, and time-based reporting.

---

## 1. `DATEPART()` — Extracting Numeric Components from Dates

The `DATEPART()` function returns an integer value representing a specific part of a date such as the year, month, or weekday number.

### Syntax

```sql
DATEPART ( datepart , date )
```

| Parameter  | Description                                                                  |
| ---------- | ---------------------------------------------------------------------------- |
| `datepart` | The part of the date to return (e.g., YEAR, MONTH, DAY, WEEKDAY, HOUR, etc.) |
| `date`     | The date or datetime expression to evaluate                                  |

### Example

```sql
SELECT 
    DATEPART(WEEKDAY, '2012-08-30') AS WeekdayNumber,
    DATEPART(MONTH, '2012-08-30') AS MonthNumber;
```

**Result**

| WeekdayNumber | MonthNumber |
| ------------- | ----------- |
| 5             | 8           |

In this example, `DATEPART(WEEKDAY, ...)` returns **5**, which represents *Thursday*, assuming the default setting where Sunday = 1. The `DATEPART(MONTH, ...)` returns **8**, corresponding to *August*.

---

### Comparison Between `DATEPART()` and `DATENAME()`

While both functions retrieve a part of a date, they differ in return type:

| Function     | Returns           | Example Output |
| ------------ | ----------------- | -------------- |
| `DATEPART()` | Integer           | 5              |
| `DATENAME()` | String (nvarchar) | 'Thursday'     |

Use `DATEPART()` when the output will be used in numerical calculations.
Use `DATENAME()` when a descriptive or text-based output is needed.

---

## 2. `DATEADD()` — Adding or Subtracting Intervals

The `DATEADD()` function returns a new date by adding or subtracting a specified number of units (such as days or months) to a given date.

### Syntax

```sql
DATEADD ( datepart , number , date )
```

| Parameter  | Description                                                         |
| ---------- | ------------------------------------------------------------------- |
| `datepart` | The date part to add to (e.g., DAY, MONTH, YEAR, HOUR, etc.)        |
| `number`   | The number of intervals to add. Negative values subtract intervals. |
| `date`     | The starting date expression.                                       |

### Example

```sql
-- Add 20 days
SELECT DATEADD(DAY, 20, '2012-08-30') AS AddedDays;

-- Subtract 20 days
SELECT DATEADD(DAY, -20, '2012-08-30') AS SubtractedDays;
```

**Result**

| Operation        | Result     |
| ---------------- | ---------- |
| Add 20 days      | 2012-09-19 |
| Subtract 20 days | 2012-08-10 |

This function supports addition or subtraction for years, months, days, hours, minutes, or seconds simply by changing the `datepart` argument.

---

## 3. `DATEDIFF()` — Calculating the Difference Between Two Dates

The `DATEDIFF()` function calculates the number of specified datepart boundaries crossed between two given dates.

### Syntax

```sql
DATEDIFF ( datepart , startdate , enddate )
```

| Parameter              | Description                                                  |
| ---------------------- | ------------------------------------------------------------ |
| `datepart`             | The unit of measurement (e.g., YEAR, MONTH, DAY, HOUR, etc.) |
| `startdate`, `enddate` | The two dates to compare.                                    |

### Example

```sql
-- Difference in months
SELECT DATEDIFF(MONTH, '2005-11-30', '2006-01-31') AS MonthDiff;

-- Difference in days
SELECT DATEDIFF(DAY, '2005-11-30', '2006-01-31') AS DayDiff;
```

**Result**

| DatePart | Result |
| -------- | ------ |
| MONTH    | 2      |
| DAY      | 62     |

**Note:**
`DATEDIFF()` counts datepart boundaries crossed, not complete periods elapsed.
For instance, the difference between `2024-12-31` and `2025-01-01` is one day but also one year boundary.

---

## 4. Practical Example: Calculating Age

Consider a table that stores each employee’s date of birth. The goal is to compute each person’s age dynamically without storing it as a separate field.

### Table Definition

```sql
CREATE TABLE Employees (
    ID INT,
    Name NVARCHAR(50),
    DateOfBirth DATE
);

INSERT INTO Employees VALUES
(1, 'Sam',  '1993-08-15'),
(2, 'John', '1997-10-26'),
(3, 'Mary', '1990-03-09');
```

### Step 1: Basic Year Difference

```sql
SELECT 
    DATEDIFF(YEAR, DateOfBirth, GETDATE()) AS AgeInYears
FROM Employees;
```

This provides an approximate year difference but does not account for whether the birthday has occurred yet in the current year.

---

### Step 2: Adjusted Accurate Age Calculation

```sql
SELECT 
    Name,
    DateOfBirth,
    DATEDIFF(YEAR, DateOfBirth, GETDATE()) 
      - CASE 
            WHEN (MONTH(DateOfBirth) > MONTH(GETDATE()))
                 OR (MONTH(DateOfBirth) = MONTH(GETDATE()) 
                     AND DAY(DateOfBirth) > DAY(GETDATE()))
              THEN 1 
              ELSE 0 
        END AS AccurateYears
FROM Employees;
```

This version ensures that the age is reduced by one if the birthday has not yet occurred in the current year.

---

### Step 3: Creating a Function to Return a Full Age Description

The following user-defined function computes an age string in the format “X years Y months Z days old.”

```sql
CREATE FUNCTION dbo.fn_ComputeAge(@DateOfBirth DATETIME)
RETURNS NVARCHAR(50)
AS
BEGIN
    DECLARE 
        @Years INT,
        @Months INT,
        @Days INT,
        @TempDate DATETIME,
        @Age NVARCHAR(50);

    SET @TempDate = @DateOfBirth;

    -- Calculate years
    SET @Years = DATEDIFF(YEAR, @DateOfBirth, GETDATE())
                 - CASE 
                       WHEN (MONTH(@DateOfBirth) > MONTH(GETDATE())) 
                            OR (MONTH(@DateOfBirth) = MONTH(GETDATE()) 
                                AND DAY(@DateOfBirth) > DAY(GETDATE()))
                       THEN 1 ELSE 0 
                   END;

    -- Add years to birth date for month calculation
    SET @TempDate = DATEADD(YEAR, @Years, @DateOfBirth);
    SET @Months = DATEDIFF(MONTH, @TempDate, GETDATE())
                  - CASE 
                        WHEN DAY(@DateOfBirth) > DAY(GETDATE())
                        THEN 1 ELSE 0 
                    END;

    -- Add months for remaining days
    SET @TempDate = DATEADD(MONTH, @Months, @TempDate);
    SET @Days = DATEDIFF(DAY, @TempDate, GETDATE());

    -- Concatenate formatted result
    SET @Age = 
        CAST(@Years AS NVARCHAR(4)) + ' years ' +
        CAST(@Months AS NVARCHAR(2)) + ' months ' +
        CAST(@Days AS NVARCHAR(2)) + ' days old';

    RETURN @Age;
END;
```

### Step 4: Using the Function

```sql
SELECT 
    ID,
    Name,
    DateOfBirth,
    dbo.fn_ComputeAge(DateOfBirth) AS Age
FROM Employees;
```

**Result**

| Name | DateOfBirth | Age                           |
| ---- | ----------- | ----------------------------- |
| Sam  | 1993-08-15  | 31 years 2 months 21 days old |
| John | 1997-10-26  | 28 years 0 months 10 days old |
| Mary | 1990-03-09  | 35 years 7 months 27 days old |

---

## 5. Summary

| Function     | Purpose                                  | Return Type   | Example                             |
| ------------ | ---------------------------------------- | ------------- | ----------------------------------- |
| `DATEPART()` | Extracts a numeric date component.       | Integer       | `DATEPART(MONTH, GETDATE()) → 11`   |
| `DATEADD()`  | Adds or subtracts an interval to a date. | Date/Datetime | `DATEADD(DAY, -10, GETDATE())`      |
| `DATEDIFF()` | Computes difference between two dates.   | Integer       | `DATEDIFF(DAY, StartDate, EndDate)` |

---

## Key Takeaways

* `DATEPART()` and `DATENAME()` are similar in concept but differ in return type — integer versus string.
* `DATEADD()` supports both addition and subtraction using positive or negative values.
* `DATEDIFF()` counts boundaries crossed rather than complete periods elapsed.
* Combining these functions enables precise calculations for durations, age, and time-based metrics.
* Encapsulating logic into user-defined functions promotes consistency and reusability in reporting and application logic.


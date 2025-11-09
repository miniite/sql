
## Mathematical Functions in SQL Server

### Introduction

In SQL Server, mathematical functions are built-in system functions that perform numeric calculations on expressions or values. These functions are used for operations such as rounding, finding powers, generating random numbers, or obtaining absolute values.
SQL Server supports a wide range of mathematical functions that follow both **ANSI standard** and **SQL Server-specific implementations**.
ANSI standard functions include fundamental ones such as `ABS()`, `CEILING()`, `FLOOR()`, `POWER()`, and `ROUND()`. SQL Server, however, extends this set with additional functions like `SQUARE()`, `SQRT()`, and `RAND(seed)` to provide enhanced numerical capabilities.

---

### Commonly Used Mathematical Functions in SQL Server

| **Function**                      | **Description**                                                                                                            | **Example**                    | **Result** |
| --------------------------------- | -------------------------------------------------------------------------------------------------------------------------- | ------------------------------ | ---------- |
| **ABS(n)**                        | Returns the absolute (positive) value of the specified number.                                                             | `SELECT ABS(-101.5);`          | `101.5`    |
| **CEILING(n)**                    | Returns the smallest integer greater than or equal to the given numeric expression.                                        | `SELECT CEILING(15.2);`        | `16`       |
| **FLOOR(n)**                      | Returns the largest integer less than or equal to the given numeric expression.                                            | `SELECT FLOOR(15.2);`          | `15`       |
| **POWER(x, y)**                   | Returns the value of *x* raised to the power *y*.                                                                          | `SELECT POWER(2,3);`           | `8`        |
| **SQUARE(n)**                     | Returns the square of the given number.                                                                                    | `SELECT SQUARE(4);`            | `16`       |
| **SQRT(n)**                       | Returns the square root of the given number.                                                                               | `SELECT SQRT(81);`             | `9`        |
| **ROUND(n, length [, function])** | Rounds or truncates a number to a specified number of decimal places based on the function parameter.                      | `SELECT ROUND(850.556, 2, 0);` | `850.56`   |
| **RAND([seed])**                  | Returns a pseudo-random float value between 0 and 1. When a seed is provided, it returns a repeatable value for that seed. | `SELECT RAND();`               | `0.472334` |

---

### Detailed Function Insights

#### 1. ABS()

The **ABS()** function removes the negative sign of a number and returns its positive equivalent.
Useful in cases where only the magnitude of a value matters, such as calculating distances, deviations, or differences.

#### 2. CEILING() and FLOOR()

Both **CEILING()** and **FLOOR()** functions round a number to the nearest integer but in opposite directions.

* `CEILING()` moves upward to the nearest integer.
* `FLOOR()` moves downward to the nearest integer.

Example:

```sql
SELECT CEILING(15.2) AS CeilingValue, FLOOR(15.2) AS FloorValue;
```

**Output:**
`CeilingValue = 16`, `FloorValue = 15`

When working with negative values, note that `CEILING(-15.2)` returns `-15`, while `FLOOR(-15.2)` returns `-16`.

#### 3. POWER(), SQUARE(), and SQRT()

* **POWER(x, y)** raises *x* to the power of *y*.
  Example: `SELECT POWER(4,3);` → `64`
* **SQUARE(n)** simplifies squaring operations.
  Example: `SELECT SQUARE(5);` → `25`
* **SQRT(n)** calculates the square root of a value.
  Example: `SELECT SQRT(81);` → `9`

These functions are extensively used in mathematical modeling, finance, and data analytics where exponential growth, variance, or distance calculations are required.

---

### 4. RAND([seed])

The **RAND()** function generates a pseudo-random float value between **0** and **1**.
Its syntax is:

```sql
RAND([seed])
```

#### Key Characteristics:

* The **`seed` parameter must be a numeric integer**. It cannot be a string.
* If you specify a **seed**, `RAND(seed)` returns **the same random value** each time for that seed — making it *deterministic* within the session.
* If you omit the seed, `RAND()` returns a **non-deterministic** value, producing a different result each time the query runs.
* The value generated is always between 0 (inclusive) and 1 (exclusive).

#### Example 1 — Without Seed

```sql
SELECT RAND();
```

Each execution will produce a different result, for example:

```
0.713429
0.218556
0.964177
```

#### Example 2 — With Seed

```sql
SELECT RAND(100);
```

Every time this query is executed, the output remains constant:

```
0.715436657367485
```

#### When to Use `RAND([seed])`

The seeded version of `RAND()` is valuable when **reproducibility** is needed.
For instance:

* During testing or debugging, where you need consistent data generation across runs.
* When creating **repeatable sample datasets** for unit testing or controlled simulations.

**Example Scenario:**
Suppose you are simulating student test scores to validate an average-calculation logic.
You can use:

```sql
SELECT FLOOR(RAND(10) * 100);
```

This ensures the same random numbers are generated each time you test, maintaining result consistency.

---

### 5. ROUND(n, length [, function])

The **ROUND()** function either rounds or truncates a numeric value based on the third parameter.
It accepts:

1. The number to round.
2. The number of decimal places.
3. An optional flag:

   * `0` (default) → Round to the nearest value.
   * `1` → Truncate (ignore extra decimals).

Example:

```sql
SELECT ROUND(850.556, 2, 0) AS RoundedValue,
       ROUND(850.556, 2, 1) AS TruncatedValue;
```

**Output:**
`RoundedValue = 850.56`
`TruncatedValue = 850.55`

Additionally, if a **negative length** is used, rounding is performed **to the left** of the decimal point:

```sql
SELECT ROUND(850.556, -1);
```

**Output:** `850.556 → 850.000`

---

### ANSI Standard vs SQL Server-Specific Functions

| **Category**                       | **Examples**                                          | **Description**                                                                                                               |
| ---------------------------------- | ----------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| **ANSI Standard Functions**        | `ABS()`, `CEILING()`, `FLOOR()`, `POWER()`, `ROUND()` | These are standardized mathematical functions available across most relational databases (SQL-compliant).                     |
| **SQL Server-Specific Extensions** | `SQUARE()`, `SQRT()`, `RAND([seed])`, `LOG10()`       | These functions extend mathematical operations beyond the ANSI standard, offering enhanced precision, control, or randomness. |

---

### Conclusion

SQL Server provides a comprehensive set of mathematical functions designed for flexibility, accuracy, and performance. While ANSI standard functions ensure compatibility across platforms, SQL Server’s extended set — such as `RAND(seed)` and `SQUARE()` — enhances the developer’s ability to perform precise calculations and controlled simulations.
Understanding the behavior, parameters, and specific use-cases of each function ensures robust and predictable outcomes in database operations.


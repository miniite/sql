

#  SQL Server Date Functions – Part 2 : Validation and Extraction Functions

This section focuses on validating date values and extracting individual components such as day, month, year, or named parts (like weekday or month name) from date expressions in SQL Server.

---

## 1. **Validating Date Values**

### 🔹 `ISDATE()`

The `ISDATE()` function checks whether an expression is a valid date, time, or datetime value.

```sql
SELECT ISDATE('2024-12-31') AS IsValidDate,
       ISDATE('31/12/2024') AS IsValidFormat,
       ISDATE('2024-02-30') AS InvalidDate;
```

**Output:**

| Expression   | Result             |
| ------------ | ------------------ |
| '2024-12-31' | 1 (Valid)          |
| '31/12/2024' | 0 (Invalid format) |
| '2024-02-30' | 0 (Invalid date)   |

✅ **Use Case:** Helps prevent conversion errors when parsing or casting date strings.

---

## 2. **Extracting Date Components**

SQL Server provides multiple functions to extract specific parts of a date value.

### 🔹 `DAY()`

Returns the **day** component of a date.

```sql
SELECT DAY('2025-03-15') AS DayPart;
```

**Result:** `15`

---

### 🔹 `MONTH()`

Returns the **month number** of a date.

```sql
SELECT MONTH('2025-03-15') AS MonthPart;
```

**Result:** `3`

---

### 🔹 `YEAR()`

Returns the **year** component of a date.

```sql
SELECT YEAR('2025-03-15') AS YearPart;
```

**Result:** `2025`

---

### 🔹 `DATENAME()`

Returns the **name** of a specific date part (like weekday or month name).

```sql
SELECT DATENAME(WEEKDAY, '2025-03-15') AS WeekdayName,
       DATENAME(MONTH, '2025-03-15') AS MonthName;
```

**Output:**

| Expression | Result   |
| ---------- | -------- |
| WEEKDAY    | Saturday |
| MONTH      | March    |

✅ **Note:** `DATENAME()` returns a string (e.g., “Monday”), while `DATEPART()` (covered in the next section) returns an integer.

---

## 3. **Supported `datepart` Values and Abbreviations**

These are the valid `datepart` arguments supported by functions like `DATENAME()` and `DATEPART()`.

| **Date Part**   | **Abbreviation(s)** | **Example Usage**                                           |
| --------------- | ------------------- | ----------------------------------------------------------- |
| year            | yy, yyyy            | `DATENAME(yy, '2025-03-15') → 2025`                         |
| quarter         | qq, q               | `DATEPART(qq, '2025-03-15') → 1`                            |
| month           | mm, m               | `DATENAME(mm, '2025-03-15') → March`                        |
| dayofyear       | dy, y               | `DATEPART(dy, '2025-03-15') → 74`                           |
| day             | dd, d               | `DATEPART(dd, '2025-03-15') → 15`                           |
| week            | wk, ww              | `DATEPART(wk, '2025-03-15') → 11`                           |
| weekday         | dw, w               | `DATENAME(dw, '2025-03-15') → Saturday`                     |
| hour            | hh                  | `DATEPART(hh, '2025-03-15 10:30') → 10`                     |
| minute          | mi, n               | `DATEPART(mi, '2025-03-15 10:30') → 30`                     |
| second          | ss, s               | `DATEPART(ss, '2025-03-15 10:30:45') → 45`                  |
| millisecond     | ms                  | `DATEPART(ms, '2025-03-15 10:30:45.250') → 250`             |
| microsecond     | mcs                 | `DATEPART(mcs, '2025-03-15 10:30:45.123456') → 123456`      |
| nanosecond      | ns                  | `DATEPART(ns, '2025-03-15 10:30:45.1234567') → 123456700`   |
| iso_week        | isowk, isoww        | `DATEPART(isowk, '2025-01-01') → 1`                         |
| timezone_hour   | tz, tzh             | (For `datetimeoffset`) `DATEPART(tz, SYSDATETIMEOFFSET())`  |
| timezone_minute | tzm                 | (For `datetimeoffset`) `DATEPART(tzm, SYSDATETIMEOFFSET())` |

---

### 📘 Important Notes

* Abbreviations like `yy` vs `yyyy` or `m` vs `mm` **do not affect the output type or value**.
  They are purely **syntactic aliases** — SQL Server internally normalizes them to the same `datepart` constant.
  In SQL Server, both abbreviations are **functionally identical**, serving only as shorthand for the same internal representation.

---

✅ **Summary**

| Function     | Purpose                                     | Return Type      | Example                                   |
| ------------ | ------------------------------------------- | ---------------- | ----------------------------------------- |
| `ISDATE()`   | Checks if value is a valid date/time        | Integer (1 or 0) | `ISDATE('2025-01-01') → 1`                |
| `DAY()`      | Extracts day number                         | Integer          | `DAY('2025-03-15') → 15`                  |
| `MONTH()`    | Extracts month number                       | Integer          | `MONTH('2025-03-15') → 3`                 |
| `YEAR()`     | Extracts year number                        | Integer          | `YEAR('2025-03-15') → 2025`               |
| `DATENAME()` | Returns textual representation of date part | String           | `DATENAME(MONTH, '2025-03-15') → 'March'` |



#  SQL Server Date Functions – Part 1

### Understanding Date & Time Data Types, Formats, and Core Functions

---

### **1. Overview**

Handling date and time correctly is essential in SQL Server for tracking transactions, maintaining logs, and supporting analytics. This article explores the **core Date and Time data types**, their **formats and syntax**, and key **functions** used to fetch system timestamps with precision and time zone awareness.

---

### **2. SQL Server Date and Time Data Types**

SQL Server provides several date/time data types, each with its own precision, storage requirements, and formatting behavior.

| **Data Type**    | **Description**                           | **Syntax Example**                                           | **Default Format (Output)**                                           | **Storage (Bytes)** | **Precision / Range** |
| ---------------- | ----------------------------------------- | ------------------------------------------------------------ | --------------------------------------------------------------------- | ------------------- | --------------------- |
| `DATE`           | Stores only the date.                     | `DECLARE @d DATE = '2025-11-05'`                             | `YYYY-MM-DD` → `2025-11-05`                                           | 3                   | 1 day                 |
| `DATETIME`       | Stores date and time (1753–9999).         | `DECLARE @dt DATETIME = '2025-11-05 14:25:00'`               | `YYYY-MM-DD hh:mm:ss.mmm` → `2025-11-05 14:25:00.000`                 | 8                   | ~3.33 ms              |
| `SMALLDATETIME`  | Less precise date/time (1900–2079).       | `DECLARE @sdt SMALLDATETIME = '2025-11-05 14:00'`            | `YYYY-MM-DD hh:mm:ss` → `2025-11-05 14:00:00`                         | 4                   | 1 minute              |
| `DATETIME2`      | Enhanced precision and range (0001–9999). | `DECLARE @dt2 DATETIME2(7) = '2025-11-05 14:25:15.1234567'`  | `YYYY-MM-DD hh:mm:ss[.nnnnnnn]` → `2025-11-05 14:25:15.1234567`       | 6–8                 | 100 ns                |
| `DATETIMEOFFSET` | Like `DATETIME2` + UTC offset.            | `DECLARE @dto DATETIMEOFFSET = '2025-11-05 14:25:00 +05:30'` | `YYYY-MM-DD hh:mm:ss[.nnnnnnn] ±hh:mm` → `2025-11-05 14:25:00 +05:30` | 8–10                | 100 ns                |
| `TIME`           | Stores only time of day.                  | `DECLARE @t TIME(4) = '14:25:30.1234'`                       | `hh:mm:ss[.nnnn]` → `14:25:30.1234`                                   | 3–5                 | 100 ns                |

---

### **3. System Date and Time Retrieval Functions**

#### **a) Local System Time Functions**

| **Function**        | **Description**                   | **Returns**    | **Precision** | **Example**                                             |
| ------------------- | --------------------------------- | -------------- | ------------- | ------------------------------------------------------- |
| `GETDATE()`         | Returns current local date/time.  | `DATETIME`     | ~3 ms         | `SELECT GETDATE();` → `2025-11-05 19:12:36.247`         |
| `CURRENT_TIMESTAMP` | ANSI equivalent of `GETDATE()`.   | `DATETIME`     | ~3 ms         | `SELECT CURRENT_TIMESTAMP;`                             |
| `SYSDATETIME()`     | Higher-precision local date/time. | `DATETIME2(7)` | 100 ns        | `SELECT SYSDATETIME();` → `2025-11-05 19:12:36.2473256` |

**Comparison:**

| **Function**        | **Precision** | **ANSI Compliant** | **Recommended Use**         |
| ------------------- | ------------- | ------------------ | --------------------------- |
| `GETDATE()`         | Millisecond   | ❌ No               | General-purpose             |
| `CURRENT_TIMESTAMP` | Millisecond   | ✅ Yes              | For ANSI-compatible scripts |
| `SYSDATETIME()`     | 100 ns        | ❌ No               | High-precision local time   |

---

#### **b) UTC (Coordinated Universal Time) Functions**

| **Function**       | **Description**                    | **Returns**    | **Precision** | **Example**                                                |
| ------------------ | ---------------------------------- | -------------- | ------------- | ---------------------------------------------------------- |
| `GETUTCDATE()`     | Current UTC date/time (no offset). | `DATETIME`     | ~3 ms         | `SELECT GETUTCDATE();` → `2025-11-05 13:42:36.247`         |
| `SYSUTCDATETIME()` | High-precision UTC date/time.      | `DATETIME2(7)` | 100 ns        | `SELECT SYSUTCDATETIME();` → `2025-11-05 13:42:36.2473256` |

**Comparison:**

| **Function**       | **Precision** | **Includes Offset** | **Recommended Use**              |
| ------------------ | ------------- | ------------------- | -------------------------------- |
| `GETUTCDATE()`     | Millisecond   | ❌ No                | Standard UTC logging             |
| `SYSUTCDATETIME()` | 100 ns        | ❌ No                | Precision logging in global apps |

---

### **4. Key Concepts**

#### **Local vs UTC**

* *Local time* adjusts according to the server’s time zone.
* *UTC time* remains constant worldwide — essential for global consistency.

#### **Time Zone Offset**

* The `+HH:MM` or `-HH:MM` portion in `DATETIMEOFFSET` defines deviation from UTC.
* Example: `+05:30` for India, `-08:00` for Pacific Time.

#### **Daylight Saving Time**

* SQL Server’s system clock adjusts automatically (if configured) for regions that observe DST.

---

### **5. Best Practices**

✅ Use `DATETIME2` for new development — it is more efficient and precise than `DATETIME`.

✅ Use `DATETIMEOFFSET` when storing multi-region timestamps.

✅ Prefer UTC-based timestamps (`GETUTCDATE()`, `SYSUTCDATETIME()`) for distributed systems.

✅ Use `SYSDATETIME()` for microsecond/nanosecond accuracy.

✅ Use `CURRENT_TIMESTAMP` for ANSI-compliant, portable code.

---

### **6. Summary Table**

| **Use Case**                     | **Recommended Type/Function** | **Reason**                   |
| -------------------------------- | ----------------------------- | ---------------------------- |
| Store only date                  | `DATE`                        | Compact storage              |
| Store only time                  | `TIME`                        | Precise time tracking        |
| Local timestamp (basic)          | `GETDATE()`                   | Quick and simple             |
| Local timestamp (high precision) | `SYSDATETIME()`               | 100 ns precision             |
| Global timestamp (UTC)           | `GETUTCDATE()`                | Time zone–independent        |
| High-precision UTC timestamp     | `SYSUTCDATETIME()`            | Ideal for logging & auditing |
| Cross-region storage             | `DATETIMEOFFSET`              | Retains offset info          |

---



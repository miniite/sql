create database  assgn

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Email NVARCHAR(100) UNIQUE,
    DepartmentID INT,
    HireDate DATE,
    Salary DECIMAL(10, 2)
);


INSERT INTO Employees (EmployeeID, FirstName, LastName, Email, DepartmentID, HireDate, Salary)
VALUES 
(1, 'John', 'Smith', 'john.smith@example.com', 101, '2021-06-15', 75000.00),
(2, 'Jane', 'Doe', 'jane.doe@example.com', 102, '2020-03-10', 85000.00),
(3, 'Michael', 'Johnson', 'michael.johnson@example.com', 101, '2019-11-22', 95000.00),
(4, 'Emily', 'Davis', 'emily.davis@example.com', 103, '2022-01-05', 68000.00),
(5, 'William', 'Brown', 'william.brown@example.com', 102, '2018-07-19', 80000.00);


SELECT FirstName
FROM Employees
WHERE Salary >  (SELECT AVG(Salary)
                FROM Employees)

SELECT FirstName
FROM Employees
WHERE HireDate > (SELECT MIN(HIREDATE)
                  FROM Employees)


SELECT FirstName
FROM Employees
WHERE Salary = (SELECT MAX(Salary)
                  FROM Employees)



SELECT FirstName, LastName
FROM Employees
WHERE DepartmentID = (SELECT DepartmentID
                      FROM Employees
                      WHERE FirstName = 'John' AND LastName = 'Smith')


SELECT FirstName, LastName
FROM Employees
WHERE DepartmentID NOT IN (SELECT TOP 1 DepartmentID
                            FROM Employees
                            GROUP BY DepartmentID
                            ORDER BY AVG(Salary) DESC)


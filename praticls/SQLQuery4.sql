create database assgn4

use assgn4

-- Creating the Employees table
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Email NVARCHAR(100) UNIQUE,
    DepartmentID INT,
    HireDate DATE,
    Salary DECIMAL(10, 2)
);

-- Creating the Departments table
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName NVARCHAR(100)
);


-- Inserting data into the Employees table
INSERT INTO Employees (EmployeeID, FirstName, LastName, Email, DepartmentID, HireDate, Salary)
VALUES 
(1, 'John', 'Smith', 'john.smith@example.com', 101, '2021-06-15', 75000.00),
(2, 'Jane', 'Doe', 'jane.doe@example.com', 102, '2020-03-10', 85000.00),
(3, 'Michael', 'Johnson', 'michael.johnson@example.com', 101, '2019-11-22', 95000.00),
(4, 'Emily', 'Davis', 'emily.davis@example.com', 103, '2022-01-05', 68000.00),
(5, 'William', 'Brown', 'william.brown@example.com', 102, '2018-07-19', 80000.00);

-- Inserting data into the Departments table
INSERT INTO Departments (DepartmentID, DepartmentName)
VALUES
(101, 'Human Resources'),
(102, 'Finance'),
(103, 'IT');


SELECT E.FirstName, E.LastName, D.DepartmentName
FROM Employees E JOIN Departments D
ON E.DepartmentID=D.DepartmentID;

SELECT D.DepartmentName, E.FirstName, E.LastName
FROM Departments D LEFT JOIN Employees E 
ON E.DepartmentID=D.DepartmentID;


SELECT E.FirstName, E.LastName
FROM Departments D LEFT JOIN Employees E 
ON E.DepartmentID=D.DepartmentID
WHERE D.DepartmentID IS NULL;

SELECT FirstName, LastName
From Employees
WHERE DepartmentID = (SELECT DepartmentID
                      FROM Employees
                      WHERE FirstName = 'Jane' and LastName = 'Doe');



SELECT E2.FirstName, E2.LastName
FROM Employees E1 JOIN Employees E2
ON E1.DepartmentID = E2.DepartmentID
WHERE E1.FirstName = 'Jane' AND E1.LastName = 'Doe' AND E2.EmployeeID <> E1.EmployeeID;


SELECT TOP 1 D.DepartmentName, SUM(E.Salary) [TotalSalary]
FROM Departments D JOIN Employees E
ON D.DepartmentID = E.DepartmentID
GROUP BY D.DepartmentName
ORDER BY SUM(E.Salary) DESC;


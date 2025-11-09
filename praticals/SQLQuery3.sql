create database aasgn3

use aasgn3 

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

 SELECT FirstName, LastName
 FROM Employees
 WHERE FirstName LIKE '_____'


SELECT FirstName, LastName
FROM Employees
WHERE LastName LIKE '_a%'





SELECT *
FROM Employees;

SELECT FirstName, LastName, Email
FROM Employees
WHERE DepartmentID = 101;


SELECT COUNT(*) [TotalEmployees]
FROM Employees

SELECT FirstName, LastName
FROM Employees
WHERE YEAR(HireDate) = '2020';


UPDATE Employees 
SET Salary = 90000
WHERE FirstName = 'Jane' AND LastName = 'Doe'

SELECT *
FROM Employees;
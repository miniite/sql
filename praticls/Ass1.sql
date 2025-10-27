
create database assgn1


CREATE TABLE EmployeeSales (
    SaleID INT PRIMARY KEY,
    EmployeeID INT,
    Department VARCHAR(50),
    SaleAmount DECIMAL(10, 2),
    SaleDate DATE
);


INSERT INTO EmployeeSales (SaleID, EmployeeID, Department, SaleAmount, SaleDate)
VALUES 
(1, 101, 'Electronics', 500.00, '2023-08-01'),
(2, 102, 'Electronics', 300.00, '2023-08-03'),
(3, 101, 'Furniture', 150.00, '2023-08-02'),
(4, 103, 'Electronics', 250.00, '2023-08-04'),
(5, 104, 'Furniture', 200.00, '2023-08-02'),
(6, 101, 'Furniture', 450.00, '2023-08-05'),
(7, 102, 'Electronics', 700.00, '2023-08-05'),
(8, 103, 'Furniture', 100.00, '2023-08-06');


SELECT Department, SUM(SaleAmount) AS TOTAL_SALES
FROM EmployeeSales
GROUP BY Department

SELECT EmployeeID, COUNT(EmployeeID)
FROM EmployeeSales
GROUP BY EmployeeID


SELECT Department, AVG(SaleAmount)
FROM EmployeeSales
GROUP BY Department

SELECT EmployeeID, SUM(SaleAmount)
FROM EmployeeSales
GROUP BY EmployeeID
HAVING COUNT(EmployeeID) > 1

SELECT MONTH(SaleDate), SUM(SaleAmount)
FROM EmployeeSales
WHERE YEAR(SaleDate) = 2023
GROUP BY MONTH(SaleDate)
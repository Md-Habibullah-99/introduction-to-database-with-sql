
-- Create the database (optional, but good practice)
CREATE DATABASE TechGearAnalytics;
GO

USE TechGearAnalytics;
GO

-- Table 1: Employees
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Department VARCHAR(50),
    HireDate DATE,
    BaseSalary DECIMAL(10,2),
    ManagerID INT NULL
);

-- Table 2: Products
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    UnitPrice DECIMAL(10,2),
    Cost DECIMAL(10,2)
);

-- Table 3: Sales
CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    EmployeeID INT,
    ProductID INT,
    SaleDate DATE,
    Quantity INT,
    Discount DECIMAL(3,2) DEFAULT 0.00,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);


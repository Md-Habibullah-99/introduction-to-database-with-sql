USE Master;

-- Drop existing tables if they exist
DROP TABLE IF EXISTS OrderDetails;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Employees;
DROP TABLE IF EXISTS Departments;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS SalaryGrades;

-- Create Tables
CREATE TABLE Employees (
    EmpID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    DepartmentID VARCHAR(20),
    Salary DECIMAL(10,2),
    HireDate DATE,
    ManagerID INT,
    City VARCHAR(50)
);

CREATE TABLE Departments (
    DepartmentID VARCHAR(20) PRIMARY KEY,
    DepartmentName VARCHAR(50),
    Budget DECIMAL(12,2),
    Location VARCHAR(50)
);

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    City VARCHAR(50),
    Country VARCHAR(50),
    CreditLimit DECIMAL(10,2)
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    UnitPrice DECIMAL(10,2),
    UnitsInStock INT
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    EmpID INT,
    OrderDate DATE,
    ShippedDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (EmpID) REFERENCES Employees(EmpID)
);

CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    Discount DECIMAL(3,2),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

CREATE TABLE SalaryGrades (
    GradeID INT PRIMARY KEY,
    MinSalary DECIMAL(10,2),
    MaxSalary DECIMAL(10,2),
    GradeLevel VARCHAR(20)
);

-- Insert Sample Data
INSERT INTO Employees VALUES 
(1, 'John', 'Doe', 'Sales', 95000.00, '2015-03-15', NULL, 'New York'),
(2, 'Jane', 'Smith', 'Sales', 85000.00, '2016-07-20', 1, 'Chicago'),
(3, 'Bob', 'Johnson', 'IT', 110000.00, '2014-01-10', NULL, 'New York'),
(4, 'Alice', 'Williams', 'IT', 75000.00, '2018-05-12', 3, 'Boston'),
(5, 'Charlie', 'Brown', 'HR', 65000.00, '2019-09-25', NULL, 'Chicago'),
(6, 'Diana', 'Jones', 'HR', 60000.00, '2020-11-30', 5, 'New York'),
(7, 'Edward', 'Davis', 'Sales', 70000.00, '2021-02-14', 1, 'Boston'),
(8, 'Fiona', 'Miller', 'IT', 105000.00, '2015-08-19', 3, 'Chicago');

INSERT INTO Departments VALUES
('Sales', 'Sales Department', 500000.00, 'New York'),
('IT', 'Information Technology', 400000.00, 'Boston'),
('HR', 'Human Resources', 200000.00, 'Chicago'),
('Marketing', 'Marketing Department', 350000.00, 'New York');

INSERT INTO Customers VALUES
(1, 'Global Traders', 'New York', 'USA', 50000.00),
(2, 'European Imports', 'London', 'UK', 75000.00),
(3, 'Asian Exports', 'Tokyo', 'Japan', 60000.00),
(4, 'American Supplies', 'Chicago', 'USA', 40000.00),
(5, 'Pacific Trading', 'Los Angeles', 'USA', 80000.00),
(6, 'Atlantic Enterprises', 'New York', 'USA', 55000.00);

INSERT INTO Products VALUES
(101, 'Laptop Pro', 'Electronics', 1200.00, 50),
(102, 'Office Chair', 'Furniture', 250.00, 100),
(103, 'Coffee Maker', 'Appliances', 80.00, 75),
(104, 'Monitor 24"', 'Electronics', 300.00, 40),
(105, 'Desk Lamp', 'Lighting', 45.00, 200),
(106, 'Wireless Mouse', 'Electronics', 35.00, 150);

INSERT INTO Orders VALUES
(1001, 1, 1, '2024-01-15', '2024-01-18'),
(1002, 2, 2, '2024-01-20', '2024-01-25'),
(1003, 3, 3, '2024-02-01', '2024-02-05'),
(1004, 1, 1, '2024-02-10', '2024-02-12'),
(1005, 4, 7, '2024-02-15', '2024-02-20'),
(1006, 5, 2, '2024-02-18', NULL),
(1007, 6, 4, '2024-03-01', '2024-03-05'),
(1008, 2, 1, '2024-03-10', '2024-03-15'),
(1009, 3, 3, '2024-03-12', NULL);

INSERT INTO OrderDetails VALUES
(1, 1001, 101, 2, 0.05),
(2, 1001, 103, 3, 0.00),
(3, 1002, 104, 1, 0.00),
(4, 1002, 106, 5, 0.10),
(5, 1003, 101, 1, 0.00),
(6, 1003, 102, 4, 0.00),
(7, 1004, 105, 6, 0.05),
(8, 1004, 106, 2, 0.00),
(9, 1005, 103, 2, 0.00),
(10, 1005, 104, 2, 0.15),
(11, 1006, 101, 1, 0.00),
(12, 1006, 102, 2, 0.00),
(13, 1007, 105, 4, 0.00),
(14, 1008, 106, 8, 0.05),
(15, 1009, 101, 2, 0.10);

INSERT INTO SalaryGrades VALUES
(1, 50000, 69999, 'Junior'),
(2, 70000, 89999, 'Mid-Level'),
(3, 90000, 119999, 'Senior'),
(4, 120000, 150000, 'Lead');

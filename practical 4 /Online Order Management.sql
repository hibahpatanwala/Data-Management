
-- Set 5: Online Order Management
--

-- 1. Find insertion anomalies
-- Cannot add a customer or product unless there is an order transaction.
-- Can't add supplier data separately without an order.

-- 2. Find update anomalies
-- Updating CustomerEmail requires changing all corresponding order rows.
-- Similarly, changing SupplierName must be updated in every order row for that supplier.

-- 3. Find deletion anomalies
-- Deleting an order may delete info about a customer or product if no other orders exist for those.

-- 4. Is schema in 1NF? Explain.
-- Yes, all fields contain atomic values. No repeating groups or arrays.

-- 5. Convert schema to 1NF (already is)

CREATE TABLE OnlineOrders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    CustomerName VARCHAR(100),
    CustomerEmail VARCHAR(100),
    ProductID INT,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    SupplierName VARCHAR(100),
    OrderDate DATE,
    Quantity INT,
    Price DECIMAL(10,2)
);

-- Insert sample data for 1NF table
INSERT INTO OnlineOrders (OrderID, CustomerID, CustomerName, CustomerEmail, ProductID, ProductName, Category, SupplierName, OrderDate, Quantity, Price)
VALUES
(5001, 301, 'Aarav Singh', 'aarav@example.com', 401, 'Wireless Mouse', 'Electronics', 'Tech Supplies Inc', '2025-09-01', 2, 499.00),
(5002, 302, 'Meera Shah', 'meera@example.com', 402, 'Yoga Mat', 'Sports', 'FitGear LLC', '2025-09-03', 1, 1200.00),
(5003, 303, 'Raj Kumar', 'raj@example.com', 403, 'LED Monitor', 'Electronics', 'Tech Supplies Inc', '2025-09-04', 1, 7500.00),
(5004, 301, 'Aarav Singh', 'aarav@example.com', 404, 'Desk Lamp', 'Furniture', 'Home Comforts', '2025-09-05', 1, 850.00),
(5005, 304, 'Sana Ali', 'sana@example.com', 401, 'Wireless Mouse', 'Electronics', 'Tech Supplies Inc', '2025-09-07', 3, 499.00),
(5006, 305, 'Vikram Patel', 'vikram@example.com', 405, 'Running Shoes', 'Sports', 'FitGear LLC', '2025-09-08', 2, 3300.00);

-- 6. State primary key
-- OrderID uniquely identifies an order.

-- 7. Write FDs
-- CustomerID → CustomerName, CustomerEmail
-- ProductID → ProductName, Category, SupplierName
-- OrderID → OrderDate, Quantity, Price, CustomerID, ProductID

-- 8. Identify partial dependencies
-- Attributes like CustomerName and CustomerEmail depend only on CustomerID,
-- ProductName, Category, SupplierName depend only on ProductID,
-- partial dependencies exist in the composite key context if we consider OrderID composite (here it's simple PK).

-- 9. Convert schema to 2NF
CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    CustomerEmail VARCHAR(100)
);

CREATE TABLE Product (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    SupplierName VARCHAR(100)
);

CREATE TABLE Supplier (
    SupplierName VARCHAR(100) PRIMARY KEY
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    ProductID INT,
    OrderDate DATE,
    Quantity INT,
    Price DECIMAL(10,2),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);

-- Insert sample data in 2NF tables
INSERT INTO Customer (CustomerID, CustomerName, CustomerEmail) VALUES
(301, 'Aarav Singh', 'aarav@example.com'),
(302, 'Meera Shah', 'meera@example.com'),
(303, 'Raj Kumar', 'raj@example.com'),
(304, 'Sana Ali', 'sana@example.com'),
(305, 'Vikram Patel', 'vikram@example.com');

INSERT INTO Supplier (SupplierName) VALUES
('Tech Supplies Inc'),
('FitGear LLC'),
('Home Comforts');

INSERT INTO Product (ProductID, ProductName, Category, SupplierName) VALUES
(401, 'Wireless Mouse', 'Electronics', 'Tech Supplies Inc'),
(402, 'Yoga Mat', 'Sports', 'FitGear LLC'),
(403, 'LED Monitor', 'Electronics', 'Tech Supplies Inc'),
(404, 'Desk Lamp', 'Furniture', 'Home Comforts'),
(405, 'Running Shoes', 'Sports', 'FitGear LLC');

INSERT INTO Orders (OrderID, CustomerID, ProductID, OrderDate, Quantity, Price) VALUES
(5001, 301, 401, '2025-09-01', 2, 499.00),
(5002, 302, 402, '2025-09-03', 1, 1200.00),
(5003, 303, 403, '2025-09-04', 1, 7500.00),
(5004, 301, 404, '2025-09-05', 1, 850.00),
(5005, 304, 401, '2025-09-07', 3, 499.00),
(5006, 305, 405, '2025-09-08', 2, 3300.00);

-- 10. Write SQL for 2NF schema (already created above)

-- 11. Identify transitive dependencies
-- SupplierName in Product table depends on SupplierName key, no transitive dependencies besides Supplier → SupplierName (trivial).
-- If Supplier details grew, could normalize supplier info further.

-- 12. Convert schema to 3NF
-- Normalize Supplier into a separate table (done above).
-- Potential for expanding Supplier info (address, contact) stored only once.

-- 13. Write SQL for 3NF schema
-- Already included Supplier table separately.

-- 14. Check BCNF compliance
-- Yes, all functional dependencies have determinants as candidate keys.

-- 15. Query: List all orders with products and suppliers
SELECT O.OrderID, C.CustomerName, P.ProductName, P.Category, P.SupplierName, O.OrderDate, O.Quantity, O.Price
FROM Orders O
JOIN Customer C ON O.CustomerID = C.CustomerID
JOIN Product P ON O.ProductID = P.ProductID;

-- 16. Query: Find total sales per customer
SELECT C.CustomerName, SUM(O.Quantity * O.Price) AS TotalSales
FROM Orders O
JOIN Customer C ON O.CustomerID = C.CustomerID
GROUP BY C.CustomerName;

-- 17. Query: Count orders per supplier
SELECT P.SupplierName, COUNT(*) AS NumberOfOrders
FROM Orders O
JOIN Product P ON O.ProductID = P.ProductID
GROUP BY P.SupplierName;

-- 18. Query: Find customers who ordered more than 5 times
SELECT C.CustomerName, COUNT(*) AS OrdersCount
FROM Orders O
JOIN Customer C ON O.CustomerID = C.CustomerID
GROUP BY C.CustomerName
HAVING COUNT(*) > 5;

-- 19. Query: Find most ordered product
SELECT P.ProductName, SUM(O.Quantity) AS TotalQuantity
FROM Orders O
JOIN Product P ON O.ProductID = P.ProductID
GROUP BY P.ProductName
ORDER BY TotalQuantity DESC
LIMIT 1;

-- 20. Discuss advantages of normalization
-- Normalization eliminates redundancy (customer and product info stored only once).
-- Update anomalies reduced since customer emails updated once.
-- Deletion and insertion anomalies alleviated by splitting entities logically into tables.

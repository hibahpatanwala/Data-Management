--
-- Set 8: Retail Store Sales 
--

-- 1. Find insertion anomalies
-- Cannot add a new product or store sale without an existing sale record.
-- Cannot add store or product details independently.

-- 2. Find update anomalies
-- Changing StoreLocation or ProductName must be updated in all rows referencing them; otherwise, inconsistent data.

-- 3. Find deletion anomalies
-- Deleting one sale record for a product/store might remove information about that product or store if no other records exist.

-- 4. Is schema in 1NF? Explain.
-- Yes, all attributes hold atomic, indivisible values, no multi-valued or repeating columns.

-- 5. Convert schema to 1NF (already is)

CREATE TABLE StoreSales (
    SaleID INT PRIMARY KEY,
    StoreID INT,
    StoreLocation VARCHAR(100),
    CashierName VARCHAR(100),
    ProductID INT,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    SaleDate DATE,
    Quantity INT,
    TotalAmount DECIMAL(10,2)
);

-- Insert sample data
INSERT INTO StoreSales (SaleID, StoreID, StoreLocation, CashierName, ProductID, ProductName, Category, SaleDate, Quantity, TotalAmount) VALUES
(9001, 1, 'Delhi Mall', 'Neha', 501, 'Laptop', 'Electronics', '2025-09-01', 2, 120000.00),
(9002, 2, 'Mumbai Store', 'Amit', 502, 'Jeans', 'Clothing', '2025-09-02', 5, 2500.00),
(9003, 1, 'Delhi Mall', 'Neha', 503, 'Smartphone', 'Electronics', '2025-09-03', 3, 180000.00),
(9004, 3, 'Bangalore Outlet', 'Suresh', 504, 'Blender', 'Home Appliances', '2025-09-04', 4, 16000.00),
(9005, 2, 'Mumbai Store', 'Amit', 505, 'T-Shirt', 'Clothing', '2025-09-05', 10, 2000.00),
(9006, 1, 'Delhi Mall', 'Neha', 501, 'Laptop', 'Electronics', '2025-09-06', 1, 60000.00);

-- 6. State primary key
-- SaleID uniquely identifies each sale.

-- 7. Write FDs
-- SaleID → StoreID, StoreLocation, CashierName, ProductID, ProductName, Category, SaleDate, Quantity, TotalAmount
-- StoreID → StoreLocation
-- ProductID → ProductName, Category

-- 8. Remove partial dependencies (2NF)
-- Separate Store, Product, and Sale details into respective tables

CREATE TABLE Store (
    StoreID INT PRIMARY KEY,
    StoreLocation VARCHAR(100)
);

CREATE TABLE Product (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50)
);

CREATE TABLE StoreSale (
    SaleID INT PRIMARY KEY,
    StoreID INT,
    CashierName VARCHAR(100),
    ProductID INT,
    SaleDate DATE,
    Quantity INT,
    TotalAmount DECIMAL(10,2),
    FOREIGN KEY (StoreID) REFERENCES Store(StoreID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);

-- Insert sample data for 2NF
INSERT INTO Store (StoreID, StoreLocation) VALUES
(1, 'Delhi Mall'),
(2, 'Mumbai Store'),
(3, 'Bangalore Outlet');

INSERT INTO Product (ProductID, ProductName, Category) VALUES
(501, 'Laptop', 'Electronics'),
(502, 'Jeans', 'Clothing'),
(503, 'Smartphone', 'Electronics'),
(504, 'Blender', 'Home Appliances'),
(505, 'T-Shirt', 'Clothing');

INSERT INTO StoreSale (SaleID, StoreID, CashierName, ProductID, SaleDate, Quantity, TotalAmount) VALUES
(9001, 1, 'Neha', 501, '2025-09-01', 2, 120000.00),
(9002, 2, 'Amit', 502, '2025-09-02', 5, 2500.00),
(9003, 1, 'Neha', 503, '2025-09-03', 3, 180000.00),
(9004, 3, 'Suresh', 504, '2025-09-04', 4, 16000.00),
(9005, 2, 'Amit', 505, '2025-09-05', 10, 2000.00),
(9006, 1, 'Neha', 501, '2025-09-06', 1, 60000.00);

-- 10. Identify transitive dependencies
-- StoreLocation depends only on StoreID
-- ProductName, Category depend only on ProductID

-- 11. Convert to 3NF
-- Already normalized by separating Store and Product entities.

-- 12. Write SQL for 3NF (same as 2NF)

-- 13. Check BCNF
-- Yes, all determinants are candidate keys.

-- 14. Query: List all sales with product and store info
SELECT S.SaleID, ST.StoreLocation, P.ProductName, S.SaleDate, S.Quantity, S.TotalAmount
FROM StoreSale S
JOIN Store ST ON S.StoreID = ST.StoreID
JOIN Product P ON S.ProductID = P.ProductID;

-- 15. Query: Total sales per store
SELECT ST.StoreLocation, SUM(S.TotalAmount) AS TotalSales
FROM StoreSale S
JOIN Store ST ON S.StoreID = ST.StoreID
GROUP BY ST.StoreLocation;

-- 16. Query: Count sales per category
SELECT P.Category, COUNT(*) AS SalesCount
FROM StoreSale S
JOIN Product P ON S.ProductID = P.ProductID
GROUP BY P.Category;

-- 17. Query: Find products with sales > 25 units
SELECT P.ProductName, SUM(S.Quantity) AS TotalSold
FROM StoreSale S
JOIN Product P ON S.ProductID = P.ProductID
GROUP BY P.ProductName
HAVING SUM(S.Quantity) > 25;

-- 18. Query: Find stores with sales exceeding $100,000
SELECT ST.StoreLocation, SUM(S.TotalAmount) AS Earnings
FROM StoreSale S
JOIN Store ST ON S.StoreID = ST.StoreID
GROUP BY ST.StoreLocation
HAVING SUM(S.TotalAmount) > 100000;

-- 19. Query: List sales by cashier
SELECT S.SaleID, S.CashierName, P.ProductName, S.SaleDate
FROM StoreSale S
JOIN Product P ON S.ProductID = P.ProductID;

-- 20. Discuss reduction in redundancy:
-- Before normalization, store details like StoreLocation duplicated for each sale and product info repeated.
-- After normalization, store and product data stored once, reducing duplication and ensuring easier updates.

--
-- Set 9: Travel Agency Booking 
--

-- 1. Identify anomalies
-- Insert anomaly: Cannot add a customer or package without a booking.
-- Update anomaly: Changing CustomerName or HotelName requires multiple row updates.
-- Deletion anomaly: Deleting a booking could remove info about customer or package if no other related bookings.

-- 2. Does schema meet 1NF? Why/why not?
-- Yes, all attributes have atomic values without repeating groups or arrays.

-- 3. Normalize to 1NF (already is)

CREATE TABLE TravelBooking (
    BookingID INT PRIMARY KEY,
    CustomerID INT,
    CustomerName VARCHAR(100),
    Phone VARCHAR(20),
    Destination VARCHAR(100),
    PackageName VARCHAR(100),
    PackagePrice DECIMAL(10,2),
    HotelName VARCHAR(100),
    TransportMode VARCHAR(50),
    TravelDate DATE
);

-- Insert sample data for 1NF table
INSERT INTO TravelBooking (BookingID, CustomerID, CustomerName, Phone, Destination, PackageName, PackagePrice, HotelName, TransportMode, TravelDate)
VALUES
(10001, 401, 'Anil Kumar', '9876543210', 'Goa', 'Beach Fun', 15000.00, 'Sea View Resort', 'Flight', '2025-12-01'),
(10002, 402, 'Sunita Rao', '9123456789', 'Manali', 'Mountain Escape', 18000.00, 'Hillside Inn', 'Bus', '2025-11-25'),
(10003, 403, 'Rajesh Singh', '9988776655', 'Goa', 'Beach Fun', 15000.00, 'Sea View Resort', 'Flight', '2025-12-05'),
(10004, 401, 'Anil Kumar', '9876543210', 'Agra', 'Historical Tour', 12000.00, 'Heritage Hotel', 'Train', '2025-11-15'),
(10005, 404, 'Meena Sharma', '9456123789', 'Manali', 'Mountain Escape', 18000.00, 'Hillside Inn', 'Bus', '2025-12-10');

-- 4. State primary key
-- BookingID is the primary key.

-- 5. Write functional dependencies
-- BookingID → all other fields
-- CustomerID → CustomerName, Phone
-- PackageName → PackagePrice, Destination, HotelName, TransportMode

-- 6. Identify partial dependencies
-- CustomerName and Phone depend only on CustomerID.
-- PackagePrice, Destination, HotelName, TransportMode depend only on PackageName.

-- 7. Convert schema to 2NF

CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    Phone VARCHAR(20)
);

CREATE TABLE Package (
    PackageName VARCHAR(100) PRIMARY KEY,
    Destination VARCHAR(100),
    PackagePrice DECIMAL(10,2),
    HotelName VARCHAR(100),
    TransportMode VARCHAR(50)
);

CREATE TABLE Booking (
    BookingID INT PRIMARY KEY,
    CustomerID INT,
    PackageName VARCHAR(100),
    TravelDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (PackageName) REFERENCES Package(PackageName)
);

-- Insert sample data for 2NF tables
INSERT INTO Customer (CustomerID, CustomerName, Phone) VALUES
(401, 'Anil Kumar', '9876543210'),
(402, 'Sunita Rao', '9123456789'),
(403, 'Rajesh Singh', '9988776655'),
(404, 'Meena Sharma', '9456123789');

INSERT INTO Package (PackageName, Destination, PackagePrice, HotelName, TransportMode) VALUES
('Beach Fun', 'Goa', 15000.00, 'Sea View Resort', 'Flight'),
('Mountain Escape', 'Manali', 18000.00, 'Hillside Inn', 'Bus'),
('Historical Tour', 'Agra', 12000.00, 'Heritage Hotel', 'Train');

INSERT INTO Booking (BookingID, CustomerID, PackageName, TravelDate) VALUES
(10001, 401, 'Beach Fun', '2025-12-01'),
(10002, 402, 'Mountain Escape', '2025-11-25'),
(10003, 403, 'Beach Fun', '2025-12-05'),
(10004, 401, 'Historical Tour', '2025-11-15'),
(10005, 404, 'Mountain Escape', '2025-12-10');

-- 8. Identify transitive dependencies
-- HotelName and TransportMode depend on PackageName, no further transitive dependencies.

-- 9. Convert to 3NF
-- Already normalized by separating Package and Customer details.

-- 10. Write SQL for 3NF schema
-- Same as 2NF schema above.

-- 11. Check BCNF compliance
-- Yes, determinants are candidate keys.

-- 12. Query: List all bookings with hotel and transport
SELECT B.BookingID, C.CustomerName, P.PackageName, P.HotelName, P.TransportMode, B.TravelDate
FROM Booking B
JOIN Customer C ON B.CustomerID = C.CustomerID
JOIN Package P ON B.PackageName = P.PackageName;

-- 13. Query: Count bookings per destination
SELECT P.Destination, COUNT(*) AS BookingCount
FROM Booking B
JOIN Package P ON B.PackageName = P.PackageName
GROUP BY P.Destination;

-- 14. Query: Find customers who booked more than once
SELECT C.CustomerName, COUNT(*) AS Bookings
FROM Booking B
JOIN Customer C ON B.CustomerID = C.CustomerID
GROUP BY C.CustomerName
HAVING COUNT(*) > 1;

-- 15. Query: Find average package price per destination
SELECT P.Destination, AVG(P.PackagePrice) AS AvgPrice
FROM Package P
GROUP BY P.Destination;

-- 16. Query: Most popular transport mode
SELECT P.TransportMode, COUNT(*) AS UsageCount
FROM Booking B
JOIN Package P ON B.PackageName = P.PackageName
GROUP BY P.TransportMode
ORDER BY UsageCount DESC
LIMIT 1;

-- 17. Query: Hotels booked more than 5 times
SELECT P.HotelName, COUNT(*) AS Bookings
FROM Booking B
JOIN Package P ON B.PackageName = P.PackageName
GROUP BY P.HotelName
HAVING COUNT(*) > 5;

-- 18. Query: List all customers traveling in December
SELECT C.CustomerName, B.TravelDate
FROM Booking B
JOIN Customer C ON B.CustomerID = C.CustomerID
WHERE MONTH(B.TravelDate) = 12;

-- 19. Compare redundancy before & after normalization
-- Before normalization data was redundant: customer and package details repeated for every booking.
-- After normalization, customer and package info is stored once per entity, improving consistency and reducing update anomalies.

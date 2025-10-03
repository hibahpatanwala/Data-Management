--
-- Set 7: Movie Ticket Booking 
--

-- 1. Identify anomalies
-- Insert anomaly: Can't add a new customer or movie without a booking.
-- Update anomaly: Changing CustomerPhone requires updates in all booking rows.
-- Deletion anomaly: Deleting last booking of a movie/customer deletes all their info.

-- 2. Does schema meet 1NF? Why/why not?
-- Yes, all columns contain atomic (single) values, no repeating groups.

-- 3. Normalize to 1NF (already is)

CREATE TABLE TicketBooking (
    BookingID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    CustomerPhone VARCHAR(20),
    MovieID INT,
    MovieTitle VARCHAR(200),
    Genre VARCHAR(50),
    ShowTime DATETIME,
    ScreenNo INT,
    SeatNo VARCHAR(10),
    TicketPrice DECIMAL(10,2)
);

-- Insert sample data for 1NF table 
INSERT INTO TicketBooking (BookingID, CustomerName, CustomerPhone, MovieID, MovieTitle, Genre, ShowTime, ScreenNo, SeatNo, TicketPrice) VALUES
(701, 'Rahul Verma', '9876543210', 101, 'Galaxy Wars', 'Action', '2025-09-15 19:30:00', 1, 'A10', 250.00),
(702, 'Anjali Mehta', '9123456780', 102, 'Romance in Paris', 'Romance', '2025-09-15 18:00:00', 2, 'B5', 150.00),
(703, 'Rahul Verma', '9876543210', 103, 'Haunted Nights', 'Horror', '2025-09-16 21:00:00', 3, 'C12', 300.00),
(704, 'Sunil Das', '9988776655', 101, 'Galaxy Wars', 'Action', '2025-09-15 22:00:00', 1, 'A11', 250.00),
(705, 'Priya Sharma', '9871236540', 104, 'Laugh Out Loud', 'Comedy', '2025-09-17 20:00:00', 4, 'D4', 180.00),
(706, 'Anjali Mehta', '9123456780', 101, 'Galaxy Wars', 'Action', '2025-09-15 19:30:00', 1, 'A12', 250.00);

-- 4. State primary key
-- BookingID uniquely identifies each ticket booking.

-- 5. Write FDs
-- BookingID → all other attributes
-- MovieID → MovieTitle, Genre
-- CustomerName → CustomerPhone (assuming unique customer names, else CustomerID would be preferred)

-- 6. Remove partial dependencies (2NF)
-- Separate Customer, Movie tables from Booking

CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    CustomerPhone VARCHAR(20)
);

CREATE TABLE Movie (
    MovieID INT PRIMARY KEY,
    MovieTitle VARCHAR(200),
    Genre VARCHAR(50)
);

CREATE TABLE Booking (
    BookingID INT PRIMARY KEY,
    CustomerID INT,
    MovieID INT,
    ShowTime DATETIME,
    ScreenNo INT,
    SeatNo VARCHAR(10),
    TicketPrice DECIMAL(10,2),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (MovieID) REFERENCES Movie(MovieID)
);

-- Insert sample data for 2NF tables
INSERT INTO Customer (CustomerID, CustomerName, CustomerPhone) VALUES
(1, 'Rahul Verma', '9876543210'),
(2, 'Anjali Mehta', '9123456780'),
(3, 'Sunil Das', '9988776655'),
(4, 'Priya Sharma', '9871236540');

INSERT INTO Movie (MovieID, MovieTitle, Genre) VALUES
(101, 'Galaxy Wars', 'Action'),
(102, 'Romance in Paris', 'Romance'),
(103, 'Haunted Nights', 'Horror'),
(104, 'Laugh Out Loud', 'Comedy');

INSERT INTO Booking (BookingID, CustomerID, MovieID, ShowTime, ScreenNo, SeatNo, TicketPrice) VALUES
(701, 1, 101, '2025-09-15 19:30:00', 1, 'A10', 250.00),
(702, 2, 102, '2025-09-15 18:00:00', 2, 'B5', 150.00),
(703, 1, 103, '2025-09-16 21:00:00', 3, 'C12', 300.00),
(704, 3, 101, '2025-09-15 22:00:00', 1, 'A11', 250.00),
(705, 4, 104, '2025-09-17 20:00:00', 4, 'D4', 180.00),
(706, 2, 101, '2025-09-15 19:30:00', 1, 'A12', 250.00);

-- 7. Write SQL for 2NF schema (already included above)

-- 8. Identify transitive dependencies
-- None, since all non-key attributes depend on the keys directly.

-- 9. Convert to 3NF (same as 2NF here)

-- 10. Write SQL for 3NF schema (same as 2NF)

-- 11. Check BCNF compliance
-- Yes, all determinants are candidate keys.

-- 12. Query: List all customers with their movies
SELECT C.CustomerName, M.MovieTitle, B.ShowTime, B.SeatNo
FROM Booking B
JOIN Customer C ON B.CustomerID = C.CustomerID
JOIN Movie M ON B.MovieID = M.MovieID;

-- 13. Query: Find number of tickets booked per movie
SELECT M.MovieTitle, COUNT(*) AS TicketsBooked
FROM Booking B
JOIN Movie M ON B.MovieID = M.MovieID
GROUP BY M.MovieTitle;

-- 14. Query: Find customers booking more than 2 tickets
SELECT C.CustomerName, COUNT(*) AS TicketCount
FROM Booking B
JOIN Customer C ON B.CustomerID = C.CustomerID
GROUP BY C.CustomerName
HAVING COUNT(*) > 2;

-- 15. Query: Find movies of "Action" genre booked most
SELECT M.MovieTitle, COUNT(*) AS TicketsBooked
FROM Booking B
JOIN Movie M ON B.MovieID = M.MovieID
WHERE M.Genre = 'Action'
GROUP BY M.MovieTitle
ORDER BY TicketsBooked DESC;

-- 16. Query: Find screens showing multiple movies
SELECT B.ScreenNo
FROM Booking B
GROUP BY B.ScreenNo
HAVING COUNT(DISTINCT B.MovieID) > 1;

-- 17. Query: Find average ticket price per genre
SELECT M.Genre, AVG(B.TicketPrice) AS AvgTicketPrice
FROM Booking B
JOIN Movie M ON B.MovieID = M.MovieID
GROUP BY M.Genre;

-- 18. Query: Highest revenue generating movie
SELECT M.MovieTitle, SUM(B.TicketPrice) AS TotalRevenue
FROM Booking B
JOIN Movie M ON B.MovieID = M.MovieID
GROUP BY M.MovieTitle
ORDER BY TotalRevenue DESC LIMIT 1;

-- 19. Query: Find seats booked by a customer
SELECT C.CustomerName, B.SeatNo, M.MovieTitle, B.ShowTime
FROM Booking B
JOIN Customer C ON B.CustomerID = C.CustomerID
JOIN Movie M ON B.MovieID = M.MovieID
WHERE C.CustomerName = 'Rahul Verma';

-- 20. Discuss improvements after normalization
-- Normalization removes redundancy in customer and movie names.
-- Updates to customers or movies need changes in one place only.
-- Data integrity and query flexibility improve.

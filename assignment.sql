-- set 1
CREATE DATABASE OnlineBookstore;
USE OnlineBookstore;

CREATE TABLE Authors (
  AuthorID INT PRIMARY KEY,
  Name VARCHAR(100),
  Country VARCHAR(50),
  DOB DATE
);

CREATE TABLE Categories (
  CategoryID INT PRIMARY KEY,
  CategoryName VARCHAR(50)
);

CREATE TABLE Books (
  BookID INT PRIMARY KEY,
  Title VARCHAR(150),
  AuthorID INT,
  CategoryID INT,
  Price DECIMAL(10,2),
  Stock INT,
  PublishedYear YEAR,
  FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID),
  FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

CREATE TABLE Customers (
  CustomerID INT PRIMARY KEY,
  Name VARCHAR(100),
  Email VARCHAR(100),
  Phone VARCHAR(15),
  Address VARCHAR(255)
);

CREATE TABLE Orders (
  OrderID INT PRIMARY KEY,
  CustomerID INT,
  OrderDate DATE,
  Status VARCHAR(20),
  FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Insert data into Authors
INSERT INTO Authors VALUES
  (1, 'R. K. Narayan', 'India', '1906-10-10'),
  (2, 'J.K. Rowling', 'UK', '1965-07-31'),
  (3, 'Agatha Christie', 'UK', '1890-09-15'),
  (4, 'Chetan Bhagat', 'India', '1974-04-22'),
  (5, 'Dan Brown', 'USA', '1964-06-22');

-- Insert data into Categories
INSERT INTO Categories VALUES
  (1, 'Fiction'),
  (2, 'Mystery'),
  (3, 'Guide'),
  (4, 'Children'),
  (5, 'Technology');

-- Insert data into Books
INSERT INTO Books VALUES
  (1, 'Malgudi Days', 1, 1, 350.00, 8, 2010),
  (2, 'Harry Potter', 2, 4, 950.50, 32, 2016),
  (3, 'The Mystery of the Blue Train', 3, 2, 600.00, 4, 2018),
  (4, 'Five Point Someone', 4, 1, 435.00, 7, 2009),
  (5, 'Digital Fortress Guide', 5, 3, 1200.00, 17, 2021);

-- Insert data into Customers
INSERT INTO Customers VALUES
  (1, 'Amit Sharma', 'amit@mail.com', '9876543210', 'Mumbai'),
  (2, 'Sneha Verma', 'sneha@mail.com', '9854471200', 'Delhi'),
  (3, 'Rohit Kumar', 'rohit@mail.com', '9012349876', 'Bangalore'),
  (4, 'Priya Singh', 'priya@mail.com', '8822456198', 'Chennai'),
  (5, 'John Doe', 'john@mail.com', '9095673450', 'Kolkata');

-- Insert data into Orders
INSERT INTO Orders VALUES
  (1, 1, '2025-08-20', 'Completed'),
  (2, 1, '2025-08-28', 'Pending'),
  (3, 2, '2025-07-19', 'Completed'),
  (4, 4, '2025-09-01', 'Pending'),
  (5, 2, '2025-08-22', 'Completed');

-- 1. List all books with price above 500.
SELECT * FROM Books WHERE Price > 500;

-- 2. Show books published after 2015.
SELECT * FROM Books WHERE PublishedYear > 2015;

-- 3. Find customers from a specific city ('Delhi' example).
SELECT * FROM Customers WHERE Address = 'Delhi';

-- 4. Display books by a given author name ('J.K. Rowling' example).
SELECT b.* FROM Books b
JOIN Authors a ON b.AuthorID = a.AuthorID
WHERE a.Name = 'J.K. Rowling';

-- 5. List top 3 most expensive books.
SELECT * FROM Books ORDER BY Price DESC LIMIT 3;

-- 6. Count total number of books in each category.
SELECT c.CategoryName, COUNT(b.BookID) AS BookCount
FROM Categories c
LEFT JOIN Books b ON c.CategoryID = b.CategoryID
GROUP BY c.CategoryID, c.CategoryName;

-- 7. Show orders placed in the last 30 days.
SELECT * FROM Orders WHERE OrderDate >= CURDATE() - INTERVAL 30 DAY;

-- 8. Display customer name and total orders placed.
SELECT c.Name, COUNT(o.OrderID) AS TotalOrders
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.Name;

-- 9. List books with stock less than 10.
SELECT * FROM Books WHERE Stock < 10;

-- 10. Find authors with more than 5 books.
SELECT a.Name, COUNT(b.BookID) AS BookCount
FROM Authors a
JOIN Books b ON a.AuthorID = b.AuthorID
GROUP BY a.AuthorID, a.Name
HAVING COUNT(b.BookID) > 5;

-- 11. Show books with category name.
SELECT b.Title, c.CategoryName
FROM Books b
JOIN Categories c ON b.CategoryID = c.CategoryID;

-- 12. Find total sales amount for a given order (Note: Assumes relevant order-item linking table exists. Adapt if needed.)
SELECT o.OrderID, SUM(b.Price) AS TotalAmount
FROM Orders o
JOIN Books b ON b.BookID IN (SELECT BookID FROM Books LIMIT 1) -- Placeholder for actual order items
WHERE o.OrderID = 1
GROUP BY o.OrderID;

-- 13. Show orders with status "Pending".
SELECT * FROM Orders WHERE Status = 'Pending';

-- 14. List authors from 'India'.
SELECT * FROM Authors WHERE Country = 'India';

-- 15. Find customers who have never placed an order.
SELECT * FROM Customers WHERE CustomerID NOT IN (SELECT CustomerID FROM Orders);

-- 16. Show average price of books in each category.
SELECT c.CategoryName, AVG(b.Price) AS AvgPrice
FROM Categories c
JOIN Books b ON c.CategoryID = b.CategoryID
GROUP BY c.CategoryID, c.CategoryName;

-- 17. List all books sorted by PublishedYear descending.
SELECT * FROM Books ORDER BY PublishedYear DESC;

-- 18. Show most recent order for each customer.
SELECT o.*
FROM Orders o
JOIN (
  SELECT CustomerID, MAX(OrderDate) AS LatestOrder
  FROM Orders
  GROUP BY CustomerID
) recent
ON o.CustomerID = recent.CustomerID AND o.OrderDate = recent.LatestOrder;

-- 19. Find categories with no books.
SELECT c.*
FROM Categories c
LEFT JOIN Books b ON c.CategoryID = b.CategoryID
WHERE b.BookID IS NULL;

-- 20. List all distinct cities from customers.
SELECT DISTINCT Address FROM Customers;

-- 21. Show total number of customers.
SELECT COUNT(*) AS TotalCustomers FROM Customers;

-- 22. Display orders with customer name and order date.
SELECT o.OrderID, c.Name, o.OrderDate
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID;

-- 23. Find the cheapest book in each category.
SELECT b.*
FROM Books b
JOIN (
  SELECT CategoryID, MIN(Price) AS MinPrice
  FROM Books
  GROUP BY CategoryID
) cheap
ON b.CategoryID = cheap.CategoryID AND b.Price = cheap.MinPrice;

-- 24. List customers who ordered books by a specific author ('R. K. Narayan').
SELECT DISTINCT c.*
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN Books b ON b.AuthorID = (SELECT AuthorID FROM Authors WHERE Name = 'R. K. Narayan')
WHERE b.BookID IN (SELECT BookID FROM Books WHERE AuthorID = b.AuthorID);

-- 25. Show books whose title contains the word 'Guide'.
SELECT * FROM Books WHERE Title LIKE '%Guide%';

-- set 2
CREATE DATABASE HospitalManagement;
USE HospitalManagement;

CREATE TABLE Doctors (
  DoctorID INT PRIMARY KEY,
  Name VARCHAR(100),
  Specialization VARCHAR(50),
  Phone VARCHAR(15),
  JoiningDate DATE
);

CREATE TABLE Patients (
  PatientID INT PRIMARY KEY,
  Name VARCHAR(100),
  DOB DATE,
  Gender VARCHAR(10),
  Phone VARCHAR(15)
);

CREATE TABLE Appointments (
  AppointmentID INT PRIMARY KEY,
  PatientID INT,
  DoctorID INT,
  Date DATE,
  Time TIME,
  Status VARCHAR(20),
  FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
  FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);

CREATE TABLE Departments (
  DeptID INT PRIMARY KEY,
  DeptName VARCHAR(50),
  Location VARCHAR(100)
);

CREATE TABLE Bills (
  BillID INT PRIMARY KEY,
  PatientID INT,
  Amount DECIMAL(10, 2),
  BillDate DATE,
  PaymentStatus VARCHAR(20),
  FOREIGN KEY (PatientID) REFERENCES Patients(PatientID)
);

-- Insert data into Doctors
INSERT INTO Doctors VALUES
  (1, 'Dr. Asha Patel', 'Cardiology', '9876543210', '2018-06-15'),
  (2, 'Dr. Raj Singh', 'Neurology', '9812345678', '2021-09-10'),
  (3, 'Dr. Meera Kulkarni', 'Orthopedics', '9823456789', '2015-02-05'),
  (4, 'Dr. Vikram Desai', 'Cardiology', '9898765432', '2019-11-20'),
  (5, 'Dr. Sunita Rao', 'Pediatrics', '9801234567', '2022-01-03');

-- Insert data into Patients
INSERT INTO Patients VALUES
  (1, 'Anil Kumar', '1950-04-12', 'Male', '9123456789'),
  (2, 'Sunita Sharma', '1985-08-20', 'Female', '9234567890'),
  (3, 'Rajesh Singh', '1970-12-30', 'Male', '9345678901'),
  (4, 'Pooja Joshi', '2001-06-15', 'Female', '9456789012'),
  (5, 'Mohit Verma', '1940-01-22', 'Male', '9567890123');

-- Insert data into Appointments
INSERT INTO Appointments VALUES
  (1, 1, 1, '2025-09-04', '10:00:00', 'Scheduled'),
  (2, 2, 2, '2025-09-04', '11:30:00', 'Cancelled'),
  (3, 3, 3, '2025-09-01', '09:00:00', 'Completed'),
  (4, 4, 4, '2025-08-30', '14:00:00', 'Completed'),
  (5, 5, 5, '2025-09-02', '10:30:00', 'Scheduled');

-- Insert data into Departments
INSERT INTO Departments VALUES
  (1, 'Cardiology', 'Floor 1'),
  (2, 'Neurology', 'Floor 2'),
  (3, 'Orthopedics', 'Floor 3'),
  (4, 'Pediatrics', 'Floor 4'),
  (5, 'Radiology', 'Floor 5');

-- Insert data into Bills
INSERT INTO Bills VALUES
  (1, 1, 7000.50, '2025-08-15', 'Paid'),
  (2, 2, 3200.00, '2025-08-20', 'Unpaid'),
  (3, 3, 12000.00, '2025-07-10', 'Paid'),
  (4, 4, 4500.25, '2025-08-25', 'Unpaid'),
  (5, 5, 6000.00, '2025-09-01', 'Paid');

-- 1. List doctors with specialization 'Cardiology'.
SELECT * FROM Doctors WHERE Specialization = 'Cardiology';

-- 2. Show all patients above 60 years old.
SELECT * FROM Patients WHERE DOB <= CURDATE() - INTERVAL 60 YEAR;

-- 3. Find appointments scheduled for today.
SELECT * FROM Appointments WHERE Date = CURDATE();

-- 4. Count total patients per department (based on doctors assigned to department by specialization).
SELECT d.DeptName, COUNT(DISTINCT a.PatientID) AS TotalPatients
FROM Departments d
LEFT JOIN Doctors doc ON d.DeptName = doc.Specialization
LEFT JOIN Appointments a ON doc.DoctorID = a.DoctorID
GROUP BY d.DeptID, d.DeptName;

-- 5. Show patients assigned to a specific doctor (DoctorID = 1 example).
SELECT DISTINCT p.*
FROM Patients p
JOIN Appointments a ON p.PatientID = a.PatientID
WHERE a.DoctorID = 1;

-- 6. List bills with amount greater than 5000.
SELECT * FROM Bills WHERE Amount > 5000;

-- 7. Display unpaid bills.
SELECT * FROM Bills WHERE PaymentStatus = 'Unpaid';

-- 8. Show the doctor with the maximum appointments.
SELECT doc.Name, COUNT(a.AppointmentID) AS AppointmentCount
FROM Doctors doc
JOIN Appointments a ON doc.DoctorID = a.DoctorID
GROUP BY doc.DoctorID, doc.Name
ORDER BY AppointmentCount DESC
LIMIT 1;

-- 9. List patients without appointments.
SELECT * FROM Patients WHERE PatientID NOT IN (SELECT DISTINCT PatientID FROM Appointments);

-- 10. Find oldest patient.
SELECT * FROM Patients ORDER BY DOB ASC LIMIT 1;

-- 11. Show average bill amount per department (linked through patient's appointments and doctors).
SELECT d.DeptName, AVG(b.Amount) AS AvgBill
FROM Departments d
JOIN Doctors doc ON d.DeptName = doc.Specialization
JOIN Appointments a ON doc.DoctorID = a.DoctorID
JOIN Bills b ON a.PatientID = b.PatientID
GROUP BY d.DeptID, d.DeptName;

-- 12. List doctors joined after 2020.
SELECT * FROM Doctors WHERE JoiningDate > '2020-12-31';

-- 13. Find patients whose name starts with 'A'.
SELECT * FROM Patients WHERE Name LIKE 'A%';

-- 14. Show all cancelled appointments.
SELECT * FROM Appointments WHERE Status = 'Cancelled';

-- 15. Count appointments per day.
SELECT Date, COUNT(*) AS AppointmentCount
FROM Appointments
GROUP BY Date;

-- 16. Find patients who visited more than 3 times.
SELECT p.PatientID, p.Name, COUNT(a.AppointmentID) AS VisitCount
FROM Patients p
JOIN Appointments a ON p.PatientID = a.PatientID
GROUP BY p.PatientID, p.Name
HAVING VisitCount > 3;

-- 17. Show department names with their doctors.
SELECT d.DeptName, doc.Name AS DoctorName
FROM Departments d
LEFT JOIN Doctors doc ON d.DeptName = doc.Specialization
ORDER BY d.DeptName;

-- 18. Find doctors working in 'Neurology'.
SELECT * FROM Doctors WHERE Specialization = 'Neurology';

-- 19. Display total bills for each patient.
SELECT p.PatientID, p.Name, SUM(b.Amount) AS TotalBills
FROM Patients p
LEFT JOIN Bills b ON p.PatientID = b.PatientID
GROUP BY p.PatientID, p.Name;

-- 20. Show top 5 highest billing patients.
SELECT p.PatientID, p.Name, SUM(b.Amount) AS TotalBills
FROM Patients p
JOIN Bills b ON p.PatientID = b.PatientID
GROUP BY p.PatientID, p.Name
ORDER BY TotalBills DESC
LIMIT 5;

-- 21. List appointments with doctor and patient names.
SELECT a.AppointmentID, p.Name AS PatientName, doc.Name AS DoctorName, a.Date, a.Time, a.Status
FROM Appointments a
JOIN Patients p ON a.PatientID = p.PatientID
JOIN Doctors doc ON a.DoctorID = doc.DoctorID;

-- 22. Find departments without doctors.
SELECT d.*
FROM Departments d
LEFT JOIN Doctors doc ON d.DeptName = doc.Specialization
WHERE doc.DoctorID IS NULL;

-- 23. List doctors with phone starting with '98'.
SELECT * FROM Doctors WHERE Phone LIKE '98%';

-- 24. Show patients admitted in last 7 days (assuming admission means appointment date).
SELECT DISTINCT p.*
FROM Patients p
JOIN Appointments a ON p.PatientID = a.PatientID
WHERE a.Date >= CURDATE() - INTERVAL 7 DAY;

-- 25. Display doctors and their total billing amounts.
SELECT doc.DoctorID, doc.Name, SUM(b.Amount) AS TotalBilling
FROM Doctors doc
JOIN Appointments a ON doc.DoctorID = a.DoctorID
JOIN Bills b ON a.PatientID = b.PatientID
GROUP BY doc.DoctorID, doc.Name;

-- set 3
CREATE DATABASE UniversityManagement;
USE UniversityManagement;

CREATE TABLE Departments (
  DeptID INT PRIMARY KEY,
  DeptName VARCHAR(100),
  HOD VARCHAR(100)
);

CREATE TABLE Students (
  StudentID INT PRIMARY KEY,
  Name VARCHAR(100),
  DOB DATE,
  Gender VARCHAR(10),
  DeptID INT,
  Email VARCHAR(100),
  FOREIGN KEY (DeptID) REFERENCES Departments(DeptID)
);

CREATE TABLE Courses (
  CourseID INT PRIMARY KEY,
  CourseName VARCHAR(100),
  DeptID INT,
  Credits INT,
  FOREIGN KEY (DeptID) REFERENCES Departments(DeptID)
);

CREATE TABLE Faculty (
  FacultyID INT PRIMARY KEY,
  Name VARCHAR(100),
  DeptID INT,
  Email VARCHAR(100),
  FOREIGN KEY (DeptID) REFERENCES Departments(DeptID)
);

CREATE TABLE Enrollments (
  EnrollmentID INT PRIMARY KEY,
  StudentID INT,
  CourseID INT,
  Semester VARCHAR(10),
  Grade CHAR(2),
  FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
  FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

-- Insert sample Departments
INSERT INTO Departments VALUES
  (1, 'Computer Science', 'Dr. R. Gupta'),
  (2, 'Physics', 'Dr. S. Mehta'),
  (3, 'Mathematics', 'Dr. A. Sharma'),
  (4, 'Chemistry', 'Dr. T. Rao'),
  (5, 'Biology', 'Dr. N. Singh');

-- Insert sample Students
INSERT INTO Students VALUES
  (1, 'Sandeep Kumar', '2002-05-12', 'Male', 1, 'sandeep@uni.edu'),
  (2, 'Anjali Sharma', '2001-11-30', 'Female', 2, 'anjali@uni.edu'),
  (3, 'Rohan Singh', '2003-07-22', 'Male', 3, 'rohan@uni.edu'),
  (4, 'Pooja Patel', '2000-09-15', 'Female', 1, 'pooja@uni.edu'),
  (5, 'Simran Kaur', '2004-02-12', 'Female', 4, 'simran@uni.edu');

-- Insert sample Courses
INSERT INTO Courses VALUES
  (1, 'Data Structures', 1, 4),
  (2, 'Quantum Mechanics', 2, 3),
  (3, 'Linear Algebra', 3, 4),
  (4, 'Organic Chemistry', 4, 3),
  (5, 'Genetics', 5, 3);

-- Insert sample Faculty
INSERT INTO Faculty VALUES
  (1, 'Dr. R. Gupta', 1, 'rgupta@uni.edu'),
  (2, 'Dr. S. Mehta', 2, 'smehta@uni.edu'),
  (3, 'Dr. A. Sharma', 3, 'asharma@uni.edu'),
  (4, 'Dr. T. Rao', 4, 'trao@uni.edu'),
  (5, 'Dr. N. Singh', 5, 'nsingh@uni.edu');

-- Insert sample Enrollments
INSERT INTO Enrollments VALUES
  (1, 1, 1, '2025S1', 'A'),
  (2, 2, 2, '2025S1', 'B'),
  (3, 3, 3, '2025S1', 'C'),
  (4, 4, 1, '2025S1', 'B'),
  (5, 5, 4, '2025S1', 'A'),
  (6, 1, 3, '2025S1', 'A'),
  (7, 4, 3, '2025S1', 'B');

-- 1. List students in 'Computer Science' department.
SELECT s.*
FROM Students s
JOIN Departments d ON s.DeptID = d.DeptID
WHERE d.DeptName = 'Computer Science';

-- 2. Show courses with more than 3 credits.
SELECT * FROM Courses WHERE Credits > 3;

-- 3. Find students born after 2000.
SELECT * FROM Students WHERE DOB > '2000-01-01';

-- 4. Show average grade per course.
SELECT c.CourseName, AVG(CASE
  WHEN e.Grade = 'A' THEN 4
  WHEN e.Grade = 'B' THEN 3
  WHEN e.Grade = 'C' THEN 2
  WHEN e.Grade = 'D' THEN 1
  ELSE 0 END) AS AvgGradePoint
FROM Courses c
LEFT JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY c.CourseName;

-- 5. List faculty members in 'Physics' department.
SELECT f.*
FROM Faculty f
JOIN Departments d ON f.DeptID = d.DeptID
WHERE d.DeptName = 'Physics';

-- 6. Count total students per department.
SELECT d.DeptName, COUNT(s.StudentID) AS StudentCount
FROM Departments d
LEFT JOIN Students s ON d.DeptID = s.DeptID
GROUP BY d.DeptName;

-- 7. Show courses taught by a given faculty (Assuming faculty teaches courses with matching dept).
SELECT c.*
FROM Courses c
JOIN Faculty f ON c.DeptID = f.DeptID
WHERE f.Name = 'Dr. R. Gupta';

-- 8. List students with no enrollments.
SELECT * FROM Students
WHERE StudentID NOT IN (SELECT StudentID FROM Enrollments);

-- 9. Show top 3 scorers in a course (CourseID = 1 example).
SELECT s.Name, e.Grade FROM Enrollments e
JOIN Students s ON e.StudentID = s.StudentID
WHERE e.CourseID = 1
ORDER BY CASE e.Grade
  WHEN 'A' THEN 1
  WHEN 'B' THEN 2
  WHEN 'C' THEN 3
  WHEN 'D' THEN 4
  ELSE 5 END
LIMIT 3;

-- 10. Display students enrolled in more than 4 courses.
SELECT s.StudentID, s.Name, COUNT(e.CourseID) AS CourseCount
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
GROUP BY s.StudentID, s.Name
HAVING CourseCount > 4;

-- 11. Find courses with no enrollments.
SELECT c.*
FROM Courses c
LEFT JOIN Enrollments e ON c.CourseID = e.CourseID
WHERE e.EnrollmentID IS NULL;

-- 12. Show department names with total faculty.
SELECT d.DeptName, COUNT(f.FacultyID) AS FacultyCount
FROM Departments d
LEFT JOIN Faculty f ON d.DeptID = f.DeptID
GROUP BY d.DeptName;

-- 13. List all courses taken by a specific student (StudentID = 1 example).
SELECT c.*
FROM Courses c
JOIN Enrollments e ON c.CourseID = e.CourseID
WHERE e.StudentID = 1;

-- 14. Find students whose name starts with 'S'.
SELECT * FROM Students WHERE Name LIKE 'S%';

-- 15. Show the youngest student.
SELECT * FROM Students ORDER BY DOB DESC LIMIT 1;

-- 16. List students and their average grade.
SELECT s.Name, AVG(CASE
  WHEN e.Grade = 'A' THEN 4
  WHEN e.Grade = 'B' THEN 3
  WHEN e.Grade = 'C' THEN 2
  WHEN e.Grade = 'D' THEN 1
  ELSE 0 END) AS AvgGradePoint
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
GROUP BY s.StudentID, s.Name;

-- 17. Find departments without students.
SELECT d.*
FROM Departments d
LEFT JOIN Students s ON d.DeptID = s.DeptID
WHERE s.StudentID IS NULL;

-- 18. Show faculty email addresses.
SELECT Email FROM Faculty;

-- 19. List students enrolled in 'Mathematics' course (CourseName example).
SELECT s.*
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
JOIN Courses c ON e.CourseID = c.CourseID
WHERE c.CourseName = 'Mathematics';

-- 20. Show total credits taken by each student.
SELECT s.Name, SUM(c.Credits) AS TotalCredits
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
JOIN Courses c ON e.CourseID = c.CourseID
GROUP BY s.StudentID, s.Name;

-- 21. Find students with failing grades (assuming 'D' and below is failing).
SELECT DISTINCT s.*
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
WHERE e.Grade IN ('D', 'F');

-- 22. List courses with maximum students.
SELECT c.CourseName, COUNT(e.StudentID) AS NumStudents
FROM Courses c
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY c.CourseName
ORDER BY NumStudents DESC
LIMIT 1;

-- 23. Show grade distribution per course.
SELECT c.CourseName, e.Grade, COUNT(*) AS GradeCount
FROM Courses c
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY c.CourseName, e.Grade;

-- 24. Display students and their department names.
SELECT s.Name, d.DeptName
FROM Students s
JOIN Departments d ON s.DeptID = d.DeptID;

-- 25. Find the oldest faculty member.
SELECT * FROM Faculty ORDER BY FacultyID ASC LIMIT 1;

-- set 4
CREATE DATABASE AirlineReservation;
USE AirlineReservation;

CREATE TABLE Airlines (
  AirlineID INT PRIMARY KEY,
  AirlineName VARCHAR(100),
  Country VARCHAR(50)
);

CREATE TABLE Flights (
  FlightID INT PRIMARY KEY,
  AirlineID INT,
  Source VARCHAR(50),
  Destination VARCHAR(50),
  DepartureTime TIME,
  ArrivalTime TIME,
  Price DECIMAL(10,2),
  FOREIGN KEY (AirlineID) REFERENCES Airlines(AirlineID)
);

CREATE TABLE Passengers (
  PassengerID INT PRIMARY KEY,
  Name VARCHAR(100),
  PassportNo VARCHAR(20),
  Nationality VARCHAR(50),
  DOB DATE
);

CREATE TABLE Bookings (
  BookingID INT PRIMARY KEY,
  FlightID INT,
  PassengerID INT,
  BookingDate DATE,
  SeatNo VARCHAR(10),
  Status VARCHAR(20),
  FOREIGN KEY (FlightID) REFERENCES Flights(FlightID),
  FOREIGN KEY (PassengerID) REFERENCES Passengers(PassengerID)
);

CREATE TABLE Payments (
  PaymentID INT PRIMARY KEY,
  BookingID INT,
  Amount DECIMAL(10,2),
  PaymentDate DATE,
  Method VARCHAR(50),
  FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID)
);

-- Insert sample Airlines
INSERT INTO Airlines VALUES
  (1, 'Air India', 'India'),
  (2, 'American Airlines', 'USA'),
  (3, 'Emirates', 'UAE'),
  (4, 'British Airways', 'UK'),
  (5, 'Lufthansa', 'Germany');

-- Insert sample Flights
INSERT INTO Flights VALUES
  (1, 1, 'Delhi', 'Mumbai', '18:30:00', '20:30:00', 6500.00),
  (2, 2, 'New York', 'London', '22:00:00', '10:00:00', 12000.00),
  (3, 3, 'Dubai', 'Paris', '15:00:00', '19:30:00', 9000.00),
  (4, 4, 'London', 'Delhi', '09:00:00', '21:00:00', 8500.00),
  (5, 5, 'Frankfurt', 'New York', '13:00:00', '16:00:00', 11000.00);

-- Insert sample Passengers
INSERT INTO Passengers VALUES
  (1, 'Amit Sharma', 'M1234567', 'India', '1990-05-15'),
  (2, 'John Doe', 'N7654321', 'USA', '1985-10-22'),
  (3, 'Sara Khan', 'P2345678', 'UAE', '1995-03-12'),
  (4, 'Michael Smith', 'Q8765432', 'UK', '1980-07-30'),
  (5, 'Anna Mueller', 'R3456789', 'Germany', '1992-12-05');

-- Insert sample Bookings
INSERT INTO Bookings VALUES
  (1, 1, 1, '2025-08-15', '12A', 'Confirmed'),
  (2, 2, 2, '2025-08-10', '14B', 'Cancelled'),
  (3, 3, 3, '2025-08-18', '22C', 'Confirmed'),
  (4, 4, 4, '2025-08-20', '18D', 'Confirmed'),
  (5, 1, 5, '2025-08-25', '20E', 'Confirmed'),
  (6, 1, 1, '2025-08-28', '13A', 'Confirmed');

-- Insert sample Payments
INSERT INTO Payments VALUES
  (1, 1, 6500.00, '2025-08-16', 'Credit Card'),
  (2, 3, 9000.00, '2025-08-19', 'Cash'),
  (3, 4, 8500.00, '2025-08-21', 'Online'),
  (4, 5, 6500.00, '2025-08-26', 'Credit Card'),
  (5, 6, 6500.00, '2025-08-29', 'Debit Card');

-- 1. List all flights from 'Delhi' to 'Mumbai'.
SELECT * FROM Flights WHERE Source = 'Delhi' AND Destination = 'Mumbai';

-- 2. Show flights departing after 6 PM.
SELECT * FROM Flights WHERE DepartureTime > '18:00:00';

-- 3. Find passengers with nationality 'India'.
SELECT * FROM Passengers WHERE Nationality = 'India';

-- 4. List bookings with status 'Confirmed'.
SELECT * FROM Bookings WHERE Status = 'Confirmed';

-- 5. Show all bookings for a given passenger name ('Amit Sharma').
SELECT b.*
FROM Bookings b
JOIN Passengers p ON b.PassengerID = p.PassengerID
WHERE p.Name = 'Amit Sharma';

-- 6. Count total flights operated by each airline.
SELECT a.AirlineName, COUNT(f.FlightID) AS TotalFlights
FROM Airlines a
LEFT JOIN Flights f ON a.AirlineID = f.AirlineID
GROUP BY a.AirlineID, a.AirlineName;

-- 7. Find passengers who booked more than 3 flights.
SELECT p.Name, COUNT(b.BookingID) AS FlightCount
FROM Passengers p
JOIN Bookings b ON p.PassengerID = b.PassengerID
GROUP BY p.PassengerID, p.Name
HAVING FlightCount > 3;

-- 8. Show the most expensive flight.
SELECT * FROM Flights ORDER BY Price DESC LIMIT 1;

-- 9. List all airlines operating in 'USA'.
SELECT * FROM Airlines WHERE Country = 'USA';

-- 10. Display bookings made in the last 7 days.
SELECT * FROM Bookings WHERE BookingDate >= CURDATE() - INTERVAL 7 DAY;

-- 11. Show average price of flights per airline.
SELECT a.AirlineName, AVG(f.Price) AS AvgPrice
FROM Airlines a
JOIN Flights f ON a.AirlineID = f.AirlineID
GROUP BY a.AirlineID, a.AirlineName;

-- 12. List passengers without any bookings.
SELECT * FROM Passengers WHERE PassengerID NOT IN (SELECT PassengerID FROM Bookings);

-- 13. Find flights with no bookings.
SELECT f.*
FROM Flights f
LEFT JOIN Bookings b ON f.FlightID = b.FlightID
WHERE b.BookingID IS NULL;

-- 14. Show passengers with passport numbers starting with 'M'.
SELECT * FROM Passengers WHERE PassportNo LIKE 'M%';

-- 15. List all bookings along with passenger names and flight details.
SELECT b.BookingID, p.Name AS PassengerName, f.Source, f.Destination, f.DepartureTime, f.ArrivalTime, b.Status
FROM Bookings b
JOIN Passengers p ON b.PassengerID = p.PassengerID
JOIN Flights f ON b.FlightID = f.FlightID;

-- 16. Show top 5 highest payment transactions.
SELECT * FROM Payments ORDER BY Amount DESC LIMIT 5;

-- 17. Count number of passengers on each flight.
SELECT f.FlightID, COUNT(b.BookingID) AS PassengerCount
FROM Flights f
LEFT JOIN Bookings b ON f.FlightID = b.FlightID AND b.Status = 'Confirmed'
GROUP BY f.FlightID;

-- 18. Find flights arriving before 10 AM.
SELECT * FROM Flights WHERE ArrivalTime < '10:00:00';

-- 19. Show flights along with airline names.
SELECT f.*, a.AirlineName
FROM Flights f
JOIN Airlines a ON f.AirlineID = a.AirlineID;

-- 20. Find passengers with multiple bookings on the same date.
SELECT p.Name, b.BookingDate, COUNT(*) AS BookingCount
FROM Bookings b
JOIN Passengers p ON b.PassengerID = p.PassengerID
GROUP BY p.Name, b.BookingDate
HAVING BookingCount > 1;

-- 21. Show payment methods used and their total amounts.
SELECT Method, SUM(Amount) AS TotalAmount
FROM Payments
GROUP BY Method;

-- 22. List passengers who booked flights in the last month.
SELECT DISTINCT p.*
FROM Passengers p
JOIN Bookings b ON p.PassengerID = b.PassengerID
WHERE b.BookingDate >= CURDATE() - INTERVAL 1 MONTH;

-- 23. Show all flights priced between 5000 and 10000.
SELECT * FROM Flights WHERE Price BETWEEN 5000 AND 10000;

-- 24. Find passengers whose DOB is after 2000.
SELECT * FROM Passengers WHERE DOB > '2000-01-01';

-- 25. List airlines with no flights scheduled.
SELECT a.*
FROM Airlines a
LEFT JOIN Flights f ON a.AirlineID = f.AirlineID
WHERE f.FlightID IS NULL;

-- set 5
CREATE DATABASE HotelManagement;
USE HotelManagement;

CREATE TABLE Hotels (
  HotelID INT PRIMARY KEY,
  HotelName VARCHAR(100),
  Location VARCHAR(100),
  Rating DECIMAL(2,1)
);

CREATE TABLE Rooms (
  RoomID INT PRIMARY KEY,
  HotelID INT,
  RoomType VARCHAR(50),
  PricePerNight DECIMAL(10,2),
  Availability BOOLEAN,
  FOREIGN KEY (HotelID) REFERENCES Hotels(HotelID)
);

CREATE TABLE Guests (
  GuestID INT PRIMARY KEY,
  Name VARCHAR(100),
  Phone VARCHAR(15),
  Email VARCHAR(100),
  Address VARCHAR(255)
);

CREATE TABLE Reservations (
  ReservationID INT PRIMARY KEY,
  RoomID INT,
  GuestID INT,
  CheckInDate DATE,
  CheckOutDate DATE,
  Status VARCHAR(20),
  FOREIGN KEY (RoomID) REFERENCES Rooms(RoomID),
  FOREIGN KEY (GuestID) REFERENCES Guests(GuestID)
);

CREATE TABLE Payments (
  PaymentID INT PRIMARY KEY,
  ReservationID INT,
  Amount DECIMAL(10,2),
  PaymentDate DATE,
  Method VARCHAR(50),
  FOREIGN KEY (ReservationID) REFERENCES Reservations(ReservationID)
);

-- Insert sample Hotels
INSERT INTO Hotels VALUES
  (1, 'The Grand', 'Mumbai', 4.5),
  (2, 'Sunrise Palace', 'Delhi', 4.2),
  (3, 'Ocean View', 'Goa', 3.9),
  (4, 'Mountain Retreat', 'Manali', 4.8),
  (5, 'City Inn', 'Mumbai', 3.5);

-- Insert sample Rooms
INSERT INTO Rooms VALUES
  (1, 1, 'Deluxe', 3500.00, TRUE),
  (2, 1, 'Suite', 7000.00, TRUE),
  (3, 2, 'Standard', 2500.00, TRUE),
  (4, 3, 'Deluxe', 3000.00, FALSE),
  (5, 4, 'Suite', 8000.00, TRUE),
  (6, 5, 'Standard', 1800.00, TRUE);

-- Insert sample Guests
INSERT INTO Guests VALUES
  (1, 'Rahul Singh', '9876543210', 'rahul@mail.com', 'Mumbai'),
  (2, 'Anita Desai', '9812345678', 'anita@mail.com', 'Delhi'),
  (3, 'Suresh Kumar', '9900112233', 'suresh@mail.com', 'Goa'),
  (4, 'Priya Nair', '9888776655', 'priya@mail.com', 'Manali'),
  (5, 'John Smith', '9654321789', 'john@mail.com', 'Mumbai');

-- Insert sample Reservations
INSERT INTO Reservations VALUES
  (1, 1, 1, '2025-08-15', '2025-08-20', 'Checked-Out'),
  (2, 2, 2, '2025-08-25', '2025-08-30', 'Checked-In'),
  (3, 3, 3, '2025-08-10', '2025-08-15', 'Cancelled'),
  (4, 5, 4, '2025-08-05', '2025-08-10', 'Checked-Out'),
  (5, 6, 5, '2025-08-20', '2025-08-25', 'Checked-In');

-- Insert sample Payments
INSERT INTO Payments VALUES
  (1, 1, 17500.00, '2025-08-20', 'Credit Card'),
  (2, 2, 35000.00, '2025-08-26', 'Cash'),
  (3, 4, 40000.00, '2025-08-10', 'Debit Card'),
  (4, 5, 9000.00, '2025-08-22', 'Credit Card');

-- 1. List all hotels in 'Mumbai'.
SELECT * FROM Hotels WHERE Location = 'Mumbai';

-- 2. Show rooms with price above 3000 per night.
SELECT * FROM Rooms WHERE PricePerNight > 3000;

-- 3. Find available rooms in a given hotel (HotelID = 1 example).
SELECT * FROM Rooms WHERE HotelID = 1 AND Availability = TRUE;

-- 4. List guests with reservations in a specific hotel (HotelID = 1 example).
SELECT DISTINCT g.*
FROM Guests g
JOIN Reservations r ON g.GuestID = r.GuestID
JOIN Rooms rm ON r.RoomID = rm.RoomID
WHERE rm.HotelID = 1;

-- 5. Show reservations with status 'Checked-In'.
SELECT * FROM Reservations WHERE Status = 'Checked-In';

-- 6. Count rooms by type for each hotel.
SELECT h.HotelName, rm.RoomType, COUNT(rm.RoomID) AS RoomCount
FROM Hotels h
JOIN Rooms rm ON h.HotelID = rm.HotelID
GROUP BY h.HotelName, rm.RoomType;

-- 7. Find guests who stayed more than 5 nights.
SELECT g.Name, DATEDIFF(r.CheckOutDate, r.CheckInDate) AS NightsStayed
FROM Guests g
JOIN Reservations r ON g.GuestID = r.GuestID
WHERE DATEDIFF(r.CheckOutDate, r.CheckInDate) > 5;

-- 8. Show top 3 most expensive room types.
SELECT DISTINCT RoomType, PricePerNight
FROM Rooms
ORDER BY PricePerNight DESC
LIMIT 3;

-- 9. List all reservations in the last month.
SELECT * FROM Reservations WHERE CheckInDate >= CURDATE() - INTERVAL 1 MONTH;

-- 10. Display guests who made more than 2 reservations.
SELECT g.Name, COUNT(r.ReservationID) AS ReservationCount
FROM Guests g
JOIN Reservations r ON g.GuestID = r.GuestID
GROUP BY g.GuestID, g.Name
HAVING ReservationCount > 2;

-- 11. Show hotels with average room price above 4000.
SELECT h.HotelName, AVG(r.PricePerNight) AS AvgPrice
FROM Hotels h
JOIN Rooms r ON h.HotelID = r.HotelID
GROUP BY h.HotelName
HAVING AvgPrice > 4000;

-- 12. List guests from a specific city ('Mumbai').
SELECT * FROM Guests WHERE Address = 'Mumbai';

-- 13. Find hotels without any reservations.
SELECT h.*
FROM Hotels h
LEFT JOIN Rooms r ON h.HotelID = r.HotelID
LEFT JOIN Reservations res ON r.RoomID = res.RoomID
WHERE res.ReservationID IS NULL;

-- 14. Show reservations with guest name, hotel name, and room type.
SELECT res.ReservationID, g.Name AS GuestName, h.HotelName, rm.RoomType
FROM Reservations res
JOIN Guests g ON res.GuestID = g.GuestID
JOIN Rooms rm ON res.RoomID = rm.RoomID
JOIN Hotels h ON rm.HotelID = h.HotelID;

-- 15. Find total revenue for each hotel.
SELECT h.HotelName, SUM(p.Amount) AS TotalRevenue
FROM Hotels h
JOIN Rooms r ON h.HotelID = r.HotelID
JOIN Reservations res ON r.RoomID = res.RoomID
JOIN Payments p ON res.ReservationID = p.ReservationID
GROUP BY h.HotelName;

-- 16. List reservations where check-out date is before check-in date (data check).
SELECT * FROM Reservations WHERE CheckOutDate < CheckInDate;

-- 17. Show payment methods used.
SELECT DISTINCT Method FROM Payments;

-- 18. Find guests who haven’t made any payments.
SELECT g.*
FROM Guests g
LEFT JOIN Reservations res ON g.GuestID = res.GuestID
LEFT JOIN Payments p ON res.ReservationID = p.ReservationID
WHERE p.PaymentID IS NULL;

-- 19. Display reservations sorted by check-in date.
SELECT * FROM Reservations ORDER BY CheckInDate;

-- 20. Find hotels with rating above 4.
SELECT * FROM Hotels WHERE Rating > 4;

-- 21. Show guests who booked suites.
SELECT DISTINCT g.*
FROM Guests g
JOIN Reservations r ON g.GuestID = r.GuestID
JOIN Rooms rm ON r.RoomID = rm.RoomID
WHERE rm.RoomType LIKE '%Suite%';

-- 22. List available rooms in 'Delhi'.
SELECT rm.*
FROM Rooms rm
JOIN Hotels h ON rm.HotelID = h.HotelID
WHERE h.Location = 'Delhi' AND rm.Availability = TRUE;

-- 23. Show total nights stayed per guest.
SELECT g.Name, SUM(DATEDIFF(r.CheckOutDate, r.CheckInDate)) AS TotalNights
FROM Guests g
JOIN Reservations r ON g.GuestID = r.GuestID
GROUP BY g.GuestID, g.Name;

-- 24. Find reservations with overlapping dates for the same room.
SELECT r1.ReservationID, r2.ReservationID, r1.RoomID
FROM Reservations r1
JOIN Reservations r2 ON r1.RoomID = r2.RoomID AND r1.ReservationID <> r2.ReservationID
WHERE r1.CheckInDate < r2.CheckOutDate AND r2.CheckInDate < r1.CheckOutDate;

-- 25. List all distinct cities where hotels are located.
SELECT DISTINCT Location FROM Hotels;

-- set 6
CREATE DATABASE LibraryManagement;
USE LibraryManagement;

CREATE TABLE Authors (
  AuthorID INT PRIMARY KEY,
  Name VARCHAR(100),
  Nationality VARCHAR(50)
);

CREATE TABLE Books (
  BookID INT PRIMARY KEY,
  Title VARCHAR(150),
  AuthorID INT,
  Category VARCHAR(50),
  Price DECIMAL(10,2),
  Stock INT,
  FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID)
);

CREATE TABLE Members (
  MemberID INT PRIMARY KEY,
  Name VARCHAR(100),
  Email VARCHAR(100),
  Phone VARCHAR(15),
  Address VARCHAR(255)
);

CREATE TABLE Loans (
  LoanID INT PRIMARY KEY,
  BookID INT,
  MemberID INT,
  IssueDate DATE,
  ReturnDate DATE,
  Status VARCHAR(20),
  FOREIGN KEY (BookID) REFERENCES Books(BookID),
  FOREIGN KEY (MemberID) REFERENCES Members(MemberID)
);

CREATE TABLE Fines (
  FineID INT PRIMARY KEY,
  LoanID INT,
  Amount DECIMAL(10,2),
  PaymentStatus VARCHAR(20),
  FOREIGN KEY (LoanID) REFERENCES Loans(LoanID)
);

-- Insert sample Authors
INSERT INTO Authors VALUES
  (1, 'Isaac Asimov', 'American'),
  (2, 'J.K. Rowling', 'British'),
  (3, 'Agatha Christie', 'British'),
  (4, 'Chetan Bhagat', 'Indian'),
  (5, 'Arthur C. Clarke', 'British');

-- Insert sample Books
INSERT INTO Books VALUES
  (1, 'Foundation', 1, 'Science Fiction', 550.00, 6),
  (2, 'Harry Potter and the Sorcerer''s Stone', 2, 'Fantasy', 850.00, 12),
  (3, 'Murder on the Orient Express', 3, 'Mystery', 620.00, 4),
  (4, 'One Night at the Call Center', 4, 'Fiction', 450.00, 8),
  (5, '2001: A Space Odyssey', 5, 'Science Fiction', 700.00, 10);

-- Insert sample Members
INSERT INTO Members VALUES
  (1, 'Amit Sharma', 'amit@mail.com', '9876543210', 'Mumbai'),
  (2, 'Priya Singh', 'priya@mail.com', '9812345678', 'Delhi'),
  (3, 'Rohit Kumar', 'rohit@mail.com', '9900112233', 'Bangalore'),
  (4, 'Sneha Verma', 'sneha@mail.com', '9888776655', 'Chennai'),
  (5, 'John Doe', 'john@mail.com', '9654321789', 'Kolkata');

-- Insert sample Loans
INSERT INTO Loans VALUES
  (1, 1, 1, '2025-08-01', '2025-08-15', 'Returned'),
  (2, 2, 2, '2025-08-10', '2025-08-24', 'Overdue'),
  (3, 3, 3, '2025-07-15', '2025-07-30', 'Returned'),
  (4, 4, 4, '2025-08-05', NULL, 'Issued'),
  (5, 5, 5, '2025-08-12', '2025-08-25', 'Returned');

-- Insert sample Fines
INSERT INTO Fines VALUES
  (1, 2, 500.00, 'Unpaid'),
  (2, 4, 300.00, 'Paid');

-- 1. List books in 'Science Fiction' category.
SELECT * FROM Books WHERE Category = 'Science Fiction';

-- 2. Show books with stock less than 5.
SELECT * FROM Books WHERE Stock < 5;

-- 3. Find members with overdue books.
SELECT DISTINCT m.*
FROM Members m
JOIN Loans l ON m.MemberID = l.MemberID
WHERE l.Status = 'Overdue';

-- 4. Show top 3 most expensive books.
SELECT * FROM Books ORDER BY Price DESC LIMIT 3;

-- 5. List all authors from 'India'.
SELECT * FROM Authors WHERE Nationality LIKE '%Indian%';

-- 6. Show books written by a given author ('J.K. Rowling').
SELECT b.*
FROM Books b
JOIN Authors a ON b.AuthorID = a.AuthorID
WHERE a.Name = 'J.K. Rowling';

-- 7. Count total books per category.
SELECT Category, COUNT(BookID) AS BookCount
FROM Books
GROUP BY Category;

-- 8. Find members who borrowed more than 5 books.
SELECT m.MemberID, m.Name, COUNT(l.LoanID) AS BorrowCount
FROM Members m
JOIN Loans l ON m.MemberID = l.MemberID
GROUP BY m.MemberID, m.Name
HAVING BorrowCount > 5;

-- 9. Show loans with status 'Returned'.
SELECT * FROM Loans WHERE Status = 'Returned';

-- 10. Display members who never borrowed any book.
SELECT * FROM Members
WHERE MemberID NOT IN (SELECT DISTINCT MemberID FROM Loans);

-- 11. List all unpaid fines.
SELECT * FROM Fines WHERE PaymentStatus = 'Unpaid';

-- 12. Show total fines paid per member.
SELECT m.Name, SUM(f.Amount) AS TotalFinesPaid
FROM Members m
JOIN Loans l ON m.MemberID = l.MemberID
JOIN Fines f ON l.LoanID = f.LoanID
WHERE f.PaymentStatus = 'Paid'
GROUP BY m.MemberID, m.Name;

-- 13. Find books issued in the last month.
SELECT DISTINCT b.*
FROM Books b
JOIN Loans l ON b.BookID = l.BookID
WHERE l.IssueDate >= CURDATE() - INTERVAL 1 MONTH;

-- 14. Show members who borrowed books in a specific category ('Fantasy').
SELECT DISTINCT m.*
FROM Members m
JOIN Loans l ON m.MemberID = l.MemberID
JOIN Books b ON l.BookID = b.BookID
WHERE b.Category = 'Fantasy';

-- 15. Find authors who wrote more than 3 books.
SELECT a.Name, COUNT(b.BookID) AS BookCount
FROM Authors a
JOIN Books b ON a.AuthorID = b.AuthorID
GROUP BY a.AuthorID, a.Name
HAVING BookCount > 3;

-- 16. List books with price between 200 and 500.
SELECT * FROM Books WHERE Price BETWEEN 200 AND 500;

-- 17. Show average fine amount.
SELECT AVG(Amount) AS AvgFineAmount FROM Fines;

-- 18. Find members with phone numbers starting with '9'.
SELECT * FROM Members WHERE Phone LIKE '9%';

-- 19. Display all loans with book and member details.
SELECT l.LoanID, b.Title, m.Name, l.IssueDate, l.ReturnDate, l.Status
FROM Loans l
JOIN Books b ON l.BookID = b.BookID
JOIN Members m ON l.MemberID = m.MemberID;

-- 20. Show books whose title contains 'History'.
SELECT * FROM Books WHERE Title LIKE '%History%';

-- 21. List members with more than one unpaid fine.
SELECT m.Name, COUNT(f.FineID) AS UnpaidFines
FROM Members m
JOIN Loans l ON m.MemberID = l.MemberID
JOIN Fines f ON l.LoanID = f.LoanID
WHERE f.PaymentStatus = 'Unpaid'
GROUP BY m.MemberID, m.Name
HAVING UnpaidFines > 1;

-- 22. Find books with no loans.
SELECT b.*
FROM Books b
LEFT JOIN Loans l ON b.BookID = l.BookID
WHERE l.LoanID IS NULL;

-- 23. Show most borrowed book.
SELECT b.Title, COUNT(l.LoanID) AS LoanCount
FROM Books b
JOIN Loans l ON b.BookID = l.BookID
GROUP BY b.BookID, b.Title
ORDER BY LoanCount DESC
LIMIT 1;

-- 24. Display top 5 members by total borrowings.
SELECT m.Name, COUNT(l.LoanID) AS BorrowCount
FROM Members m
JOIN Loans l ON m.MemberID = l.MemberID
GROUP BY m.MemberID, m.Name
ORDER BY BorrowCount DESC
LIMIT 5;

-- 25. Show all categories of books available.
SELECT DISTINCT Category FROM Books;

-- set 7
CREATE DATABASE InventoryManagement;
USE InventoryManagement;

CREATE TABLE Suppliers (
  SupplierID INT PRIMARY KEY,
  SupplierName VARCHAR(100),
  Contact VARCHAR(50),
  City VARCHAR(50)
);

CREATE TABLE Categories (
  CategoryID INT PRIMARY KEY,
  CategoryName VARCHAR(50)
);

CREATE TABLE Products (
  ProductID INT PRIMARY KEY,
  ProductName VARCHAR(100),
  CategoryID INT,
  SupplierID INT,
  Price DECIMAL(10,2),
  Stock INT,
  FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID),
  FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
);

CREATE TABLE Purchases (
  PurchaseID INT PRIMARY KEY,
  ProductID INT,
  Quantity INT,
  PurchaseDate DATE,
  SupplierID INT,
  FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
  FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
);

CREATE TABLE Sales (
  SaleID INT PRIMARY KEY,
  ProductID INT,
  Quantity INT,
  SaleDate DATE,
  CustomerName VARCHAR(100),
  FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Insert sample Suppliers
INSERT INTO Suppliers VALUES
  (1, 'ABC Supplies', 'Rahul Kumar', 'Delhi'),
  (2, 'XYZ Traders', 'Anita Sharma', 'Mumbai'),
  (3, 'PQR Distributors', 'Suresh Patel', 'Bangalore'),
  (4, 'LMN Wholesalers', 'Priya Singh', 'Chennai'),
  (5, 'RST Enterprises', 'Vikram Joshi', 'Delhi');

-- Insert sample Categories
INSERT INTO Categories VALUES
  (1, 'Electronics'),
  (2, 'Furniture'),
  (3, 'Stationery'),
  (4, 'Clothing'),
  (5, 'Groceries');

-- Insert sample Products
INSERT INTO Products VALUES
  (1, 'Laptop', 1, 1, 55000.00, 15),
  (2, 'Office Chair', 2, 2, 4500.00, 30),
  (3, 'Notebook', 3, 3, 50.00, 100),
  (4, 'T-Shirt', 4, 4, 300.00, 60),
  (5, 'Rice', 5, 5, 40.00, 200),
  (6, 'Tablet', 1, 1, 22000.00, 7);

-- Insert sample Purchases
INSERT INTO Purchases VALUES
  (1, 1, 10, '2025-08-01', 1),
  (2, 2, 50, '2025-08-05', 2),
  (3, 3, 200, '2025-08-10', 3),
  (4, 4, 100, '2025-08-15', 4),
  (5, 5, 300, '2025-08-20', 5);

-- Insert sample Sales
INSERT INTO Sales VALUES
  (1, 1, 5, '2025-08-12', 'Customer A'),
  (2, 2, 20, '2025-08-13', 'Customer B'),
  (3, 3, 50, '2025-08-14', 'Customer C'),
  (4, 4, 30, '2025-08-15', 'Customer D'),
  (5, 5, 100, '2025-08-16', 'Customer E');

-- 1. List products with stock below 10.
SELECT * FROM Products WHERE Stock < 10;

-- 2. Show top 5 most expensive products.
SELECT * FROM Products ORDER BY Price DESC LIMIT 5;

-- 3. Find suppliers from 'Delhi'.
SELECT * FROM Suppliers WHERE City = 'Delhi';

-- 4. Show products supplied by a given supplier (SupplierID = 1).
SELECT * FROM Products WHERE SupplierID = 1;

-- 5. Count products in each category.
SELECT c.CategoryName, COUNT(p.ProductID) AS ProductCount
FROM Categories c
LEFT JOIN Products p ON c.CategoryID = p.CategoryID
GROUP BY c.CategoryName;

-- 6. Find total purchases for a specific product (ProductID = 1).
SELECT ProductID, SUM(Quantity) AS TotalPurchased
FROM Purchases
WHERE ProductID = 1
GROUP BY ProductID;

-- 7. Show products never sold.
SELECT p.*
FROM Products p
LEFT JOIN Sales s ON p.ProductID = s.ProductID
WHERE s.SaleID IS NULL;

-- 8. Display sales in the last week.
SELECT * FROM Sales WHERE SaleDate >= CURDATE() - INTERVAL 7 DAY;

-- 9. Show products with sales quantity above 50.
SELECT p.ProductName, SUM(s.Quantity) AS TotalSold
FROM Products p
JOIN Sales s ON p.ProductID = s.ProductID
GROUP BY p.ProductID, p.ProductName
HAVING TotalSold > 50;

-- 10. List suppliers who supplied more than 5 products.
SELECT s.SupplierName, COUNT(p.ProductID) AS ProductCount
FROM Suppliers s
JOIN Products p ON s.SupplierID = p.SupplierID
GROUP BY s.SupplierID, s.SupplierName
HAVING ProductCount > 5;

-- 11. Show average price per category.
SELECT c.CategoryName, AVG(p.Price) AS AvgPrice
FROM Categories c
JOIN Products p ON c.CategoryID = p.CategoryID
GROUP BY c.CategoryName;

-- 12. Find top selling product.
SELECT p.ProductName, SUM(s.Quantity) AS TotalSold
FROM Products p
JOIN Sales s ON p.ProductID = s.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY TotalSold DESC
LIMIT 1;

-- 13. Show categories without products.
SELECT c.*
FROM Categories c
LEFT JOIN Products p ON c.CategoryID = p.CategoryID
WHERE p.ProductID IS NULL;

-- 14. List all sales with product names.
SELECT s.SaleID, p.ProductName, s.Quantity, s.SaleDate, s.CustomerName
FROM Sales s
JOIN Products p ON s.ProductID = p.ProductID;

-- 15. Show purchases with supplier names.
SELECT pu.PurchaseID, pr.ProductName, su.SupplierName, pu.Quantity, pu.PurchaseDate
FROM Purchases pu
JOIN Products pr ON pu.ProductID = pr.ProductID
JOIN Suppliers su ON pu.SupplierID = su.SupplierID;

-- 16. Display suppliers with no purchases.
SELECT su.*
FROM Suppliers su
LEFT JOIN Purchases pu ON su.SupplierID = pu.SupplierID
WHERE pu.PurchaseID IS NULL;

-- 17. Show most recent purchase date for each product.
SELECT ProductID, MAX(PurchaseDate) AS LastPurchaseDate
FROM Purchases
GROUP BY ProductID;

-- 18. List customers who bought more than 3 products.
SELECT CustomerName, COUNT(DISTINCT ProductID) AS ProductsBought
FROM Sales
GROUP BY CustomerName
HAVING ProductsBought > 3;

-- 19. Show total stock value (Price × Stock).
SELECT ProductName, Price, Stock, (Price * Stock) AS StockValue
FROM Products;

-- 20. Find product with maximum stock.
SELECT * FROM Products ORDER BY Stock DESC LIMIT 1;

-- 21. Show sales grouped by customer.
SELECT CustomerName, SUM(Quantity) AS TotalItemsBought
FROM Sales
GROUP BY CustomerName;

-- 22. Display top 3 customers by sales value.
SELECT CustomerName, SUM(s.Quantity * p.Price) AS TotalSpent
FROM Sales s
JOIN Products p ON s.ProductID = p.ProductID
GROUP BY CustomerName
ORDER BY TotalSpent DESC
LIMIT 3;

-- 23. Show monthly sales totals.
SELECT YEAR(SaleDate) AS Year, MONTH(SaleDate) AS Month, SUM(Quantity) AS TotalSales
FROM Sales
GROUP BY Year, Month
ORDER BY Year, Month;

-- 24. List products purchased but not sold.
SELECT pr.ProductID, pr.ProductName
FROM Products pr
JOIN Purchases pu ON pr.ProductID = pu.ProductID
LEFT JOIN Sales sa ON pr.ProductID = sa.ProductID
GROUP BY pr.ProductID
HAVING COUNT(sa.SaleID) = 0;

-- 25. Find suppliers who supply products in multiple categories.
SELECT s.SupplierName, COUNT(DISTINCT p.CategoryID) AS CategoryCount
FROM Suppliers s
JOIN Products p ON s.SupplierID = p.SupplierID
GROUP BY s.SupplierID, s.SupplierName
HAVING CategoryCount > 1;

-- set 8
CREATE DATABASE OnlineFoodDelivery;
USE OnlineFoodDelivery;

CREATE TABLE Restaurants (
  RestaurantID INT PRIMARY KEY,
  Name VARCHAR(100),
  City VARCHAR(50),
  Rating DECIMAL(2,1)
);

CREATE TABLE MenuItems (
  MenuItemID INT PRIMARY KEY,
  RestaurantID INT,
  ItemName VARCHAR(100),
  Price DECIMAL(10, 2),
  Category VARCHAR(50),
  FOREIGN KEY (RestaurantID) REFERENCES Restaurants(RestaurantID)
);

CREATE TABLE Customers (
  CustomerID INT PRIMARY KEY,
  Name VARCHAR(100),
  Phone VARCHAR(15),
  Address VARCHAR(255)
);

CREATE TABLE Orders (
  OrderID INT PRIMARY KEY,
  CustomerID INT,
  RestaurantID INT,
  OrderDate DATE,
  Status VARCHAR(20),
  FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
  FOREIGN KEY (RestaurantID) REFERENCES Restaurants(RestaurantID)
);

CREATE TABLE DeliveryAgents (
  AgentID INT PRIMARY KEY,
  Name VARCHAR(100),
  Phone VARCHAR(15),
  VehicleNo VARCHAR(20)
);

-- Insert sample Restaurants
INSERT INTO Restaurants VALUES
  (1, 'Spice Villa', 'Bangalore', 4.5),
  (2, 'Ocean Delight', 'Mumbai', 4.2),
  (3, 'Pizza World', 'Delhi', 3.9),
  (4, 'Sweet Tooth', 'Bangalore', 4.7),
  (5, 'Burger Hub', 'Chennai', 4.0);

-- Insert sample MenuItems
INSERT INTO MenuItems VALUES
  (1, 1, 'Paneer Butter Masala', 250.00, 'Main Course'),
  (2, 1, 'Garlic Naan', 50.00, 'Bread'),
  (3, 2, 'Grilled Fish', 450.00, 'Main Course'),
  (4, 3, 'Margherita Pizza', 300.00, 'Pizza'),
  (5, 4, 'Chocolate Brownie', 150.00, 'Dessert'),
  (6, 5, 'Cheese Burger', 200.00, 'Fast Food');

-- Insert sample Customers
INSERT INTO Customers VALUES
  (1, 'Rahul Kumar', '9876543210', 'Bangalore'),
  (2, 'Anita Sharma', '9812345678', 'Mumbai'),
  (3, 'Suresh Patel', '9900112233', 'Delhi'),
  (4, 'Priya Singh', '9888776655', 'Bangalore'),
  (5, 'John Smith', '9654321789', 'Chennai');

-- Insert sample Orders
INSERT INTO Orders VALUES
  (1, 1, 1, '2025-08-15', 'Delivered'),
  (2, 1, 3, '2025-08-16', 'Cancelled'),
  (3, 2, 2, '2025-08-17', 'Delivered'),
  (4, 3, 3, '2025-08-18', 'Delivered'),
  (5, 4, 4, '2025-08-19', 'Pending');

-- Insert sample DeliveryAgents
INSERT INTO DeliveryAgents VALUES
  (1, 'Ramesh Kumar', '9876543201', 'KA01AB1234'),
  (2, 'Sanjay Singh', '9812345602', 'MH02CD5678'),
  (3, 'Vikram Patel', '9900112234', 'DL03EF9012'),
  (4, 'Amit Nair', '9888776656', 'KA04GH3456'),
  (5, 'John Doe', '9654321780', 'TN05IJ7890');

-- 1. List restaurants in 'Bangalore'.
SELECT * FROM Restaurants WHERE City = 'Bangalore';

-- 2. Show menu items priced above 300.
SELECT * FROM MenuItems WHERE Price > 300;

-- 3. Find orders placed in the last week.
SELECT * FROM Orders WHERE OrderDate >= CURDATE() - INTERVAL 7 DAY;

-- 4. Show top 5 highest rated restaurants.
SELECT * FROM Restaurants ORDER BY Rating DESC LIMIT 5;

-- 5. List customers from a specific city ('Mumbai').
SELECT * FROM Customers WHERE Address = 'Mumbai';

-- 6. Show orders with status 'Delivered'.
SELECT * FROM Orders WHERE Status = 'Delivered';

-- 7. Count menu items per restaurant.
SELECT r.Name, COUNT(m.MenuItemID) AS ItemCount
FROM Restaurants r
JOIN MenuItems m ON r.RestaurantID = m.RestaurantID
GROUP BY r.Name;

-- 8. Find customers who ordered from more than 3 restaurants.
SELECT c.Name, COUNT(DISTINCT o.RestaurantID) AS RestaurantCount
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.Name
HAVING RestaurantCount > 3;

-- 9. Show most expensive item in each restaurant.
SELECT m.RestaurantID, r.Name AS RestaurantName, m.ItemName, m.Price
FROM MenuItems m
JOIN Restaurants r ON m.RestaurantID = r.RestaurantID
WHERE (m.Price, m.RestaurantID) IN (
  SELECT MAX(Price), RestaurantID FROM MenuItems GROUP BY RestaurantID
);

-- 10. List delivery agents with more than 10 deliveries (Assuming there is a Delivery table – placeholder).
-- Placeholder since Delivery table not specified.

-- 11. Find restaurants with no orders.
SELECT r.*
FROM Restaurants r
LEFT JOIN Orders o ON r.RestaurantID = o.RestaurantID
WHERE o.OrderID IS NULL;

-- 12. Show average price of items per category.
SELECT Category, AVG(Price) AS AvgPrice
FROM MenuItems
GROUP BY Category;

-- 13. List orders with customer and restaurant names.
SELECT o.OrderID, c.Name AS CustomerName, r.Name AS RestaurantName, o.OrderDate, o.Status
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN Restaurants r ON o.RestaurantID = r.RestaurantID;

-- 14. Find customers who ordered the same item multiple times (Assuming Order-Items not present, placeholder).

-- 15. Show delivery agent with maximum orders (Assuming Delivery table not present, placeholder).

-- 16. List orders with status 'Cancelled'.
SELECT * FROM Orders WHERE Status = 'Cancelled';

-- 17. Find restaurants serving 'Pizza'.
SELECT DISTINCT r.*
FROM Restaurants r
JOIN MenuItems m ON r.RestaurantID = m.RestaurantID
WHERE m.Category = 'Pizza';

-- 18. Show most popular item overall (Assuming order details table required, placeholder).

-- 19. Display top 3 customers by order value (Assuming amount details missing, placeholder).

-- 20. Show orders sorted by date.
SELECT * FROM Orders ORDER BY OrderDate;

-- 21. Find customers with no orders.
SELECT * FROM Customers
WHERE CustomerID NOT IN (SELECT CustomerID FROM Orders);

-- 22. Show menu items with category 'Dessert'.
SELECT * FROM MenuItems WHERE Category = 'Dessert';

-- 23. List orders assigned to a specific delivery agent (Assuming Delivery table missing, placeholder).

-- 24. Show daily order count.
SELECT OrderDate, COUNT(*) AS OrderCount
FROM Orders
GROUP BY OrderDate;

-- 25. Find restaurants with menu items in multiple categories.
SELECT r.RestaurantID, r.Name, COUNT(DISTINCT m.Category) AS CategoryCount
FROM Restaurants r
JOIN MenuItems m ON r.RestaurantID = m.RestaurantID
GROUP BY r.RestaurantID, r.Name
HAVING CategoryCount > 1;

-- set 9
CREATE DATABASE CinemaTicketBooking;
USE CinemaTicketBooking;

CREATE TABLE Movies (
  MovieID INT PRIMARY KEY,
  Title VARCHAR(150),
  Genre VARCHAR(50),
  Language VARCHAR(50),
  Duration INT, -- in minutes
  ReleaseDate DATE
);

CREATE TABLE Screens (
  ScreenID INT PRIMARY KEY,
  ScreenName VARCHAR(50),
  Capacity INT
);

CREATE TABLE Showtimes (
  ShowID INT PRIMARY KEY,
  MovieID INT,
  ScreenID INT,
  ShowDate DATE,
  ShowTime TIME,
  Price DECIMAL(10,2),
  FOREIGN KEY (MovieID) REFERENCES Movies(MovieID),
  FOREIGN KEY (ScreenID) REFERENCES Screens(ScreenID)
);

CREATE TABLE Customers (
  CustomerID INT PRIMARY KEY,
  Name VARCHAR(100),
  Email VARCHAR(100),
  Phone VARCHAR(15)
);

CREATE TABLE Tickets (
  TicketID INT PRIMARY KEY,
  ShowID INT,
  CustomerID INT,
  SeatNo VARCHAR(10),
  BookingDate DATE,
  Status VARCHAR(20),
  FOREIGN KEY (ShowID) REFERENCES Showtimes(ShowID),
  FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Insert sample Movies
INSERT INTO Movies VALUES
  (1, 'Fast Action', 'Action', 'English', 120, '2022-05-10'),
  (2, 'Romantic Saga', 'Romance', 'Hindi', 140, '2023-03-15'),
  (3, 'Mystery Night', 'Thriller', 'English', 110, '2021-11-22'),
  (4, 'Comedy Central', 'Comedy', 'Hindi', 90, '2024-01-05'),
  (5, 'Animated Fun', 'Animation', 'English', 80, '2020-09-30');

-- Insert sample Screens
INSERT INTO Screens VALUES
  (1, 'Screen A', 100),
  (2, 'Screen B', 80),
  (3, 'Screen C', 150);

-- Insert sample Showtimes
INSERT INTO Showtimes VALUES
  (1, 1, 1, '2025-09-04', '18:00:00', 300.00),
  (2, 2, 2, '2025-09-04', '20:00:00', 250.00),
  (3, 3, 1, '2025-09-04', '21:00:00', 200.00),
  (4, 4, 3, '2025-09-05', '17:00:00', 150.00),
  (5, 5, 2, '2025-09-06', '19:00:00', 180.00);

-- Insert sample Customers
INSERT INTO Customers VALUES
  (1, 'Amit Sharma', 'amit@mail.com', '9876543210'),
  (2, 'Priya Singh', 'priya@mail.com', '9812345678'),
  (3, 'Rajesh Kumar', 'rajesh@mail.com', '9900112233'),
  (4, 'Sneha Verma', 'sneha@mail.com', '9888776655'),
  (5, 'John Doe', 'john@mail.com', '9654321789');

-- Insert sample Tickets
INSERT INTO Tickets VALUES
  (1, 1, 1, 'A1', '2025-09-01', 'Booked'),
  (2, 1, 2, 'A2', '2025-09-01', 'Booked'),
  (3, 2, 3, 'B1', '2025-09-02', 'Booked'),
  (4, 3, 4, 'A3', '2025-09-03', 'Cancelled'),
  (5, 4, 5, 'C1', '2025-09-03', 'Booked'),
  (6, 1, 1, 'A4', '2025-09-02', 'Booked');

-- 1. List movies in 'Action' genre.
SELECT * FROM Movies WHERE Genre = 'Action';

-- 2. Show movies released after 2020.
SELECT * FROM Movies WHERE ReleaseDate > '2020-12-31';

-- 3. Find shows scheduled for today.
SELECT * FROM Showtimes WHERE ShowDate = CURDATE();

-- 4. Show top 3 highest priced shows.
SELECT * FROM Showtimes ORDER BY Price DESC LIMIT 3;

-- 5. Count tickets sold for each show.
SELECT ShowID, COUNT(TicketID) AS TicketsSold
FROM Tickets
WHERE Status = 'Booked'
GROUP BY ShowID;

-- 6. Find customers who booked more than 5 tickets.
SELECT CustomerID, COUNT(TicketID) AS TicketsBooked
FROM Tickets
GROUP BY CustomerID
HAVING TicketsBooked > 5;

-- 7. Show shows with available seats (Capacity - Tickets sold).
SELECT s.ShowID, m.Title, sc.ScreenName,
  sc.Capacity - COUNT(t.TicketID) AS AvailableSeats
FROM Showtimes s
JOIN Screens sc ON s.ScreenID = sc.ScreenID
JOIN Movies m ON s.MovieID = m.MovieID
LEFT JOIN Tickets t ON s.ShowID = t.ShowID AND t.Status = 'Booked'
GROUP BY s.ShowID, m.Title, sc.ScreenName, sc.Capacity;

-- 8. List customers who booked tickets for a given movie ('Fast Action').
SELECT DISTINCT c.*
FROM Customers c
JOIN Tickets t ON c.CustomerID = t.CustomerID
JOIN Showtimes s ON t.ShowID = s.ShowID
JOIN Movies m ON s.MovieID = m.MovieID
WHERE m.Title = 'Fast Action';

-- 9. Show movies with no shows.
SELECT * FROM Movies m
WHERE NOT EXISTS (
  SELECT 1 FROM Showtimes s WHERE s.MovieID = m.MovieID
);

-- 10. Display tickets with customer and movie names.
SELECT t.TicketID, c.Name AS CustomerName, m.Title AS MovieTitle, t.SeatNo, t.BookingDate, t.Status
FROM Tickets t
JOIN Customers c ON t.CustomerID = c.CustomerID
JOIN Showtimes s ON t.ShowID = s.ShowID
JOIN Movies m ON s.MovieID = m.MovieID;

-- 11. Find customers without any bookings.
SELECT * FROM Customers
WHERE CustomerID NOT IN (SELECT DISTINCT CustomerID FROM Tickets);

-- 12. Show daily ticket sales totals.
SELECT BookingDate, COUNT(*) AS TicketsSold
FROM Tickets
WHERE Status = 'Booked'
GROUP BY BookingDate;

-- 13. Find movies with duration greater than 2 hours.
SELECT * FROM Movies WHERE Duration > 120;

-- 14. Show most popular movie (most tickets sold).
SELECT m.Title, COUNT(t.TicketID) AS TicketsSold
FROM Movies m
JOIN Showtimes s ON m.MovieID = s.MovieID
JOIN Tickets t ON s.ShowID = t.ShowID AND t.Status = 'Booked'
GROUP BY m.MovieID, m.Title
ORDER BY TicketsSold DESC
LIMIT 1;

-- 15. List top 5 customers by tickets purchased.
SELECT c.Name, COUNT(t.TicketID) AS TicketsBought
FROM Customers c
JOIN Tickets t ON c.CustomerID = t.CustomerID AND t.Status = 'Booked'
GROUP BY c.CustomerID, c.Name
ORDER BY TicketsBought DESC
LIMIT 5;

-- 16. Show cancelled tickets.
SELECT * FROM Tickets WHERE Status = 'Cancelled';

-- 17. Find shows in a specific screen (ScreenID = 1).
SELECT * FROM Showtimes WHERE ScreenID = 1;

-- 18. Show average price per genre.
SELECT Genre, AVG(Price) AS AvgPrice
FROM Movies m
JOIN Showtimes s ON m.MovieID = s.MovieID
GROUP BY Genre;

-- 19. List movies in 'Hindi' language.
SELECT * FROM Movies WHERE Language = 'Hindi';

-- 20. Show shows in the next 7 days.
SELECT * FROM Showtimes WHERE ShowDate BETWEEN CURDATE() AND CURDATE() + INTERVAL 7 DAY;

-- 21. Find customers who booked tickets for multiple movies.
SELECT c.Name, COUNT(DISTINCT s.MovieID) AS MoviesBooked
FROM Customers c
JOIN Tickets t ON c.CustomerID = t.CustomerID
JOIN Showtimes s ON t.ShowID = s.ShowID
GROUP BY c.CustomerID, c.Name
HAVING MoviesBooked > 1;

-- 22. Show earliest showtime for each movie.
SELECT m.Title, MIN(s.ShowTime) AS EarliestShowtime
FROM Movies m
JOIN Showtimes s ON m.MovieID = s.MovieID
GROUP BY m.MovieID, m.Title;

-- 23. Find movies with shows in multiple screens.
SELECT m.Title, COUNT(DISTINCT s.ScreenID) AS ScreenCount
FROM Movies m
JOIN Showtimes s ON m.MovieID = s.MovieID
GROUP BY m.MovieID, m.Title
HAVING ScreenCount > 1;

-- 24. Display ticket booking trends by month.
SELECT YEAR(BookingDate) AS Year, MONTH(BookingDate) AS Month, COUNT(*) AS TicketsBooked
FROM Tickets
GROUP BY Year, Month
ORDER BY Year, Month;

-- 25. Show movies that have been screened more than 10 times.
SELECT m.Title, COUNT(s.ShowID) AS ShowCount
FROM Movies m
JOIN Showtimes s ON m.MovieID = s.MovieID
GROUP BY m.MovieID, m.Title
HAVING ShowCount > 10;

-- set 10
CREATE DATABASE ELearningPlatform;
USE ELearningPlatform;

CREATE TABLE Courses (
  CourseID INT PRIMARY KEY,
  Title VARCHAR(150),
  Category VARCHAR(50),
  DurationWeeks INT,
  Price DECIMAL(10, 2)
);

CREATE TABLE Instructors (
  InstructorID INT PRIMARY KEY,
  Name VARCHAR(100),
  Email VARCHAR(100),
  Specialty VARCHAR(50)
);

CREATE TABLE Students (
  StudentID INT PRIMARY KEY,
  Name VARCHAR(100),
  Email VARCHAR(100),
  City VARCHAR(50)
);

CREATE TABLE Enrollments (
  EnrollmentID INT PRIMARY KEY,
  StudentID INT,
  CourseID INT,
  EnrollDate DATE,
  Status VARCHAR(20),
  FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
  FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

CREATE TABLE Assignments (
  AssignmentID INT PRIMARY KEY,
  CourseID INT,
  Title VARCHAR(150),
  DueDate DATE,
  MaxMarks INT,
  FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

-- Insert sample Courses
INSERT INTO Courses VALUES
  (1, 'Data Science 101', 'Data Science', 10, 12000.00),
  (2, 'Python for Beginners', 'Programming', 8, 8000.00),
  (3, 'Advanced AI', 'Artificial Intelligence', 12, 15000.00),
  (4, 'Web Development', 'Programming', 6, 7000.00),
  (5, 'Machine Learning Basics', 'Artificial Intelligence', 9, 10000.00);

-- Insert sample Instructors
INSERT INTO Instructors VALUES
  (1, 'Dr. Rajesh Kumar', 'rajesh@elearning.com', 'Data Science'),
  (2, 'Ms. Anita Singh', 'anita@elearning.com', 'Python'),
  (3, 'Prof. Suresh Patel', 'suresh@elearning.com', 'AI'),
  (4, 'Mr. Ajay Mehta', 'ajay@elearning.com', 'Web Development'),
  (5, 'Dr. Neha Sharma', 'neha@elearning.com', 'Machine Learning');

-- Insert sample Students
INSERT INTO Students VALUES
  (1, 'Amit Gupta', 'amit@domain.com', 'Mumbai'),
  (2, 'Priya Verma', 'priya@domain.com', 'Delhi'),
  (3, 'Rahul Singh', 'rahul@domain.com', 'Bangalore'),
  (4, 'Sneha Joshi', 'sneha@domain.com', 'Mumbai'),
  (5, 'John Doe', 'john@domain.com', 'Chennai');

-- Insert sample Enrollments
INSERT INTO Enrollments VALUES
  (1, 1, 1, '2025-07-01', 'Completed'),
  (2, 2, 2, '2025-07-15', 'In Progress'),
  (3, 3, 3, '2025-08-01', 'Completed'),
  (4, 4, 4, '2025-08-10', 'In Progress'),
  (5, 5, 5, '2025-08-20', 'Completed'),
  (6, 1, 2, '2025-08-25', 'In Progress'),
  (7, 4, 1, '2025-08-28', 'Completed');

-- Insert sample Assignments
INSERT INTO Assignments VALUES
  (1, 1, 'Intro to Data Science', '2025-09-10', 100),
  (2, 1, 'Data Wrangling', '2025-09-17', 100),
  (3, 2, 'Python Basics', '2025-09-12', 50),
  (4, 3, 'Neural Networks', '2025-09-20', 100),
  (5, 4, 'HTML & CSS', '2025-09-15', 50);

-- 1. List courses in 'Data Science' category.
SELECT * FROM Courses WHERE Category = 'Data Science';

-- 2. Show instructors specializing in 'Python'.
SELECT * FROM Instructors WHERE Specialty = 'Python';

-- 3. Find students from 'Mumbai'.
SELECT * FROM Students WHERE City = 'Mumbai';

-- 4. List enrollments in the last month.
SELECT * FROM Enrollments WHERE EnrollDate >= CURDATE() - INTERVAL 1 MONTH;

-- 5. Show courses with duration more than 8 weeks.
SELECT * FROM Courses WHERE DurationWeeks > 8;

-- 6. Find top 3 most expensive courses.
SELECT * FROM Courses ORDER BY Price DESC LIMIT 3;

-- 7. Show students enrolled in a given course (CourseID = 1).
SELECT s.*
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
WHERE e.CourseID = 1;

-- 8. List instructors teaching multiple courses (assuming assignments table as proxy).
SELECT i.Name, COUNT(DISTINCT a.CourseID) AS CoursesTaught
FROM Instructors i
JOIN Assignments a ON i.Specialty = (SELECT Category FROM Courses WHERE CourseID = a.CourseID LIMIT 1) -- approximate link
GROUP BY i.InstructorID, i.Name
HAVING CoursesTaught > 1;

-- 9. Show assignments with due date in next week.
SELECT * FROM Assignments WHERE DueDate BETWEEN CURDATE() AND CURDATE() + INTERVAL 7 DAY;

-- 10. Find students who completed all assignments in a course. 
-- (Assuming detailed submissions table not present, placeholder.)

-- 11. Show average marks per course. 
-- (Assuming marks table not present, placeholder.)

-- 12. Find students without enrollments.
SELECT * FROM Students WHERE StudentID NOT IN (SELECT StudentID FROM Enrollments);

-- 13. Show total enrollments per course.
SELECT c.Title, COUNT(e.EnrollmentID) AS TotalEnrollments
FROM Courses c
LEFT JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY c.CourseID, c.Title;

-- 14. Display instructors with no courses assigned.
SELECT * FROM Instructors
WHERE Specialty NOT IN (SELECT Category FROM Courses);

-- 15. Show students with more than 3 enrollments.
SELECT s.Name, COUNT(e.EnrollmentID) AS EnrollmentCount
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
GROUP BY s.StudentID, s.Name
HAVING EnrollmentCount > 3;

-- 16. Find courses with no students.
SELECT * FROM Courses
WHERE CourseID NOT IN (SELECT CourseID FROM Enrollments);

-- 17. Show most popular course.
SELECT c.Title, COUNT(e.EnrollmentID) AS Enrollments
FROM Courses c
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY c.CourseID, c.Title
ORDER BY Enrollments DESC
LIMIT 1;

-- 18. List assignments per course.
SELECT c.Title, a.Title AS AssignmentTitle, a.DueDate
FROM Courses c
JOIN Assignments a ON c.CourseID = a.CourseID;

-- 19. Show students who submitted assignments late.
-- (Assuming submission table not present, placeholder.)

-- 20. Display courses and their instructor names.
-- (Assuming a linking table not present, approximate by specialty-category.)
SELECT c.Title, i.Name AS InstructorName
FROM Courses c
LEFT JOIN Instructors i ON c.Category = i.Specialty;

-- 21. Find courses under 5000 in price.
SELECT * FROM Courses WHERE Price < 5000;

-- 22. Show courses with 'AI' in the title.
SELECT * FROM Courses WHERE Title LIKE '%AI%';

-- 23. Find students who enrolled in multiple categories.
SELECT s.Name, COUNT(DISTINCT c.Category) AS CategoryCount
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
JOIN Courses c ON e.CourseID = c.CourseID
GROUP BY s.StudentID, s.Name
HAVING CategoryCount > 1;

-- 24. Show monthly enrollment counts.
SELECT YEAR(EnrollDate) AS Year, MONTH(EnrollDate) AS Month, COUNT(*) AS EnrollmentCount
FROM Enrollments
GROUP BY Year, Month
ORDER BY Year, Month;

-- 25. Find instructors teaching courses in multiple categories.
SELECT i.Name, COUNT(DISTINCT c.Category) AS CategoryCount
FROM Instructors i
JOIN Courses c ON i.Specialty = c.Category
GROUP BY i.InstructorID, i.Name
HAVING CategoryCount > 1;

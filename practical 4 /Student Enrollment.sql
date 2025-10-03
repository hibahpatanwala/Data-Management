--
-- Set 1: Student Enrollment
--

-- 1. Identify insertion anomalies
-- Can't add a student or a course independently without enrollment entry.
-- Can't register instructor details without a course.

-- 2. Identify update anomalies
-- Changing instructor phone or name must update multiple rows.
-- Student details must be updated in every course they enroll.

-- 3. Identify deletion anomalies
-- Deleting the last enrollment of a student removes all their course and instructor info.

-- 4. Does schema satisfy 1NF? Why or why not?
-- Yes, all columns contain atomic, single values; no multi-valued or nested attributes.

-- 5. Rewrite schema to achieve 1NF (already satisfied here)
CREATE TABLE StudentEnrollment (
    StudentID INT,
    StudentName VARCHAR(100),
    Phone VARCHAR(20),
    CourseID INT,
    CourseName VARCHAR(100),
    Instructor VARCHAR(100),
    InstructorPhone VARCHAR(20),
    Semester VARCHAR(20),
    Grade VARCHAR(5),
    PRIMARY KEY (StudentID, CourseID)
);

-- Sample data for 1NF table
INSERT INTO StudentEnrollment VALUES
(1, 'Rahul Kumar', '9876543210', 101, 'Mathematics', 'Dr. Singh', '9123456789', 'Fall 2025', 'A'),
(2, 'Anjali Sharma', '9123456780', 102, 'Physics', 'Dr. Verma', '9234567891', 'Fall 2025', 'B'),
(1, 'Rahul Kumar', '9876543210', 103, 'Chemistry', 'Dr. Gupta', '9345678912', 'Spring 2025', 'A'),
(3, 'Sneha Patel', '9012345678', 101, 'Mathematics', 'Dr. Singh', '9123456789', 'Fall 2025', 'C'),
(2, 'Anjali Sharma', '9123456780', 104, 'Biology', 'Dr. Mehta', '9456789123', 'Spring 2025', 'B');

-- 6. Primary key
-- Composite key: (StudentID, CourseID)

-- 7. Functional Dependencies (FDs)
-- StudentID → StudentName, Phone
-- CourseID → CourseName, Instructor, InstructorPhone
-- (StudentID, CourseID) → Semester, Grade

-- 8. Why does this table not satisfy 2NF?
-- StudentName and Phone depend only on StudentID, 
-- CourseName, Instructor, InstructorPhone depend only on CourseID,
-- these are partial dependencies on composite key.

-- 9. Split into 2NF tables
CREATE TABLE Student (
    StudentID INT PRIMARY KEY,
    StudentName VARCHAR(100),
    Phone VARCHAR(20)
);

CREATE TABLE Course (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(100),
    Instructor VARCHAR(100),
    InstructorPhone VARCHAR(20)
);

CREATE TABLE Enrollment (
    StudentID INT,
    CourseID INT,
    Semester VARCHAR(20),
    Grade VARCHAR(5),
    PRIMARY KEY (StudentID, CourseID),
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID)
);

-- Insert sample data for 2NF schema
INSERT INTO Student VALUES
(1, 'Rahul Kumar', '9876543210'),
(2, 'Anjali Sharma', '9123456780'),
(3, 'Sneha Patel', '9012345678');

INSERT INTO Course VALUES
(101, 'Mathematics', 'Dr. Singh', '9123456789'),
(102, 'Physics', 'Dr. Verma', '9234567891'),
(103, 'Chemistry', 'Dr. Gupta', '9345678912'),
(104, 'Biology', 'Dr. Mehta', '9456789123');

INSERT INTO Enrollment VALUES
(1, 101, 'Fall 2025', 'A'),
(2, 102, 'Fall 2025', 'B'),
(1, 103, 'Spring 2025', 'A'),
(3, 101, 'Fall 2025', 'C'),
(2, 104, 'Spring 2025', 'B');

-- 10. SQL CREATE TABLE statements are shown above

-- 11. Show transitive dependencies
-- InstructorPhone depends on Instructor,
-- Instructor depends on CourseID,
-- so InstructorPhone transitively depends on CourseID.

-- 12. Convert schema to 3NF to remove transitive dependency
CREATE TABLE Instructor (
    Instructor VARCHAR(100) PRIMARY KEY,
    InstructorPhone VARCHAR(20)
);

CREATE TABLE Course_3NF (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(100),
    Instructor VARCHAR(100),
    FOREIGN KEY (Instructor) REFERENCES Instructor(Instructor)
);

-- Insert data for 3NF tables
INSERT INTO Instructor VALUES
('Dr. Singh', '9123456789'),
('Dr. Verma', '9234567891'),
('Dr. Gupta', '9345678912'),
('Dr. Mehta', '9456789123');

INSERT INTO Course_3NF VALUES
(101, 'Mathematics', 'Dr. Singh'),
(102, 'Physics', 'Dr. Verma'),
(103, 'Chemistry', 'Dr. Gupta'),
(104, 'Biology', 'Dr. Mehta');

-- Student and Enrollment remain same as in 2NF schema

-- 13. SQL CREATE TABLE statements for 3NF schema given above

-- 14. Verify BCNF compliance
-- Yes, all determinants are candidate keys in each table

-- 15. Query to list students with their courses and instructors
SELECT S.StudentName, C.CourseName, I.Instructor
FROM Enrollment E
JOIN Student S ON E.StudentID = S.StudentID
JOIN Course_3NF C ON E.CourseID = C.CourseID
JOIN Instructor I ON C.Instructor = I.Instructor;

-- 16. Query to find all courses taken by a given student (example student id = 1)
SELECT C.CourseName
FROM Enrollment E
JOIN Course_3NF C ON E.CourseID = C.CourseID
WHERE E.StudentID = 1;

-- 17. Query to count students per course
SELECT C.CourseName, COUNT(*) AS NumStudents
FROM Enrollment E
JOIN Course_3NF C ON E.CourseID = C.CourseID
GROUP BY C.CourseName;

-- 18. Query: instructors teaching more than one course
SELECT Instructor, COUNT(*) AS NumCourses
FROM Course_3NF
GROUP BY Instructor
HAVING COUNT(*) > 1;

-- 19. Query all students who received grade "A"
SELECT DISTINCT S.StudentName
FROM Enrollment E
JOIN Student S ON E.StudentID = S.StudentID
WHERE E.Grade = 'A';

-- 20. Explain normalization benefits
-- Normalized schema eliminates repeated storage of student, course, and instructor info.
-- Updates to any attribute occur in just one place, improving data consistency and reducing data anomalies.

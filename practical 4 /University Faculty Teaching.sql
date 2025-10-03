CREATE TABLE FacultyTeaching (
    FacultyID INT,
    FacultyName VARCHAR(100),
    Department VARCHAR(50),
    CourseID INT,
    CourseName VARCHAR(100),
    Semester VARCHAR(20),
    Classroom VARCHAR(20),
    StudentCount INT,
    DeanName VARCHAR(100)
);

INSERT INTO FacultyTeaching (FacultyID, FacultyName, Department, CourseID, CourseName, Semester, Classroom, StudentCount, DeanName)
VALUES
(101, 'Dr. Alice Johnson', 'Computer Science', 501, 'Data Structures', 'Fall 2025', 'CS101', 45, 'Dr. Emily Carter'),
(102, 'Dr. Mark Thompson', 'Mathematics', 302, 'Calculus II', 'Fall 2025', 'MATH202', 60, 'Dr. Robert Lane'),
(103, 'Dr. Sarah Lee', 'Physics', 201, 'Quantum Mechanics', 'Spring 2025', 'PHY201', 35, 'Dr. Emily Carter'),
(104, 'Dr. Kevin Brown', 'Chemistry', 410, 'Organic Chemistry', 'Fall 2025', 'CHEM110', 50, 'Dr. Natalie Singh'),
(105, 'Dr. Nina Patel', 'Biology', 305, 'Genetics', 'Spring 2025', 'BIO101', 40, 'Dr. Natalie Singh'),
(106, 'Dr. James Smith', 'Computer Science', 502, 'Operating Systems', 'Spring 2025', 'CS102', 38, 'Dr. Emily Carter'),
(107, 'Dr. Laura Kim', 'Mathematics', 305, 'Linear Algebra', 'Summer 2025', 'MATH305', 30, 'Dr. Robert Lane'),
(108, 'Dr. Henry Davis', 'Economics', 620, 'Microeconomics', 'Fall 2025', 'ECON202', 55, 'Dr. Grace Lin'),
(109, 'Dr. Olivia Martin', 'Psychology', 701, 'Cognitive Psychology', 'Spring 2025', 'PSY301', 42, 'Dr. Grace Lin'),
(110, 'Dr. Eric Wilson', 'Computer Science', 503, 'Artificial Intelligence', 'Fall 2025', 'CS103', 48, 'Dr. Emily Carter');

-- 📝 Practice Questions

--  1.⁠ ⁠Identify insertion anomalies.
-- faculty,department,course

--  2.⁠ ⁠Identify update anomalies.
-- faculty,department,course

--  3.⁠ ⁠Identify deletion anomalies.
-- faculty,department,course

--  4.⁠ ⁠Does this schema satisfy 1NF? Explain.
-- yes each column is unique

--  5.⁠ ⁠Convert schema to 1NF.
-- it is

--  6.⁠ ⁠State primary key.
-- FacultyID,CourseID

--  7.⁠ ⁠Write FDs.
-- FacultyID -FacultyName, Department
-- Department - DeanName
-- CourseID - CourseName

--  8.⁠ ⁠Identify partial dependencies.
-- CourseName,department depends on courseid

--  9.⁠ ⁠Convert schema to 2NF.
-- faculty(facultyid,fname,department)
-- department(did,dname,dean)
-- course(courseid,CourseName,classroom)
-- teachteach(facultyid,courseid,semester,Classroom,StudentCount)

-- 10.⁠ ⁠Write SQL for 2NF schema
create table faculty(
facultyid int primary key,
    fname varchar(100),
    department int,
    foreign key (department) references department(did));
   
create table department(
did int primary key,
dname varchar(100),
    dean varchar(100));
   
create table course(
courseid int primary key,
    CourseName varchar(100),
    classroom varchar(20)
);

create table teach(
facultyid int,
    courseid int,
    semester VARCHAR(20),
    Classroom VARCHAR(20),
    StudentCount INT,
    primary key(facultyid,courseid,semester),
    foreign key (facultyid) references faculty(facultyid),
    foreign key (courseid) references course(courseid)
    );

INSERT INTO department (did, dname, dean) VALUES
(1, 'Computer Science', 'Dr. Emily Carter'),
(2, 'Mathematics', 'Dr. Robert Lane'),
(3, 'Physics', 'Dr. Emily Carter'),
(4, 'Chemistry', 'Dr. Natalie Singh'),
(5, 'Biology', 'Dr. Natalie Singh'),
(6, 'Economics', 'Dr. Grace Lin'),
(7, 'Psychology', 'Dr. Grace Lin');


INSERT INTO faculty (facultyid, fname, department) VALUES
(101, 'Alice Johnson', 1),
(102, 'Mark Thompson', 2),
(103, 'Sarah Lee', 3),
(104, 'Kevin Brown', 4),
(105, 'Nina Patel', 5),
(106, 'James Smith', 1),
(107, 'Laura Kim', 2),
(108, 'Henry Davis', 6),
(109, 'Olivia Martin', 7),
(110, 'Eric Wilson', 1);

INSERT INTO course (courseid, coursename, classroom) VALUES
(501, 'Data Structures', 'CS101'),
(502, 'Operating Systems', 'CS102'),
(503, 'Artificial Intelligence', 'CS103'),
(302, 'Calculus II', 'MATH202'),
(305, 'Linear Algebra', 'MATH305'),
(201, 'Quantum Mechanics', 'PHY201'),
(410, 'Organic Chemistry', 'CHEM110'),
(308, 'Genetics', 'BIO101'),
(620, 'Microeconomics', 'ECON202'),
(701, 'Cognitive Psychology', 'PSY301');

INSERT INTO teach (facultyid, courseid, semester, classroom, studentcount) VALUES
(101, 501, 'Fall 2025', 'CS101', 45),
(106, 502, 'Spring 2025', 'CS102', 38),
(110, 503, 'Fall 2025', 'CS103', 48),
(102, 302, 'Fall 2025', 'MATH202', 60),
(107, 305, 'Summer 2025', 'MATH305', 30),
(103, 201, 'Spring 2025', 'PHY201', 35),
(104, 410, 'Fall 2025', 'CHEM110', 50),
(105, 305, 'Spring 2025', 'BIO101', 40),
(108, 620, 'Fall 2025', 'ECON202', 55),
(109, 701, 'Spring 2025', 'PSY301', 42);


-- 11.⁠ ⁠Identify transitive dependencies.
-- faculty- department- dean
-- course- department- dean
-- 12.⁠ ⁠Convert schema to 3NF.
-- same as 2nf

-- 13.⁠ ⁠Write SQL for 3NF schema.
-- same as 2nf

-- 14.⁠ ⁠Check if schema is BCNF.
-- same as 2nf

-- 15.⁠ ⁠Query: List courses taught by each faculty.
select f.fname,c.CourseName,c.coursename,t.semester,t.studentcount
from teach t
join course c on c.courseid = t.courseid
join faculty f on t.facultyid = f.facultyid;

-- 16.⁠ ⁠Query: Count students per course.
SELECT C.CourseName, SUM(T.StudentCount) AS TotalStudents
FROM Teach T
JOIN Course C ON T.CourseID = C.CourseID
GROUP BY C.CourseName;


-- 17.⁠ ⁠Query: Find departments with more than 5 courses.
SELECT F.Department, COUNT(DISTINCT T.CourseID) AS CourseCount
FROM Teach T
JOIN Faculty F ON T.FacultyID = F.FacultyID
GROUP BY F.Department
HAVING COUNT(DISTINCT T.CourseID) > 5;


-- 18.⁠ ⁠Query: List classrooms used by multiple departments.
SELECT T.Classroom
FROM Teach T
JOIN Faculty F ON T.FacultyID = F.FacultyID
GROUP BY T.Classroom
HAVING COUNT(DISTINCT F.Department) > 1;


-- 19.⁠ ⁠Query: Find deans handling multiple departments.
SELECT D.Dean, COUNT(*) AS DepartmentCount
FROM Department D
GROUP BY D.Dean
HAVING COUNT(*) > 1;

-- 20.⁠ ⁠Explain redundancy removal via normalization.
-- before normalization there was duplication and also everything is clubbed in one schema
-- after normalization each data point is stored once ,making changes or updates more efficiently

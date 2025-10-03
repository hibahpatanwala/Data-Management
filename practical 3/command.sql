create table student(
	StudentID int,
    Name Varchar(20),
    age int,
    gender varchar(6)
);
alter table student
add location varchar(20);
INSERT INTO Student (StudentID, Name, Age, Gender)
VALUES
(01, 'Ram', 20, 'Male'),
(02, 'Sana', 21, 'Female'),
(03, 'John', 21, 'Male'),
(04, 'Peter', 20, 'Male');

update student
set location = "Bangalore"
where StudentID in (1,3);

update student
set location = "Mumbai"
where StudentID = 4;

delete from student
where StudentId = 4;

select name,gender,location
from student
;

select count(*) as np_pf_student
from student;

select name,gender
from student
where location = "Bangalore";


SELECT DISTINCT location
FROM Student;

SELECT Name FROM Student
LIMIT 2;

SET AUTOCOMMIT = 0;

START TRANSACTION;

SELECT * FROM Student;

DELETE FROM Student
WHERE StudentID = 4;

COMMIT;

SET AUTOCOMMIT = 0;

START TRANSACTION;

SELECT * FROM Student;

DELETE FROM Student
WHERE StudentID = 4;

ROLLBACK;

COMMIT;

SET AUTOCOMMIT = 0;

START TRANSACTION;

SAVEPOINT A; 

SELECT * FROM Student; 

SAVEPOINT B; 

DELETE FROM Student
WHERE StudentID = 4; 

ROLLBACK TO B;

COMMIT;

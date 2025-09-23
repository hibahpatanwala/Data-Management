create database practice;
use practice;
create table students(
	StudentID int,
    Name Varchar(20),
    age int,
    gender varchar(6)
);
select * from students;

INSERT INTO Students (StudentID, Name, Age, Gender)
VALUES
(01, 'Ram', 20, 'Male'),
(02, 'Sana', 21, 'Female'),
(03, 'John', 21, 'Male'),
(04, 'Peter', 20, 'Male');

SELECT * FROM Student;
SET SQL_SAFE_UPDATES=0;
update students
set age = 30
where StudentID = 4;

delete from students
where StudentId = 4;

truncate table students;
drop table students;

create database college;
CREATE DATABASE ABC_company;
use abc_company;
create table employees(
	eid int primary key,
    name varchar(20),
    role varchar(20),
    salary int
);
insert into employees
values(1,"Prakesh","developer",20000),
(2,"priya","tester",20000);
drop database if exists abc_company;

use college;


create table student(
	roll_no INT,
    sname varchar(20),
    age int
);

insert into student
values
(101,"adam",13),
(102,"ana",14),
(103,"bob",12);

create table teacher(
	id int primary key,
    name varchar(10),
    subjects varchar(20)
);
insert into teacher
values(1,"Prakesh","Python"),
(2,"priya","c++"),
(3,"tirup","DBMS");
select * from student;

alter table student
add column t_id int ,
add constraint fk_teacher
foreign key (t_id) references teacher(id);

create table classes(
	class_id int primary key,
    classname varchar(20),
    teacher varchar(20)
);

create table student_table(
	id int primary key,
    sname varchar(20),
    class_id int,
    foreign key (class_id) references classes(class_id)
);

insert into classes
values(1,"maths","smith"),
(2,"science","johnson"),
(3,"hisory","brown");

insert into student_table
values(101,"alice",1),
(102,"bob",2),
(103,"charlie",1),
(104,"diana",1);

create database if not exists college;
create database if not exists instagram;

show databases;
show tables;

use instagram;
CREATE TABLE user_info(
	id INT,
    age INT,
	email varchar(30) UNIQUE,
    uname varchar(30) NOT NULL,
    followers INT DEFAULT 0,
    ufollowing int,
    constraint age_check check (age >=13)
);

CREATE TABLE user_info1(
	id INT PRIMARY KEY,
    age INT,
	email varchar(30) UNIQUE,
    uname varchar(30) NOT NULL,
    followers INT DEFAULT 0,
    ufollowing int,
    constraint check (age >=13)
);

CREATE TABLE user_info2(
	id INT,
    age INT,
	email varchar(30) UNIQUE,
    uname varchar(30) NOT NULL,
    followers INT DEFAULT 0,
    ufollowing int,
    constraint check (age >=13),
    PRIMARY KEY(id)
);

create table post(
	p_id int primary key,
    content varchar(100),
    user_id int,
    foreign key (user_id) references user_info2(id)
);


INSERT INTO user_info2 (id, age, email, uname, followers, ufollowing)
VALUES(1, 25, 'user1@example.com', 'user1', 100, 50),
(2, 30, 'user2@example.com', 'user2', 200, 75),
(3, 22, 'user3@example.com', 'user3', 150, 60),
(4, 18, 'user4@example.com', 'user4', 80, 30),
(5, 27, 'user5@example.com', 'user5', 120, 40),
(6, 19, 'user6@example.com', 'user6', 90, 20),
(7, 35, 'user7@example.com', 'user7', 300, 100),
(8, 15, 'user8@example.com', 'user8', 60, 10),
(9, 40, 'user9@example.com', 'user9', 400, 150),
(10, 28, 'user10@example.com', 'user10', 110, 55);

select *
from user_info2;

select age,uname,email 
from user_info2;

select distinct age 
from user_info2;

select distinct age,uname 
from user_info2;

select age,uname from user_info2;

select *
from user_info2
where followers >100;

select uname,ufollowing,email
from user_info2
where ufollowing >100;

select uname,age,email
from user_info2
where age <20;

select * from user_info2 where age+10 = 25;

select * from user_info2 where ufollowing+10 = 70;

select uname,age
from user_info2
where age > 20 and followers> 105;

select uname,age
from user_info2
where age > 20 or followers> 105;

select uname,email
from user_info2
where age between 13 and 30;

select *
from user_info2
where email in ('user10@example.com','user1@example.com','user2@example.com');

select *
from user_info2
where email not in ('user10@example.com','user1@example.com','user2@example.com');

select *
from user_info2
where age in (13,25);

select *
from user_info2
where age not in (13,15);
 
select *
from user_info2
limit 4;

select *
from user_info2
where age>13
limit 5;

select *
from user_info2 
order by age asc;

select *
from user_info2 
order by age desc;

select max(age)
from user_info2;

select min(age)
from user_info2;

select count(age)
from user_info2
where age = 15;

select count(age)
from user_info2;

select avg(followers)
from user_info2;

select sum(followers)
from user_info2;

select age, max(followers)
from user_info2
group by age;

select age, max(followers)
from user_info2
group by age
having max(followers)>=100;


select age, max(followers)
from user_info2
group by age
having max(followers)>=100
order by age desc;

set sql_safe_updates = 0;

update user_info2
set followers = 500
where age = 35;

update user_info2
set followers = 5000
where age between 15 and 40;

select * 
from user;

delete from user_info2
where age =  35;

alter table user_info2
add column city varchar(200) default "mumbai";

alter table user_info2
rename to user;

alter table user
change column ufollowing follow int default 0;

alter table user
modify follow int default 5;

insert into user(id,uname,followers)
values(11,"ravi",650);

truncate table user_info;
drop table post;
create database col;
use col;
create table teacher(
	id int primary key,
    name varchar(10),
    subjects varchar(20),
    salary int
);
insert into teacher
values(1,"Prakesh","Python",20000),
(2,"priya","c++",40000),
(3,"tirup","DBMS",240000),
(4,"ravi","math",50000),
(5,"sheetal","english",350000);

select * 
from teacher
where salary>50000;

alter table teacher
change column salary ctc int;

update teacher
set ctc = ctc + ctc*0.25;

alter table teacher
add column city varchar(20) default "mumbai";

alter table teacher
drop column ctc;

create table student(
	roll_no INT primary key,
    sname varchar(20),
    city varchar(20),
    marks int
);

INSERT INTO student (roll_no, sname, city, marks) 
VALUES(1, 'Alice', 'New Delhi', 85),
(2, 'Bob', 'Mumbai', 90),
(3, 'Charlie', 'Pune', 78),
(4, 'David', 'Lucknow', 88),
(5, 'Eva', 'Delhi', 92);

select * 
from student
where marks>75;

select distinct city
from student;

select city,max(marks)
from student
group by city;

select avg(marks)
from student;

alter table student
add column grade varchar(1);
select * 
from student;

update student
set grade = "O" where marks>80;

update student
set grade = "A" where marks>70 and marks<80;
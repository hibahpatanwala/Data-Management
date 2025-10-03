create table coursedetails(
	courseid tinyint primary key,
  coursename varchar(20) not null,
  amount smallint);
    
insert into coursedetails
values(1,"sql",15000),
(2,"power-bi",12000);
create table studentdetails(
	sid int primary key,
    sname char(30) not null,
    age tinyint check(age>18),
    gender varchar(6) check(gender ="Male" or gender = "Female"),
    courseid tinyint,
    foreign key(courseid) references coursedetails(courseid)
);
insert into studentdetails
values(1,"ram",20,"male",1),
(2,"sham",20,"male",1),
(3,"sana",21,"male",2),
(4,"priya",24,"male",1),
(5,"john",23,"male",2);

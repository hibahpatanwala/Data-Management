use practice;
create table department(
department int primary key,
    deptname varchar(100)
);
create table employee(
empid int primary key,
    empname varchar(20),
    departmentid int,
    foreign key (departmentid) references department (department)
);
insert into department
values
(101,"IT"),
(102,"HR"),
(103,"Sales"),
(104,"Marketing");
insert into employee
values
(1,"ram",101),
(2,"sham",102),
(3,"peter",101),
(4,"john",103);

select e.empid, e.empname,d.deptname
from employee as e
inner join department as d
on e.departmentid = d.department;

select *
from employee as e
inner join department as d
on e.departmentid = d.department;

select e.empid, e.empname,d.deptname,d.department
from employee as e
left join department as d
on e.departmentid = d.department;

select e.empid, e.empname,d.deptname,d.department
from employee as e
right join department as d
on e.departmentid = d.department;

select e.empid, e.empname,d.deptname,d.department
from employee as e
left join department as d
on e.departmentid = d.department
union
select e.empid, e.empname,d.deptname,d.department
from employee as e
right join department as d
on e.departmentid = d.department;

select e.empid, e.empname,d.deptname,d.department
from employee as e
left join department as d
on e.departmentid = d.department
union all
select e.empid, e.empname,d.deptname,d.department
from employee as e
right join department as d
on e.departmentid = d.department;

select e.empid, e.empname,d.deptname,d.department
from employee as e
cross join department as d;

create table company(
emp_id int,
emp_name varchar(100),
manager_id int
);

insert into company
values
(1,"john",0),
(2,"alice",1),
(3,"bob",1),
(4,"mary",2);

select c.emp_name as employye_name,
m.emp_name as manager_name
from company c
left join company m
on c.manager_id = m.emp_id;

select c.emp_name as employye_name,
m.emp_name as manager_name
from company c
join company m
on c.manager_id = m.emp_id;

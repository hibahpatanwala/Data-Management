create table sales(
	orderid int primary key,
    productid int,
    quatity int default 0,
    price int,
    orderdate date,
    customerid varchar(20));


insert into sales
values
(1, 101, 50, 15.00, '2023-02-10', 'C001'),
(2, 102, 30, 10.00, '2023-03-15', 'C002'),
(3, 101, 60, 15.00, '2023-04-20', 'C003'),
(4, 103, 40, 20.00, '2023-05-05', 'C004'),
(5, 102, 75, 10.00, '2023-06-10', 'C005'),
(6, 104, 90, 25.00, '2023-07-15', 'C006'),
(7, 101, 30, 15.00, '2023-08-20', 'C007'),
(8, 105, 110, 30.00, '2023-09-25', 'C008'),
(9, 103, 80, 20.00, '2023-10-30', 'C009'),
(10, 104, 20, 25.00, '2023-11-05','C010');

select productid, sum(quatity) as totalquantity, count(*) as numberoforders
from sales
where orderdate between "2023-01-01" and "2023-12-31"
group by productid
having sum(quatity) >100
order by totalquantity desc
limit 7;

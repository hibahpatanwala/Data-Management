use besantbank;
insert into accountdetails
values
(6,"priya",23,"current",10000),
(7,"varun",25,"saving",2500),
(8,"sonu",24,"current",17500),
(9,"kumar",21,"saving",90000),
(10,"jatin",23,"current",503670),
(11,"suma",22,"current",54600);

insert into transactiondetails (accountid, transactiontype,transactionamount)
values(7,"credit",1000);

select distinct(accountid) from transactiondetails;

select * from accountdetails where accountid in (1,2,7);

select * from accountdetails
where accountid in (
select distinct(accountid) from transactiondetails);

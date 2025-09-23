create database besantbank;
use besantbank;

create table accountdetails(
	accountid int primary key,
    name char(30) not null,
    age tinyint check(age>18),
    accounttype varchar(20),
    currentbalance int
);
insert into accountdetails 
values
(1,"ram",21,"saving",2000);

create table transactiondetails(
	transactionid int primary key auto_increment,
    accountid int,
    transactiontype varchar(10) check(transactiontype = "credit" or transactiontype = "debit"),
    transactionamount int,
    transactiontime datetime default(now()),
    foreign key (accountid) references accountdetails (accountid));
    
insert into transactiondetails (accountid, transactiontype,transactionamount)
values(1,"credit",1000),
(2,"debit",500);

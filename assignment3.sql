create database online_books;
use online_books;
create table author(
	author_id int primary key,
    namee varchar(100) not null,
    country varchar(20),
    dob date
);

create table categories(
	category_id int,
    category_name varchar(100) unique,
    constraint pk_idk primary key(category_id)
);

create table books(
	bookID int primary key,
    title varchar(100) unique,
    authorID int,
    CategoryID int,
    Price int ,
    constraint price_chk check (Price>0),
    Stock int ,
	constraint stk_chk check(stock>=0),
    PublishYear Year Default (Year(curdate())),
    Foreign key (authorID) references author(author_id),
    Foreign key (CategoryID) references categories(category_id)
);

create table customer(
customerID int primary key,
name varchar(100) not null,
email varchar(100) unique,
phone int,
address varchar(100)
);

alter table customer add constraint chk_phone check(phone regexp'[789]');
alter table customer modify phone int not null;
alter table customer add dob date;
create table orders(
	orderId int primary key,
    customerId int,
    orderdate date,
    status varchar(10) default 'pending',
	constraint fk_cus foreign key (customerId) references customer(customerID)
);
create table ordersdetails(
	OrderID int,
    BookId int,
    quantity int check(quantity>=0),
    price decimal(5,2) check (price>0.1),
    primary key(OrderID,BookID),
	constraint fk_order foreign key (OrderID) references orders(orderId),
	constraint fk_book foreign key (BookId) references books(bookID)
);

create table payments(
	paymentID int primary key,
    orderID int,
    amount int,
    payment_date date,
    method varchar(100) default 'cash',
	constraint fk_orders foreign key (orderID) references orders(orderId)
);

alter table books add ISBN varchar(10);
alter table books add constraint uc_isbn unique(ISBN);
alter table books modify stock tinyint;
alter table books rename column PublishYear to Yearpublished;
alter table customer drop column dob;
alter table ordersdetails add discount decimal(5,4) default 0;
alter table books drop index uc_isbn;
alter table orders add deliveryAgentid int;


create table deliveryagent(
	agentID int primary key,
    namee varchar(100),
    phone int unique,
    region varchar(6) default 'north',
    check (region in ('north','south','east','west'))
);
alter table orders add deliveryagentid int;

alter table orders add constraint fk_id foreign key (deliveryagentid) references deliveryteam (agentid);
alter table orders drop foreign key fk_id;
alter table deliveryagent add email varchar(100) unique;
alter table deliveryagent modify phone varchar(10);
alter table deliveryagent drop column email;
alter table books rename column title to booktitle;
rename table books to book;
drop table payments;
rename table deliveryagent to deliveryteam;
ALTER TABLE deliveryteam DROP CHECK deliveryteam_chk_1;
alter table deliveryteam rename column region to assignedregion;
truncate table deliveryteam;
truncate table ordersdetails;
drop table deliveryteam;
rename table book to bookinventory;
rename table  customer to clients;
alter table clients rename column name to fullname;
alter table ordersdetails drop foreign key fk_book;
select * from book;
create table OrderNotes(
	NoteId int,
    Note text not null,
    constraint pk_note primary key(NoteId)
);
alter table book drop index uc_isbn;
alter table book drop check price_chk;
create table ReturnRequests(
	ReturnID int,
    OrderID int,
    Reason varchar(100),
    statuss varchar(20) default "Pending",
    constraint pk_retuen primary key(ReturnID),
    constraint fk_return foreign key (OrderId) references orders(orderId)
);
alter table ReturnRequests add column ReturnDate date;
alter table ReturnRequests drop constraint fk_return;
create table wishlist(
	customer_id int,
    bookid int,
    dateadded date,
    constraint pk_wish primary key(customer_id,bookid),
    constraint fk_wish1 foreign key (customer_id) references customer(customerID),
    constraint fk_wish2 foreign key (bookid) references book(bookID)
    );
alter table wishlist drop dateadded;
rename table wishlist to customerwishlists;
rename table customerwishlists to wishlists;
drop table books;

create table books(
	bookID int primary key,
    title varchar(100) unique,
    authorID int,
    CategoryID int,
    Price int ,
    constraint price_chk check (Price>0),
    Stock int ,
	constraint stk_chk check(stock>=0),
    PublishYear Year Default (Year(curdate())),
    Foreign key (authorID) references author(author_id),
    Foreign key (CategoryID) references categories(category_id)
);

alter table wishlists drop constraint fk_wish2;
alter table books add column edition varchar(20) default "first";
alter table books modify edition varchar(50);
alter table books drop column edition;

create table deliverylogs(
	logid int,
    deliveryagentid int,
    datee date,
    statuss varchar(20)
);
alter table deliverylogs add constraint pk_del primary key (logid);
alter table deliverylogs add constraint fk_del foreign key (deliveryagentid) references deliveryteam(agentID);
alter table deliverylogs add column comments varchar(10);
alter table deliverylogs drop column comments;
alter table deliverylogs add  constraint ch_status Check (statuss in('delivered','pending','failed'));
alter table books add column rating int check (rating between 1 and 5);
alter table books modify rating decimal(3,2);
alter table books drop column rating;

CREATE TABLE BookReviews (
 ReviewID INT PRIMARY KEY,
 BookID INT,
 CustomerID INT,
 ReviewText TEXT,
 FOREIGN KEY (BookID) REFERENCES Books(BookID),
 FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

ALTER TABLE BookReviews ADD CONSTRAINT fk_book FOREIGN KEY (BookID) REFERENCES Books(BookID);
ALTER TABLE BookReviews ADD CONSTRAINT fk_customer FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID);
ALTER TABLE BookReviews DROP FOREIGN KEY fk_book;
ALTER TABLE BookReviews DROP FOREIGN KEY fk_customer;
DROP TABLE BookReviews;

create view tsb as
select b.bookID,b.title, sum(od.quantity) as totalsold
from books b
join orderdetails od on b.bookID = od.bookId
group by b.bookID,b.title
order by totalsold;
    
CREATE TABLE Coupons (
 CouponID INT PRIMARY KEY,
 Code VARCHAR(50) UNIQUE,
 Discount INT,
 ExpiryDate DATE
);

ALTER TABLE Coupons ADD Status VARCHAR(20) DEFAULT 'Active';
ALTER TABLE Coupons ADD CONSTRAINT chk_discount CHECK (Discount BETWEEN 1 AND 50);
ALTER TABLE Coupons DROP CHECK chk_discount;
ALTER TABLE Coupons DROP COLUMN Status;

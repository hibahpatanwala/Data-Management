create database main_user;
use main_user;
CREATE TABLE user_information(
	id INT,
    age INT,
    uname varchar(30) NOT NULL,
    email varchar(30) UNIQUE,
    followers INT DEFAULT 0,
    ufollowing INT,
    CONSTRAINT age_check CHECK (age >= 13)
);


CREATE TABLE user_info(
	id INT,
	age INT,
    uname varchar(30) NOT NULL,
    followers INT DEFAULT 0,
    ufollowing int,
    constraint check (age >=13)
);

show tables;
CREATE TABLE user_info1(
	id INT,
	age INT,
    uname varchar(30) NOT NULL,
    followers INT DEFAULT 0,
    ufollowing int,
    constraint check (age >=13),
    primary key(id)
);

select * from user_info1;
INSERT INTO user_info1(id,age,uname)
values(1,14,"hibah");

INSERT INTO user_info1(id,age,uname,followers,ufollowing)
values(12,15,"nope",0,26);
	
INSERT INTO user_info1(id,age,uname)
values(5,14,"hibah1");

INSERT INTO user_info1(id,age,uname)
values(3,14,"hibah2");

INSERT INTO user_info1(id,age,uname)
values(4,43,"hibah3");

INSERT INTO user_info1(id,age,uname)
values(97,17,"hibah89");

select * 
from user_info1
where followers > 0;

select uname 
from user_info1
where followers > 0;
select count(*)
from user_info1
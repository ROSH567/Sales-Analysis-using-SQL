CREATE DATABASE IF NOT EXISTS salesWalmart;
use salesWalmart;

CREATE TABLE IF NOT EXISTS sales
(

invoice_id varchar(30) not null primary key,
branch varchar(5) not null,
city varchar(30) not null,
customer_type varchar(30) not null, 
gender varchar(6) not null,
product_line varchar(100) not null, 
unit_price decimal(10,2) not null,
quantity int not null,
vat float(6,4) not null,
total decimal(12,4) not null,
date datetime not null,
time time not null,
payment_method varchar(15) not null,
cogs decimal(10,2) not null,
gross_margin_per float(11,9),
gross_income decimal(12,4) not null,
rating float(2,1)

);

















-- -------------------------------------------------------------- --
-- feature engineering -- 
-- -------------------------------------------------------------- --

-- time_of_day 
select 
   time, 
      (CASE
	     WHEN `time` between "00:00:00" and "12:00:00" THEN "MORNING"
         WHEN `time` between "12:01:00" and "16:00:00" THEN "AFTERNOON"
         ELSE  "EVENING"
       END) AS time_of_date
from sales;
--
ALTER TABLE sales ADD COLUMN time_of_day varchar(20);
--

UPDATE sales 
set time_of_day=
(
       CASE
	     WHEN `time` between "00:00:00" and "12:00:00" THEN "MORNING"
         WHEN `time` between "12:01:00" and "16:00:00" THEN "AFTERNOON"
         ELSE  "EVENING"
       END
);
-- -------------------------------------------------------------- --

-- day_name 

SELECT
    date, DAYNAME(date)
FROM sales;
--
--
ALTER table sales add column day_name varchar(10);
--
-- 

UPDATE sales 
    SET day_name=dayname(date);
    
    
--
--
select date, monthname(date) from sales;

--

ALTER TABLE sales 
      add COLUMN month_name VARCHAR(12);
	
update sales
   set month_name=monthname(date);
   
   
   
--
--
--
-- ------------------------------------------------------------------------------------------------------------------------ --
--                                    EDA                                                                                   --
-- ------------------------------------------------------------------------------------------------------------------------ --
--  unique cities -- 
select distinct(city) from sales;

-- In which city is the each branch --
select distinct(branch) from sales;
select distinct(city), branch from sales;

-- How many unique product lines does the data have --
select distinct(product_line) from sales limit 9;
select count(distinct(product_line)) from sales;

-- which is the most common payment method --
select max(payment_method) as MOST_COMMON_PAYMENT_METHOD from sales;

select payment_method,count(payment_method) as cnt
from sales 
group by payment_method
order by cnt desc;

--  most selling product_line -- 
select max(product_line) from sales;

select product_line, count(product_line) as cnt
from sales group by product_line
order by cnt desc;


-- what is total revenue by month -- 

select month_name, sum(total) as revenue 
from sales group by month_name order by revenue desc;


-- month with largest cogs --

select month_name, sum(cogs) as cogs
from sales 
group by month_name 
order by cogs desc;


-- which product line is with maximum revenue --

select product_line, sum(total) as total
from sales
group by product_line
order by total desc;


-- city with the largest revenue -- 

select city, branch, sum(total) as revenue 
from sales 
group by city, branch
order by revenue desc;

-- product_line with max vat --

select product_line, avg(vat) avg_tax
from sales 
group by product_line 
order by avg_tax desc;


-- which branch sold more than average sales 

select branch , sum(quantity) 
from sales 
group by branch 
having sum(quantity) >(select avg(quantity) from sales);


-- most common product line by gender 

select product_line, gender, count(gender) as count 
from sales
group by gender, product_line
order by count desc;


-- average rating of each product_line 

select product_line, Round(avg(rating),2) average_rating
from sales 
group by product_line 
order by average_rating desc;

select * from sales;

delimiter //
CREATE PROCEDURE citycount (IN country CHAR(3), OUT cities INT)
       BEGIN
         SELECT COUNT(*) INTO cities FROM world.city
         WHERE CountryCode = country;
       END //
create table IF NOT EXISTS tabla 
(

invoice_id varchar(30) not null primary key,
branch varchar(5) not null,
city varchar(30) not null,
customer_type varchar(30) not null, 
gender varchar(6) not null,
product_line varchar(100) not null, 
unit_price decimal(10,2) not null,
quantity int not null,
vat float(6,4) not null,
total decimal(12,4) not null,
date datetime not null,
time time not null,
payment_method varchar(15) not null,
cogs decimal(10,2) not null,
gross_margin_per float(11,9),
gross_income decimal(12,4) not null,
rating float(2,1)

);
insert into tabla select * from sales;
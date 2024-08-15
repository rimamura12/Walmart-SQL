select*
from `walmartsalesdata.csv`;

-- data cleaning process (check for duplicate, blanks, null) --

select*,
row_number() over(
partition by `Invoice ID`) as row_num
from `walmartsalesdata.csv`;

with duplicate_cte as
(
select*,
row_number() over(
partition by `Invoice ID`) as row_num
from `walmartsalesdata.csv`
)
select*
from duplicate_cte
where row_num > 1;

select*,
row_number() over(
partition by `Invoice ID`) as row_num
from `walmartsalesdata.csv`;

-- modifying data --

select*
from `walmartsalesdata.csv`
where `invoice id` is null or
`branch` is null or 
`customer type` is null or 
`gender` is null or 
`product line` is null or 
`unit price` is null or 
`branch` is null or 
`quantity` is null or 
`tax 5%` is null or 
`total` is null or 
`date` is null or 
`time` is null or 
`payment` is null or 
`cogs` is null or 
`gross margin percentage` is null or 
`gross income` is null or 
`rating` is null;

 select*
from `walmartsalesdata.csv`
where `invoice id` = '' or
`branch` = '' or 
`customer type` = '' or 
`gender` = '' or 
`product line` = '' or 
`unit price` = '' or 
`branch` = '' or 
`quantity` = '' or 
`tax 5%` = '' or 
`total` = '' or 
`date` = '' or 
`time` = '' or 
`payment` = '' or 
`cogs` = '' or 
`gross margin percentage` = '' or 
`gross income` = '' or 
`rating` = '';

select*
from `walmartsalesdata.csv`;

select `time`,
(case 
	when `time` between "07:00:00" and "12:00:00" then "Morning"
	when `time` between "12:01:00" and "16:00:00" then "Afternoon"
	When `time` between "16:01:00" and "20:00:00" then "Evening"
    When `time` between "20:01:00" and "24:00:00" then "Night"
    When `time` between "00:01:00" and "06:59:00" then "Midnight"
End
) as time_of_date
from `walmartsalesdata.csv`;

CREATE TABLE `walmartsalesdata2` (
  `Invoice ID` text,
  `Branch` text,
  `City` text,
  `Customer type` text,
  `Gender` text,
  `Product line` text,
  `Unit price` double DEFAULT NULL,
  `Quantity` int DEFAULT NULL,
  `Tax 5%` double DEFAULT NULL,
  `Total` double DEFAULT NULL,
  `Date` text,
  `Time` text,
  `Payment` text,
  `cogs` double DEFAULT NULL,
  `gross margin percentage` double DEFAULT NULL,
  `gross income` double DEFAULT NULL,
  `Rating` double DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select*
from walmartsalesdata2;

alter table walmartsalesdata2
add column time_of_day varchar(20);

update walmartsalesdata2
set time_of_day = 
(
(case 
	when `time` between "07:00:00" and "12:00:00" then "Morning"
	when `time` between "12:01:00" and "16:00:00" then "Afternoon"
	When `time` between "16:01:00" and "20:00:00" then "Evening"
    When `time` between "20:01:00" and "24:00:00" then "Night"
    When `time` between "00:01:00" and "06:59:00" then "Midnight"
End
)
);

select*
from walmartsalesdata2;

select date,
dayname(date)
from walmartsalesdata2;

alter table walmartsalesdata2
add column day_name varchar(20);

update walmartsalesdata2
set day_name = dayname(date);

select*
from walmartsalesdata2;

alter table walmartsalesdata2
add column month_name varchar(20);

update walmartsalesdata2
set month_name = monthname(date);

select*
from walmartsalesdata2;

-- how many unique cities and how many for each city? --

select city
from walmartsalesdata2;

select distinct city
from walmartsalesdata2;

select city, count(*)
from walmartsalesdata2
group by city;

-- which city is each branch? --

select distinct branch
from walmartsalesdata2;

select distinct branch, city
from walmartsalesdata2;

-- How many unique product lines and the most selling product line? --

select distinct `product line`
from walmartsalesdata2;

select `product line`, count(*)
from walmartsalesdata2
group by `product line`
order by `product line` asc;

-- most common type of payment--

select payment, count(*)
from walmartsalesdata2
group by payment;

-- money related findings -- 

select month_name as month,
round(sum(total),2) as total_revenue
from walmartsalesdata2
group by month_name
order by month_name asc;

select month_name as month,
round(sum(cogs),2) as cogs
from walmartsalesdata2
group by month_name
order by cogs desc;

select `product line`,
round(sum(total),2) as total_revenue_of_product_line
from walmartsalesdata2
group by `product line`
order by `total_revenue_of_product_line` desc;

select city,
round(sum(total),2) as total_revenue_city
from walmartsalesdata2
group by `city`
order by `total_revenue_city` desc;

select city, branch,
round(sum(total),2) as total_revenue_city
from walmartsalesdata2
group by city, branch
order by `total_revenue_city` desc;

select `product line`,
round(avg(`tax 5%`),2) as avg_vat
from walmartsalesdata2
group by `product line`
order by avg_vat desc;

-- which branch sold more products that average product sold

select branch, 
sum(quantity)
from walmartsalesdata2
group by branch
having sum(quantity) > (select avg(quantity) from walmartsalesdata2);

-- what is the most common product line by gender -- 

select gender, `product line`, count(gender) as total_count
from walmartsalesdata2
group by gender, `product line`
order by total_count desc;





select*
from walmartsalesdata2;
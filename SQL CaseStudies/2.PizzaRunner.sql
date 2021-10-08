--A. Pizza Metrics
--How many pizzas were ordered?
--How many unique customer orders were made?
--How many successful orders were delivered by each runner?
--How many of each type of pizza was delivered?
--How many Vegetarian and Meatlovers were ordered by each customer?
--What was the maximum number of pizzas delivered in a single order?
--For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
--How many pizzas were delivered that had both exclusions and extras?
--What was the total volume of pizzas ordered for each hour of the day?
--What was the volume of orders for each day of the week?

--How many pizzas were ordered?
select count(order_id) as pizzacnt
from dbo.customer_orders

--How many unique customer orders were made?
select count(distinct order_id) as custcnt
from dbo.customer_orders

--How many successful orders were delivered by each runner?
select runner_id, count(order_id) as orders
from dbo.runner_orders
where distance != 'null'
group by runner_id

--How many of each type of pizza was delivered?
select c.pizza_id,p.pizza_name, count(c.pizza_id) as cnt
--had to convert p.pizza_name from text to nvarchar
from dbo.customer_orders c
Join dbo.pizza_names p
On p.pizza_id = c.pizza_id
Join runner_orders as r
On r.order_id = c.order_id
where r.distance != 'null'
--make sure that they were delivered and not just ordered
group by c.pizza_id, p.pizza_name

--How many Vegetarian and Meatlovers were ordered by each customer?
select c.customer_id,p.pizza_name,count(p.pizza_name) as cnt
from dbo.customer_orders c
Join dbo.pizza_names p
On p.pizza_id = c.pizza_id
group by c.customer_id,p.pizza_name
order by c.customer_id

--What was the maximum number of pizzas delivered in a single order?
with cte as
(select order_id,count(order_id) as cnt
from dbo.customer_orders
group by order_id)
select max(cnt) from cte

--For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
UPDATE dbo.customer_orders
set exclusions = null
where exclusions = 'null' or exclusions = ''
UPDATE dbo.customer_orders
set extras = null
where extras = 'null' or extras = ''
--Updated the table to change string nulls to real NULLs
Select customer_id,
count(case when exclusions is not null or extras is not null then 1 else null end) as one_change,
count(case when exclusions is null and extras is null  then 1 else null end) as no_change
from dbo.customer_orders c
Join dbo.runner_orders r
On r.order_id = c.order_id
where r.distance != 'null'
group by customer_id

--How many pizzas were delivered that had both exclusions and extras?
select sum(both) as both from
(Select customer_id,
count(case when exclusions is not null and extras is not null then 1 else null end) as both
from dbo.customer_orders c
Join dbo.runner_orders r
On r.order_id = c.order_id
where r.distance != 'null'
group by customer_id) x

--What was the total volume of pizzas ordered for each hour of the day?
select datepart(hour,order_time) as t_hour, count(order_id) as cnt
from dbo.customer_orders
group by datepart(hour,order_time)

--What was the volume of orders for each day of the week?
SELECT 
  FORMAT(DATEADD(DAY, 2, order_time),'dddd') AS day_of_week, -- add 2 to adjust 1st day of the week as Monday
  COUNT(order_id) AS total_pizzas_ordered
FROM dbo.customer_orders
GROUP BY FORMAT(DATEADD(DAY, 2, order_time),'dddd');
--order_time is type varchar(100), dateadd transforms it into a date type which then can be formatted


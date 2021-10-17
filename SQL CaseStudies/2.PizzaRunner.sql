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

--B. Runner and Customer Experience
--How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
--What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
--Is there any relationship between the number of pizzas and how long the order takes to prepare?
--What was the average distance travelled for each customer?
--What was the difference between the longest and shortest delivery times for all orders?
--What was the average speed for each runner for each delivery and do you notice any trend for these values?
--What is the successful delivery percentage for each runner?

--How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
select datepart(WEEK,registration_date) as reg_week, count(runner_id) as signup_cnt
from dbo.runners
group by datepart(WEEK,registration_date)

--What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
UPDATE dbo.runner_orders
set duration = NULL
where duration = 'null'
UPDATE dbo.runner_orders
set distance = NULL
where distance = 'null'
UPDATE dbo.runner_orders
set pickup_time = NULL
where pickup_time = 'null'
--gets rid of string nulls
with cte as
(select r.runner_id, datediff(minute, r.pickup_time, c.order_time) as min_diff
from dbo.customer_orders c
Join dbo.runner_orders r
On c.order_id = r.order_id)
select runner_id, abs(avg(min_diff)) as avg_putime_min
from cte
group by runner_id

--Is there any relationship between the number of pizzas and how long the order takes to prepare?
--(I assume that the diff btw pickup and order is the preparation time)
with cte as
(select c.order_id, abs(datediff(minute, r.pickup_time, c.order_time)) as prep_time
from dbo.customer_orders c
Join dbo.runner_orders r
On c.order_id = r.order_id)
,cte2 as
(select order_id,count(order_id) as n_piz, avg(prep_time) as t_time
from cte
group by order_id
Having avg(prep_time) is not null)
select n_piz, avg(t_time) as avg_p_time
from cte2
group by n_piz
--On average, it takes around 10 min per pizza

--What was the average distance travelled for each customer?
with cte as
(select c.order_id, c.customer_id, convert(float,left(r.distance,2)) as distance
from dbo.customer_orders c
Join dbo.runner_orders r
On c.order_id = r.order_id)
select customer_id, avg(distance) as avg_dist
from cte
group by customer_id

--What was the difference between the longest and shortest delivery times for all orders?
with cte as
(select order_id,convert(int,left(duration,2)) as dur
from dbo.runner_orders)
select max(dur)-min(dur) as diff_deliveryt
from cte

--What was the average speed for each runner for each delivery and do you notice any trend for these values?
--Formula for speed: distance/time
select runner_id,order_id,distance, convert(float,left(distance,2))/convert(float,left(duration,2)) as 'avg_speed (km/min)'
from dbo.runner_orders
where convert(float,left(distance,2))/convert(float,left(duration,2)) is not NULL
order by runner_id

--What is the successful delivery percentage for each runner?
update dbo.runner_orders
set cancellation = null
where cancellation = 'null' or cancellation = ''

with cte as
(select runner_id, count(case when cancellation is not null then 1 else null end) as n_cancelled,
count(case when cancellation is null then 1 else null end) as n_delivered
from dbo.runner_orders
group by runner_id)
select runner_id, convert(float,n_delivered)/(n_cancelled+n_delivered)*100 as success_perc
from cte

--C. Ingredient Optimisation
--What are the standard ingredients for each pizza?
--What was the most commonly added extra?
--What was the most common exclusion?
--Generate an order item for each record in the customers_orders table in the format of one of the following:
--Meat Lovers
--Meat Lovers - Exclude Beef
--Meat Lovers - Extra Bacon
--Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers
--Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
--For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"
--What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?

--What are the standard ingredients for each pizza?
Create View v_PTN as
with cte as
(select pizza_id, value as topping_id
from dbo.pizza_recipes
CROSS APPLY string_split(CAST(toppings AS VARCHAR(MAX)), ','))
,cte2 as
(select c.pizza_id, trim(c.topping_id) as topping_id, t.topping_name
from cte c
Join dbo.pizza_toppings t
On c.topping_id = t.topping_id)
select * from cte2

select * from v_PTN

SELECT pizza_id,STRING_AGG( ISNULL(cast(topping_name as varchar), ' '), ', ') As Toppings
From v_PTN
group by pizza_id

--What was the most commonly added extra?
with cte as
(select pizza_id, trim(value) as topping_id
from dbo.customer_orders
CROSS APPLY string_split(CAST(extras AS VARCHAR(MAX)), ','))
,cte2 as
(select c.topping_id, count(c.topping_id) as cnt
from cte c
group by c.topping_id)
select t.topping_name,cast(c2.topping_id as int) as topping_id, c2.cnt
from cte2 c2
Join dbo.pizza_toppings t
on t.topping_id = c2.topping_id

--What was the most common exclusion?
with cte as
(select pizza_id, trim(value) as topping_id
from dbo.customer_orders
CROSS APPLY string_split(CAST(exclusions AS VARCHAR(MAX)), ','))
,cte2 as
(select c.topping_id, count(c.topping_id) as cnt
from cte c
group by c.topping_id)
select t.topping_name,cast(c2.topping_id as int) as topping_id, c2.cnt
from cte2 c2
Join dbo.pizza_toppings t
on t.topping_id = c2.topping_id
order by cnt desc

--Generate an order item for each record in the customers_orders table in the format of one of the following:
--Meat Lovers
--Meat Lovers - Exclude Beef
--Meat Lovers - Extra Bacon
--Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers
Create View v_PEE as
(select row_number() over(order by order_id) as rn,p.pizza_name,c.pizza_id, c.exclusions, c.extras
from dbo.customer_orders c
Join dbo.pizza_names p
On p.pizza_id = c.pizza_id)

select * from v_PEE

Create view exclusions as
with cte as
(select rn,pizza_name,exclusions,extras,trim(value) as v_split
from v_PEE
CROSS APPLY string_split(CAST(exclusions AS VARCHAR(MAX)), ','))
,cte2 as
(select * from cte c
Join dbo.pizza_toppings t
On t.topping_id = c.v_split)
select * from cte2

SELECT rn,pizza_name,STRING_AGG(isnull(cast(topping_name as varchar), ' '), ', ') As exclusions
From cte2
group by rn,pizza_name

Select * from cte

Create view extras as
with cte as
(select rn,pizza_name,exclusions,extras,trim(value) as v_split
from v_PEE
CROSS APPLY string_split(CAST(extras AS VARCHAR(MAX)), ','))
,cte2 as
(select * from cte c
Join dbo.pizza_toppings t
On t.topping_id = c.v_split)
,cte3 as
(SELECT rn,pizza_name,STRING_AGG( ISNULL(cast(topping_name as varchar), ' '), ', ') As extras
From cte2
group by rn,pizza_name)
select * from cte3

select * from exclusions
select * from extras

select * from v_PEE

select exc.rn,exc.pizza_name,exc.exclusions--,ext.extras
from exclusions exc
FULL OUTER Join extras ext
On ext.rn = exc.rn
where exc.rn is not null
Union
select rn,pizza_name,exclusions,extras from v_PEE
where exclusions is null and extras is null


--Generate an alphabetically ordered comma separated ingredient list for each pizza order from the 
--customer_orders table and add a 2x in front of any relevant ingredients
--For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"


--What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?
select c.order_id,c.pizza_id,c.exclusions,c.extras
from dbo.customer_orders c
Join dbo.runner_orders r
On r.order_id = c.order_id
where r.distance is not Null

Create view total as
with cte as
(select v.pizza_id,p.toppings from v_delivered v
Join dbo.pizza_recipes p
On p.pizza_id = v.pizza_id
where exclusions is null and extras is null)
,cte2 as
(select pizza_id, value as topping_id
from cte
CROSS APPLY string_split(CAST(toppings AS VARCHAR(MAX)), ','))
select trim(topping_id) as top_id, count(trim(topping_id)) as cnt_top
from cte2
group by trim(topping_id)

Create view sub_exc as
with cte as
(select c.exclusions,c.extras
from dbo.customer_orders c
Join dbo.runner_orders r
On r.order_id = c.order_id
where r.distance is not Null and c.exclusions is not null or c.extras is not null)
,cte2 as
(select exclusions, trim(value) as exclusions2
from cte
CROSS APPLY string_split(CAST(exclusions AS VARCHAR(MAX)), ','))
Select exclusions2 as top_id, count(exclusions2) as sub_exc
from cte2
group by exclusions2

Create view sub_extr as
with cte as
(select c.exclusions,c.extras
from dbo.customer_orders c
Join dbo.runner_orders r
On r.order_id = c.order_id
where r.distance is not Null and c.exclusions is not null or c.extras is not null)
,cte2 as
(select extras, trim(value) as extras2
from cte
CROSS APPLY string_split(CAST(extras AS VARCHAR(MAX)), ','))
Select extras2 as top_id, count(extras2) as sub_ext
from cte2
group by extras2

Create view v_top_delivered as
with cte as
(Select t.top_id,t.cnt_top,se.sub_exc, sx.sub_ext
from total t
Left Join sub_exc se
On se.top_id =t.top_id
Left Join sub_extr sx
On sx.top_id = t.top_id)
,cte2 as
(select top_id,cnt_top,isnull(sub_exc,0) as sub_exc, isnull(sub_ext,0) as sub_ext
from cte)
select v.topping_name,top_id,(cnt_top-sub_exc-sub_ext) as cnt_toppings
from cte2 c
Join v_PTN v
On v.topping_id = c.top_id

select * from v_top_delivered
order by cnt_toppings desc

--D. Pricing and Ratings
--If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes 
-- how much money has Pizza Runner made so far if there are no delivery fees?
--What if there was an additional $1 charge for any pizza extras?
--Add cheese is $1 extra
--The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, 
--how would you design an additional table for this new dataset - 
--generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.
--Using your newly generated table - can you join all of the information together to form a 
--table which has the following information for successful deliveries?
--customer_id
--order_id
--runner_id
--rating
--order_time
--pickup_time
--Time between order and pickup
--Delivery duration
--Average speed
--Total number of pizzas
--If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and 
--each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?

--If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes 
-- how much money has Pizza Runner made so far if there are no delivery fees?
with cte as
(select pizza_id, count(pizza_id) as cnt
from dbo.customer_orders c
Join dbo.runner_orders r
On r.order_id = c.order_id
where r.distance is not null
group by pizza_id)
,cte2 as
(select pizza_id, cnt,
case 
	when pizza_id = 1 then cnt * 12
	when pizza_id = 2 then cnt * 10
	else null
	end as 'Money'
from cte)
select sum(Money) as tot_$
from cte2

--What if there was an additional $1 charge for any pizza extras?
--Add cheese is $1 extra
with cte as
(select pizza_id,extras
from dbo.customer_orders c
Join dbo.runner_orders r
On r.order_id = c.order_id
where r.distance is not null)
,cte2 as
(select count(trim(value)) as cnt
from cte
CROSS APPLY string_split(CAST(extras AS VARCHAR(MAX)), ','))
select cnt + 138 as tot_w_extras
from cte2
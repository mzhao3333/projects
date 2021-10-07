/* --------------------
   Case Study Questions
   --------------------*/

-- 1. What is the total amount each customer spent at the restaurant?
-- 2. How many days has each customer visited the restaurant?
-- 3. What was the first item from the menu purchased by each customer?
-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
-- 5. Which item was the most popular for each customer?
-- 6. Which item was purchased first by the customer after they became a member?
-- 7. Which item was purchased just before the customer became a member?
-- 8. What is the total items and amount spent for each member before they became a member?
-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
-- 10. In the first week after a customer joins the program (including their join date) 
--they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

-- 1. What is the total amount each customer spent at the restaurant?
SELECT s.customer_id, sum(m.price) as tot_amt
FROM dbo.sales as s
Join dbo.menu as m
On s.product_id = m.product_id
group by s.customer_id
order by tot_amt desc

-- 2. How many days has each customer visited the restaurant?
SELECT s.customer_id, count(s.order_date) as tot_days
FROM dbo.sales as s
group by s.customer_id
order by tot_days desc

-- 3. What was the first item from the menu purchased by each customer?
with cte as
(select s.customer_id,s.order_date,s.product_id, m.product_name,
row_number() over(partition by s.customer_id order by s.order_date) as rn
from dbo.sales s
Join dbo.menu m
On m.product_id = s.product_id)
select customer_id,order_date,product_name
from cte
where rn = 1

-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
select top 1 m.product_name, count(s.product_id) as cnt
from dbo.sales s
Join dbo.menu m
On m.product_id = s.product_id
group by m.product_name
order by cnt desc
--can't use limit 1

-- 5. Which item was the most popular for each customer?
with cte as
(select customer_id, product_id, count(product_id) as cnt, rank() over(partition by customer_id order by count(product_id) desc) as rn
from dbo.sales
group by customer_id,product_id)
select c.customer_id,m.product_name,c.cnt
from cte c
Join dbo.menu m
On m.product_id = c.product_id
where rn = 1

-- 6. Which item was purchased first by the customer after they became a member?
with cte as
(select s.customer_id,s.order_date,s.product_id, rank() over(partition by s.customer_id order by s.order_date) as rn
from dbo.sales s
Join dbo.members m
On m.customer_id = s.customer_id
where m.join_date <= s.order_date)
select c.customer_id,c.order_date,m.product_name 
from cte c
Join dbo.menu m
On m.product_id = c.product_id
where rn = 1

-- 7. Which item was purchased just before the customer became a member?
with cte as
(select s.customer_id,s.order_date,s.product_id, rank() over(partition by s.customer_id order by s.order_date desc) as rn
from dbo.sales s
Join dbo.members m
On m.customer_id = s.customer_id
where s.order_date < m.join_date)
select c.customer_id,c.order_date,m.product_name 
from cte c
Join dbo.menu m
On m.product_id = c.product_id
where rn = 1

-- 8. What is the total items and amount spent for each member before they became a member?
with cte as
(select s.customer_id,s.product_id
from dbo.sales s
Join dbo.members m
On m.customer_id = s.customer_id
where s.order_date < m.join_date)
select c.customer_id,sum(m.price) as sumprice
from cte c
Join dbo.menu m
On c.product_id = m.product_id
group by c.customer_id

-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
with cte as
(select s.customer_id,m.product_name,m.price,
case	
	when m.product_name = 'sushi' Then 2*price*10
	else price*10
end as Points
from dbo.sales s
Join dbo.menu m
On m.product_id = s.product_id)
select customer_id, sum(points) as Points
from cte
group by customer_id

-- 10. In the first week after a customer joins the program (including their join date) 
--they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
with cte as
(select s.customer_id,m.product_name,m.price,s.order_date
from dbo.sales s
Join dbo.menu m
On m.product_id = s.product_id
where s.order_date < '2021-02-01')
,cte2 as
(select c.customer_id,c.product_name,c.price,c.order_date,
case
	when c.order_date between b.join_date and dateadd(day,6,b.join_date) then c.price*2*10
	--to encase the first week, you want the starting day + 6 because it includes both days, otherwise if you + 7, it becomes 8 days
	when c.product_name = 'sushi' then c.price*2*10
	else c.price*10
end as points
from cte c 
Join dbo.members b
on b.customer_id = c.customer_id)
select customer_id,sum(points) as tpoints
from cte2
group by customer_id
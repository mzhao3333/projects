--A. Customer Journey
--Based off the 8 sample customers provided in the sample from the subscriptions table, 
--write a brief description about each customer’s onboarding journey.

--Try to keep it as short as possible - you may also want to run some sort of join to make your explanations a bit easier!
select s.customer_id,p.plan_id,p.plan_name,count(p.plan_id) as cnt
from dbo.subscriptions s
Join dbo.plans p
On p.plan_id = s.plan_id
where customer_id <=8
group by s.customer_id,p.plan_id,p.plan_name
--We can see that for the first 8 customers, they tend to always have the trial first and then move on to
--the basic monthly then they either churn (cancel service but plan continues till end of bill period) or move to pro mo/yr

--B. Data Analysis Questions
--How many customers has Foodie-Fi ever had?
--What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value
--What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name
--What is the customer count and percentage of customers who have churned rounded to 1 decimal place?
--How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?
--What is the number and percentage of customer plans after their initial free trial?
--What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?
--How many customers have upgraded to an annual plan in 2020?
--How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?
--Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)
--How many customers downgraded from a pro monthly to a basic monthly plan in 2020?

--How many customers has Foodie-Fi ever had?
select count(distinct customer_id) from dbo.subscriptions

--What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value
with cte as
(select s.start_date, s.customer_id
from dbo.subscriptions s
Join dbo.plans p
On p.plan_id = s.plan_id
where datepart(day,start_date) = 01 and p.plan_id = 0)
select DatePart(month,start_date) as Month_N,DATENAME(month,start_date) as Month_Name, count(customer_id) as cnt
from cte
group by DatePart(month,start_date),DATENAME(month,start_date)
order by Month_N
--Note that I filtered it to only take in people who started the trial on the 1st of every month since the Q says
--use the start of the month so I assume 01-01,02-01,...

--What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name
select p.plan_name, count(p.plan_name) as cnt
from dbo.subscriptions s
Join dbo.plans p
On p.plan_id = s.plan_id
where s.start_date > '2019-12-31'
group by p.plan_name

--What is the customer count and percentage of customers who have churned rounded to 1 decimal place?
select count(customer_id) n_churn
from dbo.subscriptions
where plan_id = 4
--307
select count(distinct customer_id)
from dbo.subscriptions
--2654 X -> 1000 because # customers not rows
select ROUND((select count(customer_id) n_churn
from dbo.subscriptions
where plan_id = 4)*1.0/count(distinct customer_id),1)*100 as perc_churned
from dbo.subscriptions
--0.3

--How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?
with cte as
(select customer_id,plan_id, row_number() over(partition by customer_id order by start_date) as rn
from dbo.subscriptions)
Select Round(count(plan_id)*1.0/(select count(distinct customer_id)
from dbo.subscriptions)*100,0) as perc_churned from cte
where rn=2 and plan_id = 4
--n_churned=92
--distinct plan_id shows only 0 which is trial

--What is the number and percentage of customer plans after their initial free trial?
--everyone starts with initial free trial (plan_id = 0)
with cte as
(select distinct customer_id, plan_id, start_date
from dbo.subscriptions)
,cte2 as
(select *, row_number() over(partition by customer_id order by start_date) as rn
from cte)
,cte3 as
(select plan_id, count(plan_id) as cnt
from cte2
where rn = 2
group by plan_id)
select plan_id,cnt, cast(cnt*1.0*100/sum(cnt) over() as decimal(10,2)) as perc
from cte3
group by plan_id,cnt
order by plan_id

--What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?
with cte as
(select plan_id,count(plan_id) as cnt 
from dbo.subscriptions
where start_date <= '2020-12-31'
group by plan_id)
Select plan_id, cnt, sum(cnt) over() as sum_all, cast(cnt*1.0*100/sum(cnt) over() as decimal(10,2)) as perc
from cte
order by plan_id

--How many customers have upgraded to an annual plan in 2020?
select count(distinct customer_id) as annual_cnts
from dbo.subscriptions
where start_date between '2020-01-01' and '2020-12-31' and plan_id = 3
--count distinct customers because there are duplicates with customer_id = 2
select * from dbo.subscriptions where start_date between '2020-01-01' and '2020-12-31' and plan_id = 3

--How many days on average does it take for a customer to change to an annual plan from the day they join Foodie-Fi?
with cte as
(select distinct *
from dbo.subscriptions
where plan_id = 0 or plan_id = 3)
,cte2 as
(select customer_id, plan_id, start_date, lag(start_date) over(partition by customer_id order by start_date) as prev
from cte)
,cte3 as
(select *, abs(datediff(day,start_date,prev)) as diff
from cte2
where prev is not null)
select avg(diff) as avg_days
from cte3

--Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)
with cte as
(select distinct *
from dbo.subscriptions
where plan_id = 0 or plan_id = 3)
,cte2 as
(select customer_id, plan_id, start_date, lag(start_date) over(partition by customer_id order by start_date) as prev
from cte)
,cte3 as
(select *, 
case 
when abs(datediff(day,start_date,prev)) between 0 and 30 then '0-30' 
when abs(datediff(day,start_date,prev)) between 31 and 60 then '31-60'
when abs(datediff(day,start_date,prev)) between 61 and 90 then '61-90'
when abs(datediff(day,start_date,prev)) between 91 and 120 then '91-120'
when abs(datediff(day,start_date,prev)) between 121 and 150 then '121-150'
when abs(datediff(day,start_date,prev)) between 151 and 180 then '151-180'
when abs(datediff(day,start_date,prev)) between 181 and 210 then '181-210'
end as '30_periods'
from cte2
where prev is not null)
select [30_periods], count([30_periods]) as cnt
from cte3
where [30_periods] is not null
group by [30_periods]
order by [30_periods]
--An easier way would be to use width_bucket but unsupported
--Would have to manually go all the way to 330-360

--How many customers downgraded from a pro monthly to a basic monthly plan in 2020?
with cte as
(select distinct * from dbo.subscriptions
where plan_id = 2 or plan_id = 1
and start_date between '2020-01-01' and '2020-12-31') 
,cte2 as
(select *, lead(plan_id) over(partition by customer_id order by start_date asc) as next_plan 
from cte)
select count(case when next_plan = 1 then 1 else null end) as n_downgrades
from cte2

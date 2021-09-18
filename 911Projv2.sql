/*
Kaggle Dataset: https://www.kaggle.com/mchirico/montcoalert

Dataset of 911 emergency calls in the Montgomery County, PA area

Skills Used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types,
Creating Procedures, Pivot Tables
*/

--Using MSSQLSERVERV2
use [911Projv2]

Select zip, count(title) as num_emergs
from [dbo].[911]
group by zip
order by num_emergs desc
--# of emergencies per zipcode

with cte as(
Select zip, count(title) as num_emergs, sum(count(title)) over() as tot_emergs
from [dbo].[911]
group by zip)
select zip, num_emergs, cast(num_emergs as float)*100/tot_emergs as percent_emergs
from cte
order by percent_emergs desc
--# of emergencies per zipcode with percentages for each zipcode

with cte2 as(
select zip, title, count(title) as n_e,max(count(title)) over(partition by zip order by count(title) desc) as m_e
from [dbo].[911]
group by zip, title)
Select zip, title, n_e
from cte2
where n_e = m_e
order by n_e desc, zip
--Most common emergency per zipcode

Create procedure dbo.spHighestEmergency_zip
@zip float(50)
as
begin
with cte2 as(
select zip, title, count(title) as n_e,max(count(title)) over(partition by zip order by count(title) desc) as m_e
from [dbo].[911]
group by zip, title)
Select zip, title, n_e
from cte2
where n_e = m_e and zip = @zip
order by n_e desc, zip
end
exec dbo.spHighestEmergency_zip 19454
--Creates a SP which returns highest count of emergency for given zip (single result)
--Error: Maximum stored...
--Solution: Procedure created with an EXEC of itself, Go must be placed before Exec to avoid recursion


Create procedure dbo.Emergencies_zip
@zip float(50)
as
begin
Select zip, title, count(title) as n__e
from [dbo].[911]
where zip = @zip
group by zip, title
order by count(title) desc
end
exec dbo.Emergencies_zip 19454
--Creates SP that returns all emergencies for given zip

with cte as
(Select title, count(title) as num_emergs, sum(count(title)) over() as tot_e
from [dbo].[911]
group by title
)
Select title, num_emergs, tot_e, cast(num_emergs as float)/cast(tot_e as float)*100 as e_percent
from cte
order by e_percent desc
--Percentage of emergencies for all emergencies

--Stored procedure for year/month/date?
--You cannot use a parameter for the datepart in the datefunctions

with cte as (
select title, timeStamp, datepart(year, timeStamp) as t_year
from [dbo].[911]
)
Select t_year, count(t_year) as [e_year]
from cte
group by t_year
order by t_year
--# of emergencies per year, last and first has less because of start/end of dataset

with cte as (
select title, timeStamp, datepart(month, timeStamp) as t_month
from [dbo].[911]
)
Select t_month, count(t_month) as [e_month]
from cte
group by t_month
order by t_month
--# of emergencies per month (across all years)

with cte as (
select title, timeStamp, datepart(day, timeStamp) as t_date
from [dbo].[911]
)
Select t_date, count(t_date) as [e_date]
from cte
group by t_date
order by t_date
--# of emergences per day (across all months and years)

with cte as (
select title, timeStamp, datepart(hour, timeStamp) as t_hour
from [dbo].[911]
),
cte_h as (
Select t_hour, count(t_hour) as [e_hour]
from cte
group by t_hour)
Select * from cte_h
order by t_hour
--# of emergencies per hour (across all time)

with cte as (
select title, timeStamp, datepart(hour, timeStamp) as t_hour
from [dbo].[911]
),
cte_h as (
Select t_hour, count(t_hour) as [e_hour]
from cte
group by t_hour)
Select t_hour, max_e_hour.e_hour from cte_h
Inner Join
(
Select max(e_hour) e_hour
from cte_h
) Max_e_hour
On cte_h.e_hour = Max_e_hour.e_hour
--Which hour has the most emergencies? 17 = 5 PM; people getting off from work?

with cte as (
select title, timeStamp as t_1, lag(timeStamp) over(order by timeStamp) as t_2
from [dbo].[911]),
cte2 as(
select *, abs(datediff(minute,t_1,t_2)) as m_diff
from cte)
Select concat(avg(m_diff), ' minutes') as avg_diff from cte2
--The average time between emergencies
--Lag is outputting a value in the first row...?

Select twp, count(title) as num_emergs, dense_rank() over(order by count(title) desc) as twp_ranks
from [dbo].[911]
group by twp
order by num_emergs desc
--# emergs by township + ranked twp in order of emergencies

Create procedure dbo.emerg_twp
@twp nvarchar(255)
as
begin
with cte as
(
Select twp, count(title) as num_emergs, dense_rank() over(order by count(title) desc) as twp_ranks
from [dbo].[911]
group by twp
)
Select twp.twp,twp.num_emergs,twp.twp_ranks from cte
--should specify which columns from which table when joining
Inner Join
(
Select twp, num_emergs, twp_ranks from cte
where twp = @twp
) as twp
On cte.twp = twp.twp
end
exec dbo.emerg_twp 'upper dublin'
--Stored procedure to return the # emergs and ranking of township when given township name

select addr, count(title) as n_emergs, dense_rank() over(order by count(title) desc) as addr_ranks
from [dbo].[911]
group by addr
order by n_emergs desc
--Number of emergences for each address with rankings


SELECT title,
    PARSENAME(REPLACE(title,':','.'),2) 'Main Emergency' ,
    PARSENAME(REPLACE(title,':','.'),1) 'Sub Emergency'
FROM [dbo].[911] WITH (NOLOCK)
--Replace(string, old_string, new_string)
--Parsename(object_name, object_part), only do-able with '.' hence the replace()
--the object part is ordered from right to left

with cte as(
SELECT title,
    PARSENAME(REPLACE(title,':','.'),2) as [m_emerg] ,
    PARSENAME(REPLACE(title,':','.'),1) as [sub_emerg]
FROM [dbo].[911] WITH (NOLOCK)),
cte2 as(
Select [sub_emerg], count(sub_emerg) as n_sub_emerg, sum(count(sub_emerg)) over() as tot_sub_emerg,
cast(count(sub_emerg) as float)*100/sum(count(sub_emerg)) over() as percent_subemerg
from cte
group by sub_emerg
)
select * 
from cte2
order by percent_subemerg desc
--# of emergencies by subemergencies with percentage of sub_emergencies

Create view v_top_sub_emergs
as
with cte as(
SELECT title,
    PARSENAME(REPLACE(title,':','.'),2) as [m_emerg] ,
    PARSENAME(REPLACE(title,':','.'),1) as [sub_emerg]
FROM [dbo].[911] WITH (NOLOCK)),
cte2 as(
Select [sub_emerg], count(sub_emerg) as n_sub_emerg, sum(count(sub_emerg)) over() as tot_sub_emerg,
cast(count(sub_emerg) as float)*100/sum(count(sub_emerg)) over() as percent_subemerg
from cte
group by sub_emerg
)
select top(10) sub_emerg,n_sub_emerg, percent_subemerg
from cte2
order by percent_subemerg desc
--Creates a view that selects top 10 rows of most sub_emergencies
select * from v_top_sub_emergs

/*
Creating Tables, Pivots, Triggers, Constraints, Foreign Keys
*/

--CREATING A PIVOT TABLE FOR SUB_EMERGENCIES PER YEAR
Create view v_subemerg_pivot
as 
with cte1 as
(
SELECT title, datepart(year,timeStamp) as [Year],
    PARSENAME(REPLACE(title,':','.'),2) as [m_emerg] ,
    PARSENAME(REPLACE(title,':','.'),1) as [sub_emerg]
FROM [dbo].[911] WITH (NOLOCK)
),
cte2 as
(
Select [Year],[sub_emerg]
from cte1
)
select * from cte2
--View for pivot table for subemergencies
--When using temp tables in view, must end with select to return anything

DECLARE 
    @columns NVARCHAR(MAX) = '';
SELECT 
    @columns += QUOTENAME([v_year_sub_emergs].[sub_emerg]) + ','
FROM 
    [v_year_sub_emergs]
group by
    [sub_emerg];
SET @columns = LEFT(@columns, LEN(@columns) - 1);
select @columns
--returns all the items in sub_emerg to be used in pivot table
--v_year_sub_emergs is a view that grouped by year and sub_emerg and has distinct sub_emergs

SELECT * FROM   
(
    SELECT 
       [Year],
       [sub_emerg]	   
    FROM 
        v_subemerg_pivot
        
) t
PIVOT(
    count([sub_emerg]) 
    FOR [sub_emerg] IN (
        [ ABDOMINAL PAINS],[ ACTIVE SHOOTER],[ ALLERGIC REACTION],[ ALTERED MENTAL STATUS],[ AMPUTATION],[ ANIMAL BITE],[ ANIMAL COMPLAINT],[ APPLIANCE FIRE],[ ARMED SUBJECT],[ ASSAULT VICTIM],[ BACK PAINS/INJURY],[ BARRICADED SUBJECT],[ BOMB DEVICE FOUND],[ BOMB THREAT],[ BUILDING FIRE],[ BURN VICTIM],[ CARBON MONOXIDE DETECTOR],[ CARDIAC ARREST],[ CARDIAC EMERGENCY],[ CHOKING],[ CVA/STROKE],[ DEBRIS/FLUIDS ON HIGHWAY],[ DEBRIS/FLUIDS ON HIGHWAY -],[ DEHYDRATION],[ DIABETIC EMERGENCY],[ DISABLED VEHICLE],[ DISABLED VEHICLE -],[ DIZZINESS],[ DROWNING],[ ELECTRICAL FIRE OUTSIDE],[ ELECTROCUTION],[ ELEVATOR EMERGENCY],[ EMS SPECIAL SERVICE],[ EYE INJURY],[ FALL VICTIM],[ FEVER],[ FIRE ALARM],[ FIRE INVESTIGATION],[ FIRE POLICE NEEDED],[ FIRE SPECIAL SERVICE],[ FOOT PATROL],[ FRACTURE],[ GAS-ODOR/LEAK],[ GENERAL WEAKNESS],[ HAZARDOUS MATERIALS INCIDENT],[ HAZARDOUS ROAD CONDITIONS],[ HAZARDOUS ROAD CONDITIONS -],[ HEAD INJURY],[ HEAT EXHAUSTION],[ HEMORRHAGING],[ HIT + RUN],[ INDUSTRIAL ACCIDENT],[ LACERATIONS],[ MATERNITY],[ MEDICAL ALERT ALARM],[ NAUSEA/VOMITING],[ OVERDOSE],[ PLANE CRASH],[ POISONING],[ POLICE INFORMATION],[ PRISONER IN CUSTODY],[ PUBLIC SERVICE],[ PUMP DETAIL],[ RESCUE - ELEVATOR],[ RESCUE - GENERAL],[ RESCUE - TECHNICAL],[ RESCUE - WATER],[ RESPIRATORY EMERGENCY],[ ROAD OBSTRUCTION],[ ROAD OBSTRUCTION -],[ S/B AT HELICOPTER LANDING],[ SEIZURES],[ SHOOTING],[ STABBING],[ STANDBY FOR ANOTHER CO],[ SUBJECT IN PAIN],[ SUICIDE ATTEMPT],[ SUICIDE THREAT],[ SUSPICIOUS],[ SYNCOPAL EPISODE],[ TRAIN CRASH],[ TRANSFERRED CALL],[ TRASH/DUMPSTER FIRE],[ UNCONSCIOUS SUBJECT],[ UNKNOWN MEDICAL EMERGENCY],[ UNKNOWN TYPE FIRE],[ UNRESPONSIVE SUBJECT],[ VEHICLE ACCIDENT],[ VEHICLE ACCIDENT -],[ VEHICLE FIRE],[ VEHICLE FIRE -],[ VEHICLE LEAKING FUEL],[ VEHICLE LEAKING FUEL -],[ WARRANT SERVICE],[ WOODS/FIELD FIRE]
)
) AS pivot_table
--ERROR: pivot table returns a bunch of 1s...
--Attempt to correct the original table, make sure that first column has all duplicate entries?
--Solution: Created a view that didn't count number of sub_emergs and has duplicate entries of year and emergencies
--Counted the sub_emergs in the pivot query itself

/* Example Pivot Query
SELECT * FROM   
(
    SELECT 
        category_name, 
        product_id,
        model_year
    FROM 
        production.products p
        INNER JOIN production.categories c 
            ON c.category_id = p.category_id
) t 
PIVOT(
    COUNT(product_id) 
    FOR category_name IN (
        [Children Bicycles], 
        [Comfort Bicycles], 
        [Cruisers Bicycles], 
        [Cyclocross Bicycles], 
        [Electric Bikes], 
        [Mountain Bikes], 
        [Road Bikes])
) AS pivot_table;
*/
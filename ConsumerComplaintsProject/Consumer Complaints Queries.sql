/*
Dataset of Consumer Complaints in the United States

Skills Used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types,
Creating Procedures, Pivot Tables
*/
Use [ConsumerComplaints]

Select [Complaint ID], count(*) from Consumer_Complaints$
Group BY [Complaint ID]
Having COUNT(*) > 1
  --Checks if there are duplicate values in complaint ID
  --every complaint ID is a complaint

Select distinct [State] from Consumer_Complaints$ 
order by [State] 
--Confirmed that there are 60 different 'states' including NULL

Select distinct [State] from Consumer_Complaints$
where [State] is not NULL
order by [State]
--when filtering by nulls, have to do is/is not NULL

 Select COUNT('Complaint ID') as Num_Complaints, Product from Consumer_Complaints$
 GROUP BY Product order by Num_Complaints desc
--Product by Complaints

 Select COUNT('Complaint ID') as Num_Complaints, [Sub-product] from Consumer_Complaints$
 where [Sub-product] is not NULL
 GROUP BY [Sub-product] order by Num_Complaints desc
 --Sub-product by Complaints

 Select COUNT([Complaint ID]) as Num_Complaints, [Company] from Consumer_Complaints$
 GROUP BY [Company] order by Num_Complaints desc
 --Counpamy by Complaints

 Select [Company Response to consumer], COUNT([Company Response to consumer]) as [Count for ea response] from Consumer_Complaints$
 GROUP BY [Company response to consumer] order by COUNT([Company response to consumer]) desc
 --Count of ea company response to cust

 Select [State], COUNT([Complaint ID]) as Num_Complaints from Consumer_Complaints$
 Group by [State] Order by Num_Complaints desc
 --Number of Complaints by State

 
 Select [ZIP code], COUNT([Company Response to consumer]) as Num_Complaints from Consumer_Complaints$ 
 Where [Zip code] is not NULL
 Group by [ZIP code] Order by Num_Complaints desc 
 --Number of complaints by Zip code (48382 belongs to Commerce Township, Michigan)


 Select [Company Response to consumer], COUNT([Company Response to consumer]) as [Count for ea response] from Consumer_Complaints$
 GROUP BY [Company response to consumer] order by COUNT([Company response to consumer]) desc
 --Count of ea company response to cust

Select * from Customer_Response_State 
where [State] is not NULL
order by 'Closed with explanation' desc
--query from view with where and order by


select * from Product_Complaint_State
where [state] is not Null
order by [Mortgage] desc
--cmplt cnts per product per state


Select * from Product_Complaint_ZipCode
where [Zip code] is not NULL
order by [Mortgage] desc
--cmplt cnts per product per zipcode

Select * from Customer_Response_Zipcode
where [Zip code] is not Null
order by [Closed with explanation] desc
--cnts per explanation per zipcode

Select [Geographic Area], Count([Complaint ID]) as [Complaint Counts]
from [USPOP$]
Left Join [Consumer_Complaints$]
on [Consumer_Complaints$].[State] = [USPOP$].[Geographic Area]
group by [Geographic Area]
--Joining both tables based on the commonality of states

Select [state], count([complaint ID]) as [Complaint Counts], Year([Date Received]) as [Year] 
from [Consumer_Complaints$]
where [state] is not NULL
group by [state],Year([Date Received])
order by 'Year'
--# of complaints per year for ea state

Select [Geographic Area], Count([Complaint ID]) as [CntComplaints]
from [USPOP$]
Left Join [Consumer_Complaints$]
on [Consumer_Complaints$].[State] = [USPOP$].[Geographic Area]
group by [Geographic Area]
--Joining both tables based states; count of complaints for ea state

select [Product], [Issue], count([Issue]) as [Issue Counts] from [Consumer_Complaints$]
group by [Product],[Issue]
order by [Issue Counts] desc
--Most common issue for ea product

select [Product], [Sub-Issue], count([Sub-Issue]) as [Sub-Issue Counts] from [Consumer_Complaints$]
group by [Product],[Sub-Issue]
order by [Sub-Issue Counts] desc
--Most common sub-issue for ea product

Select [Company], [Issue], count([Issue]) as [Issue Counts] from [Consumer_Complaints$]
group by [Company], [Issue]
Having count([Issue]) > 1000
order by [Issue Counts] desc
--Most common Issue for ea company having over 1000 complaints of that issue

Select [Company], [Issue], count([Issue]) as [Issue Counts] from [Consumer_Complaints$]
where [Company public response] is NULL
group by [Company], [Issue]
Having count([Issue]) > 1000
order by [Issue Counts] desc
--most common issue for ea company having over 1000 complaints of that issue where 
--there is no company public response

Select [Company], [Consumer consent provided?], count([Consumer consent provided?]) as [CntConsent] 
from [Consumer_Complaints$]
where [Consumer consent provided?] NOT IN ('N/A', 'Other')
group by [Company], [Consumer consent provided?]
order by [CntConsent] desc
--count of ea type of consumer consent by company

Select [State], [Consumer consent provided?], count([Consumer consent provided?]) as [CntConsent] 
from [Consumer_Complaints$]
where [Consumer consent provided?] NOT IN ('N/A', 'Other')
group by [State], [Consumer consent provided?]
order by [CntConsent] desc
--Count of ea type of consumer consent by state

Select [Zip code], [Consumer consent provided?], count([Consumer consent provided?]) as [CntConsent] 
from [Consumer_Complaints$]
where [Consumer consent provided?] NOT IN ('N/A', 'Other') AND [Zip code] is not null
group by [Zip code], [Consumer consent provided?]
order by [CntConsent] desc
--count of ea type of consumer consent by zipcode

Select [State], [Company], count([Company]) as [Company Cnt] from [Consumer_Complaints$]
group by [State], [Company]
order by [Company Cnt] desc
--count of companies in ea state

select * from CompanybyState
where [State] is not null 
order by [Bank of America] desc
--count of companies in ea state

select * from CpltRatioByStateYr
order by [2016] desc
--complaint ratio per year for ea state

select * from CmpltsByYearCompany
order by [2016] desc
--cmplts per year per company

spGetCmpltsByCompany 'Citibank'
--SP for acquiring cmplts per company for ea year

spGetCmpltsState 'CA'
--SP for acquiring total cmplts for state

spGetCmpltsZipcode '11375'
--SP for acquiring total cmplts for zipcode

spGetCmpltRatio 'DC'
--SP for acquiring cmplt ratio for state
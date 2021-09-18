/*
Views and Stored Procedures pertaining to the Consumer Complaints Dataset
*/


Use [ConsumerComplaints]

Create view Customer_Response_State AS 
Select * From
 (
	Select 
		[State],
		[Company Response to consumer],
		[Complaint ID]
	From
		[ConsumerComplaints].[dbo].[Consumer_Complaints$]
) t --temporary result set; derived table
Pivot(
	Count([Complaint ID])
		For [Company Response to consumer] IN ( 
			[Closed with explanation],
			[Closed with non-monetary relief],
			[Closed with monetary relief],
			[Closed without relief],
			[Closed],
			[Closed with relief],
			[Untimely response],
			[In progress])			
) AS pivot_table
--https://www.sqlservertutorial.net/sql-server-basics/sql-server-pivot/
--Confirmed with Tableau; For each state, the counts of each company response.

Create view Product_Complaint_State AS
Select * From
 (
	Select 
		[State],
		[Product],
		[Complaint ID]
	From
		[ConsumerComplaints].[dbo].[Consumer_Complaints$]
) t --temporary result set; derived table
Pivot(
	Count([Complaint ID])
		For [Product] IN ( 
[Credit card],
[Payday loan],
[Student loan],
[Credit reporting],
[Virtual currency],
[Prepaid card],
[Money transfers],
[Consumer Loan],
[Debt collection],
[Mortgage],
[Bank account or service],
[Other financial service])			
) AS pivot_table
--new view, shows # of complaints per product per state

Create view Product_Complaint_ZipCode AS
Select * From
 (
	Select 
		[Zip code],
		[Product],
		[Complaint ID]
	From
		[ConsumerComplaints].[dbo].[Consumer_Complaints$]
) t --temporary result set; derived table
Pivot(
	Count([Complaint ID])
		For [Product] IN ( 
[Credit card],
[Payday loan],
[Student loan],
[Credit reporting],
[Virtual currency],
[Prepaid card],
[Money transfers],
[Consumer Loan],
[Debt collection],
[Mortgage],
[Bank account or service],
[Other financial service])			
) AS pivot_table
--new view, shows # of complaints per product per Zipcode

Create view Customer_Response_Zipcode AS 
 Select * From
 (
	Select 
		[Zip code],
		[Company Response to consumer],
		[Complaint ID]
	From
		[ConsumerComplaints].[dbo].[Consumer_Complaints$]
) t --temporary result set; derived table
Pivot(
	Count([Complaint ID])
		For [Company Response to consumer] IN ( 
			[Closed with explanation],
			[Closed with non-monetary relief],
			[Closed with monetary relief],
			[Closed without relief],
			[Closed],
			[Closed with relief],
			[Untimely response],
			[In progress])			
) AS pivot_table
--view for ea company response for ea zipcode

Create view CmpltsByYear AS 
 Select * From
 (
	Select 
		Year([Date received]) as [Year],
		[Complaint ID],
		[State]
	From
		[ConsumerComplaints].[dbo].[Consumer_Complaints$]
) t --temporary result set; derived table
Pivot(
	Count([Complaint ID])
		For [Year] IN ( 
			[2011],[2012],[2013],[2014],[2015],[2016])			
) AS pivot_table
--view for cmpts per year per state

Create view CmpltsByYearCompany AS 
 Select * From
 (
	Select 
		Year([Date received]) as [Year],
		[Complaint ID],
		[Company]
	From
		[ConsumerComplaints].[dbo].[Consumer_Complaints$]
) t --temporary result set; derived table
Pivot(
	Count([Complaint ID])
		For [Year] IN ( 
			[2011],[2012],[2013],[2014],[2015],[2016])			
) AS pivot_table
--view for cmplts per year per company

Create view CpltRatio as
with up as 
	(
	select v.*
	from [ConsumerComplaints].[dbo].[USPOP$] u cross apply
		(values 
		(u.[Geographic Area], 2011, u.[2011]),
		(u.[Geographic Area], 2012, u.[2012]),
		(u.[Geographic Area], 2013, u.[2013]),
		(u.[Geographic Area], 2014, u.[2014]),
		(u.[Geographic Area], 2015, u.[2015]),
		(u.[Geographic Area], 2016, u.[2016])
		) v([State], [Year], [pop])
	),
	cc as (
		select year([Date received]) as [Year], [State], count([Complaint ID]) as num_complaints
		from [ConsumerComplaints].[dbo].[Consumer_Complaints$] cc
		group by year([Date received]), [State]
		)
select up.[State], up.[Year], cc.num_complaints, up.pop,
	(cc.num_complaints * 1.0 / up.pop) as complaint_ratio
from up join
	cc
	on up.state = cc.state and up.year = cc.year
--view for cmplt ratio per state (year vertical format)

Create view CpltRatioByStateYr as
Select * From
 (
	Select 
		[Year],
		[complaint_ratio],
		[State]
	From
		CpltRatio
) t --temporary result set; derived table
Pivot(
	sum([complaint_ratio])
		For [Year] IN ( 
			[2011],[2012],[2013],[2014],[2015],[2016])			
) AS pivot_table
--view for cmplt ratio per year per state (year horizontal format)

Create view CompanybyState as
Select * From
 (
	Select 
		[Company],
		[State]
	From
		[ConsumerComplaints].[dbo].[Consumer_Complaints$]
) t --temporary result set; derived table
Pivot(
	Count([Company])
		For [Company] IN ( 
			[Bank of America],
[Wells Fargo & Company],[JPMorgan Chase & Co.],
[Experian],[Equifax],
[Citibank],[Ocwen],
[TransUnion Intermediate Holdings, Inc.],
[Nationstar Mortgage], 
[Capital One],
[U.S. Bancorp],
[Synchrony Financial],
[Select Portfolio Servicing, Inc],
[Ditech Financial LLC],
[Amex],
[Navient Solutions, Inc.])			
) AS pivot_table
--view for count of companies in ea state

Create Procedure spGetCmpltsByCompany
@Company nvarchar(510)
as Begin
	Select * from CmpltsByYearCompany where @Company = [Company] 
End
--SP for acquiring cmplts per company for ea year

Create Procedure spGetCmpltsState
@State nvarchar(510)
as Begin
	 Select [State], COUNT([Complaint ID]) as Num_Complaints from [ConsumerComplaints].[dbo].[Consumer_Complaints$] 
	 where @State = [State]
	 group by [State]	
End
--SP for acquiring total cmplts for state

Create Procedure spGetCmpltsZipcode
@Zipcode float(8)
as Begin
	Select [ZIP code], COUNT([Company Response to consumer]) as Num_Complaints from [ConsumerComplaints].[dbo].[Consumer_Complaints$] 
	Where [Zip code] is not NULL AND @Zipcode = [Zip code]
	Group by [ZIP code]	
End
--SP for acquiring total cmplts for zipcode

Create Procedure spGetCmpltRatio
@State nvarchar(510)
as Begin
	Select * from CpltRatioByStateYr where @State = [State]
End
--SP for acquiring cmplt ratio for state



CREATE TABLE [dbo].[Customer_Temp](
	[Cust_ID] [int] NOT NULL,
	[Cust_fname] [varchar](50) NOT NULL,
	[Cust_lname] [varchar](50) NOT NULL,
	[Cust_gender] [varchar](50) NOT NULL,
	[Cust_birthdate] [date] NOT NULL,
	[Cust_membership] [varchar](50) NOT NULL,
	[Cust_email] [varchar](50) NULL,
	[Cust_mobile] [varchar](50) NULL,
	[Cust_mobile_2] [varchar](50) NULL,
	[Eff_Date] [date],
	[Cust_registerdate] [date] NOT NULL)

Create PROCEDURE Customer_Fill_Dim
AS
Begin

truncate table [dbo].[Customer_Temp]

INSERT INTO [Customer_Temp] ([Cust_ID], [Cust_fname], [Cust_lname], [Cust_gender], [Cust_birthdate], [Cust_membership], [Cust_email],[Cust_mobile],[Cust_mobile_2],[Eff_Date],[Cust_registerdate])
SELECT ISnull(t1.[Cust_ID],t2.[Cust_ID]), ISnull(t1.[Cust_fname],t2.[Cust_fname]), ISnull(t1.[Cust_lname],t2.[Cust_lname]), ISnull(t1.[Cust_gender],t2.[Cust_gender]), ISnull(t1.[Cust_birthdate],t2.[Cust_birthdate]),
ISnull(t1.[Cust_membership],t2.[Cust_membership]), ISnull(t1.[Cust_email],t2.[Cust_email]),
ISnull(t2.[Cust_mobile],t1.[Cust_mobile]),
case 
 when t2.[Cust_ID] IS NULL then NULL
 when t1.[Cust_ID] IS NULL then t2.[Cust_mobile_2]
 when isnull(t2.[Cust_mobile_2],t2.[Cust_mobile]) != t1.[Cust_mobile] then t1.[Cust_mobile]
 else t2.[Cust_mobile_2]
end as [Cust_mobile_2],
case 
 when t2.[Cust_ID] IS NULL then GETDATE()
 when t1.[Cust_ID] IS NULL then t2.[Eff_Date]
 when isnull(t2.[Cust_mobile_2],t2.[Cust_mobile]) != t1.[Cust_mobile] then GETDATE()
 else t2.[Eff_Date]
end as [Eff_Date],
ISnull(t1.[Cust_registerdate],t2.[Cust_registerdate])

FROM [Gym].[dbo].[Mas_Customer] as t1
full outer join [dbo].[Dim_Customer] as t2
on (t1.[Cust_ID]=t2.[Cust_ID])

truncate table [dbo].[Dim_Customer]

insert into [dbo].[Dim_Customer] ([Cust_ID], [Cust_fname], [Cust_lname], [Cust_gender], [Cust_birthdate], [Cust_membership], [Cust_email],[Cust_mobile],[Cust_mobile_2],[Eff_Date],[Cust_registerdate])
select [Cust_ID], [Cust_fname], [Cust_lname], [Cust_gender], [Cust_birthdate], [Cust_membership], [Cust_email],[Cust_mobile],[Cust_mobile_2],[Eff_Date],[Cust_registerdate]
from [Customer_Temp]

End

select * from [Gym].[dbo].[Mas_Customer]
Update [Gym].[dbo].[Mas_Customer]
set [Cust_mobile] = '3565443766' where [Cust_ID] = 1

select * from [dbo].[Dim_Customer]

Exec Customer_Fill_Dim
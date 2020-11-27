USE [DWHGym];  
GO  

CREATE TABLE [dbo].[Fact_Factless](
[Cust_ID1] [int],
[Cust_ID2] [int],
[Rel_ID] [int])


CREATE TABLE [dbo].[Fact_Usage_Tran](

[Cust_ID] [int],
[Surrogate_key_Branch] [int],
[Course_ID] [int],
[Date_Key] [int],
[Time_Key] [int],
[Usage] [int],
)


CREATE TABLE [dbo].[Fact_Usage_Monthly](
[Surrogate_key_Branch] [int],
[Course_ID] [int],
[Date_Key] [int],
[Usage] [int],
[Number] [int]
)


CREATE TABLE [dbo].[Fact_Acc_Usage](

[Cust_ID] [int],
[Surrogate_key_Branch] [int],
[Course_ID] [int],
[TotalUsage] [int],
[Max_Usage] [int],
[Min_Usage] [int],
[Last_date_of_Usage] [Date])

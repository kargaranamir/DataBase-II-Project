CREATE TABLE [dbo].[Fact_Factless_Temp](
[Cust_ID1] [int],
[Cust_ID2] [int],
[Rel_ID] [int])

Create PROCEDURE Factless_Fill_Fact AS
Begin

truncate table [dbo].[Fact_Factless_Temp]

INSERT INTO [dbo].[Fact_Factless_Temp]([Cust_ID1],[Cust_ID2],[Rel_ID])
Select ISNULL(t1.Cust_ID,t2.[Cust_ID1]), ISNULL(t1.Cust_introducer,t2.[Cust_ID2]),1
From [Gym].dbo.[Mas_Customer] as t1 
full outer join [dbo].[Fact_Factless] as t2
on (t1.[Cust_ID] = t2.[Cust_ID1])

truncate table [dbo].[Fact_Factless]
INSERT INTO [dbo].[Fact_Factless] ([Cust_ID1],[Cust_ID2],[Rel_ID])
Select [Cust_ID1],[Cust_ID2],[Rel_ID]
From [dbo].[Fact_Factless_Temp]

End

EXEC Factless_Fill_Fact

Select * from [dbo].[Fact_Factless]

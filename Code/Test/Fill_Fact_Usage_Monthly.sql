CREATE TABLE [dbo].[Fact_Usage_Monthly_Temp](
[Surrogate_key_Branch] [int],
[Course_ID] [int],
[Date_Key] [int],
[Usage] [int],
[Number] [int]
)


CREATE TABLE [dbo].[Fact_Usage_Monthly_Temp2](
[Surrogate_key_Branch] [int],
[Course_ID] [int],
[Date_Key] [int],
[Usage] [int],
[Number] [int]
)

CREATE TABLE [dbo].[Fact_Usage_Monthly_History](
[Surrogate_key_Branch] [int],
[Course_ID] [int],
[Usage] [int],
[Number] [int]
)



Alter PROCEDURE Usage_Monthly_Fill_Fact AS
Begin

declare @minDate date; declare @maxDate date; declare @tempMax date;
set @minDate= (select min(CONVERT (date,convert(char(8),[Date_Key]))) from [dbo].[Fact_Usage_Tran])
set @maxDate= (select max(CONVERT (date,convert(char(8),[Date_Key]))) from [dbo].[Fact_Usage_Tran])
set @tempMax=(select max(CONVERT (date,convert(char(8),[Date_Key]))) from [dbo].[Fact_Usage_Monthly])

set @minDate = DATEFROMPARTS (year(@minDate), month(@minDate), 1)

if @tempMax is not null
	begin
		if @tempMax > @minDate
		begin
			set @tempMax = DATEADD(MONTH, 1, @tempMax);
			set @minDate=@tempMax
		end
	end



while (@minDate <= @maxDate)
begin
 
truncate table [dbo].[Fact_Usage_Monthly_Temp]
truncate table [dbo].[Fact_Usage_Monthly_Temp2]

INSERT INTO [dbo].[Fact_Usage_Monthly_Temp]([Surrogate_key_Branch], [Course_ID], [Date_Key], [Usage],[Number])
Select [Surrogate_key_Branch],[Course_ID],[dbo].[DatetoKey](@minDate),sum([Usage]),COUNT(usage)
from [dbo].[Fact_Usage_Tran]
where [dbo].[DatetoKey](DATEADD(month, 1, @minDate)) > [Date_Key] and [Date_Key] >= [dbo].[DatetoKey](@minDate)
Group by [Surrogate_key_Branch],[Course_ID]

INSERT INTO [dbo].[Fact_Usage_Monthly_Temp2]([Surrogate_key_Branch], [Course_ID],[Date_Key],[Usage],[Number])
Select ISNULL(t1.[Surrogate_key_Branch],t2.Surrogate_key_Branch), ISNULL(t1.[Course_ID],t2.[Course_ID]),[dbo].[DatetoKey](@minDate),ISNULL(t1.[Usage],t2.Usage), ISNULL(t1.[Number],t2.[Number])
FROM [dbo].[Fact_Usage_Monthly_Temp] as t1
full outer join [dbo].[Fact_Usage_Monthly_History] as t2 
on(t1.[Course_ID]=t2.[Course_ID])

INSERT INTO [dbo].[Fact_Usage_Monthly]([Surrogate_key_Branch], [Course_ID],[Date_Key],[Usage],[Number])
Select [Surrogate_key_Branch], [Course_ID],[Date_Key],[Usage],[Number]
From [dbo].[Fact_Usage_Monthly_Temp2]

truncate table [dbo].[Fact_Usage_Monthly_History]

INSERT INTO [dbo].[Fact_Usage_Monthly_History]([Surrogate_key_Branch], [Course_ID], [Usage],[Number])
Select [Surrogate_key_Branch],[Course_ID],0,0
FROM [dbo].[Fact_Usage_Monthly_Temp2]


set @minDate = DATEADD(month, 1, @minDate);
end
end

EXEC Usage_Monthly_Fill_Fact

Select * from  [dbo].[Fact_Usage_Monthly]
order by [Number] desc

truncate table [dbo].[Fact_Usage_Monthly]
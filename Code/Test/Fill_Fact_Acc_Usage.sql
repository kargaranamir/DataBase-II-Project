CREATE TABLE [dbo].[Fact_Acc_Usage_Temp_Daily](
[Cust_ID] [int],
[Surrogate_key_Branch] [int],
[Course_ID] [int],
[Usage] [int])

CREATE TABLE [dbo].[Fact_Acc_Usage_Temp](
[Cust_ID] [int],
[Surrogate_key_Branch] [int],
[Course_ID] [int],
[TotalUsage] [int],
[Max_Usage] [int],
[Min_Usage] [int])

CREATE TABLE [dbo].[Fact_Acc_Usage_Temp2](
[Cust_ID] [int],
[Surrogate_key_Branch] [int],
[Course_ID] [int],
[TotalUsage] [int],
[Max_Usage] [int],
[Min_Usage] [int],
[Last_date_of_Usage] [Date])


Alter PROCEDURE Acc_Usage_Fill_Fact AS
Begin

declare @minDate date; declare @maxDate date; declare @tempMax date;
set @minDate= (select min(CONVERT (date,convert(char(8),[Date_Key]))) from [dbo].[Fact_Usage_Tran])
set @maxDate= (select max(CONVERT (date,convert(char(8),[Date_Key]))) from [dbo].[Fact_Usage_Tran])
set @tempMax=(select max([Last_date_of_Usage]) from [dbo].[Fact_Acc_Usage])


if @tempMax is not null
	begin
		if @tempMax > @minDate
		begin
			set @tempMax = DATEADD(day, 1, @tempMax);
			set @minDate=@tempMax
		end
	end

while (@minDate <= @maxDate)
begin
 
 truncate table [Fact_Acc_Usage_Temp_Daily]
 truncate table [Fact_Acc_Usage_Temp]
 truncate table [Fact_Acc_Usage_Temp2]

INSERT INTO [Fact_Acc_Usage_Temp_Daily]([Cust_ID], [Surrogate_key_Branch], [Course_ID],[Usage])
select Cust_ID, [Surrogate_key_Branch], Course_ID, Usage
from [dbo].[Fact_Usage_Tran] as t1
where [dbo].[DatetoKey](DATEADD(Day, 1, @minDate)) > [Date_Key] and [Date_Key] >= [dbo].[DatetoKey](@minDate)

INSERT INTO [dbo].[Fact_Acc_Usage_Temp]([Cust_ID], [Surrogate_key_Branch], [Course_ID], [TotalUsage], [Max_Usage], [Min_Usage])
Select [Cust_ID], [Surrogate_key_Branch], [Course_ID], sum([Usage]), max([Usage]), min([Usage])
From [Fact_Acc_Usage_Temp_Daily]
group by [Cust_ID],[Surrogate_key_Branch],[Course_ID]


INSERT INTO [dbo].[Fact_Acc_Usage_Temp2]([Cust_ID], [Surrogate_key_Branch], [Course_ID], [TotalUsage], [Max_Usage], [Min_Usage],[Last_date_of_Usage])
Select ISNULL(t1.[Cust_ID],t2.[Cust_ID]), ISNULL(t1.[Surrogate_key_Branch],t2.[Surrogate_key_Branch]), ISNULL(t1.[Course_ID],t2.[Course_ID]),
case 
when t1.[Cust_ID] is null then t2.TotalUsage
when t2.[Cust_ID] is null then t1.TotalUsage
else t1.TotalUsage + t2.TotalUsage
end,
case 
when t1.[Cust_ID] is null then t2.Max_Usage
when t2.[Cust_ID] is null then t1.Max_Usage
when t1.Max_Usage<t2.Max_Usage then t2.Max_Usage
else t1.Max_Usage
end,
case 
when t1.[Cust_ID] is null then t2.Min_Usage
when t2.[Cust_ID] is null then t1.Min_Usage
when t1.Min_Usage< t2.Min_Usage then t1.Min_Usage
else t2.Min_Usage
end,
case 
when t1.[Cust_ID] is null then t2.Last_date_of_Usage
when t2.[Cust_ID] is null then @minDate
when @minDate > t2.Last_date_of_Usage then @minDate
else t2.Last_date_of_Usage
end

From [dbo].[Fact_Acc_Usage_Temp] as t1 full outer join 
[Fact_Acc_Usage] as t2 
on (t1.[Cust_ID]=t2.[Cust_ID] and t1.[Course_ID]=t2.[Course_ID])

truncate table [Fact_Acc_Usage]

INSERT INTO [dbo].[Fact_Acc_Usage]([Cust_ID], [Surrogate_key_Branch], [Course_ID], [TotalUsage], [Max_Usage], [Min_Usage], [Last_date_of_Usage])
Select [Cust_ID], [Surrogate_key_Branch], [Course_ID], [TotalUsage], [Max_Usage], [Min_Usage], [Last_date_of_Usage]
From [Fact_Acc_Usage_Temp2]


set @minDate = DATEADD(day, 1, @minDate);
end

end


EXEC Acc_Usage_Fill_Fact

select * from [Fact_Acc_Usage]

truncate table [Fact_Acc_Usage]


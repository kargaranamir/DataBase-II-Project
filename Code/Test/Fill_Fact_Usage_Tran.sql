CREATE TABLE [dbo].[Fact_Usage_Tran_Temp](
[Cust_ID] [int],
[Surrogate_key_Branch] [int],
[Course_ID] [int],
[Date_Key] [Date],
[Time_Key] [Time],
[Usage] [int],
)

Alter PROCEDURE Usage_Tran_Fill_Fact AS
Begin

declare @minDate date; declare @maxDate date; declare @tempMax date;
set @minDate= (select min([Usage_date]) from [Gym].dbo.[Tran_Usage_Record])
set @maxDate= (select max([Usage_date]) from [Gym].dbo.[Tran_Usage_Record])
set @tempMax=(select max(CONVERT (date,convert(char(8),[Date_Key]))) from [dbo].[Fact_Usage_Tran])


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
 
truncate table [dbo].[Fact_Usage_Tran_Temp]

INSERT INTO [Fact_Usage_Tran_Temp]([Cust_ID], [Surrogate_key_Branch], [Course_ID],[Date_Key],[Time_Key],[Usage])
select Cust_ID, t3.Surrogate_key, t1.Course_ID,Usage_date, Usage_time,
Case 
when DATEDIFF(MINUTE, Course_start_time , Course_end_time)< 0 then 24*60 + DATEDIFF(MINUTE, Course_start_time , Course_end_time)
else DATEDIFF(MINUTE, Course_start_time , Course_end_time)
end AS MinuteDiff

from [Gym].dbo.[Tran_Usage_Record] as t1 inner join
[Gym].dbo.[Mas_Course] as t2 
on (t1.[Course_ID]=t2.[Course_ID])
inner join [dbo].[Dim_Branch] as t3 on (t3.[Branch_ID]=t2.Branch_ID)
where @minDate >= Usage_date and  @minDate <DATEADD(day, 1, Usage_date) and t3.Flag=1

INSERT INTO [dbo].[Fact_Usage_Tran]([Cust_ID], [Surrogate_key_Branch], [Course_ID],[Date_Key],[Time_Key],[Usage])
Select [Cust_ID], [Surrogate_key_Branch], [Course_ID],[dbo].[DatetoKey]([Date_Key]),[dbo].[TimetoKey]([Time_Key]),[Usage]
FROM [Fact_Usage_Tran_Temp]

set @minDate = DATEADD(day, 1, @minDate);
end
end

EXEC Usage_Tran_Fill_Fact

Select * from  [dbo].[Fact_Usage_Tran]


truncate table [dbo].[Fact_Usage_Tran]

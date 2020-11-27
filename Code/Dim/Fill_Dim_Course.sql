CREATE TABLE [dbo].[Course_Temp](
	[Course_ID] [int] NOT NULL PRIMARY KEY,
	[Course_type] [int] NOT NULL,
	[Course_price] [int] NOT NULL,
	[Course_usage_limit] [int] NULL,
	[Course_day_of_week] [int] NULL)

Alter PROCEDURE Course_Fill_Dim AS
begin

Truncate table [dbo].[Course_Temp]

INSERT INTO [Course_Temp] ([Course_ID], [Course_type], [Course_price], [Course_usage_limit], [Course_day_of_week])
SELECT ISnull(t1.[Course_ID],t2.[Course_ID]), ISnull(t1.[Course_type],t2.[Course_type]), ISnull(t1.[Course_price],t2.[Course_price]), ISnull(t1.[Course_usage_limit],t2.[Course_usage_limit]), ISnull(t1.[Course_day_of_week],t2.[Course_day_of_week])
FROM [Gym].dbo.Mas_Course as t1
full outer join [dbo].[Dim_Course] as t2
on (t1.[Course_ID]=t2.[Course_ID])

Truncate table [dbo].[Dim_Course]

INSERT INTO [dbo].[Dim_Course] ([Course_ID], [Course_type], [Course_price], [Course_usage_limit], [Course_day_of_week])
select [Course_ID], [Course_type], [Course_price], [Course_usage_limit], [Course_day_of_week]
from [Course_Temp] 

End


Exec Course_Fill_Dim

select * from [dbo].[Dim_Course]
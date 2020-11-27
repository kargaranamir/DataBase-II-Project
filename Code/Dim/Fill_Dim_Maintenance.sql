CREATE TABLE [dbo].[Maintenance_Temp](
	[Main_ID] [int] NOT NULL,
	[Main_type] [int] NOT NULL)

Create PROCEDURE Maintenance_Fill_Dim AS
begin

truncate table [dbo].[Maintenance_Temp]

INSERT INTO [Maintenance_Temp] ([Main_ID], [Main_type])
SELECT ISnull(t1.[Main_ID],t2.[Main_ID]), ISnull(t1.[Main_type],t2.[Main_type])
FROM [Gym].[dbo].[Tran_Maintenance] as t1
full outer join [dbo].[Dim_Maintenance] as t2
on (t1.[Main_ID]=t2.[Main_ID])


truncate  table [dbo].[Dim_Maintenance]

INSERT INTO [dbo].[Dim_Maintenance] ([Main_ID], [Main_type])
select [Main_ID], [Main_type]
from [Maintenance_Temp]

End


EXEC Maintenance_Fill_Dim

select * from [dbo].[Dim_Maintenance]
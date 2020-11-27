CREATE TABLE [dbo].[Equipment_Temp](
	[Equip_ID] [int] NOT NULL,
	[Equip_model] [varchar](50) NOT NULL,
	[Equip_serial] [varchar](50) NOT NULL,
	[Equip_status] [int] NOT NULL)



Create PROCEDURE Equipment_Fill_Dim
AS
Begin

truncate table [dbo].[Equipment_Temp]

INSERT INTO [Equipment_Temp] ([Equip_ID], [Equip_model], [Equip_serial], [Equip_status])
SELECT ISnull(t1.[Equip_ID],t2.[Equip_ID]), ISnull(t1.[Equip_model],t2.[Equip_model]), ISnull(t1.[Equip_serial],t2.[Equip_serial]), ISnull(t1.[Equip_status],t2.[Equip_status])
FROM [Gym].[dbo].[Mas_Equipment] as t1
full outer join [dbo].[Dim_Equipment] as t2
on (t1.[Equip_ID]=t2.[Equip_ID])

Truncate table [dbo].[Dim_Equipment]

INSERT INTO [dbo].[Dim_Equipment] ([Equip_ID], [Equip_model], [Equip_serial], [Equip_status])
select [Equip_ID], [Equip_model], [Equip_serial], [Equip_status]
from [Equipment_Temp] 

End

EXEC Equipment_Fill_Dim

select * from [dbo].[Dim_Equipment]
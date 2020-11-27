CREATE TABLE [dbo].[Relation_Temp](
	[Rel_ID] [int] NOT NULL,
	[Relation_describing] [varchar](50) NOT NULL)

Create PROCEDURE Relation_Fill_Dim AS
begin

truncate table [Relation_Temp]

INSERT INTO [Relation_Temp] ([Rel_ID], [Relation_describing])
SELECT ISnull(t1.[Rel_ID],t2.[Rel_ID]), ISnull(t1.[Relation_describing],t2.[Relation_describing])
FROM [Gym].dbo.[Relation] as t1
full outer join [dbo].[Dim_Relation] as t2
on (t1.[Rel_ID]=t2.[Rel_ID])

truncate table [dbo].[Dim_Relation]

INSERT INTO [dbo].[Dim_Relation] ([Rel_ID], [Relation_describing])
select [Rel_ID], [Relation_describing]
from [Relation_Temp]

end

EXEC Relation_Fill_Dim

select * from [Dim_Relation]
CREATE TABLE Branch_Temp (
	[Surrogate_key] [int],
	[Branch_ID] [int] NOT NULL,
	[Branch_address] [varchar](50) NOT NULL,
	[Branch_province] [varchar](50) NOT NULL,
	[Branch_region] [varchar](50) NOT NULL,
	[Branch_phone] [varchar](50) NOT NULL,
	[Start_Date] [date],
	[End_Date][date],
	[Flag][binary]
	);

Create PROCEDURE Branch_Fill_Dim AS
begin

Truncate table Branch_Temp

INSERT INTO Branch_Temp ([Branch_ID], [Branch_address], [Branch_province], [Branch_region], [Branch_phone],[Start_Date],[End_Date],[Flag])
SELECT ISnull(t1.[Branch_ID],t2.[Branch_ID]), ISnull(t2.[Branch_address],t1.[Branch_address]), ISnull(t1.[Branch_province],t2.[Branch_province]), ISnull(t1.[Branch_region],t2.[Branch_region]), ISnull(t1.[Branch_phone],t2.[Branch_phone]),
case 
	when t2.[Branch_ID] <> NULL then t2.[Start_Date]
	else GETDATE()
end,
case 
	when t2.[Branch_ID] is NULL then NULL
	when isnull(t2.[Branch_address],'0') <> t1.[Branch_address] and t2.[Flag] = 1 then GETDATE()
	else t2.[End_Date]
end,
case 
	when t2.[Branch_ID] is NULL then 1
	when isnull(t2.[Branch_address],'0') <> t1.[Branch_address] and t2.[Flag] = 1 then 0
	else t2.[Flag]
end

FROM [Gym].dbo.Mas_Branch as t1
full outer join [dbo].[Dim_Branch] as t2
on (t1.[Branch_ID]=t2.[Branch_ID])


INSERT INTO Branch_Temp ([Branch_ID], [Branch_address], [Branch_province], [Branch_region], [Branch_phone],[Start_Date],[End_Date],[Flag])
SELECT t1.[Branch_ID], t1.[Branch_address], t1.[Branch_province], t1.[Branch_region], t1.[Branch_phone], GETDATE(), NULL, 1
FROM [Gym].dbo.Mas_Branch as t1
inner join [dbo].[Dim_Branch] as t2
on (t1.[Branch_ID]=t2.[Branch_ID])
where t1.[Branch_address] <> t2.[Branch_address] and t2.[Flag] = 1


Truncate table [dbo].[Dim_Branch]

INSERT INTO [dbo].[Dim_Branch]([Branch_ID], [Branch_address], [Branch_province], [Branch_region], [Branch_phone],[Start_Date],[End_Date],[Flag])
SELECT [Branch_ID], [Branch_address], [Branch_province], [Branch_region], [Branch_phone],[Start_Date],[End_Date],[Flag]
FROM Branch_Temp

end


EXEC Branch_Fill_Dim

Select * From [dbo].[Dim_Branch]

UPDATE [Gym].dbo.Mas_Branch
SET [Branch_address] = '38 West Fabien St.'
WHERE [Branch_ID] = 1;


create table [Date_Temp](
 [Date_ID] [int],
 [Year] [int],
 [Month] [int],
 [Day] [int]
);


ALTER procedure Date_Fill_Dim
as begin

DECLARE @minDate date; declare @maxDate date; declare @tempMax date;
SET @minDate = '2015-01-01'
SET @maxDate = '2020-01-01'

--set @minDate= (select cast(min() as date) from )
--set @maxDate= (select cast(max()as date) from )
--set @tempMax=(select cast(max()as date) from )

	--IF @tempMax is not null
	--BEGIN
	--	IF @tempMax > @minDate
	--	BEGIN
	--		set @tempMax = DATEADD(DAY, 1, @tempMax);
	--			SET @minDate=@tempMax
	--	END
	--END

truncate table [Date_Temp]
WHILE (@minDate <= @maxDate)
BEGIN
	INSERT INTO [Date_Temp]([Date_ID], [Year], [Month], [Day])
        SELECT DateKey = YEAR(@minDate) * 10000 + MONTH(@minDate) * 100 + DAY(@minDate),
          [year] = YEAR(@minDate),
          [Month] = MONTH(@minDate),
		  [Day]= DAY(@minDate)

SET @minDate = DATEADD(DAY, 1, @minDate);
END
truncate table [Dim_Date]
INSERT INTO [Dim_Date]([Date_ID], [Year], [Month], [Day])
Select [Date_ID], [Year], [Month], [Day]
From [Date_Temp]
END

EXEC Date_Fill_Dim

select * From [Dim_Date]
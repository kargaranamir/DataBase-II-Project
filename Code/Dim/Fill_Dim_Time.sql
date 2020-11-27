create table [Time_Temp](
 [Time_ID] [int],
 [Hour] [int],
 [minute] [int],
 [second] [int],
);

Create procedure Time_Fill_Dim
as begin

DECLARE @minTime time; declare @maxTime time;
SET @minTime = CAST('00:00:00' as time);
SET @maxTime = CAST('23:59:59' as time);

truncate table [Time_Temp]

WHILE (@minTime < @maxTime)
BEGIN
	INSERT INTO [Time_Temp]([Time_ID], [Hour], [minute], [second])
        SELECT DateKey = DATEPART(hour,@minTime) * 10000 + DATEPART(minute,@minTime) * 100 + DATEPART(second,@minTime),
          [Hour] = DATEPART(hour,@minTime),
          [minute] = DATEPART(minute, @minTime),
		  [second]= DATEPART(second,@minTime)

SET @minTime = DATEADD(second, 1, @minTime);
END
INSERT INTO [Time_Temp]([Time_ID], [Hour], [minute], [second]) VALUES (235959,23,59,59)

truncate table [Dim_Time]
INSERT INTO [Dim_Time]([Time_ID], [Hour], [minute], [second])
Select [Time_ID], [Hour], [minute], [second]
from [Time_Temp]

END

Exec Time_Fill_Dim

select * from [Dim_Time]

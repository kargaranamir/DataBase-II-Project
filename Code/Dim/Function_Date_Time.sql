ALTER FUNCTION DatetoKey (@Date Date)
returns int
as begin
declare @K int = (DATEpart(year,@Date) * 10000) + (DATEpart(month,@Date) * 100) + DATEpart(day,@Date)
 return @K
end

CREATE FUNCTION TimetoKey (@Time time)
returns int
as begin
declare @K int = (DATEpart(hour,@Time) * 10000) + (DATEpart(MINUTE,@Time) * 100) + DATEpart(second,@Time)
return @K
end


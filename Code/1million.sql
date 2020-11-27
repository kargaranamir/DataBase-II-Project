CREATE TABLE [dbo].[Temp_Mi](
	[Usage_ID] [int] NOT NULL identity(1,1),
	[Cust_ID] [int] NOT NULL,
	[Course_ID] [int] NOT NULL,
	[Usage_date] [date] NOT NULL,
	[Usage_time] [time](7) NOT NULL,
	[Branch_ID] [int] NOT NULL)

declare @i int
set @i = 0
while (@i<1000)
begin

insert into [Temp_Mi] 
select [Cust_ID],[Course_ID],Dateadd(day,@i,[Usage_date]),[Usage_time],[Branch_ID]
from [dbo].[Tran_Usage_Record]

set @i =@i+1
end

truncate table [dbo].[Temp_Mi]
select * from [dbo].[Temp_Mi]

insert into [dbo].[Tran_Usage_Record]
select * 
From [Temp_Mi]


truncate table [dbo].[Tran_Usage_Record]

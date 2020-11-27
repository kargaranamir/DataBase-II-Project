ALTER TABLE [dbo].[Mas_Customer]
    ADD [Cust_introducer] INTEGER,
    FOREIGN KEY([Cust_introducer]) REFERENCES [dbo].[Mas_Customer]([Cust_ID]);

--select * From [dbo].[Mas_Customer]

--UPDATE [dbo].[Mas_Customer]
--SET [Cust_introducer] = 1
--WHERE [Cust_ID] % 3 = 1;

--UPDATE [dbo].[Mas_Customer]
--SET [Cust_introducer] = 2
--WHERE [Cust_ID] % 3 = 0;

--UPDATE [dbo].[Mas_Customer]
--SET [Cust_introducer] = null
--WHERE [Cust_ID]  = 3;
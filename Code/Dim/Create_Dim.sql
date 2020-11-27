CREATE TABLE [dbo].[Dim_Customer](
	[Cust_ID] [int] NOT NULL PRIMARY KEY,
	[Cust_fname] [varchar](50) NOT NULL,
	[Cust_lname] [varchar](50) NOT NULL,
	[Cust_gender] [varchar](50) NOT NULL,
	[Cust_birthdate] [date] NOT NULL,
	[Cust_membership] [varchar](50) NOT NULL,
	[Cust_email] [varchar](50) NULL,
	[Cust_mobile] [varchar](50) NULL,
	[Cust_mobile_2] [varchar](50) NULL,
	[Eff_Date] [date],
	[Cust_registerdate] [date] NOT NULL)

CREATE TABLE [dbo].[Dim_Branch](
	[Surrogate_key] [int] NOT NULL IDENTITY(1,1) PRIMARY KEY,
	[Branch_ID] [int] NOT NULL,
	[Branch_address] [varchar](50) NOT NULL,
	[Branch_province] [varchar](50) NOT NULL,
	[Branch_region] [varchar](50) NOT NULL,
	[Branch_phone] [varchar](50) NOT NULL,
	[Start_Date] [date],
	[End_Date][date],
	[Flag][binary])

CREATE TABLE [dbo].[Dim_Course](
	[Course_ID] [int] NOT NULL PRIMARY KEY,
	[Course_type] [int] NOT NULL,
	[Course_price] [int] NOT NULL,
	[Course_usage_limit] [int] NULL,
	[Course_day_of_week] [int] NULL)


CREATE TABLE [dbo].[Dim_Equipment](
	[Equip_ID] [int] NOT NULL PRIMARY KEY,
	[Equip_model] [varchar](50) NOT NULL,
	[Equip_serial] [varchar](50) NOT NULL,
	[Equip_status] [int] NOT NULL)

CREATE TABLE [dbo].[Dim_Maintenance](
	[Main_ID] [int] NOT NULL PRIMARY KEY,
	[Main_type] [int] NOT NULL)

CREATE TABLE [dbo].[Dim_Relation](
	[Rel_ID] [int] NOT NULL PRIMARY KEY,
	[Relation_describing] [varchar](50) NOT NULL)


create table [Dim_Date](
 [Date_ID] [int] PRIMARY KEY,
 [Year] [int],
 [Month] [int],
 [Day] [int]
);

create table [Dim_Time](
 [Time_ID] [int] PRIMARY KEY,
 [Hour] [int],
 [minute] [int],
 [second] [int],
);



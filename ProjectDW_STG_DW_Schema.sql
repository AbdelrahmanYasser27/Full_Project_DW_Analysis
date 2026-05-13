
use master;
-- Drop and recreate the database
IF EXISTS (SELECT name FROM sys.databases WHERE name = N'ProjectDW')
    DROP DATABASE ProjectDW;
GO

create database ProjectDW;
go


select * from DW.factPayment

go

create schema DW;
go

create schema STG;
go

create table [STG].products(	
	productCode        varchar(15) ,    
    productName        varchar(70),
    productLine        varchar(50),    
    productScale       varchar(10),    
    productVendor      varchar(50),    
    productDescription nvarchar(max), 
	buyPrice		   decimal(10,2), 
    MSRP               decimal(10,2), 
	Last_updated	datetime ,
	create_timestamp  datetime 
);
go

create table [STG].offices(
	officeCode   varchar(10) ,
    city         varchar(50) ,
    phone        varchar(50) ,
    state        varchar(50) ,
    country      varchar(50) ,
    postalCode   varchar(15) ,
    territory    varchar(10) ,
	Last_updated	datetime ,
	create_timestamp  datetime 
);

create table [STG].employees(
	employeeNumber int    ,
    firstName       varchar(50),
    lastName      varchar(50),
	officeCode   varchar(10),
    jobTitle       varchar(50),
	reportsTo      int,
	Last_updated	datetime ,
	create_timestamp  datetime 

);
go

create table [STG].customers(
	customerNumber      int,  
    customerName		varchar(50),
    contactLastName     varchar(50),
    contactFirstName    varchar(50),
    phone               varchar(50),
    addressLine1        varchar(50),
    addressLine2        varchar(50),	
    city                varchar(50),
    state               varchar(50),
    postalCode          varchar(15),
    country             varchar(50),
    creditLimit             decimal(10,2),
	Last_updated	datetime ,
	create_timestamp  datetime 
   
);
go

create table [STG].orders( 
	orderid int  ,
    orderDate     date  ,
    requiredDate  date  ,
    shippedDate   date  ,
    status        varchar(15) ,
    comments      nvarchar(max),
	Last_updated	datetime ,
	create_timestamp  datetime
);
go
Create table [STG].factSales(
	customerid int,
	productCode  varchar(15) ,
	officeCode   varchar(10) ,
	employeeid int,
	orderlinenumber int,
	datekey int ,
	quantityOrdered int ,
    priceEach    decimal(10,2) ,
	totalRevenue decimal(15,2),
	Last_updated	datetime ,
	create_timestamp  datetime 
);
go
create table [STG].factOrder(
	customerid int,
	employeeid int,
	productCode  varchar(15) ,
	officeCode   varchar(10),
	datekey int ,
	orderNumber   int,
	orderLineNumber int,
	Last_updated	datetime ,
	create_timestamp  datetime 
);
go

CREATE table [STG].factPayment(
	customerid int,
	datekey int ,
	employeeid int,
	officeCode   varchar(10),
	checkNumber    varchar(50),
	amount decimal(15,2),
	Last_updated	datetime ,
	create_timestamp  datetime 

);
go

CREATE TABLE [DW].D_Date (
   [DateKey] [int] NOT NULL,
   [Date] [date] NOT NULL,
   [Day] [tinyint] NOT NULL,
   [DaySuffix] [char](2) NOT NULL,
   [Weekday] [tinyint] NOT NULL,
   [WeekDayName] [varchar](10) NOT NULL,
   [WeekDayName_Short] [char](3) NOT NULL,
   [WeekDayName_FirstLetter] [char](1) NOT NULL,
   [DOWInMonth] [tinyint] NOT NULL,
   [DayOfYear] [smallint] NOT NULL,
   [WeekOfMonth] [tinyint] NOT NULL,
   [WeekOfYear] [tinyint] NOT NULL,
   [Month] [tinyint] NOT NULL,
   [MonthName] [varchar](10) NOT NULL,
   [MonthName_Short] [char](3) NOT NULL,
   [MonthName_FirstLetter] [char](1) NOT NULL,
   [Quarter] [tinyint] NOT NULL,
   [QuarterName] [varchar](6) NOT NULL,
   [Year] [int] NOT NULL,
   [MMYYYY] [char](6) NOT NULL,
   [MonthYear] [char](7) NOT NULL,
   [IsWeekend] BIT NOT NULL,
   [IsHoliday] BIT NOT NULL,
   [HolidayName] VARCHAR(20) NULL,
   [SpecialDays] VARCHAR(20) NULL,
   [FinancialYear] [int] NULL,
   [FinancialQuater] [int] NULL,
   [FinancialMonth] [int] NULL,
   [FirstDateofYear] DATE NULL,
   [LastDateofYear] DATE NULL,
   [FirstDateofQuater] DATE NULL,
   [LastDateofQuater] DATE NULL,
   [FirstDateofMonth] DATE NULL,
   [LastDateofMonth] DATE NULL,
   [FirstDateofWeek] DATE NULL,
   [LastDateofWeek] DATE NULL,
   [CurrentYear] SMALLINT NULL,
   [CurrentQuater] SMALLINT NULL,
   [CurrentMonth] SMALLINT NULL,
   [CurrentWeek] SMALLINT NULL,
   [CurrentDay] SMALLINT NULL,
   PRIMARY KEY CLUSTERED ([DateKey] ASC)
);
go 

SET NOCOUNT ON

DECLARE @CurrentDate DATE = '2003-01-06'
DECLARE @EndDate DATE = '2010-12-31'

WHILE @CurrentDate < @EndDate
BEGIN
   INSERT INTO DW.D_Date (
      [DateKey],
      [Date],
      [Day],
      [DaySuffix],
      [Weekday],
      [WeekDayName],
      [WeekDayName_Short],
      [WeekDayName_FirstLetter],
      [DOWInMonth],
      [DayOfYear],
      [WeekOfMonth],
      [WeekOfYear],
      [Month],
      [MonthName],
      [MonthName_Short],
      [MonthName_FirstLetter],
      [Quarter],
      [QuarterName],
      [Year],
      [MMYYYY],
      [MonthYear],
      [IsWeekend],
      [IsHoliday],
      [FirstDateofYear],
      [LastDateofYear],
      [FirstDateofQuater],
      [LastDateofQuater],
      [FirstDateofMonth],
      [LastDateofMonth],
      [FirstDateofWeek],
      [LastDateofWeek]
      )
   SELECT DateKey = YEAR(@CurrentDate) * 10000 + MONTH(@CurrentDate) * 100 + DAY(@CurrentDate),
      DATE = @CurrentDate,
      Day = DAY(@CurrentDate),
      [DaySuffix] = CASE 
         WHEN DAY(@CurrentDate) = 1
            OR DAY(@CurrentDate) = 21
            OR DAY(@CurrentDate) = 31
            THEN 'st'
         WHEN DAY(@CurrentDate) = 2
            OR DAY(@CurrentDate) = 22
            THEN 'nd'
         WHEN DAY(@CurrentDate) = 3
            OR DAY(@CurrentDate) = 23
            THEN 'rd'
         ELSE 'th'
         END,
      WEEKDAY = DATEPART(dw, @CurrentDate),
      WeekDayName = DATENAME(dw, @CurrentDate),
      WeekDayName_Short = UPPER(LEFT(DATENAME(dw, @CurrentDate), 3)),
      WeekDayName_FirstLetter = LEFT(DATENAME(dw, @CurrentDate), 1),
      [DOWInMonth] = DAY(@CurrentDate),
      [DayOfYear] = DATENAME(dy, @CurrentDate),
      [WeekOfMonth] = DATEPART(WEEK, @CurrentDate) - DATEPART(WEEK, DATEADD(MM, DATEDIFF(MM, 0, @CurrentDate), 0)) + 1,
      [WeekOfYear] = DATEPART(wk, @CurrentDate),
      [Month] = MONTH(@CurrentDate),
      [MonthName] = DATENAME(mm, @CurrentDate),
      [MonthName_Short] = UPPER(LEFT(DATENAME(mm, @CurrentDate), 3)),
      [MonthName_FirstLetter] = LEFT(DATENAME(mm, @CurrentDate), 1),
      [Quarter] = DATEPART(q, @CurrentDate),
      [QuarterName] = CASE 
         WHEN DATENAME(qq, @CurrentDate) = 1
            THEN 'First'
         WHEN DATENAME(qq, @CurrentDate) = 2
            THEN 'second'
         WHEN DATENAME(qq, @CurrentDate) = 3
            THEN 'third'
         WHEN DATENAME(qq, @CurrentDate) = 4
            THEN 'fourth'
         END,
      [Year] = YEAR(@CurrentDate),
      [MMYYYY] = RIGHT('0' + CAST(MONTH(@CurrentDate) AS VARCHAR(2)), 2) + CAST(YEAR(@CurrentDate) AS VARCHAR(4)),
      [MonthYear] = CAST(YEAR(@CurrentDate) AS VARCHAR(4)) + UPPER(LEFT(DATENAME(mm, @CurrentDate), 3)),
      [IsWeekend] = CASE 
         WHEN DATENAME(dw, @CurrentDate) = 'Sunday'
            OR DATENAME(dw, @CurrentDate) = 'Saturday'
            THEN 1
         ELSE 0
         END,
      [IsHoliday] = 0,
      [FirstDateofYear] = CAST(CAST(YEAR(@CurrentDate) AS VARCHAR(4)) + '-01-01' AS DATE),
      [LastDateofYear] = CAST(CAST(YEAR(@CurrentDate) AS VARCHAR(4)) + '-12-31' AS DATE),
      [FirstDateofQuater] = DATEADD(qq, DATEDIFF(qq, 0, GETDATE()), 0),
      [LastDateofQuater] = DATEADD(dd, - 1, DATEADD(qq, DATEDIFF(qq, 0, GETDATE()) + 1, 0)),
      [FirstDateofMonth] = CAST(CAST(YEAR(@CurrentDate) AS VARCHAR(4)) + '-' + CAST(MONTH(@CurrentDate) AS VARCHAR(2)) + '-01' AS DATE),
      [LastDateofMonth] = EOMONTH(@CurrentDate),
      [FirstDateofWeek] = DATEADD(dd, - (DATEPART(dw, @CurrentDate) - 1), @CurrentDate),
      [LastDateofWeek] = DATEADD(dd, 7 - (DATEPART(dw, @CurrentDate)), @CurrentDate)

   SET @CurrentDate = DATEADD(DD, 1, @CurrentDate)
END

--Update Holiday information
UPDATE DW.D_Date
SET [IsHoliday] = 1,
   [HolidayName] = 'Christmas'
WHERE [Month] = 12
   AND [DAY] = 25

UPDATE DW.D_Date
SET SpecialDays = 'Valentines Day'
WHERE [Month] = 2
   AND [DAY] = 14

--Update current date information
UPDATE DW.D_Date
SET CurrentYear = DATEDIFF(yy, GETDATE(), DATE),
    CurrentQuater = DATEDIFF(q, GETDATE(), DATE),
    CurrentMonth = DATEDIFF(m, GETDATE(), DATE),
    CurrentWeek = DATEDIFF(ww, GETDATE(), DATE),
    CurrentDay = DATEDIFF(dd, GETDATE(), DATE);
-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
select * from dw.D_Date



create table [DW].products(	
	productKey int identity(1,1) primary key,
	productCode        varchar(15) not null ,    
    productName        varchar(70),
    productLine        varchar(50),    
    productScale       varchar(10),    
    productVendor      varchar(50),    
    productDescription nvarchar(max), 
	buyPrice		   decimal(10,2), 
    MSRP               decimal(10,2), 
	create_timestamp  datetime,
	update_timestamp datetime default '9999-12-31',
	is_last bit
);

go


create table [DW].orders( 
	orderKey int identity(1,1) primary key,
	orderid   int   ,
    orderDate     date  ,
    requiredDate  date  ,
    shippedDate   date  ,
    status        varchar(15) ,
    comments      nvarchar(max),
	create_timestamp  datetime ,
	update_timestamp datetime default  '9999-12-31',
	is_last bit
);

go
select * from DW.employees

create table [DW].offices(
	officeKey int identity(1,1) primary key,
	officeCode   varchar(10) ,
    city         varchar(50) ,
    phone        varchar(50) ,
    state        varchar(50) ,
    country      varchar(50) ,
    postalCode   varchar(15) ,
    territory    varchar(10) ,
	create_timestamp  datetime,
	update_timestamp datetime default '9999-12-31',
	is_last bit
);
go

select * from dw.offices

print getdate()


go


create table [DW].employee(
	employeeKey int identity(1,1) primary key,
	employeeNumber int    ,
    firstName       varchar(50),
    lastName      varchar(50),
    officeKey    int,
    jobTitle       varchar(50),
	reportsTo      int,
	create_timestamp  datetime,
	update_timestamp datetime default '9999-12-31',
	is_last bit
);
go
select * from  DW.Employee





create table DW.customers(
    customerKey int identity(1,1) primary key, 
	customerid int,
    customerName varchar(50),
    contactLastName varchar(50),
    contactFirstName varchar(50),
    phone varchar(50),
    addressLine1 varchar(50),
    addressLine2 varchar(50),	
    city varchar(50),
    state varchar(50),
    postalCode varchar(15),
    country varchar(50),
    creditLimit decimal(10,2),
	create_timestamp  datetime,
	update_timestamp datetime default '9999-12-31',
	is_last bit
);
go

create table [DW].factSales(
	id int identity(1,1) primary key,
	customerKey int references DW.customers(customerKey),
	productKey  int references DW.products(productKey),
	officeKey   int references DW.offices(officeKey) ,
	employeeKey int references DW.employee(employeeKey),
	orderlinenumber int, -- degenerate dim
	datekey int references DW.D_Date(DateKey) ,
	quantityOrdered int ,
    priceEach    decimal(10,2) ,
	totalRevenue decimal(15,2),
	create_timestamp  datetime 
);
go
Create table [DW].factOrder(
	id int identity(1,1) primary key,
	orderKey int references DW.orders(orderKey),
	productKey int  references DW.products(productKey),
	officeKey int  references DW.offices(officeKey),
	customerKey int references DW.customers(customerKey),
	employeeKey int references DW.employee(employeeKey),
	datekey int references DW.D_Date(DateKey) ,
	orderlineNumber   int,  -- degenerate dim
	create_timestamp  datetime 
);
go

Create table [Dw].factPayment(
	id int identity(1,1) primary key,
	customerKey int references DW.customers(customerKey),
	officeKey int  references DW.offices(officeKey),
	employeeKey int references DW.employee(employeeKey),
	datekey int references DW.D_Date(DateKey) ,
	checkNumber    varchar(50),
	amount decimal(15,2),
	create_timestamp  datetime 
);
go

SELECT * FROM STG.factPayment
SELECT * FROM DW.factOrder

create TABLE STG.Conf_Table
(
  table_name		 varchar(30),
  last_extract_date	 datetime
);

INSERT INTO STG.Conf_Table VALUES
	('Customer', '1900-01-01'),
	('orders', '1900-01-01'),
	('products', '1900-01-01'),
	('offices', '1900-01-01'),
	('employees', '1900-01-01');

INSERT INTO STG.Conf_Table VALUES
		('FactSales', '1900-01-01'),
		('FactOrder', '1900-01-01'),
		('FactPayment', '1900-01-01');



update STG.Conf_Table
SET  last_extract_date = '1900-01-01'
WHERE table_name = 'FactPayment';

select * from DW.factPayment

TRUNCATE TABLE DW.factPayment
select last_extract_date from STG.Conf_Table 
use ProjectDW
select * from stg.factPayment
select * from dw.customers
select * from classicmodels.dbo.customers


UPDATE ProjectDW.STG.Conf_Table
SET last_extract_date = COALESCE(
    (SELECT MAX(Last_updated)
     FROM ProjectDW.STG.products),
    last_extract_date
)
WHERE table_name = 'products';

select * from DW.factPayment


SELECT * FROM DW.factSales
SELECT  *  FROM DW.customers
Truncate Table  DW.factPayment

-- (DT_I4)((DT_WSTR,4)YEAR(orderDate) + RIGHT("0" + (DT_WSTR,2)MONTH(orderDate),2) + RIGHT("0" + (DT_WSTR,2)DAY(orderDate),2))


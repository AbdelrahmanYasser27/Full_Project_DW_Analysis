use ProjectDW;

--Business questions / KPIs
-- What is the total revenue over time?
	SELECT 
		SUM(FS.totalRevenue) AS Expect_Total_Revenue
		FROM  DW.factSales AS FS ;
-- Which products generate the highest revenue?
	SELECT TOP 10
		P.productName , 
		SUM(FS.totalRevenue) AS Total_Revenue
		FROM  DW.factSales AS FS INNER JOIN DW.products AS P
		ON FS.productKey = P.productKey
		GROUP BY P.productName
		ORDER BY SUM(FS.totalRevenue) DESC;

-- Which customers contribute the most revenue?
	SELECT TOP 10
		C.customerName , 
		SUM(FS.totalRevenue) AS Total_Revenue
		FROM  DW.factSales AS FS INNER JOIN DW.customers AS C
		ON FS.customerKey = C.customerKey
		GROUP BY C.customerName
		ORDER BY SUM(FS.totalRevenue) DESC;
		
	
-- Which employee drives the most sales?
	SELECT TOP 10
		(E.firstName + ' '+ E.lastName) AS 'Employee Name' , 
		SUM(FS.totalRevenue) AS Total_Revenue
		FROM  DW.factSales AS FS INNER JOIN DW.employee AS E
		ON FS.employeeKey = e.employeeKey
		GROUP BY (E.firstName + ' '+ E.lastName)
		ORDER BY SUM(FS.totalRevenue) DESC;
	
-- Which office/region performs best in sales?
	SELECT
		O.officeCode,
		SUM(FS.totalRevenue) AS Total_Revenue
		FROM  DW.factSales AS FS INNER JOIN DW.offices O
		ON FS.officeKey = O.officeKey
		GROUP BY  O.officeCode
		ORDER BY SUM(FS.totalRevenue) DESC;

	------------------------------------------------------------------------------------
	SELECT
		C.city,
		C.country,
		SUM(FS.totalRevenue) AS Total_Revenue
		FROM  DW.factSales AS FS INNER JOIN DW.customers AS C
		ON FS.customerKey = C.customerKey
		GROUP BY  C.city, C.country
		ORDER BY SUM(FS.totalRevenue) DESC;
	
-- What are the sales trends by month/year?
	SELECT 
		 D.MonthYear , 
		SUM(FS.totalRevenue) AS Total_Revenue
		FROM  DW.factSales AS FS INNER JOIN DW.D_Date AS D
		ON FS.datekey = D.DateKey
		GROUP BY D.MonthYear , D.Year,D.Month
		ORDER BY D.Year, D.Month;
	
-- Which product categories perform best?
	SELECT 
		P.productLine , 
		SUM(FS.totalRevenue) AS Total_Revenue
		FROM  DW.factSales AS FS INNER JOIN DW.products AS P
		ON FS.productKey = P.productKey
		GROUP BY P.productLine
		ORDER BY SUM(FS.totalRevenue) DESC;

-- How many orders are placed over time?
	SELECT 
		COUNT(DISTINCT  FO.orderKey) AS Total_order
		FROM DW.factOrder AS FO;
-- What is the order status distribution?
	SELECT
		O.status,
		COUNT(DISTINCT  FO.orderKey) AS Total_order
		FROM DW.factOrder AS FO INNER JOIN DW.orders O
		ON FO.orderKey = O.orderKey
		GROUP BY O.status
		ORDER BY COUNT(DISTINCT  FO.orderKey) DESC;
-- How many orders are delayed?
	SELECT
		COUNT(DISTINCT  FO.orderKey) AS Total_order
		FROM DW.factOrder AS FO INNER JOIN DW.orders O
		ON FO.orderKey = O.orderKey
		WHERE O.status  in('On Hold', 'Disputed');
-- Which customers place the most orders?
	SELECT TOP 10
		C.customerName,
		COUNT(DISTINCT  FO.orderKey) AS Total_order
		FROM DW.factOrder AS FO INNER JOIN  DW.customers AS C
		ON FO.customerKey = C.customerKey
		GROUP BY C.customerName
		ORDER BY COUNT(DISTINCT  FO.orderKey) DESC;
-- Which office handles the most orders?
	SELECT 
		E.officeKey,
		COUNT(DISTINCT  FO.orderKey) AS Total_order
		FROM DW.factOrder AS FO INNER JOIN  DW.employee AS E
		ON FO.employeeKey = E.employeeKey
		GROUP BY E.officeKey
		ORDER BY COUNT(DISTINCT  FO.orderKey) DESC;

-- How much cash is collected over time?
	SELECT 
		SUM(FP.amount) AS TotalCash  
		FROM DW.factPayment AS FP;
-- Which customers pay the most?
	-- (using Window Function ya Abdo )
	SELECT TOP 10
		ROW_NUMBER() OVER(ORDER BY SUM(FP.amount) DESC )AS 'Rank',
		C.customerName,
		SUM(FP.amount) AS TotalCash
		FROM DW.factPayment AS FP INNER JOIN DW.customers  AS C
		ON FP.customerKey = C.customerKey
		GROUP BY C.customerName;

-- How frequently do customers make payments?
	SELECT TOP 10
		C.customerName,
		COUNT(FP.id) AS countPayment
		FROM DW.factPayment AS FP INNER JOIN DW.customers  AS C
		ON FP.customerKey = C.customerKey
		GROUP BY C.customerName
		ORDER BY COUNT(FP.id) DESC;
		
-- What is the cash flow trend over time?
	SELECT 
		D.MonthYear,
		SUM(FP.amount) AS TotalCash
		FROM DW.factPayment AS FP INNER JOIN DW.D_Date AS D
		ON FP.datekey= D.DateKey
		GROUP BY D.MonthYear , D.Year,D.Month
		ORDER BY D.Year, D.Month;
	
-- How does payment timing compare to orders?
	WITH Order_Time AS(
		SELECT
			O.shippedDate,
			O.orderid
			FROM DW.factOrder AS FO INNER JOIN DW.orders AS O
			ON FO.orderKey = O.orderKey
			WHERE O.status = 'Shipped'

	), Payment_Time AS(
		SELECT 
			D.Date,
			O.orderid
			FROM DW.factPayment  AS FP INNER JOIN DW.D_Date AS D
			ON FP.datekey = D.DateKey INNER JOIN DW.customers AS C
			ON FP.customerKey = C.customerKey INNER JOIN  DW.factOrder AS FO
			ON C.customerKey = FO.customerKey  INNER JOIN DW.orders AS O
			ON FO.orderKey = O.orderKey

	)
	SELECT 
		OT.orderid,
		OT.shippedDate,
		ROW_NUMBER()OVER(PARTITION BY OT.orderid ORDER BY	PT.Date ) AS 'RANK' ,
		PT.Date AS 'Payment Date'
		FROM Order_Time AS OT INNER JOIN Payment_Time AS PT
		ON OT.orderid = PT.orderid 
		ORDER BY OT.orderid,OT.shippedDate, PT.Date



	
	



	
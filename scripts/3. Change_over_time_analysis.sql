/*
===============================================================================
Change Over Time Analysis
===============================================================================
Purpose:
    - To track trends, growth, and changes in key metrics over time.
    - For time-series analysis and identifying seasonality.
    - To measure growth or decline over specific periods.

SQL Functions Used:
    - Date Functions: DATEPART(), DATETRUNC(), FORMAT()
    - Aggregate Functions: SUM(), COUNT(), AVG()
===============================================================================
*/

-- Quick Date Functions

 SELECT	
 year(order_date) as order_year, 
 month(order_date) as order_month,
 SUM(sales_amount) as Total_Sales, 
 COUNT(DISTINCT customer_key) as total_customers, 
 SUM(Quantity) as Total_Quantity 
 FROM gold.fact_sales 
 WHERE order_date IS NOT NULL
 GROUP BY YEAR(order_date),month(order_date)
 ORDER BY YEAR(order_date),month(order_date);

 -- DATETRUNC()

  SELECT	
 DATETRUNC(YEAR,order_date) as order_year,
 SUM(sales_amount) as Total_Sales, 
 COUNT(DISTINCT customer_key) as total_customers, 
 SUM(Quantity) as Total_Quantity 
 FROM gold.fact_sales 
 WHERE order_date IS NOT NULL
 GROUP BY DATETRUNC(YEAR,order_date)
 ORDER BY DATETRUNC(YEAR,order_date);

 -- FORMAT()

  SELECT	
 FORMAT(order_date,'yyyy-MMM') as order_date,
 SUM(sales_amount) as Total_Sales, 
 COUNT(DISTINCT customer_key) as total_customers, 
 SUM(Quantity) as Total_Quantity 
 FROM gold.fact_sales 
 WHERE order_date IS NOT NULL
 GROUP BY FORMAT(order_date,'yyyy-MMM')
 ORDER BY FORMAT(order_date,'yyyy-MMM');
/*
===============================================================================
Performance Analysis (Year-over-Year, Month-over-Month)
===============================================================================
Purpose:
    - To measure the performance of products, customers, or regions over time.
    - For benchmarking and identifying high-performing entities.
    - To track yearly trends and growth.

SQL Functions Used:
    - LAG(): Accesses data from previous rows.
    - AVG() OVER(): Computes average values within partitions.
    - CASE: Defines conditional logic for trend analysis.
===============================================================================
*/

-- 3. PERFORMANCE ANALYSIS (Current[Measure] - Target[Measure])
-- current sales - avg sales
-- current yr sales - Previous yr sales (yoy analysis)
-- current sales - lowest sales


/* Analyze the yearly performance of products by comparing their sales to both 
the average sales performance of the product and the previous year's sales */

--2 avg performance
 WITH yearly_product_sales AS(
SELECT 
YEAR(f.order_date) order_year,
p.product_name,
sum(f.sales_amount) current_sales
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
WHERE order_date IS NOT NULL
GROUP BY YEAR(f.order_date),p.product_name)

SELECT *,
AVG(current_sales) OVER(PARTITION BY product_name) AS avg_sales,
current_sales - AVG(current_sales) OVER(PARTITION BY product_name) AS diff_avg,
CASE WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) > 0 THEN 'Above Avg'
     WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) < 0 THEN 'Below Avg'
     ELSE 'avg'
END avg_change
FROM yearly_product_sales
ORDER BY product_name,order_year;

--3. Previous yr( yoy performance)

WITH yearly_product_sales AS(
SELECT 
YEAR(f.order_date) order_year,
p.product_name,
sum(f.sales_amount) current_sales
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
WHERE order_date IS NOT NULL
GROUP BY YEAR(f.order_date),p.product_name)

SELECT *,
AVG(current_sales) OVER(PARTITION BY product_name) AS avg_sales,
current_sales - AVG(current_sales) OVER(PARTITION BY product_name) AS diff_avg,
CASE WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) > 0 THEN 'Above Avg'
     WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) < 0 THEN 'Below Avg'
     ELSE 'avg'
END avg_change,
-- Year-over-year Analysis 
LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) py_sales,
current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS diff_py,
CASE WHEN current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Increase'
     WHEN current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decrease'
     ELSE 'No change'
END py_change
FROM yearly_product_sales
ORDER BY product_name,order_year;
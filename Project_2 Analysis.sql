----- Customer analysis (1)--Customers distribution by age group

SELECT 
    CASE 
        WHEN EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthday)) < 18 THEN '<18'
        WHEN EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthday)) BETWEEN 18 AND 25 THEN '18-25'
        WHEN EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthday)) BETWEEN 26 AND 35 THEN '26-35'
        WHEN EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthday)) BETWEEN 36 AND 45 THEN '36-45'
        WHEN EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthday)) BETWEEN 46 AND 60 THEN '46-55'
        ELSE '>60'
    END AS age_group,
    COUNT(*) AS customer_count
FROM customers
GROUP BY age_group
ORDER BY age_group;

Customer analysis (2) --- Gender distribution
SELECT gender,
    COUNT(*) AS customer_count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM customers
GROUP BY gender
ORDER BY customer_count DESC;

----Customers Analysis (3) --- Location distribution
SELECT country, state_Code, city,
COUNT(*) AS customer_count
FROM customers
GROUP BY country, state_Code, city
ORDER BY customer_count DESC;

----Product Analysis (1)----profit_margins by products
Select product_name,
SUM(CAST((unit_price_usd - unit_cost_usd) * quantity AS NUMERIC(10, 2))) AS profit_margin
from df1_overall
group by product_name
order by Profit_Margin desc
limit 10;

----Product Analysis(2) ----- Top10 frequency of products
select distinct(product_name),sum(quantity) as Quantity
from df1_overall
group by product_name
order by Quantity desc
limit 10;

-------Product Analysis (3)---Category and Subcategory analysis
SELECT category,subcategory,
CAST(SUM(unit_price_usd * quantity) AS DECIMAL(10, 2)) AS total_Sales
FROM df1_overall
GROUP BY category,subcategory
ORDER BY total_sales DESC
Limit 10;

----Sales Analysis(1) --- Sales Revenue by Category
SELECT category,
CAST(SUM(unit_price_usd * quantity) AS DECIMAL(10, 2)) AS Total_Sales_Revenue
FROM  overall
GROUP BY category
ORDER BY Total_Sales_Revenue DESC;

-----Sales Analysis(2) ----Sales by Country
SELECT  country,
CAST(SUM(unit_price_usd * quantity) AS DECIMAL(10, 2)) AS Total_Sales_Revenue
FROM  overall
GROUP BY country
ORDER BY  Total_Sales_Revenue DESC;

----Sales Analysis (3) ---- TOtal order value by month
SELECT 
    TO_CHAR(order_date, 'YYYY-MM') AS Order_Month,
    COUNT(order_number) AS Total_Orders,
    CAST(SUM(unit_price_usd * Quantity) AS DECIMAL(10, 2)) AS Total_Order_Value  
FROM overall1
GROUP BY 
    TO_CHAR(order_date, 'YYYY-MM')
ORDER BY  
    Total_Order_Value DESC
	Limit 10;

-----Store Analysis(1) ---Store size by total sales
 SELECT 
    CASE
        WHEN square_meters < 250 THEN '<250'
        WHEN square_meters BETWEEN 250 AND 500 THEN '250 to 500'
        WHEN square_meters BETWEEN 501 AND 750 THEN '500 to 750'
        WHEN square_meters BETWEEN 751 AND 1000 THEN '750 to 1000'
        WHEN square_meters BETWEEN 1001 AND 1250 THEN '1000 to 1250'
        WHEN square_meters BETWEEN 1251 AND 1500 THEN '1250 to 1500'
        WHEN square_meters BETWEEN 1501 AND 1750 THEN '1500 to 1750'
        WHEN square_meters BETWEEN 1751 AND 2000 THEN '1750 to 2000'
        WHEN square_meters > 2000 THEN '>2000'
    END AS size_bucket,
    ROUND(CAST(SUM(unit_price_usd * quantity) AS NUMERIC), 2) AS total_sales
FROM df1_overall
GROUP BY 
    CASE
        WHEN square_meters < 250 THEN '<250'
        WHEN square_meters BETWEEN 250 AND 500 THEN '250 to 500'
        WHEN square_meters BETWEEN 501 AND 750 THEN '500 to 750'
        WHEN square_meters BETWEEN 751 AND 1000 THEN '750 to 1000'
        WHEN square_meters BETWEEN 1001 AND 1250 THEN '1000 to 1250'
        WHEN square_meters BETWEEN 1251 AND 1500 THEN '1250 to 1500'
        WHEN square_meters BETWEEN 1501 AND 1750 THEN '1500 to 1750'
        WHEN square_meters BETWEEN 1751 AND 2000 THEN '1750 to 2000'
        WHEN square_meters > 2000 THEN '>2000'
    END
ORDER BY total_sales, size_bucket DESC;

-Store Analysis(2) ---Total revenue accordance with storekey,Country,Continent,State
SELECT storekey,Country,Continent,State, Square_meters,
ROUND(CAST(SUM(unit_price_usd * quantity) AS NUMERIC), 2) AS total_Revenue
FROM df1_overall
GROUP BY storekey,Country,Continent,State, Square_meters
order by total_Revenue desc;

Drop Table overall1;
Drop Table df_overall;
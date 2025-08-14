CREATE table walmart_sales(
	Customer_ID VARCHAR(50),
    Age INT,
    Gender VARCHAR(10),
    City VARCHAR(100),
    Category VARCHAR(50),
    Product_Name VARCHAR(100),
    Purchase_Date DATE,
    Purchase_Amount DECIMAL(10,2),
    Payment_Method VARCHAR(50),
    Discount_Applied VARCHAR(5),
    Rating INT,
    Repeat_Customer VARCHAR(5)
);

-- 1. Customer
-- Which age group spends the most

SELECT 
	CASE
		WHEN Age < 18 THEN 'UNDER 18'
        WHEN Age BETWEEN 18 AND 24 THEN '18 - 24'
        WHEN Age BETWEEN 25 AND 34 THEN '25 - 34'
        WHEN Age BETWEEN 35 AND 44 THEN '35 - 44'
        WHEN Age BETWEEN 45 AND 54 THEN '45 - 54'
        WHEN Age BETWEEN 55 AND 64 THEN '55 - 64'
        ELSE '65+'
	END AS Age_Group,
    SUM(Purchase_Amount) AS Total_Spend
FROM walmart_sales
group by Age_group
order by Total_Spend DESC;

SELECT Gender, SUM(Purchase_Amount) AS Total_Spend
FROM walmart_sales
group by Gender
order by Total_Spend DESC;

select City, SUM(Purchase_Amount) AS Total_Revenue
from walmart_sales
group by City
order by Total_Revenue DESC;

SELECT City,
	CASE
		WHEN Age < 18 THEN 'UNDER 18'
        WHEN Age BETWEEN 18 AND 24 THEN '18 - 24'
        WHEN Age BETWEEN 25 AND 34 THEN '25 - 34'
        WHEN Age BETWEEN 35 AND 44 THEN '35 - 44'
        WHEN Age BETWEEN 45 AND 54 THEN '45 - 54'
        WHEN Age BETWEEN 55 AND 64 THEN '55 - 64'
        ELSE '65+'
	END AS Age_Group,
    Gender,
    Count(*) AS Customer_Count
FROM walmart_sales
group by City, Age_group, Gender
order by City, Customer_Count DESC;

SELECT City, Repeat_Customer, COUNT(*) AS Count
FROM walmart_sales
GROUP BY City, Repeat_Customer
ORDER BY City, Count DESC;

SELECT Category, SUM(Purchase_Amount) AS Total_Revenue
FROM walmart_sales
GROUP BY Category
ORDER BY Total_Revenue DESC;

-- By volume
SELECT Product_Name, Category, COUNT(*) AS Units_Sold, SUM(Purchase_Amount) AS Revenue
FROM walmart_sales
GROUP BY Product_Name, Category
ORDER BY Units_Sold DESC;

-- By revenue
SELECT Product_Name, Category, SUM(Purchase_Amount) AS Revenue, COUNT(*) AS Units_Sold
FROM walmart_sales
GROUP BY Product_Name, Category
ORDER BY Revenue DESC;

SELECT Product_Name, Category, COUNT(*) AS Units_Sold, SUM(Purchase_Amount) AS Revenue, AVG(Rating) AS Avg_Rating
FROM walmart_sales
GROUP BY Product_Name, Category
HAVING AVG(Rating) < 3.5
ORDER BY Revenue DESC;

SELECT City, Product_Name, SUM(Purchase_Amount) AS Revenue, COUNT(*) AS Units_Sold
FROM walmart_sales
GROUP BY City, Product_Name
ORDER BY City, Revenue DESC;

SELECT Gender,
       CASE 
            WHEN Age < 18 THEN 'Under 18'
            WHEN Age BETWEEN 18 AND 24 THEN '18-24'
            WHEN Age BETWEEN 25 AND 34 THEN '25-34'
            WHEN Age BETWEEN 35 AND 44 THEN '35-44'
            WHEN Age BETWEEN 45 AND 54 THEN '45-54'
            WHEN Age BETWEEN 55 AND 64 THEN '55-64'
            ELSE '65+' 
        END AS Age_Group,
       Product_Name,
       SUM(Purchase_Amount) AS Revenue,
       COUNT(*) AS Units_Sold
FROM walmart_sales
GROUP BY Gender, Age_Group, Product_Name
ORDER BY Gender, Age_Group, Revenue DESC;


SELECT Discount_Applied, AVG(Purchase_Amount) AS Avg_Purchase
FROM walmart_sales
GROUP BY Discount_Applied;

SELECT Category, Repeat_Customer, COUNT(*) AS Count
FROM walmart_sales
GROUP BY Category, Repeat_Customer
ORDER BY Category, Repeat_Customer;


SELECT Repeat_Customer, SUM(Purchase_Amount) AS Total_Revenue
FROM walmart_sales
GROUP BY Repeat_Customer;

SELECT Payment_Method, COUNT(*) AS Count, SUM(Purchase_Amount) AS Revenue
FROM walmart_sales
GROUP BY Payment_Method
ORDER BY Count DESC;

SELECT Payment_Method, Category, Gender, COUNT(*) AS Count, SUM(Purchase_Amount) AS Revenue
FROM walmart_sales
GROUP BY Payment_Method, Category, Gender
ORDER BY Revenue DESC;

SELECT Payment_Method, AVG(Purchase_Amount) AS Avg_Purchase
FROM walmart_sales
GROUP BY Payment_Method
ORDER BY Avg_Purchase DESC;


-- Add month and weekday for grouping
SELECT MONTH(Purchase_Date) AS Month, SUM(Purchase_Amount) AS Revenue
FROM walmart_sales
GROUP BY Month
ORDER BY Revenue DESC;
--  revenue on which day of the week 
SELECT DAYOFWEEK(Purchase_Date) AS Weekday, SUM(Purchase_Amount) AS Revenue
FROM walmart_sales
GROUP BY Weekday
ORDER BY Revenue DESC;

-- Month-wise revenue for each category 
SELECT Category, MONTH(Purchase_Date) AS Month, SUM(Purchase_Amount) AS Revenue
FROM walmart_sales
GROUP BY Category, Month
ORDER BY Category, Month;

-- Category-wise highest revenue month
WITH MonthlyRevenue AS (
    SELECT 
        Category,
        MONTH(Purchase_Date) AS Month,
        SUM(Purchase_Amount) AS Revenue,
        ROW_NUMBER() OVER (PARTITION BY Category ORDER BY SUM(Purchase_Amount) DESC) AS rn
    FROM walmart_sales
    GROUP BY Category, MONTH(Purchase_Date)
)
SELECT Category, Month, Revenue
FROM MonthlyRevenue
WHERE rn = 1
ORDER BY Category;


SELECT distinct category from walmart_sales;
SELECT distinct month(Purchase_Date) as month from walmart_sales order by month;
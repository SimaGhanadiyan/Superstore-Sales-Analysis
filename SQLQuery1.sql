-- Data Cleaning part


-- check the first 5 rows to make sure it imported well
SELECT TOP(5) *
FROM Superstore

--Analyze: Answer our business objectives

--1. What are total sales and total profits of each year?
SELECT Year(OrderDate) AS years,SUM(Sales) AS total_sales,SUM(Profit) AS total_profit
FROM Superstore
GROUP BY YEAR(OrderDate)
ORDER BY YEAR(OrderDate) ASC

--2. What are the total profits and total sales per quarter?
SELECT YEAR(OrderDate) AS years,
       CASE 
           WHEN MONTH(OrderDate) IN (1,2,3) THEN 'Q1'
	       WHEN MONTH(OrderDate) IN (4,5,6) THEN 'Q2'
	       WHEN MONTH(OrderDate) IN (7,8,9) THEN 'Q3'
	       ELSE 'Q4'
       END AS quarters,
       SUM(Sales) AS total_sale,
       SUM(Profit) AS total_profit
FROM Superstore
GROUP BY YEAR(OrderDate),
         CASE
             WHEN MONTH(OrderDate) IN (1, 2, 3) THEN 'Q1'
             WHEN MONTH(OrderDate) IN (4, 5, 6) THEN 'Q2'
             WHEN MONTH(OrderDate) IN (7, 8, 9) THEN 'Q3'
             ELSE 'Q4'
         END
ORDER BY years, quarters;

--3. What region generates the highest sales and profits ?
SELECT Region,SUM(Sales) AS total_sales,SUM(Profit) AS total_profit
FROM Superstore
GROUP BY Region
ORDER BY total_profit DESC


--each regions profit margins for further analysis
SELECT Region, ROUND((SUM(Sales) / NULLIF(SUM(Profit), 0)) * 100, 2) AS profit_margin
FROM Superstore
GROUP BY Region
ORDER BY profit_margin DESC

--4. What state and city brings in the highest sales and profits ?

--States
SELECT TOP 10 State,
       SUM(Sales) AS total_sales,
       SUM(Profit) AS total_profit,
       ROUND((SUM(Sales) / NULLIF(SUM(Profit), 0)) * 100, 2) AS profit_margin
FROM Superstore
GROUP BY State
ORDER BY total_profit DESC;

--city
SELECT TOP 10 City,
       SUM(Sales) AS total_sales,
       SUM(Profit) AS total_profit,
       ROUND((SUM(Sales) / NULLIF(SUM(Profit), 0)) * 100, 2) AS profit_margin
FROM Superstore
GROUP BY City
ORDER BY total_profit DESC;

--5.The relationship between discount and sales and the total discount per category

--correlation between discount and average sales to understand how impactful one is to the other.
SELECT Discount, AVG(Sales) AS Avg_Sales 
FROM superstore
GROUP BY Discount
ORDER BY Discount;

--observe the total discount per product category
SELECT Category,SUM(Discount) AS total_discount
FROM superstore
GROUP BY Category 
ORDER BY total_discount DESC;

--category section to see exactly what type of products are the most discounted.
SELECT Category,SubCategory,SUM(Discount) AS total_discount
FROM Superstore
GROUP BY Category,SubCategory
ORDER BY total_discount DESC;

--6. What category generates the highest sales and profits in each region and state ?
SELECT Category,SUM(Sales) AS total_sales,SUM(Profit) AS total_profit
FROM Superstore
GROUP BY Category
ORDER BY total_profit DESC;

--the highest total sales and total profits per Category in each region:
SELECT Region,Category,SUM(Sales) AS total_sales,SUM(Profit) AS total_profit
FROM Superstore
GROUP BY Region,Category
ORDER BY total_profit DESC;

--see the highest total sales and total profits per Category in each state:
SELECT state, category, SUM(sales) AS total_sales, SUM(profit) AS total_profit 
FROM superstore 
GROUP BY state, category 
ORDER BY total_profit DESC;

--7. What subcategory generates the highest sales and profits in each region and state ?

--total sales and total profits of each subcategory with their profit margins:
SELECT subcategory, SUM(sales) AS total_sales, SUM(profit) AS total_profit, ROUND(SUM(profit)/SUM(sales)*100, 2) AS profit_marg 
FROM superstore
GROUP BY subcategory 
ORDER BY total_profit DESC;

-- highest total sales and total profits per subcategory in each region:
SELECT region, subcategory, SUM(sales) AS total_sales, SUM(profit) AS total_profit 
FROM superstore 
GROUP BY region, subcategory 
ORDER BY total_profit DESC

--see the least performing ones:
SELECT region, subcategory, SUM(sales) AS total_sales, SUM(profit) AS total_profit 
FROM superstore 
GROUP BY region, subcategory 
ORDER BY total_profit ASC;

-- highest total sales and total profits per subcategory in each state
SELECT state, subcategory, SUM(sales) AS total_sales, SUM(profit) AS total_profit 
FROM superstore 
GROUP BY state, subcategory 
ORDER BY total_profit DESC

--lowest sales and profits. Still in order for biggest lost in profits.
SELECT state, subcategory, SUM(sales) AS total_sales, SUM(profit) AS total_profit 
FROM superstore 
GROUP BY state, subcategory 
ORDER BY total_profit ASC;

--8. What are the names of the products that are the most and least profitable to us?
SELECT ProductName,SUM(sales) AS total_sales, SUM(profit) AS total_profit
FROM Superstore
GROUP BY ProductName
ORDER BY total_profit DESC

--
SELECT ProductName,SUM(sales) AS total_sales, SUM(profit) AS total_profit
FROM Superstore
GROUP BY ProductName
ORDER BY total_profit ASC

--9. What segment makes the most of our profits and sales ?
SELECT Segment,SUM(sales) AS total_sales, SUM(profit) AS total_profit
FROM Superstore
GROUP BY Segment
ORDER BY total_profit DESC


--10. How many customers do we have (unique customer IDs) in total and how much per region and state?
SELECT COUNT(DISTINCT(CustomerId)) AS count_customer_id
FROM Superstore

--how much per region
SELECT Region, COUNT(DISTINCT(CustomerId)) AS count_customer_id
FROM Superstore
GROUP BY Region
ORDER BY count_customer_id

--11. Customer rewards program
SELECT TOP 20 CustomerID,SUM(Sales) AS total_sales,SUM(Profit) AS total_profit
FROM Superstore
GROUP BY CustomerID
ORDER BY total_sales DESC

--12. Average shipping time per class and in total
SELECT ROUND(AVG(DATEDIFF(day, OrderDate, ShipDate)), 1) AS avg_shipping_time
FROM Superstore

--The shipping time in each shipping mode is:
SELECT ShipMode, ROUND(AVG(DATEDIFF(day, OrderDate, ShipDate)), 1) AS avg_shipping_time
FROM Superstore
GROUP BY ShipMode
ORDER BY avg_shipping_time

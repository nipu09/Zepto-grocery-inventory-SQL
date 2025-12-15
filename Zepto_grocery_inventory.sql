--data exploration
SELECT * FROM zepto;


-- Add an auto-incrementing primary key column (sku_id) to uniquely identify each row

ALTER TABLE zepto
ADD sku_id INT IDENTITY(1,1) PRIMARY KEY;

--count of rows
select count(*) from zepto;

--null values
SELECT * FROM zepto
WHERE name IS NULL
OR
category IS NULL
OR
mrp IS NULL
OR
discountPercent IS NULL
OR
discountedSellingPrice IS NULL
OR
weightInGms IS NULL
OR
availableQuantity IS NULL
OR
outOfStock IS NULL
OR
quantity IS NULL;


--different product categories
SELECT DISTINCT category
FROM zepto
ORDER BY category;

--products in stock vs out of stock
--

SELECT outOfStock, COUNT(sku_id)as Products
FROM zepto
GROUP BY outOfStock;

-- product names present multiple times

SELECT name,
COUNT(sku_id) AS number_of_sku_id
FROM zepto
GROUP BY name
HAVING count(sku_id) > 1
ORDER BY count(sku_id) DESC;

-- DATA CLEANING

--products with price = 0
SELECT *
FROM zepto
WHERE mrp = 0
  AND discountedSellingPrice = 0;

-- Delete products with price = 0 Delete 

DELETE FROM zepto
WHERE mrp = 0;

--convert paise to rupees

UPDATE zepto
SET mrp = mrp / 100.0,
discountedSellingPrice = discountedSellingPrice / 100.0;

-- DATA ANALYSIS

-- Q1. Find the top 10 best-value products based on the discount percentage.

SELECT DISTINCT TOP 10 name, mrp, discountPercent
FROM zepto
ORDER BY discountPercent DESC;

--Q2.What are the Products with High MRP but Out of Stock

SELECT DISTINCT name,mrp
FROM zepto
WHERE outOfStock = 1 and mrp > 300
ORDER BY mrp DESC;

--Q3.Calculate Estimated Revenue for each category

SELECT category,
SUM(discountedSellingPrice * availableQuantity) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue;

-- Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%.

SELECT DISTINCT name, mrp, discountPercent
FROM zepto
WHERE mrp > 500 AND discountPercent < 10
ORDER BY mrp DESC, discountPercent DESC;

-- Q5. Identify the top 5 categories offering the highest average discount percentage.

SELECT TOP 5 category,
ROUND(AVG(discountPercent),2) AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC


-- Q6. Find the price per gram for products above 100g and sort by best value.

SELECT DISTINCT name, weightInGms, discountedSellingPrice,
ROUND(discountedSellingPrice/weightInGms,2) AS price_per_gram
FROM zepto
WHERE weightInGms >= 100
ORDER BY price_per_gram;

--Q7.Group the products into categories like Low, Medium, Bulk.

SELECT DISTINCT name, weightInGms,
CASE WHEN weightInGms < 1000 THEN 'Low'
	WHEN weightInGms < 5000 THEN 'Medium'
	ELSE 'Bulk'
	END AS weight_category
FROM zepto;

--Q8.What is the Total Inventory Weight Per Category 

SELECT category,
       SUM(CAST(weightInGms AS BIGINT) * CAST(availableQuantity AS BIGINT)) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight DESC;




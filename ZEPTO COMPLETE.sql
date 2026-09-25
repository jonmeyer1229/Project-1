--Creating a raw table and cleaned table 

IF DB_ID(N'Zepto') IS NULL
BEGIN
    CREATE DATABASE Zepto;
END
GO

USE Zepto;
GO

DROP TABLE IF EXISTS dbo.zepto_raw;
GO

CREATE TABLE dbo.zepto_raw (
    Category VARCHAR(120),
    name VARCHAR(150),
    mrp INT,
    discountPercent INT,
    availableQuantity INT,
    discountedSellingPrice INT,
    weightInGms INT,
    outOfStock VARCHAR(10),
    quantity INT
);
GO

BULK INSERT dbo.zepto_raw
FROM 'C:\Users\jonathan.meyer\Downloads\zepto_v2.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = 'ACP',
    TABLOCK
);
GO

-- Verification
SELECT COUNT(*) AS RowsImported FROM dbo.zepto_raw;
SELECT TOP 10 * FROM dbo.zepto_raw;
GO

-- Create cleaned analysis table
DROP TABLE IF EXISTS dbo.zepto;
GO

CREATE TABLE dbo.zepto (
    sku_id INT IDENTITY(1,1) PRIMARY KEY,
    Category VARCHAR(120),
    name VARCHAR(150) NOT NULL,
    mrp DECIMAL(10,2),
    discountPercent DECIMAL(5,2),
    availableQuantity INT,
    discountedSellingPrice DECIMAL(10,2),
    weightInGms INT,
    outOfStock BIT,
    quantity INT
);
GO

INSERT INTO dbo.zepto (Category,name,mrp,discountPercent,availableQuantity,discountedSellingPrice,weightInGms,outOfStock,quantity)
SELECT Category,name,CAST(mrp AS DECIMAL(10,2)),CAST(discountPercent AS DECIMAL(5,2)),availableQuantity,CAST(discountedSellingPrice AS DECIMAL(10,2)),weightInGms,CASE WHEN LOWER(outOfStock)='true' THEN 1 WHEN LOWER(outOfStock)='false' THEN 0 ELSE NULL END,quantity
FROM dbo.zepto_raw;
GO

SELECT COUNT(*) AS CleanedRows FROM dbo.zepto;
GO

--Data Exploration

--different product categories
SELECT DISTINCT category
FROM zepto
ORDER BY category;

--product names present multiple times
SELECT name, COUNT(sku_id) as "Number of SKUs"
FROM zepto
GROUP BY name
HAVING count(sku_id) > 1
ORDER BY count(sku_id) DESC;

--Data Cleaning

--products with price = 0
SELECT * 
FROM zepto
WHERE mrp = 0 OR discountedSellingPrice = 0;

DELETE FROM zepto
WHERE mrp = 0;

--Creating a function to turn paise into rupees

UPDATE zepto
SET mrp = mrp/100.0,
discountedSellingPrice = discountedSellingPrice/100.0;

SELECT mrp, discountedSellingPrice FROM zepto

--Q1. find top 10 best-value products based on discount percentage

SELECT TOP 10 name , mrp, discountPercent
FROM zepto
ORDER BY discountPercent DESC

--Q2. what are high-MRP products that are currently out of stock
SELECT 	DISTINCT name, mrp
FROM zepto
WHERE outOfStock = 'TRUE' and mrp > 300
ORDER BY mrp DESC;

--Q3.Estimated potential revenue for each product category
SELECT category,
SUM(discountedSellingPrice * availableQuantity) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue;

--Q4.Filtered expensive products (MRP > ₹500) with minimal discount
SELECT DISTINCT name, mrp, discountPercent
FROM zepto
WHERE mrp > 500 AND discountPercent < 10
ORDER BY mrp DESC, discountPercent DESC;

--Q5.Ranked top 5 categories offering highest average discounts
SELECT TOP 5 category,
ROUND(AVG(discountPercent),2)  AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC

--Q6.Calculated price per gram to identify value-for-money products
SELECT DISTINCT name, weightInGms, discountedSellingprice,
ROUND(discountedSellingPrice/weightInGms,2) AS price_per_gram
FROM Zepto
WHERE weightInGms >=100
ORDER BY price_per_gram;

--Q7.Grouped products based on weight into Low, Medium, and Bulk categories
SELECT DISTINCT name, weightInGms,
CASE WHEN weightInGms < 1000 THEN 'LOW'
WHEN weightInGms < 5000 THEN 'MEDIUM'
ELSE 'BULK'
END AS weight_category
FROM zepto;

--Q8.Measured total inventory weight per product category
SELECT category,
SUM(weightInGms*availableQuantity) AS Total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight;

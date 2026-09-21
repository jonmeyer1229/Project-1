# Portfolio Projects
Hi! I'm Jonathan, a self-taught data analyst. I am an avid
lover of football, music, and telling stories using data.
I am skilled in SQL, Tableau & PowerBI.
Below are some projects I have completed

**Zepto E-Commerce Inventory Analysis — SQL Server**

**📌 Project Overview**
This project analyzes an e-commerce inventory dataset from Zepto using Microsoft SQL Server and SSMS. The goal is to demonstrate how SQL can transform an unfiltered product dataset into useful business information around pricing, discounts, inventory, product availability, and product value. This dataset was found on [Kaggle](https://www.kaggle.com/datasets/palvinder2006/zepto-inventory-dataset/data?select=zepto_v2.csv).

The project follows a complete data-analysis workflow:

Raw Data → Database Creation → Data Cleaning → Exploratory Analysis → Business Questions → Insights → Conclusions

This project focuses on the business questions that an analyst could answer with the dataset and what those results mean for an e-commerce business.

**🎯 Business Problem**

An e-commerce company can collect thousands of product records, but raw data is not immediately useful for decision-making. Without cleaning and organizing this information, it becomes harder for a business to answer questions such as:

Which products have the largest discounts?
Which expensive products are currently unavailable?
Which categories contain the most inventory value?
Which categories offer the highest average discounts?
Which products provide the best value based on price per gram?
Where is the company carrying large amounts of inventory?

This project uses SQL to turn the raw dataset into information that can support those types of decisions.

**🗃️ Dataset**

The dataset contains 3,732 product records across 14 product categories.

Each row represents a product/SKU and contains information about pricing, discounts, inventory, availability, weight, and quantity.

**🧹 Data Cleaning**

Before analyzing the data, I used SQL Server to:

Create the Zepto database.

Import the raw CSV data.

Create a raw staging table.

Identify null values.

Identify duplicate records.

Identify products with invalid pricing.

Remove the zero-MRP record.

Convert prices from paise to dollars.

Convert the True/False stock field into a SQL Server BIT value.

After cleaning, the dataset contained:

3,731 usable product records

**Data Preparation**

The original price fields were stored in paise, so the MRP and discounted selling price were divided by 100 before analysis.

For example:

2500 paise → 25.00 rupee

One record had an MRP of zero and was removed before analysis.

The raw table was preserved separately from the cleaned analysis table so that the original dataset remained available for reference.

**Columns**

**sku_id**: Unique identifier for each product entry (Synthetic Primary Key)

**name**: Product name as it appears on the app

**category**: Product category like Fruits, Snacks, Beverages, etc.

**mrp**: Maximum Retail Price (originally in paise, converted to rupees)

**discountPercent**: Discount applied on MRP

**discountedSellingPrice**: Final price after discount (also converted to ruppes)

**availableQuantity**: Units available in inventory

**weightInGms**: Product weight in grams

**outOfStock**: Boolean flag indicating stock availability

**quantity**: Number of units per package (mixed with grams for loose product

 **Business Questions & SQL Analysis**

**Q1. Which products offer the highest discounts?**

SELECT TOP 10 name , mrp, discountPercent

FROM zepto

ORDER BY discountPercent DESC

<img width="419" height="207" alt="image" src="https://github.com/user-attachments/assets/03e69966-e17d-492a-bf17-9a66f4a73179" />

**What does this mean?**

The highest discounts in the dataset are concentrated around 50%, suggesting that some products are being used as heavily discounted offerings. Large discounts can help attract customers, but a discount percentage alone does not tell us whether a product generates high value. A 50% discount on a $45 product has a much smaller dollar impact than a 20% discount on a $1,000 product. This is an example of why analysts should evaluate discount percentages alongside actual prices.

**Q2. What are high-MRP products that are currently out of stock?**

SELECT 	DISTINCT name, mrp

FROM zepto

WHERE outOfStock = 'TRUE' and mrp > 300

ORDER BY mrp DESC;

<img width="353" height="97" alt="image" src="https://github.com/user-attachments/assets/727869e9-acea-49c8-bdc5-b2d593ea61ff" />

**What does this mean?**

These products represent examples of relatively high-priced items that are unavailable. From an inventory-management perspective, these products could deserve attention because a stockout on a higher-priced item can represent more potential lost sales value than a stockout on a lower-priced product.

**Q3. What is the estimated potential revenue for each product category?**

SELECT category,

SUM(discountedSellingPrice * availableQuantity) AS total_revenue

FROM zepto

GROUP BY category

ORDER BY total_revenue;

<img width="235" height="288" alt="image" src="https://github.com/user-attachments/assets/848eff1f-68f4-4b98-935d-b4e7ac213623" />

**What does this mean?**

Cooking Essentials and Munchies have the highest estimated inventory value in the dataset. This suggests those categories represent significant amounts of capital tied up in inventory. From an operational perspective, categories with high inventory value may deserve additional monitoring because inventory that sits too long ties up working capital and may eventually require markdowns or promotions.

**Q4. Which expensive products have relatively small discounts?**

SELECT DISTINCT name, mrp, discountPercent

FROM zepto

WHERE mrp > 500 AND discountPercent < 10

ORDER BY mrp DESC, discountPercent DESC;

<img width="452" height="208" alt="image" src="https://github.com/user-attachments/assets/70636835-85ae-449b-ae24-9f9b413cb7ef" />

These products have relatively high prices but little or no discount. This could indicate that certain higher-priced products have stronger pricing flexibility, stronger brand positioning, or less need for discounting. From a pricing-analysis perspective, these products could be compared with their inventory levels and availability to determine whether additional discounts are justified.

**Q5. Which categories offer the highest average discounts?**

SELECT TOP 5 category,

ROUND(AVG(discountPercent),2)  AS avg_discount

FROM zepto

GROUP BY category

ORDER BY avg_discount DESC

<img width="234" height="114" alt="image" src="https://github.com/user-attachments/assets/dd93911f-b874-4dad-b54c-1de8f2a28d8a" />

Fruits & Vegetables have the highest average discount in the dataset at approximately 15.46%, followed by Meats, Fish & Eggs at approximately 11.03%. These categories may rely more heavily on discounting than many of the packaged-goods categories. One possible business consideration is that perishable categories may require more aggressive pricing strategies to move inventory.

**Q6. Which products provide the best value based on price per gram?**

For products weighing at least 100 grams, I calculated:

Discounted Selling Price ÷ Weight in Grams

SELECT DISTINCT name, weightInGms, discountedSellingprice,

ROUND(discountedSellingPrice/weightInGms,2) AS price_per_gram

FROM Zepto

WHERE weightInGms >=100

ORDER BY price_per_gram;

<img width="601" height="209" alt="image" src="https://github.com/user-attachments/assets/71086508-82e6-4f4c-9310-353dc573bead" />

**What does this mean?**

Price per gram creates a more standardized way to compare products with different package sizes. For example, comparing a 500g package directly with a 1,000g package using only the selling price can be misleading. Price-per-gram helps identify which products provide more product for each dollar spent. This metric could also be useful for comparing competing brands within the same category.

**Q7.How can prdoucts get grouped based on weight into Low, Medium, and Bulk categories?**

SELECT DISTINCT name, weightInGms,

CASE WHEN weightInGms < 1000 THEN 'LOW'

WHEN weightInGms < 5000 THEN 'MEDIUM'

ELSE 'BULK'

END AS weight_category

FROM zepto;

<img width="480" height="212" alt="image" src="https://github.com/user-attachments/assets/21e50a5a-e0a8-4444-8499-823cf2d6103e" />

**What Does this mean?**

The dataset is overwhelmingly composed of products in the Low-weight category. Only 46 products fall into the Bulk category. This could be useful from a fulfillment perspective because heavier and bulkier products can have different storage, handling, and delivery requirements than smaller products.

****

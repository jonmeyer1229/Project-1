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

**🧹 Data Cleaning & Preparation**

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

**🧹 Data Cleaning & Preparation**

Before analyzing the data, I used SQL Server to:

Create the Zepto database.

Import the raw CSV data.

Create a raw staging table.

Identify null values.

Identify duplicate records.

Identify products with invalid pricing.

Remove the zero-MRP record.

Convert prices from paise to rupees.

Convert the True/False stock field into a SQL Server BIT value.

After cleaning, the dataset contained:

3,731 usable product records

 **Business Questions & SQL Analysis**

**Q1. Which products offer the highest discounts?**

<img width="322" height="64" alt="image" src="https://github.com/user-attachments/assets/c62a717f-a7b4-41f4-a054-9ea76528c93d" />


<img width="419" height="207" alt="image" src="https://github.com/user-attachments/assets/03e69966-e17d-492a-bf17-9a66f4a73179" />

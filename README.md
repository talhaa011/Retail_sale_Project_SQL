# Retail_sale_Project_SQL
## Project Overview

**Project Title**: Retail Sales Analysis  
**Database**: `retail_sale_db`

This project is designed to leverage PostgreSQL for data storage, exploration, and analysis. By utilizing SQL queries, we aim to clean, process, and extract valuable insights from the dataset. The findings are compiled into comprehensive reports to support data-driven decision-making.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `retail_sale_db`.
- **Table Creation**: A table named `retail_sale` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
SELECT * FROM retail_sale
LIMIT 10;

SELECT COUNT(*) FROM retail_sale;
-- (DATA CLEANING)
-- check NULL values
SELECT * FROM retail_sale
where 
	transactions_id is NULL
	OR
	sale_date is NULL
	OR
	sale_time is NULL
	OR
	customer_id is NULL
	OR
	gender is NULL
	OR
	age is NULL
	OR
	category is NULL
	OR
	quantiy is NULL
	OR
	price_per_unit is NULL
	OR
	cogs is NULL
	OR
	total_sale is NULL;

--Delete NuLL values
DELETE FROM retail_sale
where 
	transactions_id is NULL
	OR
	sale_date is NULL
	OR
	sale_time is NULL
	OR
	customer_id is NULL
	OR
	gender is NULL
	OR
	age is NULL
	OR
	category is NULL
	OR
	quantiy is NULL
	OR
	price_per_unit is NULL
	OR
	cogs is NULL
	OR
	total_sale is NULL;
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
```sql
SELECT * 
FROM retail_sale
WHERE sale_date = '2022-11-05';
```

2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov-2022**:
```sql
SELECT *
FROM  retail_sale
WHERE category = 'Clothing'
AND
TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
AND
quantiy >= 3;
```

3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
```sql
SELECT category,
SUM(total_sale) as net_sale,
COUNT(*) as total_orders
FROM retail_sale
GROUP BY category;
```

4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
```sql
SELECT ROUND(avg(age),2) as avg_age
FROM retail_sale
WHERE category = 'Beauty';
```

5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
```sql
SELECT * 
FROM retail_sale
WHERE total_sale >1000;
```

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
```sql
SELECT category, gender, count(*) as total_no_of_trans
FROM retail_sale
GROUP BY category, gender
Order by category;
```

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
```sql
SELECT * FROM(
		SELECT
			EXTRACT(MONTH FROM sale_date)as month,
			EXTRACT(YEAR FROM sale_date) as year,
			avg(total_sale) as avg_sale,
			RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date)ORDER BY AVG(total_sale)DESC) as rank
		FROM retail_sale
		GROUP BY 1,2
) as t1
WHERE rank = 1;
```

8. **Write a SQL query to find the top 5 customers based on the highest total sales**:
```sql
SELECT customer_id as top_5_customer, sum(total_sale) as total_sale
FROM retail_sale
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
```

9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
```sql
SELECT category, COUNT(DISTINCT customer_id) as unique_customer
FROM retail_sale
GROUP BY category;
```

10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
WITH hourly_sale
	as
	(
	SELECT *,
		CASE
			WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'MORNING'
			WHEN EXTRACT (HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'AFTERNOON'
			ELSE 'EVENING'
		END as shift
	FROM retail_sale
)
SELECT shift ,COUNT(*) as total_orders
FROM hourly_sale
GROUP BY shift
order by shift desc;
```

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.

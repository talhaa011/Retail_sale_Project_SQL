DROP TABLE IF EXISTS retail_sale;
Create TABLE retail_sale
			(
				transactions_id INT PRIMARY KEY,
				sale_date DATE,
				sale_time TIME,
				customer_id INT,
				gender VARCHAR(15),
				age INT,
				category VARCHAR(15),
				quantiy INT,
				price_per_unit FLOAT,
				cogs FLOAT,
				total_sale FLOAT
			);

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

-- (DATA Exploration)

-- HOW MANY SALES WE HAVE
SELECT COUNT(*) as TOTAL_SALE FROM retail_sale;

-- HOW MANY CUSTOMER WE HAVE
SELECT COUNT(DISTINCT customer_id) as unique_customer FROM retail_sale;

-- HOW MANY CATEGORY WE HAVE
SELECT COUNT(Distinct category) as total_category FROM retail_sale;
SELECT Distinct category as total_category FROM retail_sale;

-- DATA ANALYSIS & BUSINESS KEY PROBLEM
-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)



 -- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
SELECT * 
FROM retail_sale
WHERE sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov-2022
-- SELECT category, SUM(quantiy)
-- FROM retail_sale
-- WHERE category = 'Clothing'
-- GROUP BY category;

SELECT *
FROM  retail_sale
WHERE category = 'Clothing'
AND
TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
AND
quantiy >= 3;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT category,
SUM(total_sale) as net_sale,
COUNT(*) as total_orders
FROM retail_sale
GROUP BY category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT ROUND(avg(age),2) as avg_age
FROM retail_sale
WHERE category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT * 
FROM retail_sale
WHERE total_sale >1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT category, gender, count(*) as total_no_of_trans
FROM retail_sale
GROUP BY category, gender
Order by category;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
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

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT customer_id as top_5_customer, sum(total_sale) as total_sale
FROM retail_sale
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT category, COUNT(DISTINCT customer_id) as unique_customer
FROM retail_sale
GROUP BY category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
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
------------------------------------------------------------

-- Author: Ganesh B. Naykawadi. --
-- Date Created: 17th January, 2023. --
-- Purpose: SQL Server Learning through examples. --

------------------------------------------------------------------------------------------------------------------------------------


										-- SQL Server Basics --


	-- Section Basic: Use / Select the database

	USE BikeStores;


	-- Section Basic: SELECT clause => used to get data from tables. SELECT ALL ( * )

	SELECT * FROM sales.customers;


	SELECT first_name, last_name, city, state 
	FROM sales.customers; -- Display only desired columns


	SELECT first_name, last_name, city, state 
	FROM sales.customers 
	WHERE state = 'NY'; -- Filtered Data using WHERE Clause


	SELECT city, COUNT(*) AS Customer_Count 
	FROM sales.customers 
	WHERE state = 'CA' 
	GROUP BY city 
	HAVING COUNT(*) >= 10 
	ORDER BY city ASC;  -- filter groups example


	-- Section Basic: OFFSET clause => used to skip the number of rows before starting to return rows from the query

	SELECT product_name, list_price 
	FROM production.products 
	ORDER BY list_price, product_name 
	OFFSET 10 ROWS;


	-- Section Basic: FETCH clause => used to select next number of rows after OFFSET clause

	SELECT product_name, list_price 
	FROM production.products 
	ORDER BY list_price, product_name 
	OFFSET 10 ROWS FETCH NEXT 10 ROWS ONLY;


	-- Section Basic: FETCH Example: To get the top 10 most expensive products using OFFSET and FETCH clauses:

	SELECT product_name, list_price 
	FROM production.products 
	ORDER BY list_price, product_name 
	OFFSET 0 ROWS FETCH FIRST 10 ROWS ONLY;


	-- Section Basic: SELECT TOP => limit the number of rows or percentage of rows returned in a query result set.

	SELECT TOP 7 product_name, list_price 
	FROM production.products 
	ORDER BY list_price DESC; -- using number

	SELECT TOP 1 PERCENT product_name, list_price 
	FROM production.products 
	ORDER BY list_price DESC; -- using percent

	SELECT TOP 1 PERCENT WITH TIES product_name, list_price 
	FROM production.products 
	ORDER BY list_price DESC; -- using WITH TIES


	-- Section Basic: DISTINCT Clause => to get only distinct values in a specified column of a table.

	SELECT DISTINCT city AS 'City Name', COUNT(city) AS 'Occurance' 
	FROM sales.customers 
	GROUP BY city ORDER BY city DESC;  -- DISTINCT clause on Single Column

	SELECT DISTINCT city AS 'City Name', state AS 'State Name' 
	FROM sales.customers
	ORDER BY city ASC, state DESC;   -- DISTINCT clause on Multiple Columns
	
	
	-- Section Basic: WHERE Clause => Filter-out table  data using some specific condtions

	SELECT product_name, model_year, list_price 
	FROM production.products 
	WHERE model_year < 2019 ORDER BY model_year DESC;   -- Basic One Condition WHERE Clause --

	SELECT product_id, product_name, model_year, list_price
	FROM production.products
	WHERE category_id = 1 AND model_year = 2018
	ORDER BY list_price DESC;	-- AND/OR Filter Example => Finding rows that meet two conditions

	SELECT product_id, product_name, model_year, list_price
	FROM production.products
	WHERE list_price BETWEEN 1899.00 AND 1999.99
	ORDER BY list_price DESC;	-- BETWEEN Filter Example => Finding rows with the value between two values

	SELECT product_id, product_name, model_year, list_price
	FROM production.products
	WHERE list_price IN (299.99, 369.99, 489.99)
	ORDER BY list_price DESC;	-- IN Filter Example => Finding rows that have a value in a list of values

	SELECT product_id, product_name, model_year, list_price
	FROM production.products
	WHERE product_name LIKE '%Cruiser%'
	ORDER BY list_price;		-- LIKE Filter Example => Finding rows whose values contain a string


	-- Section Basic: column alias => used togive Column a temporary meaningful name

	SELECT customer_id AS 'Consumer Number', 
	first_name+' '+last_name AS FullName, 
	email AS 'Email Address' 
	FROM sales.customers ORDER BY [Consumer Number] ASC;


	-- Section Basic: SQL JOINS
	-- New Database used - hr_joins; please select that before running queries on joins

	-- 01. INNER JOIN:

	SELECT c.id Candidate_ID, c.fullname Candidate_Name,
		   e.id Employee_ID, e.fullname Employee_Name
	FROM dbo.candidates c INNER JOIN dbo.employees e 
	ON c.fullname = e.fullname;


	-- 02. Left JOIN:

	SELECT c.id Candidate_ID, c.fullname Candidate_Name,
		   e.id Employee_ID, e.fullname Employee_Name
	FROM candidates c LEFT JOIN employees e
	ON e.fullname = c.fullname;


	-- 03. Right JOIN:

	SELECT c.id Candidate_ID, c.fullname Candidate_Name,
		   e.id Employee_ID, e.fullname Employee_Name
	FROM candidates c Right JOIN employees e
	ON e.fullname = c.fullname;


	-- 04. Full JOIN:

	SELECT c.id Candidate_ID, c.fullname Candidate_Name,
		   e.id Employee_ID, e.fullname Employee_Name
	FROM candidates c FULL JOIN employees e
	ON e.fullname = c.fullname;


	-- 05. SELF JOIN:

	SELECT c1.id Candidate_ID, c1.fullname Candidate_Name,
		   c2.id Candidate_ID, c2.fullname Candidate_Name
	FROM candidates c1 INNER JOIN candidates c2
	ON c1.fullname = c2.fullname;


	-- 06. CROSS JOIN:

	SELECT c.id Candidate_ID, c.fullname Candidate_Name,
		   e.id Employee_ID, e.fullname Employee_Name
	FROM candidates c CROSS JOIN employees e 
	ORDER BY Candidate_ID, Employee_ID;


	-- Section Basic: GROUP BY Clause => to produced a group for each combination of the values in the columns listed in clause

	SELECT customer_id, YEAR(order_date) Order_Year 
	FROM BikeStores.sales.orders
	WHERE customer_id IN(1,2)
	GROUP BY customer_id, YEAR(order_date)
	ORDER BY customer_id;

	-- same above result using DISTINCT Clause

	SELECT DISTINCT customer_id, YEAR (order_date) order_year
	FROM sales.orders
	WHERE customer_id IN (1, 2)
	ORDER BY customer_id;


	-- Example 01: GROUP BY => state should either having aggregate functions or be present in group by clause to work
	-- the query.

	SELECT city,
    COUNT (customer_id) customer_count,
	state 
	FROM sales.customers
	GROUP BY city
	ORDER BY city;


	-- Example 02: GROUP BY => following query returns the number of customers by state and city.

	SELECT city, state,
    COUNT (customer_id) customer_count
	FROM sales.customers
	GROUP BY state, city
	ORDER BY city, state;


	-- Example 03: GROUP BY => following statement returns the minimum and maximum list prices of all products with
	-- the model 2018 by brand.

	SELECT brand_name,
    MIN (list_price) min_price,
    MAX (list_price) max_price
	FROM production.products p
	INNER JOIN production.brands b ON b.brand_id = p.brand_id
	WHERE model_year = 2018
	GROUP BY brand_name
	ORDER BY brand_name;


	-- Section Basic: HAVING Clause => Used to filter the groups based on specified conditions.

	SELECT customer_id, YEAR (order_date) AS Buying_Year, COUNT (order_id) order_count
	FROM sales.orders
	GROUP BY customer_id, YEAR (order_date)
	HAVING COUNT (order_id) >= 2
	ORDER BY customer_id, order_count;


	-- Example 01: HAVING clause with the SUM() function example.

	SELECT order_id, SUM (quantity * list_price * ( 1 - discount)) net_value
	FROM sales.order_items
	GROUP BY order_id
	HAVING SUM (quantity * list_price * ( 1 - discount)) >  20000
	ORDER BY net_value;


	-- Example 02: HAVING clause with MAX and MIN functions example.

	SELECT category_id, MAX (list_price) max_list_price, MIN (list_price) min_list_price
	FROM production.products
	GROUP BY category_id
	HAVING MAX (list_price) > 4000 OR MIN (list_price) < 500;


	-- Example 03: HAVING clause with AVG() function example.

	SELECT category_id, AVG (list_price) avg_list_price
	FROM production.products
	GROUP BY category_id
	HAVING AVG (list_price) BETWEEN 500 AND 1000;


	-- Section Basic: GROUPING SETS => Used to generate multiple grouping sets.

	SELECT brand, category, SUM (sales) sales
	FROM sales.sales_summary
	GROUP BY
	GROUPING SETS (
		(brand, category),
		(brand),
		(category),
		()
	)
	ORDER BY brand, category;


	-- Section Basic: GROUPING SETS => CUBE
	SELECT brand, category, SUM (sales) sales
	FROM sales.sales_summary
	GROUP BY CUBE(brand, category);


	-- Section Basic: GROUPING SETS => ROLLUP

	SELECT brand, category, SUM (sales) sales
	FROM sales.sales_summary
	GROUP BY ROLLUP(brand, category);


	-- Section Basic: SUBQUERY => A subquery is a query nested inside another statement such as SELECT, INSERT, UPDATE, DELETE.

	-- 01. subquery used in place of an expression

	SELECT order_id, order_date,
    (
        SELECT
            MAX (list_price)
        FROM
            sales.order_items i
        WHERE
            i.order_id = o.order_id
    ) AS max_list_price
	FROM sales.orders o
	order by order_date desc;


	-- 02. subquery is used with IN / NOT IN operator

	SELECT product_id, product_name
	FROM production.products
	WHERE category_id IN (
        SELECT
            category_id
        FROM
            production.categories
        WHERE
            category_name = 'Mountain Bikes'
        OR category_name = 'Road Bikes'
    );


	-- 03. subquery is used with ANY operator

	SELECT product_name, list_price
	FROM production.products
	WHERE list_price >= ANY (
        SELECT
            AVG (list_price)
        FROM
            production.products
        GROUP BY
            brand_id
    )


	-- 04. subquery is used with ALL operator

	SELECT product_name, list_price
	FROM production.products
	WHERE list_price >= ALL (
        SELECT
            AVG (list_price)
        FROM
            production.products
        GROUP BY
            brand_id
    )


	-- 05. subquery is used with EXISTS or NOT EXISTS

	SELECT customer_id, first_name, last_name, city
	FROM sales.customers c
	WHERE EXISTS (
        SELECT
            customer_id
        FROM
            sales.orders o
        WHERE
            o.customer_id = c.customer_id
        AND YEAR (order_date) = 2017
    )
	ORDER BY first_name, last_name;


	-- 06. subquery in the FROM clause

	SELECT AVG(order_count) average_order_count_by_staff
	FROM
	(
		SELECT 
			staff_id, COUNT(order_id) order_count
		FROM sales.orders
		GROUP BY staff_id
	) t;


	-- Section Basic: Correlated Subquery => It is a subquery that uses the values of the outer query

	SELECT product_name, list_price, category_id
	FROM production.products p1
	WHERE list_price IN (
        SELECT MAX (p2.list_price)
        FROM production.products p2
        WHERE p2.category_id = p1.category_id
        GROUP BY p2.category_id
    )
	ORDER BY category_id, product_name;


	--  Section Basic: UNION => It is set operation that allow you to combine results of two SELECT statements into
	-- a single result set.

	SELECT first_name, last_name
	FROM sales.staffs
	UNION
	SELECT first_name, last_name
    FROM sales.customers;

	-- UNION ALL

	SELECT first_name, last_name
	FROM sales.staffs
	UNION ALL
	SELECT first_name, last_name
	FROM sales.customers;


	-- Section Basic: INTERSECT => combines result sets of two or more queries and returns distinct rows that are output
	-- by both queries.

	SELECT city
	FROM sales.customers
	INTERSECT
	SELECT city
	FROM sales.stores
	ORDER BY city;


	-- Section Basic: CTE => (Common Table Expression) allows us to define a temporary named result set that available
	-- temporarily in the execution scope of a statement.

	WITH cte_sales_amounts (staff, sales, year) AS (
    SELECT    
        first_name + ' ' + last_name, 
        SUM(quantity * list_price * (1 - discount)),
        YEAR(order_date)
    FROM    
        sales.orders o
    INNER JOIN sales.order_items i ON i.order_id = o.order_id
    INNER JOIN sales.staffs s ON s.staff_id = o.staff_id
    GROUP BY 
        first_name + ' ' + last_name,
        year(order_date)
	)

	SELECT staff, sales
	FROM cte_sales_amounts
	WHERE year = 2018;


	--Example 2: Using a common table expression to make report averages based on counts.

	WITH cte_sales AS (
    SELECT staff_id, COUNT(*) order_count  
    FROM sales.orders
    WHERE YEAR(order_date) = 2018
    GROUP BY staff_id
	)
	SELECT AVG(order_count) average_orders_by_staff
	FROM cte_sales;


	-- Recursive CTE Example

	WITH cte_numbers(n, weekday) 
	AS (
    SELECT 0, DATENAME(DW, 0)
    UNION ALL
    SELECT n + 1, DATENAME(DW, n + 1)
    FROM cte_numbers
    WHERE n < 6
	)
	SELECT weekday
	FROM cte_numbers;


	-- Section Basic: PIVOT => PIVOT operator rotates a table-valued expression. It turns the unique values in one column 
	-- into multiple columns in the output and performs aggregations on any remaining column values.

	-- STEP 01: select a base dataset for pivoting:

	--  SELECT category_name, product_id
	--  FROM production.products p INNER JOIN production.categories c
	--  ON p.category_id = c.category_id;

	-- STEP 02: create a temporary result set using a derived table:

	--  SELECT * FROM(
	--   SELECT category_name, product_id
	--   FROM production.products p INNER JOIN production.categories c
	--   ON p.category_id = c.category_id;
	--  ) t

	-- STEP 03: apply the PIVOT operator:

	SELECT * FROM (
		SELECT category_name, product_id, model_year
		FROM production.products p INNER JOIN production.categories c 
        ON c.category_id = p.category_id
	) t 
	PIVOT(
		COUNT(product_id) 
		FOR category_name IN (
			[Children Bicycles], 
			[Comfort Bicycles], 
			[Cruisers Bicycles], 
			[Cyclocross Bicycles], 
			[Electric Bikes], 
			[Mountain Bikes], 
			[Road Bikes])
	) AS pivot_table;

	-- DYNAMIC PIVOT Table

	DECLARE 
    @columns NVARCHAR(MAX) = '', 
    @sql     NVARCHAR(MAX) = '';

	-- select the category names
	SELECT @columns+=QUOTENAME(category_name) + ','
	FROM production.categories
	ORDER BY category_name;

	-- remove the last comma
	SET @columns = LEFT(@columns, LEN(@columns) - 1);

	-- construct dynamic SQL
	SET @sql ='
	SELECT * FROM (
		SELECT category_name, model_year, product_id 
		FROM production.products p INNER JOIN production.categories c 
        ON c.category_id = p.category_id
	) t 
	PIVOT(
		COUNT(product_id) 
		FOR category_name IN ('+ @columns +')
	) AS pivot_table;';

	-- execute the dynamic SQL
	EXECUTE sp_executesql @sql;


	-- Section Basic: INSERT => To add one or more rows into a table.

	--create an schema

	CREATE TABLE sales.promotions (
		promotion_id INT PRIMARY KEY IDENTITY (1, 1),
		promotion_name VARCHAR (255) NOT NULL,
		discount NUMERIC (3, 2) DEFAULT 0,
		start_date DATE NOT NULL,
		expired_date DATE NOT NULL
	); 

	--  INSERT Data into table schema
	INSERT INTO sales.promotions (
		promotion_name,	discount, start_date, expired_date
	) VALUES (
        '2018 Summer Promotion', 0.15, '20180601', '20180901'
    );


	-- To capture the inserted values, you use the OUTPUT clause. For example, the following statement inserts a new row
	-- into the promotions table and returns the inserted value of the promotion_id column:

	INSERT INTO sales.promotions (
		promotion_name, discount, start_date, expired_date
	) OUTPUT inserted.promotion_id
	VALUES (
        '2018 Fall Promotion', 0.15, '20181001', '20181101'
    );


	-- Insert explicit values into the identity column

	SET IDENTITY_INSERT sales.promotions ON;

	INSERT INTO sales.promotions (
		promotion_id, promotion_name, discount, start_date, expired_date
	)
	VALUES
    (
        7, '2019 Spring Promotion', 0.25, '20190201', '20190301'
    );

	SET IDENTITY_INSERT sales.promotions OFF;

	SELECT * FROM sales.promotions;


	-- INSERT Multiple Rows

	INSERT INTO sales.promotions (
		promotion_name, discount, start_date, expired_date
	)
	VALUES
    ( '2019 Summer Promotion', 0.15, '20190601', '20190901' ),
    ( '2019 Fall Promotion', 0.20, '20191001', '20191101' ),
    ( '2019 Winter Promotion', 0.25, '20191201', '20200101' );


	-- INSERT INTO SELECT

	-- Let's create a table named addresses for the demonstration

	CREATE TABLE sales.addresses (
		address_id INT IDENTITY PRIMARY KEY,
		street VARCHAR (255) NOT NULL,
		city VARCHAR (50),
		state VARCHAR (25),
		zip_code VARCHAR (5)
	);   

	
	-- Example 01: The following statement inserts all addresses from the customers table into the addresses table

	INSERT INTO sales.addresses (street, city, state, zip_code) 
	SELECT street, city, state, zip_code
	FROM sales.customers
	ORDER BY first_name, last_name; 

	-- SELECT * FROM sales.addresses;


	-- Section Basic:  UPDATE => To modify existing data in a table, you use the following UPDATE statement

	-- create a new table named taxes for demonstration.

	CREATE TABLE sales.taxes (
		tax_id INT PRIMARY KEY IDENTITY (1, 1),
		state VARCHAR (50) NOT NULL UNIQUE,
		state_tax_rate DEC (3, 2),
		avg_local_tax_rate DEC (3, 2),
		combined_rate AS state_tax_rate + avg_local_tax_rate,
		max_local_tax_rate DEC (3, 2),
		updated_at datetime
	);

	INSERT INTO sales.taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Alabama',0.04,0.05,0.07);
	INSERT INTO sales.taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Alaska',0,0.01,0.07);
	INSERT INTO sales.taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Arizona',0.05,0.02,0.05);
	INSERT INTO sales.taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Arkansas',0.06,0.02,0.05);
	INSERT INTO sales.taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('California',0.07,0.01,0.02);
	INSERT INTO sales.taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Colorado',0.02,0.04,0.08);
	INSERT INTO sales.taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Connecticut',0.06,0,0);
	INSERT INTO sales.taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Delaware',0,0,0);
	INSERT INTO sales.taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Florida',0.06,0,0.02);
	INSERT INTO sales.taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Georgia',0.04,0.03,0.04);
	INSERT INTO sales.taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Hawaii',0.04,0,0);
	INSERT INTO sales.taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Idaho',0.06,0,0.03);
	INSERT INTO sales.taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Illinois',0.06,0.02,0.04);
	INSERT INTO sales.taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Indiana',0.07,0,0);
	INSERT INTO sales.taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Iowa',0.06,0,0.01);
	INSERT INTO sales.taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Kansas',0.06,0.02,0.04);
	INSERT INTO sales.taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Kentucky',0.06,0,0);
	INSERT INTO sales.taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Louisiana',0.05,0.04,0.07);
	INSERT INTO sales.taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Maine',0.05,0,0);
	INSERT INTO sales.taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Maryland',0.06,0,0);
	INSERT INTO sales.taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Massachusetts',0.06,0,0);
	INSERT INTO sales.taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Michigan',0.06,0,0);
	INSERT INTO sales.taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Minnesota',0.06,0,0.01);
	INSERT INTO sales.taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Mississippi',0.07,0,0.01);
	INSERT INTO sales.taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Missouri',0.04,0.03,0.05);
	INSERT INTO sales.taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Montana',0,0,0);
	INSERT INTO sales.taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Nebraska',0.05,0.01,0.02);
	INSERT INTO sales.taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Nevada',0.06,0.01,0.01);
	INSERT INTO sales.taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('New Hampshire',0,0,0);
	INSERT INTO sales.taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('New Jersey',0.06,0,0);
	INSERT INTO sales.taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('New Mexico',0.05,0.02,0.03);
	INSERT INTO sales.taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('New York',0.04,0.04,0.04);
	INSERT INTO sales.taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('North Carolina',0.04,0.02,0.02);
	INSERT INTO sales.taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('North Dakota',0.05,0.01,0.03);
	INSERT INTO sales.taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Ohio',0.05,0.01,0.02);
	INSERT INTO sales.taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Oklahoma',0.04,0.04,0.06);
	INSERT INTO sales.taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Oregon',0,0,0);
	INSERT INTO sales.taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Pennsylvania',0.06,0,0.02);
	INSERT INTO sales.taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Rhode Island',0.07,0,0);
	INSERT INTO sales.taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('South Carolina',0.06,0.01,0.02);
	INSERT INTO sales.taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('South Dakota',0.04,0.01,0.04);
	INSERT INTO sales.taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Tennessee',0.07,0.02,0.02);
	INSERT INTO sales.taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Texas',0.06,0.01,0.02);
	INSERT INTO sales.taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Utah',0.05,0,0.02);
	INSERT INTO sales.taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Vermont',0.06,0,0.01);
	INSERT INTO sales.taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Virginia',0.05,0,0);
	INSERT INTO sales.taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Washington',0.06,0.02,0.03);
	INSERT INTO sales.taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('West Virginia',0.06,0,0.01);
	INSERT INTO sales.taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Wisconsin',0.05,0,0.01);
	INSERT INTO sales.taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('Wyoming',0.04,0.01,0.02);
	INSERT INTO sales.taxes(state,state_tax_rate,avg_local_tax_rate,max_local_tax_rate) VALUES('D.C.',0.05,0,0);


	-- Example 01:  Update a single column in all rows example

	UPDATE sales.taxes
	SET updated_at = GETDATE();


	-- Example 02: Update multiple columns example

	UPDATE sales.taxes
	SET max_local_tax_rate += 0.02, avg_local_tax_rate += 0.01
	WHERE max_local_tax_rate = 0.01;


	-- SQL SERVER UPDATE JOIN examples

	DROP TABLE IF EXISTS sales.targets;

	CREATE TABLE sales.targets (
		target_id  INT	PRIMARY KEY, percentage DECIMAL(4, 2) NOT NULL DEFAULT 0
	);

	INSERT INTO sales.targets(target_id, percentage)
	VALUES (1,0.2), (2,0.3), (3,0.5), (4,0.6), (5,0.8);

	CREATE TABLE sales.commissions (
		staff_id    INT PRIMARY KEY, 
		target_id   INT, 
		base_amount DECIMAL(10, 2) NOT NULL DEFAULT 0, 
		commission  DECIMAL(10, 2) NOT NULL DEFAULT 0, 
		FOREIGN KEY(target_id) 
        REFERENCES sales.targets(target_id), 
		FOREIGN KEY(staff_id) 
        REFERENCES sales.staffs(staff_id),
	);

	INSERT INTO sales.commissions(staff_id, base_amount, target_id)
	VALUES (1,100000,2), (2,120000,1), (3,80000,3), (4,900000,4), (5,950000,5);


	-- Example 01: UPDATE INNER JOIN example

	UPDATE sales.commissions
	SET sales.commissions.commission = c.base_amount * t.percentage
	FROM sales.commissions c INNER JOIN sales.targets t
    ON c.target_id = t.target_id;

	-- SELECT * FROM sales.commissions;


	-- Example 02: Suppose we have two more new sales staffs that have just joined and they don’t have any target yet.

	INSERT INTO sales.commissions(staff_id, base_amount, target_id)
	VALUES (6,100000,NULL), (7,120000,NULL);


	-- we can update the commission of all sales staffs using the UPDATE LEFT JOIN as follows:

	UPDATE sales.commissions
	SET sales.commissions.commission = c.base_amount  * COALESCE(t.percentage,0.1)
	FROM sales.commissions c LEFT JOIN sales.targets t 
    ON c.target_id = t.target_id;

	-- SELECT * FROM sales.commissions;


	-- Section Basic: DELETE => To remove one or more rows from a table completely, we use the DELETE statement.

	SELECT * INTO product_history
	FROM production.products;


	-- Example 01: The following DELETE statement removes all products whose model year is 2017:

	DELETE FROM production.product_history
	WHERE model_year = 2017;


	-- Example 02: The following DELETE statement removes 21 random rows from the product_history table:

	DELETE TOP (21)
	FROM production.product_history;
		

	-- Example 03: following statement will delete all rows from the target_table:

	DELETE FROM production.product_history;


	-- Section Basic: MERGE => update data in a table based on values matched from another table.

	-- step 1: create a base table (Source table) 

	CREATE TABLE sales.category (
		category_id INT PRIMARY KEY,
		category_name VARCHAR(255) NOT NULL,
		amount DECIMAL(10 , 2 )
	);

	INSERT INTO sales.category(category_id, category_name, amount)
	VALUES(1,'Children Bicycles',15000),
		  (2,'Comfort Bicycles',25000),
		  (3,'Cruisers Bicycles',13000),
		  (4,'Cyclocross Bicycles',10000);


	CREATE TABLE sales.category_staging (
		category_id INT PRIMARY KEY,
		category_name VARCHAR(255) NOT NULL,
		amount DECIMAL(10 , 2 )
	);


	INSERT INTO sales.category_staging(category_id, category_name, amount)
	VALUES(1,'Children Bicycles',15000),
		  (3,'Cruisers Bicycles',13000),
		  (4,'Cyclocross Bicycles',20000),
		  (5,'Electric Bikes',10000),
		  (6,'Mountain Bikes',10000);


	-- step 2: Use Merge statement on the target table

	MERGE sales.category t 
    USING sales.category_staging s
	ON (s.category_id = t.category_id)
	WHEN MATCHED
    THEN UPDATE SET 
        t.category_name = s.category_name,
        t.amount = s.amount
	WHEN NOT MATCHED BY TARGET 
    THEN INSERT (category_id, category_name, amount)
         VALUES (s.category_id, s.category_name, s.amount)
	WHEN NOT MATCHED BY SOURCE 
    THEN DELETE;


	-- Section Basic: TRANSACTION => A transaction is a single unit of work that typically contains multiple T-SQL statements.
	-- We’ll create two tables: invoices and invoice_items for the demonstration

	CREATE TABLE invoices (
		id int IDENTITY PRIMARY KEY,
		customer_id int NOT NULL,
		total decimal(10, 2) NOT NULL DEFAULT 0 CHECK (total >= 0)
	);

	CREATE TABLE invoice_items (
		id int,
		invoice_id int NOT NULL,
		item_name varchar(100) NOT NULL,
		amount decimal(10, 2) NOT NULL CHECK (amount >= 0),
		tax decimal(4, 2) NOT NULL CHECK (tax >= 0),
		PRIMARY KEY (id, invoice_id),
		FOREIGN KEY (invoice_id) REFERENCES invoices (id)
		ON UPDATE CASCADE
		ON DELETE CASCADE
	);

	-- The following example uses the BEGIN TRANSACTION and COMMIT statements to create a transaction:

	BEGIN TRANSACTION;

	INSERT INTO invoices (customer_id, total)
	VALUES (100, 0);

	INSERT INTO invoice_items (id, invoice_id, item_name, amount, tax)
	VALUES (10, 1, 'Keyboard', 70, 0.08),
		   (20, 1, 'Mouse', 50, 0.08);

	UPDATE invoices
		SET total = (SELECT
		SUM(amount * (1 + tax))
		FROM invoice_items
	WHERE invoice_id = 1);

	COMMIT;


	-- Section Basic: Data Definition => CREATE DATABASE => creates a new database.

	CREATE DATABASE TestDb;


	-- Section Basic: DROP DATABASE => To remove an existing database, we use the DROP DATABASE statement.

	DROP DATABASE IF EXISTS TestDb;


	-- Section Basic: CREATE SCHEMA =>  

	CREATE SCHEMA customer_services;
	GO


	-- list all schemas in the current database

	SELECT s.name AS schema_name, u.name AS schema_owner
	FROM sys.schemas s
	INNER JOIN sys.sysusers u ON u.uid = s.principal_id
	ORDER BY u.name;


	-- Section Basic: ALTER SCHEMA => allows us to transfer a securable from a schema to another within the same database.

	-- step 1: First, create a new table named offices in the dbo schema:

	CREATE TABLE dbo.offices (
		office_id      INT PRIMARY KEY IDENTITY, 
		office_name    NVARCHAR(40) NOT NULL, 
		office_address NVARCHAR(255) NOT NULL, 
		phone          VARCHAR(20),
	);


	-- step 2: insert some rows into the dob.offices table:

	INSERT INTO dbo.offices(office_name, office_address)
	VALUES	('Silicon Valley','400 North 1st Street, San Jose, CA 95130'),
			('Sacramento','1070 River Dr., Sacramento, CA 95820');


	-- step 3: create a stored procedure that finds office by office id:

	CREATE PROC usp_get_office_by_id ( @id INT ) AS
	BEGIN
		SELECT * FROM dbo.offices
		WHERE office_id = @id;
	END;


	-- step 4: transfer this dbo.offices table to the sales schema:

	ALTER SCHEMA sales TRANSFER OBJECT::dbo.offices;  


	-- If you execute the usp_get_office_by_id stored procedure, SQL Server will issue an error:

	exec usp_get_office_by_id @id = 1;


	-- step 5: Finally, manually modify the stored procedure to reflect the new schema:

	ALTER PROC usp_get_office_by_id(@id INT) AS
	BEGIN
		SELECT * FROM sales.offices
		WHERE office_id = @id;
	END;


	-- execute stored procedure now

	exec usp_get_office_by_id @id = 1;


	-- Section Basic:  DROP SCHEMA => The DROP SCHEMA statement allows you to delete a schema from a database.

	-- step 1: Create a schema for demonstration:

	CREATE SCHEMA logistics;
	GO


	-- step 2: Next, create a new table named deliveries inside the logistics schema:

	CREATE TABLE logistics.deliveries (
		order_id		INT PRIMARY KEY, 
		delivery_date   DATE NOT NULL, 
		delivery_status TINYINT NOT NULL
	);


	-- SQL Server issued the following error because the schema is not empty.

	DROP SCHEMA logistics;


	-- step 3: After that, drop the table logistics.deliveries:

	DROP TABLE IF EXISTS logistics.deliveries;


	-- step 4: Finally, issue the DROP SCHEMA again to drop the logistics schema:

	DROP SCHEMA IF EXISTS logistics;


	-- Section Basic: CREATE TABLE => this statement used to create a new table.

	CREATE TABLE sales.visits (
		visit_id INT PRIMARY KEY IDENTITY (1, 1),
		first_name VARCHAR (50) NOT NULL,
		last_name VARCHAR (50) NOT NULL,
		visited_at DATETIME,
		phone VARCHAR(20),
		store_id INT NOT NULL,
		FOREIGN KEY (store_id) REFERENCES sales.stores (store_id)
	);


	-- Section Basic: IDENTITY => Used to add an identity column to a table.

	-- Create a new schema

	CREATE SCHEMA hr;


	--  create a new table using the IDENTITY property for the personal identification number column:

	CREATE TABLE hr.person (
		person_id INT IDENTITY(1,1) PRIMARY KEY,
		first_name VARCHAR(50) NOT NULL,
		last_name VARCHAR(50) NOT NULL,
		gender CHAR(1) NOT NULL
	);


	-- First, insert a new row into the person table:

	INSERT INTO hr.person(first_name, last_name, gender)
	OUTPUT inserted.person_id
	VALUES('Ganesh', 'Naykawadi', 'M');
	

	-- Section Basic: SEQUENCE => -	A sequence is a user-defined schema bound object that generates a sequence 
	-- of numeric values according to the specification with which the sequence was created.

	-- Create a simple sequence:

	CREATE SEQUENCE item_counter
		AS INT
		START WITH 10
		INCREMENT BY 10
		MINVALUE 10
		MAXVALUE 50;

		-- The following statement returns the current value of the item_counter sequence:

		SELECT NEXT VALUE FOR item_counter AS Counter;

	-- Example 01: Real-life example for sequence object in a single table
	-- First, create a new schema named procurement:

	CREATE SCHEMA procurement;
	GO;


	-- Next, create a new table named orders:

	CREATE TABLE procurement.purchase_orders(
		order_id INT PRIMARY KEY,
		vendor_id int NOT NULL,
		order_date date NOT NULL
	);


	-- create a new sequence object named order_number that starts with 1 and is incremented by 1:

	CREATE SEQUENCE procurement.order_number
		AS INT
		START WITH 1
		INCREMENT BY 1;


	-- insert three rows into the procurement.purchase_orders table 

	INSERT INTO procurement.purchase_orders (
		order_id,
		vendor_id,
		order_date)
	VALUES
		(NEXT VALUE FOR procurement.order_number,1,'2019-04-30');


	INSERT INTO procurement.purchase_orders (
		order_id,
		vendor_id,
		order_date)
	VALUES
		(NEXT VALUE FOR procurement.order_number,2,'2019-05-01');


	INSERT INTO procurement.purchase_orders	(
		order_id,
		vendor_id,
		order_date)
	VALUES
		(NEXT VALUE FOR procurement.order_number,3,'2019-05-02');


	-- RESULT:

	SELECT order_id, vendor_id, order_date
	FROM procurement.purchase_orders;


	-- Example 02: Real-life example for sequence object in a multiple tables
	-- First, create a new sequence object:

	CREATE SEQUENCE procurement.receipt_no
	START WITH 1
	INCREMENT BY 1;


	-- Second, create procurement.goods_receipts and procurement.invoice_receipts tables:

	CREATE TABLE procurement.goods_receipts (
		receipt_id   INT	PRIMARY KEY DEFAULT (NEXT VALUE FOR procurement.receipt_no), 
		order_id     INT NOT NULL, 
		full_receipt BIT NOT NULL,
		receipt_date DATE NOT NULL,
		note NVARCHAR(100),
	);


	CREATE TABLE procurement.invoice_receipts (
		receipt_id   INT PRIMARY KEY DEFAULT (NEXT VALUE FOR procurement.receipt_no), 
		order_id     INT NOT NULL, 
		is_late      BIT NOT NULL,
		receipt_date DATE NOT NULL,
		note NVARCHAR(100)
	);


	-- Third, insert some rows into both tables without supplying the values for the receipt_id columns:

	INSERT INTO procurement.goods_receipts(
			order_id, 
			full_receipt,
			receipt_date,
			note
		)
		VALUES( 1, 1, '2019-05-12', 'Goods receipt completed at warehouse'
	);
	INSERT INTO procurement.goods_receipts(
			order_id, 
			full_receipt,
			receipt_date,
			note
		)
		VALUES( 1, 0, '2019-05-12', 'Goods receipt has not completed at warehouse'
	);

	INSERT INTO procurement.invoice_receipts(
			order_id, 
			is_late,
			receipt_date,
			note
		)
		VALUES( 1, 0, '2019-05-13', 'Invoice duly received'
	);
	INSERT INTO procurement.invoice_receipts(
			order_id, 
			is_late,
			receipt_date,
			note
		)
		VALUES( 2, 0, '2019-05-15', 'Invoice duly received'
	);


	-- Fourth, query data from both tables:

	SELECT * FROM procurement.goods_receipts;
	SELECT * FROM procurement.invoice_receipts;


	-- Section Basic: ALTER TABLE ADD Column => used to add one or more columns to a table.
	-- create a new table named sales.quotations:

	CREATE TABLE sales.quotations (
		quotation_no INT IDENTITY PRIMARY KEY,
		valid_from DATE NOT NULL,
		valid_to DATE NOT NULL
	);


	-- To add a new column named description to the sales.quotations table, we use the following statements:

	-- for single column add

	ALTER TABLE sales.quotations
	ADD description VARCHAR (255) NOT NULL;

	-- for multiple column add

	ALTER TABLE sales.quotations 
    ADD 
        amount DECIMAL (10, 2) NOT NULL,
        customer_name VARCHAR (50) NOT NULL;

	-- check RESULT:

	select * from sales.quotations;


	-- Section Basic: ALTER TABLE ALTER COLUMN => used to modify a column of a table.	
	-- First, create a new table with one column whose data type is INT:

	CREATE TABLE t1 (c INT);
	

	-- INSERT Values

	INSERT INTO t1
	VALUES (1), (2), (3);


	-- Use-case 1: modify the data type of the column from INT to VARCHAR:

	ALTER TABLE t1 
	ALTER COLUMN c VARCHAR(2);

	-- INSERT text value 

	INSERT INTO t1
	VALUES ('@');


	-- Use-case 2: Change the size of a column

	ALTER TABLE t1 ALTER COLUMN c VARCHAR (10);


	-- Use-case 3: Add a NOT NULL constraint to a nullable column

	ALTER TABLE t1 ALTER COLUMN c VARCHAR (10) NOT NULL;


	-- Section Basic: ALTER TABLE DROP COLUMN => used to remove one or more columns from existing table.

	-- create a new table named sales.price_lists for the demonstration.
	
	CREATE TABLE sales.price_lists (
		product_id int,
		valid_from DATE,
		price DEC(10,2) NOT NULL CONSTRAINT ck_positive_price CHECK(price >= 0),
		discount DEC(10,2) NOT NULL,
		surcharge DEC(10,2) NOT NULL,
		note VARCHAR(255),
		PRIMARY KEY(product_id, valid_from)
	); 

	-- DROP single column from table

	ALTER TABLE sales.price_lists
	DROP COLUMN note;


	-- DROP multiple columns from table

	ALTER TABLE sales.price_lists
	DROP COLUMN discount, surcharge;


	-- Section Basic: Computed Column => This is a column that is computed dynamically based on the values of 
	-- other columns in the same table

	-- step 1: Let’s create a new table named persons for the demonstrations:
	
	CREATE TABLE persons (
		person_id  INT PRIMARY KEY IDENTITY, 
		first_name NVARCHAR(100) NOT NULL, 
		last_name  NVARCHAR(100) NOT NULL, 
		dob        DATE
	);

	-- step 2:  insert two rows into the the persons table:

	INSERT INTO persons(first_name, last_name, dob)
	VALUES ('John','Doe','1990-05-01'),
		   ('Jane','Doe','1995-03-01');

	-- step 3: add the new full_name column to the persons table with the PERSISTED property:

	ALTER TABLE persons
	ADD full_name AS (first_name + ' ' + last_name) PERSISTED;

	-- check Result:

	SELECT person_id, full_name, dob
	FROM persons
	ORDER BY full_name;


	-- Section Basic: DROP TABLE => used to remove one or more tables from a database.

	-- Case 1: Drop a table that does not exist

	DROP TABLE IF EXISTS sales.revenues;


	-- Case 2: Drop a single table example

	-- 1. The following statement creates a new table named delivery in the sales schema:

	CREATE TABLE sales.delivery (
		delivery_id INT PRIMARY KEY,
		delivery_note VARCHAR (255) NOT NULL,
		delivery_date DATE NOT NULL
	);

	-- 2. To remove the delivery table, you use the following statement:

	DROP TABLE sales.delivery;


	-- Case 3: Drop a table with a foreign key constraint.

	-- The following statement creates two new tables named supplier_groups and suppliers in the procurement schema:

	CREATE SCHEMA procurement;
	GO

	CREATE TABLE procurement.supplier_groups (
		group_id INT IDENTITY PRIMARY KEY,
		group_name VARCHAR (50) NOT NULL
	);

	CREATE TABLE procurement.suppliers (
		supplier_id INT IDENTITY PRIMARY KEY,
		supplier_name VARCHAR (50) NOT NULL,
		group_id INT NOT NULL,
		FOREIGN KEY (group_id) REFERENCES procurement.supplier_groups (group_id)
	);

	-- err : Let’s try to drop the supplier_groups table:

	DROP TABLE procurement.supplier_groups;

	-- Right way: 

	DROP TABLE procurement.suppliers, procurement.supplier_groups;


	-- Section Basic: TRUNCATE TABLE => used  to remove all rows from a table faster and more efficiently.

	CREATE TABLE sales.customer_groups (
		group_id INT PRIMARY KEY IDENTITY,
		group_name VARCHAR (50) NOT NULL
	);

	INSERT INTO sales.customer_groups (group_name)
	VALUES	('Intercompany'),
			('Third Party'),
			('One time');

	TRUNCATE TABLE sales.customer_groups;


	-- Section Basic: SELECT INTO => creates a new table and inserts rows from the query into it.

	-- case 1: Using SQL Server SELECT INTO to copy table within the same database example

	-- step 1: create a new schema for storing the new table.
	
	CREATE SCHEMA marketing;
	GO

	-- create the marketing.customers table like the sales.customers table and copy all rows from 
	-- the sales.customers table to the marketing.customers table

	SELECT * INTO 
    marketing.customers
	FROM sales.customers;


	-- Third, query data from the the marketing.customers table to verify the copy:

	SELECT * FROM marketing.customers;


	-- Case 2: Using SQL Server SELECT INTO statement to copy table across databases

	-- step 1: create a new database named TestDb for testing:

	CREATE DATABASE TestDb;
	GO


	--  copy the sales.customers from the current database (BikeStores) to the TestDb.dbo.customers table. 

	SELECT customer_id, first_name, last_name, email
	INTO TestDb.dbo.customers
	FROM sales.customers
	WHERE state = 'CA';


	-- query data from the TestDb.dbo.customers to verify the copy:

	SELECT * FROM TestDb.dbo.customers;


	-- Section Basic: Rename Table => change the current name of the table.

	-- First, create a new table named sales.contr for storing sales contract’s data:

	CREATE TABLE sales.contr (
		contract_no INT IDENTITY PRIMARY KEY,
		start_date DATE NOT NULL,
		expired_date DATE,
		customer_id INT,
		amount DECIMAL (10, 2)
	); 


	-- use the sp_rename stored procedure to rename the sales.contr table to contracts

	EXEC sp_rename 'sales.contr', 'contracts';


	-- Section Basic: Temporary Tables => Temporary tables are tables that exist temporarily on the SQL Server.

	-- Case 1: Create temporary tables using SELECT INTO statement

	SELECT product_name, list_price
	INTO #trek_products --- temporary table
	FROM production.products
	WHERE brand_id = 9;


	-- Case 2: Second way to create a temporary table is to use the CREATE TABLE statement:

	CREATE TABLE #haro_products (
		product_name VARCHAR(MAX),
		list_price DEC(10,2)
	);

	--  insert data into this table as a regular table:

	INSERT INTO #haro_products
	SELECT product_name, list_price
	FROM production.products
	WHERE brand_id = 2;

	-- check the result

	SELECT * FROM #haro_products;


	-- Global Temporary Tables

	-- The following statements first create a global temporary table named ##heller_products and 
	-- then populate data from the production.products table into this table:

	CREATE TABLE ##heller_products (
		product_name VARCHAR(MAX),
		list_price DEC(10,2)
	);

	INSERT INTO ##heller_products
	SELECT product_name,list_price
	FROM production.products
	WHERE brand_id = 3;


	-- Section Basic: SYNONYMS => a synonym is an alias or alternative name for a database object 
	-- such as a table, view, stored procedure, user-defined function, and sequence.

	-- Case 1: Creating a synonym within the same database example.

	CREATE SYNONYM orders FOR sales.orders;

	-- Use case : The following query uses the orders synonym instead of sales.orders table

	SELECT * FROM orders;
	

	-- Case 2: Creating a synonym for a table in another database

	-- step 1: First, create a new database named test and set the current database to test:

	CREATE DATABASE test;
	GO

	USE test;
	GO


	-- step 2: Next, create a new schema named purchasing inside the test database:

	CREATE SCHEMA purchasing;
	GO


	-- step 3: Then, create a new table in the purchasing schema of the test database:

	CREATE TABLE purchasing.suppliers (
		supplier_id   INT PRIMARY KEY IDENTITY, 
		supplier_name NVARCHAR(100) NOT NULL
	);


	-- step 4: from the BikeStores database, create a synonym for the purchasing.suppliers table in the test database:

	CREATE SYNONYM suppliers 
	FOR test.purchasing.suppliers;


	-- Use case: Finally, from the BikeStores database, refer to the test.purchasing.suppliers table using the suppliers synonym:

	SELECT * FROM suppliers;


	--   Listing synonyms using Transact-SQL command:

	SELECT name, base_object_name, type
	FROM sys.synonyms
	ORDER BY name;


	-- To remove a synonym, you use the DROP SYNONYM statement with the following syntax:

	DROP SYNONYM IF EXISTS orders;


	-- Section Basic:  GUID => Globally Unique IDentifier(GUID) guaranteed to be unique across tables, databases & even servers.
	-- If we execute the below statement several times, we will see different value every time.

	SELECT 
    NEWID() AS GUID;


	-- The following statements declare a variable with type UNIQUEIDENTIFIER and assign it a GUID value generated 
	-- by the NEWID() function.

	DECLARE @id UNIQUEIDENTIFIER;
	SET @id = NEWID();
	SELECT @id AS GUID;


	-- Section Basic: Constraints => PRIMARY KEY => It is a column or a group of columns that uniquely identifies 
	-- each row in a table.

	-- Case 1: The following example creates a table with a primary key that consists of one column:

	CREATE TABLE sales.activities (
		activity_id INT PRIMARY KEY IDENTITY,
		activity_name VARCHAR (255) NOT NULL,
		activity_date DATE NOT NULL
	);


	-- Case 2: The following statement creates a new table named sales.participants whose primary key consists 
	-- of two columns:

	CREATE TABLE sales.participants(
		activity_id int,
		customer_id int,
		PRIMARY KEY(activity_id, customer_id)
	);


	-- Case 3: Create a PRIMARY KEY later to a table if not created at the time of table creation.

	-- step 1: The following statement creates a table without a primary key:

	CREATE TABLE sales.events(
		event_id INT NOT NULL,
		event_name VARCHAR(255),
		start_date DATE NOT NULL,
		duration DEC(5,2)
	);


	-- step 2: To make the event_id column as the primary key, you use the following ALTER TABLE statement:

	ALTER TABLE sales.events 
	ADD PRIMARY KEY(event_id);


	-- Section Basic: FOREIGN KEY => It is a column or a group of columns in one table that uniquely identifies 
	-- a row of another table.

	-- step 1: Create following vendor_groups and vendors tables:

	-- Create an schema procurement
	CREATE SCHEMA procurement
	GO

	CREATE TABLE procurement.vendor_groups (
		group_id INT IDENTITY PRIMARY KEY,
		group_name VARCHAR (100) NOT NULL
	);

	CREATE TABLE procurement.vendors (
        vendor_id INT IDENTITY PRIMARY KEY,
        vendor_name VARCHAR(100) NOT NULL,
        group_id INT NOT NULL,
	);


	-- step 2: The following statements drop the  vendors table and recreate it with a FOREIGN KEY constraint:

	DROP TABLE procurement.vendors;

	CREATE TABLE procurement.vendors (
        vendor_id INT IDENTITY PRIMARY KEY,
        vendor_name VARCHAR(100) NOT NULL,
        group_id INT NOT NULL,
        CONSTRAINT fk_group FOREIGN KEY (group_id) 
        REFERENCES procurement.vendor_groups(group_id)
	);

	-- step 3: First, insert some rows into the vendor_groups and vendors tables:

	INSERT INTO procurement.vendor_groups(group_name)
	VALUES	('Third-Party Vendors'),
			('Interco Vendors'),
			('One-time Vendors');

	INSERT INTO procurement.vendors(vendor_name, group_id)
	VALUES	('ABC Corp',1);


	-- ERR: try to insert a new vendor whose vendor group does not exist in the vendor_groups table:

	INSERT INTO procurement.vendors(vendor_name, group_id)
	VALUES	('XYZ Corp',4);


	-- Section Basic: NOT NULL => This constraint simply specify that a column must not assume the NULL.

	-- The following example creates a table with NOT NULL constraints for the columns: first_name, last_name, and email:

	CREATE SCHEMA hr;
	GO

	CREATE TABLE hr.persons(
		person_id INT IDENTITY PRIMARY KEY,
		first_name VARCHAR(255) NOT NULL,
		last_name VARCHAR(255) NOT NULL,
		email VARCHAR(255) NOT NULL,
		phone VARCHAR(20)
	);


	-- Add NOT NULL constraint to an existing column

	UPDATE hr.persons
	SET phone = '(408) 123 4567'
	WHERE phone IS NULL;

	ALTER TABLE hr.persons
	ALTER COLUMN phone VARCHAR(20) NOT NULL;


	-- Removing NOT NULL constraint from an existing column

	ALTER TABLE hr.persons
	ALTER COLUMN phone VARCHAR(20) NULL;


	-- Section Basic: UNIQUE Constraint => allow you to ensure that the data stored in a column, 
	-- or a group of columns, is unique among the rows in a table.

	-- The following statement creates a table whose data in the email column is unique among 
	-- the rows in the hr.persons table:

	CREATE TABLE hr.persons(
		person_id INT IDENTITY PRIMARY KEY,
		first_name VARCHAR(255) NOT NULL,
		last_name VARCHAR(255) NOT NULL,
		email VARCHAR(255) UNIQUE
	);

	-- We can also define the UNIQUE constraint as a table constraint, like this:

	CREATE TABLE hr.persons(
		person_id INT IDENTITY PRIMARY KEY,
		first_name VARCHAR(255) NOT NULL,
		last_name VARCHAR(255) NOT NULL,
		email VARCHAR(255),
		UNIQUE(email)
	);


	-- The following statement inserts a new row into the hr.persons table:

	INSERT INTO hr.persons(first_name, last_name, email)
	VALUES	('John','Doe','j.doe@bike.stores');


	-- ERR: The statement works as expected. However, the following statement fails due to the duplicate email:

	INSERT INTO hr.persons(first_name, last_name, email)
	VALUES	('Jane','Doe','j.doe@bike.stores');


	-- UNIQUE constraints for a group of columns

	-- The following example creates a UNIQUE constraint that consists of two columns person_id and skill_id:

	CREATE TABLE hr.person_skills (
		id INT IDENTITY PRIMARY KEY,
		person_id int,
		skill_id int,
		updated_at DATETIME,
		UNIQUE (person_id, skill_id)
	);

	-- The following statement adds a UNIQUE constraint to the email column:

	ALTER TABLE hr.persons
	ADD CONSTRAINT unique_email UNIQUE(email);

	ALTER TABLE hr.persons
	ADD CONSTRAINT unique_phone UNIQUE(phone); 


	ALTER Table hr.persons ADD phone INT UNIQUE;

	-- The following statement removes the unique_phone constraint from the hr.person table:

	ALTER TABLE hr.persons
	DROP CONSTRAINT unique_phone;


	-- Section Basic: CHECK Constraint => allows you to specify the values in a column that must satisfy a Boolean expression.

	CREATE SCHEMA test;
	GO

	CREATE TABLE test.products(
		product_id INT IDENTITY PRIMARY KEY,
		product_name VARCHAR(255) NOT NULL,
		unit_price DEC(10,2) CHECK(unit_price > 0)
	);


	-- We can also assign the constraint a separate name by using the CONSTRAINT keyword as follows:

	CREATE TABLE test.products(
		product_id INT IDENTITY PRIMARY KEY,
		product_name VARCHAR(255) NOT NULL,
		unit_price DEC(10,2) CONSTRAINT positive_price CHECK(unit_price > 0)
	);


	-- CHECK CONSTRAINT

	INSERT INTO test.products(product_name, unit_price)
	VALUES ('Awesome Free Bike', 0);

	-- We can insert a product whose unit price is NULL as shown in the following query:

	INSERT INTO test.products(product_name, unit_price)
	VALUES ('Another Awesome Bike', NULL);


	-- CHECK constraint referring to multiple columns

	-- We can  store a regular and discounted prices in the  test.products table and you want to ensure 
	-- that the discounted price is always lower than the regular price:

	CREATE TABLE test.product(
		product_id INT IDENTITY PRIMARY KEY,
		product_name VARCHAR(255) NOT NULL,
		unit_price DEC(10,2) CHECK(unit_price > 0),
		discounted_price DEC(10,2) CHECK(discounted_price > 0),
		CHECK(discounted_price < unit_price)
	);

	ALTER TABLE test.products
	ADD discounted_price DEC(10,2)
	CHECK(discounted_price > 0);


	ALTER TABLE test.products
	ADD CONSTRAINT valid_price 
	CHECK(unit_price > discounted_price);


	-- Add CHECK constraints to an existing table

	ALTER TABLE test.products
	ADD CONSTRAINT positive_price CHECK(unit_price > 0);


	-- To remove a CHECK constraint, you use the ALTER TABLE DROP CONSTRAINT statement:

	ALTER TABLE test.products
	DROP CONSTRAINT positive_price;


	-- Disable CHECK constraints for insert or update

	ALTER TABLE test.products
	NOCHECK CONSTRAINT valid_price;


	-- Section Basic: CASE => CASE expression evaluates a list of conditions and returns one of the multiple 
	-- specified results

	-- 01. Simple Case Example:  Using simple CASE expression in the SELECT clause example
	-- This example uses the COUNT() function with the GROUP BY clause to return the number orders for each order’s status

	SELECT order_status, COUNT(order_id) order_count
	FROM sales.orders
	WHERE YEAR(order_date) = 2018
	GROUP BY order_status;

	-- The values in the order_status column are numbers, which is not meaningful in this case. 
	-- To make the output more understandable, you can use the simple CASE expression as shown in the following query

	SELECT 
		CASE Order_Status
			WHEN 1 THEN 'PENDING'
			WHEN 2 THEN 'Processing'
			WHEN 3 THEN 'Rejected'
			WHEN 4 THEN 'Completed'
		END AS Order_Status,
		COUNT(order_id) Order_Count
	FROM sales.orders
	WHERE YEAR(order_date) = 2018
	GROUP BY Order_Status;


	-- Using simple CASE expression in aggregate function example

	SELECT    
    SUM(CASE
            WHEN order_status = 1
            THEN 1
            ELSE 0
        END) AS 'Pending', 
    SUM(CASE
            WHEN order_status = 2
            THEN 1
            ELSE 0
        END) AS 'Processing', 
    SUM(CASE
            WHEN order_status = 3
            THEN 1
            ELSE 0
        END) AS 'Rejected', 
    SUM(CASE
            WHEN order_status = 4
            THEN 1
            ELSE 0
        END) AS 'Completed', 
    COUNT(*) AS Total
	FROM sales.orders
	WHERE YEAR(order_date) = 2018;


	-- 02. searched CASE expression: The following statement uses the searched CASE expression to classify 
	-- sales order by order value

	SELECT    
    o.order_id, 
    SUM(quantity * list_price) order_value,
    CASE
        WHEN SUM(quantity * list_price) <= 500 
            THEN 'Very Low'
        WHEN SUM(quantity * list_price) > 500 AND 
            SUM(quantity * list_price) <= 1000 
            THEN 'Low'
        WHEN SUM(quantity * list_price) > 1000 AND 
            SUM(quantity * list_price) <= 5000 
            THEN 'Medium'
        WHEN SUM(quantity * list_price) > 5000 AND 
            SUM(quantity * list_price) <= 10000 
            THEN 'High'
        WHEN SUM(quantity * list_price) > 10000 
            THEN 'Very High'
    END order_priority
	FROM sales.orders o
	INNER JOIN sales.order_items i ON i.order_id = o.order_id
	WHERE YEAR(order_date) = 2018
	GROUP BY o.order_id;


	-- Section Basic: COALESCE => COALESCE expression accepts a number of arguments, evaluates them in sequence,
	-- and returns the first non-null argument.

	-- Using SQL Server COALESCE expression with character string data example

	SELECT COALESCE(NULL, 'Hi', 'Hello', NULL) result;

	-- Real-life case: The following query returns first name, last name, phone, and email of all customers:

	SELECT first_name, last_name, phone, email
	FROM sales.customers
	ORDER BY first_name, last_name;

	-- The phone column will have NULL if the customer does not have the phone number recorded in the sales.customers 
	-- table. To make the output more business friendly, you can use the COALESCE expression to substitute NULL by  
	-- the string N/A (not available) as shown in the following query:

	SELECT first_name, last_name, COALESCE(phone,'N/A') phone, email
	FROM sales.customers
	ORDER BY first_name, last_name;

	-- Using SQL Server COALESCE expression to use the available data
	-- Step 1: create a new table named salaries that stores the employee’s salaries:

	CREATE TABLE salaries (
		staff_id INT PRIMARY KEY,
		hourly_rate decimal,
		weekly_rate decimal,
		monthly_rate decimal,
		CHECK(
				hourly_rate IS NOT NULL OR 
				weekly_rate IS NOT NULL OR 
				monthly_rate IS NOT NULL
			 )
		);

	-- Each staff can have only one rate either hourly, weekly, or monthly.
	-- Step 2:  insert some rows into the salaries table:

	INSERT INTO salaries(
        staff_id, 
        hourly_rate, 
        weekly_rate, 
        monthly_rate
    )
	VALUES
    (1,20, NULL,NULL),
    (2,30, NULL,NULL),
    (3,NULL, 1000,NULL),
    (4,NULL, NULL,6000),
    (5,NULL, NULL,6500);

	-- Step 3: query data from the salaries table:

	SELECT staff_id, hourly_rate, weekly_rate, monthly_rate
	FROM salaries
	ORDER BY staff_id;

	-- Step 4: calculate monthly for each staff using the COALESCE expression as shown in the following query:

	SELECT
    staff_id,
    COALESCE(
        hourly_rate*22*8, 
        weekly_rate*4, 
        monthly_rate
    ) monthly_salary
	FROM salaries;


	-- Section Basic: NULLIF => The NULLIF expression accepts two arguments and returns NULL if two arguments 
	-- are equal. Otherwise, it returns the first expression.

	-- This example returns NULL because the first argument equals the second one:

	SELECT NULLIF(10, 10) result;

	-- However, the following example returns the first argument because two arguments are not equal:
	
	SELECT NULLIF(20, 10) result;

	-- This example returns the first argument because both arguments are not the same:

	SELECT NULLIF('Hello', 'Hi') result;

	-- REal-Life Case: Using NULLIF expression to translate a blank string to NULL

	-- The NULLIF expression comes in handy when you’re working with legacy data that contains a mixture of null 
	-- and empty strings in a column. Consider the following example.

	-- Step 1: First, create a new table named sales.leads to store the sales leads:

	CREATE TABLE sales.leads (
		lead_id    INT	PRIMARY KEY IDENTITY, 
		first_name VARCHAR(100) NOT NULL, 
		last_name  VARCHAR(100) NOT NULL, 
		phone      VARCHAR(20), 
		email      VARCHAR(255) NOT NULL
	);

	-- Step 2: Insert three rows into the sales.leads table:

	INSERT INTO sales.leads 
	( first_name, last_name, phone, email )
	VALUES
	( 'John', 'Doe', '(408)-987-2345', 'john.doe@example.com'),
	( 'Jane', 'Doe', '',  'jane.doe@example.com'),
	( 'David', 'Doe', NULL, 'david.doe@example.com');

	-- Step 3: query data from the sales.leads table:

	SELECT lead_id, first_name, last_name, phone, email
	FROM sales.leads
	ORDER BY lead_id;

	-- The phone column is a nullable column. If the phone of a lead is not known at the time of recording,

	-- the phone column will have NULL. However, from the output, the second row has an empty string in the phone  
	-- column due to the data entry mistake. Note that you may encounter a situation like this a lot if you are
	--  working with legacy databases.

	-- Step 4: the NULLIF expression:

	SELECT lead_id, first_name, last_name, phone, email
	FROM sales.leads
	WHERE NULLIF(phone,'') IS NULL;


	-- Section Basic: Find Duplicates => Find Duplicate Records in the database.

	-- Step 1: Setting up a sample table: create a new table named t1

	DROP TABLE IF EXISTS t1;
	CREATE TABLE t1 (
		id INT IDENTITY(1, 1), 
		a  INT, 
		b  INT, 
		PRIMARY KEY(id)
	);

	-- Step 2: 

	INSERT INTO
		t1(a,b)
	VALUES
		(1,1),
		(1,2),
		(1,3),
		(2,1),
		(1,2),
		(1,3),
		(2,1),
		(2,2);
	
	-- Using GROUP BY clause to find duplicates in a table

	SELECT a, b, 
    COUNT(*) occurrences
	FROM t1
	GROUP BY a, b
	HAVING COUNT(*) > 1;


	-- Using ROW_NUMBER() function to find duplicates in a table

	WITH cte AS (
		SELECT a, b, 
			ROW_NUMBER() OVER (
            PARTITION BY a,b
            ORDER BY a,b) rownum
		FROM t1
	) 
	SELECT * 
	FROM cte 
	WHERE rownum > 1;


	-- Section Basic: DELETE DUPLICATES => Delete all Duplicate records.

	-- Step 1: create a new table named sales.contacts as follows:

	DROP TABLE IF EXISTS sales.contacts;
	CREATE TABLE sales.contacts(
		contact_id INT IDENTITY(1,1) PRIMARY KEY,
		first_name NVARCHAR(100) NOT NULL,
		last_name NVARCHAR(100) NOT NULL,
		email NVARCHAR(255) NOT NULL,
	);

	-- Step 2: insert some rows into the sales.contacts table:

	INSERT INTO sales.contacts
		(first_name,last_name,email) 
	VALUES
		('Syed','Abbas','syed.abbas@example.com'),
		('Catherine','Abel','catherine.abel@example.com'),
		('Kim','Abercrombie','kim.abercrombie@example.com'),
		('Kim','Abercrombie','kim.abercrombie@example.com'),
		('Kim','Abercrombie','kim.abercrombie@example.com'),
		('Hazem','Abolrous','hazem.abolrous@example.com'),
		('Hazem','Abolrous','hazem.abolrous@example.com'),
		('Humberto','Acevedo','humberto.acevedo@example.com'),
		('Humberto','Acevedo','humberto.acevedo@example.com'),
		('Pilar','Ackerman','pilar.ackerman@example.com');

	-- Step 3: query data from the sales.contacts table:

	SELECT contact_id, first_name, last_name, email
	FROM sales.contacts;

	-- Step 4: The following statement uses a common table expression (CTE) to delete duplicate rows:

	WITH cte AS (
		SELECT contact_id, first_name, last_name, email, 
        ROW_NUMBER() OVER (
            PARTITION BY 
                first_name, 
                last_name, 
                email
            ORDER BY 
                first_name, 
                last_name, 
                email
        ) row_num
		FROM sales.contacts
	)
	DELETE FROM cte
	WHERE row_num > 1;

	-- Step 5: Check if all duplicate rows are deleted.

	SELECT contact_id, first_name, last_name, email
	FROM sales.contacts
	ORDER BY first_name, last_name, email;


-----------------------------------------------------------------------------------------------------------------
							
							-- SQL SERVER VIEWS --


	-- Section VIEWS: CREATE VIEW => -	A view is a named query stored in the database catalogue that
-	-- allows you to refer to it later. Views in SQL are kind of virtual tables.

	-- Creating a simple view example
	-- The following statement creates a view named daily_sales based on the orders, order_items, and products tables:

	CREATE VIEW sales.daily_sales
	AS
		SELECT	year(order_date) AS y,
				month(order_date) AS m,
				day(order_date) AS d,
				p.product_id,
				product_name,
				quantity * i.list_price AS sales
		FROM sales.orders AS o
		INNER JOIN sales.order_items AS i
		ON o.order_id = i.order_id
		INNER JOIN production.products AS p
		ON p.product_id = i.product_id;


		-- Create a view Product_Catalogue

		CREATE VIEW sales.product_catalog
		AS
			SELECT 
				product_name, 
				category_name, 
				brand_name,
				list_price
			FROM production.products p
			INNER JOIN production.categories c 
			ON c.category_id = p.category_id
			INNER JOIN production.brands b
			ON b.brand_id = p.brand_id;


	-- CHECK VIEW 

	SELECT * FROM sales.daily_sales
	ORDER BY y, m, d, product_name;


	-- Redefining the view example
	-- To add the customer name column to the sales.daily_sales view, you use the CREATE VIEW OR ALTER as follows:

	CREATE OR ALTER VIEW sales.daily_sales (
		year,
		month,
		day,
		customer_name,
		product_id,
		product_name
		sales
	)
	AS
		SELECT	year(order_date) AS y,
				month(order_date) AS m,
				day(order_date) AS d,
				concat( first_name, ' ', last_name ),
				p.product_id,
				product_name,
				quantity * i.list_price AS sales
		FROM sales.orders AS o
		INNER JOIN sales.order_items AS i
		ON o.order_id = i.order_id
		INNER JOIN production.products AS p
		ON p.product_id = i.product_id;


	-- Creating a view using aggregate functions example
	-- The following statement creates a view named staff_salesthose summaries the sales by staffs 
	-- and years using the SUM() aggregate function:

	CREATE VIEW sales.staff_sales (
		first_name, 
        last_name,
        year, 
        amount
	)
	AS 
    SELECT 
        first_name,
        last_name,
        YEAR(order_date),
        SUM(list_price * quantity) amount
    FROM sales.order_items i
    INNER JOIN sales.orders o
    ON i.order_id = o.order_id
    INNER JOIN sales.staffs s
	ON s.staff_id = o.staff_id
    GROUP BY first_name, last_name, YEAR(order_date);

	-- The following statement returns the contents of the view:

	SELECT * FROM sales.staff_sales
	ORDER BY first_name, last_name, year;


	-- Section VIEWS: Rename View => used to rename a view in a SQL Server Database.

	EXEC sp_rename 
    @objname = 'sales.daily_sales',
    @newname = 'sales.daily_sales_report';


	-- Section VIEWS: List Views => used to list all views in a SQL Server Database.

	-- The following stored procedure wraps the query above to list all views in the SQL Server Database based 
	-- on the input schema name and view name:

	CREATE PROC usp_list_views(
		@schema_name AS VARCHAR(MAX)  = NULL,
		@view_name AS VARCHAR(MAX) = NULL
	)
	AS
		SELECT OBJECT_SCHEMA_NAME(v.object_id) schema_name,
			   v.name view_name
		FROM sys.views as v
		WHERE (@schema_name IS NULL OR 
		OBJECT_SCHEMA_NAME(v.object_id) LIKE '%' + @schema_name + '%') AND
		(@view_name IS NULL OR
		v.name LIKE '%' + @view_name + '%');

	-- We want to know the views that contain the word sales, you can call the stored procedure usp_list_views:

	EXEC usp_list_views @view_name = 'sales';


	-- Section VIEWS: Get Information About a View => Various ways to get the information of a view.

	-- Method 1: Getting the view information using the sql.sql_module catalog

	SELECT
		definition,
		uses_ansi_nulls,
		uses_quoted_identifier,
		is_schema_bound
	FROM sys.sql_modules
	WHERE object_id = object_id( 'sales.staff_sales' );


	-- Method 2: Getting view information using the sp_helptext stored procedure.

	EXEC sp_helptext 'sales.staff_sales' ;


	-- Method 3: Getting the view information using OBJECT_DEFINITION() function.

	SELECT OBJECT_DEFINITION( OBJECT_ID ( 'sales.product_catalog' ) ) view_info;


	-- Section VIEWS: DROP VIEW => Used to remove an existing view.

	-- 01. Removing one view example

	DROP VIEW IF EXISTS sales.daily_sales;

	-- 02. Removing multiple views example

	DROP VIEW IF EXISTS 
    sales.staff_sales, 
    sales.product_catalogs;


	-- Section VIEWS: Indexed View =>  indexed views are materialized views that stores data physically like 
	-- a table hence may provide some the performance benefit if they are used appropriately.

	-- Create a sample database tables

	CREATE TABLE production.categories (
		category_id INT IDENTITY (1, 1) PRIMARY KEY,
		category_name VARCHAR (255) NOT NULL
	);


	CREATE TABLE production.brands (
		brand_id INT IDENTITY (1, 1) PRIMARY KEY,
		brand_name VARCHAR (255) NOT NULL
	);


	CREATE TABLE production.products (
		product_id INT IDENTITY (1, 1) PRIMARY KEY,
		product_name VARCHAR (255) NOT NULL,
		brand_id INT NOT NULL,
		category_id INT NOT NULL,
		model_year SMALLINT NOT NULL,
		list_price DECIMAL (10, 2) NOT NULL,
	FOREIGN KEY (category_id) 
        REFERENCES production.categories (category_id) 
        ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (brand_id) 
        REFERENCES production.brands (brand_id) 
        ON DELETE CASCADE ON UPDATE CASCADE
	);


	-- Creating Indexed view

	CREATE VIEW production.product_master
	WITH SCHEMABINDING
	AS 
		SELECT
			product_id,
			product_name,
			model_year,
			list_price,
			brand_name,
			category_name
		FROM production.products p
		INNER JOIN production.brands b 
		ON b.brand_id = p.brand_id
		INNER JOIN production.categories c 
		ON c.category_id = p.category_id;

		-- Before creating a unique clustered index for the view, let’s examine the query I/O cost statistics 
		-- by querying data from a regular view and using the SET STATISTICS IO command:

		SET STATISTICS IO ON
		GO

		SELECT * FROM production.product_master
		ORDER BY product_name;
		GO 


		-- This statement materializes the view, making it have a physical existence in the database.

		CREATE UNIQUE CLUSTERED INDEX ucidx_product_id 
		ON production.product_master(product_id);

		-- You can also add a non-clustered index on the product_name column of the view:

		CREATE NONCLUSTERED INDEX ucidx_product_name
		ON production.product_master(product_name);


-----------------------------------------------------------------------------------------------------------------------

									-- SQL SERVER INDEXES --



	-- Section Indexes: Clustered Indexes => clustered index and how to define a clustered index for a table.


	-- The following statement creates a new table named production.parts that consists of two columns 
	-- part_id and part_name & insert data into it.

	CREATE TABLE production.parts(
		part_id   INT NOT NULL, 
		part_name VARCHAR(100)
	);

	INSERT INTO production.parts(part_id, part_name)
	VALUES	(1,'Frame'),
			(2,'Head Tube'),
			(3,'Handlebar Grip'),
			(4,'Shock Absorber'),
			(5,'Fork');


	-- SELECT statement finds the part with id 5:

	SELECT * FROM production.parts
	WHERE part_id = 5;

	-- create a new table named production.part_prices with a primary key that includes three columns: 
	-- part_id and valid_from & price.

	CREATE TABLE production.part_prices(
		part_id int,
		valid_from date,
		price decimal(18,4) not null,
		PRIMARY KEY(part_id, valid_from) 
	);

	-- Using SQL Server CREATE CLUSTERED INDEX statement to create a clustered index.

	CREATE CLUSTERED INDEX idx_parts_id
	ON production.parts (part_id);  

	-- Section Indexes: non-clustered indexes => How to create nonclustered indexes for tables.

	-- 01. Using the SQL Server CREATE INDEX statement to create a nonclustered index for one column example

	SELECT customer_id, city
	FROM sales.customers
	WHERE city = 'Atwater';


	-- To improve the speed of this query, you can create a new index named ix_customers_city for the city column:

	CREATE INDEX idx_customers_city
	ON sales.customers(city);


	-- 02. Using SQL Server CREATE INDEX statement to create a nonclustered index for multiple columns example

	-- The following statement finds the customer whose last name is Berg and first name is Monika:

	SELECT customer_id, first_name, last_name
	FROM sales.customers
	WHERE last_name = 'Berg' AND 
    first_name = 'Monika';


	-- To speed up the retrieval of data, you can create a nonclustered index that includes both 
	-- last_name and first_name columns:

	CREATE INDEX idx_Customer_Name
	ON sales.customers(last_name, first_name);
	

	-- This statement finds customers whose first name is Adam. It also leverages the ix_customer_name index. 
	-- But it needs to scan the whole index for searching, which is slower than index seek.

	SELECT customer_id, first_name, last_name
	FROM sales.customers
	WHERE first_name = 'Adam';


	-- Section Index: RENAME INDEX => Rename the given index name.

	EXEC sp_rename 
        'sales.customers.idx_customers_city',
        'idx_cust_city' ,
        'INDEX';


	-- Section Index: Disable Index => Disable the given index.

	-- 01. Disabling an index (single Index) example

	ALTER INDEX idx_cust_city 
	ON sales.customers 
	DISABLE;

	-- 02. Disabling all indexes of a table example

	ALTER INDEX ALL ON sales.customers
	DISABLE;

	-- Err: Hence, you cannot access data in the table anymore.

	SELECT * FROM sales.customers;


	--Section Index: Enable Indexes => Enable all disabled indexes.

	-- 01. This statement uses the ALTER INDEX statement to “enable” or rebuild an index on a table:

	ALTER INDEX idx_cust_city
	ON sales.customers  
	REBUILD;

	-- 02. This statement uses the CREATE INDEX statement to enable the disabled index and recreate it:

	CREATE INDEX idx_Customer_Name
	ON sales.customers(last_name, first_name)
	WITH(DROP_EXISTING=ON)

	-- 03. The following statement uses the ALTER INDEX statement to enable all disabled indexes on a table:

	ALTER INDEX ALL ON sales.customers
	REBUILD;

	-- 04. This statement uses the DBCC DBREINDEX to enable an index on a table:

	DBCC DBREINDEX (sales.customers, idx_cust_city);

	-- 05. This statement uses the DBCC DBREINDEX to enable all indexes on a table:

	DBCC DBREINDEX (sales.customers, " ");  


	-- Section Index: Unique Index => enforce the uniqueness of values in one or more columns of a table.

	-- 01. Creating a SQL Server unique index for one column example

	-- step 1: This query finds the customer with the email 'caren.stephens@msn.com' RECHECK AFTER CREATING INDEX:

	SELECT customer_id, email 
	FROM sales.customers
	WHERE email = 'caren.stephens@msn.com';

	-- step 2: We need to check duplicate values in the email column first:

	SELECT email, COUNT(email) AS email_address_repeat_count
	FROM sales.customers
	GROUP BY email
	HAVING COUNT(email) > 1;

	-- step 3: create a unique index for the email column of the sales.customers table:

	CREATE UNIQUE INDEX ix_cust_email 
	ON sales.customers(email);

	-- 02. Creating a SQL Server unique index for multiple columns example

	-- step 1: First, create a table named t1 that has two columns for the demonstration:

	CREATE TABLE tx1 (
		a INT, 
		b INT
	);

	-- step 2: Next, create a unique index that includes both a and b columns:

	CREATE UNIQUE INDEX idx_uniq_ab 
	ON tx1(a, b);

	-- step 3: Then, insert a new rows into the t1 table:

	INSERT INTO tx1(a,b) VALUES(1,1);
	INSERT INTO tx1(a,b) VALUES(1,2);
	INSERT INTO tx1(a,b) VALUES(2,2);
	INSERT INTO tx1(a,b) VALUES(2,3);

	-- step 4: Finally, insert a row that already exists into the tx1 table:

	INSERT INTO tx1(a,b) VALUES(2,2);

	--step 5: ERR check for duplicate null. NOT ALLOWED.

	INSERT INTO tx1(a,b) VALUES(NULL, 2);
	INSERT INTO tx1(a,b) VALUES(NULL, 2);

	select * from tx1;
	

	-- Section Index: DROP INDEX => removes one or more indexes from the current database. 

	-- 01. Using SQL Server DROP INDEX to remove one index example

	DROP INDEX IF EXISTS ix_cust_email
	ON sales.customers;

	-- 02. Using SQL Server DROP INDEX to remove multiple indexes example

	DROP INDEX	idx_cust_city ON sales.customers,
				idx_Customer_Name ON sales.customers;


	-- Section Index: Indexes with Included Columns => use indexes with included columns to improve the speed of queries.

	-- The following statement creates a unique index for the email column:

	CREATE UNIQUE INDEX ix_cust_email 
	ON sales.customers(email);

	-- This statement finds the customer whose email is 'aide.franco@msn.com':

	SELECT customer_id, email
	FROM sales.customers
	WHERE email = 'aide.franco@msn.com';

	-- However, consider the following example:
	-- In this execution plan:

	 -- First, the query optimizer uses the index seek on the non-clustered index ix_cust_email to find 
	 -- the email and customer_id.

	 -- Second, the query optimizer uses the key lookup on the clustered index of the sales.customers table 
	 -- to find the first name and last name of the customer by customer id.

	 -- Third, for each row found in the non-clustered index, it matches with rows found in the clustered index 
	 -- using nested loops.

	SELECT first_name, last_name, email
	FROM sales.customers
	WHERE email = 'aide.franco@msn.com';


	-- step 1: First, drop the index ix_cust_email from the sales.customers table:

	DROP INDEX ix_cust_email 
	ON sales.customers;

	-- step 2: Then, create a new index ix_cust_email_inc that includes two columns first name and last name:

	CREATE UNIQUE INDEX ix_cust_email_inc
	ON sales.customers(email)
	INCLUDE(first_name,last_name);

	-- Now, the query optimizer will solely use the non-clustered index to return the requested data of the query:


	--Section Index: Filtered Indexes => to create optimized non-clustered indexes for tables.

	-- The sales.customers table has the phone column which contains many NULL values:

	SELECT 
    SUM(CASE
            WHEN phone IS NULL
            THEN 1
            ELSE 0
        END) AS [Has Phone], 
    SUM(CASE
            WHEN phone IS NULL
            THEN 0
            ELSE 1
        END) AS [No Phone]
	FROM sales.customers;

	-- This phone column is a good candidate for the filtered index.
	-- This statement creates a filtered index for the phone column of the sales.customers table:

	CREATE INDEX ix_cust_phone
	ON sales.customers(phone)
	WHERE phone IS NOT NULL;

	-- The following query finds the customer whose phone number is (281) 363-3309:

	SELECT first_name, last_name, phone
	FROM sales.customers
	WHERE phone = '(281) 363-3309';

	-- to improve the key lookup, you can use an index with included columns, which includes both 
	-- first_name and last_name columns in the index:

	CREATE INDEX idx_cust_phone
	ON sales.customers(phone)
	INCLUDE (first_name, last_name)
	WHERE phone IS NOT NULL;


	-- Section Index: Indexes on Computed Columns => simulate function-based indexes in SQL Server using indexes 
	-- on computed columns.

	-- Example: to search for customers based on local parts of their email addresses, you use these steps:

	-- Step 1: First, add a new computed column to the sales.customers table:

	ALTER TABLE sales.customers
	ADD email_local_part AS SUBSTRING(email, 0, CHARINDEX('@', email, 0));

	-- Step 2: Then, create an index on the email_local_part column:

	CREATE INDEX ix_cust_email_local_part
	ON sales.customers(email_local_part);

	-- Step 3: Now, you can use the email_local_part column instead of the expression in the WHERE clause 
	-- to find customers by the local part of the email address:

	SELECT first_name, last_name, email
	FROM sales.customers
	WHERE email_local_part = 'garry.espinoza';


------------------------------------------------------------------------------------------------------------------------------------


							-- SQL SERVER STORED PROCEDURES --


	-- Section Stored Procedure: Create stored procedure => Creating a simple stored procedure

	-- To create a stored procedure that wraps SELECT query, we can use the CREATE PROCEDURE statement as follows:

	CREATE PROCEDURE uspProductList
	AS
		BEGIN
			SELECT product_name, list_price
			FROM production.products
			ORDER BY product_name;
		END;

	-- Executing a stored procedure

	EXECUTE uspProductList;
	-- EXEC uspProductList;

	-- Deleting a stored procedure:

	DROP PROCEDURE uspProductList;
	-- DROP PROC uspProductList;    


	-- Section Stored Procedure: Stored Procedure Parameters =>  stored procedure which allows you to pass 
	-- one or more values to it.

	-- Create a stored procedure that wraps this query using the CREATE PROCEDURE statement:

	CREATE PROCEDURE uspFindProducts
	AS
		BEGIN
			SELECT product_name, list_price
			FROM production.products
			ORDER BY list_price;
		END;


	-- We can add a parameter to the stored procedure to find the products whose list prices are greater 
	-- than an input price.

	ALTER PROCEDURE uspFindProducts(@min_list_price AS DECIMAL)
	AS
		BEGIN
			SELECT product_name, list_price
			FROM production.products
			WHERE list_price >= @min_list_price
			ORDER BY list_price;
		END;

	-- Check result

	EXEC uspFindProducts 100;

	-- Creating a stored procedure with multiple parameters

	-- The following statement modifies the uspFindProducts stored procedure by adding one more parameter 
	-- named @max_list_price to it.

	ALTER PROCEDURE uspFindProducts (
		@min_list_price AS DECIMAL,
		@max_list_price AS DECIMAL
	)
	AS
		BEGIN
			SELECT product_name, list_price
			FROM production.products
			WHERE	list_price >= @min_list_price AND
					list_price <= @max_list_price
			ORDER BY list_price;
		END;

	-- Check result
	
	EXEC uspFindProducts 900, 1000;


	-- Using named parameters

	-- the following statement executes the uspFindProducts stored procedure using the 
	-- named parameters @min_list_priceand @max_list_price:

	EXECUTE uspFindProducts 
		@min_list_price = 900, 
		@max_list_price = 1000;

	-- Creating text parameters

	-- The following statement adds the @name parameter as a character string parameter to the stored procedure.

	ALTER PROCEDURE uspFindProducts(
		@min_list_price AS DECIMAL,
		@max_list_price AS DECIMAL,
		@name AS VARCHAR(max)
	)
	AS
		BEGIN
			SELECT product_name, list_price
			FROM production.products
			WHERE	list_price >= @min_list_price AND
					list_price <= @max_list_price AND
					product_name LIKE '%' + @name + '%'
			ORDER BY list_price;
		END;

	-- Once the stored procedure is altered successfully, you can execute it as follows:

	EXECUTE uspFindProducts 
		@min_list_price = 900, 
		@max_list_price = 1000,
		@name = 'Trek';


	-- Creating optional parameters

	-- In this stored procedure, we assigned 0 as the default value for the @min_list_price parameter 
	-- and 999,999 as the default value for the @max_list_price parameter.

	ALTER PROCEDURE uspFindProducts(
		@min_list_price AS DECIMAL = 0,
		@max_list_price AS DECIMAL = 999999,
		@name AS VARCHAR(max)
	)
	AS
		BEGIN
			SELECT product_name, list_price
			FROM production.products
			WHERE	list_price >= @min_list_price AND
					list_price <= @max_list_price AND
					product_name LIKE '%' + @name + '%'
			ORDER BY list_price;
		END;

	-- Once the stored procedure is compiled, you can execute it without passing the arguments 
	-- to @min_list_price and @max_list_price parameters:

	EXECUTE uspFindProducts 
		@name = 'Trek';

	-- another example

	EXECUTE uspFindProducts 
		@min_list_price = 6000,
		@name = 'Trek';


	-- Using NULL as the default value

	-- In the uspFindProducts stored procedure, we used 999,999 as the default maximum list price. 
	-- This is not robust because in the future you may have products with the list prices that are 
	-- greater than that. A typical technique to avoid this is to use NULL as the default value for the parameters:

	ALTER PROCEDURE uspFindProducts (
		@min_list_price AS DECIMAL = 0,
		@max_list_price AS DECIMAL = NULL,
		@name AS VARCHAR(max)
	)
	AS
		BEGIN
			SELECT product_name, list_price
			FROM production.products
			WHERE	list_price >= @min_list_price AND
					(@max_list_price IS NULL OR list_price <= @max_list_price) AND
					product_name LIKE '%' + @name + '%'
			ORDER BY list_price;
		END;

	-- The following statement executes the uspFindProducts stored procedure to find the product 
	-- whose list prices are greater or equal to 500 and names contain the word Haro.

	EXECUTE uspFindProducts 
		@min_list_price = 500,
		@name = 'Haro';


	-- Section Stored Procedure: Variables => declaring variables, setting their values, and assigning value 
	-- fields of a record to variables.

	-- The following SELECT statement uses the @model_year variable in the WHERE clause to find the products 
	-- of a specific model year:

	DECLARE @model_year SMALLINT;

	SET @model_year = 2018;
	
	SELECT product_name, model_year, list_price 
	FROM production.products
	WHERE model_year = @model_year
	ORDER BY product_name;


	-- The following steps describe how to store the query result in a variable:

	DECLARE @product_count INT;
	
	SET @product_count = (
		SELECT COUNT(*) 
		FROM production.products 
	);


	-- OUTPUT

	SELECT @product_count AS Count;					-- method 1

	PRINT @product_count;					-- method 2

	PRINT 'The number of products is '		-- method 3
	+ CAST(@product_count AS VARCHAR(MAX));


	-- The following stored procedure takes one parameter and returns a list of products as a string:
	
	CREATE  PROC uspGetProductList (
		@model_year SMALLINT
	) AS 
		BEGIN
			DECLARE @product_list VARCHAR(MAX);

			SET @product_list = '';

			SELECT @product_list = @product_list + product_name 
                        + CHAR(10)
			FROM production.products
			WHERE model_year = @model_year
			ORDER BY product_name;

			PRINT @product_list;
		END;

	-- OUTPUT

	EXEC uspGetProductList 2018;


	-- Section Stored Procedure: OUTPUT Parameters => used to return data back to the calling program.

	-- The following stored procedure finds products by model year and returns the number of products 
	-- via the @product_count output parameter:

	CREATE PROCEDURE uspFindProductByModel (
		@model_year SMALLINT,
		@product_count INT OUTPUT
	) AS
		BEGIN
			SELECT product_name, list_price
			FROM production.products
			WHERE model_year = @model_year;

			SELECT @product_count = @@ROWCOUNT;
		END;

	-- OUTPUT

	DECLARE @count INT;

	EXEC uspFindProductByModel
		@model_year = 2018,
		@product_count = @count OUTPUT;

	SELECT @count AS 'Number of products found';


	-- Section Stored Procedure: BEGIN....END => used to wrap a set of Transact-SQL statements into a statement block.

	-- In this syntax, you place a set of SQL statements between the BEGIN and END keywords, for example:

	BEGIN
		SELECT product_id, product_name
		FROM production.products
		WHERE list_price > 100000;

		IF @@ROWCOUNT = 0
        PRINT 'No product with price greater than 100000 found';
	END


	-- Nesting BEGIN... END Example

	BEGIN
		DECLARE @name VARCHAR(MAX);

		SELECT TOP 1
			@name = product_name
		FROM production.products
		ORDER BY list_price DESC;
    
		IF @@ROWCOUNT <> 0
			BEGIN
				PRINT 'The most expensive product is ' + @name
			END
		ELSE
			BEGIN
				PRINT 'No product found';
			END;
	END


	-- Section Stored Procedure: IF...ELSE => used to control the flow of program.

	-- The following example first gets the sales amount from the sales.order_items table in the sample database 
	-- and then prints out a message if the sales amount is greater than 1 million.

	BEGIN
		DECLARE @sales INT;

		SELECT @sales = SUM(list_price * quantity)
		FROM sales.order_items i
        INNER JOIN sales.orders o ON o.order_id = i.order_id
		WHERE YEAR(order_date) = 2018;

		SELECT @sales;

		IF @sales > 1000000
		BEGIN
			PRINT 'Great! The sales amount in 2018 is greater than 1,000,000';
		END
	END

	-- IF ELSE

	BEGIN
		DECLARE @sales INT;

		SELECT @sales = SUM(list_price * quantity)
		FROM sales.order_items i
        INNER JOIN sales.orders o ON o.order_id = i.order_id
		WHERE YEAR(order_date) = 2017;

		SELECT @sales;

		IF @sales > 10000000
			BEGIN
				PRINT 'Great! The sales amount in 2018 is greater than 10,000,000';
			END
		ELSE
			BEGIN
				PRINT 'Sales amount in 2017 did not reach 10,000,000';
			END
	END

	-- Nested IF...ELSE

	BEGIN
		DECLARE @x INT = 10, @y INT = 20;

		IF (@x > 0)
			BEGIN
				IF (@x < @y)
					PRINT 'x > 0 and x < y';
				ELSE
					PRINT 'x > 0 and x >= y';
			END			
	END
	

	-- Section Stored Procedure: WHILE => used to execute a statement block repeatedly based on a specified condition.

	-- The following example illustrates how to use the WHILE statement to print out numbers from 1 to 5:

	DECLARE @counter INT = 1;

	WHILE @counter <= 5
	BEGIN
		PRINT @counter;
		SET @counter = @counter + 1;
	END


	-- Section Stored Procedure: BREAK => used to immediately exit a WHILE loop.

	-- The following example illustrates how to use the BREAK statement:

	DECLARE @counter INT = 0;

	WHILE @counter <= 5
	BEGIN
		SET @counter = @counter + 1;
		IF @counter = 4
			BREAK;
		PRINT @counter;
	END


	-- Section Stored Procedure: CONTINUE => used to control the flow of the loop.

	-- The following example illustrates how the CONTINUE statement works.

	DECLARE @counter INT = 0;

	WHILE @counter < 5
	BEGIN
		SET @counter = @counter + 1;
		IF @counter = 3
			CONTINUE;	
		PRINT @counter;
	END


	-- Section Stored Procedure: CURSOR =>  to process a result set, one row at a time.

	-- Step 1: First, declare two variables to hold product name and list price, and a cursor to hold the result 
	-- of a query that retrieves product name and list price from the production.products table:

	DECLARE 
		@product_name VARCHAR(MAX), 
		@list_price   DECIMAL;

	DECLARE cursor_product CURSOR
		FOR SELECT product_name, list_price
		FROM production.products;

	-- Step 2: Next, open the cursor:

	OPEN cursor_product;
	
	-- Step 3: Then, fetch each row from the cursor and print out the product name and list price:

	FETCH NEXT FROM cursor_product INTO 
		@product_name, 
		@list_price;

	WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT @product_name + CAST(@list_price AS varchar);
        FETCH NEXT FROM cursor_product INTO 
            @product_name, 
            @list_price;
    END;

	--Step 4: After that, close the cursor:

	CLOSE cursor_product;
	
	-- Step 5: Finally, deallocate the cursor to release it.

	DEALLOCATE cursor_product;


	-- Section Stored Procedure: TRY...CATCH => to handle exceptions in stored procedures.

	-- create a stored procedure named usp_divide that divides two numbers:

	CREATE PROC usp_divide(
		@a decimal,
		@b decimal,
		@c decimal output
	) AS
	BEGIN
		BEGIN TRY
			SET @c = @a / @b;
		END TRY
		BEGIN CATCH
			SELECT  
				ERROR_NUMBER() AS ErrorNumber, 
				ERROR_SEVERITY() AS ErrorSeverity, 
				ERROR_STATE() AS ErrorState,
				ERROR_PROCEDURE() AS ErrorProcedure, 
				ERROR_LINE() AS ErrorLine,
				ERROR_MESSAGE() AS ErrorMessage;  
		END CATCH
	END;
	GO

	-- call the usp_divide stored procedure to divide 10 by 2:

	DECLARE @r decimal;
	EXEC usp_divide 10, 2, @r output;
	PRINT @r;

	-- attempt to divide 20 by zero by calling the usp_divide stored procedure

	DECLARE @r2 decimal;
	EXEC usp_divide 10, 0, @r2 output;
	PRINT @r2;


	-- Using TRY CATCH with transactions example

	-- Step 1: First, set up two new tables sales.persons and sales.deals for demonstration:

	CREATE TABLE sales.persons (
		person_id  INT PRIMARY KEY IDENTITY, 
		first_name NVARCHAR(100) NOT NULL, 
		last_name  NVARCHAR(100) NOT NULL
	);

	CREATE TABLE sales.deals (
		deal_id   INT PRIMARY KEY IDENTITY, 
		person_id INT NOT NULL, 
		deal_note NVARCHAR(100), 
		FOREIGN KEY(person_id) REFERENCES sales.persons(person_id)
	);

	insert into sales.persons(first_name, last_name)
	values	('John','Doe'),
			('Jane','Doe');

	insert into sales.deals(person_id, deal_note)
	values (1,'Deal for John Doe');

	-- Step 2: create a new stored procedure named usp_report_error that will be used in a CATCH block 
	-- to report the detailed information of an error:

	CREATE PROC usp_report_error
	AS
	SELECT   
        ERROR_NUMBER() AS ErrorNumber, 
        ERROR_SEVERITY() AS ErrorSeverity,  
        ERROR_STATE() AS ErrorState,  
        ERROR_LINE () AS ErrorLine,  
        ERROR_PROCEDURE() AS ErrorProcedure,  
        ERROR_MESSAGE() AS ErrorMessage;  
	GO

	-- Step 3: develop a new stored procedure that deletes a row from the sales.persons table:
	-- In this stored procedure, we used the XACT_STATE() function to check the state 
	-- of the transaction before performing COMMIT TRANSACTION or ROLLBACK TRANSACTION inside the CATCH block.

	CREATE PROC usp_delete_person(
		@person_id INT
	) AS
	BEGIN
		BEGIN TRY
			BEGIN TRANSACTION;
				-- delete the person
				DELETE FROM sales.persons 
				WHERE person_id = @person_id;
				-- if DELETE succeeds, commit the transaction
			COMMIT TRANSACTION;  
		END TRY
		BEGIN CATCH
			-- report exception
			EXEC usp_report_error;
        
			-- Test if the transaction is uncommittable.  
			IF (XACT_STATE()) = -1  
			BEGIN  
				PRINT  N'The transaction is in an uncommittable state.' +  
                    'Rolling back transaction.'  
				ROLLBACK TRANSACTION;  
			END;  
        
			-- Test if the transaction is committable.  
			IF (XACT_STATE()) = 1  
			BEGIN  
				PRINT N'The transaction is committable.' +  
                'Committing transaction.'  
				COMMIT TRANSACTION;     
			END;  
		END CATCH
	END;
	GO

	-- Step 4: call the usp_delete_person stored procedure to delete the person id 2:

	EXEC usp_delete_person 2;

	-- Step 5: call the stored procedure usp_delete_person to delete person id 1:

	EXEC usp_delete_person 1;


	-- Section Stored Procedure: RAISERROR =>  used to generate user-defined error messages.

	-- 01. Using SQL Server RAISERROR with TRY CATCH block example

	-- In this example, we use the RAISERROR inside a TRY block to cause execution to jump to 
	-- the associated CATCH block. Inside the CATCH block, we use the RAISERROR to return the 
	-- error information that invoked the CATCH block.

	DECLARE 
		@ErrorMessage  NVARCHAR(4000), 
		@ErrorSeverity INT, 
		@ErrorState    INT;

	BEGIN TRY
		RAISERROR('Error occurred in the TRY block.', 17, 1);
	END TRY
	BEGIN CATCH
		SELECT 
			@ErrorMessage = ERROR_MESSAGE(), 
			@ErrorSeverity = ERROR_SEVERITY(), 
			@ErrorState = ERROR_STATE();

		-- return the error inside the CATCH block
		RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
	END CATCH;


	-- 02. Using SQL Server RAISERROR statement with a dynamic message text example

	-- The following example shows how to use a local variable to provide the message text for a RAISERROR statement:

	DECLARE 
		@MessageText NVARCHAR(100);
	SET @MessageText = N'Cannot delete the sales order %s';

	RAISERROR(
		@MessageText, -- Message text
		16, -- severity
		1, -- state
		N'2001' -- first argument to the message text
	);


	-- Section Stored Procedure: THROW => used to raise an exception.

	-- 01. Using THROW statement to raise an exception
	-- The following example uses the THROW statement to raise an exception:

	THROW 50005, N'An error occurred', 1;


	-- 02. Using THROW statement to rethrow an exception

	CREATE TABLE t1(
		id int primary key
	);
	GO

	BEGIN TRY
		INSERT INTO t1(id) VALUES(1);
		--  cause error
		INSERT INTO t1(id) VALUES(1);
	END TRY
	BEGIN CATCH
		PRINT('Raise the caught error again');
		THROW;
	END CATCH


	-- 03. Using THROW statement to rethrow an exception

	EXEC sys.sp_addmessage 
		@msgnum = 50010, 
		@severity = 16, 
		@msgtext =
		N'The order number %s cannot be deleted because it does not exist.', 
		@lang = 'us_english';   
	GO

	DECLARE @MessageText NVARCHAR(2048);
		SET @MessageText =  FORMATMESSAGE(50010, N'1001');   

	THROW 50010, @MessageText, 1; 


	-- Section Stored Procedure: Dynamic SQL => used to construct general purpose and flexible SQL statements.

	-- Using dynamic SQL to query from any table example

	DECLARE 
		@table NVARCHAR(128),
		@sql NVARCHAR(MAX);

	SET @table = N'production.products';

	SET @sql = N'SELECT * FROM ' + @table;

	EXEC sp_executesql @sql;


	-- This stored procedure returns the top 10 rows from a table by the values of a specified column:

	CREATE OR ALTER PROC usp_query_topn(
		@table NVARCHAR(128),
		@topN INT,
		@byColumn NVARCHAR(128)
	)
	AS
	BEGIN
		DECLARE 
			@sql NVARCHAR(MAX),
			@topNStr NVARCHAR(MAX);

		SET @topNStr  = CAST(@topN as nvarchar(max));

		-- construct SQL
		SET @sql = N'SELECT TOP ' +  @topNStr  + 
                ' * FROM ' + @table + 
                    ' ORDER BY ' + @byColumn + ' DESC';
		-- execute the SQL
		EXEC sp_executesql @sql;
    
	END;


	-- For example, you can get the top 10 most expensive products from the production.products table:

	EXEC usp_query_topn 'production.products', 10, 'list_price';

	-- This statement returns the top 10 products with the highest quantity in stock:

	EXEC usp_query_topn 'production.stocks', 10, 'quantity';


------------------------------------------------------------------------------------------------------------------------------------

									-- SQL SERVER User-defined Functions --


	-- Section User-defined Functions: Scalar Functions => to encapsulate formulas or business logic and reuse them in the queries.

	-- The following example creates a function that calculates the net sales based on the quantity, list price, and discount:

	CREATE FUNCTION sales.udfNetSale (
		@quantity INT,
		@list_price DEC(10,2),
		@discount DEC(4,2)
	)
	RETURNS DEC(10,2)
	AS 
	BEGIN
		RETURN @quantity * @list_price * (1 - @discount);
	END;

	-- call the above function

	SELECT sales.udfNetSale(10,100,0.1) net_sale;

	-- Real-life use: The following example illustrates how to use the sales.udfNetSale function 
	-- to get the net sales of the sales orders in the order_items table:

	SELECT	order_id, 
			SUM(sales.udfNetSale(quantity, list_price, discount)) net_amount
	FROM sales.order_items
	GROUP BY order_id
	ORDER BY net_amount DESC;


	-- to remove the sales.udfNetSale function, you use the following statement:

	DROP FUNCTION sales.udfNetSale;


	-- Section User-defined Functions: Table Variables => variables that allow you to hold rows of data, 
	-- which are similar to temporary tables.

	-- For example, the following statement declares a table variable named @product_table which consists of 
	-- three columns: product_name, brand_id, and list_price:

	DECLARE @product_table TABLE (
		product_name VARCHAR(MAX) NOT NULL,
		brand_id INT NOT NULL,
		list_price DEC(11,2) NOT NULL
	);

	INSERT INTO @product_table
	SELECT
		product_name,
		brand_id,
		list_price
	FROM production.products
	WHERE category_id = 1;

	SELECT * FROM @product_table;
	GO


	-- Section User-defined Functions: Table-valued Functions => It is a user-defined function that returns data of a table type.

	-- The following statement example creates a table-valued function that returns a list of products including product name, 
	-- model year and the list price for a specific model year:

	CREATE FUNCTION udfProductInYear (
		@model_year INT
	)
	RETURNS TABLE
	AS
	RETURN
		SELECT 
			product_name,
			model_year,
			list_price
		FROM production.products
		WHERE model_year = @model_year;

	-- To execute a table-valued function, you use it in the FROM clause of the SELECT statement:

	SELECT * FROM udfProductInYear(2017);

	-- Example 02: For example, the following statement modifies the udfProductInYear by changing the existing 
	-- parameter and adding one more parameter:

	ALTER FUNCTION udfProductInYear (
		@start_year INT,
		@end_year INT
	)
	RETURNS TABLE
	AS
	RETURN
		SELECT 
			product_name,
			model_year,
			list_price
		FROM production.products
		WHERE model_year BETWEEN @start_year AND @end_year

	-- following statement calls the udfProductInYear function to get the products whose model years are between 2017 and 2018:

	SELECT product_name, model_year, list_price
	FROM udfProductInYear(2017,2018)
	ORDER BY product_name;


	-- Multi-statement table-valued functions (MSTVF)

	-- The following udfContacts() function combines staffs and customers into a single contact list:

	CREATE FUNCTION udfContacts()
    RETURNS @contacts TABLE (
				first_name VARCHAR(50),
				last_name VARCHAR(50),
				email VARCHAR(255),
				phone VARCHAR(25),
				contact_type VARCHAR(20)
			)
			AS
			BEGIN
				INSERT INTO @contacts
				SELECT first_name, last_name, email, phone, 'Staff'
				FROM sales.staffs;

				INSERT INTO @contacts
				SELECT first_name, last_name, email, phone, 'Customer'
				FROM sales.customers;
			RETURN;
			END;

	-- The following statement illustrates how to execute a multi-statement table-valued function udfContacts:

	SELECT * FROM udfContacts();


	-- Section User-defined Functions: DROP FUNCTION => used to remove an existing user-defined function.

	-- The following example creates a function that calculates discount amount from quantity, list price, and discount percentage:

	CREATE FUNCTION sales.udf_get_discount_amount (
		@quantity INT,
		@list_price DEC(10,2),
		@discount DEC(4,2) 
	)
	RETURNS DEC(10,2) 
	AS 
	BEGIN
		RETURN @quantity * @list_price * @discount
	END

	-- To drop the sales.udf_get_discount_amount function, you use the following statement:

	DROP FUNCTION IF EXISTS sales.udf_get_discount_amount;


------------------------------------------------------------------------------------------------------------------------------------

										-- SQL Server TRIGGERS --

	-- Section Triggers: Create Trigger => used to create a new trigger.

	-- Step 01: The following statement creates a table named production.product_audits to record information 
	-- when an INSERT or DELETE event occurs against the production.products table:

	CREATE TABLE production.product_audits(
		change_id INT IDENTITY PRIMARY KEY,
		product_id INT NOT NULL,
		product_name VARCHAR(255) NOT NULL,
		brand_id INT NOT NULL,
		category_id INT NOT NULL,
		model_year SMALLINT NOT NULL,
		list_price DEC(10,2) NOT NULL,
		updated_at DATETIME NOT NULL,
		operation CHAR(3) NOT NULL,
		CHECK(operation = 'INS' or operation='DEL')
	);

	 -- Step 02: Creating an (AFTER) DML trigger

	 CREATE TRIGGER production.trg_product_audit
	ON production.products
	AFTER INSERT, DELETE
	AS
	BEGIN
		SET NOCOUNT ON;
		INSERT INTO production.product_audits(
			product_id, product_name, brand_id, category_id, model_year,
			list_price, updated_at, operation
		)
		SELECT i.product_id, product_name, brand_id, category_id,
				model_year, i.list_price, GETDATE(), 'INS'
		FROM inserted i
		UNION ALL
		SELECT	d.product_id, product_name, brand_id, category_id,
				model_year, d.list_price, GETDATE(), 'DEL'
		FROM deleted d;
	END

	-- Step 03:  Testing the trigger

	INSERT INTO production.products(
		product_name, brand_id, category_id, model_year, list_price
	)
	VALUES ( 'Test product', 1, 1, 2018, 599 );


	-- Step 04: Let’s examine the contents of the production.product_audits table:

	SELECT * FROM production.product_audits;
	

	-- Step 05: The following statement deletes a row from the production.products table:

	DELETE FROM production.products
	WHERE product_id = 322;


	-- Step 06: Recheck again:

	SELECT * FROM production.product_audits;


	-- Section Triggers: INSTEAD OF Trigger => used to insert data into an underlying table via a view.

	-- The following statement creates a new table named production.brand_approvals for storing pending approval brands:

	CREATE TABLE production.brand_approvals(
		brand_id INT IDENTITY PRIMARY KEY,
		brand_name VARCHAR(255) NOT NULL
	);

	-- The following statement creates a new view named production.vw_brands against the production.brands and 
	-- production.brand_approvals tables:

	CREATE VIEW production.vw_brands 
	AS
	SELECT brand_name, 'Approved' approval_status
	FROM production.brands
		UNION
	SELECT brand_name, 'Pending Approval' approval_status
	FROM production.brand_approvals;

	-- we need to route production.vw_brands view to the production.brand_approvals table via the following INSTEAD OF trigger:

	CREATE TRIGGER production.trg_vw_brands 
	ON production.vw_brands
	INSTEAD OF INSERT
	AS
	BEGIN
		SET NOCOUNT ON;
		INSERT INTO production.brand_approvals ( brand_name )
		SELECT i.brand_name
		FROM inserted i
		WHERE i.brand_name NOT IN (
			SELECT brand_name FROM production.brands
        );
	END

	-- Let’s insert a new brand into the production.vw_brands view:
	-- This INSERT statement fired the INSTEAD OF trigger to insert a new row into the production.brand_approvals table.

	INSERT INTO production.vw_brands(brand_name)
	VALUES('Eddy Merckx');

	-- If you query data from the production.vw_brands table, you will see a new row appear:

	SELECT brand_name, approval_status
	FROM production.vw_brands;

	-- The following statement shows the contents of the production.brand_approvals table:

	SELECT * FROM production.brand_approvals;


	-- Section Triggers: DDL Trigger => trigger to monitor the changes made to the database objects.

	-- Suppose you want to capture all the modifications made to the database index so that you can better monitor 
	-- the performance of the database server which relates to these index changes.

	-- Step 01: First, create a new table named index_logs to log the index changes:

	CREATE TABLE index_logs (
		log_id INT IDENTITY PRIMARY KEY,
		event_data XML NOT NULL,
		changed_by SYSNAME NOT NULL
	);
	GO

	-- Step 02: Next, create a DDL trigger to track index changes and insert events data into the index_logs table:

	CREATE TRIGGER trg_index_changes
	ON DATABASE
	FOR	
		CREATE_INDEX,
		ALTER_INDEX, 
		DROP_INDEX
	AS
	BEGIN
		SET NOCOUNT ON;

    INSERT INTO index_logs (
        event_data,
        changed_by
    )
    VALUES (
        EVENTDATA(),
        USER
    );
	END;
	GO

	-- In the body of the trigger, we used the EVENTDATA() function that returns the information about server or database 
	-- events. The function is only available inside DDL or logon trigger.

	-- Step 03: Then, create indexes for the first_name and last_name columns of the sales.customers table:

	CREATE NONCLUSTERED INDEX nidx_fname
	ON sales.customers(first_name);
	GO

	CREATE NONCLUSTERED INDEX nidx_lname
	ON sales.customers(last_name);
	GO

	-- Step 04: After that, query data from the index_changes table to check whether the index creation event was captured
	-- by the trigger properly:

	SELECT * FROM index_logs;


	-- Section Triggers: DISABLE TRIGGER => DISABLE TRIGGER statement used to disable a trigger. 

	-- Step 01: The following statement creates a new table named sales.members for the demonstration:

	CREATE TABLE sales.members (
		member_id INT IDENTITY PRIMARY KEY,
		customer_id INT NOT NULL,
		member_level CHAR(10) NOT NULL
	);

	-- Step 02: The following statement creates a trigger that is fired whenever a new row is inserted into the 
	-- sales.members table. For the demonstration purpose, the trigger just returns a simple message.

	CREATE TRIGGER sales.trg_members_insert
	ON sales.members
	AFTER INSERT
	AS
	BEGIN
		PRINT 'A new member has been inserted';
	END;

	-- Step 03: The following statement inserts a new row into the sales.members table:

	INSERT INTO sales.members(customer_id, member_level)
	VALUES(1,'Silver');

	-- Step 04: To disable the sales.trg_members_insert trigger, you use the following DISABLE TRIGGER statement:
	-- After Execute, Now if you insert a new row into the sales.members table, the trigger will not be fired.

	DISABLE TRIGGER sales.trg_members_insert 
	ON sales.members;


	-- Disable all trigger on a table

	DISABLE TRIGGER ALL ON sales.members;


	-- Section Triggers: ENABLE TRIGGER => ENABLE TRIGGER statement used to enable a trigger.

	-- To enable the sales.sales.trg_members_insert trigger, you use the following statement:

	ENABLE TRIGGER sales.trg_members_insert
	ON sales.members;

	-- To enable all triggers of a table, you use the following statement:

	ENABLE TRIGGER ALL ON sales.members;

	-- Enable all triggers of a database

	ENABLE TRIGGER ALL ON DATABASE; 
	

	-- Section Triggers: View Trigger Definition => various ways to view SQL Server trigger definition.

	-- method 01: Getting trigger definition by querying from a system view

	SELECT definition   
	FROM sys.sql_modules  
	WHERE object_id = OBJECT_ID('sales.trg_members_delete'); 


	-- method 02: Getting trigger definition using OBJECT_DEFINITION function

	SELECT OBJECT_DEFINITION (
        OBJECT_ID( 'sales.trg_members_delete' )
    ) AS trigger_definition;


	-- method 03: Getting trigger definition using sp_helptext stored procedure

	EXEC sp_helptext 'sales.trg_members_delete';


	-- Section Triggers: List All Triggers => To list all triggers in a SQL Server, you query data from the sys.triggers view:

	SELECT name, is_instead_of_trigger
	FROM sys.triggers  
	WHERE type = 'TR';


	-- Section Triggers: DROP TRIGGER => to remove existing triggers.

	-- Example 01: SQL Server DROP TRIGGER – drop a DML trigger example

	-- The following statement drops a DML trigger named sales.trg_member_insert:

	DROP TRIGGER IF EXISTS sales.trg_member_insert;


	-- Example 02: SQL Server DROP TRIGGER – drop a DDL trigger example
	
	-- The following statement removes the trg_index_changes trigger:

	DROP TRIGGER IF EXISTS trg_index_changes;


------------------------------------------------------------------------------------------------------------------------------------



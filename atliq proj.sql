-- 1 Q
SELECT DISTINCT market FROM dim_customer WHERE customer = "Atliq Exclusive" 
									AND region = "APAC";
  
-- ----------------------------------------------------------------------------------------------
                                    
-- 2 Q
WITH Addcolumn_20 AS (
					SELECT COUNT(DISTINCT product) AS unique_products_2020 FROM dim_product AS d
					INNER JOIN fact_gross_price AS f ON d.product_code = f.product_code
                    WHERE f.fiscal_year = 2020
                    ),
	 Addcolumn_21 AS (
					SELECT COUNT(DISTINCT product) AS unique_products_2021 FROM dim_product AS d1
                    INNER JOIN fact_gross_price AS f1 ON d1.product_code = f1.product_code
                    WHERE f1.fiscal_year = 2021
                    )

SELECT A20.unique_products_2020, A21.unique_products_2021, 
	   ROUND(((A21.unique_products_2021 - A20.unique_products_2020)/(A20.unique_products_2020 + A20.unique_products_2020) * 100 ), 2) AS percentage_chg
       FROM Addcolumn_20 AS A20, Addcolumn_21 AS A21;

-- ----------------------------------------------------------------------------------------------

-- 3 Q
SELECT segment, COUNT(DISTINCT product) AS product_count FROM dim_product 
		GROUP BY segment ORDER BY product_count DESC;
        
-- ----------------------------------------------------------------------------------------------

-- 4 Q
WITH Prod_20 AS (
				SELECT d.segment, COUNT(DISTINCT d.product) AS product_count_2020 FROM dim_product AS d
                INNER JOIN fact_gross_price AS f ON d.product_code = f.product_code
                WHERE fiscal_year = 2020 GROUP BY d.segment),
	 Prod_21 AS (
				SELECT d.segment, COUNT(DISTINCT d.product) AS product_count_2021 FROM dim_product AS d
                INNER JOIN fact_gross_price AS f ON d.product_code = f.product_code
                WHERE fiscal_year = 2021 GROUP BY d.segment),
	 Diff AS    (
				SELECT P20.segment, P20.product_count_2020, P21.product_count_2021, 
                (P21.product_count_2021 - P20.product_count_2020) AS difference
                FROM Prod_20 AS P20 INNER JOIN Prod_21 AS P21 
                ON P20.segment = P21.segment)
SELECT * FROM Diff ORDER BY difference DESC;
                
-- ----------------------------------------------------------------------------------------------

-- 5 Q
SELECT m.product_code, d.product, m.manufacturing_cost FROM fact_manufacturing_cost AS m
		INNER JOIN dim_product AS d ON m.product_code = d.product_code
        WHERE m.manufacturing_cost = (
				SELECT MAX(manufacturing_cost) FROM fact_manufacturing_cost)
		   OR m.manufacturing_cost = (
				SELECT MIN(manufacturing_cost) FROM fact_manufacturing_cost)
		ORDER BY m.manufacturing_cost DESC;
        
-- ----------------------------------------------------------------------------------------------

-- 6 Q

  SELECT d.customer_code, d.customer, 
		ROUND(AVG(f.pre_invoice_discount_pct), 4)   AS average_discount_percentage
		FROM dim_customer AS d INNER JOIN fact_pre_invoice_deductions AS f ON 
        d.customer_code = f.customer_code 
        WHERE f.fiscal_year = 2021 AND d.market = "India" GROUP BY d.customer, d.customer_code
        ORDER BY average_discount_percentage DESC LIMIT 5 ;
-- ----------------------------------------------------------------------------------------------

-- 7 Q

SELECT CONCAT(MONTHNAME(fs.date), " ", YEAR(fs.date)) AS Month, fs.fiscal_year AS Year,
		SUM(ROUND((fg.gross_price * fs.sold_quantity), 2)) AS Gross_Sales_Amount
		FROM fact_sales_monthly
		AS fs INNER JOIN fact_gross_price AS fg ON
        fs.product_code = fg.product_code 
        INNER JOIN dim_customer AS d ON d.customer_code = fs.customer_code
        WHERE customer = "Atliq Exclusive" GROUP BY Month, Year ORDER BY Gross_Sales_Amount;



-- ----------------------------------------------------------------------------------------------

-- 8 Q

SELECT QUARTER(date) AS Quarter, SUM(sold_quantity) AS total_sold_quantity FROM fact_sales_monthly
		WHERE YEAR(date) = 2020
        GROUP BY Quarter ORDER BY total_sold_quantity DESC;
        
-- ----------------------------------------------------------------------------------------------

-- 9 Q

WITH channelQ AS (
				SELECT d.channel AS channel,
                SUM(fg.gross_price * fs.sold_quantity)/1000000 AS gross_sales_mln
                FROM dim_customer AS d INNER JOIN fact_sales_monthly AS fs ON
                d.customer_code = fs.customer_code INNER JOIN fact_gross_price AS fg
                ON fs.product_code = fg.product_code WHERE fg.fiscal_year = 2021
                GROUP BY d.channel ),
total_sales AS (
				SELECT SUM(gross_sales_mln) AS total_sales FROM channelQ)
                
SELECT channel, ROUND(gross_sales_mln, 2) AS gross_sales_mln, ROUND((gross_sales_mln / total_sales) * 100, 2) AS percentage
		FROM channelQ, total_sales ORDER BY gross_sales_mln ;
        
-- ----------------------------------------------------------------------------------------------

-- 10 Q

WITH total_quantity AS (
					SELECT d.division AS division, d.product_code AS product_code, 
                    d.product AS product, 
                    SUM(fs.sold_quantity) AS total_sold_quantity,
                    DENSE_RANK() OVER(PARTITION BY division ORDER BY SUM(fs.sold_quantity) DESC)
                    AS rank_order
                    FROM dim_product AS d INNER JOIN fact_sales_monthly AS fs ON
                    d.product_code = fs.product_code WHERE fs.fiscal_year = 2021 
                    GROUP BY division, product_code, product
                   )
                   
		
SELECT division, product_code, product, total_sold_quantity, rank_order 
		FROM total_quantity
		WHERE rank_order IN (1, 2, 3);

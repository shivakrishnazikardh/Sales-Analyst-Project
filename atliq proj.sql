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
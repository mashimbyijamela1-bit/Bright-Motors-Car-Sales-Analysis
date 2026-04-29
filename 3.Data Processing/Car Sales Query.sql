-- checking the dataset --
select * from `workspace`.`default`.`car_sales_data` limit 100;

-- calculating number of sales + total revenue--
select count(*) as row_count,
       sum(sellingprice) as total_revenue
FROM workspace.default.car_sales_data;

-- checking dataset range--
SELECT 
    MIN(TO_TIMESTAMP(SUBSTRING(saledate, 5), 'MMM dd yyyy HH:mm:ss')) AS first_sale,
    MAX(TO_TIMESTAMP(SUBSTRING(saledate, 5), 'MMM dd yyyy HH:mm:ss')) AS last_sale
FROM workspace.default.car_sales_data
WHERE saledate IS NOT NULL;

-- extracting days from the saledate column --
select DAY(TO_TIMESTAMP(SUBSTRING(saledate, 5), 'MMM dd yyyy HH:mm:ss')) AS sale_day
from `workspace`.`default`.`car_sales_data`;

--checking for nulls-- multiple columns+rows have Nulls (seen in the big query)
select *
from `workspace`.`default`.`car_sales_data`
where saledate is null;

-- extraction year from saledate column --
select YEAR(TO_TIMESTAMP(SUBSTRING(saledate, 5), 'MMM dd yyyy HH:mm:ss')) AS sale_year
from `workspace`.`default`.`car_sales_data`;

-- extraction month from saledate column --
select DATE_FORMAT(TO_TIMESTAMP(SUBSTRING(SaleDate, 5), 'MMM dd yyyy HH:mm:ss'), 'MMMM') AS MonthName
from `workspace`.`default`.`car_sales_data`;

-- extraction month from saledate column --
SELECT DATE_FORMAT(TO_TIMESTAMP(SUBSTRING(SaleDate, 5), 'MMM dd yyyy HH:mm:ss'),'E') AS DayName
FROM workspace.default.car_sales_data;

-- checking the different car makes in the dataset --
select distinct (make)
from `workspace`.`default`.`car_sales_data`;

-- checking the different car models in the dataset --
select distinct (model)
from `workspace`.`default`.`car_sales_data`;

-- checking the different car trims in the dataset --
select distinct (trim)
from `workspace`.`default`.`car_sales_data`;

-- checking the different car bodies in the dataset --
select distinct (body)
from `workspace`.`default`.`car_sales_data`;

-- checking the different car colors in the dataset --
select distinct (color)
from `workspace`.`default`.`car_sales_data`;

-- checking the different car sellers in the dataset --
select distinct (seller)
from `workspace`.`default`.`car_sales_data`;

-- checking the different states in the dataset --
select distinct (state)
from `workspace`.`default`.`car_sales_data`;

-- calculating sales performance --
SELECT SellingPrice,
       MMR,
       SellingPrice - MMR AS PriceDifference
FROM workspace.default.car_sales_data;

--calculating average difference
SELECT 
    AVG(SellingPrice - MMR) AS AvgPriceDifference
FROM workspace.default.car_sales_data;

--calculating the number of transactions above sale market--
SELECT COUNT(*) AS AboveMarketSales
FROM workspace.default.car_sales_data
WHERE SellingPrice > MMR;

--calculating the number of transactions below sale market--
SELECT COUNT(*) AS BelowMarketSales
FROM workspace.default.car_sales_data
WHERE SellingPrice < MMR;



-- The Big Query --
SELECT 
       year, 
       IFNULL(make, 'unknown') AS make,
       IFNULL(model, 'unknown') AS model,
       IFNULL(trim, 'unknown') AS trim,
       IFNULL(body, 'unknown') AS body,
       IFNULL(transmission, 'unknown') AS transmission,
       vin,
       state,
       IFNULL(condition, 0) AS condition,
       IFNULL(odometer, 0) AS odometer,
       IFNULL(color, 'unknown') AS color,
       IFNULL(interior, 'unknown') AS interior,
       seller,
       saledate,
       IFNULL(mmr, 0) AS mmr,
       IFNULL(sellingprice, 0) AS total_revenue,
       IFNULL(sellingprice, 0) - IFNULL(mmr, 0) AS PriceDifference,
       ROUND(((IFNULL(sellingprice, 0) - IFNULL(mmr, 0)) / NULLIF(IFNULL(mmr, 0),0)) * 100, 2) AS MarginPercent,

       DAY(TO_TIMESTAMP(TRIM(SUBSTRING(saledate, 5)), 'MMM dd yyyy HH:mm:ss')) AS sale_day,
       DATE_FORMAT(TO_TIMESTAMP(TRIM(SUBSTRING(saledate, 5)), 'MMM dd yyyy HH:mm:ss'),'E') AS DayName,
       YEAR(TO_TIMESTAMP(TRIM(SUBSTRING(saledate, 5)), 'MMM dd yyyy HH:mm:ss')) AS sale_year,
       MONTH(TO_TIMESTAMP(TRIM(SUBSTRING(saledate, 5)), 'MMM dd yyyy HH:mm:ss')) AS sale_month_num,
       DATE_FORMAT(TO_TIMESTAMP(TRIM(SUBSTRING(saledate, 5)), 'MMM dd yyyy HH:mm:ss'), 'MMMM') AS sale_month,

       CASE 
           WHEN IFNULL(sellingprice, 0) > IFNULL(mmr, 0) THEN 'Above Market'
           WHEN IFNULL(sellingprice, 0) = IFNULL(mmr, 0) THEN 'At Market'
           ELSE 'Below Market'  
       END AS Market_Performance,

       CASE 
           WHEN IFNULL(sellingprice, 0) < 50000 THEN 'Cheap'
           WHEN IFNULL(sellingprice, 0) BETWEEN 50000 AND 150000 THEN 'Affordable'
           ELSE 'Expensive'
       END AS PriceCategory,

       CASE 
    WHEN ((SellingPrice - MMR) / MMR) * 100 > 10 THEN 'High Margin'
    WHEN ((SellingPrice - MMR) / MMR) * 100 BETWEEN 0 AND 10 THEN 'Medium Margin'
    ELSE 'Low Margin'
END AS PerformanceTier

FROM workspace.default.car_sales_data;

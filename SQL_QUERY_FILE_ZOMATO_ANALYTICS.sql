create database zomato;
use zomato;

show tables;
SELECT * FROM zomato.`zomato data`;
select count(*) from zomato.`zomato data`;

-- Q1)Build a country Map Table
CREATE TABLE Country_Map AS
SELECT DISTINCT countrycode, Country
FROM Countries;
select * from country_map;

-- Q2).Build a Calendar Table using the Column Datekey
CREATE TABLE Calendar_Table AS 
SELECT 
    Datekey_Opening AS DateKey,
    YEAR(Datekey_Opening) AS Year,
    MONTH(Datekey_Opening) AS Month,
    DAY(Datekey_Opening) AS Date,
    -- Financial Quarter Calculation
    CASE 
        WHEN MONTH(Datekey_Opening) IN (4,5,6) THEN 'FQ-1'
        WHEN MONTH(Datekey_Opening) IN (7,8,9) THEN 'FQ-2'
        WHEN MONTH(Datekey_Opening) IN (10,11,12) THEN 'FQ-3'
        WHEN MONTH(Datekey_Opening) IN (1,2,3) THEN 'FQ-4'
    END AS Financial_Quarter,
    -- Quarter Calculation
    CASE 
        WHEN MONTH(Datekey_Opening) IN (1,2,3) THEN 'Q1'
        WHEN MONTH(Datekey_Opening) IN (4,5,6) THEN 'Q2'
        WHEN MONTH(Datekey_Opening) IN (7,8,9) THEN 'Q3'
        WHEN MONTH(Datekey_Opening) IN (10,11,12) THEN 'Q4'
    END AS Quarter,
    -- Month Name
    MONTHNAME(Datekey_Opening) AS Month_Name
FROM `zomato data`;

select * from calendar_table;


-- Q3)Find the Number of Restaurants by City and Country

SELECT 
    c.Country AS CountryName, 
    r.City, 
    COUNT(r.RestaurantID) AS Restaurant_Count
FROM `zomato data` r
JOIN Countries c ON r.CountryCode = c.CountryCode
GROUP BY c.Country, r.City
ORDER BY Restaurant_Count DESC;




-- Q4)Number of Restaurant Openings by Year, Quarter, Month
SELECT 
    YEAR(Datekey_Opening) AS Year,
    CONCAT('Q', QUARTER(Datekey_Opening)) AS Quarter,
    MONTH(Datekey_Opening) AS Month,
    COUNT(*) AS Restaurant_Openings
FROM `zomato data`
WHERE Datekey_Opening IS NOT NULL
GROUP BY 
    YEAR(Datekey_Opening),
    QUARTER(Datekey_Opening),
    MONTH(Datekey_Opening)
ORDER BY Year, Quarter, Month;
SET sql_mode = (SELECT REPLACE(@@sql_mode, 'ONLY_FULL_GROUP_BY', ''));





-- Q5)Count of Restaurants Based on Average Ratings

SELECT Rating, COUNT(RestaurantID) AS Restaurant_Count
FROM `zomato data`
GROUP BY Rating
ORDER BY Rating DESC;


-- Q6) Create Buckets Based on Average Price

SELECT 
    CASE 
        WHEN `AVG COST FOR TWO ($)` BETWEEN 0 AND 10 THEN '$0-10'
        WHEN `AVG COST FOR TWO ($)` BETWEEN 10 AND 20 THEN '$10-20'
        WHEN `AVG COST FOR TWO ($)` BETWEEN 20 AND 30 THEN '$20-30'
        WHEN `AVG COST FOR TWO ($)` BETWEEN 30 AND 50 THEN '$30-50'
        WHEN `AVG COST FOR TWO ($)` BETWEEN 50 AND 100 THEN '$50-100'
        WHEN `AVG COST FOR TWO ($)` BETWEEN 100 AND 200 THEN '$100-200'
        WHEN `AVG COST FOR TWO ($)` BETWEEN 200 AND 500 THEN '$200-500'
        WHEN `AVG COST FOR TWO ($)` > 500 THEN '$500+'
    END AS Price_Bucket,
    COUNT(RestaurantID) AS Restaurant_Count
FROM `zomato data`
GROUP BY Price_Bucket
ORDER BY Restaurant_Count DESC;



-- Q7) Percentage of Restaurants Based on "Has_Table_Booking"

SELECT 
    `Has_Table_Booking`,
    COUNT(RestaurantID) * 100.0 / (SELECT COUNT(*) FROM `zomato data`) AS Percentage
FROM `zomato data`
GROUP BY `Has_Table_Booking`;


-- Q8) Percentage of Restaurants Based on "Has_Online_Delivery"

SELECT 
    `Has_Online_Delivery`,
    COUNT(RestaurantID) * 100.0 / (SELECT COUNT(*) FROM `zomato data`) AS Percentage
FROM `zomato data`
GROUP BY `Has_Online_Delivery` limit 2;


-- Q9) Develop Charts Based on Cuisine, City, Ratings

#   a) Top 10 Cuisines by Number of Restaurants


SELECT Cuisines, COUNT(RestaurantID) AS Restaurant_Count
FROM `zomato data`
GROUP BY Cuisines
ORDER BY Restaurant_Count DESC
LIMIT 10;

# b) Top 10 Cities with Most Restaurants

SELECT City, COUNT(RestaurantID) AS Restaurant_Count
FROM `zomato data`
GROUP BY City
ORDER BY Restaurant_Count DESC
LIMIT 10;

# c) Distribution of Ratings (For a Bar Chart)

SELECT Rating, COUNT(RestaurantID) AS Restaurant_Count
FROM `zomato data`
GROUP BY Rating
ORDER BY Rating DESC;











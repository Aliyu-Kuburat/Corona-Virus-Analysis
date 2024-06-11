SHOW TABLES;

SELECT * FROM corona_virus.`corona virus`;


-- Q1-Write a code to check NULL values

SELECT * FROM corona_virus.`corona virus`
WHERE Province IS NULL;

SELECT * FROM corona_virus.`corona virus`
WHERE 'Country/Region' IS NULL;

SELECT * FROM corona_virus.`corona virus`
WHERE Latitude IS NULL;

SELECT * FROM corona_virus.`corona virus`
WHERE COALESCE(Longitude, '') = '';

-- Q2. If NULL values are present, update them with zeros for all columns. 
-- There was no null value present in the data

 -- Q3. check total number of rows
 
 SELECT COUNT(*) AS total_rows
FROM corona_virus.`corona virus`;

ALTER TABLE corona_virus.`corona virus`
MODIFY Date date;

-- Q4. Check what is start_date and end_date

Describe corona_virus.`corona virus`;

SELECT MIN(Date) AS Start_date, MAX(Date) AS end_date
FROM corona_virus.`corona virus`;

-- Q5 Number of month present in dataset

SELECT COUNT(DISTINCT MONTH(Date)) AS num_months
FROM corona_virus.`corona virus`;

-- Q6. Find monthly average for confirmed, deaths, recovered

SELECT YEAR(date) AS year,
       MONTH(date) AS month,
       AVG (confirmed) AS avg_confirmed,
       AVG (deaths) AS avg_deaths,
       AVG (recovered) AS avg_recovered
FROM corona_virus.`corona virus`
GROUP BY YEAR(date), MONTH(date)
ORDER BY YEAR(date), MONTH(date);

-- Q7. Find most frequent value for confirmed, deaths, recovered each month 


SELECT
  YEAR('date') AS year,
  MONTH('date') AS month,
  confirmed_mode AS most_frequent_confirmed,
  deaths_mode AS most_frequent_deaths,
  recovered_mode AS most_frequent_recovered
FROM (
  SELECT
    YEAR('date') AS year,
    MONTH('date') AS month,
    confirmed,
    deaths,
    recovered,
    ROW_NUMBER() OVER (PARTITION BY YEAR('date'), MONTH('date') ORDER BY COUNT(*) DESC) AS rn_confirmed,
    ROW_NUMBER() OVER (PARTITION BY YEAR('date'), MONTH('date') ORDER BY COUNT(*) DESC) AS rn_deaths,
    ROW_NUMBER() OVER (PARTITION BY YEAR('date'), MONTH('date') ORDER BY COUNT(*) DESC) AS rn_recovered,
    -- Added these lines:
    MAX(confirmed) AS confirmed_mode,
    MAX(deaths) AS deaths_mode,
    MAX(recovered) AS recovered_mode
  FROM
    corona_virus.`corona virus`
  GROUP BY
    YEAR('date'), MONTH('date'), confirmed, deaths, recovered
) AS monthly_data
WHERE
  rn_confirmed = 1 AND rn_deaths = 1 AND rn_recovered = 1;
  
  -- Second query
  
  SELECT 
    year,
    month,
    confirmed_most_frequent,
    deaths_most_frequent,
    recovered_most_frequent
FROM (
    SELECT 
        YEAR('date') AS year,
        MONTH('date') AS month,
        confirmed_mode AS confirmed_most_frequent,
        deaths_mode AS deaths_most_frequent,
        recovered_mode AS recovered_most_frequent,
        record_count,
        RANK() OVER (PARTITION BY YEAR('date'), MONTH('date') ORDER BY record_count DESC) AS rank_number
    FROM (
        SELECT 
            YEAR('date') AS year,
            MONTH('date') AS month,
            confirmed,
            deaths,
            recovered,
            COUNT(*) AS record_count,
            MAX(confirmed) AS confirmed_mode,
            MAX(deaths) AS deaths_mode,
            MAX(recovered) AS recovered_mode
        FROM 
            corona_virus.`corona virus`
        GROUP BY 
            YEAR('date'), MONTH('date'), confirmed, deaths, recovered
    ) AS monthly_data
) AS ranked_data
WHERE rank_number = 1;

  SHOW COLUMNS FROM corona_virus.`corona virus`;
  
  ALTER TABLE corona_virus.`corona virus`
MODIFY Date date;

-- Q8. Find minimum values for confirmed, deaths, recovered per year

SELECT 
    YEAR(Date) AS year,
    MIN(confirmed) AS min_confirmed,
    MIN(deaths) AS min_deaths,
    MIN(recovered) AS min_recovered
FROM 
    corona_virus.`corona virus`
GROUP BY 
    YEAR(Date);
    
-- Q9. Find maximum values of confirmed, deaths, recovered per year

SELECT 
    YEAR(Date) AS year,
    MAX(confirmed) AS max_confirmed,
    MAX(deaths) AS max_deaths,
    MAX(recovered) AS max_recovered
FROM 
    corona_virus.`corona virus`
GROUP BY 
    YEAR(Date);
    
    -- Q10. The total number of case of confirmed, deaths, recovered each month
    
    SELECT 
    YEAR(Date) AS year,
    MONTH(Date) AS month,
    SUM(confirmed) AS total_confirmed,
    SUM(deaths) AS total_deaths,
    SUM(recovered) AS total_recovered
FROM 
    corona_virus.`corona virus`
GROUP BY 
    YEAR(Date), MONTH(Date);

-- A query to show month Name

SELECT 
    YEAR(Date) AS year,
    MONTH(Date) AS month,
    SUM(confirmed) AS total_confirmed, 
    SUM(deaths) AS total_deaths, 
    SUM(recovered) AS total_recovered, 
    CASE 
        WHEN MONTH(Date) = 1 THEN 'January'
        WHEN MONTH(Date) = 2 THEN 'February'
        WHEN MONTH(Date) = 3 THEN 'March'
        WHEN MONTH(Date) = 4 THEN 'April'
        WHEN MONTH(Date) = 5 THEN 'May'
        WHEN MONTH(Date) = 6 THEN 'June'
        WHEN MONTH(Date) = 7 THEN 'July'
        WHEN MONTH(Date) = 8 THEN 'August'
        WHEN MONTH(Date) = 9 THEN 'September'
        WHEN MONTH(Date) = 10 THEN 'October'
        WHEN MONTH(Date) = 11 THEN 'November'
        WHEN MONTH(Date) = 12 THEN 'December'
        ELSE 'Unknown' -- Optional: Handle unexpected month values
    END AS month_name
FROM 
    corona_virus.`corona virus`
GROUP BY 
    YEAR(Date), MONTH(Date), month_name;
    
    -- Alternative query to show Month Name
    
    SELECT
  YEAR(Date) AS year,
  MONTH(Date) AS month,
  SUM(confirmed) AS total_confirmed,
  SUM(deaths) AS total_deaths,
  SUM(recovered) AS total_recovered,
  DATE_FORMAT(Date, '%M') AS month_name
FROM corona_virus.`corona virus`
GROUP BY YEAR(Date), MONTH(Date), month_name;


-- Q11. Check how corona virus spread out with respect to confirmed case
--      (Eg.: total confirmed cases, their average, variance & STDEV )
    
    -- Total confirmed cases
SELECT COUNT(*) AS total_confirmed_cases
FROM corona_virus.`corona virus`;

-- Average confirmed cases
SELECT AVG(confirmed) AS average_confirmed_cases
FROM corona_virus.`corona virus`;

-- Variance of confirmed cases
SELECT VARIANCE(confirmed) AS variance_confirmed_cases
FROM corona_virus.`corona virus`;

-- Standard deviation of confirmed cases
SELECT STDDEV(confirmed) AS stdev_confirmed_cases
FROM corona_virus.`corona virus`;

-- Alternative query

SELECT COUNT(*) AS total_confirmed_cases,
AVG (confirmed) AS average_confirmed_cases,
VARIANCE(confirmed) AS variance_confirmed_cases,
STDDEV(confirmed) AS stdev_confirmed_cases
FROM corona_virus.`corona virus`;

-- Q12. Check how corona virus spread out with respect to death case per month
--      (Eg.: total confirmed cases, their average, variance & STDEV )

-- Total death cases per month
SELECT YEAR(date) AS year,
       MONTH(date) AS month,
       SUM(deaths) AS total_death_cases
FROM corona_virus.`corona virus`
GROUP BY YEAR(date), MONTH(date);

-- Average death cases per month

SELECT YEAR(date) AS year,
       MONTH(date) AS month,
       AVG(deaths) AS average_death_cases
FROM corona_virus.`corona virus`
GROUP BY YEAR(date), MONTH(date);

-- Variance of death cases per month
SELECT YEAR(date) AS year,
       MONTH(date) AS month,
       VARIANCE(deaths) AS variance_death_cases
FROM corona_virus.`corona virus`
GROUP BY YEAR(date), MONTH(date);

-- Standard deviation of death cases per month
SELECT YEAR(date) AS year,
       MONTH(date) AS month,
       STDDEV(deaths) AS stdev_death_cases
FROM corona_virus.`corona virus`
GROUP BY YEAR(date), MONTH(date);

-- Alternative query

SELECT YEAR(date) AS year,
       MONTH(date) AS month,
       SUM(deaths) AS total_death_cases,
       AVG(deaths) AS average_death_cases,
       VARIANCE(deaths) AS variance_death_cases,
       STDDEV(deaths) AS stdev_death_cases
FROM corona_virus.`corona virus`
GROUP BY YEAR(date), MONTH(date);

-- Q13. Check how corona virus spread out with respect to recovered case
--      (Eg.: total confirmed cases, their average, variance & STDEV )

-- Total recovered cases
SELECT COUNT(*) AS total_recovered_cases
FROM corona_virus.`corona virus`
WHERE recovered > 0;

-- Average recovered cases
SELECT AVG(recovered) AS average_recovered_cases
FROM corona_virus.`corona virus`
WHERE recovered > 0;

-- Variance of recovered cases
SELECT VARIANCE(recovered) AS variance_recovered_cases
FROM corona_virus.`corona virus`
WHERE recovered > 0;

-- Standard deviation of recovered cases
SELECT STDDEV(recovered) AS stdev_recovered_cases
FROM corona_virus.`corona virus`
WHERE recovered > 0;

-- Alternative Query

SELECT COUNT(*) AS total_recovered_cases,
AVG(recovered) AS average_recovered_cases,
VARIANCE(recovered) AS variance_recovered_cases,
STDDEV(recovered) AS stdev_recovered_cases
FROM corona_virus.`corona virus`
WHERE recovered > 0;

-- Q14. Find Country having highest number of the Confirmed case

SELECT `Country/Region`, `Province`
FROM corona_virus.`corona virus`
WHERE confirmed = (
    SELECT MAX(confirmed)
    FROM corona_virus.`corona virus`
);

Select max(Confirmed) FROM corona_virus.`corona virus`
WHERE `Country/Region`= 'Turkey';

-- Q15. Find Country having lowest number of the death case

SELECT DISTINCT (`Country/Region`), Deaths
FROM corona_virus.`corona virus`
WHERE deaths = (
    SELECT MIN(deaths)
    FROM corona_virus.`corona virus`
);

SELECT `Country/Region`, MIN(deaths) AS death_count
FROM corona_virus.`corona virus` 
GROUP BY  `Country/Region`
ORDER BY `Country/Region` ASC
limit 5;
    
-- Q16. Find top 5 countries having highest recovered case

SELECT DISTINCT UPPER(TRIM(`Country/Region`)) AS country, SUM(recovered) AS total_recovered
FROM corona_virus.`corona virus`
GROUP BY UPPER(TRIM(`Country/Region`))  -- Group by the cleaned country name
ORDER BY total_recovered DESC
LIMIT 5;

SELECT COUNT(*) AS total_recovered_cases
FROM corona_virus.`corona virus`
WHERE recovered > 0;

SELECT COUNT(*) AS total_recovered_cases
FROM corona_virus.`corona virus`
WHERE Deaths > 0;

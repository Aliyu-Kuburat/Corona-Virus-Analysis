# Corona-Virus-Analysis

## Project: Corona Virus Analysis

### Statement Problem

The coronavirus pandemic has had a significant impact on public health and has created an urgent
need for data-driven insights to understand the spread of the virus. As a data analyst, you have been
tasked with analyzing a CORONA VIRUS dataset to derive meaningful insights and present your findings.

### Dataset:
**Description of some of the columns in the dataset based on importance:**
**Province:** Geographic subdivision within a country/region.
**Country/Region:** Geographic entity where data is recorded.
**Latitude:** North-south position on Earth's surface.
**Longitude:** East-west position on Earth's surface.
**Date:** Recorded date of CORONA VIRUS data.
**Confirmed:** Number of diagnosed CORONA VIRUS cases.
**Deaths:** Number of CORONA VIRUS-related deaths.
**Recovered:** Number of recovered CORONA VIRUS cases.

## Exploratory Analysis

The objective was a guide to the data exploration. The most important thing I did was to confirm that the provided data could answer the objective.

 - I extracted the first 1000 rows from my data and imported them into MySQL to be sure everything was fine with the data and ready for analysis. 
 - I encountered an issue with the data column, there was a data inconsistency issue.
 - I used text-to-column to correct that in Excel and converted it to MySQL-approved date format, YYYY-MM-DD.
 - I dropped the already imported practice data and tried again with the updated practice data. The test was a success and I imported my entire data set for analysis.
   
## Analysis

Check the uploaded folder for detailed information on image extraction from MySQL

SHOW TABLES;
```SELECT * FROM corona_virus. `corona virus`;```

1.	Write a code to check NULL values
SELECT * FROM corona_virus. `corona virus`
WHERE Province IS NULL;

SELECT * FROM corona_virus. `corona virus`
WHERE COALESCE (Longitude, '') = '';
 
2.	If NULL values are present, update them with zeros for all columns. 
       There was no null value present in the data
3.	 Check total number of rows
 
 SELECT COUNT (*) AS total_rows
FROM corona_virus. `corona virus`;
 

ALTER TABLE corona_virus.`corona virus`
MODIFY Date date;
Needed to modify the date column to a date data type
I check if it was properly updated by this query: 
DESCRIBE corona_virus. `corona virus`;
SHOW COLUMNS FROM corona_virus. `corona virus`;
 
4.	 Check what is start_date and end_date

SELECT MIN(Date) AS Start_date, MAX(Date) AS end_date
FROM corona_virus. `corona virus`;
 

5.	Number of months present in dataset
SELECT COUNT (DISTINCT MONTH(Date)) AS num_months
FROM corona_virus. `corona virus`;
 
6.	Find monthly average for confirmed, deaths, recovered

SELECT YEAR (date) AS year,
       MONTH (date) AS month,
       AVG (confirmed) AS avg_confirmed,
       AVG (deaths) AS avg_deaths,
       AVG (recovered) AS avg_recovered
FROM corona_virus. `corona virus`
GROUP BY YEAR (date), MONTH (date)
ORDER BY YEAR (date), MONTH (date);

 
7.	 Find most frequent value for confirmed, deaths, recovered each month 
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
    ROW_NUMBER () OVER (PARTITION BY YEAR('date'), MONTH('date') ORDER BY COUNT (*) DESC) AS rn_confirmed,
    ROW_NUMBER () OVER (PARTITION BY YEAR('date'), MONTH('date') ORDER BY COUNT (*) DESC) AS rn_deaths,
    ROW_NUMBER () OVER (PARTITION BY YEAR('date'), MONTH('date') ORDER BY COUNT(*) DESC) AS rn_recovered,
    MAX (confirmed) AS confirmed_mode,
    MAX (deaths) AS deaths_mode,
    MAX (recovered) AS recovered_mode
  FROM
    corona_virus. `corona virus`
  GROUP BY
    YEAR('date'), MONTH('date'), confirmed, deaths, recovered
) AS monthly_data
WHERE
  rn_confirmed = 1 AND rn_deaths = 1 AND rn_recovered = 1;
 
8.	 Find minimum values for confirmed, deaths, recovered per year
SELECT 
    YEAR(Date) AS year,
    MIN (confirmed) AS min_confirmed,
    MIN (deaths) AS min_deaths,
    MIN (recovered) AS min_recovered
FROM 
    corona_virus. `corona virus`
GROUP BY 
    YEAR(Date);
 
    
9.	Find maximum values of confirmed, deaths, recovered per year
SELECT 
    YEAR(Date) AS year,
    MAX (confirmed) AS max_confirmed,
    MAX (deaths) AS max_deaths,
    MAX (recovered) AS max_recovered
FROM 
    corona_virus. `corona virus`
GROUP BY 
    YEAR(Date);
 
    
10.	The total number of cases of confirmed, deaths, recovered each month
    
   SELECT 
    YEAR(Date) AS year,
    MONTH(Date) AS month,
    SUM (confirmed) AS total_confirmed,
    SUM (deaths) AS total_deaths,
    SUM (recovered) AS total_recovered
FROM 
    corona_virus. `corona virus`
GROUP BY 
    YEAR(Date), MONTH(Date);
 

-- A query to show month Name
SELECT 
    YEAR(Date) AS year,
    MONTH(Date) AS month,
    SUM (confirmed) AS total_confirmed, 
    SUM (deaths) AS total_deaths, 
    SUM (recovered) AS total_recovered, 
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
    corona_virus. `corona virus`
GROUP BY 
    YEAR(Date), MONTH(Date), month_name;
    
    -- Alternative query to show Month Name
    
    SELECT
  YEAR(Date) AS year,
  MONTH(Date) AS month,
  SUM (confirmed) AS total_confirmed,
  SUM (deaths) AS total_deaths,
  SUM (recovered) AS total_recovered,
  DATE_FORMAT (Date, '%M') AS month_name
FROM corona_virus. `corona virus`
GROUP BY YEAR(Date), MONTH(Date), month_name;

 
11. Check how corona virus spread out with respect to confirmed case
(E.g.: total confirmed cases, their average, variance & STDEV)
    
SELECT COUNT (*) AS total_confirmed_cases,
AVG (confirmed) AS average_confirmed_cases,
VARIANCE (confirmed) AS variance_confirmed_cases,
STDDEV (confirmed) AS stdev_confirmed_cases
FROM corona_virus. `corona virus`;
 
-- Q12. Check how corona virus spread out with respect to death case per month
-- (E.g.: total confirmed cases, their average, variance & STDEV)

SELECT YEAR (date) AS year,
       MONTH (date) AS month,
       SUM (deaths) AS total_death_cases,
       AVG (deaths) AS average_death_cases,
       VARIANCE (deaths) AS variance_death_cases,
       STDDEV (deaths) AS stdev_death_cases
FROM corona_virus. `corona virus`
GROUP BY YEAR (date), MONTH (date);
 

13. Check how corona virus spread out with respect to recovered case
-- (E.g.: total confirmed cases, their average, variance & STDEV)

SELECT COUNT (*) AS total_recovered_cases,
AVG (recovered) AS average_recovered_cases,
VARIANCE (recovered) AS variance_recovered_cases,
STDDEV (recovered) AS stdev_recovered_cases
FROM corona_virus. `corona virus`
WHERE recovered > 0;
 
14. Find Country having highest number of the Confirmed case

SELECT `Country/Region`, `Province`
FROM corona_virus. `corona virus`
WHERE confirmed = (
    SELECT MAX (confirmed)
    FROM corona_virus. `corona virus`
);
 
--A check Query 
Select max (Confirmed) FROM corona_virus. `corona virus`
WHERE `Country/Region`= 'Turkey';
 
15. Find Country having lowest number of the death case

SELECT DISTINCT (`Country/Region`), Deaths
FROM corona_virus. `corona virus`
WHERE deaths = (
    SELECT MIN (deaths)
    FROM corona_virus. `corona virus`
);
     
-- Q16. Find top 5 countries having highest recovered case

SELECT `Country/Region`, recovered
FROM corona_virus. `corona virus`
ORDER BY recovered DESC
LIMIT 5;
 


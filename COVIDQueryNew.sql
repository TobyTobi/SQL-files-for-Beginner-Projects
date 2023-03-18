-- COVID data was gathered from 
--https://ourworldindata.org/covid-cases

-- View World Population table
SELECT * FROM [Tobiloba].[dbo].[worldpop]


-- View COVID table
SELECT * FROM [Tobiloba].[dbo].[COVID]
ORDER BY Location


-- Delete null values
DELETE FROM [Tobiloba].[dbo].[COVID]
WHERE Location is null OR Date is null OR newcases is null OR newdeaths is null


-- Find the sum of newcases/newdeaths for all countries
SELECT Location, SUM(newcases) AS totalcases, SUM(newdeaths) AS totaldeaths
FROM [Tobiloba].[dbo].[COVID]
GROUP BY Location
ORDER BY Location, totalcases
-- The total newcases and newdeaths for 234 countries is recorded


-- Saved the results as a COVIDTotal table and import it back into SQL Server


-- Find the country with the highest cases using subquery
SELECT Location, newcases
FROM [Tobiloba].[dbo].[COVIDTotal]
WHERE newcases = (SELECT MAX(newcases) FROM [Tobiloba].[dbo].[COVIDTotal] WHERE Location != 'World')
-- The United States has the highest number of newcases with 102,357,016 newcases


-- Find the country with the lowest cases using subquery
SELECT Location, newcases
FROM [Tobiloba].[dbo].[COVIDTotal]
WHERE newcases = (SELECT MIN(newcases) FROM [Tobiloba].[dbo].[COVIDTotal] WHERE Location != 'World')
-- North Korea and Turkmenistan both have 0 cases


-- Find the countries with the highest newdeaths using subquery
SELECT Location, newdeaths
FROM [Tobiloba].[dbo].[COVIDTotal]
WHERE newdeaths = (SELECT MAX(newdeaths) FROM [Tobiloba].[dbo].[COVIDTotal] WHERE Location != 'World')
-- The United States has the highest number of newdeaths with 1,115,666 newdeaths


-- Find the countries with the lowest newdeaths using subquery
SELECT Location, newdeaths
FROM [Tobiloba].[dbo].[COVIDTotal]
WHERE newdeaths = (SELECT MIN(newdeaths) FROM [Tobiloba].[dbo].[COVIDTotal] WHERE Location != 'World')
-- Falkland Islands, Niue, North Korea, Pitcairn, Saint Helena, Tokelau, Turkmenistan, 
-- Tuvalu, Vatican have the lowest number of newdeaths with 0 newdeaths each


-- Find the sum of cases and deaths in the world
SELECT SUM(a.newcases) AS newcases, SUM(a.newdeaths) AS newdeaths,
SUM(b.population) AS TotalPopulation
FROM[Tobiloba].[dbo].[COVIDTotal] a
INNER JOIN [Tobiloba].[dbo].[worldpop] b
ON a.Location = b.Location
WHERE a.Location != 'World'
-- There have been 760,289,269 cases and 6,872,081 deaths


-- Find the number of cases and deaths per 10000 for the world
SELECT SUM(a.newcases)/SUM(b.population) * 10000 AS newcasesper10000,
SUM(a.newdeaths)/SUM(b.population) * 10000 AS newdeathsper1000
FROM [Tobiloba].[dbo].[COVIDTotal] a
INNER JOIN [Tobiloba].[dbo].[worldpop] b
ON a.Location = b.Location
-- About 951 out of every 10000 people in the world have been infected by virus and
-- About 9 out of every 10000 people in the world have died from the virus


-- Find the highest newcases per 10000
SELECT a.Location, a.newcases, a.newcases/b.population *10000 AS newcasesper10000
FROM [Tobiloba].[dbo].[COVIDTotal] a
INNER JOIN [Tobiloba].[dbo].[worldpop] b
ON a.Location = b.Location
ORDER BY newcasesper10000 DESC
-- About 7000 out of every 10000 people in San Marino have been infected


-- Find the lowest case per 10000
SELECT a.Location, a.newcases/b.population *10000 AS newcasesper10000
FROM [Tobiloba].[dbo].[COVIDTotal] a
INNER JOIN [Tobiloba].[dbo].[worldpop] b
ON a.Location = b.Location
ORDER BY newcasesper10000 ASC
-- About 3 out of every 10000 people in Yemen have been infected


-- Find the highest death per 10000
SELECT a.Location, b.population AS Population,
a.newdeaths/b.population * 10000 AS newdeathsper10000
FROM [Tobiloba].[dbo].[COVIDTotal] a
INNER JOIN [Tobiloba].[dbo].[worldpop] b
ON a.Location = b.Location
ORDER BY newdeathsper10000 DESC
-- About 64 out of every 1000 people in Peru population have died from the virus


-- Find the lowest death per 10000
SELECT a.Location, a.newdeaths/b.population * 10000 AS newdeathsper10000
FROM [Tobiloba].[dbo].[COVIDTotal] a
INNER JOIN [Tobiloba].[dbo].[worldpop] b
ON a.Location = b.Location
ORDER BY newdeathsper10000
-- 0 out of every 10000 people from the Falkland Islands, Niue, North Korea, Pitcairn, Saint Helena, Tokelau, Turkmenistan, 
-- Tuvalu, Vatican have have died from the virus


-- Find the percent of infected people that have died
SELECT a.Location, b.Population, a.newcases AS Cases,
a.newdeaths AS Deaths, a.newcases/b.population*10000 AS PrevalenceRatePer10000,
a.newdeaths/b.population*10000 AS MortalityRatePer10000,
a.newdeaths/a.newcases *100 AS FatalityRate
FROM [Tobiloba].[dbo].[COVIDTotal] a
INNER JOIN [Tobiloba].[dbo].[worldpop] b
ON a.Location = b.Location
WHERE a.newdeaths != 0
ORDER BY a.Location ASC
-- Save as a table
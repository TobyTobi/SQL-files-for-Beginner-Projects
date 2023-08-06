SELECT * FROM [Tobiloba].[dbo].[NigeriaRent]

-- There are 97,586 data entries


-- Delete Location Column
ALTER TABLE [Tobiloba].[dbo].[NigeriaRent]
DROP COLUMN Location

-- View the entire table
SELECT * FROM [Tobiloba].[dbo].[NigeriaRent]

-- Check for NULL entries
SELECT * FROM [Tobiloba].[dbo].[NigeriaRent]
WHERE Bedrooms IS NULL OR Bathrooms IS NULL OR Toilets IS NULL
ORDER BY State

-- There are 5,417 null entries. Delete them
DELETE FROM [Tobiloba].[dbo].[NigeriaRent]
WHERE Bedrooms IS NULL OR Bathrooms IS NULL OR Toilets IS NULL

-- View the table
SELECT * FROM [Tobiloba].[dbo].[NigeriaRent]
-- There are now 92,169 entries

-- Get data types
SELECT 
TABLE_CATALOG,
TABLE_SCHEMA,
TABLE_NAME, 
COLUMN_NAME, 
DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'NigeriaRent'
-- All data types are correct

-- Delete entries with invalid rent prices
SELECT DISTINCT Price FROM NigeriaRent
ORDER BY Price ASC

DELETE FROM NigeriaRent
WHERE Price < 50000

-- Find the average rent price for each state
SELECT State, AVG(Price) AS AvgRentState FROM NigeriaRent
GROUP BY State
ORDER BY State

-- Find the average rent price for each city in each state
SELECT State, City, AVG(Price) AS AvgRentCity FROM NigeriaRent
GROUP BY State, City
ORDER BY State, City

-- Find the number of serviced apartments by state
SELECT State, COUNT(Serviced) AS ServiceTrue
FROM NigeriaRent
WHERE Serviced = 1
GROUP BY State
ORDER BY State

--Find the number of apartments that are not serviced by state
SELECT State, COUNT(Serviced) AS ServiceFalse
FROM NigeriaRent
WHERE Serviced = 0
GROUP BY State
ORDER BY State

-- Maximum for each state
SELECT State, MAX(Price) FROM NigeriaRent
GROUP BY State
ORDER BY State
-- Lagos has the most expensive price

-- Minimum for each state
SELECT State, MIN(Price) FROM NigeriaRent
GROUP BY State
ORDER BY State
-- Delta State has the cheapest house on record

-- Percentage of serviced apartments posted
SELECT(SELECT COUNT(Serviced) FROM NigeriaRent
WHERE Serviced = 1)*100.0/(SELECT COUNT(Serviced)
FROM NigeriaRent) AS PercentServiced;
-- 16.5% of apartments posted are serviced

-- Percentage of furnished apartments posted
SELECT(SELECT COUNT(Furnished) FROM NigeriaRent
WHERE Furnished = 1)*100.0/(SELECT COUNT(Furnished)
FROM NigeriaRent) AS PercentFurnished;
-- 12.5% of apartments posted are furnished

-- Percentage of newly built apartments apartments posted
SELECT(SELECT COUNT([Newly Built]) FROM NigeriaRent
WHERE [Newly Built] = 1)*100.0/(SELECT COUNT([Newly Built])
FROM NigeriaRent) AS PercentNew;
-- 30.5% of apartments posted are new
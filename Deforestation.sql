-- View the forest_area table
SELECT * FROM dbo.forest_area
/*
There are 5,886 rows and 4 columns:
Country Code
Country Name
Year
Forest Area
*/

-- View the land_area table
SELECT * FROM dbo.land_area
/*
There are 5,886 rows and 4 columns:
Country Code
Country Name
Year
Total Area
*/

-- View the regions table
SELECT * FROM dbo.regions
/*
There are 5,886 rows and 4 columns:
Country Code
Country Name
Region
Income group
*/

-- Identify the null values from the forest_area table
SELECT * FROM dbo.forest_area
WHERE forest_area_sqkm IS NULL
/*
There are 316 rows of null values.
They have to be deleted
*/

DELETE FROM dbo.forest_area
WHERE forest_area_sqkm IS NULL
/*
They have been deleted
*/

-- Identify the null values from the land_area table
SELECT * FROM dbo.land_area
WHERE total_area_sq_mi IS NULL
/*
There are 78 rows of null values.
They have to be deleted
*/

DELETE FROM dbo.land_area
WHERE total_area_sq_mi IS NULL
/*
They have been deleted
*/

-- Identify the null values from the regions table
SELECT * FROM dbo.regions
WHERE income_group IS NULL OR region IS NULL
/*
There are no null values
*/

-- Check if there are duplicate values in the forest_area table
SELECT DISTINCT * FROM dbo.forest_area
/*
There are 5570 rows. Since 316 rows were deleted for having null
values, it means there are no duplicates (5586 rows initially)
*/

-- Check if there are duplicate values in the land_area table
SELECT DISTINCT * FROM dbo.land_area
/*
There are 5808 rows. Since 78 rows were deleted for having null
values, it means there are no duplicates (5586 rows initially)
*/

-- Check if there are duplicate values in the land_area table
SELECT DISTINCT * FROM dbo.regions
/*
There are no duplicates. This dataset is not too unclean
*/

-- View the income groups available
SELECT DISTINCT income_group FROM dbo.regions
/*
There is a null value. Let us check it and delete it
*/

SELECT * FROM dbo.regions
WHERE income_group = 'NULL'
/*
It is infocmation for the whole world, so we can delete it
*/

DELETE FROM dbo.regions
WHERE income_group = 'NULL'
/*
It has been deleted
*/

-- Set country_code as Primary Key for regions table
ALTER TABLE dbo.regions --Set the column to not allow null values
ALTER COLUMN country_code NVARCHAR(50) NOT NULL;

ALTER TABLE dbo.regions -- Set the column as a primary key
ADD PRIMARY KEY (country_code)

-- Delete all the entries for world in all the tables
DELETE FROM dbo.forest_area -- forest area
WHERE [Country Name] = 'World'

SELECT DISTINCT [Country Name] FROM dbo.regions;

DELETE FROM dbo.land_area -- land area
WHERE [Country Name] = 'World'

DELETE FROM dbo.regions -- regions
WHERE [Country Name] = 'World'


-- Calculate the percentage of land that are forests
SELECT DISTINCT A.country_code AS [Country Code],
		A.[Country Name] AS [Country Name],
		A.region AS Region,
		A.income_group AS [Income Group],
		B.year AS Year,
		B.forest_area_sqkm AS [Forest Area],
		C.total_area_sq_mi * 2.58999 AS [Total Area], -- convert to km
		(((B.forest_area_sqkm)/(C.total_area_sq_mi * 2.58999)) * 100) AS [Percentage Forest]
FROM dbo.regions A
FULL JOIN dbo.forest_area B
	ON A.country_code = B.country_code
INNER JOIN dbo.land_area C
	ON B.country_code = C.country_code
ORDER BY B.year, A.[Country Name]

-- Percentage forest grouped by year
SELECT Year, AVG([Percentage Forest]) AS forest_percentage_total
FROM forest_area
GROUP BY Year
ORDER BY Year

-- Countries that have lost the most forest area
SELECT TOP 10
	Initial.[Country Name] AS Country,
	Initial.[Forest Area] AS Initial_Area,
	Final.[Forest Area] AS Final_Area,
	(Final.[Forest Area] - Initial.[Forest Area])/Initial.[Forest Area] * 100 AS PercentCountry
FROM
	(SELECT [Country Name], [Forest Area]
	FROM forest_area
	WHERE Year = 1990) AS Initial
JOIN
	(SELECT [Country Name], [Forest Area]
	FROM forest_area
	WHERE Year = 2016) AS Final
ON Initial.[Country Name] = Final.[Country Name]
ORDER BY PercentCountry

-- Countries that have gained the most forest area
SELECT TOP 10
	Initial.[Country Name] AS Country,
	Initial.[Forest Area] AS Initial_Area,
	Final.[Forest Area] AS Final_Area,
	(Final.[Forest Area] - Initial.[Forest Area])/Initial.[Forest Area] * 100 AS PercentCountry
FROM
	(SELECT [Country Name], [Forest Area]
	FROM forest_area
	WHERE Year = 1990) AS Initial
JOIN
	(SELECT [Country Name], [Forest Area]
	FROM forest_area
	WHERE Year = 2016) AS Final
ON Initial.[Country Name] = Final.[Country Name]
ORDER BY PercentCountry DESC

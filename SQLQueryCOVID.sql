-- Select all columns and rows from the table
SELECT * FROM Tobiloba..CovidDeaths

-- View the distinct countries
SELECT DISTINCT Location, Continent FROM Tobiloba..CovidDeaths
GROUP BY Location, Continent
ORDER BY Location


-- There are a few unwanted locations e.g. Africa, World, Europe..., so, for all following code, we have to include the clause:
/* WHERE Continent IS NOT NULL */


-- Select data to be used ordered by location and date
SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM Tobiloba..CovidDeaths
WHERE Continent IS NOT NULL
ORDER BY 1, 2

-- Take a look at the total cases, total deaths, and death rate
SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases) *100 AS death_rate
FROM Tobiloba..CovidDeaths
WHERE Continent IS NOT NULL
ORDER BY 1, 2

-- Take a look at the percentage of the percentage of the population 
-- that has contracted COVID-19
SELECT Location, date, total_cases, Population, (total_cases/population) *100 AS death_percent
FROM Tobiloba..CovidDeaths
WHERE Continent IS NOT NULL
ORDER BY 1, 2

-- Take a look at the countries with the highest infection rate
SELECT Location, Population, MAX(total_cases) AS Highest, MAX((total_cases/population) *100) AS PercentInfected
FROM Tobiloba..CovidDeaths
WHERE Continent IS NOT NULL
GROUP BY Location, Population
ORDER BY PercentInfected DESC

-- Take a look at the countries with the highest death count per population
SELECT Location, MAX(CAST(total_deaths AS INT)) AS TotalDeathCount -- Cast the total deaths as an integer
FROM Tobiloba..CovidDeaths
WHERE Continent IS NOT NULL
GROUP BY Location
ORDER BY TotalDeathCount DESC


-- Take a look at the death counts grouped by Continent
SELECT Continent, MAX(CAST(total_deaths AS INT)) AS TotalDeathCount -- Cast the total deaths as an integer
FROM Tobiloba..CovidDeaths
WHERE Continent IS NOT NULL
GROUP BY Continent
ORDER BY TotalDeathCount DESC


-- Take a look at the global numbers grouped by date
SELECT date, SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS INT)) AS total_deaths, 
SUM(CAST(new_deaths AS INT))/SUM(new_cases) *100 AS totaldeath_percent
FROM Tobiloba..CovidDeaths
WHERE Continent IS NOT NULL
GROUP BY date
ORDER BY 1, 2

SELECT SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS INT)) AS total_deaths, 
SUM(CAST(new_deaths AS INT))/SUM(new_cases) *100 AS totaldeath_percent
FROM Tobiloba..CovidDeaths
WHERE Continent IS NOT NULL
ORDER BY 1, 2

-- Let us take a look at the Vaccinations table
SELECT * FROM Tobiloba..CovidVaccinations

-- Join the two tables: CovidDeaths and CovidVaccinations
SELECT * FROM Tobiloba..CovidDeaths dea
JOIN Tobiloba..CovidVaccinations vac
ON dea.location = vac.location AND dea.date = vac.date

-- Take a look at total population vs total vaccinations
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FROM Tobiloba..CovidDeaths dea
JOIN Tobiloba..CovidVaccinations vac
ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2, 3

-- Take a look at total population vs total vaccinations
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(BIGINT, vac.new_vaccinations)) OVER (PARTITION BY dea.Location ORDER BY 
	dea.location, dea.date ROWS UNBOUNDED PRECEDING) AS VaccRolling
FROM Tobiloba..CovidDeaths dea
JOIN Tobiloba..CovidVaccinations vac
ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2, 3



-- Now, take a look at the percentage of the population that is vaccinated
-- by using a common table expression to create a temporary table
WITH VaccPop (Continent, Location, Date, Population, New_Vaccinations, VaccRolling)
AS (
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(BIGINT, vac.new_vaccinations)) OVER (PARTITION BY dea.Location ORDER BY 
	dea.location, dea.date ROWS UNBOUNDED PRECEDING) AS VaccRolling

FROM Tobiloba..CovidDeaths dea
JOIN Tobiloba..CovidVaccinations vac
	ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
)
SELECT *, (VaccRolling/Population) *100 FROM VaccPop



-- Another way of doing this is to use the Create Table function:
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
VaccRolling numeric
)
INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(BIGINT, vac.new_vaccinations)) OVER (PARTITION BY dea.Location ORDER BY 
	dea.location, dea.date ROWS UNBOUNDED PRECEDING) AS VaccRolling

FROM Tobiloba..CovidDeaths dea
JOIN Tobiloba..CovidVaccinations vac
	ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
SELECT *, (VaccRolling/Population) * 100 AS RollingPercentVaccinatd FROM #PercentPopulationVaccinated


-- Let us create a view for visualization later
CREATE VIEW Vaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(BIGINT, vac.new_vaccinations)) OVER (PARTITION BY dea.Location ORDER BY 
	dea.location, dea.date ROWS UNBOUNDED PRECEDING) AS VaccRolling
FROM Tobiloba..CovidDeaths dea
JOIN Tobiloba..CovidVaccinations vac
	ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
GO
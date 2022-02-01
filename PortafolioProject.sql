SELECT *
FROM PortafolioProject..CovidDeaths
ORDER BY 3,4

-- SELECT *
-- FROM PortafolioProject..CovidVaccinations
-- ORDER BY 3,4

-- Select Data that we are going to be using

SELECT [location], [date], total_cases, new_cases, total_deaths, population 
FROM PortafolioProject..CovidDeaths
GO

-- LOOKING AT TOTAL CASES VS TOTAL DEATHS
-- Select rows from a Table or Portafolio' in schema '[dbo]'
SELECT [location], [date], total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM PortafolioProject..CovidDeaths
ORDER BY 1,2
GO

-- Get a list of tables and views in the current database
SELECT table_catalog [PortafolioProject], table_schema [schema], table_name [name], table_type [type]
FROM INFORMATION_SCHEMA.TABLES
GO

-- Shows the likelihood of dying if you contract Covid in your country
SELECT [location], [date], total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM PortafolioProject..CovidDeaths
WHERE location LIKE '%many%'
ORDER BY 1,2
GO

-- LOOKING AT TOTAL CASES VS POPULATION
-- Shows what percentage of population got Covid
SELECT [location], [date], total_cases, population, (total_cases/population)*100 AS PopulationPercentage
FROM PortafolioProject..CovidDeaths
WHERE location LIKE '%states%'
ORDER BY 1,2
GO

-- Looking at Countries with Highest Infaction Rate compared to Population
SELECT [location], Population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 AS PercentagePopulationInfected
FROM PortafolioProject..CovidDeaths
--WHERE location LIKE '%states%'
GROUP BY [location], Population
ORDER BY PercentagePopulationInfected DESC
GO

-- Showing Countries with the Highest Death Count per Population
SELECT [location], MAX(cast(total_deaths as int)) AS TotalDeathCount 
FROM PortafolioProject..CovidDeaths
--WHERE location LIKE '%states%'
WHERE continent is not NULL
GROUP BY [location]
ORDER BY TotalDeathCount DESC
GO

-- Let's break things down by continent 
SELECT [continent], MAX(cast(total_deaths as int)) AS TotalDeathCount 
FROM PortafolioProject..CovidDeaths
--WHERE location LIKE '%states%'
WHERE continent is not NULL
GROUP BY [continent]
ORDER BY TotalDeathCount DESC
GO

-- Let's break things down by location 
SELECT [location], MAX(cast(total_deaths as int)) AS TotalDeathCount 
FROM PortafolioProject..CovidDeaths
--WHERE location LIKE '%states%'
WHERE [continent] is NULL
GROUP BY [location]
ORDER BY TotalDeathCount DESC
GO

-- Global numbers
SELECT [date], SUM(new_cases) -- total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM PortafolioProject..CovidDeaths
-- WHERE location LIKE '%many%'
WHERE continent is not null 
GROUP BY date
ORDER BY 1,2
GO

SELECT SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 AS DeathPercentage
FROM PortafolioProject..CovidDeaths
WHERE continent is not NULL
--GROUP By [date]
ORDER By 1,2
GO

SELECT *
FROM PortafolioProject..CovidVaccinations
GO

-- Join two tables
SELECT *
FROM PortafolioProject..CovidDeaths dea
JOIN PortafolioProject..CovidVaccinations vac 
    ON dea.[location] = vac.[location]
    AND dea.[date] = vac.[date]

-- Looking at total vaccination vs total population
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FROM PortafolioProject..CovidDeaths dea 
JOIN PortafolioProject..CovidVaccinations vac 
    ON dea.[location] = vac.[location]
    AND dea.[date] = vac.[date]
ORDER By 1,2,3
GO

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FROM PortafolioProject..CovidDeaths dea 
JOIN PortafolioProject..CovidVaccinations vac 
    ON dea.[location] = vac.[location]
    AND dea.[date] = vac.[date]
ORDER By 1,2,3
GO

-- Creating a View to store data for later visualizations
CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition By
dea.location order by dea.location, dea.Date) as RollingPeopleVaccinated
FROM PortafolioProject..CovidDeaths dea 
JOIN PortafolioProject..CovidVaccinations vac 
ON dea.[location] = vac.[location]
and dea.date = vac.date 
WHERE dea.continent is not NULL
GO


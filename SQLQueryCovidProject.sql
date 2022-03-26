--SELECT *
--FROM [CovidProject].dbo.[CovidDeadths]
--WHERE CONTINENT is NOT NULL
--ORDER BY 3, 4

--SELECT *
--FROM [CovidProject].dbo.[CovidVaccinations]
--ORDER BY 3, 4

-- Select Data that we are going to be using
--SELECT Location, date, total_cases, new_Cases, total_deaths, population
--FROM [CovidProject].dbo.[CovidDeadths]
--ORDER BY 1, 2

-- Looking at Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country
--SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
--FROM [CovidProject].dbo.[CovidDeadths]
--WHERE location LIKE '%states%'
--ORDER BY 1, 2

-- Looking at Total Cases vs Population
-- Shows what percentage of popultaion got COVID
--SELECT Location, date, population, total_cases, (total_cases/population)*100 AS PercentPopulationInfected
--FROM [CovidProject].dbo.[CovidDeadths]
--WHERE location LIKE '%states%'
--ORDER BY 1, 2

-- Looking at countries with highest infection rate compared to population
--SELECT Location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 AS PercentPopulationInfected
--FROM [CovidProject].dbo.[CovidDeadths]
--GROUP BY location, population
--ORDER BY 4 DESC


-- Showing the countries with highest Death Count per Population
--SELECT location, MAX(CAST(total_deaths as INT)) as TotalDeathCount
--FROM [CovidProject].dbo.[CovidDeadths]
--WHERE continent is NOT NULL
--GROUP BY location
--ORDER BY TotalDeathCount DESC

---------------------- xxxxxxxxxxxxxxxxxxxx --------------------

-- -- Let's break things down by continent
-- Showing the countries with highest Death Count per Population
--SELECT continent, MAX(CAST(total_deaths as INT)) as TotalDeathCount
--FROM [CovidProject].dbo.[CovidDeadths]
--WHERE continent is NOT NULL
--GROUP BY continent
--ORDER BY TotalDeathCount DESC

-- The right way to figure out
--SELECT location, MAX(CAST(total_deaths as INT)) as TotalDeathCount
--FROM [CovidProject].dbo.[CovidDeadths]
--WHERE continent is NULL
--GROUP BY location
--ORDER BY TotalDeathCount DESC


-- Showing continents with the highest death counts per population
--SELECT continent, MAX(CAST(total_deaths as INT)) as TotalDeathCount
--FROM [CovidProject].dbo.[CovidDeadths]
--WHERE continent is NOT NULL
--GROUP BY continent
--ORDER BY TotalDeathCount DESC


---------------------- xxxxxxxxxxxxxxxxxxxx --------------------
-- Global Numbers
--SELECT date, SUM(new_cases) as total_cases, SUM(CAST(new_deaths as INT)) as total_Deaths, SUM(CAST(new_deaths as INT))/SUM(new_cases)*100 as DeathPercentage
--FROM [CovidProject].dbo.[CovidDeadths]
--WHERE continent is NOT NULL
--GROUP BY date
--ORDER BY 1, 2

-- Death percentage of Covid19 Around the whole globe
--SELECT SUM(new_cases) as total_cases, SUM(CAST(new_deaths as INT)) as total_Deaths, SUM(CAST(new_deaths as INT))/SUM(new_cases)*100 as DeathPercentage
--FROM [CovidProject].dbo.[CovidDeadths]
--WHERE continent is NOT NULL
--ORDER BY 1, 2


---------------------- xxxxxxxxxxxxxxxxxxxx --------------------
-- Let's work on covid Vaccinations
--SELECT *
--FROM [CovidProject].dbo.[CovidVaccinations]
--ORDER BY 3, 4

-- Let's join our two tables 
--SELECT	* 
--FROM [CovidProject].dbo.[CovidDeadths] death
--JOIN [CovidProject].dbo.[CovidVaccinations] vaccination
--	ON death.location = vaccination.location
--	AND death.date = vaccination.date

-- Looking at total population vs vaccination
--SELECT death.continent, death.location, death.population, vaccination.new_vaccinations, 
--	SUM(CONVERT(BIGINT, vaccination.new_vaccinations)) 
--	OVER (PARTITION BY death.location ORDER BY death.location, death.date) as RollingPeopleVaccinated
--FROM [CovidProject].dbo.[CovidDeadths] death
--JOIN [CovidProject].dbo.[CovidVaccinations] vaccination
--	ON death.location = vaccination.location
--	AND death.date = vaccination.date
--WHERE death.continent IS NOT NULL
--ORDER BY 2, 3

--Find out how many people are vaccinated in a country
--SELECT death.location, death.population, SUM(CONVERT(BIGINT, vaccination.new_vaccinations))/death.population*100 as VaccinationPercentage
--FROM [CovidProject].dbo.[CovidDeadths] death
--JOIN [CovidProject].dbo.[CovidVaccinations] vaccination 
--	ON death.location = vaccination.location
--	AND death.date = vaccination.date
--WHERE death.continent IS NOT NULL
--GROUP BY death.location, death.population
--ORDER BY 1

-- Using CTE
--WITH PopulationVsVaccination (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
--AS
--(
--SELECT death.continent, death.location, death.date, death.population, vaccination.new_vaccinations, 
--	SUM(CONVERT(BIGINT, vaccination.new_vaccinations)) 
--	OVER (PARTITION BY death.location ORDER BY death.location, death.date) as RollingPeopleVaccinated
--FROM [CovidProject].dbo.[CovidDeadths] death
--JOIN [CovidProject].dbo.[CovidVaccinations] vaccination
--	ON death.location = vaccination.location
--	AND death.date = vaccination.date
--WHERE death.continent IS NOT NULL
----ORDER BY 2, 3
--)

--SELECT *, (RollingPeopleVaccinated/population)*100
--FROM PopulationVsVaccination


---------------------- xxxxxxxxxxxxxxxxxxxx --------------------
-- Temp Table
--DROP TABLE IF EXISTS #PercentVaccinatedPopulation
--CREATE TABLE #PercentVaccinatedPopulation
--(
--Continent nvarchar(255),
--Location nvarchar(255),
--Date datetime,
--Population numeric,
--New_vaccination numeric,
--RollingPeopleVaccinated numeric
--)

--INSERT INTO #PercentVaccinatedPopulation
--SELECT death.continent, death.location, death.date, death.population, vaccination.new_vaccinations, 
--	SUM(CONVERT(BIGINT, vaccination.new_vaccinations)) 
--	OVER (PARTITION BY death.location ORDER BY death.location, death.date) as RollingPeopleVaccinated
--FROM [CovidProject].dbo.[CovidDeadths] death
--JOIN [CovidProject].dbo.[CovidVaccinations] vaccination
--	ON death.location = vaccination.location
--	AND death.date = vaccination.date
--WHERE death.continent IS NOT NULL

--SELECT *, (RollingPeopleVaccinated/population)*100
--FROM #PercentVaccinatedPopulation


---------------------- xxxxxxxxxxxxxxxxxxxx --------------------
-- Creating view to store data fro later visualizations
-- DROP VIEW PercentVaccinatedPopulation
--CREATE VIEW PercentVaccinatedPopulation AS
--SELECT death.continent, death.location, death.date, death.population, vaccination.new_vaccinations, 
--	SUM(CONVERT(BIGINT, vaccination.new_vaccinations)) 
--	OVER (PARTITION BY death.location ORDER BY death.location, death.date) as RollingPeopleVaccinated
--FROM [CovidProject].dbo.[CovidDeadths] death
--JOIN [CovidProject].dbo.[CovidVaccinations] vaccination
--	ON death.location = vaccination.location
--	AND death.date = vaccination.date
--WHERE death.continent IS NOT NULL

SELECT *
FROM PercentVaccinatedPopulation

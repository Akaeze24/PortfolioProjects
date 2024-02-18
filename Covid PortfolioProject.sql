--Select Top 5 * 
--From PortfolioProject..CovidDeaths
--Order by 3,4;



Select Top 5 * 
From PortfolioProject..CovidDeaths
WHERE continent is not null
Order by 3,4;

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject.dbo.CovidDeaths
ORDER BY 1;

-- TOTAL CASES VS TOTAL DEATHS
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 DeathPercent
FROM PortfolioProject.dbo.CovidDeaths
WHERE location like '%eria'
ORDER BY 1,2;

-- TOTAL CASES VS POPULATION
SELECT location, date,population,total_cases,total_deaths,(total_cases/population)*100 DeathPercentage
FROM PortfolioProject.dbo.CovidDeaths
--WHERE location = 'Nigeria'
WHERE continent is not null
ORDER BY 1,2;

--COUNTRIES WITH HIGHEST VIRIAL INFECTION RATE COMPARED TO POPULATION
SELECT location,population,MAX(total_cases) Highest_CovidVirus, MAX((total_cases/population))*100 CovidVirus_InfectedPecentage
FROM PortfolioProject.dbo.CovidDeaths
--WHERE location = 'Nigeria'
WHERE continent is not null
GROUP BY  location,population
ORDER BY CovidVirus_InfectedPecentage desc;


--COUNTRIES WITH HIGHEST DEATH RATE PER POPULATION
SELECT location, population, MAX(CAST(total_deaths AS INT)) DeathRate
FROM PortfolioProject.dbo.CovidDeaths
--WHERE location = 'Nigeria'
WHERE continent is not null
GROUP BY  location,population
ORDER BY DeathRate desc;


SELECT location, MAX(CAST(total_deaths AS INT)) DeathRate
FROM PortfolioProject.dbo.CovidDeaths
--WHERE location = 'Nigeria'
WHERE continent is null
GROUP BY  location
ORDER BY DeathRate desc;

-- DEATH RATE BY CONTINENT  -- CONTINENT WITH THE HIGHTEST DEATHRATE
SELECT continent, MAX(CAST(total_deaths AS INT)) DeathRate
FROM PortfolioProject.dbo.CovidDeaths
--WHERE location = 'Nigeria'
WHERE continent is not null
GROUP BY  continent
ORDER BY DeathRate desc;


-- GLOBAL NUMBERS
SELECT date, SUM(new_cases) TotalCases, SUM(CAST(new_deaths as int)) TotalDeaths, SUM(CAST(new_deaths as int))/SUM(new_cases)*100 DeathPercentage
FROM  PortfolioProject.dbo.CovidDeaths
--WHERE location = 'Nigeria'
WHERE continent is not null
GROUP BY  date
ORDER BY DeathPercentage desc;

SELECT SUM(new_cases) TotalCases, SUM(CAST(new_deaths as int)) TotalDeaths, SUM(CAST(new_deaths as int))/SUM(new_cases)*100 DeathPercentage
FROM  PortfolioProject.dbo.CovidDeaths
--WHERE location = 'Nigeria'
WHERE continent is not null
ORDER BY DeathPercentage desc;
 


 --Select Top 5 * 
--From PortfolioProject..CovidVaccinations
--Order by 3,4;


SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FROM PortfolioProject.dbo.CovidVaccinations vac
JOIN PortfolioProject.dbo.CovidDeaths dea
ON vac.date = dea.date
and vac.continent = dea.continent
WHERE dea.continent is not null
ORDER BY 2,3


SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) Rolling_VaccinatedPeoples
FROM PortfolioProject.dbo.CovidVaccinations vac
JOIN PortfolioProject.dbo.CovidDeaths dea
ON vac.date = dea.date
and vac.continent = dea.continent
WHERE dea.continent is not null
ORDER BY 2,3

-- TEMP TABLE
--DROP TABLE if exists #VaccinatedPopulation_Percentage
--CREATE TABLE #VaccinatedPopulation_Percentage
--(
--continent nvarchar(250),
--location nvarchar(250),
--date datetime,
--population numeric,
--new_vaccinations numeric,
--Rolling_VaccinatedPeoples numeric
--)
--INSERT INTO #VaccinatedPopulation_Percentage
--SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
--SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) Rolling_VaccinatedPeoples
--FROM PortfolioProject.dbo.CovidVaccinations vac
--JOIN PortfolioProject.dbo.CovidDeaths dea
--ON vac.date = dea.date
--and vac.continent = dea.continent
--WHERE dea.continent is not null
--ORDER BY 2,3

--SELECT *, (Rolling_VaccinatedPeoples/population)*100
--FROM #VaccinatedPopulation_Percentage


-- USE CTE

WITH PopvsVac (continent, location, date, population, new_vaccinations, Rolling_VaccinatedPeoples)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) Rolling_VaccinatedPeoples
FROM PortfolioProject.dbo.CovidVaccinations vac
JOIN PortfolioProject.dbo.CovidDeaths dea
ON vac.date = dea.date
and vac.continent = dea.continent
WHERE dea.continent is not null
--ORDER BY 2,3
)
SELECT * FROM PopvsVac


--CREATE VIEW TO STORE DATA FOR LATER VISUALIZATION

CREATE VIEW	VaccinatedPopulation_Percentage as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date)Rolling_VaccinatedPeoples
FROM PortfolioProject.dbo.CovidVaccinations vac
JOIN PortfolioProject.dbo.CovidDeaths dea
ON vac.date = dea.date
and vac.continent = dea.continent
WHERE dea.continent is not null


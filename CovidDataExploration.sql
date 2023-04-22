-- Ensuring the dataset includes the expected range of values
SELECT
  *
FROM
  [Portfolio Projects]..CovidData
WHERE continent is not null
ORDER BY
  3, 4
 

-- Selecting relevant information for my queries

SELECT
  location,
  date,
  total_cases,
  new_cases,
  total_deaths,
  population
FROM
  [Portfolio Projects]..CovidData
ORDER BY
  1,
  2


-- Looking at Total Cases vs Total Deaths in the United States
-- Shows the likelihood of dying if you contracted Covid in the United States

SELECT
  location,
  date,
  population,
  total_cases,
  total_deaths,
  (total_deaths/total_cases)*100 AS death_rate
FROM
  [Portfolio Projects]..CovidData
WHERE 
  continent is not null
  AND
  location = 'United States'
ORDER BY
  1,
  2

-- Looking at Total Cases vs Population in America

SELECT
  location,
  date,
  population,
  total_cases,
  total_deaths,
  (total_cases/population)*100 AS cases_percentage
FROM
  [Portfolio Projects]..CovidData
WHERE 
  continent is not null
  AND
  location = 'United States'
ORDER BY
  1,
  2

-- Looking at Countries with highest infection rate

SELECT
  location,
  population,
  MAX(total_cases) as highest_infection_count,
  (MAX(total_cases)/population)*100 AS infection_rate
FROM
  [Portfolio Projects]..CovidData
GROUP BY
  location,
  population
ORDER BY
  4 desc

 -- Showing countries with highest death count per population

SELECT
  location,
  MAX(cast(total_deaths as int)) as total_death_count
FROM
  [Portfolio Projects]..CovidData
WHERE
  continent is not null
GROUP BY
  location
ORDER BY
  total_death_count desc
 
-- Breaking things down by continent and income level

SELECT
  location,
  MAX(cast(total_deaths as int)) as total_death_count
FROM
  [Portfolio Projects]..CovidData
WHERE
  continent is null
GROUP BY
  location
ORDER BY
  total_death_count desc
  
-- Global Numbers

SELECT
  date,
  SUM(new_cases) as total_cases,
  SUM(cast(new_deaths as int)) as total_deaths,
  SUM(cast(new_deaths as int))/SUM(new_cases)*100 as death_percentage
FROM
  [Portfolio Projects]..CovidData
WHERE
  continent is not null
  AND
  new_cases > 0
Group By date
ORDER BY
  1,
  2

-- Looking at Total Population vs Vaccinations
-- Using CTE

 With PopvsVac (continent, location, date, population, new_vaccinations, RollingVaccinations)
  as
  (
SELECT
  continent,
  location,
  date,
  population,
  new_vaccinations,
  SUM(CONVERT(numeric, new_vaccinations)) OVER (Partition by location Order by location, date) as RollingVaccinations
  --, (RollingVaccinations/population)*100
FROM [Portfolio Projects]..CovidData
WHERE
  continent is not null
  --order by 2, 3
  )
Select*, (RollingVaccinations/Population)*100 as PercentVaccinated
From PopvsVac

--Creating viewa to store for later visualizations

Create View TotalDeathCount as
SELECT
  location,
  MAX(cast(total_deaths as int)) as total_death_count
FROM
  [Portfolio Projects]..CovidData
WHERE
  continent is null
GROUP BY
  location
--ORDER BY
--  total_death_count desc

Create View PercentPeopleVaccinated as
With PopvsVac (continent, location, date, population, new_vaccinations, RollingVaccinations)
  as
  (
SELECT
  continent,
  location,
  date,
  population,
  new_vaccinations,
  SUM(CONVERT(numeric, new_vaccinations)) OVER (Partition by location Order by location, date) as RollingVaccinations
  --, (RollingVaccinations/population)*100
FROM [Portfolio Projects]..CovidData
WHERE
  continent is not null
  --order by 2, 3
  )
Select*, (RollingVaccinations/Population)*100 as PercentVaccinated
From PopvsVac


Create View DeathPercentage as
SELECT
  date,
  SUM(new_cases) as total_cases,
  SUM(cast(new_deaths as int)) as total_deaths,
  SUM(cast(new_deaths as int))/SUM(new_cases)*100 as death_percentage
FROM
  [Portfolio Projects]..CovidData
WHERE
  continent is not null
  AND
  new_cases > 0
Group By date
--ORDER BY
--  1,
--  2


Create View InfectionRate as
SELECT
  location,
  population,
  MAX(total_cases) as highest_infection_count,
  (MAX(total_cases)/population)*100 AS infection_rate
FROM
  [Portfolio Projects]..CovidData
GROUP BY
  location,
  population
--ORDER BY
--  4 desc

Create View UsaInfectionsPercentage as
SELECT
  location,
  date,
  population,
  total_cases,
  total_deaths,
  (total_cases/population)*100 AS cases_percentage
FROM
  [Portfolio Projects]..CovidData
WHERE 
  continent is not null
  AND
  location = 'United States'
--ORDER BY
--  1,
--  2

Create View UsaDeathRate as
SELECT
  location,
  date,
  population,
  total_cases,
  total_deaths,
  (total_deaths/total_cases)*100 AS death_rate
FROM
  [Portfolio Projects]..CovidData
WHERE 
  continent is not null
  AND
  location = 'United States'
--ORDER BY
--  1,
--  2
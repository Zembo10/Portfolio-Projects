--Total Cases vs Total deaths 
--Shows Likelihood of Dying if You Contract Covid in Saudi Arabia

SELECT Location,Date, Total_Cases, Total_Deaths, (Total_deaths/Total_cases)*100 as Death_Percentage
From PortfolioProject..CovidDeaths
WHERE location like '%Saudi Arabia%' 
order by 1,2

--Looking at The Total Cases vs Population
--Shows Percentage of Population Got Infected in Saudi Arabia

SELECT Location,Date, population, Total_Cases, (Total_Cases/Population)*100 as Affected_Percentage
From PortfolioProject..CovidDeaths
WHERE location like '%Saudi Arabia%' 
order by 1,2
--Shows Percentage of Population Got Infected in The World

SELECT Location,Date, population, Total_Cases, (Total_Cases/Population)*100 as Affected_Percentage
From PortfolioProject..CovidDeaths
WHERE Continent IS NOT NULL
order by 1,2

--Highest Infection Rates Compared to Population

SELECT Location,population, MAX(Total_Cases)as Highest_Infection_Count, MAX((Total_Cases/Population))*100 as Population_Infected_Percent
From PortfolioProject..CovidDeaths
WHERE Continent IS NOT NULL
Group by Location,population
order by Population_Infected_Percent desc

--Shows Highest Death Count Per Population

SELECT Location,population, MAX(CAST(Total_Deaths as INT))as Total_Death_count
From PortfolioProject..CovidDeaths
WHERE Continent IS NOT NULL
Group by Location,population
order by Total_Death_count desc

--Shows The Deaths Count Based on Continent

SELECT Location, MAX(CAST(Total_Deaths as INT))as Total_Death_Count
From PortfolioProject..CovidDeaths
WHERE Continent IS NULL
Group by Location
order by Total_Death_Count desc

--Global Numbers

SELECT Date, SUM(New_Cases) as Total_Cases, SUM(CAST(New_Deaths as INT)) as Total_Deaths,SUM(CAST(New_Deaths as INT)) / SUM(New_Cases)
*100 as Death_Percentage
From PortfolioProject..CovidDeaths
WHERE Continent Is Not Null 
GROUP BY Date
ORDER BY 1,2


--Shows Total Population vs Total Vaccination

SELECT DEA.Continent, DEA.Location, DEA.Date, DEA.Population, VAC.New_Vaccinations,
SUM(CONVERT(INT, VAC.New_Vaccinations)) OVER (PARTITION BY DEA.Location ORDER BY DEA.Location, DEA.Date)as People_Vaccinated
FROM PortfolioProject ..CovidDeaths DEA
JOIN PortfolioProject ..CovidVaccinations VAC
ON DEA.location = VAC.location
AND DEA.Date = VAC.Date 
WHERE DEA.Continent Is Not Null 
ORDER BY 2,3

--CTE 

WITH Population_vs_Vaccination (Continent, Location, Date, pOPULATION, New_Vaccinations, People_Vaccinated)
as
( 
SELECT DEA.Continent, DEA.Location, DEA.Date, DEA.Population, VAC.New_Vaccinations,
SUM(CONVERT(INT, VAC.New_Vaccinations)) OVER (PARTITION BY DEA.Location ORDER BY DEA.Location, DEA.Date)as People_Vaccinated
FROM PortfolioProject ..CovidDeaths DEA
JOIN PortfolioProject ..CovidVaccinations VAC
ON DEA.location = VAC.location
AND DEA.Date = VAC.Date 
WHERE DEA.Continent Is Not Null 
)
SELECT *, (People_Vaccinated/Population)*100
FROM Population_vs_Vaccination


-- Temp Table
	
	DROP TABLE IF EXISTS #PercentPopulationVaccinated
	CREATE TABLE #PercentPopulationVaccinated
	(
	Continent nvarchar(255),
	Location nvarchar(255),
	Date Datetime,
	Population Numeric,
	New_Vaccinations Numeric,
	People_Vaccinated Numeric
	)

	INSERT INTO #PercentPopulationVaccinated
SELECT DEA.Continent, DEA.Location, DEA.Date, DEA.Population, VAC.New_Vaccinations,
SUM(CONVERT(INT, VAC.New_Vaccinations)) OVER (PARTITION BY DEA.Location ORDER BY DEA.Location, DEA.Date)as People_Vaccinated
FROM PortfolioProject ..CovidDeaths DEA
JOIN PortfolioProject ..CovidVaccinations VAC
ON DEA.location = VAC.location
AND DEA.Date = VAC.Date 
WHERE DEA.Continent Is Not Null 
--ORDER BY 1,2,3
SELECT *, (People_Vaccinated/Population)*100 as Percent_Population_Vaccinated
FROM #PercentPopulationVaccinated



-- Creating a View to Store Data For Later Visualizations

CREATE VIEW PercentPopulationVaccinated as
SELECT DEA.Continent, DEA.Location, DEA.Date, DEA.Population, VAC.New_Vaccinations,
SUM(CONVERT(INT, VAC.New_Vaccinations)) OVER (PARTITION BY DEA.Location ORDER BY DEA.Location, DEA.Date)as People_Vaccinated
FROM PortfolioProject ..CovidDeaths DEA
JOIN PortfolioProject ..CovidVaccinations VAC
ON DEA.location = VAC.location
AND DEA.Date = VAC.Date 
WHERE DEA.Continent Is Not Null 
--ORDER BY 2,3
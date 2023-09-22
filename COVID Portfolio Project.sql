SELECT *
FROM dbo.CovidDeaths

SELECT *
FROM dbo.Covidvaccinations

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM dbo.CovidDeaths

SELECT location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as Deathpercentage
FROM dbo.CovidDeaths
WHERE location like '%states%'
ORDER BY 1,2

SELECT location,date,population,total_cases,(total_cases/population)*100 as PopulationInfectedPercentage
FROM dbo.CovidDeaths
--WHERE location like '%states%'
ORDER BY 1,2



SELECT location,population,MAX(total_cases) as HighestInfectionCount,MAX((total_cases/population))*100 as PopulationInfectedPercentage
FROM dbo.CovidDeaths
--WHERE location like '%states%'
GROUP BY location, population
ORDER BY PopulationInfectedPercentage DESC



SELECT location,MAX(cast(total_deaths as int)) as TotalDeathCount
FROM dbo.CovidDeaths
--WHERE location like '%states%'
WHERE continent is not null
GROUP BY location
ORDER BY TotalDeathCount DESC


SELECT continent,MAX(cast(total_deaths as int)) as TotalDeathCount
FROM dbo.CovidDeaths
--WHERE location like '%states%'
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount DESC

SELECT location,MAX(cast(total_deaths as int)) as TotalDeathCount
FROM dbo.CovidDeaths
--WHERE location like '%states%'
WHERE continent is null
GROUP BY location
ORDER BY TotalDeathCount DESC


SELECT location, population,MAX(cast(total_deaths as int)) as TotalDeathCount
FROM dbo.CovidDeaths
 --WHERE location like '%Africa%'
--WHERE continent is not null
GROUP BY population, location
ORDER BY TotalDeathCount DESC



SELECT SUM(new_cases) as TotalCases, SUM(cast(new_deaths as int)) as TotalDeaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM dbo.CovidDeaths
--WHERE location like '%states%'
WHERE continent is not null
--GROUP BY date
ORDER BY 1,2


SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FROM dbo.CovidDeaths dea
JOIN dbo.CovidVaccinations Vac
 on dea.location = Vac.location
 and dea.date = vac.date
 WHERE dea.continent is not null
 ORDER BY 2,3

 SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM(cast(Vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.Location, dea.date) as RollingPeopleVaccinated
FROM dbo.CovidDeaths dea
JOIN dbo.CovidVaccinations Vac
 on dea.location = Vac.location
 and dea.date = vac.date
 WHERE dea.continent is not null
 ORDER BY 2,3

 --USE CTE

 With PopvsVac (continent, Location, date, population, new_vaccinations, RollingPeopleVaccinated)
 as
 (
  SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM(cast(Vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.Location, dea.date) as RollingPeopleVaccinated
FROM dbo.CovidDeaths dea
JOIN dbo.CovidVaccinations Vac
 on dea.location = Vac.location
 and dea.date = vac.date
 WHERE dea.continent is not null
 --ORDER BY 2,3
 )
 SELECT *, (RollingPeopleVaccinated/population)*100
 FROM PopvsVac


 --TEMP TABLE


 DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
LOcation nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)
 
 Insert into #PercentPopulationVaccinated
 SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM(cast(Vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.Location, dea.date) as RollingPeopleVaccinated
FROM dbo.CovidDeaths dea
JOIN dbo.CovidVaccinations Vac
 on dea.location = Vac.location
 and dea.date = vac.date
 --WHERE dea.continent is not null
 --ORDER BY 2,3

 SELECT *, (RollingPeopleVaccinated/Population)*100
 FROM #PercentPopulationVaccinated


 Create View PercentPopulationVaccinated as
 SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM(cast(Vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.Location, dea.date) as RollingPeopleVaccinated
FROM dbo.CovidDeaths dea
JOIN dbo.CovidVaccinations Vac
   on dea.location = Vac.location
   and dea.date = vac.date
 WHERE dea.continent is not null
 --ORDER BY 2,3

 SELECT *
 FROM PercentPopulationVaccinated
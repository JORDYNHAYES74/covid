--Select * 
--From Covid..Covidvaccinations$
--order by 3,4
--Select data that I will be using 

Select * 
From Covid..Coviddeaths$
where continent is not null
Order by 3,4

Select continent ,date, total_cases, new_cases, total_deaths, population
From Covid..Coviddeaths$
Order by 1,2

--Looking at Total Cases vs Total Deaths 
--Shows probability of dying if you contract covid

Select continent ,date, total_cases, total_deaths, (Total_deaths/total_cases)*100 as DeathPercentage
From Covid..Coviddeaths$
where location like '%states%'
Order by 1,2


--Looking at Total Cases vs Population 
--Shows what percent of population got covid 
Select continent ,date,population, total_cases, (total_cases/population)*100 as DeathPercentage
From Covid..Coviddeaths$
--where location like '%states%'
Order by 1,2


--Looking At countries with Highest infection Rate compared to population 

Select continent, Population, MAX(total_cases) as HighestInfectioncount, MAX (( total_cases/population))*100 as 
   PercentPopulationInfected 
From Covid..Coviddeaths$
--Where Location like '%states%'
where continent is not null 
Group by continent, Population 
order by  PercentPopulationInfected desc

--Showing Countries With hgihest count per population 

Select continent, MAx (cast(total_deaths as int)) as TotalDeathCount 
From Covid..Coviddeaths$
--Where Location like '%states%'
Group by continent
order by  TotalDeathCount desc

--Broken down by continents 


--Showing Continents with Highest Death Count 

Select continent, MAx (cast(total_deaths as int)) as TotalDeathCount 
From Covid..Coviddeaths$
--Where Location like '%states%'
where continent is not null 
Group by continent
order by  TotalDeathCount desc



--Global Numbers 


Select SUM (new_cases)as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM( cast(new_deaths as int))/ SUM(cast
   (new_deaths as int))/SUM (new_cases) * 100 as DeathPrecentage
From Covid..Coviddeaths$
--where location like '%states%'
Where continent is not null 
--Group by date
Order by 1,2

--Total Population vs Vaccinations 

select dea.continent , dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location,dea.date) 
as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100 
From Covid..CovidDeaths$ dea 
join Covid..Covidvaccinations$ vac
     on dea.location = vac.location
	 and dea.date = vac.date
 where dea.continent is not null 
 order by 2,3


 --Use CTE 

 with PopvsVac(Continent, Location ,Date, Population, New_vaccinations, RollingPeopleVaccinated)
 as
 (
 select dea.continent , dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location,dea.date) 
as RollingPeopleVaccinated 
--,(RollingPeopleVaccinated/population)*100
from Covid..CovidDeaths$ dea
join Covid..Covidvaccinations$ vac
     on dea.location = vac.location
	 and dea.date = vac.date
 where dea.continent is not null 
 order by 2,3
 )

 Select *, (RollingPeopleVaccinated)*100
 From PopvsVac

 --Temp Table

 Drop table if exists #PercentPopulationVaccinated

 Create table #PercentPopulationVaccinated
 (
 Continent nvarchar(255),
 Locaion nvarchar(255),
 Date datetime, 
 Population numeric,
 RollingPeopleVAccinated numeric
 )

 Insert into #PercentPopulationVaccinated
 select dea.continent , dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location,dea.date) 
as RollingPeopleVaccinated 
--,(RollingPeopleVaccinated/population)*100
from Covid..CovidDeaths$ dea
join Covid..Covidvaccinations$ vac
     on dea.location = vac.location
	 and dea.date = vac.date
 where dea.continent is not null 
 --order by 2,3

 Select *, (RollingPeopleVAccinated/Population)*100
 From #PercentPopulationVaccinated

 --Creating View to store Data for Visulization 

 Create view PercentPopulationVaccinated as 
 select dea.continent , dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location,dea.date) 
as RollingPeopleVaccinated 
--,(RollingPeopleVaccinated/population)*100
from Covid..CovidDeaths$ dea
join Covid..Covidvaccinations$ vac
     on dea.location = vac.location
	 and dea.date = vac.date
 where dea.continent is not null 
 --order by 2,3

 Select *
 from PercentPopulationVaccinated


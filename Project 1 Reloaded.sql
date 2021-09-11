select * 
from PortfolioProject..['CovidDeaths']
Where continent is not null
order by 3,4


--1 Selection of Data to be used
Select location, date, total_cases, new_cases ,total_deaths, population
from PortfolioProject..['CovidDeaths']
Where continent is not null
order by 1,2



--2 Looking at Total cases vs. Total Deaths
-- Likelihood of contracting covid in your country

Select location, date, total_cases,total_deaths, 
	case when cast(total_cases as float) <> 0 
	then cast(total_deaths as float)/cast(total_cases as float)*100 end 
	as death_rate
From PortfolioProject..['CovidDeaths']
Where location like 'South Africa' and continent is not null
order by 1,2





--4 Countries with highest infection rates compared to population


Select location, population, max(total_cases) as Highted_Infection_Count,
	case when cast(population as float) <> 0 
	then max(cast(total_cases as float))/cast(population as float)*100 end 
	as PercentPopulationInfected
From PortfolioProject..['CovidDeaths']
Where continent is not null
Group by location,population
order by PercentPopulationInfected desc

--5 Countries with hightest death count per population

Select location, max(cast(total_deaths as float)) as Total_Death_Count
From PortfolioProject..['CovidDeaths']
Where continent is not null
Group by location,population
order by Total_Death_Count desc

--6 Breaking things down by continent
-- Alternative that came on the way
Select location, max(cast(total_deaths as float)) as Total_Death_Count
From PortfolioProject..['CovidDeaths']
Where continent is null
Group by location
order by Total_Death_Count desc



--7 Continents with highest death count

Select continent, max(cast(total_deaths as float)) as Total_Death_Count
From PortfolioProject..['CovidDeaths']
Where continent is not null
Group by continent
order by Total_Death_Count desc


--8 Global Deaths
Select sum(cast(new_cases as float)) as Total_cases, sum(cast(total_deaths as float)) as Total_deaths,
		sum(cast(total_deaths as float))/sum(cast(new_cases as float)) as Death_Percentage
From PortfolioProject..['CovidDeaths']
Where continent is not null
--Group by date
order by 1,2


--9 Total Population vs Vaccinations
Select new_vaccinations
From PortfolioProject..CovidVaccinations

Select dea.continent, dea.location, dea.date, dea.population, new_vaccinations,
	sum(convert(float, vac.new_vaccinations)) 
	OVER (Partition by dea.Location Order by dea.location, dea.date) as Rolling_People_Vaccinated
From PortfolioProject..['CovidDeaths'] dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location =  vac.location
	and dea.date = vac.date
Where dea.continent is not null
Order by 2,3 


--10 Use CTE

With PopvsVac (continent, location, date, population, new_vaccinations, Rolling_People_Vaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, new_vaccinations,
	sum(convert(float, vac.new_vaccinations)) 
	OVER (Partition by dea.Location Order by dea.location, dea.date) as Rolling_People_Vaccinated
From PortfolioProject..['CovidDeaths'] dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location =  vac.location
	and dea.date = vac.date
Where dea.continent is not null
--Order by 2,3 
)
Select * , (Rolling_People_Vaccinated/population)*100 as Rolling_Vaccinated_Rate
from PopvsVac



--10 Creating View to Store data for later visualisations

Create View Rolling_Vaccinated_Rate as
Select dea.continent, dea.location, dea.date, dea.population, new_vaccinations,
	sum(convert(float, vac.new_vaccinations)) 
	OVER (Partition by dea.Location Order by dea.location, dea.date) as Rolling_People_Vaccinated
From PortfolioProject..['CovidDeaths'] dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location =  vac.location
	and dea.date = vac.date
Where dea.continent is not null
--Order by 2,3 


Create View UsedData as 
Select location, date, total_cases, new_cases ,total_deaths, population
from PortfolioProject..['CovidDeaths']
Where continent is not null
--order by 1,2


Create View LikelihoodOfContractingCovid as

Select location, date, total_cases,total_deaths, 
	case when cast(total_cases as float) <> 0 
	then cast(total_deaths as float)/cast(total_cases as float)*100 end 
	as death_rate
From PortfolioProject..['CovidDeaths']
Where location like 'South Africa' and continent is not null
--order by 1,2


--3
Create View PercentagePopulationWithCovid as 
Select location, date, Population, total_cases,  
	case when cast(population as float) <> 0 
	then cast(total_cases as float)/cast(population as float)*100 end 
	as Percent_Population_Infected
From PortfolioProject..['CovidDeaths']
Where location like 'South Africa' and continent is not null
--order by 1,2


--4
Create View highestInfectionRates as
Select location, population, max(total_cases) as Highted_Infection_Count,
	case when cast(population as float) <> 0 
	then max(cast(total_cases as float))/cast(population as float)*100 end 
	as PercentPopulationInfected
From PortfolioProject..['CovidDeaths']
Where continent is not null
Group by location,population
--order by PercentPopulationInfected desc


--5 
Create View HightestDeathCount as
Select location, max(cast(total_deaths as float)) as Total_Death_Count
From PortfolioProject..['CovidDeaths']
Where continent is not null
Group by location,population
--order by Total_Death_Count desc



--7 
Create View ContinentsWithHighestDeathCount as
Select continent, max(cast(total_deaths as float)) as Total_Death_Count
From PortfolioProject..['CovidDeaths']
Where continent is not null
Group by continent
--order by Total_Death_Count desc



--8  
Create View GlobalDeaths as
Select sum(cast(new_cases as float)) as Total_cases, sum(cast(total_deaths as float)) as Total_deaths,
		sum(cast(total_deaths as float))/sum(cast(new_cases as float)) as Death_Percentage
From PortfolioProject..['CovidDeaths']
Where continent is not null
--Group by date
--order by 1,2


--9 
Create View TotalPopulationvsVaccinations as
Select dea.continent, dea.location, dea.date, dea.population, new_vaccinations,
	sum(convert(float, vac.new_vaccinations)) 
	OVER (Partition by dea.Location Order by dea.location, dea.date) as Rolling_People_Vaccinated
From PortfolioProject..['CovidDeaths'] dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location =  vac.location
	and dea.date = vac.date
Where dea.continent is not null
--Order by 2,3 
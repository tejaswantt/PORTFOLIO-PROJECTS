select * from portfolioproject..['covid death orginal$']
select * from portfolioproject..['covid death orginal$']
select location,date,total_cases,total_deaths,population
from portfolioproject..['covid death orginal$']
order by 1,2
--looking at total cases vs total deaths
--shows likelihood of dying if you contract covid in your country
select location,date,cast(total_cases as int),cast(total_deaths as int),(total_cases/total_deaths)*100 as deathpercentage
from portfolioproject..['covid death orginal$']
where location like '%america%'
order by 1,2
--looking at total cases vs population
 select location,date,total_cases,total_deaths,population,(total_cases/population)*100 as covidpercentage
from portfolioproject..['covid death orginal$']
where location like '%america%'
order by 1,2
--looking at countries with highestt infeection rate compared to population
select location,population,MAX(total_cases) as highestinfectioncount,MAX((total_cases/population)*100) as covidpercentge
from portfolioproject..['covid death orginal$']
group by population,location
order by covidpercentge desc
--lets break things down by continent
select continent,MAX(cast(total_deaths as int)) as totaldeathcount
from portfolioproject..['covid death orginal$']
where continent is not null
group by continent
order by totaldeathcount desc

--global numbers
select  date,SUM(new_cases) as total_cases,SUM(cast(new_deaths as int)) as total_deaths,SUm(cast(new_deaths as int))+SUM(new_cases)*100 as deathpercentage
from portfolioproject..['covid death orginal$']
--where location like'%america%'
where continent is not null
group by date 
order by 1,2

--covid vaccination and covid death 
select *
from portfolioproject..['covid death orginal$'] dea
join portfolioproject..['covid vaccintion orginal$'] vac
on dea.location=vac.location
and dea.date=vac.date

--looking at total population vs vaccination
with popvsvac(continent,location,date,population,new_vaccinations,rollingpeoplevaccinated)
as
(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(convert(int,vac.new_vaccinations)) OVER (partition by dea.location order by 
dea.location,dea.date) as rollingpeoplevaccinated
from portfolioproject..['covid death orginal$'] dea
join portfolioproject..['covid vaccintion orginal$'] vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 2,3
)
select *,(rollingpeoplevaccinated/population)*100
from popvsvac



--temp table
create table #percentpopulationvaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
rollingpeoplevaccinated numeric
) 
insert into #percentpopulationvaccinated
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(convert(int,vac.new_vaccinations)) OVER (partition by dea.location order by 
dea.location,dea.date) as rollingpeoplevaccinated
from portfolioproject..['covid death orginal$'] dea
join portfolioproject..['covid vaccintion orginal$'] vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 2,3

select *,(rollingpeoplevaccinated/population)*100
from  #percentpopulationvaccinated



--create view to store data for later visualization

create view percentpopulationvaccinated as
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(convert(int,vac.new_vaccinations)) OVER (partition by dea.location order by 
dea.location,dea.date) as rollingpeoplevaccinated
from portfolioproject..['covid death orginal$'] dea
join portfolioproject..['covid vaccintion orginal$'] vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null

select *
from percentpopulationvaccinated








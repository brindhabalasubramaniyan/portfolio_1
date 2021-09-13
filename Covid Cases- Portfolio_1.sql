select * from covid_death where continent is not null order by 3,4;
-- select * from covid_vaccination order by 3,4;
-- select data that we are going to be using

-- like
-- total_cases vs total_deaths
select location,date,total_cases,total_deaths,round((total_deaths/total_cases)*100,2) AS death_percent from covid_death
where location='Afghanistan' order by 1,2;

-- total_cases vs population
select location,date,total_cases,population,round((total_cases/population)*100,3) AS case_percentage from covid_death
where location='Afghanistan' order by 1,2;

-- looking at countries with highest infection rate compared to population

select location,total_cases,population,max(total_cases) as highest_infection_count, round(max((total_cases/population)*100),3) as case_percentage from covid_death
group by location,population order by case_percentage desc;

-- showing countries with highest death count per population
select location,max(total_deaths) as max_death from covid_death
where continent is not null
group by location order by max_death desc;

-- break things by continent
select continent,max(total_deaths) as max_death from covid_death
where continent is not null
group by continent order by max_death desc;

-- joining 2 tables
select * from covid_death d join covid_vaccination v
on d.iso_code=v.iso_code;

select * from covid_death d join covid_vaccination v
on d.location=v.location
and d.date=v.date;

-- looking at total population vs vaccinations
select d.location,d.population,v.new_vaccinations,
sum(v.new_vaccinations) over (partition by d.location) as people_vaccinated from covid_death d join covid_vaccination v
on d.location=v.location
and d.date=v.date;

-- use cte
with PopvsVac (location,population,new_vaccinations,people_vaccinated)
as
(select d.location,d.population,v.new_vaccinations,
sum(v.new_vaccinations) over (partition by d.location) as people_vaccinated from covid_death d join covid_vaccination v
on d.location=v.location
and d.date=v.date)
select * from PopvsVac;

-- use temp table
Create table #PercentPeopleVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPeopleVaccinated
select d.location,d.population,v.new_vaccinations,
sum(v.new_vaccinations) over (partition by d.location) as people_vaccinated from covid_death d join covid_vaccination v
on d.location=v.location
and d.date=v.date;

-- creating view
Create view PercentPeopleVaccinated as
select d.location,d.population,v.new_vaccinations,
sum(v.new_vaccinations) over (partition by d.location) as people_vaccinated from covid_death d join covid_vaccination v
on d.location=v.location
and d.date=v.date














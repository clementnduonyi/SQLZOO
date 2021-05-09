--SQLZOO: SELECT within SELECT Tutorial


--This tutorial looks at how we can use SELECT statements 
--within SELECT statements to perform more complex queries.


--List each country name where the population is larger than that of 'Russia'.


SELECT name FROM world
  WHERE population >
     (SELECT population FROM world
      WHERE name='Russia');



--Show the countries in Europe with a per capita GDP greater than 'United Kingdom'.


SELECT name FROM world
    WHERE continent = 'Europe' 
    AND GPD/population > 
    (SELECT GPD/population FROM world
    WHERE name = 'United Kingdom')


--List the name and continent of countries in the continents containing either
-- Argentina or Australia. Order by name of the country.

SELECT name, continent
FROM world
WHERE continent IN (
        SELECT continent
        FROM world
        WHERE name IN ('Argentina', 'Australia')
      )
ORDER BY name;


--Which country has a population that is more than Canada but less
--than Poland? Show the name and the population.


SELECT name, population FROM world
     WHERE population >
     (SELECT population FROM world
     WHERE name = 'Canada') AND population <
     (SELECT population FROM world
     WHERE name = 'Poland')


--Show the name and the population of each country in Europe. Show 
--population as a percentage of the population of Germany.

--Decimal places
--You can use the function ROUND to remove the decimal places.

--Percent symbol %
--You can use the function CONCAT to add the percentage symbol.


SELECT name CONCAT(
    ROUND(population/(
        SELECT population FROM world
        where name = 'Germany') * 100, 0)'%') AS 
        percentage FROM world
        WHERE continent = 'Europe';


--Which countries have a GDP greater than every country in Europe?
--[Give the name only.] (Some countries may have NULL gdp values)

SELECT name FROM world
    WHERE GDP > ALL(SELECT GDP FROM world
    WHERE continent = 'Europe' 
    AND GDP IS NOT NULL);

--Find the largest country (by area) in each continent, 
--show the continent, the name and the area:


SELECT continent, name, area
FROM world original
WHERE area > ALL (SELECT area
                  FROM world copy
                  WHERE original.continent = copy.continent AND
                        area > 0 AND
                        original.name <> copy.name);


--List each continent and the name of the country that comes first alphabetically.

SELECT continent, name
FROM world original
WHERE name = (SELECT name
              FROM world copy
              WHERE original.continent = copy.continent
              ORDER BY name
              LIMIT 1


--Find the continents where all countries have a population <= 25000000
--Then find the names of the countries associated with these continents. Show name, continent and population.


SELECT name, continent, population
FROM world original
WHERE 25000000 > ALL(SELECT population
          FROM world copy
          WHERE original.continent = copy.continent);


--Some countries have populations more than three times 
--that of any of their neighbours (in the same continent). Give the countries and continents.


SELECT name, continent
FROM world original
WHERE population > ALL (SELECT population * 3
                    FROM world copy
                    WHERE original.continent = copy.continent
                    AND original.name <> copy.name);

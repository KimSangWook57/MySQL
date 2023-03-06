-- 1 영어를 사용하는 나라 수.
select count(countrylanguage.CountryCode) as count from countrylanguage where countrylanguage.Language = 'English';
-- 2 대한민국이 사용하는 언어.
select countrylanguage.Language from countrylanguage inner join country on country.Code = countrylanguage.CountryCode where country.Name = 'south korea'; 
-- 3 영어를 공식 언어로 사용하는 나라의 대륙과 이름.
select country.Continent, country.Name from country inner join countrylanguage on countrylanguage.CountryCode = country.Code where countrylanguage.Language = 'English' and countrylanguage.IsOfficial = 'T';
-- 4 영어를 사용하는 나라 수를 대륙별로 묶어서 정리.
select country.Continent, count(countrylanguage.CountryCode) as ContinentCount from countrylanguage inner join country on country.Code = countrylanguage.CountryCode where countrylanguage.Language = 'English' group by country.Continent;

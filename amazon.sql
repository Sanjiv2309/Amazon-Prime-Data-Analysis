

use amazon_prime;

/*divide the column gener into gener 1 and gener 2*/

ALTER TABLE titles
ADD genres_1 VARCHAR (55);


update titles
set genres_1 =(CASE WHEN CHARINDEX(',' ,genres) > 0 THEN SUBSTRING(genres,0,CHARINDEX(',',genres,0))
            ELSE genres
            END) go

/*Q3.how many movies and tv shows are present show % of total*/

CREATE VIEW movies_tv
AS
select count(type) as categories,type 
from titles
group by type;

/*Q4.what type of movies are mostly present based on genres_1*/

select * from titles; 

select COUNT(genres_1) as cnt,genres_1
from titles
where type = 'movie'
group by genres_1
order by COUNT(genres_1) DESC;


/*Q5.what type of movies are mostly present based on genres_1*/

select COUNT(genres_1) as cnt,genres_1
from titles
where type = 'show'
group by genres_1
order by COUNT(genres_1) DESC;


/*what is the average time of movies by genres*/

CREATE VIEW average_time_movie
AS
select avg(runtime) as cnt,genres_1,type
from titles
where type = 'movie'
group by genres_1,type;

select * from average_time_movie;

/*Q7.what is the average seasons of tv shows by genres_1*/

CREATE VIEW average_time_show
AS
select avg(runtime) as cnt,genres_1,type
from titles
where type = 'show'
group by genres_1,type

select * from average_time_show;


/*Q10.Each year how many movies and tv shows released*/

select * from titles;

CREATE VIEW year_movies
AS
select count(type) as categories, release_year,type
from titles
group by release_year,type;


select * from year_movies;

/*Q14.genre distribution based on IMDB votes movies*/

select * from titles;

CREATE VIEW IMDB_votes_movies
as 
select sum(imdb_votes) as votes,genres_1,type
from titles
where type = 'movie'
group by genres_1,type;

select * from IMDB_votes_movies;

/*Q15.genre distribution based on IMDB votes shows*/

CREATE VIEW IMDB_votes_shows
as 
select sum(imdb_votes) as votes,genres_1,type
from titles
where type = 'show'
group by genres_1,type;


/*Q12. HOW many kids movie and TV shows are released each year
In terms of TV Rating */

select * from titles;

/*movies*/

CREATE VIEW age_certification_MOVIES
as 
select genres_1,COUNT(genres_1) AS CNT
from titles
WHERE age_certification  IN ('TV-Y7','TV-Y7','G') and genres_1 is not null and type = 'movie'
GROUP BY genres_1;

/*tv show*/
CREATE VIEW age_certification_SHOW
as 
select genres_1,COUNT(genres_1) AS CNT
from titles
WHERE age_certification  IN ('TV-Y7','TV-Y7','G') and genres_1 is not null and type = 'show'
GROUP BY genres_1;


/*Q8. Top 10 movies and show on the base no IMDB scroce*/

/*top 10 movies*/

CREATE VIEW movies
as 
with movies (title,release_year,production_countries,genres_1,imdb_votes,movie_rank)
as(
select title,release_year,production_countries,genres_1,imdb_votes,
DENSE_RANK() over (order by imdb_votes DESC) as movie_rank
from titles
where type = 'movie'
)
select title,release_year,production_countries,genres_1,imdb_votes,movie_rank
from movies
where movie_rank< 11;

/*top 10 shows*/

CREATE VIEW SHOWS
as 
with top_10_shows(title,release_year,production_countries,genres_1,imdb_votes,show_rank)
as(
select title,release_year,production_countries,genres_1,imdb_votes,
DENSE_RANK() over (order by imdb_votes DESC) as show_rank
from titles
where type = 'show'
)
select title,release_year,production_countries,genres_1,imdb_votes,show_rank
from top_10_shows
where show_rank <11;

/*Q15. production countries */

ALTER TABLE titles
ADD countries VARCHAR (55);


update titles
set countries = (CASE WHEN CHARINDEX(',' ,production_countries) > 0 THEN SUBSTRING(production_countries,0,CHARINDEX(',',production_countries,0))
            ELSE production_countries
            END) go

select * from titles go

CREATE VIEW production_countries
AS
with production_countries(cnt,countries,top_rank)
as(
select count(countries) as cnt,countries,DENSE_RANK() over (order by count(countries) DESC) as top_rank
from titles
group by countries)
select cnt,countries,top_rank
from production_countries
where top_rank <=10;

SELECT * FROM production_countries;
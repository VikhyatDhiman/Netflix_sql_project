-- Netflix Project 
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix (
    show_id VARCHAR(6),
    type VARCHAR(10),
    title VARCHAR(150),
    director VARCHAR(210),
    casts VARCHAR(1000),
    country VARCHAR(150),
    date_added VARCHAR(50),
    release_year INT,
    rating VARCHAR(10),
    duration VARCHAR(15),
    listed_in VARCHAR(150),
    description VARCHAR(275)
);

SELECT * FROM netflix


SELECT 
   COUNT(*) as total_content 
FROM netflix;

SELECT DISTINCT type
FROM netflix;

SELECT * FROM netflix


-- 15 Business Problems

1. Count the number of Movies vs TV Shows
2. Find the most common rating for movies and TV shows
3. List all movies released in a specific year (e.g., 2020)
4. Find the top 5 countries with the most content on Netflix
5. Identify the longest movie
6. Find content added in the last 5 years
7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
8. List all TV shows with more than 5 seasons
9. Count the number of content items in each genre
10.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!
11. List all movies that are documentaries
12. Find all content without a director
13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
15.
Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.

1. Count the number of Movies vs TV Shows
SELECT type, COUNT(*) AS Count
FROM netflix 
GROUP BY type;

2. Find the most common rating for movies and TV shows
SELECT type, rating, COUNT(*) AS Count
FROM netflix
GROUP BY type, rating
ORDER BY type, Count DESC; 
	
SELECT 
  type, 
  rating, 
  COUNT(*) as count,
  RANK() OVER (PARTITION BY type ORDER BY COUNT(*) DESC) as ranking
FROM 
  netflix
GROUP BY 
  type, rating
ORDER BY 
  type, ranking 

3. List all movies released in a specific year (e.g., 2020)

SELECT title, director, casts, country, date_added, rating, duration, listed_in, description
FROM netflix
WHERE type = 'Movie' AND release_year = 2020;

4. Find the top 5 countries with the most content on Netflix

SELECT country, COUNT(*) AS ContentCount
FROM netflix
GROUP BY country
ORDER BY ContentCount DESC
LIMIT 5;

5. Identify the longest movie
SELECT title, duration
FROM netflix
WHERE type = 'Movie'
ORDER BY duration DESC
LIMIT 1;

6. Find content added in the last 5 years

SELECT title, type, date_added
FROM netflix
WHERE date_added::date >= CURRENT_DATE - INTERVAL '5 years';

7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

SELECT title, type, release_year, rating, duration, listed_in, description
FROM netflix
WHERE director = 'Rajiv Chilaka';

8. List all TV shows with more than 5 seasons

SELECT title, duration
FROM netflix
WHERE type = 'TV Show' AND (duration ~ '^(\d+) Seasons?$' AND CAST(substring(duration FROM '^(\d+)') AS INT) > 5);

9. Count the number of content items in each genre

SELECT listed_in AS genre, COUNT(*) AS ContentCount
FROM netflix
GROUP BY listed_in
ORDER BY ContentCount DESC;

10.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!

SELECT release_year, AVG(ContentCount) AS AverageContentPerYear
FROM (
    SELECT release_year, COUNT(*) AS ContentCount
    FROM netflix
    WHERE country = 'India'
    GROUP BY release_year
) AS YearlyContent
GROUP BY release_year
ORDER BY AverageContentPerYear DESC
LIMIT 5;

11. List all movies that are documentaries

SELECT title, director, casts, country, date_added, release_year, rating, duration, description
FROM netflix
WHERE type = 'Movie' AND listed_in LIKE '%Documentaries%';

12. Find all content without a director

SELECT title, type, release_year, rating, duration, listed_in, description
FROM netflix
WHERE director IS NULL OR director = '';


13. Find how many movies actor 'Salman Khan' appeared in last 10 years!

SELECT COUNT(*) AS MovieCount
FROM netflix
WHERE type = 'Movie'
  AND casts LIKE '%Salman Khan%'
  AND release_year >= EXTRACT(YEAR FROM CURRENT_DATE) - 10;

14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

SELECT actor, COUNT(*) AS MovieCount
FROM (
    SELECT unnest(string_to_array(casts, ', ')) AS actor, country
    FROM netflix
    WHERE type = 'Movie' AND country = 'India'
) AS ActorMovies
GROUP BY actor
ORDER BY MovieCount DESC
LIMIT 10;

15.
Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.

SELECT
    CASE
        WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
        ELSE 'Good'
    END AS Category,
    COUNT(*) AS ContentCount
FROM netflix
GROUP BY Category;


-- ** Movie Database project. See the file movies_erd for table\column info. **

-- 1. Give the name, release year, and worldwide gross of the lowest grossing movie.

SELECT film_title as title, 
	release_year, 
	worldwide_gross
FROM specs as s
INNER JOIN revenue as r
	ON s.movie_id = r.movie_id
WHERE worldwide_gross NOTNULL
ORDER by worldwide_gross ASC
limit 1;

	--ASNWER: Semi-Tough, 1977, 37,187,139



-- 2. What year has the highest average imdb rating?

SELECT release_year,
	ROUND(AVG(imdb_rating), 2) as avg_rating
FROM specs AS s
	FULL JOIN rating AS r
	ON s.movie_id = r.movie_id
GROUP BY release_year
ORDER BY avg_rating DESC
LIMIT 5;

	--ANSWER: 1991 at a rating of 7.45

-- 3. What is the highest grossing G-rated movie? Which company distributed it?

SELECT film_title,
	mpaa_rating,
	worldwide_gross,
	company_name
FROM specs AS s
	INNER JOIN revenue as rev
		ON s.movie_id = rev.movie_id
	INNER JOIN distributors as d
		on s.domestic_distributor_id = d.distributor_id
WHERE mpaa_rating ='G'
ORDER BY worldwide_gross DESC
LIMIT 5;

	--ANSWER: Toy Story 4, dist. Walt Disney
	
	

-- 4. Write a query that returns, for each distributor in the distributors table, the distributor name and the number of movies associated with that distributor in the movies 
-- table. Your result set should include all of the distributors, whether or not they have any movies in the movies table.

SELECT company_name as distributor,
	COUNT(film_title) as count_associated_films
FROM distributors as d
	FULL JOIN specs as s
	ON d.distributor_id = s.domestic_distributor_id
GROUP by company_name
ORDER by count_associated_films DESC;

-- 5. Write a query that returns the five distributors with the highest average movie budget.

-- 6. How many movies in the dataset are distributed by a company which is not headquartered in California? Which of these movies has the highest imdb rating?

-- 7. Which have a higher average rating, movies which are over two hours long or movies which are under two hours?
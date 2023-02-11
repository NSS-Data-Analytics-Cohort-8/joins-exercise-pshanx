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

SELECT company_name,
	ROUND(AVG(film_budget), 2) as avg_budgie
FROM distributors as d
	INNER JOIN specs as s
		ON d.distributor_id = s.domestic_distributor_id
	INNER JOIN revenue as rev
		ON s.movie_id = rev.movie_id
GROUP by company_name
ORDER by avg_budgie DESC
LIMIT 5;



-- 6. How many movies in the dataset are distributed by a company which is not headquartered in California? Which of these movies has the highest imdb rating?

SELECT film_title,
	imdb_rating,
	headquarters
FROM distributors as d
	INNER JOIN specs as s
		ON d.distributor_id = s.domestic_distributor_id
	INNER JOIN rating as r
		ON s.movie_id = r.movie_id
WHERE headquarters NOT LIKE '%CA'
ORDER by imdb_rating DESC;

	--ANSWER: two movies, the higher rated being Dirty Dancing
	--UNLESS: null headquarters counts as "Not California"
	
SELECT film_title,
	imdb_rating,
	headquarters
FROM distributors as d
	FULL JOIN specs as s
		ON d.distributor_id = s.domestic_distributor_id
	INNER JOIN rating as r
		ON s.movie_id = r.movie_id
WHERE s.domestic_distributor_id ISNULL
	OR headquarters NOT LIKE '%CA'
ORDER by imdb_rating DESC;

	--IN WHICH CASE: 13 movies, topped by Annie Hall



-- 7. Which have a higher average rating, movies which are over two hours long or movies which are under two hours?

SELECT ROUND(AVG(imdb_rating), 2) as avg_rating_over,
	(SELECT ROUND(AVG(imdb_rating), 2) FROM rating as r 
	 INNER JOIN specs as s ON r.movie_id = s.movie_id
	 WHERE length_in_min <120) 
	 	as avg_rating_under
FROM rating as r
	INNER JOIN specs as s 
		ON r.movie_id = s.movie_id
WHERE length_in_min >120;

	--ANSWER: movies over 2 hours rate higher



-- BONUS

-- 1.	Find the total worldwide gross and average imdb rating by decade. Then alter your query so it returns JUST the second highest average imdb rating and its decade. This should result in a table with just one row.

SELECT SUM(worldwide_gross) as total_ww_gross,
	round(avg(imdb_rating), 2) as avg_imdb,
	ROUND(release_year, -1) as decade
FROM specs as s
	FULL JOIN rating as r
		ON s.movie_id = r.movie_id
	FULL JOIN revenue as rev
		ON s.movie_id = rev.movie_id
GROUP BY decade
ORDER by avg_imdb DESC

SELECT round(avg(imdb_rating), 2) as avg_imdb,
	ROUND(release_year, -1) as decade
FROM specs as s
	FULL JOIN rating as r
		ON s.movie_id = r.movie_id
GROUP by decade
ORDER BY avg_imdb DESC
	EXCEPT
SELECT MAX(avg_imdb), decade
FROM specs as s
	FULL JOIN rating as r
		ON s.movie_id = r.movie_id
GROUP by decade
ORDER BY avg_imdb DESC

-- 2.	Our goal in this question is to compare the worldwide gross for movies compared to their sequels. 
	-- a.	Start by finding all movies whose titles end with a space and then the number 2.
	-- b.	For each of these movies, create a new column showing the original film’s name by removing the last two characters of the film title. For example, for the film “Cars 2”, the original title would be “Cars”. Hint: You may find the string functions listed in Table 9-10 of https://www.postgresql.org/docs/current/functions-string.html to be helpful for this. 
	-- c.	Bonus: This method will not work for movies like “Harry Potter and the Deathly Hallows: Part 2”, where the original title should be “Harry Potter and the Deathly Hallows: Part 1”. Modify your query to fix these issues. 
	-- d.	Now, build off of the query you wrote for the previous part to pull in worldwide revenue for both the original movie and its sequel. Do sequels tend to make more in revenue? Hint: You will likely need to perform a self-join on the specs table in order to get the movie_id values for both the original films and their sequels. Bonus: A common data entry problem is trailing whitespace. In this dataset, it shows up in the film_title field, where the movie “Deadpool” is recorded as “Deadpool “. One way to fix this problem is to use the TRIM function. Incorporate this into your query to ensure that you are matching as many sequels as possible.

-- 3.	Sometimes movie series can be found by looking for titles that contain a colon. For example, Transformers: Dark of the Moon is part of the Transformers series of films.
	-- a.	Write a query which, for each film will extract the portion of the film name that occurs before the colon. For example, “Transformers: Dark of the Moon” should result in “Transformers”.  If the film title does not contain a colon, it should return the full film name. For example, “Transformers” should result in “Transformers”. Your query should return two columns, the film_title and the extracted value in a column named series. Hint: You may find the split_part function useful for this task.
	-- b.	Keep only rows which actually belong to a series. Your results should not include “Shark Tale” but should include both “Transformers” and “Transformers: Dark of the Moon”. Hint: to accomplish this task, you could use a WHERE clause which checks whether the film title either contains a colon or is in the list of series values for films that do contain a colon.
	-- c.	Which film series contains the most installments?
	-- d.	Which film series has the highest average imdb rating? Which has the lowest average imdb rating?

-- 4.	How many film titles contain the word “the” either upper or lowercase? How many contain it twice? three times? four times? Hint: Look at the sting functions and operators here: https://www.postgresql.org/docs/current/functions-string.html 

-- 5.	For each distributor, find its highest rated movie. Report the company name, the film title, and the imdb rating. Hint: you may find the LATERAL keyword useful for this question. This keyword allows you to join two or more tables together and to reference columns provided by preceding FROM items in later items. See this article for examples of lateral joins in postgres: https://www.cybertec-postgresql.com/en/understanding-lateral-joins-in-postgresql/ 

-- 6.	Follow-up: Another way to answer 5 is to use DISTINCT ON so that your query returns only one row per company. You can read about DISTINCT ON on this page: https://www.postgresql.org/docs/current/sql-select.html. 

-- 7.	Which distributors had movies in the dataset that were released in consecutive years? For example, Orion Pictures released Dances with Wolves in 1990 and The Silence of the Lambs in 1991. Hint: Join the specs table to itself and think carefully about what you want to join ON. 
Total number of unique customers and distinct countries:

SELECT 
    COUNT(DISTINCT customer_id) AS total_customers,
    COUNT(DISTINCT country) AS total_countries
FROM movies.customers;

Total number of movies and distinct genres movies are listed in:

SELECT 
    COUNT(DISTINCT movie_id) AS total_movies,
    COUNT(DISTINCT genre) AS total_genres
FROM movies.movies;

Total revenue MovieNow has generated:

SELECT 
    SUM(renting_price) AS total_revenue
FROM movies.renting AS r
LEFT JOIN movies.movies AS m
ON r.movie_id = m.movie_id;

Average, minimum, and maximum renting price of movies available on MovieNow:

SELECT 
    ROUND(AVG(renting_price), 2) AS average_price,
    ROUND(MIN(renting_price), 2) AS minimum_price,
    ROUND(MAX(renting_price), 2) AS maximum_price
FROM movies.movies;

Average renting price by genre and how it compares to the overall average renting price of $2.21:

SELECT 
    genre,
    ROUND(AVG(renting_price), 2) AS average_by_genre,
    ROUND(MIN(renting_price), 2) AS minimum_by_genre,
    ROUND(MAX(renting_price), 2) AS maximum_by_genre
FROM movies.renting AS r
LEFT JOIN movies.movies AS m ON r.movie_id = m.movie_id
GROUP BY genre
ORDER BY average_by_genre DESC;

Does renting price affect how movies are rented?

SELECT 
    genre,
    ROUND(AVG(renting_price), 2) AS average_price_by_genre,
    COUNT(r.*) AS movies_rented
FROM movies.renting AS r
LEFT JOIN movies.movies AS m ON m.movie_id = r.movie_id
GROUP BY genre
ORDER BY average_price_by_genre DESC;

Does rating affect how movies are rented?

SELECT 
    ROUND(AVG(rating), 2) AS average_rating,
    MIN(rating) AS minimum_rating,
    MAX(rating) AS maximum_rating
FROM movies.renting;

Movies with a rating of 1:

SELECT 
    title AS movie_title,
    genre AS genre,
    year_of_release AS released_year
FROM movies.movies
WHERE movie_id IN (
    SELECT movie_id
    FROM movies.renting
    WHERE rating = 1
);

Movies with a perfect rating of 10:

SELECT 
    title AS movie_title,
    genre AS genre,
    year_of_release AS released_year
FROM movies.movies
WHERE movie_id IN (
    SELECT movie_id
    FROM movies.renting
    WHERE rating = 10
)
ORDER BY released_year DESC;

Identify the top 10 movies with the most rentals and their average rating:

SELECT 
    r.movie_id,
    title,
    COUNT(r.*) AS total_rent,
    ROUND(AVG(rating), 2) AS avg_rating
FROM movies.renting AS r
LEFT JOIN movies.movies AS m ON r.movie_id = m.movie_id
GROUP BY r.movie_id, title
ORDER BY total_rent DESC
LIMIT 10;

Do movies with the rating score of 10 have more rentals?

SELECT 
    r.movie_id,
    title,
    COUNT(r.*) AS total_rent,
    AVG(rating) AS avg_rating
FROM movies.renting AS r
LEFT JOIN movies.movies AS m ON r.movie_id = m.movie_id
WHERE rating = 10
GROUP BY r.movie_id, title
ORDER BY total_rent DESC;
Understanding the customers of MovieNow:

Distribution of customers by country:
SELECT 
    country,
    COUNT(*) AS total_customers
FROM movies.customers
GROUP BY country
ORDER BY COUNT(*) DESC;

Highest paying customer and their country?

SELECT 
    c.name,
    c.country,
    SUM(renting_price) AS total_amount_paid
FROM movies.renting AS r
LEFT JOIN movies.movies AS m ON r.movie_id = m.movie_id
LEFT JOIN movies.customers AS c ON r.customer_id = c.customer_id
GROUP BY c.name, c.country
ORDER BY total_amount_paid DESC
LIMIT 1;

Which country brings in the most revenue?

SELECT 
    c.country,
    SUM(m.renting_price) AS revenue_by_country
FROM movies.renting AS r
LEFT JOIN movies.movies AS m ON r.movie_id = m.movie_id
LEFT JOIN movies.customers AS c ON r.customer_id = c.customer_id
GROUP BY c.country
ORDER BY revenue_by_country DESC
LIMIT 1;

Which genre brings in the most revenue?

SELECT 
    genre,
    SUM(renting_price) AS revenue_by_genre
FROM movies.renting AS r
LEFT JOIN movies.movies AS m ON r.movie_id = m.movie_id
GROUP BY genre
ORDER BY revenue_by_genre DESC
LIMIT 1;
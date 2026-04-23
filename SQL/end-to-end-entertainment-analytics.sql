-- End-to-End Entertainment Business Analytics Project
-- Author: Fengzhe Li
-- SQL Server Portfolio Project


-- =========================================
-- Chapter 1: Basic Rental Analysis
-- =========================================

-- Analyze rating performance for Movie ID 25
USE MovieRentalAnalytics;
GO

SELECT
    movie_id,
    MIN(rating) AS min_rating,
    MAX(rating) AS max_rating,
    AVG(CAST(rating AS FLOAT)) AS avg_rating,
    COUNT(rating) AS total_ratings
FROM renting
WHERE movie_id = 25
GROUP BY movie_id;


-- Retrieve all rentals since January 2019

SELECT
    renting_id,
    customer_id,
    movie_id,
    rating,
    date_renting
FROM renting
WHERE date_renting >= '2019-01-01'
ORDER BY date_renting;


-- Calculate average rating by movie

SELECT
    movie_id,
    COUNT(rating) AS ratings_count,
    AVG(CAST(rating AS FLOAT)) AS avg_rating
FROM renting
GROUP BY movie_id
ORDER BY avg_rating DESC;



-- =========================================
-- Chapter 2: Customer Intelligence
-- =========================================

-- Identify active customers with more than 2 rentals

SELECT
    c.customer_id,
    c.name,
    c.country,
    COUNT(*) AS total_rentals,
    COUNT(r.rating) AS ratings_given,
    AVG(CAST(r.rating AS FLOAT)) AS avg_rating
FROM customers c
JOIN renting r
ON c.customer_id = r.customer_id
GROUP BY
    c.customer_id,
    c.name,
    c.country
HAVING COUNT(*) >= 2
ORDER BY total_rentals DESC;


-- Analyze rental frequency distribution

SELECT
    rental_count,
    COUNT(*) AS number_of_customers
FROM (
    SELECT
        customer_id,
        COUNT(*) AS rental_count
    FROM renting
    GROUP BY customer_id
) t
GROUP BY rental_count
ORDER BY rental_count;


-- Segment customers by rental activity

SELECT
    customer_id,
    COUNT(*) AS total_rentals,
    CASE
        WHEN COUNT(*) >= 3 THEN 'VIP Customer'
        WHEN COUNT(*) = 2 THEN 'Active Customer'
        ELSE 'Low Activity'
    END AS customer_segment
FROM renting
GROUP BY customer_id
ORDER BY total_rentals DESC;


-- Count customers by segment

SELECT
    customer_segment,
    COUNT(*) AS customers
FROM
(
    SELECT
        customer_id,
        CASE
            WHEN COUNT(*) >= 3 THEN 'VIP Customer'
            WHEN COUNT(*) = 2 THEN 'Active Customer'
            ELSE 'Low Activity'
        END AS customer_segment
    FROM renting
    GROUP BY customer_id
) t
GROUP BY customer_segment;



-- =========================================
-- Chapter 3: KPI Reporting
-- =========================================

-- Calculate total rentals

SELECT COUNT(*) AS total_rentals
FROM renting;


-- Calculate average rating

SELECT AVG(CAST(rating AS FLOAT)) AS avg_rating
FROM renting
WHERE rating IS NOT NULL;


-- Calculate repeat customer rate

SELECT 
CAST(
    100.0 * COUNT(*) /
    (SELECT COUNT(DISTINCT customer_id) FROM renting)
AS DECIMAL(5,2)) AS repeat_rate_percent
FROM
(
    SELECT customer_id
    FROM renting
    GROUP BY customer_id
    HAVING COUNT(*) >= 2
) t;


-- Count customers by country

SELECT
    country,
    COUNT(*) AS customers
FROM customers
GROUP BY country
ORDER BY customers DESC;



-- =========================================
-- Chapter 4: Ranking & Intermediate Analytics
-- =========================================

-- Rank movies by average rating

SELECT
    movie_id,
    COUNT(rating) AS ratings_count,
    AVG(CAST(rating AS FLOAT)) AS avg_rating,
    RANK() OVER(
        ORDER BY AVG(CAST(rating AS FLOAT)) DESC
    ) AS movie_rank
FROM renting
WHERE rating IS NOT NULL
GROUP BY movie_id;


-- Rank customers by rentals

SELECT
    customer_id,
    COUNT(*) AS total_rentals,
    RANK() OVER(
        ORDER BY COUNT(*) DESC
    ) AS customer_rank
FROM renting
GROUP BY customer_id;


-- Analyze monthly rental volume

WITH monthly_data AS
(
    SELECT
        FORMAT(date_renting,'yyyy-MM') AS rental_month,
        COUNT(*) AS rentals
    FROM renting
    GROUP BY FORMAT(date_renting,'yyyy-MM')
)
SELECT *,
LAG(rentals) OVER(ORDER BY rental_month) AS previous_month
FROM monthly_data;


-- Analyze missing ratings

SELECT
    COUNT(*) AS total_rentals,
    COUNT(rating) AS rated_rentals,
    COUNT(*) - COUNT(rating) AS missing_ratings
FROM renting;


-- Identify most popular movies

SELECT TOP 10
    movie_id,
    COUNT(*) AS rental_count
FROM renting
GROUP BY movie_id
ORDER BY rental_count DESC;



-- =========================================
-- Chapter 5: Multi-table Business Analytics
-- =========================================

-- Analyze USA actor demographics

SELECT
    gender,
    MIN(year_of_birth) AS oldest_birth_year,
    MAX(year_of_birth) AS youngest_birth_year,
    COUNT(*) AS total_actors
FROM actors
WHERE nationality = 'USA'
GROUP BY gender
ORDER BY total_actors DESC;


-- Combine rentals with customer and movie details

SELECT
    r.renting_id,
    c.name AS customer_name,
    c.country,
    m.title AS movie_title,
    m.genre,
    m.renting_price,
    r.rating,
    r.date_renting
FROM renting AS r
INNER JOIN customers AS c
ON r.customer_id = c.customer_id
INNER JOIN movies AS m
ON r.movie_id = m.movie_id
ORDER BY r.date_renting DESC;


-- Retrieve rentals since January 2019

SELECT
    r.renting_id,
    c.name AS customer_name,
    c.country,
    m.title,
    m.genre,
    r.rating,
    r.date_renting
FROM renting AS r
LEFT JOIN customers AS c
ON c.customer_id = r.customer_id
LEFT JOIN movies AS m
ON r.movie_id = m.movie_id
WHERE r.date_renting >= '2019-01-01'
ORDER BY r.date_renting;


-- Calculate top revenue movies

SELECT TOP 10
    m.title,
    COUNT(*) AS rental_count,
    SUM(m.renting_price) AS total_revenue
FROM renting r
LEFT JOIN movies m
ON r.movie_id = m.movie_id
GROUP BY m.title
ORDER BY total_revenue DESC;


-- Calculate revenue by country

SELECT
    c.country,
    COUNT(*) AS rentals,
    SUM(m.renting_price) AS total_revenue
FROM renting r
LEFT JOIN customers c
ON r.customer_id = c.customer_id
LEFT JOIN movies m
ON r.movie_id = m.movie_id
GROUP BY c.country
ORDER BY total_revenue DESC;


-- Analyze genre performance

SELECT
    m.genre,
    COUNT(*) AS rental_count,
    AVG(CAST(r.rating AS FLOAT)) AS avg_rating,
    SUM(m.renting_price) AS revenue
FROM renting r
LEFT JOIN movies m
ON r.movie_id = m.movie_id
GROUP BY m.genre
ORDER BY revenue DESC;


-- Identify top spending customers

SELECT TOP 10
    c.name,
    c.country,
    COUNT(*) AS rentals,
    SUM(m.renting_price) AS total_spent
FROM renting r
LEFT JOIN customers c
ON r.customer_id = c.customer_id
LEFT JOIN movies m
ON r.movie_id = m.movie_id
GROUP BY c.name, c.country
ORDER BY total_spent DESC;


-- Analyze monthly revenue trend

SELECT
    FORMAT(r.date_renting,'yyyy-MM') AS rental_month,
    COUNT(*) AS rentals,
    SUM(m.renting_price) AS revenue
FROM renting r
LEFT JOIN movies m
ON r.movie_id = m.movie_id
GROUP BY FORMAT(r.date_renting,'yyyy-MM')
ORDER BY rental_month;


-- Enrich rentals with actor participation

SELECT
    r.renting_id,
    c.name AS customer_name,
    actors.name AS actor_name,
    r.movie_id,
    r.rating,
    r.date_renting
FROM renting AS r
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
LEFT JOIN actsin AS a
ON a.movie_id = r.movie_id
LEFT JOIN actors
ON a.actor_id = actors.actor_id
ORDER BY r.date_renting DESC;


-- Rank actors by rental appearances

SELECT TOP 10
    actors.name AS actor_name,
    COUNT(*) AS rental_appearances
FROM renting r
LEFT JOIN actsin a
ON r.movie_id = a.movie_id
LEFT JOIN actors
ON a.actor_id = actors.actor_id
GROUP BY actors.name
ORDER BY rental_appearances DESC;



-- =========================================
-- Chapter 6: Advanced SQL & Window Functions
-- =========================================

-- Rank customers by lifetime value

SELECT
    c.name AS customer_name,
    c.country,
    COUNT(*) AS total_rentals,
    SUM(m.renting_price) AS lifetime_value,
    RANK() OVER(
        ORDER BY SUM(m.renting_price) DESC
    ) AS customer_rank
FROM renting r
LEFT JOIN customers c
ON r.customer_id = c.customer_id
LEFT JOIN movies m
ON r.movie_id = m.movie_id
GROUP BY c.name, c.country;


-- Calculate cumulative monthly revenue

WITH monthly_revenue AS
(
    SELECT
        DATEFROMPARTS(
            YEAR(r.date_renting),
            MONTH(r.date_renting),
            1
        ) AS rental_month,
        SUM(m.renting_price) AS revenue
    FROM renting r
    LEFT JOIN movies m
    ON r.movie_id = m.movie_id
    GROUP BY
        YEAR(r.date_renting),
        MONTH(r.date_renting)
)
SELECT
    rental_month,
    revenue,
    SUM(revenue) OVER(
        ORDER BY rental_month
        ROWS UNBOUNDED PRECEDING
    ) AS cumulative_revenue
FROM monthly_revenue;


-- Calculate monthly growth percentage

WITH monthly_data AS
(
    SELECT
        DATEFROMPARTS(
            YEAR(date_renting),
            MONTH(date_renting),
            1
        ) AS rental_month,
        COUNT(*) AS rentals
    FROM renting
    GROUP BY
        YEAR(date_renting),
        MONTH(date_renting)
)
SELECT
    rental_month,
    rentals,
    LAG(rentals) OVER(
        ORDER BY rental_month
    ) AS previous_month,
    ROUND(
        100.0 *
        (rentals - LAG(rentals) OVER(ORDER BY rental_month))
        / NULLIF(LAG(rentals) OVER(ORDER BY rental_month),0),
        2
    ) AS growth_percent
FROM monthly_data;


-- Rank movies by average rating

SELECT
    m.title,
    COUNT(r.rating) AS ratings_count,
    AVG(CAST(r.rating AS FLOAT)) AS avg_rating,
    DENSE_RANK() OVER(
        ORDER BY AVG(CAST(r.rating AS FLOAT)) DESC
    ) AS movie_rank
FROM renting r
LEFT JOIN movies m
ON r.movie_id = m.movie_id
WHERE r.rating IS NOT NULL
GROUP BY m.title;


-- Classify customers by retention status

SELECT
    customer_id,
    COUNT(*) AS rentals,
    CASE
        WHEN COUNT(*) >= 2 THEN 'Returning Customer'
        ELSE 'One-time Customer'
    END AS retention_status
FROM renting
GROUP BY customer_id;

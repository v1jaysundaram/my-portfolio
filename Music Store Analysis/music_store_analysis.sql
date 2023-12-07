# ---------------------- Music Store Analysis ---------------------------------

### For a detailed explanation of the code, check out the Medium article - https://medium.com/@vijay_sundaram/exploratory-data-analysis-of-music-data-in-sql-uncovering-insights-from-a-music-store-dataset-fcc57e9e25de

## Sales and Revenue Analysis

# What is the total sales for each genre?

SELECT g.name AS genre, SUM(il.unit_price * il.quantity) AS total_sales
FROM invoice_line il
JOIN track t ON il.track_id = t.track_id
JOIN genre g ON t.genre_id = g.genre_id
GROUP BY genre
ORDER BY total_sales DESC;


# Which genres have sales greater than the average?

SELECT g.name AS genre, SUM(il.unit_price * il.quantity) AS total_sales
FROM invoice_line il
JOIN track t ON il.track_id = t.track_id
JOIN genre g ON t.genre_id = g.genre_id
GROUP BY genre
HAVING total_sales > (SELECT AVG(total_sales) FROM (
                        SELECT g.name AS genre, SUM(il.unit_price * il.quantity) AS total_sales
                        FROM invoice_line il
                        JOIN track t ON il.track_id = t.track_id
                        JOIN genre g ON t.genre_id = g.genre_id
                        GROUP BY genre
                    ) AS subquery)
ORDER BY total_sales DESC;


# Can you identify the top-selling tracks?

SELECT t.name AS track, COUNT(t.name) AS number_purchased
FROM invoice_line il
JOIN track t ON il.track_id = t.track_id
JOIN genre g ON t.genre_id = g.genre_id
GROUP BY track
ORDER BY number_purchased DESC
LIMIT 10;


# How does the monthly sales data vary?

SELECT month(invoice_date) as month, SUM(total) AS sales
FROM invoice
GROUP BY month;

#--------------------------------------------------------------------------------------------------

## Customer Behaviour Analysis

# How many customers are there in each country?

SELECT c.country, COUNT(DISTINCT(c.customer_id)) AS customer_count
FROM customer c
JOIN invoice i ON c.customer_id = i.customer_id
GROUP BY country
ORDER BY customer_count DESC;


# Which countries have more than 10% of the total customers?

SELECT country, COUNT(customer_id) as customer_count
FROM customer 
GROUP BY country
HAVING customer_count > (SELECT 0.10 * SUM(customer_count)
					FROM (SELECT country, COUNT(customer_id) as customer_count
					FROM customer 
					GROUP BY country 
					ORDER BY customer_count DESC)
					AS subquery)
ORDER BY customer_count DESC; 


# What is the average spending per customer?

SELECT c.customer_id, CONCAT(c.first_name, " ", c.last_name) as customer_name, ROUND(AVG(i.total), 2) as avg_spend
FROM customer c
JOIN invoice i ON c.customer_id = i.customer_id
GROUP BY c.customer_id, customer_name;


# How does the average spending per customer vary between different countries?

SELECT c.country, ROUND(AVG(i.total), 2) as avg_spend
FROM customer c
JOIN invoice i ON c.customer_id = i.customer_id
GROUP BY c.country
ORDER BY avg_spend DESC;


# What are top 3 values of total invoice?

SELECT DISTINCT invoice_id, customer_id, billing_country, total
FROM invoice
ORDER BY total DESC
LIMIT 3;


# Who is the best customer?

SELECT c.customer_id, c.first_name, c.last_name, SUM(i.total) AS "total_invoice_customer" 
FROM customer c
JOIN invoice i
ON i.customer_id = c.customer_id
GROUP BY c.customer_id
ORDER BY total_invoice_customer DESC
LIMIT 1;

#--------------------------------------------------------------------------------------------------


## Genre and Artist Popularity

# Which are the top 5 selling genres based on total sales?

SELECT g.name AS genre, SUM(il.unit_price * il.quantity) AS total_sales
FROM invoice_line il
JOIN track t ON il.track_id = t.track_id
JOIN genre g ON t.genre_id = g.genre_id
GROUP BY genre
ORDER BY total_sales DESC
LIMIT 5;


# Which artist has the highest total sales?

SELECT a.name AS artist_name, SUM(il.unit_price * il.quantity) AS total_sales
FROM invoice_line il
JOIN track t ON il.track_id = t.track_id
JOIN album2 al ON t.album_id = al.album_id
JOIN artist a ON al.artist_id = a.artist_id
GROUP BY artist_name
ORDER BY total_sales DESC
LIMIT 1;


# Which genre has the most number of tracks?

SELECT g.name as genre, COUNT(t.track_id) AS track_count
FROM genre g
JOIN track t ON g.genre_id = t.genre_id
GROUP BY genre
ORDER BY track_count DESC;


# Who are the top artists in the "Rock" genre based on total sales?

SELECT a.name as artist_name, SUM(il.unit_price * il.quantity) AS total_sales
FROM invoice_line il
JOIN track t ON il.track_id = t.track_id
JOIN genre g ON t.genre_id = g.genre_id
JOIN album2 al ON t.album_id = al.album_id
JOIN artist a ON al.artist_id = a.artist_id
WHERE g.name = "Rock"
GROUP BY artist_name
ORDER BY total_sales DESC
LIMIT 5;

#--------------------------------------------------------------------------------------------------

## Global Trends

# Which country has the highest total sales?

SELECT billing_country AS country, SUM(total) AS sales
FROM invoice
GROUP BY country
ORDER BY sales DESC
LIMIT 1;


# What is the most popular genre in a specific country? - USA

SELECT g.name AS genre, SUM(il.unit_price * il.quantity) AS total_sales
FROM invoice i 
JOIN invoice_line il ON i.invoice_id = il.invoice_id
JOIN track t ON il.track_id = t.track_id
JOIN genre g ON t.genre_id = g.genre_id
WHERE i.billing_country = "USA" 
GROUP BY genre
ORDER BY total_sales DESC
LIMIT 1;


#  How does the sales performance of rock music compare between the USA and Canada?

SELECT i.billing_country AS country, SUM(il.unit_price * il.quantity) AS total_sales
FROM invoice i 
JOIN invoice_line il ON i.invoice_id = il.invoice_id
JOIN track t ON il.track_id = t.track_id
JOIN genre g ON t.genre_id = g.genre_id
WHERE g.name = "Rock"
GROUP BY country
HAVING country = "Canada" OR country = "USA"
ORDER BY total_sales DESC;


# Which are the top three cities with the highest number of customers?

SELECT city, COUNT(city) AS customer_count
FROM customer
GROUP BY city
ORDER BY customer_count DESC
LIMIT 10;


# Which countries have the most invoices?

SELECT billing_country, COUNT(*) AS invoice_count
FROM invoice
GROUP BY billing_country
ORDER BY invoice_count DESC;


# What is the most popular music genre in each country?

SELECT country, MAX(genre) as "popular_genre"
FROM (
    SELECT i.billing_country as "country", g.name as "genre", SUM(i.total) as "total_amount"
    FROM invoice i 
    JOIN invoice_line il ON i.invoice_id = il.invoice_id
    JOIN track t ON il.track_id = t.track_id
    JOIN genre g ON t.genre_id = g.genre_id
    GROUP BY country, g.name
) as subquery
GROUP BY country
ORDER BY country;

#--------------------------------------------------------------------------------------------------

## Playlists Analysis

# Which playlists have the most tracks?

SELECT p.name as playlist_name, COUNT(pt.track_id) AS track_count
FROM playlist p
JOIN playlist_track pt ON p.playlist_id = pt.playlist_id
GROUP BY playlist_name
ORDER BY track_count DESC
LIMIT 3; 


#  What are the top playlists created by users?

SELECT p.name, SUM(il.unit_price * il.quantity) AS total_sales
FROM invoice_line il
JOIN track t ON il.track_id = t.track_id
JOIN playlist_track pt ON t.track_id = pt.track_id
JOIN playlist p ON pt.playlist_id = p.playlist_id
GROUP BY p.name
ORDER BY total_sales DESC; 


#  Can you create a playlist consisting of the top 10 tracks from the "Rock" genre?

SELECT t.name AS track, COUNT(t.name) AS number_purchased
FROM invoice_line il
JOIN track t ON il.track_id = t.track_id
JOIN genre g ON t.genre_id = g.genre_id
WHERE g.name = "Rock"
GROUP BY track
ORDER BY number_purchased DESC
LIMIT 10;


# Which track names have a song length longer than the average song length?

SELECT name, milliseconds
FROM track
WHERE milliseconds > (SELECT AVG(milliseconds) FROM track)
ORDER BY milliseconds DESC
LIMIT 10;


#--------------------------------------------------------------------------------------------------

## Employee Analysis

# What is the sales data for each employee?

SELECT e.employee_id, CONCAT(e.first_name, " ", e.last_name) as employee_name, e.title, SUM(i.total) as sales
FROM employee e
JOIN customer c ON e.employee_id = c.support_rep_id
JOIN invoice i ON c.customer_id = i.customer_id
GROUP BY e.employee_id, employee_name, e.title
ORDER BY sales DESC;


# How are reporting relationships structured within the employee hierarchy?

SELECT e.employee_id, CONCAT(e.first_name, " ", e.last_name) as employee_name, e.reports_to, CONCAT(m.first_name, " ", m.last_name) as manager_name
FROM employee e
JOIN employee m ON e.reports_to = m.employee_id;


# Which employees report to the same manager?

SELECT CONCAT(m.first_name, " ", m.last_name) as manager_name, GROUP_CONCAT(CONCAT(e.first_name, " ", e.last_name))  as employee_names
FROM employee e
JOIN employee m ON e.reports_to = m.employee_id
GROUP BY manager_name
HAVING COUNT(e.employee_id) > 1;


# Who is the senior most employee based on job title?

SELECT employee_id, CONCAT(first_name, " ", last_name) as senior_most_employee, levels, title
FROM employee
WHERE reports_to IS NULL;



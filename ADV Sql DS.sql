SELECT version(); /*to select sql version*/

-- Retrieve data from select
USE sakila;
SELECT * FROM actor;
SELECT COUNT(*) FROM actor;
SELECT (last_name) FROM actor;
SELECT * FROM actor WHERE first_name='NICK';
SELECT * FROM actor WHERE first_name!='NICK';
SELECT COUNT(*) FROM actor WHERE first_name!='NICK';
SELECT * FROM actor WHERE actor_id < 10;
SELECT * FROM actor WHERE actor_id <11 AND first_name = 'JOE';
SELECT * FROM actor WHERE actor_id BETWEEN 1 AND 10;
SELECT * FROM actor WHERE first_name='JANE';
SELECT * FROM actor WHERE first_name LIKE 'JA%NE';

-- Filter results with WHERE clause, 'LIKE', 'ORDER BY' 
SELECT * FROM address WHERE district = 'BUENOS AIRES' 
AND (address LIKE '%el%' OR address LIKE '%al%');

SELECT * FROM actor ORDER BY first_name DESC;
SELECT * FROM actor ORDER BY first_name ASC;

SELECT first_name, Length(first_name) FROM actor;

SELECT concat(first_name, ' ' , last_name), length(first_name) + length(last_name) 
FROM actor ORDER BY first_name DESC;

SELECT concat(first_name, ' ' , last_name) AS full_name, 
length(first_name) + length(last_name) AS len_name 
FROM actor ORDER BY first_name DESC;

SELECT lower(first_name) FROM actor;

-- string functions
SELECT substring(first_name,1,2) FROM actor;
SELECT substring(first_name,2,1) FROM actor;
SELECT substring(first_name,1,1) FROM actor;
SELECT substring(first_name,-4) FROM actor;
SELECT concat(substring(first_name,1,1),substring(last_name,1,1)) AS Cosub FROM actor;
SELECT substr(name,1) FROM category;
SELECT substr(name,2) FROM category LIMIT 10;

SELECT * FROM film_text;
SELECT description AS original, TRIM(LEADING 'A' FROM description) AS modified FROM film_text;

SELECT trim(description) AS trimmed FROM film;
SELECT trim(LEADING 'A' FROM description) AS trimmed FROM film; /*Removing A's from start*/

SELECT concat(first_name, ' ',last_name) AS Coca FROM customer;
SELECT length(address) AS original,length(REPLACE(address,' ','')) AS new,
length(address)+1-length(REPLACE(address,' ','')) AS numwords FROM address;

-- date functions
SELECT * FROM address;

SELECT * FROM address WHERE year(last_update) = 2014; 
SELECT * FROM address WHERE TIMESTAMP(last_update) = '2014-09-25 22:30:27';
SELECT * FROM address WHERE DATE(last_update) = '2014-09-25';

SELECT * , date_format (last_update, '%d,%m,%y') AS new_date FROM address;
SELECT date_format(curdate(), '%d,%m,%y') AS T_day;
SELECT curtime();
SELECT curtime()+0;

-- GROUP BY and grouped results
SELECT district FROM address GROUP BY district;
SELECT district, COUNT(*) AS dist_counts FROM address GROUP BY district;

SELECT district, group_concat(postal_code) AS PC, COUNT(*) AS dist_counts 
FROM address GROUP BY district HAVING dist_counts >5 ORDER BY dist_counts DESC;

SELECT district, group_concat(postal_code) AS PC, COUNT(*) AS dist_counts 
FROM address WHERE district LIKE '%S%' GROUP BY district HAVING dist_counts >5 
ORDER BY dist_counts DESC;

SELECT * FROM film;
SELECT avg(rental_duration) FROM film;

SELECT rating, SUM(rental_duration) FROM film GROUP BY rating;

-- DEDuplicate with select distinct
SELECT DISTINCT district FROM address;

SELECT DISTINCT customer_id, inventory_id FROM rental;

SELECT CONCAT(customer_id, '_', inventory_id) AS conc, COUNT(*) AS ct
FROM rental
GROUP BY conc
ORDER BY ct DESC;  

-- Merge rows with group by
SELECT district, group_concat(phone ORDER BY phone ASC SEPARATOR ';') AS GC
FROM address GROUP BY district;

-- Merge data across tables using JOIN(JOIN is same as innerjoin)
SELECT * FROM customer JOIN address
on customer.address_id = address.address_id;

SELECT * FROM customer AS c JOIN address AS a
on c.address_id = a.address_id;

-- Combine rows vertically using JOIN
SELECT 'actor' AS tbl, DATE(last_update) FROM actor
UNION ALL
SELECT 'address' AS tbl, DATE(last_update) FROM address; 

-- FOR unique values
SELECT 'actor' AS tbl, DATE(last_update) FROM actor
UNION
SELECT 'address' AS tbl, DATE(last_update) FROM address; 

-- Merge data across tables with IN 
SELECT * FROM rental WHERE customer_id=1 IN(
SELECT customer_id FROM customer WHERE first_name='MARY');

-- Save your queries using VIEW
SELECT * FROM actor_info;
SHOW CREATE VIEW actor_info;

-- Wildcards '%'
SELECT * FROM film WHERE description LIKE '%drama%'; 
SELECT * FROM actor WHERE first_name LIKE 'JOHN%';
SELECT * FROM actor WHERE first_name LIKE 'JO_N%'; /*Can only be used for strings like char,varchar etc*/
SELECT * FROM address WHERE postal_code LIKE '3___7%';/*Postal code under varchar returns numeric values*/

-- number functions
SELECT AVG(amount) FROM payment;
SELECT stddev(amount) FROM payment;

SELECT concat(YEAR(payment_date),'_',MONTH(payment_date)) AS yr_mth,
AVG(amount), COUNT(*) FROM payment
GROUP BY yr_mth; /*month wise average*/

SELECT amount, round(amount,0) from payment;
SELECT amount, ceil(amount) from payment;
SELECT amount, truncate(amount,0) from payment;
SELECT amount, truncate(amount,1) from payment;
SELECT amount, INTERVAL(amount,1.2,3,4,5) from payment;

-- Editing using UPDATE
-- Update fields in table
UPDATE actor
SET first_name = 'PENNY'
WHERE actor_id = 1;

UPDATE film
SET release_year = 1970 
WHERE film_id NOT IN(SELECT film_id FROM inventory);

-- INSERT query
/*Basic Insert query
INSERT INTO table
values (value1,value2);
or
INSERT INTO table (column1, column2)
values(value1,value2);
 */ 
 
 SELECT max(country_id) FROM country;
 -- DELETE query
 -- Basic query
 /* DELETE wil remove rows from table leaving the table intact 
 DELETE FROM table WHERE filter = TRUE
 DELETE FROM * ; will remove everything form table
 Always use a where clause*/
 
 -- Drop
 /* DROP removes the the entire table from a database
 DROP TABLE table_name;*/
 
 -- ALTER
 /* ALTER TABLE table_name ADD column_name column_type; 
 ALTER TABLE table_name DROP column_name;*/
 








USE sakila;

-- Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.

SELECT COUNT(*)
FROM film AS f
JOIN inventory AS i ON f.film_id = i.film_id
WHERE title = 'Hunchback Impossible';

-- List all films whose length is longer than the average length of all the films in the Sakila database.

SELECT title, length
FROM film
WHERE length > (SELECT AVG(length) FROM film);

-- Use a subquery to display all actors who appear in the film "Alone Trip".

SELECT a.first_name, a.last_name
FROM actor AS a
JOIN film_actor AS fa ON a.actor_id = fa.actor_id
JOIN film AS f ON fa.film_id = f.film_id
WHERE f.title = 'Alone Trip';

-- Sales have been lagging among young families, and you want to target family movies for a promotion. Identify all movies categorized as family films.

SELECT f.title
FROM film AS f
JOIN film_category AS fc ON f.film_id = fc.film_id
JOIN category AS c ON fc.category_id = c.category_id
WHERE c.name = 'Family';

-- Retrieve the name and email of customers from Canada using both subqueries and joins. To use joins, you will need to identify the relevant tables and their primary and foreign keys.

SELECT c1.first_name, c1.last_name, c1.email
FROM customer AS c1
JOIN address AS a ON c1.address_id = a.address_id
JOIN city AS c2 ON a.city_id = c2.city_id
JOIN country AS c3 ON c2.country_id = c3.country_id
WHERE c3.country = 'Canada';

/*Determine which films were starred by the most prolific actor in the Sakila database.
A prolific actor is defined as the actor who has acted in the most number of films.
First, you will need to find the most prolific actor and then use that actor_id to find the different films that he or she starred in.*/

SELECT f.title AS films_starred_by_most_prolific_actor
FROM film AS f
JOIN film_actor AS fa ON f.film_id = fa.film_id
WHERE fa.actor_id =
	(SELECT actor_id FROM
		(SELECT fa.actor_id, COUNT(f.film_id) AS number_of_movies
		FROM film_actor AS fa
		JOIN film AS f ON fa.film_id = f.film_id
		GROUP BY fa.actor_id
		ORDER BY number_of_movies DESC
		LIMIT 1) AS sub1);

/*Find the films rented by the most profitable customer in the Sakila database.
You can use the customer and payment tables to find the most profitable customer, i.e., the customer who has made the largest sum of payments.*/

SELECT f.title AS films_rented_by_top_customer
FROM film AS f
JOIN inventory AS i ON f.film_id = i.film_id
JOIN rental AS r ON i.inventory_id = r.inventory_id
WHERE r.customer_id = 
	(SELECT customer_id FROM	
        (SELECT customer_id, SUM(amount) as total_spent
		FROM payment
		GROUP BY customer_id
		ORDER BY total_spent DESC
		LIMIT 1) AS sub1);

-- Retrieve the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client. You can use subqueries to accomplish this.

SELECT customer_id, SUM(amount) AS total_amount_spent
FROM payment
GROUP BY customer_id
HAVING total_amount_spent >
	(SELECT AVG(total)
	FROM
		(SELECT customer_id, SUM(amount) AS total
		FROM payment
		GROUP BY customer_id) AS sub1)
ORDER BY total_amount_spent DESC;
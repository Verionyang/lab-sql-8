USE sakila;
-- 1. Write a query to display for each store its store ID, city, and country.
SELECT s.store_id, c.city, co.country FROM store as s
JOIN address as a
ON s.address_id = a.address_id
JOIN city as c
ON a.city_id = c.city_id
JOIN country as co
ON c.country_id = co.country_id;
-- 2. Write a query to display how much business, in dollars, each store brought in.
SELECT FORMAT(sum(p.amount), 'C') as 'Total Revenue' from payment as p
JOIN staff as s
ON s.staff_id = p.staff_id
JOIN store as st
ON s.store_id = s.store_id
GROUP BY s.store_id;
-- 3. Which film categories are longest?
SELECT c.name, MAX(f.length) as film_length
FROM film as f
LEFT JOIN film_category as fc
ON f.film_id = fc.film_id
JOIN category as c
ON c.category_id = fc.category_id
GROUP BY fc.category_id;
-- 4. Display the most frequently rented movies in descending order.
SELECT f.title, COUNT(r.rental_id) as 'Rental Frequencies' FROM rental as r
JOIN inventory as i
ON i.inventory_id = r.inventory_id
JOIN film as f 
ON f.film_id = i.film_id
GROUP BY f.film_id
ORDER BY COUNT(r.rental_id) DESC;
-- 5. List the top five genres in gross revenue in descending order.
SELECT c.name, sum(p.amount) as 'Total Revenue' FROM category as c
JOIN film_category as fc
ON c.category_id = fc.category_id
JOIN inventory as i
ON i.film_id = fc.film_id
JOIN rental as r 
ON i.inventory_id = r.inventory_id
JOIN payment as p 
ON p.rental_id = r.rental_id
GROUP BY c.name
ORDER BY sum(p.amount) DESC
LIMIT 5;
-- 6. Is "Academy Dinosaur" available for rent from Store 1? Yes, there are 12 copies avaiable. 
SELECT * FROM rental;
SELECT f.title, count(i.inventory_id) AS 'Number of available copies' FROM film as f 
JOIN inventory as i
ON i.film_id = f.film_id
JOIN rental as r
ON i.inventory_id = r.inventory_id
WHERE f.title = 'Academy Dinosaur' AND i.store_id = 1
GROUP BY f.title;
-- 7. Get all pairs of actors that worked together.
SELECT * FROM film_actor;
SELECT f.title, a1.actor_id, a2.actor_id FROM film as f
JOIN film_actor as fa1
ON f.film_id = fa1.film_id
JOIN actor as a1 
ON a1.actor_id = fa1.actor_id
JOIN film_actor as fa2
ON f.film_id=fa2.film_id
JOIN actor as a2
ON fa2.actor_id = a2.actor_id
WHERE a1.actor_id != a2.actor_id;
-- BONUS: 
-- 8. Get all pairs of customers that have rented the same film more than 3 times.
SELECT f.title, r1.customer_id,r2.customer_id FROM film as f
JOIN inventory as i1
ON i1.film_id = f.film_id
JOIN rental as r1 
ON r1.inventory_id = i1.inventory_id 
JOIN inventory as i2
ON f.film_id = i2.film_id 
JOIN rental as r2
ON r2.inventory_id = i2.inventory_id;

SELECT o1.customer_id AS CustomerID1,
       o2.customer_id AS CustomerID2,
       COUNT(*) as 'Times of renting the same films'
FROM( (SELECT c.customer_id, f.film_id
        FROM customer AS c
        JOIN rental AS r ON r.customer_id = c.customer_id
        JOIN inventory AS i ON i.inventory_id = r.inventory_id
        JOIN film AS f ON i.film_id = f.film_id
        ) AS o1
        JOIN (SELECT c.customer_id, f.film_id
                FROM customer AS c
                JOIN rental AS r ON r.customer_id = c.customer_id
                JOIN inventory AS i ON i.inventory_id = r.inventory_id
                JOIN film AS f ON i.film_id = f.film_id
    ) AS o2 ON o2.film_id = o1.film_id AND o2.customer_id < o1.customer_id )
GROUP BY o1.customer_id, o2.customer_id
HAVING count(*) >3
ORDER BY COUNT(*) DESC;
-- 9. For each film, list actor that has acted in more films.
SELECT f.title, count(fa.actor_id) as 'Number of Actors' FROM film as f
JOIN film_actor as fa
ON f.film_id = fa.film_id
JOIN actor as a
ON a.actor_id = fa.actor_id
GROUP BY f.title
ORDER BY f.title;
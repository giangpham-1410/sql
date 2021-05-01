-- We would like to know: number of copies of each film at each store and total copies.

SELECT
	-- film_id,
    film.title,
    COUNT(CASE WHEN store_id = 1 THEN inventory_id ELSE NULL END) AS number_copies_store_1,
    COUNT(CASE WHEN store_id = 2 THEN inventory_id ELSE NULL END) AS number_copies_store_2,
    COUNT(inventory_id) AS total_copies
FROM inventory
	LEFT JOIN film
		ON inventory.film_id = film.film_id
GROUP BY
	film.title
ORDER BY
	film.title;

/*
1. My partner and I want to come by each of the stores in person and meet the managers. 
Please send over the managers’ names at each store, with the full address of each property (street address, district, city, and country please)
*/

SELECT
	staff.first_name,
    staff.last_name,
    address.address,
    address.district,
    city.city,
    country.country

FROM store
	LEFT JOIN staff ON store.manager_staff_id = staff.staff_id
	LEFT JOIN address ON store.address_id = address.address_id
    LEFT JOIN city ON address.city_id = city.city_id
    LEFT JOIN country ON city.country_id = country.country_id;


/*
2. My partner and I want to come by each of the stores in person and meet the managers. 
Please send over the managers’ names at each store, with the full address of each property (street address, district, city, and country please)
*/

SELECT
	inventory.store_id,
    inventory.inventory_id,
    film.title,
    film.description,
    film.rating,
    film.replacement_cost
FROM inventory
	LEFT JOIN film ON inventory.film_id = film.film_id;


/*
3. From the same list of films you just pulled, please roll that data up and provide a summary level overview of your inventory.
We would like to know how many inventory items you have with each rating at each store.
*/

SELECT
	inventory.store_id,
    film.rating,
    COUNT(inventory_id) AS inventory_items
FROM inventory
	LEFT JOIN film ON inventory.film_id = film.film_id
GROUP BY
	inventory.store_id,
    film.rating;


/*
4. We would like to see the number of films, as well as the average replacement cost, and total replacement
cost, sliced by store and film category
*/

SELECT
	inventory.store_id,
	category.name AS category_name,
	COUNT(film.film_id) AS number_of_films,
    AVG(film.replacement_cost) AS avg_replacement_cost,
    SUM(film.replacement_cost) AS total_replacement_cost

FROM film
	LEFT JOIN film_category ON film.film_id = film_category.film_id
	LEFT JOIN category ON film_category.category_id = category.category_id
	LEFT JOIN inventory ON film.film_id = inventory.film_id

GROUP BY
	inventory.store_id,
	category.name
ORDER BY
	total_replacement_cost DESC;


/*
5. Please provide a list of all customer names, which store they go to, whether or not they are currently active, and their full
addresses – street address, city, and country
*/

SELECT
	customer.first_name,
    customer.last_name,
    customer.store_id,
    address.address,
    address.district,
    city.city,
    country.country,
    customer.active
FROM customer
	LEFT JOIN address ON customer.address_id = address.address_id
	LEFT JOIN city ON address.city_id = city.city_id
	LEFT JOIN country ON city.country_id = country.country_id;


/*
6. Please pull together a list of customer names, their total lifetime rentals, and the
sum of all payments you have collected from them. It would be great to see this ordered on total lifetime value,
with the most valuable customers at the top of the list.
*/

SELECT
	customer.first_name,
    customer.last_name,
    COUNT(payment.rental_id) AS total_rentals,
    SUM(payment.amount) AS total_payment
FROM customer
	LEFT JOIN payment ON customer.customer_id = payment.customer_id
GROUP BY
	customer.customer_id
ORDER BY
	total_payment DESC;

/*
7. Could you please provide a list of advisor and investor names in one table? Could you please note
whether they are an investor or an advisor, and for the investors, it would be good to include which company they work with.
*/

SELECT
	'investor' AS type,
    first_name,
    last_name,
    company_name AS company
FROM investor

UNION

SELECT
	'advisor' AS type,
    first_name,
    last_name,
    NULL
FROM advisor;


/*
8. Could you please provide a list of advisor and investor names in one table? Could you please note whether they are an
investor or an advisor, and for the investors, it would be good to include which company they work with.
*/

SELECT
    CASE
		WHEN awards = 'Emmy, Oscar, Tony ' THEN 'three-awards'
        WHEN awards IN ('Emmy, Oscar', 'Emmy, Tony', 'Oscar, Tony') THEN 'two-awards'
        ELSE 'one-award'
    END AS number_of_award,
    AVG(CASE WHEN actor_id IS NULL THEN 0 ELSE 1 END)*100 AS pct_of_one_award
FROM actor_award
GROUP BY
	number_of_award;


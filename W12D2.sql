/*Esercizio 1 Effettuate un'esplorazione preliminare del database. Di cosa si tratta? Quante e quali tabelle contiene?
Fate in modo di avere un'idea abbastanza chiara riguardo a con cosa state lavorando.*/
SHOW TABLES FROM sakila;
SELECT * FROM actor;
SELECT * FROM address;
SELECT * FROM category;
SELECT * FROM city;
SELECT * FROM country;
SELECT * FROM customer;
SELECT * FROM film;
SELECT * FROM film_actor;
SELECT * FROM film_category;
SELECT * FROM film_text;
SELECT * FROM inventory;
SELECT * FROM language;
SELECT * FROM payment;
SELECT * FROM rental;
SELECT * FROM staff;
SELECT * FROM store;

/*Esercizio 2 Scoprite quanti clienti si sono registrati nel 2006*/
SELECT
	count(*) Clienti2006
FROM
	customer
WHERE
	customer.create_date LIKE '%2006%'
;

SELECT
 count(customer_id) Clienti2006
 FROM
 customer
 WHERE
 YEAR(customer.create_date) = 2006;

/*Esercizio 3 Trovate il numero totale di noleggi effettuati il giorno 1/1/2006*/
SELECT
	*
FROM
	rental
WHERE
	rental.rental_date = '2006-01-01%'
;

SELECT
	COUNT(*) NoleggiCapodanno2006
FROM
	rental
WHERE
	rental.rental_date = '2006-01-01%'
;

SELECT
	COUNT(*) NoleggiCapodanno2006
FROM
	rental
WHERE
	DATE(rental.rental_date) = '2006-01-01'
;

/*Esercizio 4 Elencate tutti i film noleggiati nell’ultima settimana e
tutte le informazioni legate al cliente che li ha noleggiati.*/

SELECT film.title AS TitoloFilm, customer.*
FROM film LEFT JOIN inventory ON film.film_id = inventory.film_id LEFT JOIN rental ON inventory.inventory_id = rental.inventory_id 
LEFT JOIN customer ON rental.customer_id = customer.customer_id
WHERE DATEDIFF('2006-02-14', DATE(rental.rental_date)) < 7
;

SELECT 
customer.*, rental.rental_date, film.title
FROM
customer
LEFT JOIN
payment ON customer.customer_id = payment.payment_id
LEFT JOIN
rental ON payment.rental_id = rental.rental_id
LEFT JOIN
inventory ON rental.inventory_id = inventory.inventory_id
LEFT JOIN
film ON inventory.film_id = film.film_id
WHERE
WEEK(rental.rental_date) = (SELECT DISTINCT
WEEK(rental.rental_date) AS numero_settimana
FROM
rental
ORDER BY 1 DESC
LIMIT 1)
/*AND YEAR(rental.rental_date) = (SELECT DISTINCT
YEAR(rental.rental_date) AS numero_anno
FROM
rental
ORDER BY 1 DESC
LIMIT 1)*/
;

/*Esercizio 5 Calcolate la durata media del noleggio per ogni categoria di film.*/

SELECT 
    cat.name CategoriaFilm,
    CAST(AVG(DATEDIFF(r.return_date, r.rental_date))
        AS DECIMAL (10 , 2 )) DurataMediaNoleggio
FROM
    category cat
        LEFT JOIN
    film_category fcat ON cat.category_id = fcat.category_id
        LEFT JOIN
    film f ON fcat.film_id = f.film_id
        LEFT JOIN
    inventory inv ON f.film_id = inv.film_id
        LEFT JOIN
    rental r ON inv.inventory_id = r.inventory_id
GROUP BY cat.name;
-- Esercizio 6 Trovate la durata del noleggio più lunga.

SELECT 
    f.title Film,
    CONCAT(c.first_name, ' ', c.last_name) Nome_Cognome,
    CAST(DATEDIFF(r.return_date, r.rental_date) AS DECIMAL (10,0)) DurataNoleggio
FROM
    film f
        LEFT JOIN
    inventory inv ON f.film_id = inv.film_id
        LEFT JOIN
    rental r ON inv.inventory_id = r.inventory_id
        LEFT JOIN
    customer c ON r.customer_id = c.customer_id
WHERE
    DATEDIFF(r.return_date, r.rental_date) = (SELECT MAX(DATEDIFF(r.return_date, r.rental_date))
													FROM rental r)
;
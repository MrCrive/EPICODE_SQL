/*Esercizio 1 Identificate tutti i clienti che non hanno effettuato nessun noleggio a gennaio 2006.*/
SELECT DISTINCT
	CONCAT(customer.first_name," ",customer.last_name) Cliente
FROM
	rental
		JOIN
	customer
		ON
	rental.customer_id = customer.customer_id
WHERE YEAR(rental_date) <> 2006
;
	
 SELECT DISTINCT
	customer.customer_id Cliente
FROM
	customer
WHERE customer.customer_id NOT IN (SELECT DISTINCT
	customer_id
FROM
	rental
	where rental_date between '2006-02-01' and '2006-02-28')
;
	
/*Esercizio 2 Elencate tutti i film che sono stati noleggiati più di 10 volte nel penultimo quarto del 2005*/

SELECT 
    film.title Film,
    COUNT(rental.customer_id) QuantNoleggi
FROM
    film
        LEFT JOIN
    inventory ON film.film_id = inventory.film_id
        LEFT JOIN
    rental ON inventory.inventory_id = rental.inventory_id
WHERE quarter(rental.rental_date) = 3 AND YEAR(rental.rental_date) = 2005
GROUP BY 1
HAVING QuantNoleggi > 10
;

/*Esercizio 3 Trovate il numero totale di noleggi effettuati il giorno 1/1/2006.*/

SELECT
	COUNT(rental.rental_date) TotNoleggi
FROM
	rental
WHERE
	DATE(rental.rental_date) = '2006-02-14'
;

/*Esercizio 4 Calcolate la somma degli incassi generati nei weekend (sabato e domenica).*/

SELECT
	SUM(payment.amount) IncassiWeekEnd
FROM
	payment
JOIN
	rental
ON
	payment.rental_id = rental.rental_id
WHERE
	DAYNAME(payment_date) IN ('Saturday','Sunday')
;

SELECT SUM(AMOUNT) AS TOT_AMOUNT
FROM RENTAL R
LEFT JOIN PAYMENT P ON R.RENTAL_ID=P.RENTAL_ID
WHERE dayofweek(PAYMENT_DATE)=1 OR dayofweek(PAYMENT_DATE)=7;

SELECT SUM(AMOUNT) AS TOT_AMOUNT
FROM PAYMENT P
WHERE dayofweek(PAYMENT_DATE)=1 OR dayofweek(PAYMENT_DATE)=7;

/*Esercizio 5 Individuate il cliente che ha speso di più in noleggi.*/

SELECT
	customer.customer_id,
    CONCAT(customer.first_name," ",customer.last_name) Cliente,
    SUM(payment.amount) TotSpeseViaggi
FROM
	customer
		JOIN
	payment
		ON
	customer.customer_id = payment.customer_id
GROUP BY 1
ORDER BY 3 DESC
LIMIT 1;

/*Esercizio 6 Elencate i 5 film con la maggior durata media di noleggio.*/

SELECT
	film.title TitoloFilm,
    AVG(DATEDIFF(rental.return_date,rental.rental_date)) DurataMediaNoleggio
FROM
	rental
		JOIN
	inventory ON rental.inventory_id = inventory.inventory_id
		JOIN
	film ON inventory.film_id = film.film_id
GROUP BY
	1
ORDER BY 2 DESC
LIMIT 5;

SELECT TITLE, RENTAL_DURATION
FROM FILM
ORDER BY 2 DESC
LIMIT 5;

/*Esercizio 7 Calcolate il tempo medio tra due noleggi consecutivi da parte di un cliente.*/

SELECT
	CONCAT(customer.first_name,' ', customer.last_name) Nome_Cognome,
    AVG(DATEDIFF(rental2.rental_date, rental.rental_date)) MediaTempoTraNoleggi
FROM
	customer
JOIN
	rental
ON
	customer.customer_id = rental.customer_id
JOIN
	sakila.rental rental2
ON
	rental.customer_id = rental2.customer_id
AND
	rental2.rental_date = (SELECT
								MIN(nr.rental_date)
							FROM
								sakila.rental nr
							WHERE
								nr.customer_id = rental.customer_id
							AND
								nr.rental_date > rental.rental_date)
GROUP BY
	customer.customer_id,
    CONCAT(customer.first_name,' ', customer.last_name)
ORDER BY
	MediaTempoTraNoleggi DESC
;
    
/*Esercizio 8 Individuate il numero di noleggi per ogni mese del 2005.*/

SELECT DISTINCT
	MONTHNAME(rental.rental_date) Mese, COUNT(rental.rental_date) NoleggiMensili
FROM
	rental
WHERE
	YEAR(rental_date) = 2005
GROUP BY
	1
;

/*Esercizio 9 Trovate i film che sono stati noleggiati almeno due volte lo stesso giorno.*/

SELECT
	f.title Film,
    COUNT(DISTINCT DATE(r.rental_id)) NumNoleggi
FROM
	rental r
		LEFT JOIN
	inventory i ON r.inventory_id = i.inventory_id
		LEFT JOIN
	film f ON i.film_id = f.film_id
GROUP BY f.title
HAVING COUNT(DISTINCT DATE(r.rental_id)) >= 2
ORDER BY COUNT(DISTINCT DATE(r.rental_id));

/*Esercizio 10 Calcolate il tempo medio di noleggio.*/

SELECT
	CAST(AVG(DATEDIFF(r.return_date,r.rental_date))AS DECIMAL(10,0)) MediaNoleggio
FROM
	rental r;
    
SELECT
	AVG(DATEDIFF(r.return_date,r.rental_date)) MediaNoleggio
FROM
	rental r;

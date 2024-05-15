/*Esercizio 1 Cominciate facendo un’analisi esplorativa del database, ad esempio:
Fate un elenco di tutte le tabelle.
Visualizzate le prime 10 righe della tabella Album. Trovate il numero totale di canzoni della tabella Tracks.
Trovate i diversi generi presenti nella tabella Genre.
Effettuate tutte le query esplorative che vi servono per prendere confidenza con i dati.*/

SHOW TABLES FROM chinook;

SELECT *
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA LIKE 'chinook'
;

SELECT
	*
FROM
	album
WHERE
	AlbumId <= 10;

SELECT
	*
FROM
	album
LIMIT
	10;

SELECT
	genre.Name Genere
FROM
	genre
ORDER BY
	1
;
/*Esercizio 2 Recuperate il nome di tutte le tracce e del genere associato.*/
SELECT
	track.Name Traccia,
    genre.Name Genere
FROM
	genre
JOIN
	track
ON
	genre.GenreId = track.GenreId
/*WHERE
	genre.Name LIKE (SELECT genre.Name FROM genre WHERE genre.Name IN ('Rock'))*/
;

/*Esercizio 3 Recuperate il nome di tutti gli artisti che hanno almeno un album nel database.
Esistono artisti senza album nel database?*/

SELECT
	artist.Name,
    album.Title
FROM
	artist
JOIN
	album
ON
	artist.ArtistId = album.ArtistId
;

SELECT
	artist.Name,
    album.Title
FROM
	artist
LEFT JOIN
	album
ON
	artist.ArtistId = album.ArtistId
WHERE
	album.Title IS null;

/*Esercizio 4 Esercizio Join Recuperate il nome di tutte le tracce, del genere associato e della tipologia di media.
Esiste un modo per recuperare il nome della tipologia di media?*/

SELECT
	track.Name Traccia,
    genre.Name Genere,
    mediatype.Name TipologiaMedia
FROM
	genre
LEFT JOIN
	track
ON
	genre.GenreId = track.GenreId
LEFT JOIN
	mediatype
ON
	track.MediaTypeId = mediatype.MediaTypeId
;

/*Esercizio 5 Elencate i nomi di tutti gli artisti e dei loro album.*/
SELECT
	artist.Name,
    album.Title
FROM
	artist
LEFT JOIN
	album
ON
	artist.ArtistId = album.ArtistId
;
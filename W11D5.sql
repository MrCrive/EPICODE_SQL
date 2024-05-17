/* Esercizio 1 Elencate il numero di tracce per ogni genere in ordine discendente,
escludendo quei generi che hanno meno di 10 tracce.*/
SELECT
	genre.Name Genere, COUNT(track.Name) NumeroTracce
FROM
	genre
JOIN
	track
ON
	genre.GenreId = track.GenreId
GROUP BY
	genre.Name
HAVING
	COUNT(track.Name) >=10
ORDER BY
	1 DESC
;

SELECT
	genre.Name Genere, COUNT(DISTINCT track.Name) NumeroTracce
FROM
	genre
LEFT JOIN
	track
ON
	genre.GenreId = track.GenreId
GROUP BY
	genre.Name
HAVING
	COUNT(track.Name) >=10
ORDER BY
	2 DESC
;

/*Esercizio 2 Trovate le tre canzoni più costose.*/
SELECT
	track.Name, track.UnitPrice CostoUnitario
FROM
	track
ORDER BY
	2 DESC
LIMIT
	3
;

/*Esercizio 3 Elencate gli artisti che hanno canzoni più lunghe di 6 minuti.*/
SELECT DISTINCT
	artist.Name Artista -- , track.Milliseconds Durata_millisecondi
FROM
	artist
JOIN
	album
ON
	artist.ArtistId = album.ArtistId
JOIN
	track
ON
	album.AlbumId = track.AlbumId
WHERE
	track.Milliseconds >360000
;

SELECT DISTINCT
AR.NAME
FROM TRACK T
JOIN ALBUM AL ON T.ALBUMID=AL.ALBUMID
JOIN ARTIST AR ON AR.ARTISTID=AL.ARTISTID
WHERE T.MILLISECONDS > 360000;

-- Esercizio 4 Individuate la durata media delle tracce per ogni genere.

SELECT 
    genre.Name Genere,
    AVG(track.Milliseconds) / 60000 MediaTracciaMin
FROM
    genre
        LEFT JOIN
    track ON genre.GenreId = track.GenreId
GROUP BY 1
ORDER BY 1;

SELECT 
G.NAME,
M.NAME,
CAST(AVG(MILLISECONDS) / 1000 AS DECIMAL(7,3)) AS AVG_DURATION_SEC,
CAST(AVG(MILLISECONDS) / 60000 AS DECIMAL(5,3)) AS AVG_DURATION_MIN
FROM
TRACK T
LEFT JOIN
GENRE G ON T.GENREID = G.GENREID
LEFT JOIN
MEDIATYPE M ON T.MEDIATYPEID = M.MEDIATYPEID
GROUP BY G.NAME, M.NAME
ORDER BY AVG_DURATION_SEC DESC;

/*Esercizio 5 Elencate tutte le canzoni con la parola “Love” nel titolo,
ordinandole alfabeticamente prima per genere e poi per nome.*/
SELECT
	t.Name Canzone
FROM
	track t
WHERE
	t.Name LIKE ('%love%')
AND
	t.Name NOT LIKE('%llove%')
;

-- Esercizio 6 Trovare il costo medio per ogni tipologia di media
SELECT
	mediatype.Name TipoMedia, AVG(track.UnitPrice) CostoMedio
FROM
	mediatype
		LEFT JOIN
	track
		ON
	mediatype.MediaTypeId = track.MediaTypeId
GROUP BY
	1
ORDER BY
	1
;

-- Esercizio 7 Individuate il genere con più tracce.
SELECT DISTINCT
	genre.Name Genere,
    track.GenreId Traccia
FROM
	genre
		LEFT JOIN
	track
		ON
	genre.GenreId = track.GenreId
ORDER BY
	2 DESC
LIMIT
	1
;

SELECT G.NAME AS GENRE_NAME
FROM TRACK T
LEFT JOIN GENRE G ON T.GENREID=G.GENREID
GROUP BY G.NAME
HAVING COUNT(DISTINCT T.NAME)=(SELECT MAX(NUM_TRACK)
FROM(SELECT G.NAME AS GENRE_NAME, COUNT(DISTINCT T.NAME) AS NUM_TRACK
FROM TRACK T
LEFT JOIN GENRE G ON T.GENREID=G.GENREID
GROUP BY G.NAME) A );

/*Esercizio 8 Esercizio Query Avanzate
Trovate gli artisti che hanno lo stesso numero di album dei Rolling Stones.*/
SELECT DISTINCT
	artist.Name Artista, COUNT(album.ArtistId) NumAlbum
FROM
	artist
		LEFT JOIN
	album
		ON
	artist.ArtistId = album.ArtistId
GROUP BY
	1
HAVING
	COUNT(album.ArtistId) = (SELECT NumTracce FROM(SELECT 
    artist.Name, COUNT(album.ArtistId) NumTracce
FROM
    artist
        LEFT JOIN
    album ON artist.ArtistId = album.ArtistId
WHERE
    artist.Name LIKE 'The Rolling Stones'
GROUP BY 1)A)
;

-- Esercizio 9 Trovate l’artista con l’album più costoso.
SELECT DISTINCT
	artist.Name Artista, album.Title Album , SUM(track.UnitPrice) Prezzo
FROM
	artist
		LEFT JOIN
	album
		ON
	artist.ArtistId = album.ArtistId
		LEFT JOIN
	track
		ON
	album.AlbumId = track.AlbumId
GROUP BY
	1, 2
ORDER BY
	3 DESC
LIMIT
	1
;

SELECT AR.NAME ARTIST, AL.TITLE ALBUM
FROM TRACK T
LEFT JOIN ALBUM AL ON T.ALBUMID=AL.ALBUMID
LEFT JOIN ARTIST AR ON AL.ARTISTID=AR.ARTISTID
GROUP BY AR.NAME, AL.TITLE
HAVING SUM(T.UNITPRICE)=( SELECT MAX(ALBUM_PRICE)
FROM(
SELECT AR.NAME ARTIST, AL.TITLE ALBUM, SUM(T.UNITPRICE) AS ALBUM_PRICE
FROM TRACK T
LEFT JOIN ALBUM AL ON T.ALBUMID=AL.ALBUMID
LEFT JOIN ARTIST AR ON AL.ARTISTID=AR.ARTISTID
GROUP BY AR.NAME, AL.TITLE)A)
;
/*1 Scrivi una query per verificare che il campo ProductKey nella tabella DimProduct sia una chiave primaria.
Quali considerazioni/ragionamenti è necessario che tu faccia?
input: GROUP BY dimproduct.ProductKey
output:dimproduct.ProductKey
table:dimproduct*/
SELECT
	dimproduct.ProductKey, COUNT(dimproduct.ProductKey) Conteggio
FROM
	dimproduct
GROUP BY
	dimproduct.ProductKey;

SELECT 
    COUNT(dimproduct.ProductKey) AS NumeroRighe,
    COUNT(DISTINCT dimproduct.ProductKey) AS NumeroRigheSenzaRipetizioni
FROM
    dimproduct;
    
/*2 Scrivi una query per verificare che la combinazione dei campi SalesOrderNumber e SalesOrderLineNumber sia una PK.*/
SELECT
	SalesOrderNumber , SalesOrderLineNumber, COUNT(resel.SalesOrderNumber AND resel.SalesOrderLineNumber) COUNT_1_IF_PK
FROM
	factresellersales resel
GROUP BY
	SalesOrderNumber , SalesOrderLineNumber;

SELECT DATE(OrderDate) AS Data_Transazione, COUNT(*) AS Numero_Transazioni
FROM factresellersales
WHERE OrderDate >= '2020-01-01'
GROUP BY DATE(OrderDate);
    
/*3 Conta il numero transazioni (SalesOrderLineNumber) realizzate ogni giorno a partire dal 1 Gennaio 2020.*/
SELECT 
    resel.OrderDate, COUNT(resel.OrderDate) OrdiniGiornalieri
FROM
    factresellersales resel
GROUP BY
	resel.OrderDate
HAVING
	resel.OrderDate >= '2020-01-01';
/*4 Calcola il fatturato totale (FactResellerSales.SalesAmount),
la quantità totale venduta (FactResellerSales.OrderQuantity)
e il prezzo medio di vendita (FactResellerSales.UnitPrice) per prodotto (DimProduct)
a partire dal 1 Gennaio 2020.
Il result set deve esporre pertanto il nome del prodotto,
il fatturato totale,
la quantità totale venduta
e il prezzo medio di vendita.
I campi in output devono essere parlanti!
input: groupby factresellersales.SalesAmount, UnitPrice
output: dimproduct.EnglishProductName, SUM(factresellersales.SalesAmount) FatturatoTot, AVG(UnitPrice) PrezzoMedio
table: dimproduct, factresellersales
*/
SELECT
	prod.EnglishProductName,
    SUM(resel.SalesAmount) FatturatoTot,
    SUM(resel.OrderQuantity) QuantitaOrdine,
    AVG(resel.UnitPrice) PrezzoMedio
FROM
	factresellersales resel
LEFT JOIN
	dimproduct prod
ON
	prod.ProductKey = resel.ProductKey
WHERE
	resel.OrderDate >= '2020-01-01'
GROUP BY
	prod.EnglishProductName
ORDER BY
	1;

SELECT EnglishProductName AS PRODOTTO, 
SUM(SalesAmount) AS FATTURATO, 
SUM(OrderQuantity) AS QUANT, 
SUM(SalesAmount)/SUM(OrderQuantity) PREZZO_MEDIO_TOT_2 
FROM ADV.factresellersales A
LEFT JOIN dimproduct B ON A.ProductKey=B.ProductKey
WHERE ORDERDATE >= '2020-01-01'
-- AND EnglishProductName='AWC Logo Cap'
GROUP BY 1
ORDER BY 1;

/*HAVING  ci vanno le condizioni sulle metriche*/

/*5 Calcola il fatturato totale (FactResellerSales.SalesAmount)
e la quantità totale venduta (FactResellerSales.OrderQuantity)
per Categoria prodotto (DimProductCategory).
Il result set deve esporre pertanto il nome della categoria prodotto,
il fatturato totale
e la quantità totale venduta.
I campi in output devono essere parlanti!*/

SELECT
	cat.EnglishProductCategoryName NomeProdotto,
    SUM(resel.SalesAmount) FatturatoTot,
    SUM(resel.OrderQuantity) QuantitaOrdine
FROM
	factresellersales resel
/* LEFT*/ JOIN
	dimproduct prod
ON
	resel.ProductKey = prod.ProductKey
/*LEFT*/ JOIN
	dimproductsubcategory subcat
ON
	prod.ProductSubcategoryKey = subcat.ProductSubcategoryKey
JOIN
	dimproductcategory cat
ON
	subcat.ProductCategoryKey = cat.ProductCategoryKey
GROUP BY
	cat.EnglishProductCategoryName
ORDER BY
	1;

/*6 Calcola il fatturato totale per area città (DimGeography.City) realizzato a partire dal 1 Gennaio 2020.
Il result set deve esporre l’elenco delle città con fatturato realizzato superiore a 60K.*/

SELECT
	geo.City Citta,
    SUM(reselsales.SalesAmount) FatturatoTot
FROM
	factresellersales reselsales
/*LEFT*/ JOIN
	dimreseller reseller
ON
	reselsales.ResellerKey = reseller.ResellerKey
/*LEFT*/ JOIN
	dimgeography geo
ON
	reseller.GeographyKey = geo.GeographyKey
GROUP BY
	geo.City
HAVING
	SUM(reselsales.SalesAmount) > 60000
ORDER BY
	1;
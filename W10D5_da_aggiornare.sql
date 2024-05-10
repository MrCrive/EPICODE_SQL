/* Esponi l’anagrafica dei prodotti indicando per ciascun prodotto anche la sua sottocategoria
(DimProduct, DimProductSubcategory).*/

SELECT *
FROM
    dimproduct A
JOIN
    dimproductsubcategory B ON A.ProductSubcategoryKey = B.ProductSubcategoryKey;
SELECT
	dimproduct.EnglishProductName AS AnagraficaProdotti,
    dimproductsubcategory.ProductSubcategoryKey AS ChiaveSottocategoria
FROM
	dimproduct
JOIN
	dimproductsubcategory
ON
	dimproduct.ProductSubcategoryKey = dimproductsubcategory.ProductSubcategoryKey;
/* Esponi l’anagrafica dei prodotti indicando per ciascun prodotto la sua sottocategoria e la sua categoria
(DimProduct, DimProductSubcategory, DimProductCategory). */
SELECT 
    dimproduct.EnglishProductName AS AnagraficaProdotti,
	dimproductcategory.ProductCategoryKey AS ChiaveCategoria,
    dimproductsubcategory.ProductSubcategoryKey AS ChiaveSottocategoria
FROM
    dimproduct
        JOIN
    dimproductsubcategory ON dimproduct.ProductSubcategoryKey = dimproductsubcategory.ProductSubcategoryKey
		JOIN
	dimproductcategory ON dimproductsubcategory.ProductCategoryKey = dimproductcategory.ProductCategoryKey;
/* Esponi l’elenco dei soli prodotti venduti (DimProduct, FactResellerSales). */
SELECT DISTINCT
    dimproduct.EnglishProductName,
    factresellersales.ProductKey
FROM
	dimproduct
JOIN
	factresellersales
ON
	dimproduct.ProductKey = factresellersales.ProductKey;
/* Esponi l’elenco dei prodotti non venduti
(considera i soli prodotti finiti cioè quelli per i quali il campo FinishedGoodsFlag è uguale a 1). */
SELECT *
FROM
	dimproduct
WHERE
	dimproduct.ProductKey NOT IN (SELECT 
ON
	dimproduct.ProductKey = factresellersales.ProductKey
WHERE
	FinishedGoodsFlag = 1 AND factresellersales.ProductKey is NULL;
/* Esponi l’elenco delle transazioni di vendita (FactResellerSales)
indicando anche il nome del prodotto venduto (DimProduct) */
SELECT
    factresellersales.SalesOrderNumber,
    dimproduct.EnglishProductName,
    dimproduct.ProductKey
FROM
	dimproduct
    JOIN
	factresellersales
ON
	dimproduct.ProductKey = factresellersales.ProductKey;
/*Esponi l’elenco delle transazioni di vendita
indicando la categoria di appartenenza di ciascun prodotto venduto.*/
/*Esplora la tabella DimReseller.*/
SELECT *
FROM dimreseller;
/*Esponi in output l’elenco dei reseller
indicando, per ciascun reseller, anche la sua area geografica.*/
/*Esponi l’elenco delle transazioni di vendita.
Il result set deve esporre i campi:
SalesOrderNumber, SalesOrderLineNumber, OrderDate, UnitPrice, Quantity, TotalProductCost.
Il result set deve anche indicare
il nome del prodotto,
il nome della categoria del prodotto,
il nome del reseller e
l’area geografica.*/
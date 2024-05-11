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
	dimproduct.ProductKey NOT IN (
    SELECT DISTINCT
		dimproduct.ProductKey
	FROM
		dimproduct
	JOIN
		factresellersales
	ON
		dimproduct.ProductKey = factresellersales.ProductKey)
AND
	FinishedGoodsFlag = 1;
/* Esponi l’elenco delle transazioni di vendita (FactResellerSales)
indicando anche il nome del prodotto venduto (DimProduct) */
SELECT
	dimproduct.EnglishProductName,
    factresellersales.*
FROM
	dimproduct
JOIN
	factresellersales
ON
	dimproduct.ProductKey = factresellersales.ProductKey;
/*Esponi l’elenco delle transazioni di vendita
indicando la categoria di appartenenza di ciascun prodotto venduto.*/
SELECT
	prod.*,
    cat.EnglishProductCategoryName CategoriaProdotto
FROM
	dimproduct prod
JOIN
	dimproductsubcategory subcat
ON
	prod.ProductSubcategoryKey = subcat.ProductSubcategoryKey
JOIN
	dimproductcategory cat
ON
	subcat.ProductCategoryKey = cat.ProductCategoryKey;
/*Esplora la tabella DimReseller.*/
SELECT *
FROM dimreseller;
/*Esponi in output l’elenco dei reseller
indicando, per ciascun reseller, anche la sua area geografica.*/
SELECT 
	reseller.*,
	geo.EnglishCountryRegionName country
FROM 
	dimreseller reseller
JOIN
	dimgeography geo
ON
	reseller.GeographyKey = geo.GeographyKey;
/*Esponi l’elenco delle transazioni di vendita.
Il result set deve esporre i campi:
SalesOrderNumber, SalesOrderLineNumber, OrderDate, UnitPrice, Quantity, TotalProductCost.
Il result set deve anche indicare
il nome del prodotto,
il nome della categoria del prodotto,
il nome del reseller e
l’area geografica.*/
SELECT
	reseller.SalesOrderNumber,
    reseller.SalesOrderLineNumber,
    reseller.OrderDate,
    reseller.UnitPrice,
    reseller.OrderQuantity,
    reseller.TotalProductCost,
    prod.EnglishProductName,
    cat.EnglishProductCategoryName,
    res.ResellerName,
    geo.City,
    geo.EnglishCountryRegionName
FROM
	dimproductcategory cat
LEFT JOIN
	dimproductsubcategory subcat
ON
	cat.ProductCategoryKey = subcat.ProductCategoryKey
LEFT JOIN
	dimproduct prod
ON
	subcat.ProductSubcategoryKey = prod.ProductSubcategoryKey
LEFT JOIN
	factresellersales reseller
ON
	prod.ProductKey = reseller.ProductKey
LEFT JOIN
	dimreseller res
ON
	reseller.ResellerKey = res.ResellerKey
LEFT JOIN
	dimgeography geo
ON
	res.GeographyKey = geo.GeographyKey;
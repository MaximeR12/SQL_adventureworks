/* Q1 */
SELECT *
FROM HumanResources.Employee
ORDER BY JobTitle ASC;

/* Q2 */
SELECT p.*  
FROM person.person AS p  
ORDER BY LastName;

/* Q3 */
SELECT FirstName, LastName, businessentityid AS Employee_id
FROM person.person
ORDER BY LastName;

/* Q4 */
SELECT productid, productnumber, name as prodname
FROM production.product
WHERE production.product.productLine = 'T' AND Product.SellStartDate IS NOT NULL
ORDER BY prodname ASC;

/* Q5 */
SELECT salesorderid, customerid, orderdate, subtotal, (taxamt*100)/subtotal AS percentagetax
FROM sales.salesorderheader
ORDER BY subtotal desc;

/* Q6 */
SELECT DISTINCT jobtitle
FROM HumanResources.Employee
ORDER BY jobtitle;

/* Q7 */
SELECT CustomerID, sum(freight) AS sum_freigt
FROM Sales.SalesOrderHeader
GROUP BY CustomerID
ORDER BY CustomerID;

/* Q8 */
SELECT CustomerID, SalesPersonID, sum(SubTotal) as sum_subtotal, avg(SubTotal) as avg_subtotal
FROM Sales.SalesOrderHeader
GROUP BY CustomerID, SalesPersonID
ORDER BY CustomerID DESC;

/* Q9 */
SELECT ProductID, sum(Quantity) AS sum_qtty
FROM Production.ProductInventory
WHERE Shelf = 'A' or Shelf = 'C' or Shelf = 'H'
GROUP BY ProductID
HAVING sum(Quantity) > 500
ORDER BY ProductID;

/* Q10 */
SELECT sum(Quantity) as sum_qtty
FROM production.ProductInventory
GROUP BY (locationID*10);

/* Q11 */
SELECT p.BusinessEntityID, FirstName, LastName, PhoneNumber AS Person_Phone  
FROM Person.Person AS p  
JOIN Person.PersonPhone AS ph 
ON p.BusinessEntityID  = ph.BusinessEntityID  
WHERE LastName LIKE 'L%'  
ORDER BY LastName, FirstName;

/* Q12 */
SELECT salespersonid, customerid, sum(subtotal) as sum_subtotal
FROM sales.SalesOrderHeader
GROUP BY ROLLUP(salespersonid, customerid);

/* Q13 */
SELECT locationid, shelf, sum(quantity) as TotalQuantity
FROM production.ProductInventory
GROUP BY ROLLUP(locationid,shelf);

/* Q14 */
SELECT locationid, shelf, sum(quantity) as TotalQuantity
FROM production.ProductInventory
GROUP BY GROUPING SETS( ROLLUP(locationid, shelf), CUBE(locationid,shelf));

/* Q15 */
SELECT locationid, sum(quantity) as total_quantity
FROM production.ProductInventory
GROUP BY CUBE(locationid);

/* Q16 */
SELECT a.City, COUNT(b.AddressID) AS nbemployees
FROM Person.BusinessEntityAddress as b
	INNER JOIN Person.Address as a
		ON b.AddressID = a.AddressID
GROUP BY a.City
ORDER BY a.city;

/* Q17 */
SELECT YEAR(s.orderdate) AS 'DateYear',
	sum(s.totaldue) AS sumdue
FROM Sales.SalesOrderHeader as s
GROUP BY YEAR(s.orderdate)
ORDER BY YEAR(s.orderdate);

/* Q18 */
SELECT YEAR(s.orderdate) AS 'DateYear',
	sum(s.totaldue) AS sumdue
FROM Sales.SalesOrderHeader as s
WHERE YEAR(s.orderdate) <= 2016
GROUP BY YEAR(s.orderdate)
ORDER BY YEAR(s.orderdate);

/* Q19 */
SELECT c.ContactTypeID, c.name
FROM Person.ContactType as c
WHERE c.name LIKE '%manager%'
ORDER BY ContactTypeID desc;

/* Q20 */
SELECT p.BusinessEntityID, p.FirstName, p.LastName
FROM Person.BusinessEntityContact as b
	INNER JOIN Person.ContactType as c
		ON c.ContactTypeID = b.ContactTypeID
	INNER JOIN Person.Person as p
		ON p.BusinessEntityID = b.PersonID
WHERE c.Name = 'Purchasing Manager'
ORDER BY LastName, FirstName;

/* Q21 */
SELECT ROW_NUMBER() OVER (PARTITION BY PostalCode ORDER BY SalesYTD DESC) AS "Row Number",
pp.LastName, sp.SalesYTD, pa.PostalCode
FROM Sales.SalesPerson AS sp
    INNER JOIN Person.Person AS pp
        ON sp.BusinessEntityID = pp.BusinessEntityID
    INNER JOIN Person.Address AS pa
        ON pa.AddressID = pp.BusinessEntityID
WHERE TerritoryID IS NOT NULL
    AND SalesYTD <> 0
ORDER BY PostalCode;

/* Q22 */
SELECT pc.ContactTypeID, pc.Name AS CTypeName, COUNT(*) AS NOcontacts
FROM Person.BusinessEntityContact AS pbe
	INNER JOIN Person.ContactType AS pc
		ON pc.ContactTypeID = pbe.ContactTypeID
GROUP BY pc.ContactTypeID, pc.Name
HAVING COUNT(*) >= 100
ORDER BY COUNT(*) DESC;

/* Q23 */
SELECT (e.Rate*40) AS "weekly_salary",
	CAST(e.RateChangeDate AS DATE) AS "fromdate",
	(p.LastName + ',' + p.FirstName + ' ' + p.MiddleName) AS "Full_name"
FROM HumanResources.EmployeePayHistory as e
	INNER JOIN Person.Person as p 
		ON e.BusinessEntityID = p.BusinessEntityID
ORDER BY Full_name;

/* Q24 */
SELECT (e.Rate*40) AS "weekly_salary",
	CAST(e.RateChangeDate AS DATE) AS "fromdate",
	(p.LastName + ',' + p.FirstName + ' ' + p.MiddleName) AS "Full_name"
FROM HumanResources.EmployeePayHistory as e
	INNER JOIN Person.Person as p 
		ON e.BusinessEntityID = p.BusinessEntityID
			WHERE e.RateChangeDate = (SELECT MAX(RateChangeDate)
			FROM HumanResources.EmployeePayHistory as ep
			WHERE ep.BusinessEntityID = e.BusinessEntityID)
ORDER BY Full_name;

/* Q25 */
SELECT SalesOrderID, ProductID, OrderQty
    ,SUM(OrderQty) OVER (PARTITION BY SalesOrderID) AS "Total Quantity"
    ,AVG(OrderQty) OVER (PARTITION BY SalesOrderID) AS "Avg Quantity"
    ,COUNT(OrderQty) OVER (PARTITION BY SalesOrderID) AS "No of Orders"
    ,MIN(OrderQty) OVER (PARTITION BY SalesOrderID) AS "Min Quantity"
    ,MAX(OrderQty) OVER (PARTITION BY SalesOrderID) AS "Max Quantity"
    FROM Sales.SalesOrderDetail
WHERE SalesOrderID IN(43659,43664);

/* Q26 */
SELECT SalesOrderID, ProductID, OrderQty
    ,SUM(OrderQty) OVER (PARTITION BY SalesOrderID) AS "Total Quantity"
    ,AVG(OrderQty) OVER (PARTITION BY SalesOrderID) AS "Avg Quantity"
    ,COUNT(OrderQty) OVER (PARTITION BY SalesOrderID) AS "No of Orders"
    ,MIN(OrderQty) OVER (PARTITION BY SalesOrderID) AS "Min Quantity"
    ,MAX(OrderQty) OVER (PARTITION BY SalesOrderID) AS "Max Quantity"
    FROM Sales.SalesOrderDetail
WHERE SalesOrderID IN(43659,43664) AND ProductID LIKE '71%';

/* Q27 */
SELECT SalesOrderID, SUM(orderqty*unitprice) as "totalcost"
FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID
HAVING SUM(OrderQty*UnitPrice) > 100000
ORDER BY SalesOrderID;

/* Q28 */
SELECT p.ProductID, p.name
FROM Production.Product as p
WHERE p.name LIKE 'Lock Washer%'
ORDER BY ProductID;

/* Q29 */
SELECT p.ProductID, p.name, p.color
FROM Production.Product as p
ORDER BY p.ListPrice;

/* Q30 */
SELECT BusinessEntityID, JobTitle, HireDate
FROM HumanResources.Employee
ORDER BY YEAR(HireDate);

/* Q31 */
SELECT LastName, FirstName
FROM Person.Person
WHERE LastName LIKE 'R%'
ORDER BY FirstName ASC, LastName DESC;

/* Q32 */
SELECT BusinessEntityID, SalariedFlag
FROM HumanResources.Employee
ORDER BY CASE SalariedFlag WHEN 'true' THEN BusinessEntityID END DESC,
		CASE SalariedFlag WHEN 'false' THEN BusinessEntityID END ASC;

/* Q33 */
SELECT BusinessEntityID, LastName, TerritoryName, CountryRegionName
FROM Sales.vSalesPerson
ORDER BY CASE CountryRegionName WHEN 'United States' THEN TerritoryName END ASC,
		CASE WHEN CountryRegionName != 'United States' THEN TerritoryName END ASC;

/* Q34 */
SELECT p.firstname, p.lastname 
    ,ROW_NUMBER() OVER (ORDER BY a.PostalCode) AS "Row Number"  
    ,RANK() OVER (ORDER BY a.PostalCode) AS "Rank"  
    ,DENSE_RANK() OVER (ORDER BY a.PostalCode) AS "Dense Rank"  
    ,NTILE(4) OVER (ORDER BY a.PostalCode) AS "Quartile" 
	,s.salesytd, a.postalcode
FROM Sales.SalesPerson as s
	INNER JOIN Person.Person as p
	ON s.BusinessEntityID = p.BusinessEntityID
	INNER JOIN Person.Address as a
	ON a.AddressID = p.BusinessEntityID
WHERE salesytd != 0;

/* Q35 */
SELECT * FROM HumanResources.Department
ORDER BY DepartmentID OFFSET 10 ROWS;

/* Q36 */
SELECT * FROM HumanResources.Department
ORDER BY DepartmentID 
	OFFSET 5 ROWS
	FETCH NEXT 5 ROWS ONLY;

/* Q37 */
SELECT p.name, color, listprice
FROM Production.Product as p
WHERE Color IN ('blue', 'red')
ORDER BY listprice;

/* Q38 */
SELECT p.Name, sod.SalesOrderID  
FROM Production.Product AS p  
FULL OUTER JOIN Sales.SalesOrderDetail AS sod  
ON p.ProductID = sod.ProductID  
ORDER BY p.Name ;

/* Q39 */ 
SELECT p.Name, sod.SalesOrderID  
FROM Production.Product AS p  
LEFT OUTER JOIN Sales.SalesOrderDetail AS sod
ON p.ProductID = sod.ProductID  
ORDER BY p.Name ;

/* Q40 */
SELECT p.Name, sod.SalesOrderID  
FROM Production.Product AS p  
INNER JOIN Sales.SalesOrderDetail AS sod
ON p.ProductID = sod.ProductID  
ORDER BY p.Name;

/* Q41 */
SELECT st.name, sp.BusinessEntityID
FROM Sales.SalesTerritory as st
RIGHT OUTER JOIN Sales.SalesPerson as sp
ON sp.TerritoryID = st.TerritoryID;

/* Q42 */
SELECT concat(RTRIM(p.FirstName),' ', LTRIM(p.LastName)) AS Name, d.City  
FROM Person.Person AS p  
INNER JOIN HumanResources.Employee AS e ON p.BusinessEntityID = e.BusinessEntityID   
INNER JOIN  
   (SELECT bea.BusinessEntityID, a.City   
    FROM Person.Address AS a  
    INNER JOIN Person.BusinessEntityAddress AS bea  
    ON a.AddressID = bea.AddressID) AS d  
ON p.BusinessEntityID = d.BusinessEntityID  
ORDER BY p.LastName, p.FirstName;

/* Q43 */
SELECT businessentityid, firstname,lastname  
FROM  
   (SELECT * FROM person.person  
    WHERE persontype = 'IN') AS personDerivedTable 
WHERE lastname = 'Adams'
ORDER BY firstname;

/* Q44 */
SELECT businessentityid, firstname,lastname  
FROM Person.Person
WHERE businessentityid <=1500 AND lastname LIKE 'Al%' AND firstname LIKE 'M%'
ORDER BY businessentityid;

/* Q45 */
SELECT ProductID, a.Name, Color  
FROM Production.Product AS a  
INNER JOIN (VALUES ('Blade'), ('Crown Race'), ('AWC Logo Cap')) AS b(Name)   
ON a.Name = b.Name;

/* Q46 */
WITH Sales_CTE (SalesPersonID, SalesOrderID, SalesYear)
AS
(
    SELECT SalesPersonID, SalesOrderID, DATE_PART('year',OrderDate) AS SalesYear
    FROM Sales.SalesOrderHeader
    WHERE SalesPersonID IS NOT NULL
)
SELECT SalesPersonID, COUNT(SalesOrderID) AS TotalSales, SalesYear
FROM Sales_CTE
GROUP BY SalesYear, SalesPersonID
ORDER BY SalesPersonID, SalesYear;

/* Q47 */
WITH Sales_CTE (SalesPersonID, NumberOfOrders)
AS
(
    SELECT SalesPersonID, COUNT(*)
    FROM Sales.SalesOrderHeader
    WHERE SalesPersonID IS NOT NULL
    GROUP BY SalesPersonID
)
SELECT AVG(NumberOfOrders) AS "Average Sales Per Person"
FROM Sales_CTE;

/* Q48 */
SELECT *   
FROM Production.ProductPhoto  
WHERE LargePhotoFileName LIKE '%green_%';

/* Q49 */
SELECT AddressLine1, AddressLine2, City, PostalCode, CountryRegionCode    
FROM Person.Address AS a  
JOIN Person.StateProvince AS s ON a.StateProvinceID = s.StateProvinceID  
WHERE CountryRegionCode NOT IN ('US')  
AND City LIKE 'Pa%' ;

/* Q50 */
SELECT TOP 20 JobTitle, HireDate  
FROM HumanResources.Employee as e
ORDER BY HireDate desc;

/* Q51 */
SELECT *  
FROM Sales.SalesOrderHeader AS h  
INNER JOIN Sales.SalesOrderDetail AS d 
    ON h.SalesOrderID = d.SalesOrderID   
WHERE h.TotalDue > 100  AND (d.OrderQty > 5 OR d.unitpricediscount < 1000.00);

/* Q52 */
SELECT p.name, color
FROM Production.Product as p
WHERE p.name LIKE '%red%';

/* Q53 */
SELECT p.name, p.ListPrice
FROM Production.Product as p
WHERE p.name LIKE '%Mountain%' AND p.ListPrice = 80.99;

/* Q54 */
SELECT p.name, color
FROM Production.Product as p
WHERE p.name LIKE '%road%' OR p.name LIKE '%Mountain%';

/* Q55 */
SELECT p.name, color
FROM Production.Product as p
WHERE p.name LIKE '%Black%' AND p.name LIKE '%Mountain%';

/* Q56 */
SELECT p.name, color
FROM Production.Product as p
WHERE p.name LIKE 'Chain%';

/* Q57 */
SELECT p.Name, p.Color
FROM Production.Product as p
WHERE p.name LIKE 'Chain%' OR p.name LIKE 'Full%';

/* Q58 */
SELECT p.FirstName+' '+p.LastName+' l ' +e.EmailAddress 
FROM Person.Person as p
INNER JOIN Person.EmailAddress as e
	ON p.BusinessEntityID = e.BusinessEntityID;
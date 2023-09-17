-- Consulta 100 SELECT con Northwind

-- 1. Selecci�n simple
--Aqui seleccionamos dos columnas(campos) de una tabla
SELECT ProductName, UnitPrice FROM Products;

-- 2. Uso de funciones de agregaci�n (SUM)
-- calcular el precio promedio de los productos en cada categor�a de la tabla "Products" 
SELECT CategoryID, AVG(UnitPrice) AS AvgPrice FROM Products
GROUP BY CategoryID;

-- 3. Uso de funciones de agregaci�n (COUNT)
--Contar cu�ntos productos suministra cada proveedor en la tabla "Products"
SELECT SupplierID, COUNT(*) AS ProductCount FROM Products
GROUP BY SupplierID;

-- 4. Uso de funciones de agregaci�n (MAX)
--Encontrar el precio m�ximo (el precio m�s alto) de los productos en cada categor�a de la tabla "Products"
SELECT CategoryID, MAX(UnitPrice) AS MaxPrice FROM Products
GROUP BY CategoryID;

-- 5. Uso de funciones de agregaci�n (MIN)
--Encontrar el precio m�nimo (el precio m�s bajo) de los productos en cada categor�a de la tabla "Products"
SELECT CategoryID, MIN(UnitPrice) AS MinPrice
FROM Products
GROUP BY CategoryID;

-- 6. Uso de funciones de agregaci�n (COUNT DISTINCT)
--Contar la cantidad de categor�as �nicas en la tabla "Products" 
SELECT COUNT(DISTINCT CategoryID) AS UniqueCategories
FROM Products;

-- 7. Uso de funciones de fecha (GETDATE)
/*seleccionar los datos de las �rdenes (pedidos) de la tabla "Orders", 
pero solo aquellas �rdenes que se realizaron en los �ltimos 7 d�as.*/
SELECT OrderID, OrderDate
FROM Orders
WHERE OrderDate >= GETDATE() - 7;

-- 8. Uso de funciones de cadena (CONCAT)
/*Hacer una concatenaci�n para poder unir el nombre con apellido y generar
el nombre completo*/
SELECT CONCAT(FirstName, ' ', LastName) AS FullName
FROM Employees;

-- 9. Uso de funciones condicionales (CASE)
/*Seleccionar un producto y ver si esta en existencia,para esto se pregunta 
si el producto tiene stock, en caso de si tenerlo se mostrara "En stock" de
lo contrario dira "Agotado"*/
SELECT ProductName,
       CASE
           WHEN UnitsInStock > 0 THEN 'En stock'
           ELSE 'Agotado'
       END AS StockStatus
FROM Products;

-- 10. Uso de funciones de ventana (ROW_NUMBER)
/*Se muestran los datos generales del empleado (Nombre, Apellido Paterno,
Apellido Materno) y se le asigna un n�mero de fila a cada empleado.*/
SELECT EmployeeID, LastName, FirstName,
       ROW_NUMBER() OVER (ORDER BY LastName, FirstName) AS RowNum
FROM Employees;

-- 11. Uso de UNION (Uni�n de dos consultas)
/* +Los productos con una cantidad en stock igual o menor a 10.
   +Los productos que han sido descontinuados.*/
SELECT ProductName
FROM Products
WHERE UnitsInStock <= 10
UNION
SELECT ProductName
FROM Products
WHERE Discontinued = 1;
select * from Products;

-- 12. Uso de INNER JOIN (Uni�n interna)
/*Seleccionamos el nombre del cliente de la tabla clientes y 
le agregamos su ID de la orden.*/
SELECT Customers.ContactName, Orders.OrderID
FROM Customers
INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID;

-- 13. Uso de LEFT JOIN (Uni�n izquierda)
/*Lista de pares de datos que incluyen el nombre de contacto del 
cliente ("ContactName") y el identificador �nico de la orden 
("OrderID"). Si un cliente no tiene ninguna orden asociada, su 
nombre de contacto se mostrar� en la lista, pero la columna "OrderID" 
tendr� un valor nulo (NULL).*/ 
SELECT Customers.ContactName, Orders.OrderID
FROM Customers
LEFT JOIN Orders ON Customers.CustomerID = Orders.CustomerID;

-- 14. Uso de RIGHT JOIN (Uni�n derecha)
/*Mostrar� el nombre completo del empleado en la columna 
"EmployeeFullName" junto con el identificador �nico de la orden 
("OrderID")*/ 
SELECT CONCAT(Employees.FirstName, ' ', Employees.LastName) AS EmployeeFullName, Orders.OrderID
FROM Employees
RIGHT JOIN Orders ON Employees.EmployeeID = Orders.EmployeeID;

-- 15. Uso de FULL OUTER JOIN (Uni�n completa)
/*Devuelve una lista que combina informaci�n de clientes y �rdenes, 
incluyendo casos en los que no hay una coincidencia directa entre 
clientes y �rdenes.*/
SELECT Customers.ContactName, Orders.OrderID
FROM Customers
FULL OUTER JOIN Orders ON Customers.CustomerID = Orders.CustomerID;

-- 16. Uso de funciones matem�ticas (ROUND)
/*Proporciona una lista de nombres de productos junto con los precios 
de esos productos redondeados a dos decimales*/
SELECT ProductName, ROUND(UnitPrice, 2) AS RoundedPrice
FROM Products;

-- 17. Uso de funciones de fecha (DATEPART)
/*Lista de las ordenes junto con el a�o que fueron elaboradas*/
SELECT OrderID, DATEPART(year, OrderDate) AS OrderYear
FROM Orders;

-- 18. Uso de funciones de cadena (SUBSTRING)
/* Abrebiaci�n de los nombres de los clientes*/
SELECT ContactName, SUBSTRING(ContactName, 1, 10) AS ShortContact
FROM Customers;

-- 19. Uso de funciones condicionales (IIF)
/*Lista de nombres de productos junto con su estado de existencia 
("En stock" o "Agotado") en la columna "StockStatus." */
SELECT ProductName,
       IIF(UnitsInStock > 0, 'En stock', 'Agotado') AS StockStatus
FROM Products;

-- 20. Uso de funciones de ventana (LEAD)
/*Lista de nombres de productos junto con sus precios unitarios, 
y agrega una columna adicional llamada "NextPrice" que muestra el 
precio unitario del siguiente producto en funci�n del orden de 
precios ascendente.*/
SELECT ProductName, UnitPrice,
       LEAD(UnitPrice) OVER (ORDER BY UnitPrice) AS NextPrice
FROM Products;

/*21. Uso de UNION ALL (Uni�n de dos consultas sin eliminaci�n de 
duplicados)*/
/*lista de nombres de productos que cumplen dos condiciones diferentes:
aquellos con una cantidad en stock igual o menor a 10 y aquellos que 
han sido descontinuados. La consulta utiliza "UNION ALL" para combinar 
los resultados de ambas condiciones sin eliminar duplicados. */
SELECT ProductName
FROM Products
WHERE UnitsInStock <= 10
UNION ALL
SELECT ProductName
FROM Products
WHERE Discontinued = 1;

-- 22. Uso de CROSS JOIN (Producto cartesiano)
/*combinaci�n de todos los clientes con todos los empleados*/
SELECT Customers.ContactName, Employees.LastName
FROM Customers
CROSS JOIN Employees;

-- 23. Uso de SELF JOIN (Uni�n con la misma tabla)
/*Utiliza un "SELF JOIN" en la tabla "Employees" para obtener los 
apellidos de los empleados y los apellidos de sus respectivos jefes. 
El "LEFT JOIN" se basa en la relaci�n "ReportsTo," lo que permite 
identificar qui�n es el jefe de cada empleado.*/
SELECT E1.LastName, E2.LastName AS ManagerLastName
FROM Employees AS E1
LEFT JOIN Employees AS E2 ON E1.ReportsTo = E2.EmployeeID;

-- 24. Uso de una subconsulta (Subconsulta en WHERE)
/*Esta consulta utiliza una subconsulta en la cl�usula "WHERE" para 
seleccionar nombres de productos de la tabla "Products" cuyos 
proveedores tienen un pa�s igual a "USA" seg�n la tabla "Suppliers." 
La subconsulta se utiliza para filtrar los productos seg�n la ubicaci�n 
de sus proveedores.*/
SELECT ProductName
FROM Products
WHERE SupplierID IN (SELECT SupplierID FROM Suppliers WHERE Country = 'USA');

-- 25. Uso de una subconsulta correlacionada (Subconsulta relacionada con la consulta principal)
/*Permite identificar y listar las �rdenes que incluyen un producto 
espec�fico ("ProductID = 1") y mostrar informaci�n relevante de esas 
�rdenes, como sus identificadores y el identificador de los clientes 
que las realizaron.*/
SELECT OrderID, CustomerID
FROM Orders
WHERE OrderID IN (SELECT OrderID FROM [Order Details] WHERE ProductID = 1);
SELECT *FROM [Order Details];

-- 26. Uso de la funci�n MAX con GROUP BY
 /*Devolver� una lista de categor�as de productos junto con el precio 
 m�ximo registrado en cada categor�a.*/
SELECT CategoryID, MAX(UnitPrice) AS MaxPrice
FROM Products
GROUP BY CategoryID;

-- 27. Uso de la funci�n MIN con GROUP BY
/*Devolver� una lista de categor�as de productos junto con el precio 
 minimo registrado en cada categor�a.*/
SELECT CategoryID, MIN(UnitPrice) AS MinPrice
FROM Products
GROUP BY CategoryID;

-- 28. Uso de la funci�n SUM con GROUP BY
/*Devuelve una lista de categor�as de productos junto con la cantidad 
total de productos vendidos en cada una de ellas*/
SELECT CategoryName, SUM([Order Details].Quantity) AS TotalQuantity
FROM Categories
JOIN Products AS P ON Categories.CategoryID = P.CategoryID
JOIN [Order Details] ON P.ProductID = [Order Details].ProductID
GROUP BY Categories.CategoryName;

-- 29. Uso de la funci�n AVG con GROUP BY
/*Devuelve el promedio de los precios de los productos para cada proveedor*/
SELECT SupplierID, AVG(UnitPrice) AS AvgPrice
FROM Products
GROUP BY SupplierID;

-- 30. Uso de la funci�n COUNT con GROUP BY
-- Devuelve el n�mero de productos en cada categor�a
SELECT CategoryID, COUNT(*) AS ProductCount
FROM Products
GROUP BY CategoryID;

-- 31. Uso de funciones matem�ticas (ABS)
-- Devuelve el precio de los productos como valores absolutos
SELECT ProductName, ABS(UnitPrice) AS AbsolutePrice
FROM Products;

-- 32. Uso de funciones de fecha (DATEDIFF)
--Devuelve la diferencia en d�as entre la fecha del pedido y la fecha de env�o
SELECT OrderID, DATEDIFF(day, OrderDate, ShippedDate) AS DaysToShip
FROM Orders
WHERE ShippedDate IS NOT NULL;

-- 33. Uso de funciones de cadena (UPPER)
-- Devuelve el nombre del cliente en may�sculas
SELECT CustomerID, UPPER(ContactName) AS UppercaseName
FROM Customers;

-- 34. Uso de funciones condicionales (NULLIF)
-- Devuelve la cantidad de existencias no nulas
SELECT ProductName,
       NULLIF(UnitsInStock, 0) AS NonZeroStock
FROM Products;

-- 35. Uso de funciones de ventana (LAG)
--Devuelve el nombre del producto, el precio unitario y el precio anterior
SELECT ProductName, UnitPrice,
       LAG(UnitPrice) OVER (ORDER BY UnitPrice) AS PrevPrice
FROM Products;

-- 36. Uso de UNION con tres consultas (Uni�n de tres consultas)
/*Devuelve una lista de productos que tienen existencias bajas, est�n 
descontinuados o tienen un precio alto*/
SELECT ProductName
FROM Products
WHERE UnitsInStock <= 10
UNION
SELECT ProductName
FROM Products
WHERE Discontinued = 1
UNION
SELECT ProductName
FROM Products
WHERE UnitPrice > 50;

/*37. Uso de una subconsulta correlacionada (Subconsulta relacionada 
con la consulta principal)
-- Devuelve el ID y el apellido de los empleados cuyo jefe se 
encuentra en los Estados Unidos*/
SELECT EmployeeID, LastName
FROM Employees
WHERE EmployeeID IN (SELECT ReportsTo FROM Employees WHERE Country = 'USA');

-- 38. Uso de una subconsulta con EXISTS (Subconsulta EXISTS)
-- Devuelve el nombre de los clientes que han realizado al menos una orden
SELECT ContactName
FROM Customers
WHERE EXISTS (SELECT * FROM Orders WHERE Customers.CustomerID = Orders.CustomerID);

-- 39. Uso de la funci�n MAX con TOP (Obtener el m�ximo valor con TOP)
-- Devuelve la orden m�s reciente
SELECT TOP 1 OrderID, OrderDate
FROM Orders
ORDER BY OrderDate DESC;

-- 40. Uso de la funci�n COUNT DISTINCT con HAVING (Agrupar y filtrar con HAVING)
/*Devuelve el n�mero de �rdenes distintas manejadas por cada empleado que haya manejado 
m�s de 5 �rdenes.*/
SELECT Employees.EmployeeID, COUNT(DISTINCT OrderID) AS OrderCount
FROM Employees
JOIN Orders ON Employees.EmployeeID = Orders.EmployeeID
GROUP BY Employees.EmployeeID
HAVING COUNT(DISTINCT OrderID) > 5;

-- 41. Uso de la funci�n COALESCE (Manejar valores nulos con COALESCE)
/*Devuelve el nombre del producto y reemplaza los valores nulos de 
existencias por 0*/
SELECT ProductName, COALESCE(UnitsInStock, 0) AS StockCount
FROM Products;

-- 42. Uso de la funci�n CAST (Convertir tipos de datos con CAST)
-- Devuelve el ID del empleado convertido a cadena
SELECT EmployeeID, CAST(EmployeeID AS VARCHAR) AS EmployeeIDAsString
FROM Employees;

-- 43. Uso de la funci�n SUBQUERY (Subconsulta en SELECT)
/*Devuelve el ID del empleado y la cantidad de �rdenes manejadas por 
ese empleado*/
SELECT EmployeeID,
       (SELECT COUNT(*) FROM Orders WHERE Orders.EmployeeID = Employees.EmployeeID) AS OrderCount
FROM Employees;

-- 44. Uso de JOIN con tres tablas (JOIN con tres tablas)
/*Devuelve el nombre del cliente, el ID de la orden y el nombre del producto para 
todas las �rdenes*/
SELECT Customers.ContactName, Orders.OrderID, Products.ProductName
FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID
JOIN [Order Details] ON Orders.OrderID = [Order Details].OrderID
JOIN Products ON [Order Details].ProductID = Products.ProductID;

-- 45. Uso de la funci�n DATEADD (Sumar d�as a una fecha)
/*Devuelve el ID de la orden, la fecha de la orden y la fecha de la 
orden m�s 7 d�as*/
SELECT OrderID, OrderDate, DATEADD(day, 7, OrderDate) AS NewOrderDate
FROM Orders;

-- 46. Uso de funciones matem�ticas (POWER)
-- Devuelve el nombre del producto, el precio unitario y el precio al cuadrado
SELECT ProductName, UnitPrice, POWER(UnitPrice, 2) AS PriceSquared
FROM Products;

-- 47. Uso de funciones de fecha (DATEADD)
/*Devuelve el ID de la orden, la fecha de la orden y la fecha de la 
orden un mes despu�s*/
SELECT OrderID, OrderDate, DATEADD(month, 1, OrderDate) AS NextMonthOrderDate
FROM Orders;

-- 48. Uso de funciones de cadena (LEN)
/*Devuelve el nombre de la categor�a y la longitud del nombre de la 
categor�a*/
SELECT CategoryName, LEN(CategoryName) AS NameLength
FROM Categories;

-- 49. Uso de funciones condicionales (CHOOSE)
/*Devuelve el nombre del producto y el estado de existencia basado 
en unidades en stock*/
SELECT ProductName, CHOOSE(UnitsInStock + 1, 'Agotado', 'Bajo stock', 'Stock moderado', 'Stock suficiente') AS StockStatus
FROM Products;

-- 50. Uso de funciones de ventana (DENSE_RANK)
/*Devuelve el nombre de la categor�a, el nombre del producto, el 
precio unitario y el rango de precios dentro de cada categor�a*/
SELECT Categories.CategoryName, ProductName, UnitPrice,
       DENSE_RANK() OVER (PARTITION BY Products.CategoryID ORDER BY UnitPrice) AS PriceRank
FROM Products
JOIN Categories ON Products.CategoryID = Categories.CategoryID;

-- 51. Uso de UNION con m�ltiples consultas (Uni�n de m�ltiples consultas)
/*Devuelve una lista de nombres de productos que cumplen con tres condiciones 
diferentes*/
SELECT ProductName
FROM Products
WHERE UnitsInStock <= 10
UNION
SELECT ProductName
FROM Products
WHERE Discontinued = 1
UNION
SELECT ProductName
FROM Products
WHERE UnitPrice > 50;

/* 52. Uso de una subconsulta correlacionada con EXISTS (Subconsulta 
correlacionada con EXISTS)
Devuelve los nombres de contacto de los clientes que han realizado 
�rdenes con un costo de env�o superior a $100*/
SELECT ContactName
FROM Customers
WHERE EXISTS (SELECT * FROM Orders WHERE Customers.CustomerID = Orders.CustomerID AND Freight > 100);

-- 53. Uso de una subconsulta con NOT IN (Subconsulta con NOT IN)
-- Devuelve los empleados que no tienen un superior (jefe)
SELECT EmployeeID, LastName, FirstName
FROM Employees
WHERE EmployeeID NOT IN (SELECT ReportsTo FROM Employees WHERE ReportsTo IS NOT NULL);

/* 54. Uso de la funci�n AVG con TOP (Obtener el promedio de los primeros 
N registros)*/
/* Devuelve el promedio de precios unitarios de los 10 productos con los precios 
m�s altos, agrupados por categor�a*/
SELECT TOP 10 CategoryID, AVG(UnitPrice) AS AvgPrice
FROM Products
GROUP BY CategoryID
ORDER BY AvgPrice DESC;

-- 55. Uso de la funci�n SUM con WHERE (Sumar valores bajo cierta condici�n)
/* Devuelve el total de costos de env�o de �rdenes para los empleados cuyo 
pa�s de env�o es 'USA'*/
SELECT EmployeeID, SUM(Freight) AS TotalFreightCost
FROM Orders
WHERE ShipCountry = 'USA'
GROUP BY EmployeeID;

-- 56. Uso de la funci�n CONCAT con condiciones (Concatenar con condiciones)
--Devuelve el nombre del producto junto con detalles adicionales entre par�ntesis
SELECT ProductName,
       CONCAT(ProductName, ' (', QuantityPerUnit, ')') AS ProductDetails
FROM Products;

-- 57. Uso de JOIN con alias (JOIN con alias)
/*Devuelve el nombre de contacto de los clientes y los n�meros de orden, 
utilizando alias para las tablas*/
SELECT C.ContactName, O.OrderID
FROM Customers AS C
JOIN Orders AS O ON C.CustomerID = O.CustomerID;

-- 58. Uso de la funci�n MONTH (Obtener el mes de una fecha)
/*Devuelve el ID de la orden, la fecha de la orden y el mes de la fecha de la orden*/
SELECT OrderID, OrderDate, MONTH(OrderDate) AS OrderMonth
FROM Orders;

/*59. Uso de la funci�n DISTINCT con m�ltiples columnas (Valores 
distintos para m�ltiples columnas)*/
-- Devuelve una lista de ciudades de env�o y pa�ses de env�o �nicos
SELECT DISTINCT ShipCity, ShipCountry
FROM Orders;

-- 60. Uso de la funci�n REPLACE (Reemplazar caracteres en una cadena)
/*Devuelve el nombre de contacto de los clientes con guiones en los 
n�meros de tel�fono eliminados*/
SELECT ContactName, REPLACE(Phone, '-', '') AS CleanedPhone
FROM Customers;

-- 61. Uso de funciones matem�ticas (CEILING)
/*Devuelve el nombre del producto, el precio unitario y el precio 
redondeado hacia arriba utilizando CEILING*/
SELECT ProductName, UnitPrice, CEILING(UnitPrice) AS RoundedPriceUp
FROM Products;

-- 62. Uso de funciones de fecha (YEAR)
--Devuelve el ID de la orden, la fecha de la orden y el a�o de la fecha de la orden
SELECT OrderID, OrderDate, YEAR(OrderDate) AS OrderYear
FROM Orders;

-- 63. Uso de funciones de cadena (LOWER)
-- Devuelve el nombre de contacto de los clientes en min�sculas
SELECT ContactName, LOWER(ContactName) AS LowercaseName
FROM Customers;

-- 64. Uso de funciones condicionales (COALESCE con CASE)
/*Devuelve el nombre del producto y el estado de existencia ("En stock" o "Agotado") 
utilizando COALESCE y CASE*/
SELECT ProductName,
       CASE 
           WHEN UnitsInStock > 0 THEN 'En stock'
           ELSE 
               CASE 
                   WHEN COALESCE(Discontinued, 0) = 0 THEN 'Agotado'
                   ELSE 'No Agotado'
               END
       END AS StockStatus
FROM Products;

-- 65. Uso de funciones de ventana (NTILE)
/*Devuelve el nombre del producto, el precio unitario y el cuartil de precios
utilizando NTILE*/
SELECT ProductName, UnitPrice,
       NTILE(4) OVER (ORDER BY UnitPrice) AS PriceQuartile
FROM Products;

-- 66. Uso de UNION con m�ltiples consultas y ORDER BY (Uni�n con ORDER BY)
/*Combina nombres de productos de la tabla "Products" que cumplen tres condiciones
diferentes (baja existencia, discontinuados o alto precio) y los ordena 
alfab�ticamente.*/
SELECT ProductName
FROM Products
WHERE UnitsInStock <= 10
UNION
SELECT ProductName
FROM Products
WHERE Discontinued = 1
UNION
SELECT ProductName
FROM Products
WHERE UnitPrice > 50
ORDER BY ProductName;

/*67. Uso de una subconsulta correlacionada con EXISTS y NOT EXISTS 
(Subconsulta correlacionada con EXISTS y NOT EXISTS)*/
/*Encuentra nombres de contacto de clientes que han realizado 
pedidos pero no tienen registros en "CustomerCustomerDemo".*/
SELECT ContactName
FROM Customers
WHERE EXISTS (SELECT * FROM Orders WHERE Customers.CustomerID = Orders.CustomerID)
AND NOT EXISTS (SELECT * FROM CustomerCustomerDemo WHERE Customers.CustomerID = CustomerCustomerDemo.CustomerID);

-- 68. Listar Supervisores de Empleados
/*seleccionamos los empleados cuyo EmployeeID coincide con el ReportsTo en 
la misma tabla "Employees" de la base de datos Northwind. Esto deber�a 
seleccionar los empleados que act�an como supervisores de otros empleados.*/
SELECT EmployeeID, LastName, FirstName
FROM Employees
WHERE EmployeeID IN (
    SELECT ReportsTo
    FROM Employees
);
/*69. Uso de la funci�n COUNT con DISTINCT y WHERE (Contar valores distintos 
bajo ciertas condiciones)*/
/*Cuenta los nombres de productos �nicos en cada categor�a, excluyendo los productos 
discontinuados.*/
SELECT CategoryID, COUNT(DISTINCT ProductName) AS DistinctProductCount
FROM Products
WHERE Discontinued = 0
GROUP BY CategoryID;

/*70. Uso de la funci�n MAX con PARTITION BY (Obtener el m�ximo por partici�n)
Calcula el precio unitario m�ximo para cada categor�a de productos y muestra 
los detalles de los productos.*/
SELECT CategoryID, ProductName, UnitPrice,
       MAX(UnitPrice) OVER (PARTITION BY CategoryID) AS MaxPriceInCategory
FROM Products;

/*71. Uso de la funci�n SUM con PARTITION BY (Obtener la suma por partici�n)
Calcula la suma de los precios unitarios para cada categor�a de productos y 
muestra los detalles de los productos.*/
SELECT CategoryID, ProductName, UnitPrice,
       SUM(UnitPrice) OVER (PARTITION BY CategoryID) AS TotalPriceInCategory
FROM Products;

/*72. Uso de la funci�n RANK con PARTITION BY (Obtener el rango por partici�n)
Asigna un rango a los productos seg�n su precio unitario dentro de cada categor�a.*/
SELECT CategoryID, ProductName, UnitPrice,
       RANK() OVER (PARTITION BY CategoryID ORDER BY UnitPrice DESC) AS PriceRankInCategory
FROM Products;

/*73. Uso de la funci�n CONCAT_WS (Concatenar con separador)
Concatena los nombres y apellidos de los empleados separados por comas.*/
SELECT FirstName, LastName, CONCAT_WS(', ', LastName, FirstName) AS FullName
FROM Employees;

/*74. Uso de la funci�n COALESCE con valores predeterminados (Manejar 
valores nulos con COALESCE y valores predeterminados)
Maneja valores nulos en la cantidad en stock y el precio de los productos, 
reemplaz�ndolos con ceros si son nulos.*/
SELECT ProductName, COALESCE(UnitsInStock, 0) AS StockCount,
       COALESCE(UnitPrice, 0) AS Price
FROM Products;

/*75. Uso de JOIN con m�ltiples tablas (JOIN con m�ltiples tablas)
ista de clientes, sus pedidos y los productos incluidos en cada
pedido, junto con la cantidad de productos.*/
SELECT Customers.CustomerID, Customers.ContactName, Orders.OrderID, [Order Details].ProductID, [Order Details].Quantity
FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID
JOIN [Order Details] ON Orders.OrderID = [Order Details].OrderID;
select * from Shippers;
select * from Orders;
select * from Customers;

/*76. Uso de funciones matem�ticas (FLOOR)
Mostrar� el nombre del producto y el precio unitario redondeado hacia abajo 
a un n�mero entero en la columna "RoundedPriceDown."*/
SELECT ProductName, UnitPrice, FLOOR(UnitPrice) AS RoundedPriceDown
FROM Products;

-- 77. Uso de funciones de fecha (MONTH)
/*Mostrar� el ID de las ordenes de un determinado mes"*/
SELECT OrderID, OrderDate
FROM Orders
WHERE MONTH(OrderDate) = 5;

-- 78. Uso de funciones de cadena (LEN y LEFT)
/*muestra el nombre de la empresa de la tabla "Customers," calcula la longitud 
de cada nombre utilizando LEN y muestra los primeros 10 caracteres de cada 
nombre con LEFT.*/
SELECT CompanyName, LEN(CompanyName) AS CompanyNameLength,
       LEFT(CompanyName, 10) AS ShortCompanyName
FROM Customers;

-- 79. Uso de funciones condicionales (CASE con m�ltiples condiciones)
/*proporciona informaci�n sobre si cada producto est� en stock, tiene stock 
suficiente o est� agotado, lo que puede ser �til para el seguimiento y la 
gesti�n de inventario.*/
SELECT ProductName,
       CASE
           WHEN UnitsInStock > 50 THEN 'Stock suficiente'
           WHEN UnitsInStock > 0 THEN 'En stock'
           ELSE 'Agotado'
       END AS StockStatus
FROM Products;

-- 80. Uso de funciones de ventana (FIRST_VALUE)
--Identifica el producto m�s econ�mico en cada categor�a.
SELECT CategoryID, ProductName, UnitPrice,
       FIRST_VALUE(ProductName) OVER (PARTITION BY CategoryID ORDER BY UnitPrice) AS FirstProductInCategory
FROM Products;

-- 81. Uso de UNION con m�ltiples consultas y ORDER BY (Uni�n con ORDER BY)
--Los nombres de los productos se presentan en orden alfab�tico.*/
SELECT ProductName
FROM Products
WHERE UnitsInStock <= 10
UNION
SELECT ProductName
FROM Products
WHERE Discontinued = 1
UNION
SELECT ProductName
FROM Products
WHERE UnitPrice > 50
ORDER BY ProductName;

/*82. Uso de una subconsulta correlacionada con m�ltiples condiciones 
(Subconsulta correlacionada con m�ltiples condiciones)
La subconsulta verifica si existe al menos un pedido del cliente con 
destino a los EE. UU.*/
SELECT ContactName
FROM Customers
WHERE EXISTS (SELECT * FROM Orders WHERE Customers.CustomerID = Orders.CustomerID AND ShipCountry = 'USA');

-- 83. Uso de una subconsulta con operador IN (Subconsulta con IN)
/*muestra los empleados cuyos supervisores tienen IDs 2, 5 o 7. Muestra el ID del empleado, 
su apellido y su nombre.*/
SELECT EmployeeID, LastName, FirstName
FROM Employees
WHERE EmployeeID IN (SELECT ReportsTo FROM Employees WHERE ReportsTo IN (2, 5, 7));

/*84. Uso de la funci�n COUNT con DISTINCT y WHERE (Contar valores distintos 
bajo ciertas condiciones)
cuenta cu�ntos proveedores �nicos suministran productos en cada categor�a. 
Muestra el ID de categor�a y la cantidad de proveedores �nicos en la columna 
"UniqueSuppliersCount" para productos que no est�n descontinuados.*/
SELECT CategoryID, COUNT(DISTINCT SupplierID) AS UniqueSuppliersCount
FROM Products
WHERE Discontinued = 0
GROUP BY CategoryID;

/*85. Uso de la funci�n SUM con PARTITION BY y ORDER BY (Obtener la suma 
acumulativa)
calcula la cantidad acumulativa de productos dentro de cada pedido y muestra 
el ID del pedido, el ID del producto, la cantidad individual y la cantidad 
acumulativa en la columna "CumulativeQuantity."*/
SELECT OrderID, ProductID, Quantity,
       SUM(Quantity) OVER (PARTITION BY OrderID ORDER BY ProductID) AS CumulativeQuantity
FROM [Order Details];

/*86. Uso de la funci�n ROW_NUMBER con PARTITION BY (Asignar n�meros de fila 
dentro de particiones)
asigna un n�mero de fila a cada producto dentro de su categor�a, ordenando los 
productos por precio unitario. Muestra el ID de categor�a, el nombre del 
producto, el precio unitario y el n�mero de fila en la columna "RowInCategory."*/
SELECT CategoryID, ProductName, UnitPrice,
       ROW_NUMBER() OVER (PARTITION BY CategoryID ORDER BY UnitPrice) AS RowInCategory
FROM Products;

/*87. Uso de la funci�n CONCAT_WS (Concatenar con separador)
muestra los nombres y apellidos de los empleados y concatena sus apellidos 
seguidos de comas y nombres en una columna llamada "FullName."*/
SELECT FirstName, LastName, CONCAT_WS(', ', LastName, FirstName) AS FullName
FROM Employees;

/*88. Uso de la funci�n COALESCE con valores predeterminados (Manejar valores nulos con COALESCE y valores predeterminados)
Muestra el nombre de los productos, la cantidad en stock (reemplazando los 
valores nulos con 0) en la columna "StockCount," y el precio unitario 
(reemplazando los valores nulos con 0) en la columna "Price."*/
SELECT ProductName, COALESCE(UnitsInStock, 0) AS StockCount,
       COALESCE(UnitPrice, 0) AS Price
FROM Products;

-- 89. Uso de JOIN con m�ltiples tablas (JOIN con m�ltiples tablas)
--50 ordenes mas nuevas 
SELECT TOP 50 OrderID, OrderDate
FROM Orders
ORDER BY OrderDate DESC;

-- 90. Uso de JOIN con condiciones adicionales (JOIN con condiciones adicionales)
/* devuelve los nombres de los empleados y la cantidad total de pedidos que han 
atendido exclusivamente para clientes en los Estados Unidos.*/
SELECT Employees.FirstName, Employees.LastName, COUNT(Orders.OrderID) AS TotalOrders
FROM Employees
JOIN Orders ON Employees.EmployeeID = Orders.EmployeeID
JOIN Customers ON Orders.CustomerID = Customers.CustomerID
WHERE Customers.Country = 'USA'
GROUP BY Employees.FirstName, Employees.LastName;

-- 91. "Mostrar Nombre del Producto y Precio Unitario con Logaritmo Natural"
/*muestra el nombre del producto y su precio unitario de la tabla "Products". 
Luego, calcula el logaritmo natural (base e) del precio unitario de cada 
producto y muestra el resultado en la columna "LogarithmPrice".
*/
SELECT ProductName, UnitPrice, LOG(UnitPrice) AS LogarithmPrice
FROM Products;

-- 92. Uso de funciones de fecha (DAY)
/*Muestra el ID del pedido, la fecha del pedido y extrae el d�a del mes de la 
fecha del pedido utilizando la funci�n DAY, que se muestra en la columna 
"OrderDay."*/
SELECT OrderID, OrderDate, DAY(OrderDate) AS OrderDay
FROM Orders;

-- 93. Uso de funciones de cadena (CHARINDEX)
/*Comprueba si el nombre de env�o contiene "Express" y muestra 
1 si s� lo contiene, 0 si no.*/
SELECT ShipName, CHARINDEX('Express', ShipName) AS ContainsExpress
FROM Orders;

-- 94. Uso de funciones condicionales (NULLIF con COALESCE)
--Reemplaza valores nulos en "UnitsInStock" con 1 en la columna "NonZeroStock".
SELECT ProductName, COALESCE(NULLIF(UnitsInStock, 0), 1) AS NonZeroStock
FROM Products;

-- 95. Uso de funciones de ventana (LAG con PARTITION BY)
/*Muestra el precio unitario y el precio unitario anterior en orden ascendente dentro de 
cada categor�a.*/
SELECT CategoryID, ProductName, UnitPrice,
       LAG(UnitPrice) OVER (PARTITION BY CategoryID ORDER BY UnitPrice) AS PrevPrice
FROM Products;

-- 96. Uso de UNION con m�ltiples consultas (Uni�n de m�ltiples consultas)
/*Combina nombres de productos que cumplen tres condiciones diferentes: baja existencia, discontinuados 
o alto precio.*/
SELECT ProductName
FROM Products
WHERE UnitsInStock <= 10
UNION
SELECT ProductName
FROM Products
WHERE Discontinued = 1
UNION
SELECT ProductName
FROM Products
WHERE UnitPrice > 50;

/* 97. Uso de una subconsulta correlacionada con GROUP BY 
(Subconsulta correlacionada con GROUP BY)
Cuenta la cantidad de �rdenes por cliente.*/
SELECT CustomerID, CompanyName,
       (SELECT COUNT(*) FROM Orders WHERE Customers.CustomerID = Orders.CustomerID) AS OrderCount
FROM Customers;

/* 98. Uso de una subconsulta con operador NOT IN (Subconsulta con NOT IN)
Selecciona empleados excluyendo aquellos con supervisores.*/
SELECT EmployeeID, LastName, FirstName
FROM Employees
WHERE EmployeeID NOT IN (SELECT ReportsTo FROM Employees WHERE ReportsTo IS NOT NULL);

/* 99. Uso de la funci�n COUNT con DISTINCT y HAVING (Contar valores distintos 
con filtro HAVING)
Cuenta nombres de productos distintos por categor�a y muestra solo categor�as 
con m�s de 5 nombres distintos.*/
SELECT CategoryID, COUNT(DISTINCT ProductName) AS DistinctProductCount
FROM Products
GROUP BY CategoryID
HAVING COUNT(DISTINCT ProductName) > 5;

/* 100. Uso de la funci�n SUM con PARTITION BY y ORDER BY (Obtener la suma 
acumulativa)
Calcula la cantidad acumulativa de productos dentro de cada pedido.*/
SELECT OrderID, ProductID, Quantity,
       SUM(Quantity) OVER (PARTITION BY OrderID ORDER BY ProductID) AS CumulativeQuantity
FROM [Order Details];
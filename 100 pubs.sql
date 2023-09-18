--Select de ayuda
--Poder revisar las llaves primarias y foraneas de la base de datos
use pubs;
SELECT 
    OBJECT_NAME(fk.parent_object_id) AS TablaPrincipal,
    col.name AS LlavePrimaria,
    OBJECT_NAME(fk.referenced_object_id) AS TablaForanea,
    col_ref.name AS LlaveForanea
FROM 
    sys.foreign_keys AS fk
INNER JOIN 
    sys.foreign_key_columns AS fkc ON fk.object_id = fkc.constraint_object_id
INNER JOIN 
    sys.columns AS col ON fkc.parent_column_id = col.column_id AND fkc.parent_object_id = col.object_id
INNER JOIN 
    sys.columns AS col_ref ON fkc.referenced_column_id = col_ref.column_id AND fkc.referenced_object_id = col_ref.object_id

--Revisar tablas y campos de la base de datos
SELECT 
    t.name AS NombreTabla,
    c.name AS NombreColumna,
    type.name AS TipoDato,
    c.max_length AS LongitudMaxima,
    c.is_nullable AS EsNullable,
    CASE WHEN pkc.column_id IS NOT NULL THEN 'Sí' ELSE 'No' END AS EsClavePrimaria
FROM 
    sys.tables AS t
INNER JOIN 
    sys.columns AS c ON t.object_id = c.object_id
INNER JOIN 
    sys.types AS type ON c.system_type_id = type.system_type_id
LEFT JOIN 
    sys.indexes AS pk ON t.object_id = pk.object_id AND pk.is_primary_key = 1
LEFT JOIN 
    sys.index_columns AS pkc ON pk.object_id = pkc.object_id AND c.column_id = pkc.column_id AND pk.index_id = pkc.index_id
ORDER BY 
    t.name, c.column_id;


--1. Total de libros que están registrados en esa tabla en particular.
SELECT COUNT(*) AS total_books
FROM titles;

--2. Unión del nombre con el apellido
SELECT CONCAT(authors.au_fname, ' ', authors.au_lname) AS full_name
FROM authors;

--3. Obtener la cantidad promedio de regalias que los autores reciben en esa tabla en particular.
SELECT AVG(royaltyper) AS avg_royalty
FROM titleauthor;

--4. Recupera los nombres de editoriales únicos que están asociados a títulos de 
--libros en la base de datos.
SELECT DISTINCT publishers.pub_name
FROM publishers
INNER JOIN titles ON publishers.pub_id = titles.pub_id;

--5. Lista de empleados y las descripciones de los trabajos que desempeñan
SELECT employee.fname, jobs.job_desc
FROM employee
LEFT JOIN jobs ON employee.job_id = jobs.job_id;

--6. Lista de nombres de tiendas (almacenes) distintos que están asociados a ventas en una base de datos.
SELECT DISTINCT stores.stor_name
FROM stores
RIGHT JOIN sales ON stores.stor_id = sales.stor_id;

--7. Listar todos los títulos de libros junto con su información de publicación: 
SELECT titles.title_id, titles.title, pub_info.pub_id, titles.pubdate
from titles
INNER JOIN pub_info ON titles.pub_id = pub_info.pub_id;

--8. Obtener una lista de autores y sus libros publicados:
SELECT authors.au_id, authors.au_fname, authors.au_lname, titles.title
FROM authors
INNER JOIN titleauthor ON authors.au_id = titleauthor.au_id
INNER JOIN titles ON titleauthor.title_id = titles.title_id;

--9. Mostrar la información de ventas de libros por tienda:
SELECT sales.stor_id, stores.stor_name, titles.title, sales.ord_date, sales.qty
FROM sales
INNER JOIN titles ON sales.title_id = titles.title_id
INNER JOIN stores ON sales.stor_id = stores.stor_id;

--10. Listar los empleados junto con su información de trabajo
SELECT employee.emp_id, employee.fname, employee.lname, jobs.job_desc
FROM employee
INNER JOIN jobs ON employee.job_id = jobs.job_id;

--11. Listar los nombres de las editoriales y la cantidad de títulos publicados por cada una
SELECT publishers.pub_name, COUNT(titles.title_id) AS num_titles_published
FROM publishers
INNER JOIN titles ON publishers.pub_id = titles.pub_id
GROUP BY publishers.pub_name;

--12. Mostrar la información de programación de pagos de regalías por libro
SELECT roysched.title_id, titles.title, roysched.lorange, roysched.hirange, roysched.royalty
FROM roysched 
INNER JOIN titles ON roysched.title_id = titles.title_id;

--13. Obtener una lista de libros vendidos junto con su información de descuento
SELECT sales.title_id, titles.title, discounts.discounttype, discounts.discount
FROM sales
INNER JOIN discounts ON sales.stor_id = discounts.stor_id
INNER JOIN titles ON sales.title_id = titles.title_id;

--14. Listar los libros y sus autores junto con la información de las editoriales
SELECT titles.title_id, titles.title, authors.au_id, authors.au_fname, authors.au_lname, pub_info.pub_id
FROM titles
INNER JOIN titleauthor ta ON titles.title_id = ta.title_id
INNER JOIN authors ON ta.au_id = authors.au_id
INNER JOIN pub_info ON titles.pub_id = pub_info.pub_id;

--15. calcula la cantidad total de libros vendidos para cada título y editorial
SELECT titles.title_id, titles.title, sales.stor_id, sales.qty
FROM titles
LEFT JOIN sales ON titles.title_id = sales.title_id;

--16. Obtener una lista de autores junto con la cantidad total de libros vendidos de cada autor
SELECT authors.au_id, authors.au_fname, authors.au_lname, SUM(sales.qty) AS total_books_sold
FROM authors
INNER JOIN titleauthor ON authors.au_id = titleauthor.au_id
INNER JOIN sales ON titleauthor.title_id = sales.title_id
GROUP BY authors.au_id, authors.au_fname, authors.au_lname;

--17. Listar las tiendas junto con sus ubicaciones y las ventas totales en cada una
SELECT stores.stor_id, stores.stor_name, stores.stor_address, SUM(sales.qty) AS total_sales
FROM stores
LEFT JOIN sales ON stores.stor_id = sales.stor_id
GROUP BY stores.stor_id, stores.stor_name, stores.stor_address;

--18. Listar todas las tiendas junto con los títulos de libros vendidos en cada una, 
--incluso si no se han vendido algunos libros en una tienda.
SELECT stores.stor_id, stores.stor_name, titles.title
FROM stores
LEFT JOIN sales ON stores.stor_id = sales.stor_id
LEFT JOIN titles  ON sales.title_id = titles.title_id;

--19. Mostrar una lista de todas las editoriales y los títulos de libros que han publicado, 
--incluyendo aquellas editoriales que no han publicado ningún libro. 
SELECT publishers.pub_id, publishers.pub_name, titles.title
FROM publishers
FULL JOIN titles ON publishers.pub_id = titles.pub_id;

--20. Muestra información sobre los títulos de los libros y las ventas correspondientes en las tiendas, 
--teniendo en cuenta que algunos títulos pueden no haber tenido ventas.
SELECT t.title_id, t.title, p.pub_id, SUM(s.qty) AS total_sold
FROM titles t
INNER JOIN pub_info p ON t.pub_id = p.pub_id
INNER JOIN sales s ON t.title_id = s.title_id
GROUP BY t.title_id, t.title, p.pub_id;

--21. 
SELECT stores.stor_id, stores.stor_name, stores.stor_address, SUM(sales.qty) AS total_sales
FROM stores
LEFT JOIN sales ON stores.stor_id = sales.stor_id
GROUP BY stores.stor_id, stores.stor_name, stores.stor_address;

--22. Procedimiento almacenado para calcular el total de copias vendidas
CREATE PROCEDURE CalculateTotalSold
    @multiplier INT
AS
BEGIN
    SELECT sales.title_id, titles.title, pub_info.pub_id, sales.qty * @multiplier AS total_sold
    FROM titles
    INNER JOIN pub_info ON titles.pub_id = pub_info.pub_id
    INNER JOIN sales ON titles.title_id = sales.title_id;
END;
--Ejecutar procedmiento
DECLARE @Multiplier INT
SET @Multiplier = 15
EXEC CalculateTotalSold @Multiplier

select * from sales;
--23. Procedimiento almacenado para calcular el tiempo de los trabajadores en la empresa
CREATE PROCEDURE CalculateAverageAge
    @currentYear INT
AS
BEGIN
    SELECT employee.emp_id, employee.fname, employee.lname, j.job_desc,
           @currentYear - YEAR(employee.hire_date) AS avg_age
    FROM employee
    RIGHT JOIN jobs j ON employee.job_id = j.job_id;
END;

--24. Calcular el tiempo laboral del empleado
CREATE PROCEDURE CalculateEmployeeYearsWorking
    @currentDate DATE
AS
BEGIN
    SELECT employee.emp_id, employee.fname, employee.lname, jobs.job_desc,
           DATEDIFF(YEAR, employee.hire_date, @currentDate) - 
           CASE WHEN (DATEPART(MONTH, employee.hire_date) > DATEPART(MONTH, @currentDate)) OR 
                     (DATEPART(MONTH, employee.hire_date) = DATEPART(MONTH, @currentDate) AND 
                      DATEPART(DAY, employee.hire_date) > DATEPART(DAY, @currentDate))
                THEN 1
                ELSE 0
           END AS years_working
    FROM employee
    RIGHT JOIN jobs ON employee.job_id = jobs.job_id;
END;
-- Declarar una variable para la fecha actual
DECLARE @currentDate DATE;
SET @CurrentDate = '2023-09-17';

--25. Crear un procedimiento almacenado para calcular regalías con un parámetro
-- Ejecutar el procedimiento almacenado
CREATE PROCEDURE CalculateRoyaltiesWithMultiplier
    @multiplier DECIMAL(10, 2)
AS
BEGIN
    SELECT authors.au_id, authors.au_fname, authors.au_lname, 
           SUM(titles.price * sales.qty * @multiplier) AS total_royalties
    FROM authors
    INNER JOIN titleauthor ON authors.au_id = titleauthor.au_id
    INNER JOIN titles ON titleauthor.title_id = titles.title_id
    INNER JOIN sales ON titles.title_id = sales.title_id
    GROUP BY authors.au_id, authors.au_fname, authors.au_lname;
END;
-- Ejecutar el procedimiento con un multiplicador de 0.1
EXEC CalculateRoyaltiesWithMultiplier 0.1;
-- Ejecutar el procedimiento con un multiplicador de 0.05
EXEC CalculateRoyaltiesWithMultiplier 0.05;

--26. Obtener información sobre las ventas en tiendas
CREATE PROCEDURE GetSalesWithNullReplacement
    @replacementValue NVARCHAR(255)
AS
BEGIN
    SELECT s.stor_id, s.stor_name, 
           ISNULL(t.title, @replacementValue) AS title
    FROM stores s
    LEFT JOIN sales sa ON s.stor_id = sa.stor_id
    LEFT JOIN titles t ON sa.title_id = t.title_id;
END;
-- Ejecutar el procedimiento con un valor de reemplazo "Sin venta"
EXEC GetSalesWithNullReplacement 'Sin venta';

--27. Mostrar una lista de autores con la suma de las regalías ganadas por cada uno, 
--calculando las regalías como el producto del precio del libro y la cantidad vendida, 
--y luego sumando estos valores
SELECT a.au_id, a.au_fname, a.au_lname, 
       SUM(t.price * s.qty) AS total_royalties
FROM authors a
INNER JOIN titleauthor ta ON a.au_id = ta.au_id
INNER JOIN titles t ON ta.title_id = t.title_id
INNER JOIN sales s ON t.title_id = s.title_id
GROUP BY a.au_id, a.au_fname, a.au_lname;

--28. Mostrar una lista de autores que no hayan escrito ningún libro
SELECT a.au_id, a.au_fname, a.au_lname
FROM authors a
LEFT JOIN titleauthor ta ON a.au_id = ta.au_id
WHERE ta.title_id IS NULL;

--29. Consulta para seleccionar empleados con el mismo job_id y obtener el nombre del empleo
CREATE PROCEDURE GetEmployeesByJobID
    @jobID INT
AS
BEGIN
    SELECT e.emp_id, e.fname, e.lname, j.job_desc AS job_name
    FROM employee e
    INNER JOIN jobs j ON e.job_id = j.job_id
    WHERE e.job_id = @jobID;
END;
-- Ejemplo de uso del procedimiento almacenado
EXEC GetEmployeesByJobID @jobID = 13;

--30. Ordenar la venta de libros de mayor a menor dependiendo en la tienda que han sido vendidos
SELECT s.stor_id, s.stor_name, t.title, t.price AS max_price
FROM stores s
INNER JOIN sales sa ON s.stor_id = sa.stor_id
INNER JOIN titles t ON sa.title_id = t.title_id
WHERE t.price = (SELECT MAX(price) FROM titles WHERE title_id = sa.title_id);

--31. Ordenar los libros de mayor a menor
SELECT title, price
FROM titles
ORDER BY price DESC;

--32. Ordenar la venta de libros de una tienda de mayor a menor precio
CREATE PROCEDURE GetBooksInStoreWithStoreName
    @storeID INT
AS
BEGIN
    -- Consulta para obtener una lista de libros en una tienda específica con el nombre de la tienda
    SELECT s.stor_id, s.stor_name, t.title, t.price
    FROM stores s
    INNER JOIN sales sa ON s.stor_id = sa.stor_id
    INNER JOIN titles t ON sa.title_id = t.title_id
    WHERE s.stor_id = @storeID
    ORDER BY t.price DESC;
END;
EXEC GetBooksInStoreWithStoreName @storeID = 6380;

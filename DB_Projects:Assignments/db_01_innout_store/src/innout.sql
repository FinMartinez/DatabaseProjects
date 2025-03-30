-- CS3810: Principles of Database Systems
-- Instructor: Thyago Mota
-- Student(s): Fin Martinez
-- Description: SQL for the In-N-Out Store

DROP DATABASE innout;

CREATE DATABASE innout;

\c innout

-- TODO: table create statements
-----------------
--Customers Table
-----------------
CREATE TABLE Customers(
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(15),
    last_name VARCHAR(15),
    gender CHAR(1) DEFAULT '?'
);

------------------
--Categories Table
------------------

CREATE TABLE Categories(
    cat_code CHAR(3) PRIMARY KEY,
    "desc" VARCHAR(10) NOT NULL
);

-------------
--Items Table
-------------

CREATE TABLE Items(
    item_code SERIAL PRIMARY KEY,
    "desc" VARCHAR(20) NOT NULL,
    price DECIMAL(3,2) NOT NULL,
    cat_code CHAR(3)
);

-------------------------
--Sales Information Table
-------------------------

CREATE TABLE InfoSales(
    sale_id INT PRIMARY KEY,
    cust_id INT NOT NULL,
    FOREIGN KEY (cust_id) REFERENCES Customers(id),
    "date" CHAR(8) NOT NULL,
    "time" CHAR(8) NOT NULL,
    item INT NOT NULL,
    FOREIGN KEY (item) REFERENCES Items(item_code),
    quantity INT NOT NULL,
    price DECIMAL (3, 2) NOT NULL,
    total DECIMAL (4, 2)
);

-- TODO: table insert statements

--Customers
INSERT INTO Customers (first_name, last_name) VALUES
('Eris', 'Apple');

INSERT INTO Customers(first_name, last_name, gender) VALUES
('Gordon', 'Ramsay', 'M'),
('Anthony', 'Bourdain', 'M'),
('Claire', 'Saffitz', 'F'),
('Cat', 'Cora', 'F');

--Items
INSERT INTO Items("desc", price, cat_code) VALUES
('beef', 4.00, 'MEA'),
('chicken', 3.50, 'MEA'),
('pork', 3.00, 'MEA'),
('fish', 3.75, 'SEA'),
('crab', 5.00, 'SEA'),
('shrimp', 4.00, 'SEA'),
('bread', 2.00, 'BKY'),
('muffins', 3.50, 'BKY'),
('cake', 4.00, 'BKY'),
('soda', 1.00, 'BVR'),
('juice', 1.75, 'BVR'),
('seltzer', 1.50, 'BVR'),
('cheese', 2.00, 'DRY'),
('eggs', 4.00, 'DRY'),
('milk', 1.50, 'DRY'),
('pizza', 3.00, 'FRZ'),
('burrito', 2.00, 'FRZ'),
('popsicle', 2.00, 'FRZ'),
('bags', 0.10, NULL),
('headphones', 9.99, NULL);

--Categories
INSERT INTO Categories VALUES
('BVR', 'beverages'),
('DRY', 'dairy'),
('PRD', 'produce'),
('FRZ', 'frozen'),
('BKY', 'bakery'),
('MEA', 'meat'),
('SEA', 'seafood'),
('ALC', 'alcohol');

--Select statement to obtain customer ids and item codes for use in InfoSales
SELECT last_name, id FROM Customers
ORDER BY 1;

SELECT item_code, "desc" FROM Items
ORDER BY 1;

--Add in date/time 
--Sale Information
INSERT INTO InfoSales(sale_id, cust_id, "date", "time", item, quantity, price) VALUES
(1, 1, 03152023, '09:00:00', 1, 1, 4.50),
(2, 2, 03152023, '09:15:00', 1, 2, 2.00),
(3, 5, 03152023, '15:00:00', 2, 6, 1.50),
(4, 2, 03142023, '12:00:00', 1, 2, 2.00),
(5, 4, 03142023, '13:20:00', 4, 1, 2.00),
(6, 4, 03142023, '13:20:00', 10, 1, 2.00),
(7, 5, 03132023, '09:00:00', 13, 2, 0.10),
(8, 2, 03132023, '09:10:00', 13, 12, 4.00),
(9, 1, 03132023, '15:45:00', 17, 8, 0.75),
(10,1, 03122023, '11:00:00', 20, 1, 4.00),
(11,4, 03122023, '12:30:00', 19, 6, 1.00),
(12,2, 03122023, '13:30:00', 8, 1, 4.00),
(13,5, 03112023, '09:30:00', 7, 3, 2.00),
(14,2, 03112023, '10:00:00', 6, 3, 0.50),
(15,1, 03112023, '10:30:00', 5, 1, 2.00);

-- TODO: SQL queries

-- a) all customer names in alphabetical order

SELECT last_name, first_name FROM Customers
ORDER by 1;

-- b) number of items (labeled as total_items) in the database 

SELECT COUNT(*) AS total_items FROM Items;

-- c) number of customers (labeled as number_customers) by gender

SELECT gender, COUNT(*) AS number_customers FROM Customers
GROUP BY gender;

-- d) a list of all item codes (labeled as code) and descriptions (labeled as description) followed by their category descriptions (labeled as category) in numerical order of their codes (items that do not have a category should not be displayed)

SELECT A.item_code AS code, A."desc" AS "description", B."desc" AS category FROM Items A 
INNER JOIN Categories B
ON A.cat_code = B.cat_code
ORDER BY item_code;

-- e) a list of all item codes (labeled as code) and descriptions (labeled as description) in numerical order of their codes for the items that do not have a category

SELECT item_code AS code, "desc" as "description" FROM Items
WHERE cat_code IS NULL
ORDER BY item_code;

-- f) a list of the category descriptions (labeled as category) that do not have an item in alphabetical order

SELECT A."desc" AS category FROM Categories A
LEFT JOIN Items B
ON A.cat_code = B.cat_code
WHERE B.cat_code IS NULL
ORDER BY 1;

-- g) set a variable named "ID" and assign a valid customer id to it; then show the content of the variable using a select statement
\set ID 4

-- h) a list describing all items purchased by the customer identified by the variable "ID" (you must used the variable), showing, the date of the purchase (labeled as date), the time of the purchase (labeled as time and in hh:mm:ss format), the item's description (labeled as item), the quantity purchased (labeled as qtt), the item price (labeled as price), and the total amount paid (labeled as total_paid).

SELECT A.cust_id AS ID, A."date" AS date, A."time" AS time, B."desc" AS item, A.quantity AS qtt, A.price AS price, A.quantity * A.price AS total_paid FROM InfoSales A
INNER JOIN Items B
ON A.item = B.item_code
WHERE cust_id = :ID;

-- i) the total amount of sales per day showing the date and the total amount paid in chronological order

SELECT "date", COUNT(sale_id) AS total_sales, SUM(quantity * price) AS total FROM InfoSales
GROUP BY "date"
ORDER BY 1;

-- j) the description of the top item (labeled as item) in sales with the total sales amount (labeled as total_paid)

SELECT B."desc" AS item, A.price * A.quantity AS total_paid FROM InfoSales A
INNER JOIN Items B
ON A.item = B.item_code
ORDER BY total_paid DESC
LIMIT 1;

-- k) the descriptions of the top 3 items (labeled as item) in number of times they were purchased, showing that quantity as well (labeled as total)

SELECT B."desc" AS item, SUM(A.item) AS total  FROM InfoSales A
INNER JOIN Items B
ON A.item = B.item_code
GROUP BY B."desc"
ORDER BY 1
LIMIT 3;

-- l) the name of the customers who never made a purchase 

SELECT last_name, first_name FROM Customers A
LEFT JOIN InfoSales B
ON A.id = B.cust_id
WHERE B.cust_id IS NULL
ORDER BY 1;
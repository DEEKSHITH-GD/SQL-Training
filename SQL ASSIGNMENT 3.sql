CREATE DATABASE SQL_ASSIGNMENT_3;
USE SQL_ASSIGNMENT_3;

--a) Create a table "Product" with the following fields
CREATE TABLE Product ( Product_id INT PRIMARY KEY IDENTITY,
					   Product_code VARCHAR(10),
					   Product_Name VARCHAR(255),
					   Product_Desc VARCHAR(255),
					   Manufacturer VARCHAR(255),
					   Unit_Price DECIMAL(9,2),
					   Units_In_Stock INT );

--b) Create a table "Customer" with the following fields
CREATE TABLE Customer ( Customer_id  INT PRIMARY KEY IDENTITY,
						CustomerName VARCHAR(255),
						Address VARCHAR(255),
						ContactNumber VARCHAR(255),
						CompanyName VARCHAR(255) );

--c) Create a table "Orders" with the following fields
CREATE TABLE Orders ( Orders_id INT PRIMARY KEY IDENTITY,
					  Customer_id INT FOREIGN KEY REFERENCES Customer(Customer_id),
					  Product_id INT FOREIGN KEY REFERENCES Product(Product_id),
					  Units_Ordered INT,
					  Order_Date DateTime );

--d) Insert appropriate data to each of the table(Min 5 records)
INSERT INTO Product ( Product_code, Product_Name, Product_Desc, Manufacturer, Unit_Price, Units_In_Stock )
VALUES ( 'P001', 'Laptop', '15-inch display, 8GB RAM, 256GB SSD', 'TechCorp', 1200.00, 50),
       ( 'P002', 'Smartphone', '6-inch display, 4GB RAM, 64GB storage', 'MobileTech', 600.00, 150),
       ( 'P003', 'Tablet', '10-inch display, 3GB RAM, 32GB storage', 'TabInc', 300.00, 80),
       ( 'P004', 'Monitor', '24-inch display, Full HD', 'ScreenMakers', 150.00, 100),
       ( 'P005', 'Keyboard', 'Mechanical keyboard with RGB lighting', 'KeyPro', 70.00, 200);

INSERT INTO Customer ( CustomerName, Address, ContactNumber, CompanyName )
VALUES	( 'John Doe', '123 Elm Street', '1234567890', 'ABC Corp'),
		( 'Jane Smith', '456 Oak Avenue', '2345678901', 'XYZ Inc'),
		( 'Robert Brown', '789 Pine Road', '3456789012', 'LMN Ltd'),
		( 'Emily Davis', '101 Maple Boulevard', '4567890123', 'OPQ Enterprises'),
		( 'Michael Wilson', '202 Cedar Street', '5678901234', 'RST Solutions');

INSERT INTO Orders (Customer_id, Product_id, Units_Ordered, Order_Date)
VALUES (1, 1, 10, '2024-07-01 10:30:00'),
	   (2, 2, 5, '2024-07-02 11:00:00'),
       (3, 3, 2, '2024-07-03 12:00:00'),
       (1, 4, 7, '2024-07-04 13:00:00'),
       (2, 5, 1, '2024-07-05 14:30:00');
    
--e) Write queries for the following
--a. Select all product detailsSELECT * FROM Product;--b. Select all Products whose manufacturer is ‘Hindustan Lever Limited’SELECT * FROM Product WHERE Manufacturer = 'Hindustan Lever Limited';
--c. Select all orders done in last one month and display in the format : Product_Name, Customer_Name, Company_Name, Order_Date.SELECT p.Product_Name, c.CustomerName, c.CompanyName, o.Order_Date FROM ORDERS oJOIN Product p ON o.Product_id = P.Product_idJOIN Customer c ON o.Customer_id = c.Customer_idWHERE o.Order_Date >= DATEADD(MONTH, -1, GETDATE());--d. Select all customers who have ordered for more than 10 items and order by order count
SELECT c.*, SUM(o.Units_Ordered) AS Total_Units_Ordered FROM Customer c
JOIN Orders o ON c.Customer_id = o.Customer_id
GROUP BY c.Customer_id, c.CustomerName, c.Address, c.ContactNumber, c.CompanyName
HAVING SUM(o.Units_Ordered) > 10
ORDER BY Total_Units_Ordered DESC;

--e. Insert Product_Name, Customer_Name, Company_Name, Order_Date into another table
CREATE TABLE Table_for_insert ( Product_Name VARCHAR(255),
								CustomerName VARCHAR(255),
								CompanyName VARCHAR(255),
								Order_Date DateTime );

INSERT INTO Table_for_insert ( Product_Name, CustomerName, CompanyName, Order_Date )
SELECT p.Product_Name, c.CustomerName, c.CompanyName, O.Order_Date FROM Orders o
JOIN Product p ON o.Product_id = P.Product_idJOIN Customer c ON o.Customer_id = c.Customer_id;

--f. Find average Unit_Price for product of ‘Hindustan Lever Limited'
SELECT AVG(Unit_Price) AS [Average unit price] FROM Product
WHERE Manufacturer = 'Hindustan Lever Limited';

--g. Find the maximum and minimum Unit_Price for product of ‘Hindustan Lever Limited’
SELECT MAX(Unit_Price) AS [Max unit price], MIN(Unit_Price) AS [Min unit price] FROM Product
WHERE Manufacturer = 'Hindustan Lever Limited';

--h. Alter Table to add column Total_Price to Orders table
ALTER TABLE Orders
ADD Total_Price DECIMAL(9,2);

--i. Update Orders table to calculate the Total_Price
UPDATE Orders
SET Total_Price = ( SELECT o.Units_Ordered * p.Unit_Price FROM Product p
					WHERE o.Product_id = p.Product_id )
FROM Orders o;

--j. Alter Table to drop column Total_Price from Orders table
ALTER TABLE Orders
DROP COLUMN Total_Price;

--k. Delete records from Product table where Unit in stock is 0
DELETE FROM Product
WHERE Units_In_Stock = 0;

--l. Alter table to change CompanyName from varchar(255) to varchar(125)ALTER TABLE Customer
ALTER COLUMN CompanyName VARCHAR(125);

--m. Select all customers having a total order less than 5000 rupees and display in the format Customer_Name, Company_Name, Total_Order_Amount
SELECT c.CustomerName, c.CompanyName, o.Total_Price AS Total_Order_Amount FROM Customer c
JOIN Orders o ON c.Customer_id = o.Customer_id
WHERE o.Total_Price > 5000.00;

--n. Select all customers and display their total number of order. (Should display as 0 if a customer has not made any orders)
SELECT c.*, COALESCE(COUNT(o.Orders_id), 0) AS Total_Orders FROM Customer c
LEFT JOIN Orders o ON c.Customer_id = o.Customer_id
GROUP BY c.Customer_id, c.CustomerName, c.Address, c.ContactNumber, c.CompanyName
ORDER BY c.Customer_id;

--f) Write Stored procedures for the following
--a) Select all Product_Name, Customer_Name, Company_Name, Order_Date
CREATE PROCEDURE Select_all 
AS
SELECT p.Product_Name, c.CustomerName AS Customer_Name, c.CompanyName AS Company_Name, o.Order_Date FROM Orders o
JOIN Product p ON o.Product_id = p.Product_id
JOIN Customer c ON o.Customer_id = c.Customer_id;
GO

EXEC Select_all;

--b) Insert data to orders table. SP should except params @customerid, @productid, @unitsordered, @orderdate
CREATE PROCEDURE Insert_To_Orders @Customer_id INT,
								  @productid INT,
								  @Units_Ordered INT,
								  @Order_Date DateTime
AS
INSERT INTO Orders (Customer_id, Product_id, Units_Ordered, Order_Date)
VALUES (@Customer_id, @productid, @Units_Ordered, @Order_Date);
GO

EXEC Insert_To_Orders @Customer_id = 3,
					  @productid = 5,
					  @Units_Ordered = 2,
					  @Order_Date = '2024-07-12';

--c) Update data in product table. SP should except params @productid, , @unitsinstockCREATE PROCEDURE Update_Product @Product_id INT,
								@Units_In_Stock INT
AS
UPDATE Product
SET Units_In_Stock = @Units_In_Stock
WHERE Product_id = @Product_id;
GO

EXEC Update_Product @Product_id = '1',
					@Units_In_Stock = '1200';

--d) To update the unit_price of the product whose product_id is 1. If Unit_in_stock is greater than 1000, then decrease by 10% else 
--decrease by 5%(Use If Else statement in SP)
CREATE PROCEDURE UpdateProductPrice @Product_id INT
AS
DECLARE @CurrentUnitPrice DECIMAL(9,2);
DECLARE @UnitsInStock INT;

SELECT @CurrentUnitPrice = Unit_Price, @UnitsInStock = Units_In_Stock FROM Product
WHERE Product_id = @Product_id;

IF @UnitsInStock > 1000
	SET @CurrentUnitPrice = @CurrentUnitPrice * 0.90;
ELSE
	SET @CurrentUnitPrice = @CurrentUnitPrice * 0.95;

UPDATE Product
SET Unit_Price = @CurrentUnitPrice
WHERE Product_id = @Product_id;
GO

EXEC UpdateProductPrice @Product_id = 1;
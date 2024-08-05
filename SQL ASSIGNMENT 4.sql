CREATE DATABASE SQL_ASSIGNMENT_4;
USE SQL_ASSIGNMENT_4;

--a) Create a table "Vendor” with the following fields
CREATE TABLE Vendor ( VendorID INT NOT NULL PRIMARY KEY IDENTITY,
					  AccountNumber VARCHAR(15),
					  CompanyName VARCHAR(50) NOT NULL,
					  Location VARCHAR(50) NOT NULL,
					  CreditRating TINYINT NOT NULL,
					  ActiveFlag BIT,
					  PurchasingWebServiceURL VARCHAR(255) );

CREATE TABLE ProductInventory ( ProductInventoryID INT NOT NULL PRIMARY KEY IDENTITY,
								ProductID VARCHAR(15),
								ProductName VARCHAR(50) NOT NULL,
								Location VARCHAR(50) NOT NULL,
								Quantity INT,
								UnitPrice DECIMAL(9,2) );

CREATE TABLE Sales ( SalesID INT NOT NULL PRIMARY KEY IDENTITY,
					 ProductID INT FOREIGN KEY REFERENCES ProductInventory(ProductInventoryID),
					 VendorID INT FOREIGN KEY REFERENCES Vendor(VendorID),
					 SalesDate DATETIME,
					 Quatity INT );

--d) Insert appropriate data to each of the table(Min 10 records)
INSERT INTO Vendor ( AccountNumber, CompanyName, Location, CreditRating, ActiveFlag, PurchasingWebServiceURL)
VALUES ('ACC1234567890', 'TechCorp', 'New York', 4, 1, 'http://techcorp.com/service'),
       ('ACC1234567891', 'MobileTech', 'San Francisco', 3, 1, 'http://mobiletech.com/service'),
	   ('ACC1234567892', 'TabInc', 'Los Angeles', 5, 1, 'http://tabinc.com/service'),
	   ('ACC1234567893', 'ScreenMakers', 'Chicago', 2, 1, 'http://screenmakers.com/service'),
	   ('ACC1234567894', 'KeyPro', 'Houston', 3, 1, 'http://keypro.com/service'),
	   ('ACC1234567895', 'OfficeWorks', 'Philadelphia', 4, 1, 'http://officeworks.com/service'),
	   ('ACC1234567896', 'GadgetGear', 'Phoenix', 5, 1, 'http://gadgetgear.com/service'),
	   ('ACC1234567897', 'CompuWorld', 'San Diego', 2, 1, 'http://compuworld.com/service'),
	   ('ACC1234567898', 'PeripheralPros', 'Dallas', 4, 1, 'http://peripheralpros.com/service'),
	   ('ACC1234567899', 'TechGurus', 'San Jose', 3, 1, 'http://techgurus.com/service');

INSERT INTO ProductInventory (ProductID, ProductName, Location, Quantity, UnitPrice)
VALUES ('P001', 'Laptop', 'Warehouse A', 150, 1200.00),
       ('P002', 'Smartphone', 'Warehouse B', 300, 600.00),
	   ('P003', 'Tablet', 'Warehouse A', 200, 300.00),
	   ('P004', 'Monitor', 'Warehouse C', 100, 150.00),
	   ('P005', 'Keyboard', 'Warehouse B', 500, 70.00),
	   ('P006', 'Mouse', 'Warehouse C', 400, 25.00),
	   ('P007', 'Printer', 'Warehouse A', 50, 200.00),
	   ('P008', 'Scanner', 'Warehouse B', 75, 150.00),
	   ('P009', 'Webcam', 'Warehouse C', 120, 50.00),
	   ('P010', 'Headphones', 'Warehouse A', 250, 80.00);

INSERT INTO Sales (ProductID, VendorID, SalesDate, Quatity)
VALUES (1, 1, '2024-01-15 09:00:00', 10),
       (2, 2, '2024-01-16 10:30:00', 15),
	   (3, 3, '2024-01-17 11:00:00', 20),
	   (4, 4, '2024-01-18 12:00:00', 5),
	   (5, 5, '2024-01-19 14:00:00', 30),
	   (6, 6, '2024-01-20 15:30:00', 25),
	   (7, 7, '2024-01-21 16:00:00', 8),
	   (8, 8, '2024-01-22 09:30:00', 12),
	   (9, 9, '2024-01-23 10:00:00', 18),
	   (10, 10, '2024-01-24 11:30:00', 22);

--b. Select all Products from Inventory sold on 1-Sep-2011 by vendor ‘National Sales Corp’
SELECT * FROM ProductInventory p
JOIN Sales s ON p.ProductInventoryID = s.ProductID
JOIN Vendor v ON s.VendorID = v.VendorID
WHERE s.SalesDate = '2011-09-01 00:00:00' AND v.CompanyName = 'National Sales Corp';

--c. To get the count of products sold by vendor ‘International Merchandise’ in the month of Aug 2011.SELECT COUNT(*) AS Products_Sold FROM Sales s
JOIN Vendor v ON s.VendorID = v.VendorID
WHERE v.CompanyName = 'International Merchandise' AND s.SalesDate BETWEEN '2011-08-01 00:00:00' AND '2011-08-31 23:59:59';

--d. Select all vendor who have sold for more than the average sales quatity
WITH Sales_Quantity AS ( SELECT VendorID, SUM(Quatity) AS total_quantity FROM Sales 
						 GROUP BY VendorID ),
Average_quantity AS ( SELECT AVG(total_quantity) AS avg_quantity FROM Sales_Quantity )
SELECT v.* FROM Vendor v
JOIN Sales_Quantity s ON v.VendorID = s.VendorID
CROSS JOIN Average_quantity a
WHERE s.total_quantity > a.avg_quantity;

--e. Insert ProductName, CompanyName, SalesDate into another table
CREATE TABLE ProductSales ( ProductName VARCHAR(50),
							CompanyName VARCHAR(50),
							SalesDate DATETIME );

INSERT INTO ProductSales (ProductName, CompanyName, SalesDate)
SELECT p.ProductName, v.CompanyName, s.SalesDate FROM Sales s
JOIN ProductInventory p ON s.ProductID = p.ProductInventoryID
JOIN Vendor v ON s.VendorID = v.VendorID;

--f.f. Find average UnitPrice for products manufactured in ‘Mysore’(Location)SELECT AVG(UnitPrice) AS [Average Unit Price] FROM ProductInventory
WHERE Location = 'Mysore';
--g. Find the maximum and minimum products manufactured in ‘Mysore’(Location)SELECT MAX(UnitPrice) AS [Maximum Unit Price], MIN(UnitPrice) AS [Minimum Unit Price] FROM ProductInventory
WHERE Location = 'Mysore';

--h. Alter Table to add column Shipped (bit) to Sales table
ALTER TABLE Sales
ADD Shipped BIT;

--i. Update Sales table to set Shipped to true if sales date is lesser than today
UPDATE Sales
SET Shipped = 1
WHERE SalesDate < GETDATE();

--j. Delete records from Vendor where Vendor is no longer used.
DELETE FROM Vendor
WHERE NOT EXISTS (
    SELECT 1 FROM Sales
    WHERE Sales.VendorID = Vendor.VendorID
);

--k. Alter Table to drop column PurchasingWebServiceURL from Vendors table
ALTER TABLE Vendor
DROP COLUMN PurchasingWebServiceURL;

--l. Alter table to change Location from varchar(50) to varchar(255)
ALTER TABLE Vendor
ALTER COLUMN Location VARCHAR(255);

--m. Select all products whose vendor location is same as product manufacture location
SELECT p.* FROM ProductInventory p
JOIN Vendor v ON p.Location = v.Location;

--f) Write Stored procedures for the following 
--a) Select all ProductName, CompanyName, SalesDate and order by SalesDate to display more recent sales on top.CREATE PROCEDURE Sales_SP
AS
SELECT p.ProductName AS ProductName, v.CompanyName AS CompanyName, s.SalesDate AS SalesDate FROM Sales s
JOIN ProductInventory p ON s.ProductID = p.ProductInventoryID
JOIN Vendor v ON s.VendorID = v.VendorID
GROUP BY p.ProductName, v.CompanyName, s.SalesDate
ORDER BY s.SalesDate DESC;
GO

EXEC Sales_SP;

--b) Insert data to Sales table. SP should except params @vendorid, @productid, @quantity, @saledate
CREATE PROCEDURE Insert_into_sales @SalesID INT,
								   @ProductID INT,
								   @VendorID INT,
								   @SalesDate DATETIME,
								   @Quatity INT 
AS
INSERT INTO Sales (SalesID, ProductID, VendorID, SalesDate, Quatity)
VALUES (@SalesID, @ProductID, @VendorID, @SalesDate, @Quatity);
GO

EXEC Insert_into_sales @SalesID = 13,
					   @ProductID = 10,
					   @VendorID = 10,
					   @SalesDate = '2024-07-13 11:10:23',
					   @Quatity = 15; 

--c) Update data in ProductInventory. SP should except params @ProductInventoryID, @productid , @Quantity, @UnitPrice
CREATE PROCEDURE Update_pi @ProductInventoryID INT,
						   @ProductID VARCHAR(15),	
						   @Quantity INT,
						   @UnitPrice DECIMAL(9,2)
AS
UPDATE ProductInventory
SET ProductID = @ProductID,	
	Quantity = @Quantity,
	UnitPrice = @UnitPrice
WHERE ProductInventoryID = @ProductInventoryID
GO

EXEC Update_pi @ProductInventoryID = 10,
			   @ProductID = 'P00010',	
			   @Quantity = 25,
			   @UnitPrice = 999;

--d) To update the CreditRating of the Vendor who has max sales record for the month of Aug 2011. Use If else state to update record as follow 
--1 if sales Quatity is greater than 10000
--2 if sales Quatity is greater than 5000
--3 if sales Quatity is greater than 1000
--4 if sales Quatity is greater than 500
--5 if sales Quatity is less than 50

CREATE PROCEDURE Update_Vendor_CreditRating_For_MaxSales
AS
DECLARE @MaxSalesVendorID INT;
DECLARE @CreditRatingToUpdate INT;

SELECT TOP 1 @MaxSalesVendorID = s.VendorID FROM Sales s
WHERE MONTH(s.SalesDate) = 8 AND YEAR(s.SalesDate) = 2011
ORDER BY s.Quatity DESC;

SELECT @CreditRatingToUpdate = CASE
									WHEN SUM(s.Quatity) > 10000 THEN 1
									WHEN SUM(s.Quatity) > 5000 THEN 2
									WHEN SUM(s.Quatity) > 1000 THEN 3
									WHEN SUM(s.Quatity) > 500 THEN 4
									ELSE 5
							   END
FROM Sales s
WHERE s.VendorID = @MaxSalesVendorID AND MONTH(s.SalesDate) = 8 AND YEAR(s.SalesDate) = 2011;

UPDATE Vendor
SET CreditRating = @CreditRatingToUpdate
WHERE VendorID = @MaxSalesVendorID;

SELECT @MaxSalesVendorID AS VendorIDUpdated, @CreditRatingToUpdate AS NewCreditRating;

EXEC Update_Vendor_CreditRating_For_MaxSales;
CREATE DATABASE SQL_ASSIGNMENT_2;
USE SQL_ASSIGNMENT_2;

--a) Create a table "UserDetails" with the following fields
CREATE TABLE UserDetails ( UserId INT PRIMARY KEY IDENTITY,
						   username VARCHAR(255),
						   User_Type INT );

--b) Populate the table with the following data
INSERT INTO UserDetails ( username, User_Type )
				 VALUES ( 'Sam', 1 ),
						( 'Mac', 2 ),
						( 'David', 2 ),
						( 'John', 1 );

--c) Create a table "UserPersonalInfo" with the following fields
CREATE TABLE UserPersonalInfo ( UserPersonalInfoId INT PRIMARY KEY IDENTITY,
								UserId INT FOREIGN KEY REFERENCES UserDetails( UserId ),
								First_Name VARCHAR(255),
								Last_Name VARCHAR(255),
								Email_Id VARCHAR(255),
								DOB DATETIME,
								Address VARCHAR(MAX),
								City VARCHAR(MAX),
								State VARCHAR(MAX),
								Country VARCHAR(MAX),
								Salary	DECIMAL(18,2),
								DOJ VARCHAR(MAX) );

--d) Populate the table with the following data(all fields to be filled)
INSERT INTO UserPersonalInfo ( UserId, First_Name, Last_Name, Email_Id, DOB, Address, City, State, Country, Salary, DOJ )
VALUES ( 1, 'Sam', 'Samuel', 'sam@gmail.com', '1998-06-05 02:58:04', '25, x street', 'Bengaluru', 'Karnataka', 'Bharat', 756023.00, '09-06-2020' ),	   ( 2, 'Mac', 'Jason', 'mac@gmail.com', '1991-01-05 02:58:04', '5, x street', 'Bengaluru', 'Karnataka', 'Bharat', 956023.00, '09-02-2023' ),	   ( 3, 'David', 'Johnson', 'david@gmail.com', '1995-06-05 06:58:04', '1, x street', 'Bengaluru', 'Karnataka', 'Bharat', 906023.00, '02-01-2017' ),	   ( 4, 'John', 'Matthew', 'john@gmail.com', '2000-06-05 01:58:04', '1, y street', 'Bengaluru', 'Karnataka', 'Bharat', 356023.00, '02-01-2017' );--Fill the details appropriately and write queries for the following:--1. Select all admin users(i.e Select all user details whose User_type =1)
SELECT username AS Admin_Users FROM UserDetails WHERE User_type = 1;

--2. Update salary of users whose dateofjoining is greater than 1/1/2008UPDATE UserPersonalInfoSET Salary = 986404.00WHERE CAST(DOJ AS DATE) > '2008-01-01';--3. Insert UserPersonalInfo to another table.CREATE TABLE UserPersonalInfo_Duplicate ( UserPersonalInfoId INT PRIMARY KEY IDENTITY,
										  UserId INT FOREIGN KEY REFERENCES UserDetails( UserId ),
										  First_Name VARCHAR(255),
										  Last_Name VARCHAR(255),
										  Email_Id VARCHAR(255),
										  DOB DATETIME,
										  Address VARCHAR(MAX),
										  City VARCHAR(MAX),
										  State VARCHAR(MAX),
										  Country VARCHAR(MAX),
										  Salary	DECIMAL(18,2),
										  DOJ VARCHAR(MAX) );

INSERT INTO UserPersonalInfo_Duplicate ( UserId, First_Name, Last_Name, Email_Id, DOB, Address, City, State, Country, Salary, DOJ )
SELECT UserId, First_Name, Last_Name, Email_Id, DOB, Address, City, State, Country, Salary, DOJ FROM UserPersonalInfo;

--4. Select all the users where salary is greater than the maximum salary of user_type admin
WITH MaxSalary AS ( SELECT MAX(upi.Salary) AS max_salary FROM UserPersonalInfo upi
					JOIN UserDetails ud ON upi.UserId = ud.UserId
					WHERE ud.User_Type = 1 )
SELECT upi.* FROM UserPersonalInfo upi
WHERE upi.Salary > (SELECT max_salary FROM MaxSalary);

--5. find average salary of each user type and display records in the format User Type, Average Salary
SELECT ud.User_Type, AVG(upi.Salary) AS [Average Salary] FROM UserDetails ud
JOIN UserPersonalInfo upi ON UD.UserId = upi.UserId
GROUP BY ud.User_Type;

--6. Find the Max, min salary and display records in the format UserPersonalInfoId, firstname, lastname, salary
SELECT TOP 1 UserPersonalInfoId, First_Name, Last_Name, Salary AS Max_Salary FROM UserPersonalInfo
ORDER BY salary DESC;

SELECT TOP 1 UserPersonalInfoId, First_Name, Last_Name, Salary AS Min_Salary FROM UserPersonalInfo
ORDER BY salary ASC;

--7. Calculate DA (50% of salary), Professtional tax(5% of salary), Net Salary(salary + DA - Professtional tax
SELECT 0.5 * Salary AS DA, 0.05 * Salary AS [Professtional tax], Salary + (0.5 * Salary) - (0.05 * Salary) AS [Net Salary] FROM UserPersonalInfo;

--8. Alter table "UserDetails" to change the "username" from varchar(255) to varchar(50)
ALTER TABLE UserDetails
ALTER COLUMN username varchar(50);

--9. Alter table to add a column "Age" to the " serPersonalInfo" table
ALTER TABLE UserPersonalInfo
ADD Age INT;

--10. Alter table to add column user_status, Alter table to drop the column " user_status " to the " UserPersonalInfo" table
ALTER TABLE UserPersonalInfo
ADD user_status BIT;

--11. update UserPersonalInfo to calculate Age
UPDATE UserPersonalInfo
SET Age = DATEDIFF(YEAR, DOB, GETDATE());

--12. Delete records from " UserPersonalInfo " where user_status = 2DELETE FROM UserPersonalInfo
WHERE user_status = 2;

--Stored Procedures
--1. Write a Stored Procedure for the following--a. To get the details of the all the usersCREATE PROCEDURE All_Users 
AS
SELECT * FROM UserDetails
GO;

EXEC All_Users;--b. To get all the details of a userpersonal infoCREATE PROCEDURE All_Userpersonal_info
AS
SELECT * FROM UserPersonalInfo
GO;

EXEC All_Userpersonal_info;

--c. Adding a new user to the UserDetails table. The SP should accept parameters @UserName, @UserType
CREATE PROCEDURE Add_UserDetails @username VARCHAR(255),
								 @User_Type INT 
AS
INSERT INTO UserDetails ( username, User_Type )
				 VALUES ( @username, @User_Type )
GO

EXEC Add_UserDetails @username = 'Sham',
					 @User_Type = '2';

--d. Adding a new User Personnal Info. The SP should accept parameters relevant parameter and should return the id
CREATE PROCEDURE Add_User_Personnal_Info @UserId INT,
										 @First_Name VARCHAR(255),
										 @Last_Name VARCHAR(255),
										 @Email_Id VARCHAR(255),
										 @DOB DATETIME,
										 @Address VARCHAR(MAX),
										 @City VARCHAR(MAX),
										 @State VARCHAR(MAX),
										 @Country VARCHAR(MAX),
										 @Salary	DECIMAL(18,2),
										 @DOJ VARCHAR(MAX)
AS
INSERT INTO UserPersonalInfo ( UserId, First_Name, Last_Name, Email_Id, DOB, Address, City, State, Country, Salary, DOJ )
VALUES ( @UserId, @First_Name, @Last_Name, @Email_Id, @DOB, @Address, @City, @State, @Country, @Salary, @DOJ )

SELECT SCOPE_IDENTITY() AS UserPersonalInfoId;
GO

EXEC Add_User_Personnal_Info @UserId = '5',
							 @First_Name = 'Ramu',
							 @Last_Name = 'S',
							 @Email_Id = 'ramu@gmail.com',
							 @DOB = '2000-09-20',
							 @Address = 'xyz street',
							 @City = 'Mysore',
							 @State = 'Karnataka',
							 @Country = 'India',
							 @Salary = '476020.00',
							 @DOJ = '02-02-2022';

--e. Updating the User Personnal Info. The SP should accept parameters relevant parameter
CREATE PROCEDURE Update_User_Personnal_Info @UserPersonalInfoId INT,
											@UserId INT,
											@First_Name VARCHAR(255),
											@Last_Name VARCHAR(255),
											@Email_Id VARCHAR(255),
											@DOB DATETIME,
											@Address VARCHAR(MAX),
											@City VARCHAR(MAX),
											@State VARCHAR(MAX),
											@Country VARCHAR(MAX),
											@Salary	DECIMAL(18,2),											@DOJ VARCHAR(MAX)ASBEGIN
    UPDATE UserPersonalInfo
    SET UserId = @UserId,
		First_Name = @First_Name,
        Last_Name = @Last_Name,
        Email_Id = @Email_Id,
        DOB = @DOB,
        Address = @Address,
        City = @City,
        State = @State,
        Country = @Country,
        Salary = @Salary,
        DOJ = @DOJ
    WHERE UserPersonalInfoId = @UserPersonalInfoId;
END
GOEXEC Update_User_Personnal_Info @UserPersonalInfoId = '5',
								@UserId = '5',
								@First_Name = 'Pragna', 
					 			@Last_Name = 'S', 
								@Email_Id = 'pragna@gmail.com', 
								@DOB = '2001-06-24',
								@Address = 'something', 
								@City = 'Udupi', 
								@State = 'Karnataka', 
								@Country = 'India',
								@Salary = '600000.00', 
								@DOJ = '06-05-2021';
				
--f. To update the salary of User Personnal Info with UserPersonalInfoId is 1.condition for updating is 
-- - If work experience is greater than 3 year, then give a hike of 20%
-- - Else if less than 3 years, then give a hike of 10% (Use if – else statement)CREATE PROCEDURE Update_Salary @UserPersonalInfoId INT
AS
DECLARE @DOJ DATETIME;
DECLARE @currentSalary NUMERIC(10, 2);
DECLARE @newSalary NUMERIC(10, 2);
DECLARE @workExperience INT;
DECLARE @hikePercent FLOAT;

SELECT @DOJ = DOJ, @currentSalary = Salary FROM UserPersonalInfo
WHERE UserPersonalInfoId = @UserPersonalInfoId;

SET @workExperience = DATEDIFF(YEAR, @DOJ, GETDATE());

IF @workExperience > 3
	SET @hikePercent = 0.20;
ELSE
    SET @hikePercent = 0.10;

SET @newSalary = @currentSalary * (1 + @hikePercent);

UPDATE UserPersonalInfo
SET Salary = @newSalary
WHERE UserPersonalInfoId = @UserPersonalInfoId;
GO

EXEC Update_Salary @UserPersonalInfoId = 5;

--g. To display User Name , years of experience
CREATE PROCEDURE Emp_Exp @UserPersonalInfoId INT
AS
SELECT CONCAT_WS(' ', First_Name, Last_Name) AS [User Name], DATEDIFF(YEAR, DOJ, GETDATE()) AS [Years of Experience] FROM UserPersonalInfo
WHERE UserPersonalInfoId = @UserPersonalInfoId;
GO

EXEC Emp_Exp @UserPersonalInfoId = '4';
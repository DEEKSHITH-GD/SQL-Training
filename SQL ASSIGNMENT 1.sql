use SQL_Assignment1_13;

--a) Create a table "Department_Master" with the following fields
CREATE TABLE Department_Master ( department_id INT PRIMARY KEY IDENTITY, 
								 department_code VARCHAR(10), 
								 department_Name VARCHAR(255), 
								 department_Location VARCHAR(255), 
								 department_Status BIT);
--b) Populate the table with the following data
INSERT INTO Department_Master (department_code, department_Name, department_Location, department_Status) 
VALUES ('IT', 'Information Tech', 'Mysore ', 1),
	   ('MAR', 'Marketing', 'Mysore', 1),
	   ('HR', 'Human Resource', 'Mysore', 1),
	   ('DEV', 'Development', 'Mysore', 1);
--Create an Employee table "Employee_Details" with the following fields
CREATE TABLE Employee_Details ( staffid INT PRIMARY KEY IDENTITY,
								firstname VARCHAR(50),
								lastname VARCHAR(50),
								mailid VARCHAR(100),
								reportingto INT,
								department_code INT FOREIGN KEY REFERENCES Department_Master(department_id),
								phone VARCHAR(50),
								mobilenumber VARCHAR(50),
								employedcountry VARCHAR(50),
								dateofjoining DATETIME,
								city VARCHAR(50),
								salary NUMERIC(10,2) );
--Fill the details appropriately
INSERT INTO Employee_Details ( firstname, lastname, mailid, reportingto, department_code, phone, mobilenumber, employedcountry, dateofjoining, city, salary )
VALUES ( 'Abishek', 'Kumar', 'akumar@gmail.com', 1, 1, '1234567890', '2354652354', 'India', '2024-01-01 09:00:00', 'Bengaluru', 172452.00 ),
	   ( 'Arjun', 'Verma', 'averma@gmail.com', 1, 1, '8723764563', '9873625164', 'India', '2024-01-01 09:00:00', 'Bengaluru', 172452.00 ),
	   ( 'Nihir', 'A', 'nihir@gmail.com', 1, 1, '9826361736', '8736273645', 'India', '2024-01-01 09:00:00', 'Bengaluru', 172452.00 ),
	   ( 'Sohail', 'Z', 'sohail@gmail.com', 3, 2, '7686542876', '8976372637', 'India', '2024-01-01 09:00:00', 'Bengaluru', 172452.00 ),
	   ( 'Ravi', 'R', 'ravir@gmail.com', 3, 2, '1287362756', '8372638912', 'India', '2024-01-01 09:00:00', 'Bengaluru', 172452.00 );

--write queries for the following:
--1. Select employee details whose department_Name ='Marketing'
SELECT Employee_Details.* FROM Employee_Details
JOIN Department_Master ON Employee_Details.department_code = Department_Master.department_id
WHERE Department_Master.department_Name = 'Marketing';

--2. Update salary of employees whose dateofjoining is greater than 1/1/2008
UPDATE Employee_Details
SET salary = 472452.00
WHERE dateofjoining > '2008-01-01 00:00:00';

--3. Insert employee details to another table.
CREATE TABLE Employee_Details_duplicate ( staffid INT PRIMARY KEY IDENTITY,
										  firstname VARCHAR(50),
										  lastname VARCHAR(50),
										  mailid VARCHAR(100),
										  reportingto INT,
										  department_code INT FOREIGN KEY REFERENCES Department_Master(department_id),
										  phone VARCHAR(50),
										  mobilenumber VARCHAR(50),
										  employedcountry VARCHAR(50),
										  dateofjoining DATETIME,
										  city VARCHAR(50),
										  salary NUMERIC(10,2) );

INSERT INTO Employee_Details_duplicate ( firstname, lastname, mailid, reportingto, department_code, phone, mobilenumber, employedcountry, dateofjoining, city, salary )
SELECT firstname, lastname, mailid, reportingto, department_code, phone, mobilenumber, employedcountry, dateofjoining, city, salary FROM Employee_Details;

--4. Select all the employees where employee salary is greater than the maximum salary of department ‘Marketing’
WITH Emp_Max_Salary AS ( SELECT ed.*, MAX(ed.salary) OVER (PARTITION BY dm.department_Name) AS max_salary FROM Employee_Details ed
						 JOIN Department_Master dm ON ed.department_code = dm.department_id
						 WHERE dm.department_Name = 'Marketing' )
SELECT * FROM Emp_Max_Salary
WHERE salary > max_salary;

--5. find average salary of each department and display records in the format department_code, Department_Name, Average Salary
SELECT dept.department_code AS department_code, dept.department_Name AS Department_Name, AVG(emp.salary) AS [Average Salary] FROM Department_Master dept
JOIN Employee_Details emp ON dept.department_id = emp.department_code
GROUP BY dept.department_code, dept.department_Name;

--6. Find the Max, min salary and display records in the format staffid, firstname, lastname, salary
SELECT TOP 1 emp.staffid, emp.firstname, emp.lastname, emp.salary AS Max_Salary FROM Employee_Details emp
ORDER BY emp.salary DESC;

SELECT TOP 1 emp.staffid, emp.firstname, emp.lastname, emp.salary AS Min_Salary FROM Employee_Details emp
ORDER BY emp.salary ASC;

--7. Calculate DA (50% of salary), Professtional tax(5% of salary), Net Salary(salary + DA - Professtional tax)
SELECT 0.5 * emp.salary AS DA, 0.05 * emp.salary AS [Professtional tax], emp.salary + (0.5 * emp.salary) - (0.05 * emp.salary) AS [Net Salary] FROM Employee_Details emp;

--8. Select departments having more than 2 employees
SELECT dept.department_Name FROM Department_Master dept
JOIN Employee_Details emp ON dept.department_id = emp.department_code
GROUP BY dept.department_Name
HAVING COUNT(emp.department_code) > 2;

--9. Alter table "Department_Master" to change the "department_Name" from varchar(20) to varchar(40)
ALTER TABLE Department_Master
ALTER COLUMN department_Name varchar(40);

--10. Alter table to add a column "Department_Manager" to the "Department_Master" table
ALTER TABLE Department_Master
ADD Department_Manager varchar(40);

--11. Alter table to drop the column "Department_Manager" FROM the "Department_Master" tableALTER TABLE Department_Master
DROP COLUMN Department_Manager;

--12. update employee set salary = salary + 1000 when dateofjoining is between '1/1/2005' to '1/1/2010'
UPDATE Employee_Details
SET salary = salary + 1000
WHERE dateofjoining BETWEEN '2005-01-01 00:00:00' AND '2010-01-01 00:00:00'

--13. Delete records from "Department_Master" where department_Status = 2
DELETE FROM Department_Master
WHERE department_Status = 2;

--14. Display employee name and his/her manager name.UPDATE Department_MasterSET Department_Manager = 'Ramesh'WHERE department_code = 'IT';UPDATE Department_MasterSET Department_Manager = 'Megha'WHERE department_code = 'MAR';UPDATE Department_MasterSET Department_Manager = 'Raj'WHERE department_code = 'HR';UPDATE Department_MasterSET Department_Manager = 'Surya'WHERE department_code = 'DEV';SELECT CONCAT_WS(' ', emp.firstname, emp.lastname) AS [Employee Name], dept.Department_Manager AS Manager FROM Employee_Details empJOIN Department_Master dept ON emp.department_code = dept.department_id;--15. Select all employee whose city is same as department_LocationSELECT CONCAT_WS(' ', emp.firstname, emp.lastname) AS [Employee Name] FROM Employee_Details empJOIN Department_Master dept ON emp.department_code = dept.department_idWHERE emp.city = dept.department_Location;--Write a Stored Procedure for the following
--a. To get the details of the all the employees
CREATE PROCEDURE Get_All_Employees 
AS
SELECT * FROM Employee_Details
GO;

EXEC Get_All_Employees;

--b. To get all the details of a department
CREATE PROCEDURE Get_A_Dept_Details @department_code VARCHAR(10)
AS
SELECT * FROM Department_Master WHERE Department_Master.department_code = @department_code
GO

EXEC Get_A_Dept_Details @department_code = 'MAR';

--c. Adding a new Department to the Department_Master table. The SP should accept parameters @DeptCode, @DeptName, @DeptLocation and @Status.
CREATE PROCEDURE Add_Dept @department_code VARCHAR(10), 
						  @department_Name VARCHAR(255), 
						  @department_Location VARCHAR(255), 
						  @department_Status BIT 
AS
INSERT INTO Department_Master (department_code, department_Name, department_Location, department_Status)
VALUES (@department_code, @department_Name, @department_Location, @department_Status)
GO

EXEC Add_Dept @department_code = 'SUP', 
			  @department_Name = 'SUPPORT', 
			  @department_Location = 'MYSORE', 
			  @department_Status = '1';

--d. Adding a new Employee. The SP should accept parameters @firstname, @lastname, @mailed, @reportingto, @department_code, @phone, @mobilenumber,
--@ employedcountry, @dateofjoining,@city,@salary. The Sp should return The Employee ID (staffed)
CREATE PROCEDURE Add_Emp @firstname VARCHAR(50),
						 @lastname VARCHAR(50),
						 @mailid VARCHAR(100),
						 @reportingto INT,
						 @department_code INT,
						 @phone VARCHAR(50),
						 @mobilenumber VARCHAR(50),
						 @employedcountry VARCHAR(50),
						 @dateofjoining DATETIME,
						 @city VARCHAR(50),
						 @salary NUMERIC(10,2) 
AS
INSERT INTO Employee_Details ( firstname, lastname, mailid, reportingto, department_code, phone, mobilenumber, employedcountry, dateofjoining, city, salary )
VALUES ( @firstname, @lastname, @mailid, @reportingto, @department_code, @phone, @mobilenumber, @employedcountry, @dateofjoining, @city, @salary )
GO

EXEC Add_Emp @firstname = 'Prithiv', 
			 @lastname = 'Chouhan', 
			 @mailid = 'prithiv@gmail.com', 
			 @reportingto = 1,
			 @department_code = 4, 
			 @phone = '9876567456', 
			 @mobilenumber = '9988675427', 
			 @employedcountry = 'INDIA',
			 @dateofjoining = '2006-03-01 08:03:03', 
			 @city = 'MYSORE', 
			 @salary = 546600.00;

--e. Updating the Employee details. The SP should accept parameters @staffid, @firstname, @lastname, @mailed, @reportingto, @department_code, 
--@phone, @mobilenumber, @employedcountry, @dateofjoining, @city, @salary
CREATE PROCEDURE Update_Emp @staffid INT,
							@firstname VARCHAR(50),
						    @lastname VARCHAR(50),
							@mailid VARCHAR(100),
							@reportingto INT,
							@department_code INT,
							@phone VARCHAR(50),
							@mobilenumber VARCHAR(50),
							@employedcountry VARCHAR(50),
							@dateofjoining DATETIME,
							@city VARCHAR(50),
							@salary NUMERIC(10,2) ASBEGIN
    UPDATE Employee_Details
    SET firstname = @firstname,
        lastname = @lastname,
        mailid = @mailid,
        reportingto = @reportingto,
        department_code = @department_code,
        phone = @phone,
        mobilenumber = @mobilenumber,
        employedcountry = @employedcountry,
        dateofjoining = @dateofjoining,
        city = @city,
        salary = @salary
    WHERE staffid = @staffid;
END
GOEXEC Update_Emp @staffid = '12',
				@firstname = 'Praveen', 
				@lastname = 'K', 
				@mailid = 'Praveen@gmail.com', 
				@reportingto = 1,
				@department_code = 4, 
				@phone = '9876554456', 
				@mobilenumber = '9989875427', 
				@employedcountry = 'India',
				@dateofjoining = '2006-03-01 08:03:03', 
				@city = 'Mysore', 
				@salary = 546600.00;

--To update the salary of employee with starffid 1.condition for updating is - If work experience is greater than 3 year, then give a hike of 20%
-- - Else if less than 3 years, then give a hike of 10% (Use if – else statement)
CREATE PROCEDURE Update_Salary @staffid INT
AS
DECLARE @dateofjoining DATETIME;
DECLARE @currentSalary NUMERIC(10, 2);
DECLARE @newSalary NUMERIC(10, 2);
DECLARE @workExperience INT;
DECLARE @hikePercent FLOAT;

SELECT @dateofjoining = dateofjoining, @currentSalary = salary FROM Employee_Details
WHERE staffid = @staffid;

SET @workExperience = DATEDIFF(YEAR, @dateofjoining, GETDATE());

IF @workExperience > 3
	SET @hikePercent = 0.20;
ELSE
    SET @hikePercent = 0.10;

SET @newSalary = @currentSalary * (1 + @hikePercent);

UPDATE Employee_Details
SET salary = @newSalary
WHERE staffid = @staffid;
GO

EXEC Update_Salary @staffid = 11;

--g. To display Employee Name , years of experience
CREATE PROCEDURE Emp_Exp @staffid INT
AS
SELECT CONCAT_WS(' ', firstname, lastname) AS [Employee Name], DATEDIFF(YEAR, dateofjoining, GETDATE()) AS [Years of Experience] FROM Employee_Details
WHERE staffid = @staffid;
GO

EXEC Emp_Exp @staffid = '10';

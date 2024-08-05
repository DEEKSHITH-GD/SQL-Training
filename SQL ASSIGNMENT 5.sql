CREATE DATABASE SQL_ASSIGNMENT_5;
USE SQL_ASSIGNMENT_5;

CREATE TABLE Manufacturers ( maname VARCHAR(30) PRIMARY KEY, 
							 location VARCHAR(50) );

INSERT INTO Manufacturers (maname, location) 
VALUES ('Ford', 'USA'),
	   ('Toyota', 'Japan'),
	   ('Honda', 'Japan'),
	   ('Chevrolet', 'USA'),
	   ('BMW', 'Germany');

CREATE TABLE Models (mid INT PRIMARY KEY IDENTITY, 
					 maname VARCHAR(30) FOREIGN KEY REFERENCES Manufacturers(maname), 
					 model VARCHAR(40) );

INSERT INTO Models (maname, model) 
VALUES ('Ford', 'Mustang'),
	   ('Toyota', 'Corolla'),
	   ('Honda', 'Civic'),
	   ('Chevrolet', 'Camaro'),
	   ('BMW', 'X5');

CREATE TABLE Cars ( cid INT PRIMARY KEY IDENTITY, 
					mid INT FOREIGN KEY REFERENCES Models(mid),
					cyear DATE );
					
INSERT INTO Cars (mid, cyear) 
VALUES (1, '2010-01-01'),
	   (2, '2012-01-01'),
	   (3, '2015-01-01'),
	   (4, '2018-01-01'),
	   (5, '2020-01-01');

CREATE TABLE Buyers (bid INT PRIMARY KEY IDENTITY,
					 bname VARCHAR(25),
					 bcity VARCHAR(30),
					 age TINYINT);

INSERT INTO Buyers (bname, bcity, age) 
VALUES ('John Doe', 'New York', 30),
	   ('Jane Smith', 'Los Angeles', 25),
	   ('Michael Brown', 'Chicago', 35),
	   ('Emily Davis', 'Houston', 28),
	   ('David Wilson', 'Phoenix', 40);

CREATE TABLE SalesPeople ( s_id INT PRIMARY KEY IDENTITY, 
						   sname VARCHAR(30), 
						   years_employed DATE);

INSERT INTO SalesPeople (sname, years_employed) 
VALUES ('Alice Johnson', '2012-01-01'),
	   ('Bob Martin', '2010-01-01'),
	   ('Charlie Lee', '2015-01-01'),
	   ('Diana Harris', '2018-01-01'),
	   ('Ethan Clark', '2005-01-01');

CREATE TABLE Transactions ( bid INT FOREIGN KEY REFERENCES Buyers(bid), 
						    cid INT FOREIGN KEY REFERENCES Cars(cid), 
						    s_id INT FOREIGN KEY REFERENCES SalesPeople(s_id), 
						    amount DECIMAL(9,2), 
						    month DATE, 
						    day DATE, 
						    year DATE );

INSERT INTO Transactions (bid, cid, s_id, amount, month, day, year) 
VALUES (1, 1, 1, 9500.00, '1997-01-01', '1997-01-01', '1997-01-01'),
	   (2, 2, 2, 20000.00, '1997-02-01', '1997-02-01', '1997-02-01'),
	   (3, 3, 3, 30000.00, '1997-03-01', '1997-03-01', '1997-03-01'),
	   (4, 4, 4, 15000.00, '1997-04-01', '1997-04-01', '1997-04-01'),
	   (5, 5, 5, 12000.00, '1997-05-01', '1997-05-01', '1997-05-01');


INSERT INTO Transactions (bid, cid, s_id, amount, month, day, year) 
VALUES (1, 1, 5, 9500.00, '1998-01-01', '1998-01-01', '1998-01-01'),
	   (2, 2, 5, 20000.00, '1999-02-01', '1999-02-01', '1999-02-01'),
	   (3, 3, 5, 30000.00, '2000-03-01', '2000-03-01', '2000-03-01'),
	   (4, 4, 5, 15000.00, '2001-04-01', '2001-04-01', '2001-04-01'),
	   (5, 5, 5, 12000.00, '2002-05-01', '2002-05-01', '2002-05-01');

--Express the following queries using SQL. The SQL queries should not return duplicates.
--1. Print the bname and bcity of all buyers who have purchased a Ford Mustang for an amount less than $10,000. 
--(Note: Ford is the manufacturer, Mustang is the model.)

SELECT b.bname, b.bcity FROM Buyers b
JOIN Transactions t ON b.bid = t.bid
JOIN Cars c ON t.cid = c.cid
JOIN Models M ON c.mid = m.mid
WHERE t.amount < 10000.00 AND m.maname = 'Ford' AND m.model= 'Mustang';

--2. Print the sid of all salespeople who have sold both a Ford and a Toyota in 1997.
SELECT s.s_id AS sid, s.sname AS [Sale's Person Name] FROM SalesPeople s
JOIN Transactions t ON s.s_id = t.s_id
JOIN Cars c ON t.cid = c.cid
JOIN Models m ON c.mid = m.mid
WHERE YEAR(t.year) = 1997 AND (m.maname = 'Ford' OR m.maname = 'Toyota');

--3. Print the sid of all salespeople who have sold at least one car of every manufacturer.
SELECT s.s_id AS sid, s.sname AS [Sale's Person Name]  FROM SalesPeople s
JOIN Transactions t ON s.s_id = t.s_id
JOIN Cars c ON t.cid = c.cid
JOIN Models m ON c.mid = m.mid
JOIN Manufacturers ma ON m.maname = ma.maname
GROUP BY s.s_id, s.sname
HAVING COUNT(DISTINCT ma.maname) = (SELECT COUNT(*) FROM Manufacturers);

--4. Print the sname(s) of all sales people who did not sell any cars in 1997.
SELECT s.sname FROM SalesPeople s
WHERE NOT EXISTS ( SELECT 1 FROM Transactions t
				   WHERE t.s_id = s.s_id AND YEAR(t.year) = 1997 );

--5. Print the sname and total sales amount of the salesperson who had the highest total sales (in dollars) for 1997.
SELECT TOP 1 s.sname, SUM(t.amount) AS [total sales amount]  FROM SalesPeople s
JOIN Transactions t ON s.s_id = t.s_id
WHERE YEAR(t.year) = 1997
GROUP BY t.s_id, s.sname
ORDER BY SUM(t.amount) DESC

--6. Print the sname, and average amount per transaction (i.e., average sales amount) for every salesperson who has been working less than 10 years,
--and who has sold at least 50 cars. Print the result in descending order of the average sales amount.
SELECT s.sname, AVG(t.amount) AS [Average Amount] FROM SalesPeople s
JOIN Transactions t ON s.s_id = t.s_id
WHERE DATEDIFF(YEAR, YEAR(s.years_employed), GETDATE()) <10
GROUP BY s.s_id, s.sname
HAVING COUNT(t.cid) >=50
ORDER BY AVG(t.amount) DESC

--Assignment 2:
--Given the following Schema, answer the following querries:
CREATE TABLE employee (fname VARCHAR(30), 
					   mname VARCHAR(30),
					   lname VARCHAR(30), 
					   ssn INT PRIMARY KEY IDENTITY, 
					   bdate DATETIME, 
					   address VARCHAR(200), 
					   sex VARCHAR(20), 
					   salary DECIMAL(9,2), 
					   superssn INT UNIQUE NOT NULL, 
					   dno INT FOREIGN KEY REFERENCES department(dnumber) );

INSERT INTO employee (fname, mname, lname, bdate, address, sex, salary, superssn, dno)
VALUES ('John', 'A', 'Doe', '1985-02-15', '123 Main St, Anytown, NY', 'Male', 60000.00, 10, 2),
	   ('Jane', 'B', 'Smith', '1979-09-12', '456 Elm St, Anycity, CA', 'Female', 75000.00, 11, 1),
	   ('Michael', 'C', 'David', '1990-04-25', '789 Oak St, Anystate, TX', 'Male', 55000.00, 12, 3),
	   ('Emily', 'D', 'Ann', '1988-07-04', '321 Pine St, Anyvillage, FL', 'Female', 65000.00, 13, 3),
	   ('Robert', 'J', 'Lee', '1983-11-30', '654 Birch St, Anymetropolis, WA', 'Male', 70000.00, 14, 4),
	   ('Jessica', 'R', 'Marie', '1987-03-20', '987 Cedar St, Anymountain, CO', 'Female', 68000.00, 15, 2),
	   ('David', 'S', 'James', '1982-06-10', '234 Spruce St, Anyborough, MA', 'Male', 72000.00, 16, 1);

CREATE TABLE department ( dname VARCHAR(40), 
						  dnumber INT PRIMARY KEY IDENTITY,
						  mgrssn INT UNIQUE NOT NULL, 
						  mgrstartdate DATETIME );

INSERT INTO department (dname, mgrssn, mgrstartdate)
VALUES ('Research', 20, '2005-01-01'),
	   ('Sales', 21, '2006-02-15'),
	   ('Marketing', 23, '2007-03-20'),
	   ('HR', 24, '2008-04-25');


CREATE TABLE dept_locations ( dnumber INT FOREIGN KEY REFERENCES department(dnumber), 
							  dlocation VARCHAR(30) );

INSERT INTO dept_locations (dnumber, dlocation)
VALUES (1, 'New York'),
	   (2, 'Los Angeles'),
	   (3, 'Chicago'),
	   (4, 'Houston');

CREATE TABLE project ( pname VARCHAR(30), 
					   pnumber INT PRIMARY KEY IDENTITY,  
					   plocation VARCHAR(30), 
					   dnum INT FOREIGN KEY REFERENCES department(dnumber) );

INSERT INTO project (pname, plocation, dnum)
VALUES ('Project A', 'Stafford', 1),
	   ('Project B', 'Houston', 4),
	   ('Project C', 'Los Angeles', 2),
	   ('Project D', 'Chicago', 3);

CREATE TABLE works_on ( essn INT FOREIGN KEY REFERENCES employee(ssn), 
						pno INT FOREIGN KEY REFERENCES project(pnumber), 
						no_of_hours INT );

INSERT INTO works_on (essn, pno, no_of_hours)
VALUES (7, 3, 40),
	   (8, 4, 35),
	   (9, 5, 30),
	   (10, 6, 25),
	   (11, 3, 25),
	   (12, 4, 15);
						
CREATE TABLE dependents ( essn INT FOREIGN KEY REFERENCES employee(ssn), 
						  dependent_name VARCHAR(30), 
						  sex VARCHAR(15), 
						  bdate DATETIME, 
						  relationship VARCHAR(20) );

INSERT INTO dependents (essn, dependent_name, sex, bdate, relationship)
VALUES (7, 'Sarah Doe', 'Female', '2010-03-01', 'Daughter'),
	   (10, 'Tom Smith', 'Male', '2008-07-15', 'Son'),
	   (11, 'Mary Doe', 'Female', '2012-11-20', 'Daughter');

--1. Retrieve the name and address of all employees who work for the 
--a. 'Research' department.
SELECT CONCAT_WS(' ', e.fname, e.mname, e.lname) AS [Employee Name], e.address FROM employee e
JOIN department d ON e.dno = d.dnumber
WHERE d.dname = 'Research';

--2. For every project located in 'Stafford', list the project number, the
--a. controlling department number, and the department manager's last name,
--b. address, and birthdate

SELECT p.pnumber, d.dnumber, e.lname, e.address, e.bdate AS birthday FROM employee e
JOIN project p ON e.dno = p.dnum
JOIN department d ON p.dnum = d.dnumber
WHERE p.plocation = 'Stafford';
 
--3. Find the names of employees who work on all the projects controlled
--a. by department number 5.
SELECT CONCAT_WS(' ', e.fname, e.mname, e.lname) AS [Employee Name] FROM employee e
JOIN project p ON e.dno = p.dnum
WHERE p.dnum = 5;

--4. Make a list of project numbers for projects that involve an employee
--a. whose last name is 'Smith', either as a worker or as a manager of the
--b. department that controls the project.
SELECT w.pno FROM works_on w
JOIN employee e ON w.essn = e.ssn
WHERE e.lname = 'Smith';

--5. List the names of all employees with two or more dependents.
SELECT CONCAT_WS(' ', e.fname, e.mname, e.lname) AS [Employee Name] FROM employee e
JOIN dependents d ON e.ssn = d.essn
GROUP BY e.fname, e.mname, e.lname
HAVING COUNT(d.essn) >= 2;

--6. Retrieve the names of employees who have no dependents.
SELECT CONCAT_WS(' ', e.fname, e.mname, e.lname) AS [Employee Name] FROM employee e
WHERE NOT EXISTS ( SELECT TOP 1 d.* FROM dependents d
				   WHERE d.essn = e.ssn);

--Assignment 3:
--In this assignment, you’ll have to come up with SQL queries for the following database schema:
CREATE TABLE Artists ( artistID INT PRIMARY KEY IDENTITY, 
					   name VARCHAR(255) );

INSERT INTO Artists (name) 
VALUES ('Mogwai'), 
	   ('Nirvana'), 
	   ('Radiohead'), 
	   ('The Beatles'), 
	   ('Pink Floyd');

CREATE TABLE SimilarArtists ( artistID INT FOREIGN KEY REFERENCES Artists(artistID), 
							  simArtistID INT PRIMARY KEY IDENTITY, 
							  weight INT );

INSERT INTO SimilarArtists (artistID, weight) 
VALUES (1, 60), 
       (1, 58), 
	   (2, 75), 
	   (3, 69), 
	   (4, 68), 
	   (3, 78);

CREATE TABLE Albums ( albumID INT PRIMARY KEY IDENTITY, 
					  artistID INT FOREIGN KEY REFERENCES Artists(artistID), 
					  name VARCHAR(255) );

INSERT INTO Albums (artistID, name) 
VALUES (1, 'Mogwai'), 
	   (2, 'Nevermind'), 
	   (3, 'OK Computer'), 
	   (4, 'Abbey Road'), 
	   (5, 'The Wall'); 


CREATE TABLE Tracks ( trackID INT PRIMARY KEY IDENTITY, 
					  artistID INT FOREIGN KEY REFERENCES Artists(artistID), 
					  name VARCHAR(255), 
					  length INT);

INSERT INTO Tracks (artistID, name, length) 
VALUES (1, 'Intro', 300000),
	   (2, 'Smells Like Teen Spirit', 301000),
	   (3, 'Paranoid Android', 620000),
	   (4, 'Come Together', 240000),
	   (5, 'Comfortably Numb', 380000);


CREATE TABLE TrackLists ( albumID INT FOREIGN KEY REFERENCES Albums(albumID), 
						  trackID INT FOREIGN KEY REFERENCES Tracks(trackID), 
						  trackNum INT);

INSERT INTO TrackLists (albumID, trackID, trackNum) 
VALUES (1, 1, 1),
	   (2, 2, 1),
	   (3, 3, 1),
	   (4, 4, 1),
	   (5, 5, 1);

--1. Find the names of all Tracks that are more than 10 minutes (600,000 ms) long.
SELECT name FROM Tracks
WHERE length > 600000;

--2. Find the names of all Artists who have recorded a self-titled Album (the name of the Album is the same as the 
--name of the Artist).
SELECT a.name FROM Artists a
JOIN Albums alb ON a.artistID = alb.artistID
WHERE a.name = alb.name;

--3. Find the names of all Artists who have recorded an Album on which the first track is named “Intro”.
SELECT a.name FROM Artists a
JOIN Tracks t ON a.artistID = t.artistID
WHERE t.name = 'Intro';

select * from Tracks;

--4. Find the names of all Artists who are more similar to Mogwai than to Nirvana (meaning the weight of their 
--similarity to Mogwai is greater).
WITH MogwaiSimilarity AS ( SELECT simArtistID, weight FROM SimilarArtists
						   WHERE artistID = (SELECT artistID FROM Artists WHERE name = 'Mogwai') ),
						   
NirvanaSimilarity AS ( SELECT simArtistID, weight FROM SimilarArtists
					   WHERE artistID = (SELECT artistID FROM Artists WHERE name = 'Nirvana') )

SELECT a.name FROM Artists a
JOIN MogwaiSimilarity ms ON a.artistID = ms.simArtistID
JOIN NirvanaSimilarity ns ON a.artistID = ns.simArtistID
WHERE ms.weight > ns.weight;

--5. Find the names of all Albums that have more than 30 tracks.
SELECT a.name AS [Album Name] FROM Albums a
JOIN Tracks t ON a.artistID = t.artistID
GROUP BY a.name
HAVING COUNT(DISTINCT t.name) > 3;

--6. Find the names of all Artists who do not have a similarity rating greater than 5 to any other Artist.
SELECT a.name FROM Artists a
LEFT JOIN SimilarArtists sa ON a.artistID = sa.artistID
GROUP BY a.artistID, a.name
HAVING MAX(COALESCE(sa.weight, 0)) <= 5;
select * from SimilarArtists;

--7. For all Albums, list the Album’s name and the name of its 15th Track. If the Album does not have a 15th Track,
--list the Track name as null.
SELECT a.name AS [Album Name], t.name AS [15th Track Name] FROM Albums a
LEFT JOIN ( SELECT tl.albumID, t.name FROM TrackLists tl
			JOIN Tracks t ON tl.trackID = t.trackID
			WHERE tl.trackNum = 15 ) t ON a.albumID = t.albumID;

select * from TrackLists;
select * from Tracks;

--8. List the name of each Artist, along with the name and average Track length of their Album that has the highest 
--average Track length.
WITH Album_Average_Length AS ( SELECT al.artistID, al.albumID, al.name AS AlbumName, AVG(t.length) AS AvgTrackLength FROM Albums al
							   JOIN TrackLists tl ON al.albumID = tl.albumID
							   JOIN Tracks t ON tl.trackID = t.trackID
							   GROUP BY al.artistID, al.albumID, al.name ),

Max_Average_Length AS ( SELECT artistID, MAX(AvgTrackLength) AS MaxAvgTrackLength FROM Album_Average_Length
					    GROUP BY artistID )

SELECT a.name AS [Artist Name], al.AlbumName AS [Album Name], al.AvgTrackLength AS [Average Track Length] FROM Max_Average_Length mal
JOIN Album_Average_Length al ON mal.artistID = al.artistID AND mal.MaxAvgTrackLength = al.AvgTrackLength
JOIN Artists a ON a.artistID = al.artistID
ORDER BY al.AvgTrackLength DESC;

--9. For all Artists that have released a Track with a name beginning with “The”, give their name and the name of 
--the Artist who is most similar to them that has released a Track with a name beginning with “Why”. If there is a 
--tie, choose the Artist with the lowest artistID. If there are no qualifying Artists, list the Artist name as null.
WITH Get_tracks AS ( SELECT t.name AS track_name, a.name AS artist_name, sa.weight FROM Tracks t
					 JOIN Artists a ON t.artistID = a.artistID
					 JOIN SimilarArtists sa ON a.artistID = sa.artistID )

SELECT gt1.track_name AS ['The' Track Name], gt1.artist_name AS [Artist Name], gt2.track_name AS ['Why' Track Name], gt2.artist_name AS [Similar Artist Name]
FROM ( SELECT gt.track_name, gt.artist_name, gt.weight FROM Get_tracks gt
	   WHERE gt.track_name LIKE 'The%') gt1
LEFT JOIN ( SELECT gt.track_name, gt.artist_name, gt.weight FROM Get_tracks gt
			WHERE gt.track_name LIKE 'Why%') gt2
ON gt1.weight = gt2.weight
ORDER BY gt1.weight ASC;
















--10. If an Artist is within one degree of Hot Water Music, that means that their similarity to Hot Water Music is at least 5. 
--If an Artist is within N degrees of Hot Water Music, then they have a similarity of at least 5 to an Artist that is within N-1 degrees of 
--Hot Water Music. Find the percent of all Artists that are within 6 (or fewer) degrees of Hot Water Music.(Your answer should also include 
--Hot Water Music themselves! Also, note that the percentage should be an integer between 0 and 100, inclusive.


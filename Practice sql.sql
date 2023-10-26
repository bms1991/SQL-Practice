/*SQL*/
/*SQL queries are mainly divided into 5 categories
  1) Data Definition Language:Create,Drop,Alter,Truncate
  2) Data Query Language: Select
  3) Data Manipulation Language:Insert,Update,Delete,Call,Explain Call,Lock
  4) Data Control Language: Grant,Revoke
  5) Transaction Control Language: Commit,Savepoint,Rollback,Set Transaction,Set Constraint*/
  
/* Creating new Database */
CREATE database PERSON;
/*Using the above database*/
USE PERSON; 
/*Creating new Table*/
CREATE TABLE Persons (
 PersonID int,
 LastName varchar(255),
FirstName varchar(255),
 Address varchar(255),
 City varchar(255) 
);
/*Inserting new Values into Table Persons*/
INSERT INTO Persons (PersonID, LastName, FirstName, Address,
City)
VALUES (24, 'Cruise', 'Tom', 'Distric 76', 'Beverly Hills'),
	   (32,'Evans','Chris','106th street','San Diego'),
       (43,'Johansson','Scarlett','33rd block','Los Angeles'),
       (55,'Stone','Emma','89th Main street','London'),
       (76,'Lopez','Jennifer','Block 36','Los Angeles'),
       (99,'Gayle','Chris','333rd street','Kingston'),
       (18,'Kohli','Virat','183rd main','Mumbai');

/*SELECT statements*/
/*To select all the data from Table*/
SELECT * FROM Persons;
/* To select required columns from table*/
SELECT FirstName, City FROM Persons;
/* To select only Distinct values of the column from table*/
SELECT DISTINCT City FROM Persons;
/* To count the distinc values */
SELECT COUNT(DISTINCT CITY) FROM Persons;

/*Select with Where conditions*/
SELECT * FROM Persons
WHERE City= 'Los Angeles';
SELECT * FROM Persons
WHERE PersonID > 50;
/* Other operators <,=>,=<,!=,!<,!> */

/* Logical operators:Used to test a specified condition */
SELECT * FROM Persons
WHERE City='Mumbai' AND FirstName='Virat';
SELECT * FROM Persons
WHERE City='Mumbai' OR City='Los Angeles';
SELECT * FROM Persons
WHERE NOT City='Mumbai';
/* Combining AND OR NOT */
SELECT * FROM Persons
WHERE City='Los Angeles' AND (LastName='Johansson' OR LastName='Lopez');
SELECT * FROM Persons
WHERE NOT City='Mumbai' AND NOT City='London';

/* Order BY : To sort the result in ascending or descending order */
SELECT * FROM Persons
ORDER BY City;  /* Ascending default*/
SELECT * FROM Persons
ORDER BY PersonID DESC; /* Descending order*/
SELECT * FROM Persons
ORDER BY City DESC, LastName ASC;

/* Creating another table with null values and primary key */
CREATE TABLE Loans (
ID int NOT NULL,
LastName varchar(255),
FirstName varchar(255),
DOB date,     /*format YYYY-MM-DD*/
Age int,
Gender varchar(255),
Income float,
PRIMARY KEY (ID)
);
/*ALter Table*/
ALTER TABLE Loans
DROP COLUMN Income;
ALTER TABLE Loans
ADD Incomeincrores float;
ALTER TABLE Loans
ADD Profession float;
ALTER TABLE Loans
MODIFY COLUMN Profession varchar(255); 
SELECT * FROM Loans;

/* Date formats
DATE - format YYYY-MM-DD
DATETIME - format: YYYY-MM-DD HH:MI:SS
TIMESTAMP - format: YYYY-MM-DD HH:MI:SS
YEAR - format YYYY or YY*/

INSERT INTO Loans (ID, LastName, FirstName, DOB, Age, Gender, Incomeincrores, Profession)
VALUES (24, 'Cruise', 'Tom', '1962-07-03',61,'Male',1000.45,'Actor'),
	   (32,'Evans','Chris','1981-06-13',42,'Male',300.4,'Actor'),
       (43,'Johansson','Scarlett','1984-11-22',38,'Felmale',500.75,'Actor'),
       (55,'Stone','Emma','1988-11-06',34,'Female',257.99,'Actor'),
       (76,'Lopez','Jennifer','1969-07-24',54,'Female',875.33,'Actor'),
       (99,'Gayle','Chris','1979-10-21',44,'Male', Null,'Cricketer'),
       (18,'Kohli','Virat','1988-11-05',34,'Male',400.44,'Cricketer'),
       (56,'Perry','Elise','1990-11-02',32,'Female',105.4,'Cricketer'),
       (89,'Gadot','Gal','1985-04-30',38,'Female',375.90,'Actor'),
       (78,'Holland','Tom','1996-06-01',27,'Male',Null,'Actor');

/* IS Null and Is Not null */         
SELECT * FROM Loans 
WHERE Incomeincrores IS NULL;
SELECT Gender, Profession, Incomeincrores FROM Loans 
WHERE Incomeincrores IS NOT NULL;

/* UPDATE */
UPDATE Loans
SET Incomeincrores=200.45
WHERE ID=99;
UPDATE Loans
SET Incomeincrores=275.78
WHERE ID=78;
SELECT * FROM Loans;
UPDATE Loans
SET Gender='Female'
WHERE ID=43;

/* LIMIT clause is used to specify the number of records to return*/
SELECT * FROM Loans
LIMIT 3; /*first three records*/
SELECT * FROM Loans
LIMIT 3 OFFSET 3; /*return only 3 records, start on record 4*/
SELECT * FROM Loans
WHERE Profession='Actor'
LIMIT 3;

/* The MIN() function returns the smallest value of the selected column.

The MAX() function returns the largest value of the selected column. */
SELECT MAX(Incomeincrores) AS LargestPrice
FROM Loans;
SELECT MIN(Incomeincrores) AS SmallestPrice
FROM Loans;
/*or You can simply use this*/
SELECT MIN(Incomeincrores)
FROM Loans;

/* COUNT() function returns the number of rows that matches a specified criterion
   AVG() function returns the average value of a numeric column
   SUM() function returns the total sum of a numeric column
   STDDEV(): Returns the standard deviation of all the values specified in the expression.
   in the expression.
   VARIANCE(): Returns the variance of all the values specified in the expression*/
   
SELECT COUNT(Incomeincrores)
FROM Loans;
SELECT COUNT(Incomeincrores)
FROM Loans
WHERE Incomeincrores > 500;
SELECT AVG(Incomeincrores)
FROM Loans;
SELECT SUM(Incomeincrores)
FROM Loans;
SELECT variance(Incomeincrores)
FROM Loans;
SELECT stddev(Incomeincrores)
FROM Loans;

/* The LIKE operator is used in a WHERE clause to search for a specified pattern in a column.*/
SELECT * FROM Loans
WHERE FirstName LIKE 't%'; /* gives result for firstname starting with t*/
SELECT * FROM Loans
WHERE FirstName LIKE '%t'; /* gives result for firstname ending with t*/
SELECT * FROM Loans
WHERE FirstName LIKE '%is%'; /* 'is' in any position*/
SELECT * FROM Loans
WHERE FirstName LIKE '%_i%'; /* 'i' has a letter before*/
SELECT * FROM Loans
WHERE FirstName LIKE '%i__%'; /* has atleast two letters after 'r'*/
SELECT * FROM Loans
WHERE FirstName LIKE 'e%e'; /* starts and ends with e*/

/* The IN operator allows you to specify multiple values in a WHERE clause.
   The IN operator is a shorthand for multiple OR conditions. */
SELECT * FROM Loans
WHERE Gender IN ('Female');
SELECT * FROM Loans
WHERE Gender IN ('Female') AND Age > 35;
SELECT * FROM Loans
WHERE Gender NOT IN ('Female');
SELECT * FROM Loans
WHERE Gender NOT IN ('Female') AND Age >= 40;
/* Selecting same person of ID in Loans as PersonID in Persons*/ 
SELECT * FROM Loans
WHERE ID IN (SELECT PersonID FROM Persons);

/* The BETWEEN operator selects values within a given range. The values can be 
numbers, text, or dates.
The BETWEEN operator is inclusive: begin and end values are included. */
SELECT * FROM Loans
WHERE Incomeincrores BETWEEN 300 AND 500;
SELECT ID,LastName,FirstName FROM Loans
WHERE Incomeincrores NOT BETWEEN 300 AND 500;
SELECT * FROM Loans
WHERE Incomeincrores BETWEEN 300 AND 500
AND ID BETWEEN 10 AND 50; 
SELECT * FROM Loans
WHERE Incomeincrores BETWEEN 300 AND 500
AND ID NOT IN (32); 
SELECT * FROM Loans
WHERE Incomeincrores BETWEEN 300 AND 500
ORDER BY FirstName; 

/* Aliases are used to give a table, or a column in a table, a temporary name.
   Aliases are often used to make column names more readable.
   An alias only exists for the duration of that query.
   An alias is created with the AS keyword. */
SELECT FirstName AS fname, DOB AS Birthdate
FROM Loans;

/* JOIN clause is used to combine rows from two or more tables, 
   based on a related column between them. */
/* INNER JOIN: Returns records that have matching values in both tables
   LEFT JOIN: Returns all records from the left table, and the matched records from the right table
   RIGHT JOIN: Returns all records from the right table, and the matched records from the left table
   CROSS JOIN: Returns all records from both tables
   SELF JOIN: Is a regular join, but the table is joined with itself. */
SELECT * FROM Persons
INNER JOIN Loans 
ON Loans.ID = Persons.PersonID;

SELECT * FROM Persons
LEFT JOIN Loans 
ON Loans.ID = Persons.PersonID;

SELECT * FROM Persons
RIGHT JOIN Loans 
ON Loans.ID = Persons.PersonID;

SELECT * FROM Persons
CROSS JOIN Loans; 

SELECT * FROM Persons
CROSS JOIN Loans
WHERE Persons.PersonID=Loans.ID;

/* Self Join */
SELECT Persons.FirstName AS FName, Persons.City AS City, Loans.DOB AS Birthdate 
FROM Persons, Loans
WHERE Persons.PersonID = Loans.ID
ORDER BY Persons.City;

/* The UNION operator is used to combine the result-set of two or more SELECT statements.

   Every SELECT statement within UNION must have the same number of columns
   The columns must also have similar data types
   The columns in every SELECT statement must also be in the same order */

SELECT LastNAme FROM Persons
UNION
SELECT LastName FROM Loans
ORDER BY LastName;

/* UNION selects only distinct values. Use UNION ALL to also select duplicate values!*/
SELECT LastNAme FROM Persons
UNION ALL
SELECT LastName FROM Loans
ORDER BY LastName;

SELECT FirstName,LastNAme FROM Persons
WHERE LastName='Kohli'
UNION ALL
SELECT FirstName,LastName FROM Loans
WHERE LastName='Kohli'
ORDER BY LastName;

/* Group BY */
SELECT COUNT(ID), Profession
FROM Loans
GROUP BY Profession
ORDER BY COUNT(ID) DESC;

SELECT MAX(ID), Profession
FROM Loans
GROUP BY Profession
ORDER BY MAX(ID) DESC;

/* Having */
SELECT COUNT(ID), Profession
FROM Loans
GROUP BY Profession
HAVING COUNT(ID) > 4;

/* EXISTS checks the existence of a record */
SELECT FirstName
FROM Persons
WHERE EXISTS (SELECT FirstName FROM Loans WHERE Persons.PersonID = Loans.ID 
AND Age > 40);

/* The ANY operator:
   returns a boolean value as a result
   returns TRUE if ANY of the subquery values meet the condition
   ANY means that the condition will be true if the operation is true for any
   of the values in the range. */
SELECT FirstName
FROM Persons
WHERE PersonID = ANY
  (SELECT ID
  FROM Loans
  WHERE Age > 40);

/*The INSERT INTO SELECT statement copies data from one table and inserts it into another table.*/
INSERT INTO Persons (PersonID, FirstName, LastName)
SELECT ID, FirstName, LastName FROM Loans;
SELECT*FROM Persons

/* The CASE statement goes through conditions and returns a value when the first condition is 
met (like an if-then-else statement). So, once a condition is true, it will stop reading 
and return the result. If no conditions are true, it returns the value in the ELSE clause.
If there is no ELSE part and no conditions are true, it returns NULL */
   
SELECT * FROM Loans;
SELECT ID, FirstName, Profession,
CASE 
  WHEN Age > 32 THEN 'Experienced Professional'
  WHEN Age = 32 THEN 'Worthy'
  ELSE 'Young and Inexperienced'
END AS Potentialclients
FROM Loans; 

/* IFNULL() or COALESCE() function lets you return an alternative value if an expression is NULL.*/
SELECT FirstName, IFNULL(Incomeincrores, 0)
FROM Loans;
   
/* DELETE to delete records in Table*/
DELETE FROM Loans WHERE FirstName='Tom';
SELECT*FROM Loans;

/* VIEW: A view contains rows and columns, just like a real table.
The fields in a view are fields from one or more real tables in the database.*/

CREATE VIEW CricketerLoans AS
SELECT FirstName, LastName, Age
FROM Loans
WHERE Profession = 'Cricketer';
SELECT * FROM CricketerLoans;

/* CREATE INDEX and DROP INDEX is used for creating and dropping Indexes from column names.*/

/* DROP TABLE:DROP TABLE statement is used to drop an existing table in a database.
TRUNCATE TABLE:used to delete the data inside a table, but not the table itself.
DROP DATABASE :used to drop an existing SQL database.*/
TRUNCATE TABLE Loans;
DROP TABLE Loans;
DROP DATABASE Person;
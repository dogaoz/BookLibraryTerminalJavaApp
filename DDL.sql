USE Master
DROP DATABASE labwork
CREATE DATABASE labwork
USE labwork
 -- bookId, bookName, authorId,categoryId,publisherId,page,ISBN,stateId
create table Book (
	bookId int NOT NULL IDENTITY,
	bookName nvarchar(100) NOT NULL,
	authorId int NOT NULL,
	categoryId int NOT NULL,
	publisherId int NOT NULL,
	page int NOT NULL,
	ISBN char(9) NOT NULL,
	publishDate date NOT NULL,
	constraint pkbookID primary key (bookId)
	);

create table category (
	categoryId int IDENTITY NOT NULL,
	categoryName nvarchar(45) NOT NULL,
	constraint pkbookCategory primary key (categoryId)
	);
	
create table publisher (
	publisherId int IDENTITY NOT NULL,
	publisherName nvarchar(45) NOT NULL,
	constraint pkbookPublisher primary key (publisherId)
	);
	
create table author (
	authorId int IDENTITY NOT NULL,
	authorName nvarchar(45) NOT NULL,
	constraint pkbookAuthor primary key (authorId)
	);
	
alter table Book add constraint fkBookCategory
	foreign key (categoryId) references category (categoryId);
	
alter table Book add constraint fkBookPublisher
	foreign key (publisherId) references publisher (publisherId);
	
alter table Book add constraint fkBookAuthor
	foreign key (authorId) references author (authorId);


create table Student (
	studentNumber char(9) NOT NULL,
	studentName nvarchar(50) NOT NULL,
	studentAddress nvarchar(100),
	studentPhone char(11),
	numberOfBooks tinyint default 0,
	facultyId int,
	
	constraint pkstudent primary key (studentNumber)
	);
	
create table faculty (
	facultyId int identity NOT NULL,
	facultyName nvarchar(45) NOT NULL,
	constraint pkfaculty primary key (facultyId)
	);
	
alter table Student add constraint fkStudentFaculty
	foreign key (facultyId) references faculty (facultyId);
	
create table state (
	stateId int NOT NULL IDENTITY,
	stateType bit NOT NULL,
	startDate date NOT NULL,
	endDate date NOT NULL,
	studentNumber char(9) NOT NULL,
	constraint pkState primary key (stateId)
	);

alter table state add constraint fkStateStudent
	foreign key (studentNumber) references Student (studentNumber);

create table stateDetail(
	stateId int NOT NULL  IDENTITY,
	bookId int NOT NULL,
	constraint pkStateDetail primary key (stateId)
	);
alter table stateDetail add constraint fkStateId_detail
	foreign key (stateId) references state (stateId);
	
alter table stateDetail add constraint fkBookId_detail
	foreign key (bookId) references Book (bookId);

alter table Student add constraint chk_maxborrow
	check (numberOfBooks between 0 and 5);


-- Mock Data
INSERT INTO author (authorName) VALUES   ('Patrick Collins')
						   ,('Atul Gawande')
						   ,('Maurice D. Weir')
						   ,('health')
						   ,('finance');
						   
INSERT INTO category (categoryName) VALUES  ('law')
						   ,('math')
						   ,('computers')
						   ,('health')
						   ,('sales');
					   
INSERT INTO publisher (publisherName) VALUES ('Pearson')
						   ,('Sterling')
						   ,('Picador')
						   ,('Pelican')
						   ,('Harper Business');
 -- bookId, bookName, authorId,categoryId,publisherId,page,ISBN,stateId

INSERT INTO Book (bookName, authorId,categoryId,publisherId,page,ISBN,publishDate)
			VALUES ('The book',1,1,1,340,000000001,'2005-01-01')
				  ,('Thomas'' Calculus ',3,2,1,991,000000002,'2012-01-01')
				  ,('Some other book',2,5,4,250,000000003,'2002-01-01')
				  ,('Health 101 ',2,4,5,175,000000004,'2013-01-01')
				  ,('Integration Formulas',4,2,3,448,000000005,'2003-01-01')
				  ,('Other book 2 ',5,1,2,678,000000006,'2015-01-01')
				  ,('some other book 2 ',3,3,1,882,000000007,'1998-01-01')
				  ,('Other book ',5,3,5,435,000000008,'2016-01-01')
				  ,('Negotiate To Win! ',1,5,2,202,000000009,'2015-01-01')
				  ,('Finance Advices From Pros',2,5,3,201,000000010,'2008-01-01');

INSERT INTO faculty (facultyName) VALUES ('Law'),
										 ('Engineering'),
										 ('Finance'),
										 ('Architecture');

INSERT INTO Student (studentNumber,studentName,studentAddress,studentPhone,numberOfBooks,facultyId)
			VALUES ('150301037','Doga Ozkaraca','address 123','05001234567',0,2),
				   ('150301038','Lale Al','address 123','05001234567',2,2),
				   ('150101037','Mert Cakir','address 123','05001234567',1,1),
				   ('150101045','Ayse Comert','address 123','05001234567',5,3),
				   ('150101046','Ali Veli','address 123','05001234567',0,3),
				   ('150101017','Merve Tir','address 123','05001234567',1,4);

				   --state type = 0 returned , 1 borrowed
INSERT INTO state (stateType, startDate, endDate,studentNumber) 
			VALUES  (0, '2016-05-12', '2016-05-15', '150301037'),
					(0, '2016-05-22', '2016-05-25', '150101037'),
					(0, '2016-05-21', '2016-05-23', '150101017'),
					(0, '2016-05-18', '2016-05-21', '150101045'),
					(0, '2016-05-12', '2016-05-17', '150101037'),
					(0, '2016-03-22', '2016-03-27', '150101037'),
					(0, '2016-04-18', '2016-04-23', '150101045'),
					(0, '2016-05-16', '2016-05-18', '150101045'),
					(0, '2016-03-12', '2016-03-15', '150301037'),
					(0, '2016-03-22', '2016-03-25', '150301037'),
					(1, '2016-05-26', '2016-06-10', '150301038'),
					(1, '2016-05-27', '2016-06-05', '150101037'),
					(1, '2016-05-26', '2016-06-03', '150301038'),
					(1, '2016-05-26', '2016-06-02', '150101017'),
					(1, '2016-05-28', '2016-06-01', '150101045'),
					(1, '2016-05-28', '2016-06-01', '150101045'),
					(1, '2016-05-28', '2016-06-01', '150101045'),
					(1, '2016-05-28', '2016-06-01', '150101045'),
					(1, '2016-05-28', '2016-06-01', '150101045');
INSERT INTO stateDetail (bookId) VALUES 
								(1),
								(2),
								(5),
								(7),
								(1),
								(8),
								(9),
								(3),
								(3),
								(5),
								(4),
								(2),
								(1),
								(6),
								(9),
								(3),
								(5),
								(4),
								(2);
-- Find the number of books by category
SELECT category.categoryName, COUNT(*) FROM Book 
				JOIN category on Book.categoryId = category.categoryId
				GROUP BY category.categoryName;

-- Display all book titles taken by students in Math Category
SELECT Book.bookName FROM Book JOIN category on Book.categoryId = category.categoryId WHERE category.categoryName='math';

-- Find the student(s) who have borrowed the maximum number of books

SELECT * FROM Student WHERE numberOfBooks=5;

-- Find the student(s) who have never borrowed any books.

SELECT * FROM Student WHERE studentNumber NOT IN (SELECT state.studentNumber from state)
								
-- Find books that have never been borrowed

SELECT bookId,bookName FROM Book WHERE bookId NOT IN (SELECT bookId from stateDetail);

-- Find the total number of books borrowed by category
SELECT category.categoryName, COUNT(*) FROM Book 
				JOIN category on Book.categoryId = category.categoryId
				JOIN stateDetail on Book.bookId = stateDetail.bookId
				JOIN state on stateDetail.stateId = state.stateId
				WHERE state.stateType = 1
				GROUP BY category.categoryName;

-- Find the average age of books by publisher
SELECT YEAR(getDate()) - AVG(YEAR(Book.publishDate)) as avgAgeOfBooks , category.categoryName from Book
						JOIN category on Book.categoryId = category.categoryId
						GROUP BY category.categoryName;
-- LAB 29.04.2016
-- LAB 29.04.2016
-- LAB 29.04.2016


--- LABWORK 5

-- Add a quantity column to book table to store the number of book in stock
-- Initially update all books to be 10

alter table Book add quantity int NOT NULL default 10;

-- Add a derived column called Available that stores number of books available to be borrowed.

SELECT B.ISBN, B.bookName, B.authorId, B.categoryId,  B.quantity,
		B.quantity - (SELECT COUNT(*) from stateDetail
				JOIN state on stateDetail.stateId = state.stateId
				WHERE (state.stateType = 1 AND stateDetail.bookId= B.bookId )) as Available 
		FROM Book as B;
 			
-- Using an update statement, update this value based on the transactions in borrowed table.

-- return a book : e.g. 4
UPDATE state set stateType = 0 WHERE state.stateId = (SELECT stateDetail.stateId 
														from stateDetail
														join state on state.stateId = stateDetail.stateId
														 where (stateDetail.bookId = 4 AND state.studentNumber = '150101045')
													)

--Write a query to find the book(s) that were borrowed the most in each category

		SELECT t.categoryName, MAX(t.Borrowed) as maxBorrowed
		FROM
		(
		SELECT category.categoryName, B.bookId
												
												, (SELECT COUNT(*) from stateDetail
												JOIN state on stateDetail.stateId = state.stateId
												WHERE (state.stateType = 1 AND stateDetail.bookId= B.bookId )) as Borrowed
		FROM Book as B
		JOIN category on category.categoryId = B.categoryId
		GROUP BY category.categoryName,B.bookName,B.bookId) as t
		GROUP BY t.categoryName,t.bookId

--Write a query to find total number of books borrowed by category. 
SELECT t.categoryName, SUM(t.Borrowed) as totalBorrowed
		FROM
		(
		SELECT category.categoryName, B.bookName
												
												, (SELECT COUNT(*) from stateDetail
												JOIN state on stateDetail.stateId = state.stateId
												WHERE (state.stateType = 1 AND stateDetail.bookId= B.bookId )) as Borrowed
		FROM Book as B
		JOIN category on category.categoryId = B.categoryId
		GROUP BY category.categoryName,B.bookName,B.bookId) as t
		GROUP BY t.categoryName

--Write a query that finds all categories that have at least one book taken
SELECT *
FROM
(SELECT t.categoryName, SUM(t.Borrowed) as totalBorrowed
		FROM
		(
		SELECT category.categoryName, B.bookName
												
												, (SELECT COUNT(*) from stateDetail
												JOIN state on stateDetail.stateId = state.stateId
												WHERE (state.stateType = 1 AND stateDetail.bookId= B.bookId )) as Borrowed
		FROM Book as B
		JOIN category on category.categoryId = B.categoryId
		GROUP BY category.categoryName,B.bookName,B.bookId) as t
		GROUP BY t.categoryName) as k
		GROUP BY k.categoryName,k.totalBorrowed
		HAVING MIN(k.totalBorrowed) > 0

--Write a query that finds all categories that have have more than 100 books taken

SELECT *
FROM
(SELECT t.categoryName, SUM(t.Borrowed) as totalBorrowed
		FROM
		(
		SELECT category.categoryName, B.bookName
												
												, (SELECT COUNT(*) from stateDetail
												JOIN state on stateDetail.stateId = state.stateId
												WHERE (state.stateType = 1 AND stateDetail.bookId= B.bookId )) as Borrowed
		FROM Book as B
		JOIN category on category.categoryId = B.categoryId
		GROUP BY category.categoryName,B.bookName,B.bookId) as t
		GROUP BY t.categoryName) as k
		GROUP BY k.categoryName,k.totalBorrowed
		HAVING MIN(k.totalBorrowed) > 100

--Write a query to delete all books that are published before 1980 and is not borrowed as of today

DELETE FROM Book WHERE (YEAR(Book.publishDate) < 1980 AND NOT EXISTS ( SELECT * from stateDetail
												JOIN state on stateDetail.stateId = state.stateId
												WHERE (state.stateType = 1 AND stateDetail.bookId= Book.bookId )) )

--Write a query to update all book quantities to be -1 for books in Sales category

UPDATE Book SET Book.quantity = -1 FROM Book JOIN category on Book.categoryId = category.categoryId WHERE  category.categoryName = 'finance';
	

--Using Labwork2, create following views
--Add borrow and return Dates as DateTime columns in your tables
--Creates views 
--to show all books and borrowers with borrow dates
--Then write a query using the view to show books that have been borrowed in last 3 months
--to show all books and return dates
--Then write a query using the view to show books that have been borrowed the longest time in last year
create view showCurrentBookOwnershipStatus as
	 


--Create check constraints on borrow and return relations as below
--Check that borrow return dates are after current date
--Check date return borrow quantities are always > 1


--Now using your design and queries, create a simple Java application to support following application menu
--Admin
--Add : program should store Enter data for a book. ISBN No is a 9 digit number and is unique
--Search : program should search for a book by ISBN No and/or title and output the result(s) in tabular form 
--Statistics: Number of books taken and not returned yet will be displayed by user name
-- User
--Borrow: Enter a student id and borrow and/or return option for a book by ISBN. A student can borrow at most five books at a time.  
--Search : program should search for a book by ISBN No and/or title and output the result(s) in tabular form
--Return: : Enter a student id and return a book by ISBN



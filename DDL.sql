USE Master
DROP DATABASE labwork
CREATE DATABASE labwork
USE labwork
 -- bookId, bookName, authorId,categoryId,publisherId,page,ISBN,stateId
create table Book (
	bookId int NOT NULL IDENTITY,
	bookName nvarchar(100),
	authorId int,
	categoryId int,
	publisherId int,
	page int,
	ISBN char(9),
	stateId int,
	constraint pkbookID primary key (bookId)
	);

create table category (
	categoryId int IDENTITY,
	categoryName nvarchar(45),
	constraint pkbookCategory primary key (categoryId)
	);
	
create table publisher (
	publisherId int IDENTITY,
	publisherName nvarchar(45),
	constraint pkbookPublisher primary key (publisherId)
	);
	
create table author (
	authorId int IDENTITY,
	authorName nvarchar(45),
	constraint pkbookAuthor primary key (authorId)
	);
	
alter table Book add constraint fkBookCategory
	foreign key (categoryId) references category (categoryId);
	
alter table Book add constraint fkBookPublisher
	foreign key (publisherId) references publisher (publisherId);
	
alter table Book add constraint fkBookAuthor
	foreign key (authorId) references author (authorId);

create table Student (
	studentNumber char(9),
	studentName nvarchar(50),
	studentAddress nvarchar(100),
	studentPhone char(11),
	numberOfBooks tinyint default 0,
	facultyId int,
	
	constraint pkstudent primary key (studentNumber)
	);
	
create table faculty (
	facultyId int identity,
	facultyName nvarchar(45),
	constraint pkfaculty primary key (facultyId)
	);
	
alter table Student add constraint fkStudentFaculty
	foreign key (facultyId) references faculty (facultyId);
	
create table state (
	stateId int NOT NULL IDENTITY,
	stateType bit,
	startDate date NOT NULL,
	endDate date NOT NULL,
	studentNumber char(9),
	constraint pkState primary key (stateId)
	);

alter table state add constraint fkStateStudent
	foreign key (studentNumber) references Student (studentNumber);

create table stateDetail(
	stateId int NOT NULL,
	bookId int,
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
						   ,('finance');
					   
INSERT INTO publisher (publisherName) VALUES ('Pearson')
						   ,('Sterling')
						   ,('Picador')
						   ,('Pelican')
						   ,('Harper Business');
 -- bookId, bookName, authorId,categoryId,publisherId,page,ISBN,stateId

INSERT INTO Book (bookName, authorId,categoryId,publisherId,page,ISBN,stateId)
			VALUES ('The book',1,1,1,340,000000001,1)
				  ,('Thomas'' Calculus ',3,2,1,991,000000002,1)
				  ,('Some other book',2,5,4,250,000000003,1)
				  ,('Health 101 ',2,4,5,175,000000004,1)
				  ,('Integration Formulas',4,2,3,448,000000005,1)
				  ,('Other book 2 ',5,1,2,678,000000006,1)
				  ,('some other book 2 ',3,3,1,882,000000007,1)
				  ,('Other book ',5,3,5,435,000000008,1)
				  ,('Negotiate To Win! ',1,5,2,202,000000009,1)
				  ,('Finance Advices From Pros',2,5,3,201,000000010,1);

INSERT INTO faculty (facultyName) VALUES ('Law'),
										 ('Engineering'),
										 ('Finance'),
										 ('Architecture');

INSERT INTO Student (studentNumber,studentName,studentAddress,studentPhone,numberOfBooks,facultyId)
			VALUES ('150301037','Doga Ozkaraca','address 123','05001234567',0,2),
				   ('150301038','Lale Al','address 123','05001234567',0,2),
				   ('150101037','Mert Cakir','address 123','05001234567',0,1),
				   ('150101045','Ayse Comert','address 123','05001234567',0,3),
				   ('150101017','Merve Tir','address 123','05001234567',0,4);

				   --state type = 0 returned , 1 borrowed
INSERT INTO state (stateType, startDate, endDate,studentNumber) 
			VALUES  (0, 2016-05-22, 2016-05-25, '150301037'),
					(0, 2016-05-22, 2016-05-25, '150101037'),
					(0, 2016-05-22, 2016-05-25, '150101045'),
					(0, 2016-05-22, 2016-05-25, '150101045'),
					(1, 2016-05-26, 2016-06-10, '150301038'),
					(1, 2016-05-26, 2016-06-10, '150301038'),
					(1, 2016-05-26, 2016-06-10, '150301038'),
					(1, 2016-05-26, 2016-06-10, '150301038'),
					(1, 2016-05-26, 2016-06-10, '150301038');
-- Find the number of books by category
SELECT COUNT(*) FROM Book 
-- Display all book titles taken by students in Math Category
SELECT bookName FROM Book WHERE categoryId=2;

-- Find the student(s) who have borrowed the maximum number of books

SELECT * FROM Student WHERE numberOfBooks=5;

-- Find the student(s) who have never borrowed any books.

 
-- Find books that have never been borrowed

SELECT Book.bookId,Book.bookName FROM Book LEFT OUTER JOIN stateDetail on Book.bookId != stateDetail.bookId;

-- Find the total number of books borrowed by category

-- Find the average age of books by publisher


-- LAB 29.04.2016
-- LAB 29.04.2016
-- LAB 29.04.2016


--- LABWORK 5

-- Add a quantity column to book table to store the number of book in stock
-- Initially update all books to be 10

alter table Book add quantity int NOT NULL default 10;

-- Add a derived column called Available that stores number of books available to be borrowed.

SELECT Book.ISBN, Book.bookName, Book.authorId, Book.categoryId,  Book.quantity,
		Book.quantity - COUNT(*) as Available 
		FROM Book
 		JOIN stateDetail on Book.stateId = stateDetail.stateId
		GROUP BY Book.ISBN;
 		
 		
-- Using an update statement, update this value based on the transactions in borrowed table.


INSERT INTO state (stateId,stateType,startDate,endDate,studentId) 
			VALUES(1,1,'2016-04-29','2016-05-01',150301037);
			
			
INSERT INTO stateDetail (stateId,bookId) VALUES (1,1);


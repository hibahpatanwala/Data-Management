-- 📘 Set 3: Library Book Borrowing

-- 📂 Schema

CREATE TABLE LibraryBorrowing (
    BorrowID INT,
    MemberID INT,
    MemberName VARCHAR(100),
    MemberAddress VARCHAR(200),
    BookID INT,
    BookTitle VARCHAR(200),
    Author VARCHAR(100),
    Publisher VARCHAR(100),
    BorrowDate DATE,
    ReturnDate DATE
);

--
-- 1. Identify insertion anomalies
--  You cannot enter a new Member or Book without a borrowing record. E.g., can't add a new Member before they borrow a book.
--
-- 2. Identify update anomalies
--  If a Member's address changes, you must update every row they ever borrowed a book; forgetting some rows introduces inconsistency.
--
-- 3. Identify deletion anomalies
--  Deleting a Member's last borrowing record also loses Member info.
--
-- 4. Why does this table fail 1NF?
--  If SkillSet, Author, or Publisher were stored as comma-separated lists, or BorrowDate, ReturnDate could contain multiple dates, it would violate 1NF. In this design, as long as values are atomic, the table is in 1NF.

-- 5. Rewrite schema in 1NF (already is)
CREATE TABLE LibraryBorrowing (
    BorrowID INT PRIMARY KEY,
    MemberID INT,
    MemberName VARCHAR(100),
    MemberAddress VARCHAR(200),
    BookID INT,
    BookTitle VARCHAR(200),
    Author VARCHAR(100),
    Publisher VARCHAR(100),
    BorrowDate DATE,
    ReturnDate DATE
);

-- Insert sample data for 1NF table
INSERT INTO LibraryBorrowing (BorrowID, MemberID, MemberName, MemberAddress, BookID, BookTitle, Author, Publisher, BorrowDate, ReturnDate) VALUES
(1, 201, 'Ravi Patel', '20 MG Road, Pune',      301, 'Algorithms 101',        'Cormen',     'Pearson',     '2025-09-01', '2025-09-20'),
(2, 202, 'Priya Joshi', '45 Nehru St, Mumbai',   302, 'Organic Chemistry',      'Morrison',   'McGraw-Hill', '2025-09-05', '2025-09-15'),
(3, 201, 'Ravi Patel', '20 MG Road, Pune',      302, 'Organic Chemistry',      'Morrison',   'McGraw-Hill', '2025-09-18', '2025-09-28'),
(4, 203, 'Salim Khan',  '76 Park Ave, Delhi',    303, 'Modern Physics',         'Resnick',    'Wiley',       '2025-09-10', '2025-09-24'),
(5, 204, 'Megha Singh', '9 Garden Rd, Chennai',  304, 'Data Science Basics',    'Provost',    'Pearson',     '2025-09-12', '2025-09-27'),
(6, 202, 'Priya Joshi', '45 Nehru St, Mumbai',   301, 'Algorithms 101',         'Cormen',     'Pearson',     '2025-09-21', '2025-10-01'),
(7, 203, 'Salim Khan',  '76 Park Ave, Delhi',    305, 'General Psychology',     'Stanley',    'PHI',         '2025-09-23', '2025-10-02');

-- 6. State primary key
-- BorrowID is the primary key (each borrowing transaction is unique).

-- 7. Write FDs
-- BorrowID → all other attributes
-- MemberID → MemberName, MemberAddress
-- BookID → BookTitle, Author, Publisher

-- 8. Remove partial dependencies (2NF)
-- Create separate tables for members and books; keep borrowing info in a fact table.
CREATE TABLE Member (
    MemberID INT PRIMARY KEY,
    MemberName VARCHAR(100),
    MemberAddress VARCHAR(200)
);
CREATE TABLE Book (
    BookID INT PRIMARY KEY,
    BookTitle VARCHAR(200),
    Author VARCHAR(100),
    Publisher VARCHAR(100)
);
CREATE TABLE Borrow (
    BorrowID INT PRIMARY KEY,
    MemberID INT,
    BookID INT,
    BorrowDate DATE,
    ReturnDate DATE,
    FOREIGN KEY (MemberID) REFERENCES Member(MemberID),
    FOREIGN KEY (BookID) REFERENCES Book(BookID)
);

-- Insert sample data for 2NF tables
INSERT INTO Member (MemberID, MemberName, MemberAddress) VALUES
(201, 'Ravi Patel', '20 MG Road, Pune'),
(202, 'Priya Joshi', '45 Nehru St, Mumbai'),
(203, 'Salim Khan',  '76 Park Ave, Delhi'),
(204, 'Megha Singh', '9 Garden Rd, Chennai');

INSERT INTO Book (BookID, BookTitle, Author, Publisher) VALUES
(301, 'Algorithms 101', 'Cormen', 'Pearson'),
(302, 'Organic Chemistry', 'Morrison', 'McGraw-Hill'),
(303, 'Modern Physics', 'Resnick', 'Wiley'),
(304, 'Data Science Basics', 'Provost', 'Pearson'),
(305, 'General Psychology', 'Stanley', 'PHI');

INSERT INTO Borrow (BorrowID, MemberID, BookID, BorrowDate, ReturnDate) VALUES
(1, 201, 301, '2025-09-01', '2025-09-20'),
(2, 202, 302, '2025-09-05', '2025-09-15'),
(3, 201, 302, '2025-09-18', '2025-09-28'),
(4, 203, 303, '2025-09-10', '2025-09-24'),
(5, 204, 304, '2025-09-12', '2025-09-27'),
(6, 202, 301, '2025-09-21', '2025-10-01'),
(7, 203, 305, '2025-09-23', '2025-10-02');

-- 10. Identify transitive dependencies
-- MemberID → MemberName, MemberAddress (MemberAddress depends on MemberID indirectly via MemberName)
-- BookID → BookTitle, Author, Publisher (Publisher depends on BookID via BookTitle or Author)

-- 11. Convert to 3NF
-- 2NF design is already in 3NF because all non-prime attributes depend only on the key (no transitive dependency left in Borrow, nor in Book or Member).

-- 12. Write SQL for 3NF schema
-- Same as 2NF tables above.

-- 13. Does schema meet BCNF?
-- Yes: For all FDs, the determinant is a candidate key in its respective table.

-- 14. Query: List all books borrowed by a member
SELECT B.BookTitle, Bor.BorrowDate, Bor.ReturnDate
FROM Book B
JOIN Borrow Bor ON B.BookID = Bor.BookID
WHERE Bor.MemberID = 201;

-- 15. Query: Find members who borrowed more than 3 books
SELECT M.MemberName, COUNT(*) AS BorrowCount
FROM Borrow Bor
JOIN Member M ON Bor.MemberID = M.MemberID
GROUP BY M.MemberName
HAVING COUNT(*) > 3;

-- 16. Query: Find authors whose books are borrowed most
SELECT BK.Author, COUNT(*) AS BorrowCount
FROM Borrow BR
JOIN Book BK ON BR.BookID = BK.BookID
GROUP BY BK.Author
ORDER BY BorrowCount DESC;

-- 17. Query: Count books borrowed per month
SELECT DATE_FORMAT(BorrowDate, '%Y-%m') AS Month, COUNT(*) AS BorrowCount
FROM Borrow
GROUP BY Month;

-- 18. Query: List overdue books (example: ReturnDate > '2025-09-30')
SELECT Bor.BorrowID, B.BookTitle, Bor.ReturnDate
FROM Borrow Bor
JOIN Book B ON B.BookID = Bor.BookID
WHERE Bor.ReturnDate > '2025-09-30';

-- 19. Query: Find publishers whose books are borrowed most
SELECT BK.Publisher, COUNT(*) AS BorrowCount
FROM Borrow BR
JOIN Book BK ON BR.BookID = BK.BookID
GROUP BY BK.Publisher
ORDER BY BorrowCount DESC;

-- 20. Compare redundancy pre/post normalization
-- Before normalization: Member and book info repeated in each borrowing record. Updating addresses or book details requires changing multiple rows.
-- After normalization: Each member and book info is stored exactly once; borrowing records just reference IDs, reducing redundancy and update anomalies.

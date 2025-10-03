-- CONCAT FUNCTION
SELECT CONCAT('Tharun',' ', Name, ' Challa') AS FullName
FROM Accountdetails;

-- CONCAT FUNCTION (Alternative)
SELECT CONCAT('Tharun ', Name) AS FullName
FROM Accountdetails;

-- UPPER FUNCTION
SELECT UPPER(Name) AS CapitalCharacters
FROM Accountdetails;

-- LOWER FUNCTION
SELECT LOWER(Name) AS SmallCharacters
FROM Accountdetails;

-- TRIM FUNCTION
SELECT TRIM(' MYSQL WORKBENCH ') AS cleandata;

-- LTRIM FUNCTION
SELECT LTRIM(' MYSQL WORKBENCH ') AS Leftcleandata;

-- RTRIM FUNCTION
SELECT RTRIM(' MYSQL WORKBENCH ') AS Rightcleandata;

-- LENGTH FUNCTION
SELECT LENGTH('MYSQL WORKBENCH') AS Textlength;

-- AVG FUNCTION
SELECT AVG(Currentbalance) AS Averagebalance
FROM Accountdetails;

-- ROUND AVG FUNCTION
SELECT ROUND(AVG(Currentbalance)) AS Averagebalance
FROM Accountdetails;

-- NOW FUNCTION
SELECT NOW();

-- TIMESTAMPDIFF FUNCTION
SELECT TIMESTAMPDIFF(DAY,'2024-08-01','2024-08-10') AS Datediff;

-- CURRENT_DATE FUNCTION
SELECT CURRENT_DATE();

-- YEAR FUNCTION
SELECT YEAR('2024-08-05') AS Year;

-- MONTH FUNCTION
SELECT MONTH('2024-08-05') AS Month;

-- DAY FUNCTION
SELECT DAY('2024-08-05') AS Day;

-- CREATE FUNCTION FOR BMI
CREATE FUNCTION BodyMassIndex (Par_Height FLOAT, Par_Weight FLOAT)
RETURNS FLOAT
BEGIN
    DECLARE Var_BMI FLOAT;
    SELECT Par_Weight/(Par_Height * Par_Height)
    INTO Var_BMI;
    RETURN Var_BMI;
END;

-- SUM FUNCTION
SELECT SUM(Currentbalance) AS Totalbalance
FROM Accountdetails;

-- MAX FUNCTION
SELECT MAX(Currentbalance) AS Maxbalance
FROM Accountdetails;

-- MIN FUNCTION
SELECT MIN(Currentbalance) AS Minbalance
FROM Accountdetails;

-- DISTINCT FUNCTION
SELECT DISTINCT(Accounttype) AS UniqueAccountType
FROM Accountdetails;

-- COUNT FUNCTION (on Currentbalance)
SELECT COUNT(Currentbalance) AS Totalrecords
FROM Accountdetails;

-- COUNT FUNCTION (*)
SELECT COUNT(*) AS Totalrecords
FROM Accountdetails;

-- LEAD FUNCTION
SELECT *, LEAD(Salary) OVER(PARTITION BY Name) AS Nextval
FROM empsalary;

-- LAG FUNCTION
SELECT *, LAG(Salary) OVER(PARTITION BY Name) AS Previousval
FROM empsalary;

-- CHARINDEX FUNCTION
SELECT CHARINDEX('a', Name) FROM Accountdetails;

-- INSTR FUNCTION
SELECT Name, INSTR(Name,'a') AS Position FROM Accountdetails;

-- MONTHNAME FUNCTION
SELECT MONTHNAME('2024-08-11') AS month_name;

-- DATE_ADD FUNCTION
SELECT DATE_ADD('2024-08-05', INTERVAL 5 DAY) AS Newdate;

-- DAYOFWEEK FUNCTION
SELECT DAYOFWEEK('2024-08-05') AS WeekNo;

-- RANK FUNCTION
SELECT Name, Subject, Marks,
       RANK() OVER(PARTITION BY Subject ORDER BY Marks DESC) AS Stud_rank
FROM studentsmarks;

-- DENSE_RANK FUNCTION
SELECT Name, Subject, Marks,
       DENSE_RANK() OVER(PARTITION BY Subject ORDER BY Marks DESC) AS Stud_rank
FROM studentsmarks;

-- ROW_NUMBER FUNCTION
SELECT Name, Subject, Marks,
       ROW_NUMBER() OVER(PARTITION BY Subject ORDER BY Marks DESC) AS Rowno
FROM studentsmarks;

-- CREATE FUNCTION TO CALCULATE AGE
-- Make sure permissions for user functions are enabled first:
-- SET GLOBAL LOG_BIN_TRUST_FUNCTION_CREATORS=1;
CREATE FUNCTION CalcAge(birthDate DATE)
RETURNS TINYINT DETERMINISTIC
BEGIN
    DECLARE VAR_Age TINYINT;
    SELECT TIMESTAMPDIFF(YEAR, birthDate, NOW())
    INTO VAR_Age;
    RETURN VAR_Age;
END;

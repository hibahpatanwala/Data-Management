-- 📘 Set 2: Employee Project Assignment

CREATE TABLE EmployeeProject (
    EmpID INT,
    EmpName VARCHAR(100),
    Department VARCHAR(50),
    DeptLocation VARCHAR(50),
    ProjectID INT,
    ProjectName VARCHAR(100),
    ProjectManager VARCHAR(100),
    HoursWorked INT,
    SkillSet VARCHAR(200)
);
INSERT INTO EmployeeProject (EmpID, EmpName, Department, DeptLocation, ProjectID, ProjectName, ProjectManager, HoursWorked, SkillSet)
VALUES
(1, 'Amit Kumar', 'Engineering', 'Mumbai', 101, 'AI Chatbot', 'Sanjay Desai', 50, 'C,Java,Problem-Solving'),
(1, 'Amit Kumar', 'Engineering', 'Mumbai', 103, 'Sales Dashboard', 'Manoj Pillai', 18, 'C,Java,Problem-Solving'),
(2, 'Priya Singh', 'Marketing', 'Delhi', 102, 'Ad Campaign', 'Neha Verma', 35, 'Communication,SEO,Content Writing'),
(3, 'Rahul Sharma', 'Sales', 'Chennai', 103, 'Sales Dashboard', 'Manoj Pillai', 42, 'Negotiation,CRM,PPT'),
(4, 'Sneha Mehra', 'Finance', 'Bangalore', 104, 'Budget Analyst', 'Leena Gupta', 56, 'Accounting,Excel,Taxation'),
(5, 'Vikram Patel', 'Engineering', 'Mumbai', 101, 'AI Chatbot', 'Sanjay Desai', 38, 'Python,Data Analysis,SQL'),
(5, 'Vikram Patel', 'Engineering', 'Mumbai', 104, 'Budget Analyst', 'Leena Gupta', 20, 'Python,Data Analysis,SQL');

-- 📝 Practice Questions

-- 1. Identify insertion anomalies in this table.
-- empname, projectname

-- 2. Identify update anomalies.
-- EmpName , Department

-- 3. Identify deletion anomalies.
-- ProjectName, ProjectManager

-- 4. Does this schema satisfy 1NF? Explain.
-- Yes: Each column holds atomic (single) values; there are no repeating groups or arrays in any cell.

-- 5. Normalize to 1NF.
-- Schema already meets 1NF (single values per cell).

-- 6. State the primary key.
-- (EmpID, ProjectID)

-- 7. Write functional dependencies (FDs).
--EmpID → EmpName, Department, SkillSet
-- Department → DeptLocation
-- ProjectID → ProjectName, ProjectManager
-- EmpID, ProjectID → HoursWorked

-- 8. Identify partial dependencies.
-- EmpID → EmpName, Department, SkillSet
-- ProjectID → ProjectName, ProjectManager
-- Department → DeptLocation

-- 9. Convert schema into 2NF.
-- Employee(EmpID, EmpName, Department, SkillSet)
-- Department(Department, DeptLocation)
-- Project(ProjectID, ProjectName, ProjectManager)
-- EmployeeProject(EmpID, ProjectID, HoursWorked)


-- 10. Write SQL for 2NF tables.
CREATE TABLE Department (
    Department VARCHAR(50) PRIMARY KEY,
    DeptLocation VARCHAR(50)
);

CREATE TABLE Employee (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(100),
    Department VARCHAR(50),
    SkillSet VARCHAR(200),
    FOREIGN KEY (Department) REFERENCES Department(Department)
);

CREATE TABLE Project (
    ProjectID INT PRIMARY KEY,
    ProjectName VARCHAR(100),
    ProjectManager VARCHAR(100)
);

CREATE TABLE EmployeeProject (
    EmpID INT,
    ProjectID INT,
    HoursWorked INT,
    PRIMARY KEY (EmpID, ProjectID),
    FOREIGN KEY (EmpID) REFERENCES Employee(EmpID),
    FOREIGN KEY (ProjectID) REFERENCES Project(ProjectID)
);

INSERT INTO Department (Department, DeptLocation) VALUES
('Engineering', 'Mumbai'),
('Marketing', 'Delhi'),
('Sales', 'Chennai'),
('Finance', 'Bangalore');

INSERT INTO Employee (EmpID, EmpName, Department, SkillSet) VALUES
(1, 'Amit Kumar', 'Engineering', 'C,Java,Problem-Solving'),
(2, 'Priya Singh', 'Marketing', 'Communication,SEO,Content Writing'),
(3, 'Rahul Sharma', 'Sales', 'Negotiation,CRM,PPT'),
(4, 'Sneha Mehra', 'Finance', 'Accounting,Excel,Taxation'),
(5, 'Vikram Patel', 'Engineering', 'Python,Data Analysis,SQL');

INSERT INTO Project (ProjectID, ProjectName, ProjectManager) VALUES
(101, 'AI Chatbot', 'Sanjay Desai'),
(102, 'Ad Campaign', 'Neha Verma'),
(103, 'Sales Dashboard', 'Manoj Pillai'),
(104, 'Budget Analyst', 'Leena Gupta');

INSERT INTO EmployeeProject (EmpID, ProjectID, HoursWorked) VALUES
(1, 101, 50),
(1, 103, 18),
(2, 102, 35),
(3, 103, 42),
(4, 104, 56),
(5, 101, 38),
(5, 104, 20);

INSERT INTO EmployeeProject (EmpID, ProjectID, HoursWorked) VALUES
(1, 101, 50),
(1, 103, 18),
(2, 102, 35),
(3, 103, 42),
(4, 104, 56),
(5, 101, 38),
(5, 104, 20);


-- 11. Explain why transitive dependencies still exist.
-- In the Employee table, Department → DeptLocation (DeptLocation not dependent directly on the primary key EmpID, but through Department).
-- In Project, ProjectManager info may relate to another entity (like ManagerID), implying further normalization is possible.

-- 12. Convert schema into 3NF.
-- Department(Department, DeptLocation)
-- Employee(EmpID, EmpName, Department, SkillSet)
-- Project(ProjectID, ProjectName, ProjectManager)
-- EmployeeProject(EmpID, ProjectID, HoursWorked)

-- 13. Write SQL for 3NF tables.
-- Same as 2NF tables

-- 14. Check if schema satisfies BCNF. Modify if needed.
-- Same as 2NF tables

-- 15. Query: List employees with their projects.
SELECT E.EmpName, P.ProjectName
FROM EmployeeProject EP
JOIN Employee E ON EP.EmpID = E.EmpID
JOIN Project P ON EP.ProjectID = P.ProjectID;


-- 16. Query: Count projects per employee.
SELECT E.EmpName, COUNT(*) AS ProjectCount
FROM EmployeeProject EP
JOIN Employee E ON EP.EmpID = E.EmpID
GROUP BY E.EmpName;


-- 17. Query: Find employees with more than 1 skill.
SELECT EmpName, SkillSet
FROM Employee
WHERE LENGTH(SkillSet) - LENGTH(REPLACE(SkillSet, ',', '')) >= 1;


-- 18. Query: Find managers handling multiple projects.
SELECT ProjectManager, COUNT(*) AS ProjectCount
FROM Project
GROUP BY ProjectManager
HAVING COUNT(*) > 1;


-- 19. Query: Find employees working > 40 hours.
SELECT E.EmpName, P.ProjectName, EP.HoursWorked
FROM EmployeeProject EP
JOIN Employee E ON EP.EmpID = E.EmpID
JOIN Project P ON EP.ProjectID = P.ProjectID
WHERE EP.HoursWorked > 40;


-- 20. Discuss redundancy before vs. after normalization.
-- Before normalization: Data about employees, departments, projects, etc., was repeated for every assignment. Updating or correcting a single item (like department information) would require many changes.

-- After normalization: Each entity is stored in a single table; changes require editing just one record. This reduces redundancy and improves consistency.

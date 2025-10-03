WITH AccountSummary AS (
    SELECT Accounttype,
           SUM(Currentbalance) AS TotalBalance,
           AVG(Age) AS AverageAge
    FROM Accountdetails
    GROUP BY Accounttype
)
SELECT Accounttype, TotalBalance, AverageAge
FROM AccountSummary;

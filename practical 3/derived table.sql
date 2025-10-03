-- top 5 balances
SELECT currentbalance FROM accountdetails
ORDER BY currentbalance DESC
LIMIT 5;

-- step 2
SELECT MIN(Currentbalance) FROM Accountdetails
WHERE Currentbalance IN (
    SELECT currentbalance FROM Accountdetails
    ORDER BY currentbalance DESC
    LIMIT 5
);

-- step 3
SELECT MIN(Currentbalance) FROM (
    SELECT Currentbalance FROM Accountdetails
    ORDER BY Currentbalance DESC
    LIMIT 5
) AS Topbalance;

SELECT MIN(Currentbalance) FROM (
    SELECT Currentbalance FROM Accountdetails
    ORDER BY Currentbalance DESC
    LIMIT 2
) AS Topbalance;

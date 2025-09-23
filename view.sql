-- create view
CREATE VIEW AccountsOfTransactions AS
    -- query to be placed in view
    SELECT * FROM Accountdetails WHERE AccountID IN (
        SELECT DISTINCT(AccountID) FROM Transactiondetails
    );

-- execute view
SELECT * FROM AccountsOfTransactions;

-- insert new record in tran. table
INSERT INTO Transactiondetails (AccountID, Transactiontype, Transactionamount)
VALUES
(1, 'Credit', 1000);

-- execute view
SELECT * FROM AccountsOfTransactions;

call practise;

CREATE VIEW BalanceInBank AS
	SELECT SUM(Currentbalance) FROM Accountdetails;
    
SELECT * FROM BalanceInBank; 

UPDATE BalanceInBank
SET Name = 'Ram' WHERE AccountID = 1;

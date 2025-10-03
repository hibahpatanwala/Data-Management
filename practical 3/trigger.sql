DELIMITER $$
CREATE TRIGGER CASCADINGDELETE
BEFORE DELETE ON Accountdetails
FOR EACH ROW
BEGIN
    DELETE FROM Transactiondetails WHERE AccountID = OLD.AccountID;
END;
DELIMITER ;

-- 8. AFTER INSERT trigger for updating balances
DELIMITER $$
CREATE TRIGGER BalanceUpdater
AFTER INSERT ON Transactiondetails
FOR EACH ROW
BEGIN
    DECLARE Var_AccountID INT;
    DECLARE Var_Transactiontype VARCHAR(10);
    DECLARE Var_Transactionamount INT;
    DECLARE Var_Currentbalance INT;

    SELECT AccountID, Transactiontype, Transactionamount
        INTO Var_AccountID, Var_Transactiontype, Var_Transactionamount
        FROM Transactiondetails
        WHERE TransactionID = NEW.TransactionID;

    SELECT Currentbalance INTO Var_Currentbalance
        FROM Accountdetails
        WHERE AccountID = Var_AccountID;

    IF Var_Transactiontype = 'Credit' THEN
        UPDATE Accountdetails
        SET Currentbalance = Var_Currentbalance + Var_Transactionamount
        WHERE AccountID = Var_AccountID;
    ELSEIF Var_Transactionamount <= Var_Currentbalance THEN
        UPDATE Accountdetails
        SET Currentbalance = Var_Currentbalance - Var_Transactionamount
        WHERE AccountID = Var_AccountID;
    ELSE
        -- Optionally handle insufficient funds
        UPDATE Accountdetails
        SET Currentbalance = Var_Currentbalance
        WHERE AccountID = Var_AccountID;
    END IF;
END;
DELIMITER ;



TRUNCATE TABLE Transactiondetails;
SELECT * FROM Transactiondetails;

UPDATE Accountdetails SET Currentbalance = 0;
SELECT * FROM Accountdetails;

INSERT INTO Transactiondetails (AccountID, Transactiontype, Transactionamount)
VALUES (1, 'Credit', 1000), (2, 'Debit', 500);

SELECT * FROM Transactiondetails;



DELETE FROM Accountdetails WHERE AccountID=1;
SELECT * FROM Accountdetails;


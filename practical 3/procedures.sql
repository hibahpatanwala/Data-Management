CREATE DEFINER=`root`@`localhost` PROCEDURE `ministatement`(Par_accountID INT)
BEGIN
	DECLARE Var_Name CHAR(20);
    DECLARE Var_Currentbalance INT;
    SELECT NOW() AS Today_DateTime;
    IF EXISTS(
		SELECT * FROM Accountdetails
        WHERE AccountID = Par_AccountID)
	THEN
		SELECT Par_AccountID AS AccountID;
        SELECT Name, Currentbalance INTO Var_Name, Var_Currentbalance
			FROM Accountdetails
            WHERE AccountID = Par_AccountID;
		SELECT Var_Name AS Customername ;
        SELECT * FROM TransactionDetails
			WHERE AccountID = Par_AccountID
            AND TIMESTAMPDIFF(MONTH, Transactiontime, NOW())<6;
		SELECT Var_Currentbalance AS Currentbalance;
	ELSE
		SELECT 'Invalid AccountID' AS Message;
	END IF;
END


CREATE DEFINER=`root`@`localhost` PROCEDURE `bank_statement`(Par_AccountID INT)
BEGIN
	SELECT * FROM TransactionDetails
    WHERE AccountID = Par_AccountID;
END

CREATE DEFINER=`root`@`localhost` PROCEDURE `AccountStatusUpdater`()
BEGIN
	UPDATE AccountDetails
	SET Accountstatus = 'Active' WHERE AccountID IN (
		SELECT AccountID FROM TransactionDetails
		WHERE TIMESTAMPDIFF(MONTH, Transactiontime, NOW()) <= 6);
    UPDATE AccountDetails
	SET Accountstatus = 'Active' WHERE AccountID NOT IN (
		SELECT AccountID FROM TransactionDetails
		WHERE TIMESTAMPDIFF(MONTH, Transactiontime, NOW()) <= 6);
END

ALTER TABLE AccountDetails
ADD Accountstatus CHAR(28) DEFAULT('Active');

SELECT * FROM AccountDetails;

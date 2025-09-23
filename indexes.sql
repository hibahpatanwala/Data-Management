-- Create a non-unique index
CREATE INDEX Accindex
ON Accountdetails(AccountID);

-- Create a unique index
CREATE UNIQUE INDEX Accountindex
ON Accountdetails(AccountID);

-- Attempt to create a HASH index (not supported by all engines)
CREATE INDEX AccIDindex
USING HASH
ON Accountdetails(AccountID);

-- Drop an index
DROP INDEX AccIDindex
ON Accountdetails;

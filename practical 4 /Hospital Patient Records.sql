
-- Set 4: Hospital Patient Records 
--

-- 1. Identify anomalies (insert, update, delete)
-- Insert anomaly: Can't add a new doctor unless there's a patient record.
-- Update anomaly: Changing DoctorSpecialization requires updating all patient records for that doctor.
-- Delete anomaly: Deleting a patient record may lose information about the doctor if no other patient exists.

-- 2. Does schema satisfy 1NF? Why/why not?
-- Yes, each attribute holds atomic values, no multi-valued attributes or repeating groups.

-- 3. Rewrite schema in 1NF
CREATE TABLE PatientRecords (
    PatientID INT PRIMARY KEY,
    PatientName VARCHAR(100),
    Age INT,
    DoctorName VARCHAR(100),
    DoctorSpecialization VARCHAR(100),
    AppointmentDate DATE,
    Treatment VARCHAR(200),
    MedicinePrescribed VARCHAR(200),
    BillAmount DECIMAL(10,2)
);

-- Insert sample data in 1NF table
INSERT INTO PatientRecords (PatientID, PatientName, Age, DoctorName, DoctorSpecialization, AppointmentDate, Treatment, MedicinePrescribed, BillAmount)
VALUES
(1001, 'Rajesh Kumar', 45, 'Dr. Sharma', 'Cardiology', '2025-09-01', 'Angioplasty', 'Aspirin', 5000.00),
(1002, 'Anita Singh', 37, 'Dr. Sharma', 'Cardiology', '2025-09-03', 'ECG', 'Beta Blockers', 1500.00),
(1003, 'Vikram Joshi', 29, 'Dr. Mehta', 'Neurology', '2025-09-05', 'MRI', 'Painkillers', 3000.00),
(1004, 'Sunita Patel', 50, 'Dr. Das', 'Orthopedics', '2025-09-06', 'Fracture Fix', 'Calcium Supplements', 7000.00),
(1005, 'Manoj Sharma', 40, 'Dr. Mehta', 'Neurology', '2025-09-07', 'Consultation', 'None', 1000.00);

-- 4. State primary key
-- PatientID is the primary key uniquely identifying a patient record.

-- 5. Write functional dependencies
-- PatientID → PatientName, Age, DoctorName, DoctorSpecialization, AppointmentDate, Treatment, MedicinePrescribed, BillAmount
-- DoctorName → DoctorSpecialization

-- 6. Remove partial dependencies (2NF)
-- PatientID uniquely identifies patient info.
-- DoctorName determines DoctorSpecialization (transitive dependency).
-- Separate Doctor info.

CREATE TABLE Doctor (
    DoctorName VARCHAR(100) PRIMARY KEY,
    DoctorSpecialization VARCHAR(100)
);

CREATE TABLE Patient (
    PatientID INT PRIMARY KEY,
    PatientName VARCHAR(100),
    Age INT,
    DoctorName VARCHAR(100),
    FOREIGN KEY (DoctorName) REFERENCES Doctor(DoctorName)
);

CREATE TABLE Appointment (
    PatientID INT,
    AppointmentDate DATE,
    Treatment VARCHAR(200),
    MedicinePrescribed VARCHAR(200),
    BillAmount DECIMAL(10,2),
    PRIMARY KEY (PatientID, AppointmentDate),
    FOREIGN KEY (PatientID) REFERENCES Patient(PatientID)
);

-- Insert sample data into 2NF tables
INSERT INTO Doctor (DoctorName, DoctorSpecialization) VALUES
('Dr. Sharma', 'Cardiology'),
('Dr. Mehta', 'Neurology'),
('Dr. Das', 'Orthopedics');

INSERT INTO Patient (PatientID, PatientName, Age, DoctorName) VALUES
(1001, 'Rajesh Kumar', 45, 'Dr. Sharma'),
(1002, 'Anita Singh', 37, 'Dr. Sharma'),
(1003, 'Vikram Joshi', 29, 'Dr. Mehta'),
(1004, 'Sunita Patel', 50, 'Dr. Das'),
(1005, 'Manoj Sharma', 40, 'Dr. Mehta');

INSERT INTO Appointment (PatientID, AppointmentDate, Treatment, MedicinePrescribed, BillAmount) VALUES
(1001, '2025-09-01', 'Angioplasty', 'Aspirin', 5000.00),
(1002, '2025-09-03', 'ECG', 'Beta Blockers', 1500.00),
(1003, '2025-09-05', 'MRI', 'Painkillers', 3000.00),
(1004, '2025-09-06', 'Fracture Fix', 'Calcium Supplements', 7000.00),
(1005, '2025-09-07', 'Consultation', 'None', 1000.00);

-- 7. Create SQL for 2NF schema
-- (Already created above)

-- 8. Identify transitive dependencies
-- DoctorName → DoctorSpecialization is a transitive dependency if DoctorSpecialization stored in Patient table.

-- 9. Convert schema to 3NF
-- Already resolved by moving DoctorSpecialization to Doctor table.

-- 10. Write SQL for 3NF schema
-- Same as 2NF schema above.

-- 11. Check if schema is BCNF
-- Yes, all determinants are candidate keys for their respective tables.

-- 12. Query: List patients with their doctors
SELECT P.PatientName, P.Age, D.DoctorName, D.DoctorSpecialization
FROM Patient P
JOIN Doctor D ON P.DoctorName = D.DoctorName;

-- 13. Query: Count patients per doctor
SELECT DoctorName, COUNT(*) AS PatientCount
FROM Patient
GROUP BY DoctorName;

-- 14. Query: List treatments done by "Dr. Sharma"
SELECT A.Treatment, A.AppointmentDate, P.PatientName
FROM Appointment A
JOIN Patient P ON A.PatientID = P.PatientID
WHERE P.DoctorName = 'Dr. Sharma';

-- 15. Query: Find patients prescribed more than 2 medicines
-- Assuming medicines are stored as comma-separated values:
SELECT P.PatientName, A.MedicinePrescribed
FROM Appointment A
JOIN Patient P ON A.PatientID = P.PatientID
WHERE LENGTH(A.MedicinePrescribed) - LENGTH(REPLACE(A.MedicinePrescribed, ',', '')) >= 2;

-- 16. Query: List all specializations of doctors treating patients
SELECT DISTINCT DoctorSpecialization FROM Doctor;

-- 17. Query: Find highest bill amount
SELECT MAX(BillAmount) AS HighestBill FROM Appointment;

-- 18. Query: Average bill per doctor
SELECT D.DoctorName, AVG(A.BillAmount) AS AvgBill
FROM Appointment A
JOIN Patient P ON A.PatientID = P.PatientID
JOIN Doctor D ON P.DoctorName = D.DoctorName
GROUP BY D.DoctorName;

-- 19. Query: Patients treated by doctors of "Cardiology"
SELECT P.PatientName, D.DoctorName
FROM Patient P
JOIN Doctor D ON P.DoctorName = D.DoctorName
WHERE D.DoctorSpecialization = 'Cardiology';

-- 20. Explain redundancy reduction after normalization
-- Before normalization, doctor's specialization repeated per patient, increasing storage and risk of inconsistencies.
-- After normalization, doctor details stored once, patients reference doctors, greatly reducing data redundancy and update anomalies.

-- Inserts seed data to bootstrap the Hospital Management System database
-- Each INSERT is preceded by a one-line descriptive comment

-- Inserts sample patients used for development and testing
INSERT INTO dbo.Patients (FullName, DOB, Gender, Phone, Email, IsActive)
VALUES
('Alice Johnson', '1985-03-12', 'Female', '555-0101', 'alice@example.com', 1),
('Bob Smith', '1990-07-22', 'Male', '555-0102', 'bob@example.com', 1),
('Carol Davis', '1978-11-05', 'Female', '555-0103', NULL, 1);
GO

-- Inserts sample doctors used for development and testing
INSERT INTO dbo.Doctors (FullName, Specialization, Phone, ConsultationFee, IsAvailable)
VALUES
('Dr. Emily Zhang', 'Cardiology', '555-0201', 150.00, 1),
('Dr. Raj Patel', 'Orthopedics', '555-0202', 120.00, 1),
('Dr. Maria Lopez', 'Dermatology', '555-0203', 100.00, 1);
GO

-- Inserts sample appointments to exercise reporting and scheduling logic
INSERT INTO dbo.Appointments (PatientCode, DoctorCode, AppointmentDate, AppointmentStatus)
VALUES
(1, 1, DATEADD(day, 3, SYSUTCDATETIME()), 'Scheduled'),
(2, 2, DATEADD(day, 1, SYSUTCDATETIME()), 'Scheduled'),
(3, 3, DATEADD(day, -10, SYSUTCDATETIME()), 'Completed');
GO

-- Creates tables used by the Hospital Management System
-- Each CREATE TABLE statement is preceded by a one-line descriptive comment
--use Hospital_Management_Db
-- Creates the Patients table to store patient personal and status information
CREATE TABLE dbo.Patients (
    PatientCode INT IDENTITY(1,1) PRIMARY KEY,
    FullName NVARCHAR(200) NOT NULL,
    DOB DATE NOT NULL,
    Gender NVARCHAR(20) NOT NULL,
    Phone NVARCHAR(20) NOT NULL,
    Email NVARCHAR(200) NULL,
    IsActive BIT NOT NULL DEFAULT(1),
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    UpdatedAt DATETIME2 NULL
);
GO

-- Creates the Doctors table to hold doctor details and availability
CREATE TABLE dbo.Doctors (
    DoctorCode INT IDENTITY(1,1) PRIMARY KEY,
    FullName NVARCHAR(200) NOT NULL,
    Specialization NVARCHAR(200) NOT NULL,
    Phone NVARCHAR(20) NOT NULL,
    ConsultationFee DECIMAL(10,2) NOT NULL,
    IsAvailable BIT NOT NULL DEFAULT(1),
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    UpdatedAt DATETIME2 NULL
);
GO

-- Creates the Appointments table recording patient-doctor appointments and status
CREATE TABLE dbo.Appointments (
    AppointmentId INT IDENTITY(1,1) PRIMARY KEY,
    PatientCode INT NOT NULL FOREIGN KEY REFERENCES dbo.Patients(PatientCode),
    DoctorCode INT NOT NULL FOREIGN KEY REFERENCES dbo.Doctors(DoctorCode),
    AppointmentDate DATETIME2 NOT NULL,
    AppointmentStatus NVARCHAR(50) NOT NULL DEFAULT('Scheduled'),
    CancelledAt DATETIME2 NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    UpdatedAt DATETIME2 NULL
);
GO

CREATE NONCLUSTERED INDEX IX_Doctors_Available_Specialization
ON dbo.Doctors (Specialization)
WHERE IsAvailable = 1;

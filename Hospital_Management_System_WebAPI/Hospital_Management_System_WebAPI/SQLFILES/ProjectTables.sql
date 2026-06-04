CREATE DATABASE Hospital_Management_DB
USE Hospital_Management_DB


-- Creating Table 
-- 1. Patient's Table 
CREATE TABLE Patients
(
 PatientCode INT PRIMARY KEY IDENTITY(1000,1),
 FullName VARCHAR(100) NOT NULL,
 DOB DATE NOT NULL,
 Gender VARCHAR(10) NOT NULL,
 Phone VARCHAR(15) UNIQUE NOT NULL,
 Email VARCHAR(100)  NULL,
 IsActive BIT DEFAULT 1 NOT NULL,
 CreatedAt DATETIME DEFAULT GETDATE(),
 UpdatedAt DATETIME NULL
)


--2. Doctor's Table
CREATE TABLE Doctors
(
 DoctorCode INT PRIMARY KEY IDENTITY(100,1),
 FullName VARCHAR(100) NOT NULL,
 Specialization VARCHAR(100) NOT NULL,
 Phone VARCHAR(15) UNIQUE NOT NULL,
 ConsultationFee DECIMAL(10,2) NOT NULL CHECK(ConsultationFee > 0),
 IsAvailable BIT DEFAULT 1 NOT NULL,
 CreatedAt DATETIME DEFAULT GETDATE(),
 UpdatedAt DATETIME NULL
)

--3. Appoitment's Tabel
CREATE TABLE Appointments
(
 AppointmentId INT PRIMARY KEY IDENTITY(1,1),
 PatientCode INT NOT NULL,
 DoctorCode INT  NOT NULL,
 AppointmentDate DATETIME NOT NULL,
 AppointmentStatus VARCHAR(15) NOT NULL DEFAULT 'Scheduled'
 CHECK(AppointmentStatus IN ('Scheduled','Completed','Cancelled')),
 CancelledAt DATETIME NULL,
 CreatedAt DATETIME DEFAULT GETDATE(),
 CONSTRAINT FK_Appointment_Patient
 FOREIGN KEY(PatientCode)
 REFERENCES Patients(PatientCode),

 CONSTRAINT FK_Appointment_dOCTOR
 FOREIGN KEY(DoctorCode)
 REFERENCES Doctors(DoctorCode)
)
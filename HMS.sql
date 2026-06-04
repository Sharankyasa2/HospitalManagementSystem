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



-- PATIENTS SAMPLE DATA

INSERT INTO Patients
(FullName, DOB, Gender, Phone, Email)
VALUES
('Sharan Kyasa', '2003-05-10', 'Male', '9876500001', 'sharan@gmail.com'),

('Rahul Sharma', '1999-08-14', 'Male', '9876500002', 'rahul@gmail.com'),

('Sneha Reddy', '2001-11-20', 'Female', '9876500003', 'sneha@gmail.com'),

('Priya Nair', '1998-03-25', 'Female', '9876500004', 'priya@gmail.com'),

('Kiran Kumar', '2000-07-12', 'Male', '9876500005', 'kiran@gmail.com');


-- DOCTORS SAMPLE DATA

INSERT INTO Doctors
(FullName, Specialization, Phone, ConsultationFee)
VALUES
('Dr. Rajesh', 'Cardiology', '9000000001', 800.00),
('Dr. Vikram', 'Cardiology', '9000000005', 600.00),
('Dr. Anil', 'Cardiology', '9000000016', 750.00),
('Dr. Sneha', 'Cardiology', '9000000017', 900.00),

('Dr. Meena', 'Neurology', '9000000002', 1200.00),
('Dr. Rohan', 'Neurology', '9000000018', 1100.00),
('Dr. Divya', 'Neurology', '9000000019', 1000.00),

('Dr. Arjun', 'Orthopedics', '9000000003', 700.00),
('Dr. Karthik', 'Orthopedics', '9000000020', 850.00),
('Dr. Pooja', 'Orthopedics', '9000000021', 750.00),

('Dr. Kavya', 'Dermatology', '9000000004', 500.00),
('Dr. Neha', 'Dermatology', '9000000022', 650.00),
('Dr. Sanjay', 'Dermatology', '9000000023', 550.00),

('Dr. Suresh', 'Pediatrics', '9000000024', 650.00),
('Dr. Ananya', 'Pediatrics', '9000000025', 700.00),
('Dr. Ravi', 'Pediatrics', '9000000026', 600.00),

('Dr. Priya', 'General Medicine', '9000000027', 1000.00),
('Dr. Lakshmi', 'General Medicine', '9000000028', 1200.00),
('Dr. Shalini', 'General Medicine', '9000000029', 1100.00);


-- APPOINTMENTS SAMPLE DATA
INSERT INTO Appointments
(PatientCode, DoctorCode, AppointmentDate, AppointmentStatus)
VALUES
(1000, 100, '2026-05-30 10:00:00', 'Scheduled'),

(1001, 101, '2026-05-30 11:00:00', 'Completed'),

(1002, 102, '2026-05-31 09:30:00', 'Scheduled'),

(1003, 103, '2026-06-01 02:00:00', 'Cancelled'),

(1004, 104, '2026-06-02 04:30:00', 'Scheduled');







   
-- patient queries
--ADDING PATIENT

CREATE PROCEDURE sp_AddPatient
(
    @FullName VARCHAR(100),
    @DOB DATE,
    @Gender VARCHAR(10),
    @Phone VARCHAR(15),
    @Email VARCHAR(100)
)
AS
BEGIN
    BEGIN TRY

        BEGIN TRANSACTION;

        INSERT INTO Patients
        (
            FullName,
            DOB,
            Gender,
            Phone,
            Email,
            IsActive,
            CreatedAt,
            UpdatedAt
        )
        VALUES
        (
            @FullName,
            @DOB,
            @Gender,
            @Phone,
            @Email,
            1,
            GETDATE(),
            GETDATE()
        );

        COMMIT;

    END TRY

    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK;

        THROW;

    END CATCH
END


-- UPDATE PATIENT
CREATE PROCEDURE sp_UpdatePatient
(
    @PatientCode INT,
    @FullName VARCHAR(100) = NULL,
    @DOB DATE = NULL,
    @Gender VARCHAR(10) = NULL,
    @Phone VARCHAR(15) = NULL,
    @Email VARCHAR(100) = NULL
)
AS
BEGIN
    BEGIN TRY

        BEGIN TRANSACTION;

        UPDATE Patients
        SET
            FullName = ISNULL(NULLIF(@FullName, ''), FullName),

            DOB = ISNULL(@DOB, DOB),

            Gender = ISNULL(NULLIF(@Gender, ''), Gender),

            Phone = ISNULL(NULLIF(@Phone, ''), Phone),

            Email = ISNULL(NULLIF(@Email, ''), Email),

            UpdatedAt = GETDATE()

        WHERE PatientCode = @PatientCode;

        IF @@ROWCOUNT = 0
        BEGIN
            THROW 50001, 'Patient not found', 1;
        END

        COMMIT;

    END TRY

    BEGIN CATCH

      
            ROLLBACK;

        THROW;

    END CATCH
END


-- DEACTIVATE PATIENT
CREATE PROCEDURE sp_DeactivatePatient
    @PatientCode INT
AS
BEGIN
    BEGIN TRY

        BEGIN TRANSACTION;

        UPDATE Patients
        SET
            IsActive = 0,
            UpdatedAt = GETDATE()
        WHERE PatientCode = @PatientCode
          AND IsActive = 1;

        IF @@ROWCOUNT = 0
        BEGIN
            THROW 50002, 'Patient not found or already deactivated', 1;
        END

        COMMIT;

    END TRY

    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK;

        THROW;

    END CATCH
END
--get patient by id
CREATE PROCEDURE sp_GetPatientById
    @PatientCode INT
AS
BEGIN
    BEGIN TRY

        SELECT
            PatientCode,
            FullName,
            DOB,
            Gender,
            Phone,
            Email,
            IsActive,
            CreatedAt,
            UpdatedAt
        FROM Patients
        WHERE PatientCode = @PatientCode
          AND IsActive = 1;

        IF @@ROWCOUNT = 0
        BEGIN
            THROW 50003, 'Patient not found', 1;
        END

    END TRY

    BEGIN CATCH

        THROW;

    END CATCH
END


--GET ALL PATIENTS

CREATE PROCEDURE sp_GetAllPatients
AS
BEGIN
    BEGIN TRY

        SELECT *
    FROM Patients
    WHERE IsActive = 1;

    END TRY

    BEGIN CATCH
        THROW;
    END CATCH
END

--DOCTOR

sp_AddDoctor
sp_GetDoctors
sp_GetDoctorsBySpecialization

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


-- ADD DOCTOR
CREATE PROCEDURE sp_AddDoctor
    @FullName VARCHAR(100),
    @Specialization VARCHAR(100),
    @Phone VARCHAR(15),
    @ConsultationFee DECIMAL(10,2)
AS
BEGIN
    BEGIN TRY

        BEGIN TRANSACTION;

        INSERT INTO Doctors
        (
            FullName,
            Specialization,
            Phone,
            ConsultationFee,
            IsAvailable,
            CreatedAt,
            UpdatedAt
        )
        VALUES
        (
            @FullName,
            @Specialization,
            @Phone,
            @ConsultationFee,
            1,
            GETDATE(),
            GETDATE()
        );

        COMMIT;

    END TRY

    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK;

        THROW;

    END CATCH
END

-- GET DOCTOR

CREate PROCEDURE sp_GetDoctors
AS
BEGIN
    BEGIN TRY

        SELECT
            DoctorCode,
            FullName,
            Specialization,
            Phone,
            ConsultationFee,
            IsAvailable,
            CreatedAt,
            UpdatedAt
        FROM Doctors;

    END TRY

    BEGIN CATCH
        THROW;
    END CATCH
END



-- get doctor by specialization

ALTER PROCEDURE sp_GetDoctorsBySpecialization
    @Specialization VARCHAR(100),
    @IsAvailable BIT = NULL
AS
BEGIN
    BEGIN TRY

        SELECT
            DoctorCode,
            FullName,
            Specialization,
            Phone,
            ConsultationFee,
            IsAvailable,
            CreatedAt,
            UpdatedAt
        FROM Doctors
        WHERE Specialization = @Specialization
          AND (@IsAvailable IS NULL OR IsAvailable = @IsAvailable);

    END TRY

    BEGIN CATCH

        THROW;

    END CATCH
END




--Appointment SPs

-- book appointment
CREATE PROCEDURE sp_BookAppointment
(
    @PatientCode INT,
    @DoctorCode INT,
    @AppointmentDate DATETIME
)
AS
BEGIN
    BEGIN TRY

        BEGIN TRANSACTION;

        -- Validate appointment date
        IF @AppointmentDate < GETDATE()
        BEGIN
            THROW 50001, 'Appointment date cannot be in the past', 1;
        END

        -- Check doctor availability
        IF NOT EXISTS
        (
            SELECT 1
            FROM Doctors
            WHERE DoctorCode = @DoctorCode
              AND IsAvailable = 1
        )
        BEGIN
            THROW 50002, 'Doctor is unavailable', 1;
        END

        -- Book appointment
        INSERT INTO Appointments
        (
            PatientCode,
            DoctorCode,
            AppointmentDate,
            AppointmentStatus,
            CreatedAt
        )
        VALUES
        (
            @PatientCode,
            @DoctorCode,
            @AppointmentDate,
            'Scheduled',
            GETDATE()
        );

        COMMIT;

    END TRY

    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK;

        THROW;

    END CATCH
END


-- cancel appointment
CREATE PROCEDURE sp_CancelAppointment
(
    @AppointmentId INT
)
AS
BEGIN
    BEGIN TRY

        BEGIN TRANSACTION;

        
        UPDATE Appointments
        SET
            AppointmentStatus = 'Cancelled',
            CancelledAt = GETDATE()
        WHERE AppointmentId = @AppointmentId
        AND AppointmentStatus = 'Scheduled';

        IF @@ROWCOUNT = 0
        BEGIN
            THROW 50002,
            'Appointment not found or already cancelled/completed',
            1;
        END

        COMMIT;

    END TRY

    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK;

        THROW;

    END CATCH
END



CREATE PROCEDURE sp_UpdateCompletedAppointments
AS
BEGIN
    BEGIN TRY
    UPDATE Appointments

        SET AppointmentStatus = 'Completed'
        WHERE AppointmentStatus = 'Scheduled'AND AppointmentDate < GETDATE();
    END TRY
    BEGIN CATCH
    THROW;
    END CATCH
END
GO

-- get upcomming appointments
ALTER PROCEDURE sp_GetUpcomingAppointments
AS
BEGIN
    BEGIN TRY

        SELECT
            AppointmentId,
            PatientCode,
            DoctorCode,
            AppointmentDate,
            AppointmentStatus,
            CancelledAt
        FROM Appointments
        WHERE AppointmentDate >= GETDATE()
        AND AppointmentStatus = 'Scheduled'
        ORDER BY AppointmentDate;

    END TRY

    BEGIN CATCH

        THROW;

    END CATCH
END

-- get doctor appointments
CREATE PROCEDURE sp_GetDoctorAppointments
(
    @DoctorCode INT
)
AS
BEGIN
    BEGIN TRY

        SELECT
            AppointmentId,
            PatientCode,
            DoctorCode,
            AppointmentDate,
            AppointmentStatus,
            CancelledAt
        FROM Appointments
        WHERE DoctorCode = @DoctorCode
        ORDER BY AppointmentDate DESC;

    END TRY

    BEGIN CATCH

        THROW;

    END CATCH
END



-- get patients appointments


ALTER PROCEDURE sp_GetPatientAppointments
(
    @PatientCode INT
)
AS
BEGIN
    BEGIN TRY

        SELECT
            AppointmentId,
            PatientCode,
            DoctorCode,
            AppointmentDate,
            AppointmentStatus,
            CancelledAt
        FROM Appointments
        WHERE PatientCode=@PatientCode
        ORDER BY AppointmentDate DESC;

    END TRY

    BEGIN CATCH

        THROW;

    END CATCH
END




CREATE PROCEDURE sp_GetAppointmentReport
AS
BEGIN
    SELECT
        A.AppointmentId,
        P.FullName AS PatientName,
        D.FullName AS DoctorName,
        D.Specialization,
        A.AppointmentDate,
        A.AppointmentStatus,
        D.ConsultationFee
    FROM Appointments A
    INNER JOIN Patients P
        ON A.PatientCode = P.PatientCode
    INNER JOIN Doctors D
        ON A.DoctorCode = D.DoctorCode
    ORDER BY A.AppointmentDate DESC;
END
GO




CREATE PROCEDURE sp_GetRevenueBySpecialization
AS
BEGIN
    SELECT
        D.Specialization,
        COUNT(A.AppointmentId) AS TotalAppointments,
        SUM(D.ConsultationFee) AS TotalRevenue
    FROM Appointments A
    INNER JOIN Doctors D
        ON A.DoctorCode = D.DoctorCode
    WHERE A.AppointmentStatus <> 'Cancelled'
    GROUP BY D.Specialization
    ORDER BY TotalRevenue DESC;
END
GO




CREATE PROCEDURE sp_GetDoctorsWithMoreThan2Appointments
AS
BEGIN
    SELECT
        D.DoctorCode,
        D.FullName,
        D.Specialization,
        COUNT(A.AppointmentId) AS AppointmentCount
    FROM Doctors D
    INNER JOIN Appointments A
        ON D.DoctorCode = A.DoctorCode
    GROUP BY
        D.DoctorCode,
        D.FullName,
        D.Specialization
    HAVING COUNT(A.AppointmentId) > 2
    ORDER BY AppointmentCount DESC;
END
GO


SELECT name
FROM sys.procedures;
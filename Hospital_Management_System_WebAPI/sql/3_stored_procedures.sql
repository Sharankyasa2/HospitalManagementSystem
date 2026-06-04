-- Stored procedures used by the .NET application
-- Each procedure is preceded by a one-line descriptive comment explaining purpose and parameters

-- Adds a new patient record and returns the new PatientCode
IF OBJECT_ID('dbo.sp_AddPatient', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_AddPatient;
GO
CREATE PROCEDURE dbo.sp_AddPatient
    @FullName NVARCHAR(200),
    @DOB DATE,
    @Gender NVARCHAR(20),
    @Phone NVARCHAR(20),
    @Email NVARCHAR(200) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.Patients (FullName, DOB, Gender, Phone, Email)
    VALUES (@FullName, @DOB, @Gender, @Phone, @Email);

    SELECT SCOPE_IDENTITY() AS PatientCode;
END
GO

-- Deactivates a patient by setting IsActive = 0
IF OBJECT_ID('dbo.sp_DeactivatePatient', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_DeactivatePatient;
GO
CREATE PROCEDURE dbo.sp_DeactivatePatient
    @PatientCode INT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.Patients
    SET IsActive = 0,
        UpdatedAt = SYSUTCDATETIME()
    WHERE PatientCode = @PatientCode;

    IF @@ROWCOUNT = 0
        THROW 50000, 'Patient not found or could not be deactivated.', 1;
END
GO

-- Updates patient details based on PatientCode
IF OBJECT_ID('dbo.sp_UpdatePatient', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_UpdatePatient;
GO
CREATE PROCEDURE dbo.sp_UpdatePatient
    @PatientCode INT,
    @FullName NVARCHAR(200),
    @DOB DATE,
    @Gender NVARCHAR(20),
    @Phone NVARCHAR(20),
    @Email NVARCHAR(200)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.Patients
    SET FullName = @FullName,
        DOB = @DOB,
        Gender = @Gender,
        Phone = @Phone,
        Email = @Email,
        UpdatedAt = SYSUTCDATETIME()
    WHERE PatientCode = @PatientCode;

    IF @@ROWCOUNT = 0
        THROW 50001, 'Patient update failed.', 1;
END
GO

-- Gets all patients for administration or listing
IF OBJECT_ID('dbo.sp_GetAllPatients', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_GetAllPatients;
GO
CREATE PROCEDURE dbo.sp_GetAllPatients
AS
BEGIN
    SET NOCOUNT ON;

    SELECT PatientCode, FullName, DOB, Gender, Phone, Email, IsActive
    FROM dbo.Patients;
END
GO

-- Retrieves a single patient by PatientCode
IF OBJECT_ID('dbo.sp_GetPatientById', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_GetPatientById;
GO
CREATE PROCEDURE dbo.sp_GetPatientById
    @PatientCode INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT PatientCode, FullName, DOB, Gender, Phone, Email, IsActive
    FROM dbo.Patients
    WHERE PatientCode = @PatientCode;
END
GO

-- Adds a new doctor record to the Doctors table
IF OBJECT_ID('dbo.sp_AddDoctor', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_AddDoctor;
GO
CREATE PROCEDURE dbo.sp_AddDoctor
    @FullName NVARCHAR(200),
    @Specialization NVARCHAR(200),
    @Phone NVARCHAR(20),
    @ConsultationFee DECIMAL(10,2)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.Doctors (FullName, Specialization, Phone, ConsultationFee)
    VALUES (@FullName, @Specialization, @Phone, @ConsultationFee);

    IF @@ROWCOUNT = 0
        THROW 50002, 'Failed to add doctor.', 1;
END
GO

-- Retrieves all doctors
IF OBJECT_ID('dbo.sp_GetDoctors', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_GetDoctors;
GO
CREATE PROCEDURE dbo.sp_GetDoctors
AS
BEGIN
    SET NOCOUNT ON;

    SELECT DoctorCode, FullName, Specialization, Phone, ConsultationFee, IsAvailable
    FROM dbo.Doctors;
END
GO

-- Retrieves doctors filtered by specialization
IF OBJECT_ID('dbo.sp_GetDoctorsBySpecialization', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_GetDoctorsBySpecialization;
GO
CREATE PROCEDURE dbo.sp_GetDoctorsBySpecialization
    @Specialization NVARCHAR(200)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT DoctorCode, FullName, Specialization, Phone, ConsultationFee, IsAvailable
    FROM dbo.Doctors
    WHERE Specialization = @Specialization;
END
GO

-- Books a new appointment between a patient and a doctor
IF OBJECT_ID('dbo.sp_BookAppointment', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_BookAppointment;
GO
CREATE PROCEDURE dbo.sp_BookAppointment
    @PatientCode INT,
    @DoctorCode INT,
    @AppointmentDate DATETIME2
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.Appointments (PatientCode, DoctorCode, AppointmentDate, AppointmentStatus)
    VALUES (@PatientCode, @DoctorCode, @AppointmentDate, 'Scheduled');
END
GO

-- Cancels an appointment and sets CancelledAt timestamp
IF OBJECT_ID('dbo.sp_CancelAppointment', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_CancelAppointment;
GO
CREATE PROCEDURE dbo.sp_CancelAppointment
    @AppointmentId INT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.Appointments
    SET AppointmentStatus = 'Cancelled',
        CancelledAt = SYSUTCDATETIME(),
        UpdatedAt = SYSUTCDATETIME()
    WHERE AppointmentId = @AppointmentId;
END
GO

-- Marks appointments as Completed if appointment date is in the past
IF OBJECT_ID('dbo.sp_UpdateCompletedAppointments', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_UpdateCompletedAppointments;
GO
CREATE PROCEDURE dbo.sp_UpdateCompletedAppointments
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.Appointments
    SET AppointmentStatus = 'Completed',
        UpdatedAt = SYSUTCDATETIME()
    WHERE AppointmentDate < SYSUTCDATETIME()
      AND AppointmentStatus NOT IN ('Completed', 'Cancelled');
END
GO

-- Retrieves upcoming appointments (scheduled and not cancelled/completed)
IF OBJECT_ID('dbo.sp_GetUpcomingAppointments', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_GetUpcomingAppointments;
GO
CREATE PROCEDURE dbo.sp_GetUpcomingAppointments
AS
BEGIN
    SET NOCOUNT ON;

    SELECT a.AppointmentId, a.PatientCode, a.DoctorCode, a.AppointmentDate, a.AppointmentStatus,
           a.CancelledAt
    FROM dbo.Appointments a
    WHERE a.AppointmentStatus = 'Scheduled'
      AND a.AppointmentDate >= SYSUTCDATETIME();
END
GO

-- Retrieves appointments for a specified doctor
IF OBJECT_ID('dbo.sp_GetDoctorAppointments', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_GetDoctorAppointments;
GO
CREATE PROCEDURE dbo.sp_GetDoctorAppointments
    @DoctorCode INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT a.AppointmentId, a.PatientCode, a.DoctorCode, a.AppointmentDate, a.AppointmentStatus,
           a.CancelledAt
    FROM dbo.Appointments a
    WHERE a.DoctorCode = @DoctorCode
      AND a.AppointmentStatus = 'Scheduled';
END
GO

-- Retrieves appointments for a specified patient
IF OBJECT_ID('dbo.sp_GetPatientAppointments', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_GetPatientAppointments;
GO
CREATE PROCEDURE dbo.sp_GetPatientAppointments
    @PatientCode INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT a.AppointmentId, a.PatientCode, a.DoctorCode, a.AppointmentDate, a.AppointmentStatus,
           a.CancelledAt
    FROM dbo.Appointments a
    WHERE a.PatientCode = @PatientCode;
END
GO

-- Appointment report joining patients and doctors for reporting
IF OBJECT_ID('dbo.sp_GetAppointmentReport', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_GetAppointmentReport;
GO
CREATE PROCEDURE dbo.sp_GetAppointmentReport
AS
BEGIN
    SET NOCOUNT ON;

    SELECT a.AppointmentId,
           p.FullName AS PatientName,
           d.FullName AS DoctorName,
           d.Specialization,
           a.AppointmentDate,
           a.AppointmentStatus,
           d.ConsultationFee
    FROM dbo.Appointments a
    JOIN dbo.Patients p ON p.PatientCode = a.PatientCode
    JOIN dbo.Doctors d ON d.DoctorCode = a.DoctorCode;
END
GO

-- Aggregates revenue by specialization using consultation fees of completed appointments
IF OBJECT_ID('dbo.sp_GetRevenueBySpecialization', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_GetRevenueBySpecialization;
GO
CREATE PROCEDURE dbo.sp_GetRevenueBySpecialization
AS
BEGIN
    SET NOCOUNT ON;

    SELECT d.Specialization,
           COUNT(*) AS TotalAppointments,
           SUM(d.ConsultationFee) AS TotalRevenue
    FROM dbo.Appointments a
    JOIN dbo.Doctors d ON d.DoctorCode = a.DoctorCode
    WHERE a.AppointmentStatus = 'Completed'
    GROUP BY d.Specialization;
END
GO

-- Finds doctors with more than two scheduled appointments (busy doctors)
IF OBJECT_ID('dbo.sp_GetDoctorsWithMoreThan2Appointments', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_GetDoctorsWithMoreThan2Appointments;
GO
CREATE PROCEDURE dbo.sp_GetDoctorsWithMoreThan2Appointments
AS
BEGIN
    SET NOCOUNT ON;

    SELECT d.DoctorCode,
           d.FullName,
           d.Specialization,
           COUNT(a.AppointmentId) AS AppointmentCount
    FROM dbo.Appointments a
    JOIN dbo.Doctors d ON d.DoctorCode = a.DoctorCode
    WHERE a.AppointmentStatus = 'Scheduled'
    GROUP BY d.DoctorCode, d.FullName, d.Specialization
    HAVING COUNT(a.AppointmentId) > 2;
END
GO

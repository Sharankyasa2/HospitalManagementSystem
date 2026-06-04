
-- book appointment
--USE Hospital_Management_DB
ALTER PROCEDURE sp_BookAppointment
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

        IF EXISTS
        (
            SELECT 1 FROM APPOINTMENTS 
            WHERE DOCTORCODE = @DoctorCode AND AppointmentStatus = 'Scheduled' AND  @AppointmentDate < DATEADD(hour,1,AppointmentDate)
            AND DATEADD(HOUR, 1, @AppointmentDate) > AppointmentDate
        )
        BEGIN
            THROW 50002, 'Slot Already Booked', 1;
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
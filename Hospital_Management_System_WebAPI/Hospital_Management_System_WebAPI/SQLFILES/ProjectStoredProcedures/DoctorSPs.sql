
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

        SELECT SCOPE_IDENTITY();

        COMMIT;

    END TRY

    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK;

        THROW;

    END CATCH
END

-- GET DOCTOR

CREATE PROCEDURE sp_GetDoctors
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

--get doctor by doctor code
CREATE PROCEDURE sp_GetDoctorById
    @DoctorCode INT
AS
BEGIN
    IF NOT EXISTS
    (
        SELECT 1 FROM Doctors WHERE DoctorCode = @DoctorCode AND IsAvailable = 1
    )
    BEGIN
        THROW 50003,'Doctor data Does not exist with this code',2
    END
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
        WHERE DoctorCode = @DoctorCode;
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
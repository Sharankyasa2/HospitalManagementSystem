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
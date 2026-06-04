--
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
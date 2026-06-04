using Hospital_Management_System_WebAPI.Models.DTOs.Appointment;

public interface IReportService
{
    Task<List<AppointmentReportDto>> GetAppointmentReportAsync();

    Task<List<RevenueBySpecializationDto>> GetRevenueBySpecializationAsync();

    Task<List<DoctorAppointmentStatsDto>> GetDoctorsWithMoreThan2AppointmentsAsync();
}
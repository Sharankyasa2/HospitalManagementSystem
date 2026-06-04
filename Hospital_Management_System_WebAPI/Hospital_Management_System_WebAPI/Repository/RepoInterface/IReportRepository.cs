using Hospital_Management_System_WebAPI.Models.DTOs.Appointment;

public interface IReportRepository
{
    Task<List<AppointmentReportDto>> GetAppointmentReportAsync();

    Task<List<RevenueBySpecializationDto>> GetRevenueBySpecializationAsync();

    Task<List<DoctorAppointmentStatsDto>> GetDoctorsWithMoreThan2AppointmentsAsync();
}
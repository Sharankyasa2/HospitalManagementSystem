using Hospital_Management_System_WebAPI.Models.DTOs.Appointment;
using Hospital_Management_Web_Api.Repositories.Interface;

namespace Hospital_Management_System_WebAPI.Services.ServiceImplementation
{
    public class ReportService : IReportService
    {
        private readonly IReportRepository _repository;

        // Constructor: injects report repository used to fetch report data
        public ReportService(IReportRepository repository)
        {
            _repository = repository;
        }

        // Retrieves appointment report data from repository
        public async Task<List<AppointmentReportDto>> GetAppointmentReportAsync()
        {
            return await _repository.GetAppointmentReportAsync();
        }

        // Retrieves revenue grouped by specialization from repository
        public async Task<List<RevenueBySpecializationDto>> GetRevenueBySpecializationAsync()
        {
            return await _repository.GetRevenueBySpecializationAsync();
        }

        // Retrieves statistics for doctors having more than two appointments
        public async Task<List<DoctorAppointmentStatsDto>> GetDoctorsWithMoreThan2AppointmentsAsync()
        {
            return await _repository.GetDoctorsWithMoreThan2AppointmentsAsync();
        }
    }
}
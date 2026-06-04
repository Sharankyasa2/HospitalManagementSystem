using Hospital_Management_System_WebAPI.Models.DTOs.Appointment;
using Hospital_Management_System_WebAPI.Models.POCO;
using Hospital_Management_Web_Api.Repositories.Interface;
using Hospital_Management_Web_Api.Services.Interface;

namespace Hospital_Management_System_WebAPI.Services.ServiceImplementation
{
    public class AppointmentService : IAppointmentService
    {
        private readonly IAppointmentRepository _repo;

        // Constructor: injects appointment repository used for data operations
        public AppointmentService(IAppointmentRepository repo)
        {
            _repo = repo;
        }

        // Validates and books a new appointment via repository
        public async Task BookAppointmentAsync(BookAppointmentDto dto)
        {
            if (dto.DoctorCode <= 0)
                throw new Exception("Invalid doctor");
            await _repo.BookAppointmentAsync(dto);
        }

        // Cancels an appointment identified by its id after validation
        public async Task CancelAppointmentAsync(int appointmentId)
        {
            if (appointmentId <= 0)
                throw new Exception("Invalid appointment id");

            await _repo.CancelAppointmentAsync(appointmentId);
        }

        // Retrieves all upcoming appointments from repository
        public async Task<List<Appointment>> GetUpcomingAppointmentsAsync()
        {
            return await _repo.GetUpcomingAppointmentsAsync();
        }

        // Retrieves all appointments for a specific doctor after validating input
        public async Task<List<Appointment>> GetDoctorAppointmentsAsync(int doctorCode)
        {
            if (doctorCode <= 0)
                throw new Exception("Invalid doctor code");

            return await _repo.GetDoctorAppointmentsAsync(doctorCode);
        }
    }
}
using Hospital_Management_System_WebAPI.Models.DTOs.Appointment;
using Hospital_Management_System_WebAPI.Models.POCO;

namespace Hospital_Management_Web_Api.Repositories.Interface
{
    public interface IAppointmentRepository
    {
        Task BookAppointmentAsync(BookAppointmentDto dto);

        Task CancelAppointmentAsync(int appointmentId);

        Task<List<Appointment>> GetUpcomingAppointmentsAsync();

        Task<List<Appointment>> GetDoctorAppointmentsAsync(int doctorCode);

        Task<List<Appointment>> GetPatientAppointmentsAsync(int patientCode);
    }
}
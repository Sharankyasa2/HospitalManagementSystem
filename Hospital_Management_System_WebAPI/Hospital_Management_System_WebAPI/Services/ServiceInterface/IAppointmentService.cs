using Hospital_Management_System_WebAPI.Models.DTOs.Appointment;
using Hospital_Management_System_WebAPI.Models.POCO;

namespace Hospital_Management_Web_Api.Services.Interface
{
    public interface IAppointmentService
    {
        Task BookAppointmentAsync(BookAppointmentDto dto);
        Task CancelAppointmentAsync(int appointmentId);
        Task<List<Appointment>> GetUpcomingAppointmentsAsync();
        Task<List<Appointment>> GetDoctorAppointmentsAsync(int doctorCode);
    }
}
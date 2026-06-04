namespace Hospital_Management_System_WebAPI.Models.DTOs.Appointment
{
    public class DoctorAppointmentStatsDto
    {
        public int DoctorCode { get; set; }
        public string DoctorName { get; set; } = string.Empty;
        public string Specialization { get; set; } = string.Empty;
        public int AppointmentCount { get; set; }
    }
}
namespace Hospital_Management_System_WebAPI.Models.DTOs.Appointment
{
    public class RevenueBySpecializationDto
    {
        public string Specialization { get; set; } = string.Empty;
        public int TotalAppointments { get; set; }
        public decimal TotalRevenue { get; set; }
    }
}
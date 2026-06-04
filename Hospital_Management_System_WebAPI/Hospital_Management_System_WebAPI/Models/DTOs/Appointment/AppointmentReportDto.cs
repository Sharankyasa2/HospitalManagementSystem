namespace Hospital_Management_System_WebAPI.Models.DTOs.Appointment
{
    public class AppointmentReportDto
    {
        public int AppointmentId { get; set; }
        public string PatientName { get; set; } = string.Empty;
        public string DoctorName { get; set; } = string.Empty;
        public string Specialization { get; set; } = string.Empty;
        public DateTime AppointmentDate { get; set; }
        public string AppointmentStatus { get; set; } = string.Empty;
        public decimal ConsultationFee { get; set; }
    }
}
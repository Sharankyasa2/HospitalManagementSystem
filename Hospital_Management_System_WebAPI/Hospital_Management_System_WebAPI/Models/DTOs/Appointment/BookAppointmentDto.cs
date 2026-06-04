using System.ComponentModel.DataAnnotations;

namespace Hospital_Management_System_WebAPI.Models.DTOs.Appointment
{
    public class BookAppointmentDto
    {
        [Required]
        public int PatientCode { get; set; }

        [Required]
        public int DoctorCode { get; set; }

        [Required]
        public DateTime AppointmentDate { get; set; }
        public string? PatientName { get; internal set; }
    }
}
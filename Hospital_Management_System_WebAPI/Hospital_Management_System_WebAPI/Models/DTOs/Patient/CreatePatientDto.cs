using System.ComponentModel.DataAnnotations;

namespace Hospital_Management_System_WebAPI.Models.DTOs.Patient
{
    public class CreatePatientDto
    {
        [Required]
        public string FullName { get; set; } = string.Empty;

        [Required]
        [DataType(DataType.Date)]
        public DateTime DOB { get; set; }

        [Required]
        public string Gender { get; set; } = string.Empty;

        [Required]
        public string Phone { get; set; } = string.Empty;

        [EmailAddress]
        public string? Email { get; set; }
    }
}
using System.ComponentModel.DataAnnotations;

namespace Hospital_Management_Web_Api.Models.Patient.DTOs
{
    public class UpdatePatientDto
    {
        public string? FullName { get; set; }

        [DataType(DataType.Date)]
        public DateTime? DOB { get; set; }

        public string? Gender { get; set; }

        public string? Phone { get; set; }

        [EmailAddress]
        public string? Email { get; set; }
    }
}
namespace Hospital_Management_System_WebAPI.Models.POCO
{
    public class Doctor : Person
    {
        public int DoctorCode { get; set; }

        public string Specialization { get; set; } = string.Empty;

        public decimal ConsultationFee { get; set; }

        public bool IsAvailable { get; set; }

        public DateTime CreatedAt { get; set; }

        public DateTime? UpdatedAt { get; set; }
    }
}
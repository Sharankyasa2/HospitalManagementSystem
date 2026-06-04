namespace Hospital_Management_System_WebAPI.Models.POCO
{
    public class Patient : Person
    {
        public int PatientCode { get; set; }

        public DateTime DOB { get; set; }

        public string? Gender { get; set; }

        public string? Email { get; set; }

        public bool IsActive { get; set; }

        public DateTime CreatedAt { get; set; }

        public DateTime? UpdatedAt { get; set; }

        public int Age
        {
            get
            {
                int age = DateTime.Today.Year - DOB.Year;

                if (DateTime.Today < DOB.AddYears(age))
                    age--;

                return age;
            }
        }
    }
}
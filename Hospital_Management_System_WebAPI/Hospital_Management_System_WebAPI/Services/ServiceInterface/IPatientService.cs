using Hospital_Management_System_WebAPI.Models.DTOs.Patient;
using Hospital_Management_System_WebAPI.Models.POCO;
using Hospital_Management_Web_Api.Models.Patient.DTOs;

namespace Hospital_Management_Web_Api.Services.Interface
{
    public interface IPatientService
    {
        Task AddPatientAsync(CreatePatientDto dto);

        Task UpdatePatientAsync(int atientCode, UpdatePatientDto dto);

        Task DeactivatePatientAsync(int patientCode);


        Task<Patient?> GetPatientByIdAsync(int patientCode);
        Task<List<Patient>> GetAllPatientsAsync();
    }
}
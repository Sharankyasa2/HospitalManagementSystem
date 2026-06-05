using Hospital_Management_System_WebAPI.Models.POCO;
using Hospital_Management_Web_Api.Models.Doctor.DTOs;
using Hospital_Management_Web_Api.Models.Patient;
using Hospital_Management_Web_Api.Models.Patient.DTOs;

namespace Hospital_Management_Web_Api.Repositories.Interface
{
    public interface IDoctorRepository
    {
        Task<int> AddDoctorAsync(CreateDoctorDto dto);

        Task<Doctor> GetDoctorByCodeAsync(int code);

        Task<List<Doctor>> GetDoctorsAsync();

        Task<List<Doctor>> GetDoctorsBySpecializationAsync(string specialization);
    }
}
using Hospital_Management_System_WebAPI.Models.POCO;
using Hospital_Management_Web_Api.Models.Doctor.DTOs;

namespace Hospital_Management_Web_Api.Services.Interface
{
    public interface IDoctorService
    {
        Task AddDoctorAsync(CreateDoctorDto dto);

        Task<List<Doctor>> GetDoctorsAsync();

        Task<List<Doctor>> GetDoctorsBySpecializationAsync(string specialization);
    }
}
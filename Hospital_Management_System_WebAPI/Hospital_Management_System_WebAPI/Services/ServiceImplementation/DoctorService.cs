using Hospital_Management_System_WebAPI.Models.POCO;
using Hospital_Management_Web_Api.Models.Doctor.DTOs;
using Hospital_Management_Web_Api.Models.Patient;
using Hospital_Management_Web_Api.Repositories;
using Hospital_Management_Web_Api.Repositories.Interface;
using Hospital_Management_Web_Api.Services.Interface;

namespace Hospital_Management_System_WebAPI.Services.ServiceImplementation
{
    public class DoctorService : IDoctorService
    {
        private readonly IDoctorRepository _doctorRepository;

        // Constructor: injects doctor repository for business operations
        public DoctorService(IDoctorRepository doctorRepository)
        {
            _doctorRepository = doctorRepository;
        }



        // Validates and adds a new doctor record via repository
        public async Task AddDoctorAsync(CreateDoctorDto dto)
        {
            if (string.IsNullOrWhiteSpace(dto.FullName))
                throw new Exception("Doctor name is required.");

            if (string.IsNullOrWhiteSpace(dto.Specialization))
                throw new Exception("Specialization is required.");

            if (dto.ConsultationFee <= 0)
                throw new Exception("Consultation fee must be greater than zero.");

            await _doctorRepository.AddDoctorAsync(dto);
        }

        // Retrieves all doctors from the repository
        public async Task<List<Doctor>> GetDoctorsAsync()
        {
            return await _doctorRepository.GetDoctorsAsync();
        }

        // Returns the underlying doctor repository instance (for internal use)
        public IDoctorRepository Get_doctorRepository1()
        {
            return _doctorRepository;
        }

        // Retrieves doctors filtered by specialization
        public async Task<List<Doctor>> GetDoctorsBySpecializationAsync(
            string specialization)
        {
            if (string.IsNullOrWhiteSpace(specialization))
                throw new Exception("Specialization is required.");

            return await _doctorRepository.GetDoctorsBySpecializationAsync(specialization);
        }


    }
}
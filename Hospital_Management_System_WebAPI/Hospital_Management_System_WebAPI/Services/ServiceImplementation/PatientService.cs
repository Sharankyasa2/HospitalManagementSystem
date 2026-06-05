using Hospital_Management_System_WebAPI.Models.DTOs.Patient;
using Hospital_Management_System_WebAPI.Models.POCO;
using Hospital_Management_Web_Api.Models.Patient.DTOs;
using Hospital_Management_Web_Api.Repositories.Interface;
using Hospital_Management_Web_Api.Services.Interface;
using System.ComponentModel.DataAnnotations;

namespace Hospital_Management_System_WebAPI.Services.ServiceImplementation
{
    public class PatientService : IPatientService
    {
        // getting the object of patient repository
        public readonly IPatientRepository _patientRepository;


        // Constructor: injects patient repository used for data access
        public PatientService(IPatientRepository patientRepository)
        {
            _patientRepository = patientRepository;
        }



        // Validates and adds a new patient record via repository
        public async Task<int> AddPatientAsync(CreatePatientDto dto)
        {
            if (dto.Phone.Length > 12)
            {
                throw new ValidationException(
                    "Phone number cannot exceed 12 characters.");
            }
            if (dto.DOB > DateTime.Today)
            {
                throw new Exception("DOB cannot be a future date...");
            }
            return await _patientRepository.AddPatientAsync(dto);
        }


        // Deactivates a patient record identified by patient code
        public async Task DeactivatePatientAsync(int patientCode)
        {
            await _patientRepository.DeactivatePatientAsync(patientCode);
        }


        // Retrieves all patients from the repository
        public async Task<List<Patient>> GetAllPatientsAsync()
        {
            return await _patientRepository.GetAllPatientsAsync();
        }


        // Updates an existing patient's details in the repository
        public async Task UpdatePatientAsync(int PatientCode, UpdatePatientDto dto)
        {
            await _patientRepository.UpdatePatientAsync(PatientCode, dto);
        }





        // Retrieves a single patient by id with not-found validation
        async Task<Patient> IPatientService.GetPatientByIdAsync(int patientCode)
        {
            var patient = await _patientRepository.GetPatientByIdAsync(patientCode);

            if (patient == null)
                throw new KeyNotFoundException($"Patient with ID {patientCode} not found.");

            return patient;
        }


    }
}
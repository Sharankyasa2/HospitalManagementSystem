using Hospital_Management_Web_Api.Models.Doctor.DTOs;
using Hospital_Management_Web_Api.Services;
using Hospital_Management_Web_Api.Services.Interface;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace Hospital_Management_Web_Api.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class DoctorController : ControllerBase
    {
        //doctor service dependency injection
        private readonly IDoctorService _doctorService;
        // Constructor: injects the doctor service used by the controller
        public DoctorController(IDoctorService doctorServices)
        {
            _doctorService = doctorServices;
        }



        //Doctor Registration Action Method
        // Registers a new doctor in the system
        [HttpPost]
        public async Task<IActionResult> AddDoctor(CreateDoctorDto dto)
        {
            int docCode = await _doctorService.AddDoctorAsync(dto);
            return StatusCode(201, $"Doctor added successfully with code : {docCode}");
        }

        //Method to send all Availabe Doctors
        // Retrieves all available doctors asynchronously
        [HttpGet("all")]
        public async Task<IActionResult> GetDoctors()
        {
            var doctors = await _doctorService.GetDoctorsAsync();

            return Ok(doctors);
        }

        [HttpGet("{DoctorCode}")]
        public async Task<IActionResult> GetDoctorByCode(int DoctorCode)
        {
            return Ok(await _doctorService.GetDoctorByCode(DoctorCode));
        }

        //Http Methods to get Doctors By Specialization and who are available
        // Retrieves doctors filtered by specialization
        [HttpGet("specialization/{specialization}")]
        public async Task<IActionResult> GetDoctorsBySpecialization(string specialization)
        {
            var doctors =
                await _doctorService
                .GetDoctorsBySpecializationAsync(specialization);

            return Ok(doctors);
        }

    }
}

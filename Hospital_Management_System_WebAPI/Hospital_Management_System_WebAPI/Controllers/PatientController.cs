using Hospital_Management_System_WebAPI.Models.DTOs.Patient;
using Hospital_Management_System_WebAPI.Models.POCO;
using Hospital_Management_System_WebAPI.Services;
using Hospital_Management_Web_Api.Models.Patient.DTOs;
using Hospital_Management_Web_Api.Services.Interface;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace Hospital_Management_Web_Api.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PatientController : ControllerBase
    {
        //Dependency Injection for patient and email service
        private readonly IPatientService _patientService;
        private readonly EmailService _emailService;
        // Constructor: injects patient and email services used by the controller
        public PatientController(IPatientService patientService, EmailService emailService)
        {
            _patientService = patientService;
            _emailService = emailService;
        }



        //Http Method to get all Patients
        // Retrieves all patients asynchronously and returns them in the response
        [HttpGet("all")]
        public async Task<IActionResult> GetAllPatients()
        {

            var patients = await _patientService.GetAllPatientsAsync();

            return Ok(patients);
        }

        //Http Method to Register new Patient
        // Registers a new patient and sends a confirmation email if provided
        [HttpPost]
        public async Task<ActionResult> AddPatient(CreatePatientDto dto)
        {
            int code = await _patientService.AddPatientAsync(dto);
            string? email = dto.Email;
            if (!string.IsNullOrWhiteSpace(email))
            {
                await _emailService.SendEmailAsync(
                    email,
                    "Registration Successful",
                    $@"
                    <html>
                        <body>
                            <h2>Welcome to SHARAN HOSPITALS</h2>

                            <p>Hello <strong>{dto.FullName}</strong>,</p>

                            <p>
                                Your registration was successfully completed on
                                <strong>{DateTime.Now:dd MMMM yyyy hh:mm tt}</strong>.
                            </p>
                            <p>Registration code created : {code}</p>
                            <p>Thank you for choosing us.</p>

                            <br/>

                            <p>Regards,</p>
                            <p><strong>SHARAN HOSPITALS</strong></p>
                        </body>
                    </html>");
            }
            return StatusCode(
                StatusCodes.Status201Created,//sending 201 code for creation successful
                $"Patient added successfully with Patient code {code}");
        }

        //http method to Update patient 
        // Updates an existing patient's details by patient code
        [HttpPut("{patientCode}")]
        public async Task<IActionResult> UpdatePatient(int patientCode, UpdatePatientDto dto)
        {
            await _patientService.UpdatePatientAsync(patientCode, dto);

            return NoContent(); //  standard for update
        }



        //Method to Deactivate a patient using patient code
        // Deactivates a patient account and optionally notifies them via email
        [HttpDelete("deactivate/{patientCode}")]
        public async Task DeactivatePatient(int patientCode)
        {
            var patient = await _patientService.GetPatientByIdAsync(patientCode);
            if(patient is not null)
            {
                if (!string.IsNullOrWhiteSpace(patient.Email))
                {
                    await _emailService.SendEmailAsync(
                        patient.Email,
                        "Account Deactivation Notice",
                        $@"
                    <html>
                    <body>
                        <h2>SHARAN HOSPITALS</h2>
                        <p>Hello <strong>{patient.FullName}</strong>,</p>

                        <p>Your account has been temporarily deactivated.</p>

                        <p>Thank you for your understanding.</p>

                        <br/>
                        <p>Regards,</p>
                        <p><strong>SHARAN HOSPITALS</strong></p>
                    </body>
                    </html>");
                }
            }
            await _patientService.DeactivatePatientAsync(patientCode);
        }

        //Active method to get patient by Id
        // Retrieves a single patient by their patient code
        [HttpGet("{patientCode}")]
        public async Task<IActionResult> GetPatientById(int patientCode)
        {

            var patient = await _patientService.GetPatientByIdAsync(patientCode);

            if (patient == null)
                throw new Exception("no patient exist with this patientId");
            return Ok(patient);

        }



    }


}

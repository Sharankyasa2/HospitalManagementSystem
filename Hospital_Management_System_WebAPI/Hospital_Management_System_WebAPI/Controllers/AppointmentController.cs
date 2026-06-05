using Hospital_Management_System_WebAPI.Models.DTOs.Appointment;
using Hospital_Management_System_WebAPI.Models.POCO;
using Hospital_Management_System_WebAPI.Services;
using Hospital_Management_Web_Api.Services.Interface;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace Hospital_Management_Web_Api.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AppointmentController : ControllerBase
    {
        //Dependency injection for appointment services
        private readonly IAppointmentService _service;
        private readonly IPatientService _patService;
        private readonly IDoctorService _doctorService;
        private readonly EmailService _emailService;

        // Constructor: injects appointment service used to manage appointments
        public AppointmentController(IAppointmentService service, IDoctorService doctorService, IPatientService patService, EmailService emailservice)
        {
            _service = service;
            _patService = patService;
            _emailService = emailservice;
            _doctorService = doctorService;
        }

        //Action method to book appointments
        // Books a new appointment and returns 201 when successful
        [HttpPost("book")]
        public async Task<IActionResult> BookAppointment(BookAppointmentDto dto)
        {
            int apptCode = await _service.BookAppointmentAsync(dto);
            DateTime appdate = dto.AppointmentDate;
            var patient = await _patService.GetPatientByIdAsync(dto.PatientCode);
            var doctor = await _doctorService.GetDoctorByCode(dto.DoctorCode);
            if (patient is not null && doctor is not null)
            {
                if (!string.IsNullOrWhiteSpace(patient.Email))
                {
                    await _emailService.SendEmailAsync(
                        patient.Email,
                        "Appointment Confirmation Notice",
                        $@"
                    <html>
                    <body>
                        <h2>SHARAN HOSPITALS</h2>

                        <p>Hello <strong>{patient.FullName}</strong>,</p>

                        <p>Your Appointment has been has been booked Successfully on,</p>
                        
                        <strong>{appdate:dd MMMM yyyy hh:mm tt}</strong>.

                        <p>with {doctor.FullName} ({doctor.Specialization})</p>

                        <p>Registration Code : {apptCode}</p>

                        <p>Thank you for your understanding.</p>

                        <br/>

                        <p>Regards,</p>

                        <p><strong>SHARAN HOSPITALS</strong></p>

                    </body>

                    </html>");
                }
            }
            return StatusCode(201, $"Appointment booked successfully with Code : {apptCode}");
        }

        //action methods to cancel the appointments and return mail confirmation
        [HttpDelete("cancel/{id}")]
        public async Task<IActionResult> CancelAppointment(int id)
        {
            await _service.CancelAppointmentAsync(id);
            var apt = await _service.GetAppointmentByIdAsync(id);
            var patient = await _patService.GetPatientByIdAsync(apt.PatientCode);
            var doctor = await _doctorService.GetDoctorByCode(apt.DoctorCode);
            if(patient is not null && doctor is not null)
            {
                if (!string.IsNullOrWhiteSpace(patient.Email))
                {
                    await _emailService.SendEmailAsync(
                        patient.Email,
                        "Appointment Cancellation Notice",
                        $@"
                    <html>
                    <body>
                        <h2>SHARAN HOSPITALS</h2>

                        <p>Hello <strong>{patient.FullName}</strong>,</p>

                        <p>Your Appointment on <strong>{apt.AppointmentDate:dd MMMM yyyy hh:mm tt}</strong>.</p>                                         
                        

                        <p>with {doctor.FullName} ({doctor.Specialization})</p>

                        <p>has been has been <strong>Cancelled Successfully</strong>.</p> 

                        <br/>

                        <p>Regards,</p>

                        <p><strong>SHARAN HOSPITALS</strong></p>

                    </body>

                    </html>");
                }
            }

            return Ok("Appointment cancelled successfully");
        }

        //Action method to get all upcoming appointments which are scheduled but nto completed
        // retrieves all upcoming appointments that are scheduled but not completed
        [HttpGet("upcoming-appointments")]
        public async Task<IActionResult> GetUpcoming()
        {
            var data = await _service.GetUpcomingAppointmentsAsync();
            return Ok(data);
        }

        //action method to get appointments of individual doctor using doctor code
        // Retrieves all appointments scheduled for a specific doctor
        [HttpGet("doctor/{doctorCode}")]
        public async Task<IActionResult> GetDoctorAppointments(int doctorCode)
        {
            var data = await _service.GetDoctorAppointmentsAsync(doctorCode);
            return Ok(data);
        }

        [HttpGet("{AppointmentId}")]
        public async Task<IActionResult> GetAppointmentById(int AppointmentId)
        {
            var appt = await _service.GetAppointmentByIdAsync(AppointmentId);
            return Ok(appt);
        }
    }
}
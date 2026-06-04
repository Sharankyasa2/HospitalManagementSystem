using Hospital_Management_System_WebAPI.Models.DTOs.Appointment;
using Hospital_Management_Web_Api.Services.Interface;
using Microsoft.AspNetCore.Mvc;

namespace Hospital_Management_Web_Api.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ReportController : ControllerBase
    {
        private readonly IReportService _reportService;

        // Constructor: injects report service for generating various reports
        public ReportController(IReportService reportService)
        {
            _reportService = reportService;
        }


        //Action method to get appointment report
        // Retrieves a detailed appointment report for analysis
        [HttpGet("appointments")]
        public async Task<IActionResult> GetAppointmentReport()
        {
            List<AppointmentReportDto> reports =
                await _reportService.GetAppointmentReportAsync();

            return Ok(reports);
        }

        //action method to get revenue by specialization
        // Retrieves total revenue grouped by doctor specialization
        [HttpGet("revenue-by-specialization")]
        public async Task<IActionResult> GetRevenueBySpecialization()
        {
            List<RevenueBySpecializationDto> reports =
                await _reportService.GetRevenueBySpecializationAsync();

            return Ok(reports);
        }

        //action method to get all doctors who are currently not available
        // Retrieves doctors who have more than two active appointments
        [HttpGet("busy-doctors")]
        public async Task<IActionResult> GetDoctorsWithMoreThan2Appointments()
        {
            List<DoctorAppointmentStatsDto> reports =
                await _reportService.GetDoctorsWithMoreThan2AppointmentsAsync();

            return Ok(reports);
        }
    }
}

using Hospital_Management_Web_Api.Repositories.Interface;
using Microsoft.Data.SqlClient;
using System.Data;
using Hospital_Management_Web_Api.Helpers;
using Hospital_Management_System_WebAPI.Models.POCO;
using Hospital_Management_System_WebAPI.Models.DTOs.Appointment;

namespace Hospital_Management_System_WebAPI.Repository.ServiceImplementation
{
    public class AppointmentRepository : IAppointmentRepository
    {
        private readonly DbHelper _dbHelper;

        public AppointmentRepository(DbHelper dbHelper)
        {
            _dbHelper = dbHelper;
        }


        // Books an appointment record in the database via stored procedure
        public async Task BookAppointmentAsync(BookAppointmentDto dto)
        {
            using SqlConnection con = _dbHelper.GetConnection();

            using SqlCommand cmd = new("sp_BookAppointment", con);

            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.AddWithValue("@PatientCode", dto.PatientCode);
            cmd.Parameters.AddWithValue("@DoctorCode", dto.DoctorCode);
            cmd.Parameters.AddWithValue("@AppointmentDate", dto.AppointmentDate);

            await con.OpenAsync();
            await cmd.ExecuteNonQueryAsync();
        }

        // Cancels an appointment record identified by appointment id
        public async Task CancelAppointmentAsync(int appointmentId)
        {
            using SqlConnection con = _dbHelper.GetConnection();

            using SqlCommand cmd = new("sp_CancelAppointment", con);

            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@AppointmentId", appointmentId);

            await con.OpenAsync();
            await cmd.ExecuteNonQueryAsync();
        }
      

        // Retrieves upcoming appointments and updates completed status first
        public async Task<List<Appointment>> GetUpcomingAppointmentsAsync()
        {
            List<Appointment> appointments = new();

            using SqlConnection con = _dbHelper.GetConnection();

            await con.OpenAsync();

            await UpdateCompletedAppointmentsAsync(con);

            using SqlCommand cmd = new("sp_GetUpcomingAppointments", con);

            cmd.CommandType = CommandType.StoredProcedure;

            using SqlDataReader reader = await cmd.ExecuteReaderAsync();

            while (await reader.ReadAsync())
            {
                appointments.Add(MapAppointment(reader));
            }

            return appointments;
        }

        // Retrieves appointments for a specified doctor after updating statuses
        public async Task<List<Appointment>> GetDoctorAppointmentsAsync(int doctorCode)
        {
            List<Appointment> appointments = new();

            using SqlConnection con = _dbHelper.GetConnection();

            await con.OpenAsync();

            await UpdateCompletedAppointmentsAsync(con);

            using SqlCommand cmd = new("sp_GetDoctorAppointments", con);

            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@DoctorCode", doctorCode);

            using SqlDataReader reader = await cmd.ExecuteReaderAsync();

            while (await reader.ReadAsync())
            {
                appointments.Add(MapAppointment(reader));
            }

            return appointments;
        }

        // Retrieves appointments for a specified patient after updating statuses
        public async Task<List<Appointment>> GetPatientAppointmentsAsync(int patientCode)
        {
            List<Appointment> appointments = new();

            using SqlConnection con = _dbHelper.GetConnection();

            await con.OpenAsync();

            await UpdateCompletedAppointmentsAsync(con);

            using SqlCommand cmd = new("sp_GetPatientAppointments", con);

            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@PatientCode", patientCode);

            using SqlDataReader reader = await cmd.ExecuteReaderAsync();

            while (await reader.ReadAsync())
            {
                appointments.Add(MapAppointment(reader));
            }

            return appointments;
        }

        // Runs a stored procedure to mark completed appointments in DB
        private async Task UpdateCompletedAppointmentsAsync(SqlConnection con)
        {
            using SqlCommand cmd = new("sp_UpdateCompletedAppointments", con);

            cmd.CommandType = CommandType.StoredProcedure;

            await cmd.ExecuteNonQueryAsync();
        }

        // Maps a data reader row to an Appointment POCO
        private Appointment MapAppointment(SqlDataReader reader)
        {
            return new Appointment
            {
                AppointmentId = Convert.ToInt32(reader["AppointmentId"]),
                PatientCode = Convert.ToInt32(reader["PatientCode"]),
                DoctorCode = Convert.ToInt32(reader["DoctorCode"]),
                AppointmentDate = Convert.ToDateTime(reader["AppointmentDate"]),
                AppointmentStatus = reader["AppointmentStatus"].ToString()!,

                CancelledAt =
                    reader["CancelledAt"] == DBNull.Value
                    ? null
                    : Convert.ToDateTime(reader["CancelledAt"])
            };
        }
    }
}
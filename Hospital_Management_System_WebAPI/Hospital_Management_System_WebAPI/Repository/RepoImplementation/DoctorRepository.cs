using System.Data;
using Microsoft.Data.SqlClient;
using Hospital_Management_Web_Api.Helpers;
using Hospital_Management_Web_Api.Models.Doctor.DTOs;
using Hospital_Management_Web_Api.Repositories.Interface;
using Hospital_Management_System_WebAPI.Models.POCO;

namespace Hospital_Management_System_WebAPI.Repository.ServiceImplementation
{
    public class DoctorRepository : IDoctorRepository
    {
        private readonly DbHelper _dbHelper;

        public DoctorRepository(DbHelper dbHelper)
        {
            _dbHelper = dbHelper;
        }


        // Adds a new doctor record to the database using a stored procedure
        public async Task AddDoctorAsync(CreateDoctorDto dto)
        {
            using SqlConnection con = _dbHelper.GetConnection();

            using SqlCommand cmd =
                new SqlCommand("sp_AddDoctor", con);

            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.AddWithValue("@FullName", dto.FullName);
            cmd.Parameters.AddWithValue("@Specialization", dto.Specialization);
            cmd.Parameters.AddWithValue("@Phone", dto.Phone);
            cmd.Parameters.AddWithValue("@ConsultationFee", dto.ConsultationFee);

            await con.OpenAsync();

            int rows = await cmd.ExecuteNonQueryAsync();

            if (rows == 0)
            {
                throw new Exception("Doctor could not be added.");
            }
        }


        // Maps a data reader row to a Doctor POCO
        private Doctor MapDoctor(SqlDataReader reader)
        {
            return new Doctor
            {
                DoctorCode = Convert.ToInt32(reader["DoctorCode"]),
                FullName = reader["FullName"].ToString()!,
                Specialization = reader["Specialization"].ToString()!,
                Phone = reader["Phone"].ToString()!,
                ConsultationFee = Convert.ToDecimal(reader["ConsultationFee"]),
                IsAvailable = Convert.ToBoolean(reader["IsAvailable"]),
                CreatedAt = reader["CreatedAt"] == DBNull.Value
    ? DateTime.MinValue
    : Convert.ToDateTime(reader["CreatedAt"]),

                UpdatedAt = reader["UpdatedAt"] == DBNull.Value
    ? null
    : Convert.ToDateTime(reader["UpdatedAt"])
            };
        }

        // Retrieves all doctors from the database
        public async Task<List<Doctor>> GetDoctorsAsync()
        {
            List<Doctor> doctors = new();

            using SqlConnection con = _dbHelper.GetConnection();

            using SqlCommand cmd =
                new SqlCommand("sp_GetDoctors", con);

            cmd.CommandType = CommandType.StoredProcedure;

            await con.OpenAsync();

            using SqlDataReader reader =
                await cmd.ExecuteReaderAsync();

            while (await reader.ReadAsync())
            {
                doctors.Add(MapDoctor(reader));

            }

            return doctors;
        }

        // Retrieves doctors filtered by specialization using stored procedure
        public async Task<List<Doctor>> GetDoctorsBySpecializationAsync(
            string specialization)
        {
            List<Doctor> doctors = new();

            using SqlConnection con = _dbHelper.GetConnection();

            using SqlCommand cmd =
                new SqlCommand("sp_GetDoctorsBySpecialization", con);

            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.AddWithValue(
                "@Specialization",
                specialization);

            await con.OpenAsync();

            using SqlDataReader reader =
                await cmd.ExecuteReaderAsync();

            while (await reader.ReadAsync())
            {
                doctors.Add(MapDoctor(reader));

            }

            return doctors;
        }
    }
}
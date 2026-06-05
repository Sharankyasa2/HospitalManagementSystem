using Hospital_Management_System_WebAPI.Models.DTOs.Patient;
using Hospital_Management_System_WebAPI.Models.POCO;
using Hospital_Management_Web_Api.Helpers;
using Hospital_Management_Web_Api.Models.Patient.DTOs;
using Hospital_Management_Web_Api.Repositories.Interface;
using Microsoft.Data.SqlClient;
using System.Data;
using System.Numerics;

namespace Hospital_Management_System_WebAPI.Repository.ServiceImplementation
{
    public class PatientRepository : IPatientRepository
    {

        private readonly DbHelper _dbHelper;

        // Constructor: injects DbHelper used to create database connections
        public PatientRepository(DbHelper dbHelper)
        {
            _dbHelper = dbHelper;
        }




        // Adds a new patient record to the database using a stored procedure
        public async Task<int> AddPatientAsync(CreatePatientDto dto)
        {
            int code = 0;
            try
            {
                using (SqlConnection con = _dbHelper.GetConnection())
                {
                    SqlCommand cmd = new SqlCommand("sp_AddPatient", con);
                    cmd.Parameters.AddWithValue("@FullName", dto.FullName);
                    cmd.Parameters.AddWithValue("@DOB", dto.DOB);
                    cmd.Parameters.AddWithValue("@Gender", dto.Gender);
                    cmd.Parameters.AddWithValue("@Phone", dto.Phone);
                    cmd.Parameters.AddWithValue("@Email", dto.Email ?? (object)DBNull.Value);

                    cmd.CommandType = CommandType.StoredProcedure;
                    await con.OpenAsync();
                    code = Convert.ToInt32(await cmd.ExecuteScalarAsync());

                    if (code == 0)
                    {
                        throw new Exception("Failed to add patient.");
                    }
                }
            }
            catch (Exception)
            {
                throw;
            }
            return code;

        }


        // Deactivates a patient record identified by patient code
        public async Task DeactivatePatientAsync(int patientCode)
        {
            try
            {
                using (SqlConnection con = _dbHelper.GetConnection())
                {
                    SqlCommand cmd = new SqlCommand("sp_DeactivatePatient", con);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@PatientCode", patientCode);
                    await con.OpenAsync();
                    int rowsAffected = await cmd.ExecuteNonQueryAsync();

                    if (rowsAffected == 0)
                    {
                        throw new Exception("Failed to deactivate patient.");
                    }
                }
            }
            catch (Exception)
            {
                throw;
            }
        }



        // Updates patient details in the database using stored procedure
        public async Task UpdatePatientAsync(int patientCode, UpdatePatientDto dto)
        {
            try
            {
                using (SqlConnection con = _dbHelper.GetConnection())
                {
                    SqlCommand cmd = new SqlCommand("sp_UpdatePatient", con);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@PatientCode", patientCode);
                    cmd.Parameters.AddWithValue("@FullName", dto.FullName);
                    cmd.Parameters.AddWithValue("@DOB", dto.DOB);

                    cmd.Parameters.AddWithValue("@Gender", dto.Gender);

                    cmd.Parameters.AddWithValue("@Phone", dto.Phone);

                    cmd.Parameters.AddWithValue("@Email", dto.Email);

                    cmd.CommandType = CommandType.StoredProcedure;
                    await con.OpenAsync();
                    var rowsAffected = await cmd.ExecuteNonQueryAsync();

                    if (rowsAffected == 0)
                    {
                        throw new Exception("Failed to add patient.");
                    }

                }

            }
            catch (Exception)
            {
                throw;
            }


        }
        // Retrieves all patients from database (explicit interface impl.)
        async Task<List<Patient>> IPatientRepository.GetAllPatientsAsync()
        {
            using (SqlConnection con = _dbHelper.GetConnection())
            {
                List<Patient> patients = new List<Patient>();

                SqlCommand cmd = new SqlCommand("sp_GetAllPatients", con);
                cmd.CommandType = CommandType.StoredProcedure;
                con.Open();

                SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    patients.Add(new Patient
                    {
                        PatientCode = Convert.ToInt32(reader["PatientCode"]),
                        FullName = reader["FullName"].ToString(),
                        DOB = Convert.ToDateTime(reader["DOB"]),
                        Gender = reader["Gender"].ToString(),
                        Phone = reader["Phone"].ToString(),
                        Email = reader["Email"]?.ToString(),
                        IsActive = Convert.ToBoolean(reader["IsActive"])
                    });
                }
                return patients;
            }
        }

        // Retrieves a single patient by id from database (explicit interface impl.)
        async Task<Patient?> IPatientRepository.GetPatientByIdAsync(int patientCode)
        {
            try
            {
                using (SqlConnection con = _dbHelper.GetConnection())
                {
                    SqlCommand cmd = new SqlCommand("sp_GetPatientById", con);
                    cmd.Parameters.AddWithValue("@PatientCode", patientCode);
                    cmd.CommandType = CommandType.StoredProcedure;
                    await con.OpenAsync();
                    using (SqlDataReader reader = await cmd.ExecuteReaderAsync())
                    {
                        if (await reader.ReadAsync())
                        {
                            return new Patient
                            {
                                PatientCode = Convert.ToInt32(reader["PatientCode"]),
                                FullName = reader["FullName"].ToString(),
                                DOB = Convert.ToDateTime(reader["DOB"]),
                                Gender = reader["Gender"].ToString(),
                                Phone = reader["Phone"].ToString(),
                                Email = reader["Email"]?.ToString(),
                                IsActive = Convert.ToBoolean(reader["IsActive"])
                            };
                        }
                        return null;
                    }
                }
            }
            catch (Exception)
            {
                throw;
            }
        }
    }
}
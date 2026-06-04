using Microsoft.Data.SqlClient;

namespace Hospital_Management_Web_Api.Helpers
{
    public class DbHelper
    {
        private readonly IConfiguration _configuration;

        // Constructor: injects configuration used to read connection strings
        public DbHelper(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        // Creates and returns a new SqlConnection using configured connection string
        public SqlConnection GetConnection()
        {
            return new SqlConnection(
                _configuration.GetConnectionString("DefaultConnection"));
        }
    }
}
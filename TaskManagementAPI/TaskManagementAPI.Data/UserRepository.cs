using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Threading.Tasks;
using TaskManagementAPI.Data.Dto;

namespace TaskManagementAPI.Data
{
    public class UserRepository
    {
        private readonly string _connectionString = ConfigurationManager.ConnectionStrings["TaskManagementDB"].ConnectionString;

        public async Task<UserDto> AuthenticateUserAsync(string userName, string password)
        {
            UserDto user = null;
            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                SqlCommand cmd = new SqlCommand("AuthenticateUser", conn)
                {
                    CommandType = CommandType.StoredProcedure
                };
                cmd.Parameters.AddWithValue("@UserName", userName);
                cmd.Parameters.AddWithValue("@Password", password);

                conn.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (await reader.ReadAsync())
                    {
                        user = new UserDto
                        {
                            UserId = (int)reader["UserId"],
                            FullName = reader["FullName"].ToString(),
                            UserName = reader["UserName"].ToString()
                        };
                    }
                }
                return user;
            }
        }
        public async Task<List<UserDto>> GetAllUsersAsync()
        {
            var users = new List<UserDto>();
            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                SqlCommand cmd = new SqlCommand("GetAllUsers", conn)
                {
                    CommandType = CommandType.StoredProcedure
                };
                conn.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (await reader.ReadAsync())
                    {
                        users.Add(new UserDto
                        {
                            UserId = (int)reader["UserId"],
                            FullName = reader["FullName"].ToString()
                        });
                    }
                }
            }
            return users;
        }
    }

}

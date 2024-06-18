using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Threading.Tasks;
using TaskManagementAPI.Data.Dto;


namespace TaskManagementAPI.Data
{
    /// <summary>
    /// Get/Save Task data to Database
    /// </summary>
    public class TaskRepository
    {
        readonly string _connectionString = ConfigurationManager.ConnectionStrings["TaskManagementDB"].ConnectionString;
        public async Task<List<TaskDto>> GetTasksAsync(int userId)
        {
            var tasks = new List<TaskDto>();
            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                SqlCommand cmd = new SqlCommand("GetTasks", conn)
                {
                    CommandType = CommandType.StoredProcedure
                };
                cmd.Parameters.AddWithValue("@UserId", userId);

                conn.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (await reader.ReadAsync())
                    {
                        tasks.Add(new TaskDto
                        {
                            TaskId = (int)reader["TaskId"],
                            UserId = (int)reader["UserId"],
                            TaskName = reader["TaskName"].ToString(),
                            AssignTo = reader["AssignTo"].ToString(),
                            StatusName = reader["StatusName"].ToString(),
                            TaskDescription = reader["TaskDescription"].ToString() 
                        });
                    }
                }
            }
            return  tasks;
        }

        public async Task<TaskDto> GetTaskAsync(int userId, int taskId)
        {

            TaskDto task = null;
            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                SqlCommand cmd = new SqlCommand("GetTask", conn)
                {
                    CommandType = CommandType.StoredProcedure
                };
                cmd.Parameters.AddWithValue("@UserId", userId);
                cmd.Parameters.AddWithValue("@TaskId", taskId);

                conn.Open();
                using (SqlDataReader reader = await cmd.ExecuteReaderAsync())
                {
                    if (reader.Read())
                    {
                        task = new TaskDto
                        {
                            TaskId = reader.GetInt32(reader.GetOrdinal("TaskId")),
                            UserId = reader.GetInt32(reader.GetOrdinal("UserId")),
                            TaskName = reader.GetString(reader.GetOrdinal("TaskName")),
                            StatusId = reader.GetInt32(reader.GetOrdinal("StatusId")),
                            TaskDescription = reader.IsDBNull(reader.GetOrdinal("TaskDescription")) ? null : reader.GetString(reader.GetOrdinal("TaskDescription"))
                        };
                    }
                }
            }
            return task;
        }
    
        public async Task AddTaskAsync(int userId, string taskName, string taskDescription, int statusId, int createdById)
        {
            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                SqlCommand cmd = new SqlCommand("CreateTask", conn)
                {
                    CommandType = CommandType.StoredProcedure
                };
                cmd.Parameters.AddWithValue("@UserId", userId);
                cmd.Parameters.AddWithValue("@TaskName", taskName);
                cmd.Parameters.AddWithValue("@TaskDescription", taskDescription);
                cmd.Parameters.AddWithValue("@StatusId", statusId);
                cmd.Parameters.AddWithValue("@CreatedByUserId", createdById);

                conn.Open();
                await cmd.ExecuteReaderAsync();
            }
        }

        public async Task UpdateTaskAsync(int taskId, int userId, string taskName, string taskDescription, int statusId, int lastUpdatedByUserId)
        {
            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                SqlCommand cmd = new SqlCommand("UpdateTask", conn)
                {
                    CommandType = CommandType.StoredProcedure
                };
                cmd.Parameters.AddWithValue("@TaskId", taskId);
                cmd.Parameters.AddWithValue("@UserId", userId);
                cmd.Parameters.AddWithValue("@TaskName", taskName);
                cmd.Parameters.AddWithValue("@TaskDescription", taskDescription);
                cmd.Parameters.AddWithValue("@StatusId", statusId);
                cmd.Parameters.AddWithValue("@LastUpdatedByUserId", lastUpdatedByUserId);

                conn.Open();
                await cmd.ExecuteNonQueryAsync();
            }
        }

        public async Task DeleteTaskAsync(int userId, int taskId)
        {
            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                SqlCommand cmd = new SqlCommand("DeleteTask", conn)
                {
                    CommandType = CommandType.StoredProcedure
                };
                cmd.Parameters.AddWithValue("@UserId", userId);
                cmd.Parameters.AddWithValue("@TaskId", taskId);

                conn.Open();
               await cmd.ExecuteNonQueryAsync();
            }
        }

        public async Task<List<TaskCountDto>> GetTaskCountByUserAsync()
        {
            var tasksCount = new List<TaskCountDto>();
            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                SqlCommand cmd = new SqlCommand("GetTaskCountByUser", conn)
                {
                    CommandType = CommandType.StoredProcedure
                };
                conn.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (await reader.ReadAsync())
                    {
                        tasksCount.Add(new TaskCountDto
                        {
                            FullName = reader["FullName"].ToString(),
                            TaskCount = (int)reader["TaskCount"]
                         
                        });
                    }
                }
            }
            return tasksCount;
        }

        public async Task<List<TaskStatusDto>> GetAllTaskStatusAsync()
        {
            var tasksStatus = new List<TaskStatusDto>();
            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                SqlCommand cmd = new SqlCommand("GetAllTasksStatus", conn)
                {
                    CommandType = CommandType.StoredProcedure
                };
                conn.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (await reader.ReadAsync())
                    {
                        tasksStatus.Add(new TaskStatusDto
                        {
                            StatusId = (int)reader["StatusId"],
                            StatusName = reader["StatusName"].ToString()
                        });
                    }
                }
            }
            return tasksStatus;
        }
    }
}

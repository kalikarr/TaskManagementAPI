using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Threading.Tasks;
using TaskManagementAPI.Data.Dto;


namespace TaskManagementAPI.Data
{
    /// <summary>Get/Save Task data to Database</summary>
    public class TaskRepository
    {
        readonly string _connectionString = ConfigurationManager.ConnectionStrings["TaskManagementDB"].ConnectionString;

        #region Public async methods 
        /// <summary>Gets the tasks asynchronous.</summary>
        /// <param name="userId">The user identifier.</param>
        /// <returns>
        ///  list of tasks 
        /// </returns>
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
            return tasks;
        }

        /// <summary>Gets the task asynchronous.</summary>
        /// <param name="userId">The user identifier.</param>
        /// <param name="taskId">The task identifier.</param>
        /// <returns>
        ///   task
        /// </returns>
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

        /// <summary>Adds the task asynchronous.</summary>
        /// <param name="userId">The user identifier.</param>
        /// <param name="taskName">Name of the task.</param>
        /// <param name="taskDescription">The task description.</param>
        /// <param name="statusId">The status identifier.</param>
        /// <param name="createdById">The created by identifier.</param>
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

        /// <summary>Updates the task asynchronous.</summary>
        /// <param name="taskId">The task identifier.</param>
        /// <param name="userId">The user identifier.</param>
        /// <param name="taskName">Name of the task.</param>
        /// <param name="taskDescription">The task description.</param>
        /// <param name="statusId">The status identifier.</param>
        /// <param name="lastUpdatedByUserId">The last updated by user identifier.</param>
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

        /// <summary>Deletes the task asynchronous.</summary>
        /// <param name="userId">The user identifier.</param>
        /// <param name="taskId">The task identifier.</param>
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

        /// <summary>Gets the task count by user asynchronous.</summary>
        /// <returns>
        ///  Task count for users
        /// </returns>
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

        /// <summary>Gets all task status asynchronous.</summary>
        /// <returns>
        ///   List of task status
        /// </returns>
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

        #endregion
    }
}
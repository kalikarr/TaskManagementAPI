
using OfficeOpenXml;
using System;
using System.IO;
using System.Net.Http.Headers;
using System.Net.Http;
using System.Net;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Http.Cors;
using TaskManagementAPI.Data;
using TaskManagementAPI.Extensions;
using TaskManagementAPI.Helpers;
using TaskManagementAPI.Models;
using TaskManagementAPI.Filter;
namespace TaskManagementAPI.Controllers
{
    [JwtAuthorize]

    [EnableCors(origins: "*", headers: "*", methods: "*")]
    [RoutePrefix("api/tasks")]
    public class TaskController : ApiController
    {
        private readonly TaskRepository _taskRepository;

        public TaskController()
        {
            _taskRepository = new TaskRepository();
        }

        [HttpGet, Route("{userId}")]
        public async Task<IHttpActionResult> GetTasks(int userId)
        {
            try
            {
                userId.ThrowIf(x => x <= 0, "User Id must be > 0");

                var tasks = await _taskRepository.GetTasksAsync(userId);

                return Json(tasks);

            }
            catch (Exception exc)
            {
                exc.HandleError();
                return BadRequest("Unable to fetch the tasks for the user");
            }

        }

        [HttpGet, Route("{userId}/{taskId}")]
        public async Task<IHttpActionResult> GetTask(int userId, int taskId)
            {
            try
            {
                userId.ThrowIf(x => x <= 0, "User Id must be > 0");
                taskId.ThrowIf(x => x <= 0, "Task Id must be > 0");

                var task = await _taskRepository.GetTaskAsync(userId, taskId);
                if (task == null)
                {
                    return BadRequest();
                }
                return Json(task);
            }
            catch (Exception exc)
            {
                exc.HandleError();
                return BadRequest("Unable to fetch the task");
            }
        }

        [HttpPost, Route("createTask")]
        public async Task<IHttpActionResult> AddTask(TaskModel task)
        {
            try
            {
                task.ThrowIfNull("Task Model cannot be null");

                await _taskRepository.AddTaskAsync(task.UserId, task.TaskName, task.TaskDescription, task.CreatedById);
                return Ok();
            }
            catch (Exception exc)
            {
                exc.HandleError();
                return BadRequest("Unable to create a task");
            }
        }

        [HttpPut, Route("updateTask")]
        public async Task<IHttpActionResult> UpdateTask(TaskModel task)
        {
            try
            {
                task.ThrowIfNull("Task Model cannot be null");
                await _taskRepository.UpdateTaskAsync(task.TaskId, task.UserId ,task.TaskName, task.TaskDescription, task.StatusId, task.LastUpdatedByUserId);
                return Ok();
            }
            catch (Exception exc)
            {
                exc.HandleError();
                return BadRequest("Unable to UpdateTask the tasksr");
            }
        }

        [HttpDelete, Route("deleteTask/{userId}/{taskId}")]
        public async Task<IHttpActionResult> DeleteTask(int userId, int taskId)
        {
            try
            {
                userId.ThrowIf(x => x <= 0, "User Id must be > 0");
                taskId.ThrowIf(x => x <= 0, "Task Id must be > 0");

                await _taskRepository.DeleteTaskAsync(userId, taskId);
                return Ok();
            }
            catch (Exception exc)
            {
                exc.HandleError();
                return BadRequest("Unable to delete the tasks");
            }
        }
        [HttpGet, Route("getTaskCountByUser")]
        public async Task<IHttpActionResult> GetTaskCountByUser()
        {
            try
            {
                var tasksCount = await _taskRepository.GetTaskCountByUserAsync();

                return Json(tasksCount);

            }
            catch (Exception exc)
            {
                exc.HandleError();
                return BadRequest("Unable to fetch the tasks for the user");
            }

        }

        [HttpGet, Route("getalltaskstatus")]
        public async Task<IHttpActionResult> GetallTaskStatus()
        {
            try
            {
                var statuses = await _taskRepository.GetAllTaskStatusAsync();

                return Json(statuses);

            }
            catch (Exception exc)
            {
                exc.HandleError();
                return BadRequest("Unable to fetch the tasks for the user");
            }

        }

        [HttpGet, Route("export/{userId}")]
        public async Task<HttpResponseMessage> Export(int userId)
        {
            try
            {

                var tasks = await _taskRepository.GetTasksAsync(userId);
                ExcelPackage.LicenseContext = LicenseContext.NonCommercial;
                using (var package = new ExcelPackage())
            {
                var worksheet = package.Workbook.Worksheets.Add("Tasks");
                worksheet.Cells["A1"].Value = "Task ID";
                worksheet.Cells["B1"].Value = "Task Name";
                worksheet.Cells["C1"].Value = "Task Description";

                var row = 2;
                foreach (var task in tasks)
                {
                    worksheet.Cells[row, 1].Value = task.TaskId;
                    worksheet.Cells[row, 2].Value = task.TaskName;
                    worksheet.Cells[row, 3].Value = task.TaskDescription;
                    row++;
                }

                var memoryStream = new MemoryStream();
                package.SaveAs(memoryStream);
                memoryStream.Position = 0;

                var result = new HttpResponseMessage(HttpStatusCode.OK)
                {
                    Content = new ByteArrayContent(memoryStream.ToArray())
                };
                result.Content.Headers.ContentDisposition = new ContentDispositionHeaderValue("attachment")
                {
                    FileName = "Tasks.xlsx"
                };
                result.Content.Headers.ContentType = new MediaTypeHeaderValue("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");

                return result;
            }
            }
            catch (Exception exc)
            {
                exc.HandleError();
                return new HttpResponseMessage(HttpStatusCode.BadRequest);
            }
        }
    }
}

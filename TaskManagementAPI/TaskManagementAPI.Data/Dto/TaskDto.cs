using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TaskManagementAPI.Data.Dto
{
    public class TaskDto
    {
        public int TaskId { get; set; }
        public int UserId { get; set; }
        public int StatusId { get; set; }
        public string TaskName { get; set; }
        public string AssignTo { get; set; }
        public string StatusName { get; set; }
        public string TaskDescription { get; set; }
    }

}
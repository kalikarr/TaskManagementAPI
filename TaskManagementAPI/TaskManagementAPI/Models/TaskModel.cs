using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TaskManagementAPI.Models
{
    public class TaskModel
    {
        public int TaskId { get; set; }
        public int UserId { get; set; }
        public string TaskName { get; set; }
        public int StatusId { get; set; }
        public string TaskDescription { get; set; }
        public int CreatedById { get; set; }
        public int LastUpdatedByUserId { get; set; }
        
    }
}
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TaskManagementAPI.Data.Dto
{
    public class TaskCountDto
    {
        public int UserId { get; set; }
        public int TaskCount { get; set; }
    }

}
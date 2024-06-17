using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TaskManagementAPI.Data.Dto
{
    public class UserDto
    {
        public int UserId { get; set; }
        public string FullName { get; set; }
        public string UserName { get; set; }
        
    }
}
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TaskManagementAPI.Helpers
{
    public static class ExceptionHelper
    {
        private static readonly NLog.Logger Logger = NLog.LogManager.GetCurrentClassLogger();

        public static void HandleError(this Exception ex)
        {
            Logger.Error(ex);
        }
       
    }
}
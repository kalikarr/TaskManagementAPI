using System;

namespace TaskManagementAPI.Helpers
{
    /// <summary>
    /// Static helper classs
    /// </summary>
    public static class ExceptionHelper
    {
        private static readonly NLog.Logger Logger = NLog.LogManager.GetCurrentClassLogger();

        /// <summary>
        /// Handles the error.
        /// </summary>
        /// <param name="ex">The ex.</param>
        public static void HandleError(this Exception ex)
        {
            Logger.Error(ex);
        }
    }
}
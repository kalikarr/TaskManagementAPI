using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Web;

namespace TaskManagementUI.Helpers
{
    public static class Helper
    {
        /// <summary>
        /// Gets the API base URL from the Web.config file.
        /// </summary>
        /// <returns>The API base URL as a string.</returns>
        public static string GetApiBaseUrl()
        {
            return ConfigurationManager.AppSettings["ApiBaseUrl"];
        }
        /// <summary>
        /// Hash the string using sha256
        /// </summary>
        /// <param name="text"></param>
        /// <returns>Hashed String</returns>
        public static string GetHashString(string text)
        {
            using (SHA256 sha256 = SHA256.Create())
            {
                byte[] bytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(text));
                StringBuilder builder = new StringBuilder();
                foreach (byte b in bytes)
                {
                    builder.Append(b.ToString("x2"));
                }
                return builder.ToString();
            }
        }
    }
}
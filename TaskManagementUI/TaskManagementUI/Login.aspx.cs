using Newtonsoft.Json;
using System;
using System.Net.Http;
using System.Text;
using TaskManagementUI.Dto;
using TaskManagementUI.Helpers;

namespace TaskManagementUI
{
    public partial class Login : System.Web.UI.Page
    {
        private static readonly HttpClient client = new HttpClient();
        protected void Page_Load(object sender, EventArgs e)
        {
          //Do nothing
        }
        /// <summary>
        /// Handles the Click event of the btnLogin control.
        /// </summary>
        /// <param name="sender">The source of the event.</param>
        /// <param name="e">The <see cref="EventArgs"/> instance containing the event data.</param>
        protected void btnLogin_Click(object sender, EventArgs e)
        {
            var userAuthContext =  AuthenticateUserAsync(txtUserName.Text, Helper.GetHashString(txtPassword.Text));
            if (userAuthContext != null && !string.IsNullOrEmpty(userAuthContext.Token))
            {
                Session["UserAuthContext"] = userAuthContext;
                Response.Redirect("TaskManager.aspx");
            }
            else
            {
                DivLoginErrorMessage.Visible = true;
                
            }
        }
        /// <summary>
        /// Authenticates the user asynchronous.
        /// </summary>
        /// <param name="userName">Name of the user.</param>
        /// <param name="password">The password.</param>
        /// <returns></returns>
        private UserAuthContext AuthenticateUserAsync(string userName, string password)
        {
            var loginData = new { UserName = userName, Password = password };
            var content = new StringContent(JsonConvert.SerializeObject(loginData), Encoding.UTF8, "application/json");

            var response = client.PostAsync(Helper.GetApiBaseUrl()+ "api/account/login", content).Result;
            if (response.IsSuccessStatusCode)
            {
                var responseString = response.Content.ReadAsStringAsync().Result;
                return JsonConvert.DeserializeObject<UserAuthContext>(responseString);
            }
            return null;
        }
    }
}

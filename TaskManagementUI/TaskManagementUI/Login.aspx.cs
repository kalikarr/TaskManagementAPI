using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
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
        protected  void btnLogin_Click(object sender, EventArgs e)
        {
            var userAuthContext =  AuthenticateUserAsync(txtUserName.Text, Helper.GetHashString(txtPassword.Text));
            if (userAuthContext != null && !string.IsNullOrEmpty(userAuthContext.Token))
            {
                Session["UserAuthContext"] = userAuthContext;
                Response.Redirect("TaskManager.aspx");
            }
            else
            {
                lblStatus.Text = "Login failed!";
            }
        }
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

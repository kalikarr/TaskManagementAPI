using System;
using System.Web;
using System.Web.Security;
using TaskManagementUI.Dto;

namespace TaskManagementUI.MasterPages
{
    public partial class Site : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserAuthContext"] == null)
                Response.Redirect("Login.aspx");

            UserAuthContext userAuthContext =(UserAuthContext)Session["UserAuthContext"];
            if (string.IsNullOrEmpty(userAuthContext.Token))
            {
                Response.Redirect("Login.aspx");
            }
            lblUserName.Text = userAuthContext.FullName; ;
            hdnUserId.Value = userAuthContext.UserId.ToString();
            hdnToken.Value = userAuthContext.Token;
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        { 
            Session.Clear();
            Session.Abandon();
            hdnUserId.Value = "";
            hdnToken.Value = "";
            FormsAuthentication.SignOut();
            Response.Redirect("Login.aspx");

        }
    }
}
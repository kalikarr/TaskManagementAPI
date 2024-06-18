using System;
using System.Web.Security;
using TaskManagementUI.Dto;
using TaskManagementUI.Helpers;

namespace TaskManagementUI.MasterPages
{
    public partial class Site : System.Web.UI.MasterPage
    {
        /// <summary>
        /// Handles the Load event of the Page control.
        /// </summary>
        /// <param name="sender">The source of the event.</param>
        /// <param name="e">The <see cref="EventArgs"/> instance containing the event data.</param>
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
            hdnBaseUrl.Value = Helper.GetApiBaseUrl();
        }

        /// <summary>
        /// Handles the Click event of the btnLogout control.
        /// </summary>
        /// <param name="sender">The source of the event.</param>
        /// <param name="e">The <see cref="EventArgs"/> instance containing the event data.</param>
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
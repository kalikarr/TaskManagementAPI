using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Optimization;
using System.Web.Security;
using System.Web.SessionState;
using TaskManagementUI.App_Start;

namespace TaskManagementUI
{
    public class Global : System.Web.HttpApplication
    {
        protected void Application_Start(object sender, EventArgs e)
        {
            BundleConfig.RegisterBundles(BundleTable.Bundles);
        }
        protected void Application_Error(object sender, EventArgs e)
        {
            Exception exe = Server.GetLastError();

            NLog.Logger Logger = NLog.LogManager.GetCurrentClassLogger();
            Logger.Error(exe);

            Server.ClearError();
 
            Response.Redirect("~/Error.aspx");
        }
    }
}
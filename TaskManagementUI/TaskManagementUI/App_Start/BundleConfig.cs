using System.Web.Optimization;

namespace TaskManagementUI.App_Start
{
    public class BundleConfig
    {
        /// <summary>
        /// RegisterBundles
        /// </summary>
        /// <param name="bundles">The bundles.</param>
        public static void RegisterBundles(BundleCollection bundles)
        {
            bundles.Add(new StyleBundle("~/bundles/styles").Include(
                      "~/Includes/lib/bootstrap/css/bootstrap.min.css",
                      "~/Includes/css/site.css"));

           
            bundles.Add(new ScriptBundle("~/bundles/scripts").Include(
                        "~/Includes/lib/jquery/jquery.min.js",
                        "~/Includes/lib/bootstrap/js/bootstrap.min.js",
                             "~/Includes/js/common.js",
                                  "~/Includes/js/taskmanager.js"));
                           
           
            BundleTable.EnableOptimizations = true;
        }

    }
}
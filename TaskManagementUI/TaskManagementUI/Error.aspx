<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Error.aspx.cs" Inherits="TaskManagementUI.Error" %>
<%@ Import Namespace="System.Web.Optimization" %>
<%@ Register Src="~/UserControllers/Header.ascx" TagPrefix="ucHeader" TagName="Header" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <title>Error</title>
    <asp:PlaceHolder runat="server">
        <%: Styles.Render("~/bundles/styles") %>
        <%: Scripts.Render("~/bundles/scripts") %>
    </asp:PlaceHolder>
</head>
<body>
    <ucHeader:Header runat="server" id="Header" />
    <div class="error-container">
        <div class="error-card text-center">
            <h1 class="text-danger">Oops!</h1>
            <h2>Something Went Wrong</h2>
            <p>We're sorry, but an error occurred while processing your request. Please try again later.</p>
            <a href="login.aspx" class="btn btn-primary">Go to Homepage</a>
        </div>
    </div>
</body>
</html>

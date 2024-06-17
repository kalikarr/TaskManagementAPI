<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="TaskManagementUI.Login" %>
<%@ Import Namespace="System.Web.Optimization" %>
<%@ Register Src="~/UserControllers/Header.ascx" TagPrefix="uc1" TagName="Header" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <title>Task Management Login </title>
    
    <asp:PlaceHolder runat="server">
        <%: Styles.Render("~/bundles/styles") %>
      <%: Scripts.Render("~/bundles/scripts") %> 
    </asp:PlaceHolder>
</head>
<body>   <uc1:Header runat="server" id="Header" />
    <form id="form1" runat="server" class="needs-validation login-container" novalidate>
     
        <h2>Login</h2>
        <div class="form-group">
            <asp:Label ID="lblUserName" runat="server" Text="Username" CssClass="form-label"></asp:Label>
            <asp:TextBox ID="txtUserName" runat="server" CssClass="form-control" placeholder="Enter username" required ></asp:TextBox>
             <div class="invalid-feedback">
                 Please enter user name.
             </div>
        </div>
        <div class="form-group">
            <asp:Label ID="lblPassword" runat="server" Text="Password" CssClass="form-label"></asp:Label>
            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control" placeholder="Enter password" required ></asp:TextBox>
             <div class="invalid-feedback">
                 Please enter user Password.
             </div>
        </div>
        <asp:Button ID="btnLogin" runat="server" Text="Login" CssClass="btn btn-primary" OnClick="btnLogin_Click" />
        <asp:Label ID="lblStatus" runat="server" CssClass="alert alert-danger d-none"></asp:Label>
    </form>
     <script>
        (function () {
            'use strict';
            window.addEventListener('load', function () {
                var forms = document.getElementsByClassName('needs-validation');
                var validation = Array.prototype.filter.call(forms, function (form) {
                    form.addEventListener('submit', function (event) {
                        if (form.checkValidity() === false) {
                            event.preventDefault();
                            event.stopPropagation();
                        }
                        form.classList.add('was-validated');
                    }, false);
                });
            }, false);
        })();
    </script>
</body>
</html>
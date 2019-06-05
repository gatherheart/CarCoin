<%@ Page Title="Login" Language="C#" MasterPageFile="~/Master/Site.master" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="center-block">
        <table style="border-collapse:collapse; margin-top: 150px;" class="d-flex justify-content-center mb-3">
            <tr>
                <td>Login ID:</td>
                <td><asp:TextBox ID="TextBoxID" runat="server"></asp:TextBox></td>
            </tr>
            <tr>
                <td>
                    Password:</td>
                <td>
                    <asp:TextBox ID="TextBoxPW" runat="server" TextMode="Password"></asp:TextBox></td>
            </tr>
            <tr>
                <td colspan="2">
                    <asp:LinkButton ID="LinkButtonLogin" CssClass="d-flex flex-row-reverse" OnClick="LinkButtonLogin_Click" runat="server">Login</asp:LinkButton></td>
            </tr>
        </table>
    </div>
</asp:Content>


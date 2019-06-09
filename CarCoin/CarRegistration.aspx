<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Default.master" AutoEventWireup="true" CodeFile="CarRegistration.aspx.cs" Inherits="CarRegistration" Async="true" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <div style="margin-top: 150px;">&nbsp;</div>
    <table style="border-collapse:collapse" class="d-flex justify-content-center mb-3">
        <tr>
            <td colspan="2">Add new Car to Blockchain:</td>
        </tr>
        <tr>
            <td><asp:Label ID="LabelCarNumber" Text="New Car Number:" runat="server"></asp:Label></td>
            <td><asp:TextBox ID="TextBoxCarNumber" runat="server" Text="2014318416"></asp:TextBox></td>
        </tr>
        <tr>
            <td><asp:Label ID="LabelAddCarValue" Text="New Car Value:" runat="server"></asp:Label></td>
            <td><asp:TextBox ID="TextBoxAddCarValue" runat="server" Text="50000"></asp:TextBox></td>
        </tr>
        <tr>
            <td><asp:Label ID="LabelAddCarTime" Text="Add Car Date:" runat="server"></asp:Label></td>
            <td><asp:TextBox ID="TextBoxAddCarTime" runat="server" Text="20190603"></asp:TextBox></td>
        </tr>
        <tr>
            <td colspan="2" style="text-align: right;">
                <asp:LinkButton ID="LinkButtonRegisterCar" OnClick="LinkButtonRegisterCar_Click" runat="server">Register New Car</asp:LinkButton>
            </td>
        </tr>
        <tr>
            <td colspan="2">&nbsp;</td>
        </tr>
        <tr>
            <td><asp:Label ID="LabelTransactionLinkText" Text="Link to transaction (Etherscan):" runat="server" Visible="false"></asp:Label></td>
            <td><asp:LinkButton ID="LinkButtonTransactionLink" Text="" runat="server" Visible="false"></asp:LinkButton></td>
        </tr>
    </table>
</asp:Content>
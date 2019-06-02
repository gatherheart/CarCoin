﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Default.master" AutoEventWireup="true" CodeFile="Report.aspx.cs" Inherits="Report" Async="true" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <div style="margin-top: 150px;">&nbsp;</div>
    <table style="border-collapse:collapse" class="d-flex justify-content-center mb-3">
        <tr>
            <td colspan="2">Report Accident to Blockchain:</td>
        </tr>
        <tr>
            <td><asp:Label ID="LabelCarNumber" Text="Car Number:" runat="server"></asp:Label></td>
            <td><asp:TextBox ID="TextBoxCarNumber" runat="server" Text="2015318385"></asp:TextBox></td>
        </tr>
        <tr>
            <td><asp:Label ID="LabelAccidentTime" Text="Accident Date:" runat="server"></asp:Label></td>
            <td><asp:TextBox ID="TextBoxAccidentTime" runat="server" Text="20190602"></asp:TextBox></td>
        </tr>
        <tr>
            <td><asp:Label ID="LabelAccidentValue" Text="New Car Value:" runat="server"></asp:Label></td>
            <td><asp:TextBox ID="TextBoxAccidentValue" runat="server" Text="1549"></asp:TextBox></td>
        </tr>
        <tr>
            <td><asp:Label ID="LabelAccidentData" Text="Accident Data:" runat="server"></asp:Label></td>
            <td><asp:TextBox ID="TextBoxAccidentData" runat="server" Text="Success"></asp:TextBox></td>
        </tr>
        <tr>
            <td colspan="2">
                <asp:LinkButton ID="LinkButtonReportAccident" OnClick="LinkButtonReportAccident_Click" runat="server">Report Accident</asp:LinkButton>
            </td>
        </tr>
    </table>
</asp:Content>

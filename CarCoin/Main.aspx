<%@ Page Title="Main" Language="C#" MasterPageFile="~/Master/Default.master" AutoEventWireup="true" CodeFile="Main.aspx.cs" Inherits="Main" Async="true" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <div style="margin-top: 150px;">&nbsp;</div>
    <div class="center-block">
        <asp:Panel ID="PanelInsuranceControls" runat="server" Visible="false">
            <table style="border-collapse:collapse" class="d-flex justify-content-center mb-3">
                <tr>
                    <td>
                        <asp:LinkButton ID="LinkButtonRegisterNewCar" OnClick="LinkButtonRegisterNewCar_Click" runat="server">Register new car in Blockchain</asp:LinkButton>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:LinkButton ID="LinkButtonAddAccident" OnClick="LinkButtonAddAccident_Click" runat="server">Report new accident to Blockchain</asp:LinkButton>
                    </td>
                </tr>
            </table>
        </asp:Panel>
        <table style="border-collapse:collapse" class="d-flex justify-content-center mb-3">
            <tr>
                <td colspan="2">Search Car</td>
            </tr>
            <tr>
                <td><asp:Label ID="LabelCarNumber" Text="Car Number:" runat="server"></asp:Label></td>
                <td><asp:TextBox ID="TextBoxCarNumber" runat="server" Text="2015318385"></asp:TextBox></td>
            </tr>
            <tr>
                <td colspan="2" style="text-align: right;">
                    <asp:LinkButton ID="LinkButtonSearchCar" OnClick="LinkButtonSearchCar_Click" runat="server">Search</asp:LinkButton>
                </td>
            </tr>
            <tr>
                <td colspan="2">&nbsp;</td>
            </tr>
            <tr>
                <td colspan="2">
                    <asp:Panel ID="PanelNoRecordsFound" runat="server" Visible="false">
                        <asp:Label ID="LabelNoRecordsFound" Text="No records found for this car!" ForeColor="Red" runat="server"></asp:Label>
                    </asp:Panel>
                    <asp:Repeater ID="RepeaterAccidentData" runat="server" Visible="false">
                        <HeaderTemplate>
                            <table>
                                <tr>
                                    <th>Accident Time</th>
                                    <th>Car Value</th>
                                    <th>Car Data</th>
                                    <% if (false) { //LoginControl.IsInsurance((int)Session["UID"]) for delete%>
                                    <td>&nbsp;</td>
                                    <% } %>
                                </tr>
                        </HeaderTemplate>
                        <ItemTemplate>
                                <tr>
                                    <td>
                                        <%# ((AccidentData)Container.DataItem).Time %>
                                    </td>
                                    <td>
                                        <%# ((AccidentData)Container.DataItem).LostValue %>
                                    </td>
                                    <td>
                                        <%# ((AccidentData)Container.DataItem).Data %>
                                    </td>
                                    <% if (false) { //LoginControl.IsInsurance((int)Session["UID"]) for delete %>
                                    <td>
                                        <asp:LinkButton ID="LinkButtonDeleteEntry" OnCommand="LinkButtonDeleteEntry_Click" CommandArgument="<%# ((AccidentData)Container.DataItem).Data %>" runat="server">
                                            Delete Entry
                                        </asp:LinkButton>
                                    </td>
                                    <% } %>
                                </tr>
                        </ItemTemplate>
                        <FooterTemplate>
                            </table>
                        </FooterTemplate>
                    </asp:Repeater>
                </td>
            </tr>
        </table>
    </div>
</asp:Content>


<%@ Page Title="Main" Language="C#" MasterPageFile="~/Master/Default.master" AutoEventWireup="true" CodeFile="Main.aspx.cs" Inherits="Main" Async="true" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="center-block">
        <table style="border-collapse:collapse; margin-top: 150px;" class="d-flex justify-content-center mb-3">
            <tr>
                <td><asp:Label ID="LabelOutputWeiTitle" Text="Balance in Wei:" Visible="false" runat="server"></asp:Label></td>
                <td><asp:Label ID="LabelOutputWei" runat="server"></asp:Label></td>
            </tr>
            <tr>
                <td><asp:Label ID="LabelOutputEtherTitle" Text="Balance in Ether:" Visible="false" runat="server"></asp:Label></td>
                <td><asp:Label ID="LabelOutputEther" runat="server"></asp:Label></td>
            </tr>
            <tr>
                <td colspan="2">&nbsp;</td>
            </tr>
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
                    <asp:Repeater ID="RepeaterAccidentData" runat="server" Visible="false">
                        <HeaderTemplate>
                            <table>
                                <tr>
                                    <th>Accident Time</th>
                                    <th>Car Value</th>
                                    <th>Car Data</th>
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


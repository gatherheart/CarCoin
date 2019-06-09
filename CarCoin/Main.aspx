<%@ Page Title="Main" Language="C#" MasterPageFile="~/Master/Default.master" AutoEventWireup="true" CodeFile="Main.aspx.cs" Inherits="Main" Async="true" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <div style="margin-top: 150px;">&nbsp;</div>
    <div class="center-block">
      <table style="border-collapse:collapse" class="d-flex justify-content-center mb-3">
          <tr>
              <td colspan="2">
                <h4 class="display-4" style="text-align:center">SEARCH CAR</h4>
              </td>
          </tr>
          <tr class="form-group w-35">
              <td><asp:Label ID="LabelCarNumber" class="display-6 mr-3" Text="Car:" runat="server"></asp:Label></td>
              <td><asp:TextBox ID="TextBoxCarNumber" class="form-control input-lg" runat="server" Text=""></asp:TextBox></td>
          </tr>
          <tr>
              <td colspan="2" style="text-align: right;">
                  <asp:LinkButton ID="LinkButtonSearchCar" OnClick="LinkButtonSearchCar_Click" runat="server">Search</asp:LinkButton>
              </td>
          </tr>
          <tr>
              <td colspan="2">&nbsp;</td>
          </tr>
          <tr class="form-group w-35">
              <td><asp:Label ID="LabelCarValueText" class="display-6 mr-3" Text="The car's current value is:" runat="server" Visible="false"></asp:Label></td>
              <td><asp:Label ID="LabelCarValue" class="display-6 mr-3" Text="" runat="server" Visible="false"></asp:Label>
                  <asp:Label ID="LabelCarCoinText" class="display-6 mr-3" Text="CarCoins" runat="server" Visible="false"></asp:Label></td>
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
                                  <td style="padding-right: 4%">
                                  <h6 class="display-6 mr-3">Accident time</h6>
                                  </td>
                                  <td style="padding-right: 3%">
                                  <h6 class="display-6 mr-3">Value</h6>
                                  </td>
                                  <td>
                                  <h6 class="display-6">Data</h6>
                                  </td>
                                  <% if (false) { //LoginControl.IsInsurance((int)Session["UID"]) for delete%>
                                  <td>&nbsp;</td>
                                  <% } %>
                              </tr>
                      </HeaderTemplate>
                      <ItemTemplate>
                              <tr>
                                  <td style="width: 200px">
                                      <%# ((AccidentData)Container.DataItem).Time %>
                                  </td>
                                  <td style="padding-right: 3%">
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
    </div>
</asp:Content>
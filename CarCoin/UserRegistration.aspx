<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Site.master" AutoEventWireup="true" CodeFile="UserRegistration.aspx.cs" Inherits="UserRegistration" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <div style="margin-top: 150px;">&nbsp;</div>
      <table style="border-collapse:collapse" class="d-flex justify-content-center mb-3">
          <tr>
              <td colspan="3">
                <h4 class="display-4" style="text-align:center">USER REGISTRATION</h4>
              </td>
          </tr>
          <tr class="form-group w-35">
              <td><asp:Label ID="LabelUserID" class="display-6 mr-3" Text="User ID (Case Sensitive): " runat="server"></asp:Label></td>
              <td><asp:TextBox ID="TextBoxUserID" class="form-control input-lg" runat="server" AutoCompleteType="None"></asp:TextBox></td>
              <td>&nbsp;</td>
          </tr>
          <tr class="form-group w-35">
              <td><asp:Label ID="LabelUserPassword1" class="display-6 mr-3" Text="Password: " runat="server"></asp:Label></td>
              <td><asp:TextBox ID="TextBoxUserPassword1" class="form-control input-lg" runat="server" TextMode="Password" AutoCompleteType="None"></asp:TextBox></td>
              <td>&nbsp;</td>
          </tr>
          <tr class="form-group w-35">
              <td><asp:Label ID="LabelUserPassword2" class="display-6 mr-3" Text="Repeat Password: " runat="server"></asp:Label></td>
              <td><asp:TextBox ID="TextBoxUserPassword2" class="form-control input-lg" runat="server" TextMode="Password" AutoCompleteType="None"></asp:TextBox></td>
              <td>
                  <asp:CompareValidator ID="CompareValidatorPasssword" runat="server" ForeColor="Red" ErrorMessage="* Passwords do not match" ControlToCompare="TextBoxUserPassword1" ControlToValidate="TextBoxUserPassword2"></asp:CompareValidator>
              </td>
          </tr>
          <tr class="form-group w-35">
              <td><asp:Label ID="LabelUserNickname" class="display-6 mr-3" Text="Pick a Nickname: " runat="server"></asp:Label></td>
              <td><asp:TextBox ID="TextBoxUserNickname" class="form-control input-lg" runat="server" AutoCompleteType="None"></asp:TextBox></td>
              <td>&nbsp;</td>
          </tr>
          <tr class="form-group w-35">
              <td><asp:Label ID="LabelISCAddress" class="display-6 mr-3" Text="Insurance Company Ethereum Address: " runat="server"></asp:Label></td>
              <td><asp:TextBox ID="TextBoxISCAddress" class="form-control input-lg" runat="server" AutoCompleteType="None"></asp:TextBox></td>
              <td><asp:Label ID="LabelISCAddressError" class="display-6 mr-3" Text="*" runat="server" Visible="false" ForeColor="Red"></asp:Label></td>
          </tr>
          <tr>
              <td colspan="3">
                <h4 class="display-4" style="text-align:center">&nbsp;</h4>
              </td>
          </tr>
          <tr class="form-group w-35">
            <td colspan="2">
                <asp:Label ID="LabelRegistrationError" class="display-6 mr-3" Text="(*) An error occurred please recheck your entered information again." runat="server" Visible="false" ForeColor="Red"></asp:Label>
              </td>
              <td>&nbsp;</td>
          </tr>
          <tr>
              <td colspan="2" style="text-align: right;">
                    <asp:LinkButton ID="LinkButtonRegisterUser" OnClick="LinkButtonRegisterUser_Click" runat="server">Registration</asp:LinkButton>
              </td>
              <td>&nbsp;</td>
          </tr>
       </table>
</asp:Content>


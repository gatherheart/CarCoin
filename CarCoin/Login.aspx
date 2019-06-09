<%@ Page Title="Login" Language="C#" MasterPageFile="~/Master/Site.master" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">

    <style>

         .formclass{
               padding: 10px;
               margin-top: 10px;
               background: #000;
               width: 200px;
         }
         .input{
              padding: 10px;
              width: 100%;
          }

          .center-block{
              position: absolute;
              top: 50%;
              left: 50%;
              transform: translate(-50%, -50%);
              width: 400px;
              height: 350px;
              background: rgba(255,255,255,.9);
              box-sizing: border-box;
              box-shadow: 0 15px 20px rgba(255,255,255,.2);
              border-radius: 10px;
          }

          .center-block .inputBox{
              padding-left: 10%;
              position: relative;
          }
          .center-block input{
              width: 100%;
              padding: 10px 0;
              font-size: 14px;
              clear: #000;
              margin-bottom: 30px;
              border: none;
              border-bottom: 1px solid #000;
              outline: none;
              background: transparent;
          }

          .center-block .imglogo {
            margin-left: auto;
            margin-right: auto; 
            display: block;
          }
    </style>
    <div class="center-block">
      <img class="imglogo" src="/images/logo.png" alt="carcoinLogo" />
        <div class="inputBox">
          <div><asp:TextBox ID="TextBoxID" CssClass="input" placeholder="UserId" runat="server"></asp:TextBox></div>
          <div><asp:TextBox ID="TextBoxPW" CssClass="input" placeholder="Password" runat="server" TextMode="Password"></asp:TextBox></div>
          <asp:LinkButton ID="LinkButtonLogin" CssClass="ml-2 btn btn-secondary btn-lg" OnClick="LinkButtonLogin_Click" runat="server">Login</asp:LinkButton>
        </div>
        </div>
</asp:Content>
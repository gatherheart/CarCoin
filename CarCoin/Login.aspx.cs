using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Login : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        
    }

    protected void LinkButtonLogin_Click(object sender, EventArgs e)
    {
        DataAccess da = new DataAccess();
        DataSetLogin dsl = da.GetLogin(this.TextBoxID.Text, this.TextBoxPW.Text);

        if (da.IsValidLogin(dsl))
        {
            LoginControl.Login(dsl, Session);
            Response.Redirect("~/Main.aspx");
        }
        else
            Response.Redirect("~/Login.aspx");
    }
}
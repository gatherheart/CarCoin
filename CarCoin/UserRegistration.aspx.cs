using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class UserRegistration : System.Web.UI.Page
{
    protected string m_PrivateKey { get; set; }

    protected void Page_Load(object sender, EventArgs e)
    {
    }

    protected void LinkButtonRegisterUser_Click(object sender, EventArgs e)
    {
        bool abort = true;
        DataAccess da = new DataAccess();

        if (checkISCAddress(da))
        {
            abort = false;
            this.LabelISCAddressError.Visible = true;
        }

        if (!abort && checkPassword())
            abort = false;

        if (abort)
            this.LabelISCAddressError.Visible = true;
        else
        {
            da.RegisterNewUser(this.TextBoxUserID.Text,
                this.TextBoxUserPassword1.Text,
                this.TextBoxUserNickname.Text,
                this.TextBoxISCAddress.Text,
                this.m_PrivateKey);
            Response.Redirect("~/Login.aspx");
        }
    }

    private bool checkISCAddress(DataAccess da)
    {
        bool retval = false;

        DataSetLogin dsa = da.GetInsuranceByEthereumAddress(this.TextBoxISCAddress.Text);

        if (dsa.user.Count() > 0 && dsa.user.Rows[0]["ethereum_adr"].ToString() == this.TextBoxISCAddress.Text)
        { 
            retval = true;
            this.m_PrivateKey = dsa.user.Rows[0]["private_key"].ToString();
        }

        return retval;
    }

    private bool checkPassword()
    {
        bool retval = false;

        if (this.TextBoxUserPassword1.Text == this.TextBoxUserPassword2.Text)
        {
            retval = true;
        }

        return retval;
    }
}
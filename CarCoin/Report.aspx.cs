using Nethereum.Contracts;
using Nethereum.Hex.HexTypes;
using Nethereum.Web3;
using Nethereum.Web3.Accounts;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Numerics;
using System.Threading.Tasks;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Report : System.Web.UI.Page
{
    public string AccountAddress { get; set; }
    private string AccountPrivateKey { get; set; }

    protected void Page_Load(object sender, EventArgs e)
    {
        //Login Control: redirect to home
        if (!LoginControl.IsLoggedIn(Session))
            Response.Redirect("~/Default.aspx");

        //Make sure some user doesn't just try loading "Report.aspx" in browser
        if (!LoginControl.IsInsurance((int)Session[Constants.SESSION_USERID]))
            Response.Redirect("~/Main.aspx");

        DataAccess da = new DataAccess();
        DataSetLogin dsl = da.GetLogin((int)Session[Constants.SESSION_USERID]);

        this.AccountAddress = dsl.user.Rows[0]["ethereum_adr"].ToString();
        this.AccountPrivateKey = dsl.user.Rows[0]["private_key"].ToString();
    }

    protected async void LinkButtonReportAccident_Click(object sender, EventArgs e)
    {
        string success = "";

        success = await ReportAccident(
            this.TextBoxCarNumber.Text, 
            this.TextBoxAccidentTime.Text, 
            this.TextBoxAccidentValue.Text, 
            this.TextBoxAccidentData.Text);

        if (success != "")
        {
            this.LabelTransactionLinkText.Visible = true;
            this.LinkButtonTransactionLink.Visible = true;
            this.LinkButtonTransactionLink.Text = success;
            this.LinkButtonTransactionLink.PostBackUrl = new Uri("https://ropsten.etherscan.io/tx/" + success).ToString();
        }
    }

    protected async Task<string> ReportAccident(string carNumber, string accidentTime, string carValue, string accidentData)
    {
        string retval = "";
        try
        {
            BigInteger time = BigInteger.Parse(accidentTime); // it will be oracle time and date
            BigInteger loss = BigInteger.Parse(carValue);
            HexBigInteger gas = new HexBigInteger(new BigInteger(900000));
            HexBigInteger value = new HexBigInteger(new BigInteger(0));
            var abi = System.IO.File.ReadAllText(Server.MapPath(".") + Constants.ETHEREUM_CONTRACT_ABIFILE); //190531_contract
            string ABI = @abi;

            var web3 = new Web3(new Account(this.AccountPrivateKey), Constants.ETHEREUM_ENDPOINT_API);
            Contract carCoinContract = web3.Eth.GetContract(ABI, Constants.ETHEREUM_CONTRACT_ADDRESS);

            //get the function by name
            var ccFunction = carCoinContract.GetFunction("reportAccident");
            var sendAccidentData = await ccFunction.SendTransactionAsync(this.AccountAddress, 
                gas, 
                value, 
                time, 
                carNumber, 
                loss, 
                accidentData);

            retval = sendAccidentData;
        }
        catch (Exception ex)
        {
            Console.WriteLine(ex.ToString());
        }

        return retval;
    }
}
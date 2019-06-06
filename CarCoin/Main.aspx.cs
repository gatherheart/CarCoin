using System;
using System.Numerics;
using System.Threading.Tasks;
using Nethereum.Web3;
using Nethereum.Web3.Accounts;
using Nethereum.Contracts;
using Nethereum.Hex.HexTypes;
using System.Collections.Generic;
using System.Web.UI.WebControls;

public partial class Main : System.Web.UI.Page
{
    public string AccountAddress { get; set; }
    private string AccountPrivateKey { get; set; }

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            //Login Control: redirect to home
            if (!LoginControl.IsLoggedIn(Session))
                Response.Redirect("~/Default.aspx");

            if (LoginControl.IsInsurance((int)Session[Constants.SESSION_USERID]))
                this.PanelInsuranceControls.Visible = true;
        }
        catch (Exception ex)
        {
            Console.WriteLine(ex.ToString()); //for debugging
        }

        DataAccess da = new DataAccess();
        DataSetLogin dsl = da.GetLogin((int)Session[Constants.SESSION_USERID]);

        this.AccountAddress = dsl.user.Rows[0]["ethereum_adr"].ToString();
        this.AccountPrivateKey = dsl.user.Rows[0]["private_key"].ToString();
    }

    protected async void LinkButtonSearchCar_Click(object sender, EventArgs e)
    {
        Task<string> accidentDataOutputTask = GetAccidentData(this.AccountAddress, this.TextBoxCarNumber.Text);
        string accidentData = await accidentDataOutputTask;
        List<AccidentData> adl = new Tools().ProcessAccidentDataInput(accidentData);

        if (adl.Count == 0)
        {
            this.PanelNoRecordsFound.Visible = true;
            this.RepeaterAccidentData.Visible = false;
        }
        else
        {
            this.PanelNoRecordsFound.Visible = false; 

            this.RepeaterAccidentData.DataSource = adl;
            this.RepeaterAccidentData.DataBind();

            this.RepeaterAccidentData.Visible = true;
        }
    }

    protected async Task<string> GetAccidentData(string accountAddress, string carNumber)
    {
        var abi = System.IO.File.ReadAllText(Server.MapPath(".") + Constants.ETHEREUM_CONTRACT_ABIFILE); //190531_contract
        string ABI = @abi;
        
        var web3 = new Web3(new Account(AccountPrivateKey), Constants.ETHEREUM_ENDPOINT_API);
        Contract carCoinContract = web3.Eth.GetContract(ABI, Constants.ETHEREUM_CONTRACT_ADDRESS);

        //get the function by name
        var ccFunction = carCoinContract.GetFunction("getAccidentData");
        var getAccidentData = await ccFunction.CallAsync<string>(
            from: accountAddress, 
            gas: new HexBigInteger(0), 
            value: new HexBigInteger(0), 
            functionInput: carNumber);

        return getAccidentData;
    }

    /// <summary>
    /// NOT USED: For later use (Delete entry button in repeater)
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void LinkButtonDeleteEntry_Click(object sender, CommandEventArgs e)
    {
        var argument = e.CommandArgument.ToString();
    }
    /// <summary>
    /// Goes to register new car page
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void LinkButtonRegisterNewCar_Click(object sender, EventArgs e)
    {
        Response.Redirect("~/CarRegistration.aspx");
    }

    /// <summary>
    /// Goes to record accident page
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void LinkButtonAddAccident_Click(object sender, EventArgs e)
    {
        Response.Redirect("~/Report.aspx");
    }
}
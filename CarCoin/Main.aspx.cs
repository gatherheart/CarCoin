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
    private BigInteger m_Balance;
    public BigInteger Balance { get => m_Balance; set => m_Balance = value; }

    public string AccountAddress { get; set; }

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
    }

    protected async void LinkButtonSearchCar_Click(object sender, EventArgs e)
    {
        Task<string> accidentDataOutputTask = GetAccidentData(this.AccountAddress, this.TextBoxCarNumber.Text);
        string accidentData = await accidentDataOutputTask;
        List<AccidentData> adl = new Tools().ProcessAccidentDataInput(accidentData);

        this.RepeaterAccidentData.DataSource = adl;
        this.RepeaterAccidentData.DataBind();

        this.RepeaterAccidentData.Visible = true;
    }

    protected static async Task<string> GetAccidentData(string accountAddress, string carNumber)
    {
        var privateKey = "799C0BB7B1DDAD07D24AE66240CFA1263F8FF49FF3BBE92C203AC2D0F6136919";
        //var privateKey = "D971363300B10DD559F5883F86F16B2099BBD577A7585EBC7156285033256718"; //mine

        var abi = System.IO.File.ReadAllText(Constants.ETHEREUM_CONTRACT_ABIFILE); //190531_contract
        string ABI = @abi;
        
        var web3 = new Web3(new Account(privateKey), Constants.ETHEREUM_ENDPOINT_API);
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
    /// For later use (Delete entry button in repeater)
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void LinkButtonDeleteEntry_Click(object sender, CommandEventArgs e)
    {
        var argument = e.CommandArgument.ToString();
    }

    /// <summary>
    /// Goes to record accident page
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void LinkButtonAddAccident_Click(object sender, EventArgs e)
    {

    }
}
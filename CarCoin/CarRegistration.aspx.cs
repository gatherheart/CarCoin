﻿using Nethereum.Contracts;
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

public partial class CarRegistration : System.Web.UI.Page
{
    public string AccountAddress { get; set; }

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
    }

    protected async void LinkButtonRegisterCar_Click(object sender, EventArgs e)
    {
        bool success = false;

        success = await RegisterNewCar(
            this.TextBoxCarNumber.Text,
            this.TextBoxAddCarValue.Text,
            this.TextBoxAddCarTime.Text);

        if (success)
            Response.Redirect("~/Main.aspx");
    }

    protected async Task<bool> RegisterNewCar(string carNumber, string carValue, string newCarTime)
    {
        bool retval = false;
        try
        {
            //var privateKey = "799C0BB7B1DDAD07D24AE66240CFA1263F8FF49FF3BBE92C203AC2D0F6136919";
            var privateKey = "D971363300B10DD559F5883F86F16B2099BBD577A7585EBC7156285033256718"; //mine

            BigInteger loss = BigInteger.Parse(carValue);
            BigInteger time = BigInteger.Parse(newCarTime);
            HexBigInteger gas = new HexBigInteger(new BigInteger(900000));
            HexBigInteger value = new HexBigInteger(new BigInteger(0));
            var abi = System.IO.File.ReadAllText(Constants.ETHEREUM_CONTRACT_ABIFILE); //190531_contract
            string ABI = @abi;

            var web3 = new Web3(new Account(privateKey), Constants.ETHEREUM_ENDPOINT_API);
            Contract carCoinContract = web3.Eth.GetContract(ABI, Constants.ETHEREUM_CONTRACT_ADDRESS);

            //get the function by name
            var ccFunction = carCoinContract.GetFunction("carRegistration");
            var sendAccidentData = await ccFunction.SendTransactionAsync(this.AccountAddress,
                gas,
                value,
                carNumber,
                loss,
                time);

            retval = true;
        }
        catch (Exception ex)
        {
            Console.WriteLine(ex.ToString());
        }

        return retval;
    }
}
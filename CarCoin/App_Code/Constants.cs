using System;
using System.Collections.Generic;
using System.Web;

/// <summary>
/// Summary description for Constantsx
/// </summary>
public class Constants
{
    public Constants()
    {
    }

    public const string SESSION_SESSIONID = "SessionId";
    public const string SESSION_USERID = "UID";
    public const string SESSION_USERNICK = "nickname";

    //Ethereum related
    public const string ETHEREUM_ENDPOINT_API = "https://ropsten.infura.io/v3/844df00556bd417ea69dd754d6049de4"; //Team url: "https://ropsten.infura.io/v3/3e2a025b1980443fb4c784c3d3a278a4"
    //public const string ETHEREUM_CONTRACT_ADDRESS = "0x4cb945d2353693c686d25e0896cd66b59d3a00b9"; //2019 05 31deploy
    public const string ETHEREUM_CONTRACT_ADDRESS = "0x3cb3f80544ea2b02f63ab6b12d1ef87cc62c04aa"; //2019 06 02 deploy
    public const string ETHEREUM_CONTRACT_ABIFILE = @"C:\Users\trafa\source\repos\CarCoin\CarCoin\ext\CarCoin\190531_contract\abi.json";
}
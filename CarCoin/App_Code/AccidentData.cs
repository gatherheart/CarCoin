using Nethereum.ABI.FunctionEncoding.Attributes;
using System;
using System.Collections.Generic;
using System.Numerics;

/// <summary>
/// Summary description for AccidentDataDTO
/// </summary>
public class AccidentData
{
    public DateTime Time { get; set; }
    public BigInteger LostValue { get; set; }
    public string Data { get; set; }
}


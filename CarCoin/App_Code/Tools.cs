using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Numerics;
using System.Web;

/// <summary>
/// Summary description for Tools
/// </summary>
public class Tools
{
    public Tools()
    {
    }
    
    /// <summary>
    /// Splits the data from blockchain
    /// </summary>
    /// <param name="input">data</param>
    public List<AccidentData> ProcessAccidentDataInput(string input)
    {
        List<AccidentData> accidentDataList = new List<AccidentData>();

        if (input != null && input != "")
        {
            // input format "20190602|2100|crash01@20190602|300|crash02@" (to split with delimiter @): 
            // time, value and data
            List<string> values = input.Split('@').ToList<string>();

            foreach (string tuple in values)
            {
                if (tuple != "")
                {
                    List<string> entries = tuple.Split('|').ToList<string>();
                    AccidentData ad = new AccidentData();

                    ad.Time = DateTime.ParseExact(entries[0].ToString(),
                                          "yyyyMMdd",
                                           CultureInfo.InvariantCulture);
                    ad.LostValue = BigInteger.Parse(entries[1].ToString());
                    ad.Data = entries[2].ToString();

                    accidentDataList.Add(ad); //add new Accident Data to list
                }
            }
        }
        else {
            //car has no data
        }
        return accidentDataList;
    }

    /// <summary>
    /// Fixing a concetenation "problem" from contract lol (OBSOLETE)
    /// </summary>
    /// <param name="c">starting character to cut off</param>
    /// <param name="val">string</param>
    /// <returns>cut string if present</returns>
    private string cutPrecedingChar(char c, string val)
    {
        string temp = "";
        if (val.StartsWith(c.ToString()))
            temp = val.TrimStart(c);

        return temp;
    }
}
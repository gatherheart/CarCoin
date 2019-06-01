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

        // input has always 3 values (to split with delimiter @): 
        // time, value and data
        string[] values = input.Split('@');
        string t = "";

        t = cutTrailingChar('\\', values[0]);

        // each value has n entries
        foreach (string timeEntry in t.Split('\\'))
        {
            AccidentData ad = new AccidentData();
            ad.Time = DateTime.ParseExact(timeEntry,
                                  "yyyyMMdd",
                                   CultureInfo.InvariantCulture); 
            accidentDataList.Add(ad); //add new Accident Data to list
        }


        t = cutTrailingChar('\\', values[1]);
        int i = 0;

        // assuming cohoerent data from contract
        foreach (string valueEntry in t.Split('\\'))
        {
            accidentDataList[i].LostValue = BigInteger.Parse(valueEntry); //use list
            i++;
        }


        t = cutTrailingChar('/', values[2]);
        i = 0;
        // for not thinking about the return, once again 
        foreach (string valueData in t.Split('/'))
        {
            accidentDataList[i].Data = valueData;
            i++;
        }

        return accidentDataList;
    }

    /// <summary>
    /// Fixing a concetenation "problem" from contract lol
    /// </summary>
    /// <param name="c">starting character to cut off</param>
    /// <param name="val">string</param>
    /// <returns>cut string if present</returns>
    private string cutTrailingChar(char c, string val)
    {
        string temp = "";
        if (val.StartsWith(c.ToString()))
            temp = val.TrimStart(c);

        return temp;
    }
}
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for LoginControl
/// </summary>
public class LoginControl
{
    public LoginControl()
    {
    }

    public static void Login(DataSetLogin dsl, System.Web.SessionState.HttpSessionState session)
    {
        int uid = (int)dsl.user.Rows[0]["uid"];
        string nickname = dsl.user.Rows[0]["nickname"].ToString();

        session.Add(Constants.SESSION_USERID, uid);
        session.Add(Constants.SESSION_USERNICK, nickname);
        session.Add(Constants.SESSION_SESSIONID, session.SessionID);
    }
    public static void Logout(System.Web.SessionState.HttpSessionState session)
    {
        session.Clear();
    }

    public static bool IsLoggedIn(System.Web.SessionState.HttpSessionState session)
    {
        bool retval;

        try
        {
            if (session[Constants.SESSION_USERID].ToString() != "")
                retval = true;
            else
                retval = false;
        }
        catch
        {
            retval = false;
        }
        return retval;
    }
}
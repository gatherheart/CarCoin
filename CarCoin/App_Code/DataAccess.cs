using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

/// <summary>
/// Summary description for DataAccess
/// </summary>
public class DataAccess
{
    /// <summary>
    /// 
    /// </summary>
    public DataAccess()
    {

    }

    public DataSetLogin GetLogin(int uid)
    {
        DataSetLoginTableAdapters.TableAdapterUser userTableAdapter = new DataSetLoginTableAdapters.TableAdapterUser();
        DataSetLogin loginData = new DataSetLogin();
        userTableAdapter.FillByUID(loginData.user, uid);

        return loginData;
    }

    public DataSetLogin GetLogin(string username, string password)
    {
        DataSetLoginTableAdapters.TableAdapterUser userTableAdapter = new DataSetLoginTableAdapters.TableAdapterUser();
        DataSetLogin loginData = new DataSetLogin();
        userTableAdapter.FillByUserPass(loginData.user, username, password);

        return loginData;
    }

    public bool IsValidLogin(DataSetLogin dsl)
    {
        bool retval = false;

        try
        {
            if (dsl.user.Rows[0]["username"].ToString() != null)
                retval = true;
        }
        catch (Exception ex)
        {
            Console.WriteLine(ex.ToString()); //only used in debugging
        }

        return retval;
    }

    bool IsSuperuser(string username, string password)
    {
        bool retval = false;
        DataSetLoginTableAdapters.TableAdapterSuperuser superuserTableAdapter = new DataSetLoginTableAdapters.TableAdapterSuperuser();
        DataSetLogin superuserData = new DataSetLogin();

        superuserTableAdapter.FillBySuperuser(superuserData.superuser, username, password);

        try
        {
            if (superuserData.superuser.Rows[0]["uid"].ToString() != null)
                retval = true;
        }
        catch (Exception ex)
        {
            Console.WriteLine(ex.ToString()); //only used in debugging
        }

        return retval;
    }

    public void RegisterNewUser(string uid, string pw, string nick, string iscAddr, string iscPrivKey)
    {
        DataSetLoginTableAdapters.TableAdapterUser userTableAdapter = new DataSetLoginTableAdapters.TableAdapterUser();
        DataSetLogin userData = new DataSetLogin();

        //new user can never be ISC, owner has to set manually
        userTableAdapter.InsertQuery(uid, pw, nick, iscAddr, iscPrivKey, 0);
    }

    public DataSetLogin GetInsuranceByEthereumAddress(string ea)
    {
        DataSetLoginTableAdapters.TableAdapterUser userTableAdapter = new DataSetLoginTableAdapters.TableAdapterUser();
        DataSetLogin userData = new DataSetLogin();
        userTableAdapter.FillByEthereumAddr(userData.user, ea);

        return userData;
    }
}
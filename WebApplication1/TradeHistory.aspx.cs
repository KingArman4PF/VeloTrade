using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using Npgsql;

namespace WebApplication1
{
    public partial class TradeHistory : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadTrades();
            }
        }

        private void LoadTrades()
        {
            try
            {
                string filter = ddlStatus.Value;
                string query = "SELECT * FROM trades";
                Npgsql.NpgsqlParameter[] parameters = null;

                if (!string.IsNullOrWhiteSpace(filter))
                {
                    query += " WHERE result = @result";
                    parameters = new Npgsql.NpgsqlParameter[]
                    {
                        new Npgsql.NpgsqlParameter("@result", filter)
                    };
                }

                query += " ORDER BY entry_date DESC";

                DataTable dt = DatabaseHelper.ExecuteQuery(query, parameters);
                gvTrades.DataSource = dt;
                gvTrades.DataBind();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error loading trades: " + ex.Message);
            }
        }

        protected void btnFilter_Click(object sender, EventArgs e)
        {
            gvTrades.PageIndex = 0;
            LoadTrades();
        }

        protected void gvTrades_PageIndexChanging(object sender, System.Web.UI.WebControls.GridViewPageEventArgs e)
        {
            gvTrades.PageIndex = e.NewPageIndex;
            LoadTrades();
        }

        protected void gvTrades_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            try
            {
                if (e.CommandName == "DeleteTrade" && int.TryParse(e.CommandArgument.ToString(), out int tradeId))
                {
                    string query = "DELETE FROM trades WHERE trade_id = @tradeId";
                    NpgsqlParameter[] parameters = new NpgsqlParameter[]
                    {
                        new NpgsqlParameter("@tradeId", tradeId)
                    };
                    DatabaseHelper.ExecuteNonQuery(query, parameters);
                    LoadTrades();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error deleting trade: " + ex.Message);
            }
        }
    }
}
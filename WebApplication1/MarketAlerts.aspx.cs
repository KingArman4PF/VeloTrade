using System;
using System.Data;
using System.Web.UI.WebControls;
using Npgsql;

namespace WebApplication1
{
    public partial class MarketAlerts : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadAlerts();
            }
        }

        protected void btnCreateAlert_Click(object sender, EventArgs e)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(txtSymbol.Text) || string.IsNullOrWhiteSpace(txtPrice.Text))
                {
                    ShowMessage("Please fill in all fields.", false);
                    return;
                }

                string symbol = txtSymbol.Text.ToUpper().Trim();
                string alertType = ddlAlertType.Value;
                decimal price = Convert.ToDecimal(txtPrice.Text);

                string query = "INSERT INTO alerts (symbol, alert_type, condition_value) VALUES (@symbol, @alertType, @price)";

                NpgsqlParameter[] parameters = new NpgsqlParameter[]
                {
                    new NpgsqlParameter("@symbol", symbol),
                    new NpgsqlParameter("@alertType", alertType),
                    new NpgsqlParameter("@price", price)
                };

                DatabaseHelper.ExecuteNonQuery(query, parameters);

                ShowMessage("✅ Alert created successfully!", true);
                txtSymbol.Text = "";
                txtPrice.Text = "";
                LoadAlerts();
            }
            catch (Exception ex)
            {
                ShowMessage("❌ Error: " + ex.Message, false);
            }
        }

        private void LoadAlerts()
        {
            try
            {
                string query = "SELECT * FROM alerts ORDER BY created_at DESC";
                DataTable dt = DatabaseHelper.ExecuteQuery(query);

                rptAlerts.DataSource = dt;
                rptAlerts.DataBind();

                pnlAlertsEmpty.Visible = dt.Rows.Count == 0;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error loading alerts: " + ex.Message);
            }
        }

        protected void rptAlerts_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            try
            {
                if (e.CommandName == "Delete" && int.TryParse(e.CommandArgument.ToString(), out int alertId))
                {
                    string query = "DELETE FROM alerts WHERE alert_id = @alertId";
                    NpgsqlParameter[] parameters = new NpgsqlParameter[]
                    {
                        new NpgsqlParameter("@alertId", alertId)
                    };
                    DatabaseHelper.ExecuteNonQuery(query, parameters);
                    LoadAlerts();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error deleting alert: " + ex.Message);
            }
        }

        private void ShowMessage(string message, bool isSuccess)
        {
            lblMessage.Text = message;
            lblMessage.CssClass = isSuccess ? "message success" : "message error";
            lblMessage.Visible = true;
        }
    }
}
using System;
using System.Data;
using System.Web.UI.WebControls;
using Npgsql;

namespace WebApplication1
{
    public partial class SetupManager : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadSetups();
            }
        }

        protected void btnCreateSetup_Click(object sender, EventArgs e)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(txtSetupName.Text) || string.IsNullOrWhiteSpace(txtSetupDescription.Text))
                {
                    ShowMessage("Please fill in setup name and description.", false);
                    return;
                }

                string setupName = txtSetupName.Text.Trim();
                string description = txtSetupDescription.Text.Trim();
                string targetMarkets = txtTargetMarkets.Text.Trim();
                string timeframe = txtTimeframe.Text.Trim();

                string query = "INSERT INTO setups (setup_name, description, target_markets, timeframe) VALUES (@name, @desc, @markets, @timeframe)";

                NpgsqlParameter[] parameters = new NpgsqlParameter[]
                {
                    new NpgsqlParameter("@name", setupName),
                    new NpgsqlParameter("@desc", description),
                    new NpgsqlParameter("@markets", targetMarkets),
                    new NpgsqlParameter("@timeframe", timeframe)
                };

                DatabaseHelper.ExecuteNonQuery(query, parameters);

                ShowMessage("✅ Setup saved successfully!", true);
                txtSetupName.Text = "";
                txtSetupDescription.Text = "";
                txtTargetMarkets.Text = "";
                txtTimeframe.Text = "";
                LoadSetups();
            }
            catch (Exception ex)
            {
                ShowMessage("❌ Error: " + ex.Message, false);
            }
        }

        private void LoadSetups()
        {
            try
            {
                string query = "SELECT * FROM setups ORDER BY created_at DESC";
                DataTable dt = DatabaseHelper.ExecuteQuery(query);

                rptSetups.DataSource = dt;
                rptSetups.DataBind();

                pnlSetupsEmpty.Visible = dt.Rows.Count == 0;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error loading setups: " + ex.Message);
            }
        }

        protected void rptSetups_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            try
            {
                if (e.CommandName == "Delete" && int.TryParse(e.CommandArgument.ToString(), out int setupId))
                {
                    string query = "DELETE FROM setups WHERE setup_id = @setupId";
                    NpgsqlParameter[] parameters = new NpgsqlParameter[]
                    {
                        new NpgsqlParameter("@setupId", setupId)
                    };
                    DatabaseHelper.ExecuteNonQuery(query, parameters);
                    LoadSetups();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error deleting setup: " + ex.Message);
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
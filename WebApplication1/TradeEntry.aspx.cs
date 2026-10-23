using System;
using Npgsql;

namespace WebApplication1
{
    public partial class TradeEntry : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                txtEntryDate.Text = DateTime.Now.ToString("yyyy-MM-ddTHH:mm");
            }
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(txtSymbol.Text) || 
                    string.IsNullOrWhiteSpace(txtEntryPrice.Text) ||
                    string.IsNullOrWhiteSpace(txtQuantity.Text) ||
                    string.IsNullOrWhiteSpace(txtReasoning.Text))
                {
                    ShowMessage("Please fill in all required fields (marked with *).", false);
                    return;
                }

                string symbol = txtSymbol.Text.ToUpper().Trim();
                decimal entryPrice = Convert.ToDecimal(txtEntryPrice.Text);
                int quantity = Convert.ToInt32(txtQuantity.Text);
                string tradeType = ddlTradeType.SelectedValue;
                DateTime entryDate = DateTime.Parse(txtEntryDate.Text);
                string reasoning = txtReasoning.Text.Trim();
                string notes = txtNotes.Text.Trim();

                decimal? exitPrice = null;
                DateTime? exitDate = null;
                if (!string.IsNullOrWhiteSpace(txtExitPrice.Text))
                {
                    exitPrice = Convert.ToDecimal(txtExitPrice.Text);
                }
                if (!string.IsNullOrWhiteSpace(txtExitDate.Text))
                {
                    exitDate = DateTime.Parse(txtExitDate.Text);
                }

                decimal? profitLoss = null;
                string result = "OPEN";
                if (exitPrice.HasValue && exitDate.HasValue)
                {
                    if (tradeType == "LONG")
                    {
                        profitLoss = (exitPrice.Value - entryPrice) * quantity;
                    }
                    else
                    {
                        profitLoss = (entryPrice - exitPrice.Value) * quantity;
                    }

                    if (profitLoss > 0) result = "WIN";
                    else if (profitLoss < 0) result = "LOSS";
                    else result = "BREAK_EVEN";
                }

                string query = "INSERT INTO trades (symbol, entry_price, exit_price, quantity, trade_type, entry_date, exit_date, result, profit_loss, reasoning, notes) VALUES (@symbol, @entryPrice, @exitPrice, @quantity, @tradeType, @entryDate, @exitDate, @result, @profitLoss, @reasoning, @notes)";

                NpgsqlParameter[] parameters = new NpgsqlParameter[]
                {
                    new NpgsqlParameter("@symbol", symbol),
                    new NpgsqlParameter("@entryPrice", entryPrice),
                    new NpgsqlParameter("@exitPrice", (object)exitPrice ?? DBNull.Value),
                    new NpgsqlParameter("@quantity", quantity),
                    new NpgsqlParameter("@tradeType", tradeType),
                    new NpgsqlParameter("@entryDate", entryDate),
                    new NpgsqlParameter("@exitDate", (object)exitDate ?? DBNull.Value),
                    new NpgsqlParameter("@result", result),
                    new NpgsqlParameter("@profitLoss", (object)profitLoss ?? DBNull.Value),
                    new NpgsqlParameter("@reasoning", reasoning),
                    new NpgsqlParameter("@notes", notes)
                };

                DatabaseHelper.ExecuteNonQuery(query, parameters);

                ShowMessage("✅ Trade logged successfully!", true);
                ClearForm();
            }
            catch (Exception ex)
            {
                ShowMessage("❌ Error: " + ex.Message, false);
            }
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            Response.Redirect("Dashboard.aspx");
        }

        private void ShowMessage(string message, bool isSuccess)
        {
            lblMessage.Text = message;
            lblMessage.CssClass = isSuccess ? "message success" : "message error";
            lblMessage.Visible = true;
        }

        private void ClearForm()
        {
            txtSymbol.Text = "";
            txtEntryPrice.Text = "";
            txtQuantity.Text = "";
            txtExitPrice.Text = "";
            txtExitDate.Text = "";
            txtReasoning.Text = "";
            txtNotes.Text = "";
            txtEntryDate.Text = DateTime.Now.ToString("yyyy-MM-ddTHH:mm");
        }
    }
}
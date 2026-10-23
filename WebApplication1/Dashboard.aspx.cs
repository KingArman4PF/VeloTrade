using System;
using System.Data;

namespace WebApplication1
{
    public partial class Dashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadDashboardData();
            }
        }

        private void LoadDashboardData()
        {
            try
            {
                string query = "SELECT * FROM trades WHERE exit_date IS NOT NULL ORDER BY exit_date DESC LIMIT 10";
                DataTable dt = DatabaseHelper.ExecuteQuery(query);

                if (dt.Rows.Count > 0)
                {
                    gvRecentTrades.DataSource = dt;
                    gvRecentTrades.DataBind();
                }

                CalculateStats();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error loading dashboard: " + ex.Message);
            }
        }

        private void CalculateStats()
        {
            try
            {
                object totalCount = DatabaseHelper.ExecuteScalar("SELECT COUNT(*) FROM trades WHERE exit_date IS NOT NULL");
                int total = totalCount != null ? Convert.ToInt32(totalCount) : 0;
                lblTotalTrades.Text = total.ToString();

                if (total == 0)
                {
                    lblWinRate.Text = "0%";
                    lblTotalPL.Text = "$0.00";
                    lblAvgWin.Text = "$0.00";
                    return;
                }

                object winCount = DatabaseHelper.ExecuteScalar("SELECT COUNT(*) FROM trades WHERE result = 'WIN'");
                int wins = winCount != null ? Convert.ToInt32(winCount) : 0;
                double winRate = (double)wins / total * 100;
                lblWinRate.Text = winRate.ToString("F1") + "%";

                object totalPL = DatabaseHelper.ExecuteScalar("SELECT COALESCE(SUM(profit_loss), 0) FROM trades WHERE exit_date IS NOT NULL");
                decimal pl = totalPL != null ? Convert.ToDecimal(totalPL) : 0;
                lblTotalPL.Text = pl.ToString("C");

                object avgWin = DatabaseHelper.ExecuteScalar("SELECT COALESCE(AVG(profit_loss), 0) FROM trades WHERE result = 'WIN'");
                decimal avg = avgWin != null ? Convert.ToDecimal(avgWin) : 0;
                lblAvgWin.Text = avg.ToString("C");
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error calculating stats: " + ex.Message);
            }
        }
    }
}
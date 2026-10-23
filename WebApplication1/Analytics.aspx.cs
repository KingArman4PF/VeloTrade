using System;
using System.Data;

namespace WebApplication1
{
    public partial class Analytics : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadAnalytics();
            }
        }

        private void LoadAnalytics()
        {
            try
            {
                CalculateMetrics();
                LoadTopSymbols();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error loading analytics: " + ex.Message);
            }
        }

        private void CalculateMetrics()
        {
            object totalCount = DatabaseHelper.ExecuteScalar("SELECT COUNT(*) FROM trades");
            int total = totalCount != null ? Convert.ToInt32(totalCount) : 0;
            lblTotalTrades.Text = total.ToString();

            object closedCount = DatabaseHelper.ExecuteScalar("SELECT COUNT(*) FROM trades WHERE exit_date IS NOT NULL");
            int closed = closedCount != null ? Convert.ToInt32(closedCount) : 0;
            lblClosedTrades.Text = closed.ToString();

            object openCount = DatabaseHelper.ExecuteScalar("SELECT COUNT(*) FROM trades WHERE exit_date IS NULL");
            int open = openCount != null ? Convert.ToInt32(openCount) : 0;
            lblOpenTrades.Text = open.ToString();

            if (closed == 0)
            {
                lblWins.Text = "0";
                lblLosses.Text = "0";
                lblBreakEven.Text = "0";
                lblWinRate.Text = "0%";
                lblTotalPL.Text = "$0.00";
                lblAvgWin.Text = "$0.00";
                lblAvgLoss.Text = "$0.00";
                lblProfitFactor.Text = "0.00";
                lblMaxWin.Text = "$0.00";
                lblMaxLoss.Text = "$0.00";
                lblRiskReward.Text = "0.00";
                return;
            }

            object winCount = DatabaseHelper.ExecuteScalar("SELECT COUNT(*) FROM trades WHERE result = 'WIN'");
            int wins = winCount != null ? Convert.ToInt32(winCount) : 0;
            lblWins.Text = wins.ToString();

            object lossCount = DatabaseHelper.ExecuteScalar("SELECT COUNT(*) FROM trades WHERE result = 'LOSS'");
            int losses = lossCount != null ? Convert.ToInt32(lossCount) : 0;
            lblLosses.Text = losses.ToString();

            object beCount = DatabaseHelper.ExecuteScalar("SELECT COUNT(*) FROM trades WHERE result = 'BREAK_EVEN'");
            int breakEven = beCount != null ? Convert.ToInt32(beCount) : 0;
            lblBreakEven.Text = breakEven.ToString();

            double winRate = (double)wins / closed * 100;
            lblWinRate.Text = winRate.ToString("F1") + "%";
            ClientScript.RegisterStartupScript(GetType(), "updateWinRate", 
                $"document.getElementById('winRateBar').style.width = '{winRate}%';", true);

            object totalPL = DatabaseHelper.ExecuteScalar("SELECT COALESCE(SUM(profit_loss), 0) FROM trades WHERE exit_date IS NOT NULL");
            decimal pl = totalPL != null ? Convert.ToDecimal(totalPL) : 0;
            lblTotalPL.Text = pl.ToString("C");

            object avgWin = DatabaseHelper.ExecuteScalar("SELECT COALESCE(AVG(profit_loss), 0) FROM trades WHERE result = 'WIN'");
            decimal avgWinVal = avgWin != null ? Convert.ToDecimal(avgWin) : 0;
            lblAvgWin.Text = avgWinVal.ToString("C");

            object avgLoss = DatabaseHelper.ExecuteScalar("SELECT COALESCE(AVG(profit_loss), 0) FROM trades WHERE result = 'LOSS'");
            decimal avgLossVal = avgLoss != null ? Convert.ToDecimal(avgLoss) : 0;
            lblAvgLoss.Text = avgLossVal.ToString("C");

            decimal totalWins = wins > 0 ? (decimal)wins * avgWinVal : 0;
            decimal totalLosses = losses > 0 ? Math.Abs((decimal)losses * avgLossVal) : 1;
            decimal profitFactor = totalLosses > 0 ? totalWins / totalLosses : totalWins;
            lblProfitFactor.Text = profitFactor.ToString("F2");

            object maxWin = DatabaseHelper.ExecuteScalar("SELECT COALESCE(MAX(profit_loss), 0) FROM trades WHERE result = 'WIN'");
            decimal maxWinVal = maxWin != null ? Convert.ToDecimal(maxWin) : 0;
            lblMaxWin.Text = maxWinVal.ToString("C");

            object maxLoss = DatabaseHelper.ExecuteScalar("SELECT COALESCE(MIN(profit_loss), 0) FROM trades WHERE result = 'LOSS'");
            decimal maxLossVal = maxLoss != null ? Convert.ToDecimal(maxLoss) : 0;
            lblMaxLoss.Text = maxLossVal.ToString("C");

            decimal riskReward = avgLossVal != 0 ? Math.Abs(avgWinVal / avgLossVal) : 0;
            lblRiskReward.Text = riskReward.ToString("F2");
        }

        private void LoadTopSymbols()
        {
            try
            {
                string query = @"
                    SELECT symbol, COUNT(*) as trade_count, SUM(profit_loss) as total_pl
                    FROM trades
                    WHERE exit_date IS NOT NULL
                    GROUP BY symbol
                    ORDER BY trade_count DESC
                    LIMIT 10
                ";

                DataTable dt = DatabaseHelper.ExecuteQuery(query);

                if (dt.Rows.Count > 0)
                {
                    string html = "";
                    foreach (DataRow row in dt.Rows)
                    {
                        string symbol = row["symbol"].ToString();
                        int count = Convert.ToInt32(row["trade_count"]);
                        decimal pl = Convert.ToDecimal(row["total_pl"] ?? 0);

                        html += $@"
                            <div class='symbol-item'>
                                <div>
                                    <div class='symbol-name'>{symbol}</div>
                                    <div style='color: #94a3b8; font-size: 0.85rem;'>{count} trades • {pl:C}</div>
                                </div>
                                <span class='symbol-count'>{count}</span>
                            </div>
                        ";
                    }

                    pnlTopSymbols.Controls.Clear();
                    pnlTopSymbols.Controls.Add(new System.Web.UI.LiteralControl(html));
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error loading top symbols: " + ex.Message);
            }
        }
    }
}
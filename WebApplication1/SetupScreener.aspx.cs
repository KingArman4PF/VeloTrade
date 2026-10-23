using System;
using System.Data;

namespace WebApplication1
{
    public partial class SetupScreener : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnScreen_Click(object sender, EventArgs e)
        {
            try
            {
                int minWinRate = string.IsNullOrWhiteSpace(txtMinWinRate.Text) ? 0 : Convert.ToInt32(txtMinWinRate.Text);
                decimal minProfitFactor = string.IsNullOrWhiteSpace(txtMinProfitFactor.Text) ? 0 : Convert.ToDecimal(txtMinProfitFactor.Text);
                int minTrades = string.IsNullOrWhiteSpace(txtMinTrades.Text) ? 0 : Convert.ToInt32(txtMinTrades.Text);

                string query = @"
                    SELECT 
                        symbol,
                        COUNT(*) as trade_count,
                        SUM(CASE WHEN result = 'WIN' THEN 1 ELSE 0 END) as wins,
                        ROUND(100.0 * SUM(CASE WHEN result = 'WIN' THEN 1 ELSE 0 END) / COUNT(*), 2) as win_rate,
                        SUM(profit_loss) as total_pl,
                        AVG(profit_loss) as avg_pl,
                        MAX(profit_loss) as max_win,
                        MIN(profit_loss) as max_loss
                    FROM trades
                    WHERE exit_date IS NOT NULL
                    GROUP BY symbol
                    HAVING COUNT(*) >= @minTrades
                    ORDER BY win_rate DESC, total_pl DESC
                ";

                Npgsql.NpgsqlParameter[] parameters = new Npgsql.NpgsqlParameter[]
                {
                    new Npgsql.NpgsqlParameter("@minTrades", minTrades)
                };

                DataTable dt = DatabaseHelper.ExecuteQuery(query);

                string html = "";
                int resultCount = 0;

                foreach (DataRow row in dt.Rows)
                {
                    string symbol = row["symbol"].ToString();
                    int tradeCount = Convert.ToInt32(row["trade_count"]);
                    int wins = Convert.ToInt32(row["wins"]);
                    decimal winRate = Convert.ToDecimal(row["win_rate"]);
                    decimal totalPL = Convert.ToDecimal(row["total_pl"] ?? 0);
                    decimal avgPL = Convert.ToDecimal(row["avg_pl"] ?? 0);
                    decimal maxWin = Convert.ToDecimal(row["max_win"] ?? 0);
                    decimal maxLoss = Convert.ToDecimal(row["max_loss"] ?? 0);

                    // Calculate profit factor
                    decimal profitFactor = 0;
                    if (tradeCount > 0 && wins > 0 && tradeCount > wins)
                    {
                        decimal totalWins = wins * avgPL;
                        decimal totalLosses = (tradeCount - wins) * Math.Abs(avgPL);
                        profitFactor = totalLosses > 0 ? totalWins / totalLosses : totalWins;
                    }

                    // Filter by criteria
                    if (winRate >= minWinRate && profitFactor >= minProfitFactor)
                    {
                        string plColor = totalPL > 0 ? "#10b981" : "#ef4444";
                        html += $@"
                            <div class='result-item'>
                                <div class='result-title'>{symbol} • {tradeCount} Trades</div>
                                <div class='result-details'>
                                    Win Rate: {winRate:F1}% | Wins: {wins} | Profit Factor: {profitFactor:F2} | Total P/L: <span style='color:{plColor}; font-weight:600;'>{totalPL:C}</span><br/>
                                    Avg Trade: {avgPL:C} | Max Win: {maxWin:C} | Max Loss: {maxLoss:C}
                                </div>
                            </div>
                        ";
                        resultCount++;
                    }
                }

                if (resultCount > 0)
                {
                    pnlResults.Controls.Clear();
                    pnlResults.Controls.Add(new System.Web.UI.LiteralControl(html));
                    resultsDiv.Visible = true;
                    emptyDiv.Visible = false;
                }
                else
                {
                    resultsDiv.Visible = false;
                    emptyDiv.Visible = true;
                    emptyDiv.InnerHtml = "<div class='empty-state'>No setups match your criteria. Try adjusting your filters.</div>";
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error screening setups: " + ex.Message);
                emptyDiv.InnerHtml = $"<div class='empty-state'>Error: {ex.Message}</div>";
                emptyDiv.Visible = true;
            }
        }
    }
}
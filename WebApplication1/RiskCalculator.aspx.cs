using System;

namespace WebApplication1
{
    public partial class RiskCalculator : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnFixedRisk_Click(object sender, EventArgs e)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(txtAccountSize.Text) || 
                    string.IsNullOrWhiteSpace(txtRiskPercent.Text) ||
                    string.IsNullOrWhiteSpace(txtFixedEntry.Text) ||
                    string.IsNullOrWhiteSpace(txtFixedStop.Text))
                {
                    ClientScript.RegisterClientScriptBlock(GetType(), "error", 
                        "alert('Please fill in all fields.');", true);
                    return;
                }

                decimal accountSize = Convert.ToDecimal(txtAccountSize.Text);
                decimal riskPercent = Convert.ToDecimal(txtRiskPercent.Text);
                decimal entryPrice = Convert.ToDecimal(txtFixedEntry.Text);
                decimal stopPrice = Convert.ToDecimal(txtFixedStop.Text);

                // Calculate risk amount
                decimal riskAmount = accountSize * (riskPercent / 100);

                // Calculate pips/points at risk
                decimal priceRisk = Math.Abs(entryPrice - stopPrice);

                // Calculate position size
                decimal positionSize = priceRisk > 0 ? riskAmount / priceRisk : 0;

                // Round down to whole number
                int qty = (int)Math.Floor(positionSize);

                // Capital required
                decimal capitalRequired = qty * entryPrice;

                // Update UI
                lblRiskAmount.Text = riskAmount.ToString("C");
                lblPositionSize.Text = qty.ToString();
                lblCapitalRequired.Text = capitalRequired.ToString("C");
                lblBuyQty.Text = qty.ToString();
                lblBuyPrice.Text = entryPrice.ToString("F2");
                lblStopPrice.Text = stopPrice.ToString("F2");

                fixedRiskResults.Visible = true;
            }
            catch (Exception ex)
            {
                ClientScript.RegisterClientScriptBlock(GetType(), "error", 
                    $"alert('Error: {ex.Message}');", true);
            }
        }

        protected void btnKellyCriterion_Click(object sender, EventArgs e)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(txtWinRate.Text) || 
                    string.IsNullOrWhiteSpace(txtRiskReward.Text) ||
                    string.IsNullOrWhiteSpace(txtKellyAccountSize.Text))
                {
                    ClientScript.RegisterClientScriptBlock(GetType(), "error", 
                        "alert('Please fill in all fields.');", true);
                    return;
                }

                decimal winRate = Convert.ToDecimal(txtWinRate.Text) / 100;
                decimal riskReward = Convert.ToDecimal(txtRiskReward.Text);
                decimal accountSize = Convert.ToDecimal(txtKellyAccountSize.Text);

                // Kelly Formula: f = (win% * reward) - loss% / reward
                // where win% = win rate, loss% = 1 - win rate, reward = risk/reward ratio
                decimal winPercent = winRate;
                decimal lossPercent = 1 - winRate;

                decimal kelly = (winPercent * riskReward - lossPercent) / riskReward;

                // Clamp Kelly to 0-25%
                kelly = Math.Max(0, Math.Min(kelly, 0.25m));

                // Conservative Kelly (half Kelly)
                decimal conservativeKelly = kelly / 2;

                // Position sizes
                decimal kellyRiskAmount = accountSize * kelly;
                decimal conservativeRiskAmount = accountSize * conservativeKelly;

                // Update UI
                lblKellyPercent.Text = (kelly * 100).ToString("F2") + "%";
                lblConservativeKelly.Text = (conservativeKelly * 100).ToString("F2") + "%";
                lblKellyPositionSize.Text = (kelly * 100).ToString("F1") + "% of account";
                lblKellyRiskAmount.Text = kellyRiskAmount.ToString("C");
                lblKellyConservativeRisk.Text = conservativeRiskAmount.ToString("C");

                kellyResults.Visible = true;
            }
            catch (Exception ex)
            {
                ClientScript.RegisterClientScriptBlock(GetType(), "error", 
                    $"alert('Error: {ex.Message}');", true);
            }
        }

        protected void btnRiskReward_Click(object sender, EventArgs e)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(txtRREntry.Text) || 
                    string.IsNullOrWhiteSpace(txtRRStop.Text) ||
                    string.IsNullOrWhiteSpace(txtRRTarget.Text) ||
                    string.IsNullOrWhiteSpace(txtRRQty.Text))
                {
                    ClientScript.RegisterClientScriptBlock(GetType(), "error", 
                        "alert('Please fill in all fields.');", true);
                    return;
                }

                decimal entryPrice = Convert.ToDecimal(txtRREntry.Text);
                decimal stopPrice = Convert.ToDecimal(txtRRStop.Text);
                decimal targetPrice = Convert.ToDecimal(txtRRTarget.Text);
                int qty = Convert.ToInt32(txtRRQty.Text);

                // Calculate risk and reward
                decimal riskPerShare = Math.Abs(entryPrice - stopPrice);
                decimal rewardPerShare = Math.Abs(targetPrice - entryPrice);

                decimal totalRisk = riskPerShare * qty;
                decimal totalReward = rewardPerShare * qty;

                // R:R Ratio
                decimal ratio = riskPerShare > 0 ? rewardPerShare / riskPerShare : 0;

                // Update UI
                lblRRRisk.Text = totalRisk.ToString("C");
                lblRRReward.Text = totalReward.ToString("C");
                lblRRRatio.Text = ratio.ToString("F2") + ":1";
                lblRRInfo.Text = totalRisk.ToString("C");
                lblRewardInfo.Text = totalReward.ToString("C");

                rrResults.Visible = true;
            }
            catch (Exception ex)
            {
                ClientScript.RegisterClientScriptBlock(GetType(), "error", 
                    $"alert('Error: {ex.Message}');", true);
            }
        }
    }
}
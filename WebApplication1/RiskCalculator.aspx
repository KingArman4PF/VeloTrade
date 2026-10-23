<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RiskCalculator.aspx.cs" Inherits="WebApplication1.RiskCalculator" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>VeloTrade — Risk Calculator</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@500;600;700&family=Inter:wght@400;500;600&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="Site.css" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="app">
            <aside class="sidebar">
                <div class="brand">
                    <div class="brand-mark">VeloTrade<span class="dot">.</span></div>
                    <div class="brand-sub">Trading Journal</div>
                </div>
                <nav class="nav-group">
                    <div class="nav-eyebrow">Journal</div>
                    <a class="nav-link" href="Dashboard.aspx"><span class="ic">▣</span> Dashboard</a>
                    <a class="nav-link" href="TradeEntry.aspx"><span class="ic">✚</span> New Trade</a>
                    <a class="nav-link" href="TradeHistory.aspx"><span class="ic">≣</span> Trade History</a>
                    <a class="nav-link" href="Analytics.aspx"><span class="ic">◧</span> Analytics</a>
                    <a class="nav-link" href="Charts.aspx"><span class="ic">◨</span> Charts</a>
                    <div class="nav-eyebrow">Strategy</div>
                    <a class="nav-link" href="MarketAlerts.aspx"><span class="ic">◔</span> Market Alerts</a>
                    <a class="nav-link" href="SetupScreener.aspx"><span class="ic">◎</span> Setup Screener</a>
                    <a class="nav-link" href="SetupManager.aspx"><span class="ic">▤</span> Setup Manager</a>
                    <a class="nav-link active" href="RiskCalculator.aspx"><span class="ic">△</span> Risk Calculator</a>
                </nav>
                <div class="sidebar-foot">VeloTrade &middot; Personal Journal</div>
            </aside>

            <div class="main">
                <header class="topbar">
                    <button type="button" class="menu-toggle">☰</button>
                    <div>
                        <h1>Risk Calculator</h1>
                        <div class="sub">Size positions before you enter, not after</div>
                    </div>
                    <div class="topbar-right">
                        <div class="session-pill"><span class="live-dot"></span> <span class="txt" id="liveClock">--:--:--</span></div>
                    </div>
                </header>

                <div class="page">
                    <div class="calculator-grid">
                        <!-- Fixed Risk Calculator -->
                        <div class="calc-card">
                            <h3>Fixed Risk % Calculator</h3>
                            <p class="card-lede">Calculate position size based on account risk percentage</p>

                            <div class="form-group">
                                <label>Account Size ($)</label>
                                <asp:TextBox ID="txtAccountSize" runat="server" placeholder="10000" TextMode="Number"></asp:TextBox>
                            </div>

                            <div class="form-group">
                                <label>Risk % per Trade</label>
                                <asp:TextBox ID="txtRiskPercent" runat="server" placeholder="2" TextMode="Number" step="0.1"></asp:TextBox>
                                <div class="helper-text">Typical: 1–2% per trade</div>
                            </div>

                            <div class="form-group">
                                <label>Entry Price ($)</label>
                                <asp:TextBox ID="txtFixedEntry" runat="server" placeholder="100" TextMode="Number" step="0.01"></asp:TextBox>
                            </div>

                            <div class="form-group">
                                <label>Stop Loss Price ($)</label>
                                <asp:TextBox ID="txtFixedStop" runat="server" placeholder="98" TextMode="Number" step="0.01"></asp:TextBox>
                            </div>

                            <asp:Button ID="btnFixedRisk" runat="server" Text="Calculate Position Size" CssClass="btn" OnClick="btnFixedRisk_Click" />

                            <div class="result-box" id="fixedRiskResults" runat="server" visible="false">
                                <div class="result-row">
                                    <span class="result-label">Risk Amount</span>
                                    <span class="result-value"><asp:Label ID="lblRiskAmount" runat="server"></asp:Label></span>
                                </div>
                                <div class="result-row">
                                    <span class="result-label">Position Size (Qty)</span>
                                    <span class="result-value"><asp:Label ID="lblPositionSize" runat="server"></asp:Label></span>
                                </div>
                                <div class="result-row">
                                    <span class="result-label">Capital Required</span>
                                    <span class="result-value"><asp:Label ID="lblCapitalRequired" runat="server"></asp:Label></span>
                                </div>
                                <div class="info-box">
                                    Buy <asp:Label ID="lblBuyQty" runat="server"></asp:Label> shares at $<asp:Label ID="lblBuyPrice" runat="server"></asp:Label> with stop at $<asp:Label ID="lblStopPrice" runat="server"></asp:Label>
                                </div>
                            </div>
                        </div>

                        <!-- Kelly Criterion Calculator -->
                        <div class="calc-card">
                            <h3>Kelly Criterion Calculator</h3>
                            <p class="card-lede">Optimal position sizing based on win rate &amp; risk/reward</p>

                            <div class="form-group">
                                <label>Win Rate (%)</label>
                                <asp:TextBox ID="txtWinRate" runat="server" placeholder="60" TextMode="Number" step="0.1"></asp:TextBox>
                                <div class="helper-text">Your historical win rate</div>
                            </div>

                            <div class="form-group">
                                <label>Risk/Reward Ratio</label>
                                <asp:TextBox ID="txtRiskReward" runat="server" placeholder="1" TextMode="Number" step="0.1"></asp:TextBox>
                                <div class="helper-text">Avg win / avg loss (e.g., 1.5 = win $1.50 for every $1 lost)</div>
                            </div>

                            <div class="form-group">
                                <label>Account Size ($)</label>
                                <asp:TextBox ID="txtKellyAccountSize" runat="server" placeholder="10000" TextMode="Number"></asp:TextBox>
                            </div>

                            <asp:Button ID="btnKellyCriterion" runat="server" Text="Calculate Kelly %" CssClass="btn" OnClick="btnKellyCriterion_Click" />

                            <div class="result-box" id="kellyResults" runat="server" visible="false">
                                <div class="result-row">
                                    <span class="result-label">Kelly %</span>
                                    <span class="result-value"><asp:Label ID="lblKellyPercent" runat="server"></asp:Label></span>
                                </div>
                                <div class="result-row">
                                    <span class="result-label">Conservative Kelly (÷2)</span>
                                    <span class="result-value"><asp:Label ID="lblConservativeKelly" runat="server"></asp:Label></span>
                                </div>
                                <div class="result-row">
                                    <span class="result-label">Position Size</span>
                                    <span class="result-value"><asp:Label ID="lblKellyPositionSize" runat="server"></asp:Label></span>
                                </div>
                                <div class="info-box">
                                    Risk <asp:Label ID="lblKellyRiskAmount" runat="server"></asp:Label> per trade<br/>
                                    Conservative: <asp:Label ID="lblKellyConservativeRisk" runat="server"></asp:Label>
                                </div>
                            </div>
                        </div>

                        <!-- Risk/Reward Analyzer -->
                        <div class="calc-card">
                            <h3>Risk/Reward Analyzer</h3>
                            <p class="card-lede">Analyze risk vs potential reward for a trade</p>

                            <div class="form-group">
                                <label>Entry Price ($)</label>
                                <asp:TextBox ID="txtRREntry" runat="server" placeholder="100" TextMode="Number" step="0.01"></asp:TextBox>
                            </div>

                            <div class="form-group">
                                <label>Stop Loss ($)</label>
                                <asp:TextBox ID="txtRRStop" runat="server" placeholder="95" TextMode="Number" step="0.01"></asp:TextBox>
                            </div>

                            <div class="form-group">
                                <label>Take Profit ($)</label>
                                <asp:TextBox ID="txtRRTarget" runat="server" placeholder="110" TextMode="Number" step="0.01"></asp:TextBox>
                            </div>

                            <div class="form-group">
                                <label>Position Size (Qty)</label>
                                <asp:TextBox ID="txtRRQty" runat="server" placeholder="100" TextMode="Number"></asp:TextBox>
                            </div>

                            <asp:Button ID="btnRiskReward" runat="server" Text="Analyze Setup" CssClass="btn" OnClick="btnRiskReward_Click" />

                            <div class="result-box" id="rrResults" runat="server" visible="false">
                                <div class="result-row">
                                    <span class="result-label">Risk per Trade</span>
                                    <span class="result-value negative"><asp:Label ID="lblRRRisk" runat="server"></asp:Label></span>
                                </div>
                                <div class="result-row">
                                    <span class="result-label">Reward if Target Hit</span>
                                    <span class="result-value"><asp:Label ID="lblRRReward" runat="server"></asp:Label></span>
                                </div>
                                <div class="result-row">
                                    <span class="result-label">R:R Ratio</span>
                                    <span class="result-value"><asp:Label ID="lblRRRatio" runat="server"></asp:Label></span>
                                </div>
                                <div class="info-box">
                                    Risk <asp:Label ID="lblRRInfo" runat="server"></asp:Label> to make <asp:Label ID="lblRewardInfo" runat="server"></asp:Label>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
    <script src="Site.js"></script>
</body>
</html>

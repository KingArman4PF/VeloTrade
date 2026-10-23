<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SetupScreener.aspx.cs" Inherits="WebApplication1.SetupScreener" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>VeloTrade — Setup Screener</title>
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
                    <a class="nav-link active" href="SetupScreener.aspx"><span class="ic">◎</span> Setup Screener</a>
                    <a class="nav-link" href="SetupManager.aspx"><span class="ic">▤</span> Setup Manager</a>
                    <a class="nav-link" href="RiskCalculator.aspx"><span class="ic">△</span> Risk Calculator</a>
                </nav>
                <div class="sidebar-foot">VeloTrade &middot; Personal Journal</div>
            </aside>

            <div class="main">
                <header class="topbar">
                    <button type="button" class="menu-toggle">☰</button>
                    <div>
                        <h1>Setup Screener</h1>
                        <div class="sub">Filter your history to find your most profitable patterns</div>
                    </div>
                    <div class="topbar-right">
                        <div class="session-pill"><span class="live-dot"></span> <span class="txt" id="liveClock">--:--:--</span></div>
                    </div>
                </header>

                <div class="page">
                    <div class="card">
                        <h3>Screen Your Trading Setup Performance</h3>
                        <p class="card-lede">Filter your trades by setup criteria to find your most profitable patterns</p>

                        <div class="form-group">
                            <label>Filter by Win Rate (%)</label>
                            <asp:TextBox ID="txtMinWinRate" runat="server" placeholder="50" TextMode="Number" step="1"></asp:TextBox>
                        </div>

                        <div class="form-group">
                            <label>Filter by Min Profit Factor</label>
                            <asp:TextBox ID="txtMinProfitFactor" runat="server" placeholder="1.0" TextMode="Number" step="0.1"></asp:TextBox>
                        </div>

                        <div class="form-group">
                            <label>Filter by Min Trades in Setup</label>
                            <asp:TextBox ID="txtMinTrades" runat="server" placeholder="5" TextMode="Number"></asp:TextBox>
                        </div>

                        <asp:Button ID="btnScreen" runat="server" Text="Screen Setups" CssClass="btn" OnClick="btnScreen_Click" />

                        <div id="resultsDiv" runat="server" visible="false">
                            <h2 class="section-title">Setup Performance Results</h2>
                            <asp:Panel ID="pnlResults" runat="server"></asp:Panel>
                        </div>

                        <div class="empty-state" id="emptyDiv" runat="server">
                            Enter your screening criteria and select "Screen Setups" to analyze your trading patterns
                        </div>
                    </div>

                    <div class="info-box" style="margin-top: 1.5rem;">
                        <strong>How it works:</strong> this screener analyzes your trade history and identifies which symbols and setups are most profitable. Use it to focus on your best-performing patterns and drop the underperforming ones.
                    </div>
                </div>
            </div>
        </div>
    </form>
    <script src="Site.js"></script>
</body>
</html>

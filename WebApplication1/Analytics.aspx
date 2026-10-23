<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Analytics.aspx.cs" Inherits="WebApplication1.Analytics" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>VeloTrade — Analytics</title>
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
                    <a class="nav-link active" href="Analytics.aspx"><span class="ic">◧</span> Analytics</a>
                    <a class="nav-link" href="Charts.aspx"><span class="ic">◨</span> Charts</a>
                    <div class="nav-eyebrow">Strategy</div>
                    <a class="nav-link" href="MarketAlerts.aspx"><span class="ic">◔</span> Market Alerts</a>
                    <a class="nav-link" href="SetupScreener.aspx"><span class="ic">◎</span> Setup Screener</a>
                    <a class="nav-link" href="SetupManager.aspx"><span class="ic">▤</span> Setup Manager</a>
                    <a class="nav-link" href="RiskCalculator.aspx"><span class="ic">△</span> Risk Calculator</a>
                </nav>
                <div class="sidebar-foot">VeloTrade &middot; Personal Journal</div>
            </aside>

            <div class="main">
                <header class="topbar">
                    <button type="button" class="menu-toggle">☰</button>
                    <div>
                        <h1>Trading Analytics</h1>
                        <div class="sub">Performance broken down by outcome, P/L, and risk</div>
                    </div>
                    <div class="topbar-right">
                        <div class="session-pill"><span class="live-dot"></span> <span class="txt" id="liveClock">--:--:--</span></div>
                    </div>
                </header>

                <div class="page">
                    <div class="grid">
                        <div class="card">
                            <h3>Overall Performance</h3>
                            <div class="stat-row">
                                <span class="stat-label">Total Trades</span>
                                <span class="stat-value"><asp:Label ID="lblTotalTrades" runat="server" Text="0"></asp:Label></span>
                            </div>
                            <div class="stat-row">
                                <span class="stat-label">Closed Trades</span>
                                <span class="stat-value"><asp:Label ID="lblClosedTrades" runat="server" Text="0"></asp:Label></span>
                            </div>
                            <div class="stat-row">
                                <span class="stat-label">Open Trades</span>
                                <span class="stat-value neutral"><asp:Label ID="lblOpenTrades" runat="server" Text="0"></asp:Label></span>
                            </div>
                        </div>

                        <div class="card">
                            <h3>Win Statistics</h3>
                            <div class="stat-row">
                                <span class="stat-label">Wins</span>
                                <span class="stat-value positive"><asp:Label ID="lblWins" runat="server" Text="0"></asp:Label></span>
                            </div>
                            <div class="stat-row">
                                <span class="stat-label">Losses</span>
                                <span class="stat-value negative"><asp:Label ID="lblLosses" runat="server" Text="0"></asp:Label></span>
                            </div>
                            <div class="stat-row">
                                <span class="stat-label">Break Even</span>
                                <span class="stat-value neutral"><asp:Label ID="lblBreakEven" runat="server" Text="0"></asp:Label></span>
                            </div>
                            <div class="stat-row">
                                <span class="stat-label">Win Rate</span>
                                <span class="stat-value"><asp:Label ID="lblWinRate" runat="server" Text="0%"></asp:Label></span>
                            </div>
                            <div class="progress-bar">
                                <div class="progress-fill" id="winRateBar" style="width: 0%;"></div>
                            </div>
                        </div>

                        <div class="card">
                            <h3>Profit &amp; Loss</h3>
                            <div class="stat-row">
                                <span class="stat-label">Total P/L</span>
                                <span class="stat-value"><asp:Label ID="lblTotalPL" runat="server" Text="$0.00"></asp:Label></span>
                            </div>
                            <div class="stat-row">
                                <span class="stat-label">Avg Win</span>
                                <span class="stat-value positive"><asp:Label ID="lblAvgWin" runat="server" Text="$0.00"></asp:Label></span>
                            </div>
                            <div class="stat-row">
                                <span class="stat-label">Avg Loss</span>
                                <span class="stat-value negative"><asp:Label ID="lblAvgLoss" runat="server" Text="$0.00"></asp:Label></span>
                            </div>
                            <div class="stat-row">
                                <span class="stat-label">Profit Factor</span>
                                <span class="stat-value"><asp:Label ID="lblProfitFactor" runat="server" Text="0.00"></asp:Label></span>
                            </div>
                        </div>

                        <div class="card">
                            <h3>Risk Metrics</h3>
                            <div class="stat-row">
                                <span class="stat-label">Max Win</span>
                                <span class="stat-value positive"><asp:Label ID="lblMaxWin" runat="server" Text="$0.00"></asp:Label></span>
                            </div>
                            <div class="stat-row">
                                <span class="stat-label">Max Loss</span>
                                <span class="stat-value negative"><asp:Label ID="lblMaxLoss" runat="server" Text="$0.00"></asp:Label></span>
                            </div>
                            <div class="stat-row">
                                <span class="stat-label">Risk/Reward Ratio</span>
                                <span class="stat-value"><asp:Label ID="lblRiskReward" runat="server" Text="0.00"></asp:Label></span>
                            </div>
                        </div>
                    </div>

                    <h2 class="section-title">Top Trading Symbols</h2>
                    <asp:Panel ID="pnlTopSymbols" runat="server"></asp:Panel>
                </div>
            </div>
        </div>
    </form>
    <script src="Site.js"></script>
</body>
</html>

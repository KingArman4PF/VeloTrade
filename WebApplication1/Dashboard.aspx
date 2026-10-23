<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="WebApplication1.Dashboard" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>VeloTrade — Dashboard</title>
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
                    <a class="nav-link active" href="Dashboard.aspx"><span class="ic">▣</span> Dashboard</a>
                    <a class="nav-link" href="TradeEntry.aspx"><span class="ic">✚</span> New Trade</a>
                    <a class="nav-link" href="TradeHistory.aspx"><span class="ic">≣</span> Trade History</a>
                    <a class="nav-link" href="Analytics.aspx"><span class="ic">◧</span> Analytics</a>
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
                        <h1>Dashboard</h1>
                        <div class="sub">Your trading performance at a glance</div>
                    </div>
                    <div class="topbar-right">
                        <div class="session-pill"><span class="live-dot"></span> <span class="txt" id="liveClock">--:--:--</span></div>
                    </div>
                </header>

                <div class="page">
                    <div class="market-watch">
                        <div class="tradingview-widget-container">
                            <div class="tradingview-widget-container__widget"></div>
                            <script type="text/javascript" src="https://s3.tradingview.com/external-embedding/embed-widget-ticker-tape.js" async>
                            {
                              "symbols": [
                                { "proName": "FX:EURUSD", "title": "EUR/USD" },
                                { "proName": "FX:GBPUSD", "title": "GBP/USD" },
                                { "proName": "FX:USDJPY", "title": "USD/JPY" },
                                { "proName": "OANDA:XAUUSD", "title": "Gold" },
                                { "proName": "BINANCE:BTCUSDT", "title": "BTC/USD" },
                                { "proName": "BINANCE:ETHUSDT", "title": "ETH/USD" },
                                { "proName": "NASDAQ:AAPL", "title": "Apple" },
                                { "proName": "NASDAQ:TSLA", "title": "Tesla" },
                                { "proName": "NASDAQ:NVDA", "title": "NVIDIA" }
                              ],
                              "showSymbolLogo": true,
                              "isTransparent": true,
                              "displayMode": "adaptive",
                              "colorTheme": "dark",
                              "locale": "en"
                            }
                            </script>
                        </div>
                    </div>

                    <h2 class="section-title">Quick Stats</h2>
                    <div class="grid">
                        <div class="hud-card">
                            <span class="hud-corner tl"></span><span class="hud-corner tr"></span>
                            <span class="hud-corner bl"></span><span class="hud-corner br"></span>
                            <h3>Total Trades</h3>
                            <div class="hud-value"><asp:Label ID="lblTotalTrades" runat="server" Text="0"></asp:Label></div>
                        </div>
                        <div class="hud-card">
                            <span class="hud-corner tl"></span><span class="hud-corner tr"></span>
                            <span class="hud-corner bl"></span><span class="hud-corner br"></span>
                            <h3>Win Rate</h3>
                            <div class="hud-value"><asp:Label ID="lblWinRate" runat="server" Text="0%"></asp:Label></div>
                        </div>
                        <div class="hud-card">
                            <span class="hud-corner tl"></span><span class="hud-corner tr"></span>
                            <span class="hud-corner bl"></span><span class="hud-corner br"></span>
                            <h3>Total Profit/Loss</h3>
                            <div class="hud-value"><asp:Label ID="lblTotalPL" runat="server" Text="$0.00"></asp:Label></div>
                        </div>
                        <div class="hud-card">
                            <span class="hud-corner tl"></span><span class="hud-corner tr"></span>
                            <span class="hud-corner bl"></span><span class="hud-corner br"></span>
                            <h3>Avg Win</h3>
                            <div class="hud-value"><asp:Label ID="lblAvgWin" runat="server" Text="$0.00"></asp:Label></div>
                        </div>
                    </div>

                    <h2 class="section-title">Recent Trades</h2>
                    <asp:GridView ID="gvRecentTrades" runat="server" CssClass="table" AutoGenerateColumns="false">
                        <Columns>
                            <asp:BoundField DataField="symbol" HeaderText="Symbol" />
                            <asp:BoundField DataField="trade_type" HeaderText="Type" />
                            <asp:BoundField DataField="entry_price" HeaderText="Entry" DataFormatString="{0:C}" />
                            <asp:BoundField DataField="exit_price" HeaderText="Exit" DataFormatString="{0:C}" />
                            <asp:BoundField DataField="result" HeaderText="Result" />
                            <asp:BoundField DataField="entry_date" HeaderText="Date" DataFormatString="{0:yyyy-MM-dd}" />
                        </Columns>
                        <EmptyDataTemplate>
                            <div class="empty-state">No trades yet. Log your first trade to see it here.</div>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </div>
            </div>
        </div>
    </form>
    <script src="Site.js"></script>
</body>
</html>
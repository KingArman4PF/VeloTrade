<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SetupManager.aspx.cs" Inherits="WebApplication1.SetupManager" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>VeloTrade — Setup Manager</title>
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
                    <a class="nav-link active" href="SetupManager.aspx"><span class="ic">▤</span> Setup Manager</a>
                    <a class="nav-link" href="RiskCalculator.aspx"><span class="ic">△</span> Risk Calculator</a>
                </nav>
                <div class="sidebar-foot">VeloTrade &middot; Personal Journal</div>
            </aside>

            <div class="main">
                <header class="topbar">
                    <button type="button" class="menu-toggle">☰</button>
                    <div>
                        <h1>Setup Manager</h1>
                        <div class="sub">Document the trading setups you actually follow</div>
                    </div>
                    <div class="topbar-right">
                        <div class="session-pill"><span class="live-dot"></span> <span class="txt" id="liveClock">--:--:--</span></div>
                    </div>
                </header>

                <div class="page">
                    <div class="grid-2">
                        <div class="card">
                            <h3>Create New Setup</h3>

                            <asp:Label ID="lblMessage" runat="server" Visible="false" CssClass="message"></asp:Label>

                            <div class="form-group">
                                <label>Setup Name *</label>
                                <asp:TextBox ID="txtSetupName" runat="server" placeholder="e.g., Breakout above MA, MACD Divergence"></asp:TextBox>
                            </div>

                            <div class="form-group">
                                <label>Description/Rules *</label>
                                <asp:TextBox ID="txtSetupDescription" runat="server" TextMode="MultiLine" Rows="5" placeholder="Describe your setup criteria and entry/exit rules"></asp:TextBox>
                            </div>

                            <div class="form-group">
                                <label>Target Markets</label>
                                <asp:TextBox ID="txtTargetMarkets" runat="server" placeholder="e.g., Stocks, Crypto, Forex"></asp:TextBox>
                            </div>

                            <div class="form-group">
                                <label>Best Timeframe</label>
                                <asp:TextBox ID="txtTimeframe" runat="server" placeholder="e.g., 4H, Daily, Weekly"></asp:TextBox>
                            </div>

                            <asp:Button ID="btnCreateSetup" runat="server" Text="Save Setup" CssClass="btn" OnClick="btnCreateSetup_Click" />
                        </div>

                        <div class="card">
                            <h3>Your Trading Setups</h3>

                            <asp:Repeater ID="rptSetups" runat="server" OnItemCommand="rptSetups_ItemCommand">
                                <ItemTemplate>
                                    <div class="list-item setup-item" style="align-items: flex-start;">
                                        <div class="item-info">
                                            <div class="setup-name"><%# Eval("setup_name") %></div>
                                            <div class="setup-details">
                                                <strong>Rules:</strong> <%# Eval("description") %><br/>
                                                <strong>Markets:</strong> <%# Eval("target_markets") %> &middot; <strong>Timeframe:</strong> <%# Eval("timeframe") %><br/>
                                                <small>Created: <%# Eval("created_at", "{0:MMM dd, yyyy HH:mm}") %></small>
                                            </div>
                                        </div>
                                        <asp:Button runat="server" Text="✕ Delete" CssClass="btn btn-danger"
                                            CommandName="Delete" CommandArgument='<%# Eval("setup_id") %>'
                                            OnClientClick="return confirm('Delete this setup?');" />
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>

                            <asp:Panel ID="pnlSetupsEmpty" runat="server" CssClass="empty-state" Visible="false">
                                No setups created yet. Start by creating one!
                            </asp:Panel>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
    <script src="Site.js"></script>
</body>
</html>

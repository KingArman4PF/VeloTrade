<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MarketAlerts.aspx.cs" Inherits="WebApplication1.MarketAlerts" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>VeloTrade — Market Alerts</title>
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
                    <a class="nav-link active" href="MarketAlerts.aspx"><span class="ic">◔</span> Market Alerts</a>
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
                        <h1>Market Alerts</h1>
                        <div class="sub">Get notified when a symbol crosses a price level</div>
                    </div>
                    <div class="topbar-right">
                        <div class="session-pill"><span class="live-dot"></span> <span class="txt" id="liveClock">--:--:--</span></div>
                    </div>
                </header>

                <div class="page">
                    <div class="grid-2">
                        <div class="card">
                            <h3>Create New Alert</h3>

                            <asp:Label ID="lblMessage" runat="server" Visible="false" CssClass="message"></asp:Label>

                            <div class="form-group">
                                <label>Symbol *</label>
                                <div class="combo-wrap">
                                    <asp:TextBox ID="txtSymbol" runat="server" placeholder="Type to search forex, crypto, stocks..." CssClass="mono" autocomplete="off"></asp:TextBox>
                                    <div class="combo-list" id="symbolCombo"></div>
                                </div>
                            </div>

                            <div class="form-group">
                                <label>Alert Type *</label>
                                <select id="ddlAlertType" runat="server">
                                    <option value="PRICE_ABOVE">Price Above</option>
                                    <option value="PRICE_BELOW">Price Below</option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label>Price Level ($) *</label>
                                <asp:TextBox ID="txtPrice" runat="server" placeholder="0.00" TextMode="Number" step="0.01"></asp:TextBox>
                            </div>

                            <asp:Button ID="btnCreateAlert" runat="server" Text="Create Alert" CssClass="btn" OnClick="btnCreateAlert_Click" />
                        </div>

                        <div class="card">
                            <h3>Active Alerts</h3>

                            <asp:Repeater ID="rptAlerts" runat="server" OnItemCommand="rptAlerts_ItemCommand">
                                <ItemTemplate>
                                    <div class="list-item alert-item">
                                        <div class="alert-info">
                                            <div class="alert-symbol"><%# Eval("symbol") %></div>
                                            <div class="alert-details">
                                                <%# Eval("alert_type").ToString() == "PRICE_ABOVE" ? "⬆ Price Above" : "⬇ Price Below" %>
                                                $<%# Eval("condition_value", "{0:F2}") %> &middot; Created <%# Eval("created_at", "{0:MMM dd, yyyy HH:mm}") %>
                                            </div>
                                        </div>
                                        <asp:Button runat="server" Text="✕ Delete" CssClass="btn btn-danger"
                                            CommandName="Delete" CommandArgument='<%# Eval("alert_id") %>' />
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>

                            <asp:Panel ID="pnlAlertsEmpty" runat="server" CssClass="empty-state" Visible="false">
                                No active alerts. Create one to get started!
                            </asp:Panel>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
    <script src="Symbols.js"></script>
    <script src="Site.js"></script>
    <script>
        vtInitSymbolCombo('<%= txtSymbol.ClientID %>', 'symbolCombo');
    </script>
</body>
</html>

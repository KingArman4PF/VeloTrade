<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TradeEntry.aspx.cs" Inherits="WebApplication1.TradeEntry" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>VeloTrade — New Trade</title>
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
                    <a class="nav-link active" href="TradeEntry.aspx"><span class="ic">✚</span> New Trade</a>
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
                        <h1>Log New Trade</h1>
                        <div class="sub">Record entries, exits, and the reasoning behind them</div>
                    </div>
                    <div class="topbar-right">
                        <div class="session-pill"><span class="live-dot"></span> <span class="txt" id="liveClock">--:--:--</span></div>
                    </div>
                </header>

                <div class="page" style="max-width: 640px;">
                    <asp:Label ID="lblMessage" runat="server" Visible="false" CssClass="message"></asp:Label>

                    <div class="card">
                        <div class="form-group">
                            <label>Symbol (e.g., EURUSD, BTC) *</label>
                            <div class="combo-wrap">
                                <asp:TextBox ID="txtSymbol" runat="server" placeholder="Type to search forex, crypto, stocks..." CssClass="mono" autocomplete="off"></asp:TextBox>
                                <div class="combo-list" id="symbolCombo"></div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label>Trade Type *</label>
                            <asp:DropDownList ID="ddlTradeType" runat="server">
                                <asp:ListItem Value="LONG">LONG</asp:ListItem>
                                <asp:ListItem Value="SHORT">SHORT</asp:ListItem>
                            </asp:DropDownList>
                        </div>

                        <div class="form-group">
                            <label>Entry Price ($) *</label>
                            <asp:TextBox ID="txtEntryPrice" runat="server" placeholder="0.00" TextMode="Number"></asp:TextBox>
                        </div>

                        <div class="form-group">
                            <label>Quantity *</label>
                            <asp:TextBox ID="txtQuantity" runat="server" placeholder="100" TextMode="Number"></asp:TextBox>
                        </div>

                        <div class="form-group">
                            <label>Entry Date &amp; Time *</label>
                            <asp:TextBox ID="txtEntryDate" runat="server" TextMode="DateTimeLocal"></asp:TextBox>
                        </div>

                        <div class="form-group">
                            <label>Exit Price ($)</label>
                            <asp:TextBox ID="txtExitPrice" runat="server" placeholder="0.00" TextMode="Number"></asp:TextBox>
                            <div class="helper-text">Leave blank if the trade is still open</div>
                        </div>

                        <div class="form-group">
                            <label>Exit Date &amp; Time</label>
                            <asp:TextBox ID="txtExitDate" runat="server" TextMode="DateTimeLocal"></asp:TextBox>
                        </div>

                        <div class="form-group">
                            <label>Trade Reasoning *</label>
                            <asp:TextBox ID="txtReasoning" runat="server" TextMode="MultiLine" Rows="4" placeholder="Why did you enter this trade?"></asp:TextBox>
                        </div>

                        <div class="form-group">
                            <label>Notes</label>
                            <asp:TextBox ID="txtNotes" runat="server" TextMode="MultiLine" Rows="3" placeholder="Additional observations..."></asp:TextBox>
                        </div>

                        <div class="button-group">
                            <asp:Button ID="btnSubmit" runat="server" Text="Save Trade" CssClass="btn" OnClick="btnSubmit_Click" />
                            <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn btn-secondary" OnClick="btnCancel_Click" />
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

<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TradeHistory.aspx.cs" Inherits="WebApplication1.TradeHistory" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>VeloTrade — Trade History</title>
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
                    <a class="nav-link active" href="TradeHistory.aspx"><span class="ic">≣</span> Trade History</a>
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
                        <h1>Trade History</h1>
                        <div class="sub">Every trade you've logged, filterable by outcome</div>
                    </div>
                    <div class="topbar-right">
                        <div class="session-pill"><span class="live-dot"></span> <span class="txt" id="liveClock">--:--:--</span></div>
                    </div>
                </header>

                <div class="page">
                    <div class="filter-section">
                        <div class="filter-group">
                            <label>Filter by:</label>
                            <select id="ddlStatus" runat="server">
                                <option value="">All Trades</option>
                                <option value="WIN">Wins Only</option>
                                <option value="LOSS">Losses Only</option>
                                <option value="OPEN">Open Trades</option>
                            </select>
                            <asp:Button ID="btnFilter" runat="server" Text="Apply Filter" CssClass="btn" OnClick="btnFilter_Click" />
                        </div>
                    </div>

                    <asp:GridView ID="gvTrades" runat="server" CssClass="table" AutoGenerateColumns="false" AllowPaging="true" PageSize="20" OnPageIndexChanging="gvTrades_PageIndexChanging" OnRowCommand="gvTrades_RowCommand">
                        <Columns>
                            <asp:BoundField DataField="trade_id" HeaderText="ID" />
                            <asp:BoundField DataField="symbol" HeaderText="Symbol" />
                            <asp:BoundField DataField="trade_type" HeaderText="Type" />
                            <asp:BoundField DataField="entry_price" HeaderText="Entry" DataFormatString="{0:C}" />
                            <asp:BoundField DataField="exit_price" HeaderText="Exit" DataFormatString="{0:C}" />
                            <asp:BoundField DataField="quantity" HeaderText="Qty" />
                            <asp:BoundField DataField="profit_loss" HeaderText="P/L" DataFormatString="{0:C}" />
                            <asp:TemplateField HeaderText="Result">
                                <ItemTemplate>
                                    <span class='<%# Eval("result").ToString() == "WIN" ? "win" : Eval("result").ToString() == "LOSS" ? "loss" : "open" %>'>
                                        <%# Eval("result") %>
                                    </span>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="entry_date" HeaderText="Entry Date" DataFormatString="{0:yyyy-MM-dd HH:mm}" />
                            <asp:BoundField DataField="exit_date" HeaderText="Exit Date" DataFormatString="{0:yyyy-MM-dd HH:mm}" NullDisplayText="Open" />
                            <asp:TemplateField HeaderText="">
                                <ItemTemplate>
                                    <asp:Button runat="server" Text="✕" CssClass="btn btn-danger"
                                        CommandName="DeleteTrade" CommandArgument='<%# Eval("trade_id") %>'
                                        OnClientClick="return confirm('Delete this trade permanently?');" />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <EmptyDataTemplate>
                            <div class="empty-state">No trades match this filter yet.</div>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </div>
            </div>
        </div>
    </form>
    <script src="Site.js"></script>
</body>
</html>

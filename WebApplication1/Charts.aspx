<%@ Page Language="C#" AutoEventWireup="true" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>VeloTrade — Charts</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@500;600;700&family=Inter:wght@400;500;600&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="Site.css" />
    <script src="https://unpkg.com/lightweight-charts@4.1.0/dist/lightweight-charts.standalone.production.js"></script>
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
                    <a class="nav-link active" href="Charts.aspx"><span class="ic">◨</span> Charts</a>
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
                        <h1>Charts</h1>
                        <div class="sub">Price action with your own entries and exits marked</div>
                    </div>
                    <div class="topbar-right">
                        <div class="session-pill"><span class="live-dot"></span> <span class="txt" id="liveClock">--:--:--</span></div>
                    </div>
                </header>

                <div class="page">
                    <div class="card" style="margin-bottom: 1.5rem;">
                        <div class="filter-group">
                            <div class="combo-wrap" style="min-width: 240px;">
                                <label style="margin-bottom: 0.3rem;">Symbol</label>
                                <input type="text" id="chartSymbol" class="mono" placeholder="Type to search..." autocomplete="off" value="EURUSD" />
                                <div class="combo-list" id="symbolCombo"></div>
                            </div>
                            <div>
                                <label style="margin-bottom: 0.3rem;">Timeframe</label>
                                <select id="chartInterval">
                                    <option value="5min">5 Minute</option>
                                    <option value="15min">15 Minute</option>
                                    <option value="1h">1 Hour</option>
                                    <option value="4h">4 Hour</option>
                                    <option value="1day" selected>1 Day</option>
                                    <option value="1week">1 Week</option>
                                </select>
                            </div>
                            <button type="button" class="btn" id="btnLoadChart" style="width: auto; padding: 0.7rem 1.5rem; margin-top: 1.4rem;">Refresh Now</button>
                        </div>
                        <div class="helper-text" style="margin-top: 0.75rem;">Chart loads automatically when you change symbol or timeframe, and refreshes the latest candle every 30 seconds while this page is open.</div>
                    </div>

                    <div class="card" style="padding: 0.5rem;">
                        <div id="chartStatus" class="empty-state" style="padding: 4rem 1rem;">Choose a symbol and timeframe, then select "Load Chart"</div>
                        <div id="chartContainer" style="width: 100%; height: 560px; display: none;"></div>
                    </div>

                    <div class="info-box" style="margin-top: 1.5rem;">
                        <strong>Reading the markers:</strong> an arrow marks where you entered (up = LONG, down = SHORT), and a circle marks the exit, colored by outcome — green for a win, red for a loss, gold for break-even/open. Data is candle data from Twelve Data; your entries and exits come straight from your own trade log.
                    </div>
                </div>
            </div>
        </div>
    </form>
    <script src="Symbols.js"></script>
    <script src="Site.js"></script>
    <script>
        vtInitSymbolCombo('chartSymbol', 'symbolCombo');

        (function () {
            var chart = null;
            var series = null;
            var pollTimer = null;
            var debounceTimer = null;
            var lastLoadedSymbol = null;

            function intervalToMinutes(interval) {
                var map = { "5min": 5, "15min": 15, "1h": 60, "4h": 240, "1day": 1440, "1week": 10080 };
                return map[interval] || 1440;
            }

            function fetchMarkers(symbol) {
                if (!series) return;
                fetch('TradeMarkers.ashx?symbol=' + encodeURIComponent(symbol))
                    .then(function (r) { return r.json(); })
                    .then(function (markers) {
                        if (Array.isArray(markers)) series.setMarkers(markers);
                    })
                    .catch(function () { /* markers are best-effort */ });
            }

            function loadChart() {
                var symbol = document.getElementById('chartSymbol').value.trim().toUpperCase();
                var interval = document.getElementById('chartInterval').value;
                var statusEl = document.getElementById('chartStatus');
                var containerEl = document.getElementById('chartContainer');

                if (pollTimer) { clearInterval(pollTimer); pollTimer = null; }

                if (!symbol) {
                    statusEl.textContent = 'Enter a symbol first.';
                    statusEl.style.display = 'block';
                    containerEl.style.display = 'none';
                    return;
                }

                statusEl.textContent = 'Loading ' + symbol + '...';
                statusEl.style.display = 'block';
                containerEl.style.display = 'none';
                lastLoadedSymbol = symbol;

                fetch('ChartData.ashx?symbol=' + encodeURIComponent(symbol) + '&interval=' + encodeURIComponent(interval))
                    .then(function (r) { return r.json(); })
                    .then(function (data) {
                        if (data.error || data.code) {
                            statusEl.textContent = 'Could not load data: ' + (data.error || data.message || 'unknown error');
                            return;
                        }
                        if (!data.values || !data.values.length) {
                            statusEl.textContent = 'No price data returned for ' + symbol + '.';
                            return;
                        }

                        var candles = data.values.map(function (v) {
                            var t = Math.floor(new Date(v.datetime.replace(' ', 'T') + 'Z').getTime() / 1000);
                            return {
                                time: t,
                                open: parseFloat(v.open),
                                high: parseFloat(v.high),
                                low: parseFloat(v.low),
                                close: parseFloat(v.close)
                            };
                        });

                        statusEl.style.display = 'none';
                        containerEl.style.display = 'block';
                        containerEl.innerHTML = '';

                        chart = LightweightCharts.createChart(containerEl, {
                            layout: {
                                background: { color: 'transparent' },
                                textColor: '#8D93A6',
                                fontFamily: "'JetBrains Mono', monospace"
                            },
                            grid: {
                                vertLines: { color: '#1A2030' },
                                horzLines: { color: '#1A2030' }
                            },
                            rightPriceScale: { borderColor: '#232838' },
                            timeScale: { borderColor: '#232838', timeVisible: intervalToMinutes(interval) < 1440 },
                            crosshair: { mode: LightweightCharts.CrosshairMode.Normal },
                            width: containerEl.clientWidth,
                            height: 560
                        });

                        series = chart.addCandlestickSeries({
                            upColor: '#34D399',
                            downColor: '#F87171',
                            borderVisible: false,
                            wickUpColor: '#34D399',
                            wickDownColor: '#F87171'
                        });

                        series.setData(candles);
                        chart.timeScale().fitContent();
                        fetchMarkers(symbol);

                        // Poll for the latest bar every 30s — free-tier friendly,
                        // and this is as "live" as a non-WebSocket plan gets.
                        pollTimer = setInterval(function () { pollLatest(symbol, interval); }, 30000);

                        window.addEventListener('resize', function () {
                            if (chart) chart.applyOptions({ width: containerEl.clientWidth });
                        });
                    })
                    .catch(function (err) {
                        statusEl.style.display = 'block';
                        containerEl.style.display = 'none';
                        statusEl.textContent = 'Request failed: ' + err.message;
                    });
            }

            function pollLatest(symbol, interval) {
                if (symbol !== lastLoadedSymbol || !series) return;

                fetch('ChartData.ashx?symbol=' + encodeURIComponent(symbol) + '&interval=' + encodeURIComponent(interval) + '&t=' + Date.now())
                    .then(function (r) { return r.json(); })
                    .then(function (data) {
                        if (!data.values || !data.values.length || symbol !== lastLoadedSymbol) return;
                        var latest = data.values[data.values.length - 1];
                        var t = Math.floor(new Date(latest.datetime.replace(' ', 'T') + 'Z').getTime() / 1000);
                        series.update({
                            time: t,
                            open: parseFloat(latest.open),
                            high: parseFloat(latest.high),
                            low: parseFloat(latest.low),
                            close: parseFloat(latest.close)
                        });
                    })
                    .catch(function () { /* silent — next poll will retry */ });
            }

            // Auto-load whenever the timeframe changes
            document.getElementById('chartInterval').addEventListener('change', loadChart);

            // Auto-load as you type a symbol, debounced so it doesn't fire on every keystroke
            document.getElementById('chartSymbol').addEventListener('input', function () {
                clearTimeout(debounceTimer);
                debounceTimer = setTimeout(loadChart, 600);
            });

            // Picking a symbol from the dropdown fires 'change' on the input (see Site.js) — load immediately
            document.getElementById('chartSymbol').addEventListener('change', loadChart);

            // Manual refresh button, in case you want to force it right now
            document.getElementById('btnLoadChart').addEventListener('click', loadChart);

            // Initial load for the default symbol
            loadChart();
        })();
    </script>
</body>
</html>

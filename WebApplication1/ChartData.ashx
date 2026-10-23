<%@ WebHandler Language="C#" Class="ChartData" %>

using System;
using System.Web;
using System.Net;
using System.Configuration;
using System.Collections.Generic;
using System.Text.RegularExpressions;

// Proxies Twelve Data's /time_series endpoint so the API key never reaches
// the browser, and caches each (symbol, interval) response briefly so
// repeated chart loads don't burn through the free-tier daily quota.
public class ChartData : IHttpHandler
{
    private static readonly Dictionary<string, CacheEntry> _cache = new Dictionary<string, CacheEntry>();
    private static readonly object _lock = new object();
    private static readonly TimeSpan CacheDuration = TimeSpan.FromMinutes(2);

    private class CacheEntry
    {
        public DateTime FetchedAt;
        public string Json;
    }

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "application/json";

        string symbol = context.Request.QueryString["symbol"];
        string interval = context.Request.QueryString["interval"];

        if (string.IsNullOrWhiteSpace(interval)) interval = "1day";
        if (string.IsNullOrWhiteSpace(symbol))
        {
            context.Response.StatusCode = 400;
            context.Response.Write("{\"error\":\"symbol is required\"}");
            return;
        }

        symbol = NormalizeSymbol(symbol.Trim().ToUpper());
        string cacheKey = symbol + "|" + interval;

        lock (_lock)
        {
            CacheEntry cached;
            if (_cache.TryGetValue(cacheKey, out cached) &&
            DateTime.UtcNow - cached.FetchedAt < CacheDuration)
            {
                context.Response.Write(cached.Json);
                return;
            }
        }

        try
        {
            string apiKey = ConfigurationManager.AppSettings["TwelveDataApiKey"];
            if (string.IsNullOrWhiteSpace(apiKey) || apiKey == "YOUR_API_KEY_HERE")
            {
                context.Response.StatusCode = 500;
                context.Response.Write("{\"error\":\"TwelveDataApiKey is not set in Web.config\"}");
                return;
            }

            string url = string.Format(
                "https://api.twelvedata.com/time_series?symbol={0}&interval={1}&outputsize=300&order=asc&apikey={2}",
                Uri.EscapeDataString(symbol), Uri.EscapeDataString(interval), apiKey);

            using (WebClient client = new WebClient())
            {
                string json = client.DownloadString(url);

                lock (_lock)
                {
                    _cache[cacheKey] = new CacheEntry { FetchedAt = DateTime.UtcNow, Json = json };
                }

                context.Response.Write(json);
            }
        }
        catch (WebException wex)
        {
            context.Response.StatusCode = 502;
            context.Response.Write("{\"error\":\"Upstream request failed: " + wex.Message.Replace("\"", "'") + "\"}");
        }
        catch (Exception ex)
        {
            context.Response.StatusCode = 500;
            context.Response.Write("{\"error\":\"" + ex.Message.Replace("\"", "'") + "\"}");
        }
    }

    // Twelve Data expects forex/crypto pairs as "EUR/USD" or "BTC/USD".
    // VeloTrade stores/types them without a slash (e.g. "EURUSD", "BTCUSD").
    // Best-effort conversion: a plain 6-letter alphabetic symbol with no
    // slash gets a "/" inserted after the 3rd character. Stock tickers
    // (AAPL, MSFT, BRK.B, etc.) are left untouched.
    private static string NormalizeSymbol(string symbol)
    {
        if (symbol.Contains("/")) return symbol;
        if (Regex.IsMatch(symbol, "^[A-Z]{6}$"))
        {
            return symbol.Substring(0, 3) + "/" + symbol.Substring(3);
        }
        return symbol;
    }

        public bool IsReusable
        {
            get { return false; }
        }
}
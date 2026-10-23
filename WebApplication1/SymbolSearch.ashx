<%@ WebHandler Language="C#" Class="SymbolSearch" %>

using System;
using System.Web;
using System.Net;
using System.Configuration;
using System.Collections.Generic;

// Proxies Twelve Data's /symbol_search endpoint so the API key never
// reaches the browser, with a short cache per query text since the
// same partial search (e.g. "EUR") gets typed repeatedly across sessions.
public class SymbolSearch : IHttpHandler
{
    private static readonly Dictionary<string, CacheEntry> _cache = new Dictionary<string, CacheEntry>();
    private static readonly object _lock = new object();
    private static readonly TimeSpan CacheDuration = TimeSpan.FromMinutes(10);

    private class CacheEntry
    {
        public DateTime FetchedAt;
        public string Json;
    }

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "application/json";

        string query = context.Request.QueryString["q"];
        if (string.IsNullOrWhiteSpace(query))
        {
            context.Response.Write("{\"data\":[]}");
            return;
        }

        query = query.Trim();
        string cacheKey = query.ToUpper();

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
                "https://api.twelvedata.com/symbol_search?symbol={0}&outputsize=30&apikey={1}",
                Uri.EscapeDataString(query), apiKey);

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

    public bool IsReusable
    {
        get { return false; }
    }
}

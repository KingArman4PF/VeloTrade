<%@ WebHandler Language="C#" Class="TradeMarkers" %>

using System;
using System.Web;
using System.Data;
using System.Text;
using Npgsql;
using WebApplication1;

// Returns the logged trades for a given symbol as JSON markers
// ready to hand to Lightweight Charts' series.setMarkers().
public class TradeMarkers : IHttpHandler
{
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "application/json";
        string symbol = context.Request.QueryString["symbol"];

        if (string.IsNullOrWhiteSpace(symbol))
        {
            context.Response.Write("[]");
            return;
        }

        symbol = symbol.Trim().ToUpper();

        try
        {
            string query = "SELECT trade_type, entry_date, exit_date, result " +
                            "FROM trades WHERE UPPER(symbol) = @symbol ORDER BY entry_date";
            NpgsqlParameter[] parameters = new NpgsqlParameter[] { new NpgsqlParameter("@symbol", symbol) };
            DataTable dt = DatabaseHelper.ExecuteQuery(query, parameters);

            StringBuilder sb = new StringBuilder();
            sb.Append("[");
            bool first = true;

            foreach (DataRow row in dt.Rows)
            {
                string tradeType = row["trade_type"].ToString();
                DateTime entryDate = Convert.ToDateTime(row["entry_date"]);
                long entryTime = ToUnixTime(entryDate);
                bool isLong = tradeType == "LONG";

                if (!first) sb.Append(",");
                first = false;
                sb.Append("{")
                  .Append("\"time\":").Append(entryTime).Append(",")
                  .Append("\"position\":\"").Append(isLong ? "belowBar" : "aboveBar").Append("\",")
                  .Append("\"color\":\"").Append(isLong ? "#34D399" : "#F87171").Append("\",")
                  .Append("\"shape\":\"").Append(isLong ? "arrowUp" : "arrowDown").Append("\",")
                  .Append("\"text\":\"").Append(tradeType).Append(" ENTRY\"")
                  .Append("}");

                if (row["exit_date"] != DBNull.Value)
                {
                    string result = row["result"].ToString();
                    DateTime exitDate = Convert.ToDateTime(row["exit_date"]);
                    long exitTime = ToUnixTime(exitDate);
                    string exitColor = result == "WIN" ? "#34D399" : result == "LOSS" ? "#F87171" : "#E8B354";

                    sb.Append(",{")
                      .Append("\"time\":").Append(exitTime).Append(",")
                      .Append("\"position\":\"").Append(isLong ? "aboveBar" : "belowBar").Append("\",")
                      .Append("\"color\":\"").Append(exitColor).Append("\",")
                      .Append("\"shape\":\"circle\",")
                      .Append("\"text\":\"").Append(result).Append("\"")
                      .Append("}");
                }
            }

            sb.Append("]");
            context.Response.Write(sb.ToString());
        }
        catch (Exception ex)
        {
            context.Response.StatusCode = 500;
            context.Response.Write("{\"error\":\"" + ex.Message.Replace("\"", "'") + "\"}");
        }
    }

    private static long ToUnixTime(DateTime dt)
    {
        DateTime utc = DateTime.SpecifyKind(dt, DateTimeKind.Utc);
        return ((DateTimeOffset)utc).ToUnixTimeSeconds();
    }

    public bool IsReusable
    {
        get { return false; }
    }
}

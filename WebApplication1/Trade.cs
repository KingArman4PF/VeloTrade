using System;

namespace WebApplication1
{
    public class Trade
    {
        public int TradeId { get; set; }
        public string Symbol { get; set; }
        public decimal EntryPrice { get; set; }
        public decimal? ExitPrice { get; set; }
        public int Quantity { get; set; }
        public string TradeType { get; set; }
        public DateTime EntryDate { get; set; }
        public DateTime? ExitDate { get; set; }
        public string Result { get; set; }
        public decimal? ProfitLoss { get; set; }
        public string Reasoning { get; set; }
        public string Notes { get; set; }

        public decimal CalculateProfitLoss()
        {
            if (!ExitPrice.HasValue) return 0;

            if (TradeType == "LONG")
            {
                return (ExitPrice.Value - EntryPrice) * Quantity;
            }
            else
            {
                return (EntryPrice - ExitPrice.Value) * Quantity;
            }
        }

        public string DetermineResult()
        {
            decimal pl = CalculateProfitLoss();
            if (pl > 0) return "WIN";
            if (pl < 0) return "LOSS";
            return "BREAK_EVEN";
        }
    }
}
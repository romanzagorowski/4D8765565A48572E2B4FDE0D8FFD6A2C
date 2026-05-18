//+------------------------------------------------------------------+
//|                                                         SELL.mq4 |
//|                                     roman.zagorowski@hotmail.com |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "roman.zagorowski@hotmail.com"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include <stdlib.mqh>

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
{
    if(0 != OrdersTotal())
        return;
    
    const string symbol = "EURUSD.";
    const double pip = Point * 10;
    const double size = 1;
    const double price = Bid;
    const int slippage = 0;
    const double stoploss   = NormalizeDouble(Ask + pip * 10, Digits);
    const double takeprofit = NormalizeDouble(Ask - pip * 10, Digits);
    
    
    int orderTicket = OrderSend(symbol, OP_SELL, size, price, slippage, stoploss, takeprofit);
    
    if(-1 == orderTicket)
    {
        const int lastError = GetLastError();
        const string errorDescription = ErrorDescription(lastError);
        
        Print("ERROR: Failed to send SELL order. (error=", lastError, ", description='", errorDescription, "')");
    }
    else
    {
        Print("INFO: Order sent!");
    }
}
//+------------------------------------------------------------------+

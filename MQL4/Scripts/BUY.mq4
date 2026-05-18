//+------------------------------------------------------------------+
//|                                                          BUY.mq4 |
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
    const double price = Ask;
    const int slippage = 0;
    const double stoploss = NormalizeDouble(Bid - pip * 10, Digits);
    const double takeprofit = NormalizeDouble(Bid + pip * 10, Digits);
    
    
    int orderTicket = OrderSend(symbol, OP_BUY, size, price, slippage, stoploss, takeprofit);
    
    if(-1 == orderTicket)
    {
        const int lastError = GetLastError();
        const string errorDescription = ErrorDescription(lastError);
        
        Print("ERROR: Failed to send BUY order. (error=", lastError, ", description='", errorDescription, "')");
    }
    else
    {
        Print("INFO: Order sent!");
    }
}
//+------------------------------------------------------------------+

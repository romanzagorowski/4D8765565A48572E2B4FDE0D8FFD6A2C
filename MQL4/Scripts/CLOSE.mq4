//+------------------------------------------------------------------+
//|                                                        CLOSE.mq4 |
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
    while(0 != OrdersTotal())
    {
        const int orderIndex = 0;
        
        bool selected = OrderSelect(orderIndex, SELECT_BY_POS, MODE_TRADES);
        
        if(!selected)
        {
            const int lastError = GetLastError();
            const string errorDescription = ErrorDescription(lastError);
            
            Print("ERROR: Failed to select order by index. (index=", orderIndex, ", error=", lastError, ", description='", errorDescription, "')");
            
            return;
        }
        
        const int orderTicket = OrderTicket();
        const double orderSize = OrderLots();
        const int orderType = OrderType();
        const double closePrice = orderType == OP_BUY ? Bid : Ask;
        const int slippage = 0;
        
        bool closed = OrderClose(orderTicket, orderSize, closePrice, slippage);
        
        if(!closed)
        {
            const int lastError = GetLastError();
            const string errorDescription = ErrorDescription(lastError);
            
            Print("ERROR: Failed to close order. (error=", lastError, ", description='", errorDescription, "')");
            
            return;
        }
        else
        {
            Print("INFO: Order closed!");
        }
    }
}
//+------------------------------------------------------------------+

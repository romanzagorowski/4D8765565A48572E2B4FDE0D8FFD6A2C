//+------------------------------------------------------------------+
//|                                             _rz_system_ema25.mq4 |
//|                                     roman.zagorowski@hotmail.com |
//|                                                                  |
//+------------------------------------------------------------------+
#property strict
//--- includes
#include "IsNewBar.mqh"
#include "WithCheck.mqh"
#include <stdlib.mqh>
//--- constants
const int ___magicNumber = 20230618;
//--- input parameters
input int      EMAPeriod=25;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
    IsNewBar(); // to initialize internal static variable
    
    return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
//---

}
//+------------------------------------------------------------------+
bool SelectOrderByMagicAndType(const int orderMagicNumber, const int orderType)
{
    for(int i = 0; i < OrdersTotal(); ++i)
    {
        if(OrderSelect(i, SELECT_BY_POS))
        {
            if(OrderMagicNumber() == orderMagicNumber && OrderType() == orderType)
            {
                return true;
            }
        }
    }

    return false;
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
int DeleteOrdersByMagicAndType(const int magicNumber, const int orderType)
{
    int deletedOrdersCount = 0;
    
    while(SelectOrderByMagicAndType(magicNumber, orderType))
    {
        if(OrderDeleteWC(OrderTicket()))
        {
            ++deletedOrdersCount;
        }
    }
    
    return deletedOrdersCount;
}

void OnTick()
{
//---
    if(IsNewBar())
    {
        const string symbol = Symbol();
        const double spread = MarketInfo(symbol, MODE_SPREAD) * _Point;
        const double stop_level = MarketInfo(symbol, MODE_STOPLEVEL) * _Point;
        
        // TODO: if there is an open long position and an active sell stop order then cancel the sell stop order.
        // We have no orders that if executed cancels another order.
        // So when we detect that there is a long position and sell stop order we need to cancel the sell stop order.
        if(SelectOrderByMagicAndType(___magicNumber, OP_BUY))
        {
            Print("INFO: A long position found: ticket=", OrderTicket(), ". Deleting any SELLSTOP order...");
            
            const int deletedOrdersCount = DeleteOrdersByMagicAndType(___magicNumber, OP_SELLSTOP);
            
            Print("INFO: ", deletedOrdersCount, " SELLSTOP order(s) has been deleted.");
        }
        else
        {
            Print("INFO: No long positions found.");
        }
        
        //  TODO: if there is an open short position and an active buy stop order then cancel the buy stop order.
        if(SelectOrderByMagicAndType(___magicNumber, OP_SELL))
        {
            Print("INFO: A short position found: ticket=", OrderTicket(), ". Deleting any BUYSTOP order...");
            
            const int deletedOrdersCount = DeleteOrdersByMagicAndType(___magicNumber, OP_BUYSTOP);
            
            Print("INFO: ", deletedOrdersCount, " BUYSTOP order(s) has been deleted.");
        }
        else
        {
            Print("INFO: No short positions found.");
        }
        
        double ema1 = iMA(NULL, 0, EMAPeriod, 0, MODE_EMA, PRICE_CLOSE, 1);
        double ema2 = iMA(NULL, 0, EMAPeriod, 0, MODE_EMA, PRICE_CLOSE, 2);
        
        if(Close[2] < ema2 && Close[1] > ema1)
        {
            Print("INFO: A long setup detected. Close[2] < ema2 && Close[1] > ema1 (", Close[2], " < ", ema2, " && ", Close[1], " > ", ema1, ").");
            
            // long setup
            
            // close short position if any

            if(SelectOrderByMagicAndType(___magicNumber, OP_SELL))
            {
                const int orderTicket = OrderTicket();
                const double orderSize = OrderLots();
                const double price = Ask;
                const int slippage = 0;
                
                OrderCloseWC(orderTicket, orderSize, price, slippage);
                
                Print("INFO: A short position closed (ticket=", orderTicket, ", size=", orderSize, ", price=", price, ", slippage=", slippage, ").");
            }
            else
            {
                Print("INFO: No short position to close found. Continuing...");
            }
            
            // create buy stop order
            // create buy stop order at the high of the previous bar
            // I'm buying using an ask (sell) price
            // I'm using higher of two prices:
            // Close[1] + spread + min distance from market price (stop level)
            // High[1] + spread
            // ... + spread turns a bid price into an ask price
            
            const int cmd = OP_BUYSTOP;
            const double volume = 0.01;

            const double high_1 = High[1];
            const double high_1_ask = high_1 + spread;

            // I use current open[0] that may be different than close[1] (gap)
            const double open_0_bid = Open[0];
            const double open_0_ask = open_0_bid + spread;
            const double open_0_ask_sl = open_0_ask + stop_level;
            
            const double price_x = high_1_ask;
            const double price_y = open_0_ask_sl;
            const double price = MathMax(price_x, price_y);

            const int slippage = 0;
            const double stoploss = 0.0;
            const double takeprofit = 0.0;
            const string comment = "";
            const int magic = ___magicNumber;
            
            const int ticket = OrderSendWC(symbol, cmd, volume, price, slippage, stoploss, takeprofit, comment, magic);
            
            if(-1 == ticket)
            {
                Print("Error: Failed to create a BUYSTOP order...");
            }
            else
            {
                Print("INFO: Succeeded to create a BUYSTOP order (ticket=", ticket, ")!");
            }
        }
        else
        
        if(Close[2] > ema2 && Close[1] < ema1)
        {
            // short setup
            Print("INFO: A short setup detected. Close[2] > ema2 && Close[1] < ema1 (", Close[2], " > ", ema2, " && ", Close[1], " < ", ema1, ").");
            
            // close long position if any

            if(SelectOrderByMagicAndType(___magicNumber, OP_BUY))
            {
                const int orderTicket = OrderTicket();
                const double orderSize = OrderLots();
                const double price = Bid;
                const int slippage = 0;
                
                OrderCloseWC(orderTicket, orderSize, price, slippage);
                
                Print("INFO: A long position closed (ticket=", orderTicket, ", size=", orderSize, ", price=", price, ", slippage=", slippage, ").");
            }
            else
            {
                Print("INFO: No long position to close found. Continuing...");
            }
            
            // create sell stop order
            // create sell stop order at the low of the previous bar
            // I'm selling using a bid (buy) price
            // I'm using lower of two prices:
            // Close[1] + min distance from market price
            // Low[1]
            
            const int cmd = OP_SELLSTOP;
            const double volume = 0.01;

            const double low_1_bid = Low[1];
            
            const double open_0_bid = Open[0];
            const double open_0_bid_sl = open_0_bid + stop_level;
            
            const double price_x = low_1_bid;
            const double price_y = open_0_bid_sl;
            
            const double price = MathMin(price_x, price_y);
            
            const int slippage = 0;
            const double stoploss = 0.0;
            const double takeprofit = 0.0;
            const string comment = "";
            const int magic = ___magicNumber;
            
            const int ticket = OrderSendWC(symbol, cmd, volume, price, slippage, stoploss, takeprofit, comment, magic);
            
            if(-1 == ticket)
            {
                Print("Error: Failed to create a SELLSTOP order...");
            }
            else
            {
                Print("INFO: Succeeded to create a SELLSTOP order (ticket=", ticket, ")!");
            }
        }
        
        else 
        {
            Print("INFO: Neither short nor long setup detected...");
        }
    }
}
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                         _rz_symbolinfostring.mq4 |
//|                                     roman.zagorowski@hotmail.com |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "roman.zagorowski@hotmail.com"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
{
//---
   string currency_base   = SymbolInfoString(NULL, SYMBOL_CURRENCY_BASE  );
   string currency_profit = SymbolInfoString(NULL, SYMBOL_CURRENCY_PROFIT);
   string currency_margin = SymbolInfoString(NULL, SYMBOL_CURRENCY_MARGIN);
   
    Alert("SYMBOL_CURRENCY_BASE  : ", currency_base  );
    Alert("SYMBOL_CURRENCY_PROFIT: ", currency_profit);
    Alert("SYMBOL_CURRENCY_MARGIN: ", currency_margin);
    
    Alert("AccountCurrency: ", AccountCurrency());
}
//+------------------------------------------------------------------+

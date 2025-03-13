//+------------------------------------------------------------------+
//|                                             _rz_account_info.mq4 |
//|                                     roman.zagorowski@hotmail.com |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "roman.zagorowski@hotmail.com"
#property link      ""
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
{
    //Alert("Account #", AccountNumber(), " leverage is ", AccountLeverage());
    Alert("ACCOUNT_NAME: ", AccountInfoString(ACCOUNT_NAME));
    Alert("ACCOUNT_SERVER: ", AccountInfoString(ACCOUNT_SERVER));
    Alert("ACCOUNT_CURRENCY: ", AccountInfoString(ACCOUNT_CURRENCY));
    Alert("ACCOUNT_COMPANY: ", AccountInfoString(ACCOUNT_COMPANY));
    
    Alert("ACCOUNT_LOGIN: ", AccountInfoInteger(ACCOUNT_LOGIN));
    Alert("ACCOUNT_TRADE_MODE: ", EnumToString((ENUM_ACCOUNT_TRADE_MODE)AccountInfoInteger(ACCOUNT_TRADE_MODE)));
    Alert("ACCOUNT_LEVERAGE: ", AccountInfoInteger(ACCOUNT_LEVERAGE));
    Alert("ACCOUNT_LIMIT_ORDERS: ", AccountInfoInteger(ACCOUNT_LIMIT_ORDERS));
    Alert("ACCOUNT_MARGIN_SO_MODE: ", AccountInfoInteger(ACCOUNT_MARGIN_SO_MODE));
    Alert("ACCOUNT_TRADE_ALLOWED: ", AccountInfoInteger(ACCOUNT_TRADE_ALLOWED));
    Alert("ACCOUNT_TRADE_EXPERT: ", AccountInfoInteger(ACCOUNT_TRADE_EXPERT));


    Alert("ACCOUNT_BALANCE: ", AccountInfoDouble(ACCOUNT_BALANCE));
    Alert("ACCOUNT_CREDIT: ", AccountInfoDouble(ACCOUNT_CREDIT));
    Alert("ACCOUNT_PROFIT: ", AccountInfoDouble(ACCOUNT_PROFIT));
    Alert("ACCOUNT_EQUITY: ", AccountInfoDouble(ACCOUNT_EQUITY));
    Alert("ACCOUNT_MARGIN: ", AccountInfoDouble(ACCOUNT_MARGIN));
    Alert("ACCOUNT_MARGIN_FREE: ", AccountInfoDouble(ACCOUNT_MARGIN_FREE));
    Alert("ACCOUNT_MARGIN_LEVEL: ", AccountInfoDouble(ACCOUNT_MARGIN_LEVEL));
    Alert("ACCOUNT_MARGIN_SO_CALL: ", AccountInfoDouble(ACCOUNT_MARGIN_SO_CALL));
    Alert("ACCOUNT_MARGIN_SO_SO: ", AccountInfoDouble(ACCOUNT_MARGIN_SO_SO));
    Alert("ACCOUNT_MARGIN_INITIAL: ", AccountInfoDouble(ACCOUNT_MARGIN_INITIAL));
    Alert("ACCOUNT_MARGIN_MAINTENANCE: ", AccountInfoDouble(ACCOUNT_MARGIN_MAINTENANCE));
    Alert("ACCOUNT_ASSETS: ", AccountInfoDouble(ACCOUNT_ASSETS));
    Alert("ACCOUNT_LIABILITIES: ", AccountInfoDouble(ACCOUNT_LIABILITIES));
    Alert("ACCOUNT_COMMISSION_BLOCKED: ", AccountInfoDouble(ACCOUNT_COMMISSION_BLOCKED));

/*
    Alert("ACCOUNT_LOGIN: ", AccountInfoInteger(ACCOUNT_LOGIN));
    Alert("ACCOUNT_LOGIN: ", AccountInfoInteger(ACCOUNT_LOGIN));
    Alert("ACCOUNT_LOGIN: ", AccountInfoInteger(ACCOUNT_LOGIN));
    Alert("ACCOUNT_LOGIN: ", AccountInfoInteger(ACCOUNT_LOGIN));
*/
}
//+------------------------------------------------------------------+

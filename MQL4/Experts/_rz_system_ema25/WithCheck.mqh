//+------------------------------------------------------------------+
//|                                                    WithCheck.mqh |
//|                                     roman.zagorowski@hotmail.com |
//+------------------------------------------------------------------+
#property copyright "roman.zagorowski@hotmail.com"
#property strict
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2010
//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);
// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import
//+------------------------------------------------------------------+
//| EX5 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex5"
//   string ErrorDescription(int error_code);
// #import
//+------------------------------------------------------------------+
#import "WithCheck.ex4"

bool ObjectSetDoubleWC(long chartId, string objectName, ENUM_OBJECT_PROPERTY_DOUBLE propId, int propModifier, double propValue);
bool ObjectSetIntegerWC(long chartId, string objectName, ENUM_OBJECT_PROPERTY_INTEGER propId, long propValue);
bool ObjectSetIntegerWC(long chartId, string objectName, ENUM_OBJECT_PROPERTY_INTEGER propId, int propModifier, long propValue);
bool ObjectSetStringWC(long chartId, string objectName, ENUM_OBJECT_PROPERTY_STRING propId, const string propValue);
bool ObjectDeleteWC(string objectName);
int ObjectTypeWC(string objectName);
int ObjectsTotalWC();
string ObjectNameWC(int index);
bool ObjectCreateWC(string objectName, ENUM_OBJECT objectType, int subWindow, datetime time1, double price1, datetime time2, double price2);
bool OrderDeleteWC(int ticket, color arrow_color=clrNONE);
bool OrderSelectWC(int index, int select, int pool=MODE_TRADES);
bool OrderCloseWC(int ticket, double lots, double price, int slippage);
bool OrderSendWC(string symbol, int cmd, double volume, double price, int slippage, double stoploss, double takeprofit, string comment = NULL, int magic = 0);

#import

//+------------------------------------------------------------------+
//|                                                      _rz_hst.mqh |
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
#import "_rz_hst.ex4"

int WriteHstHeader(int fd, string symbol, int period, int digits, string copyright = "");
int ReadHstHeader(int fd, int & version, string & symbol, int & period, int & digits, string & copyright);

#import

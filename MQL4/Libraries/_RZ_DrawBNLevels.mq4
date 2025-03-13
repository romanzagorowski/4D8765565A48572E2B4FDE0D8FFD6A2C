//+------------------------------------------------------------------+
//|                                           _RZ_DrawBNLevels.mq4 |
//|                                     roman.zagorowski@hotmail.com |
//+------------------------------------------------------------------+
#property library
#property copyright "roman.zagorowski@hotmail.com"
#property version   "1.00"
#property strict

#include <_rz_withcheck.mqh>

//+------------------------------------------------------------------+
double GetChartHighestHigh()
{
    return High[iHighest(NULL, 0, MODE_HIGH)];
}
//+------------------------------------------------------------------+
double GetChartLowestLow()
{
    return Low[iLowest(NULL, 0, MODE_LOW)];
}
//+------------------------------------------------------------------+
void DeleteObjectsByPrefix(string prefix)
{
    for(int i = ObjectsTotalWithCheck() - 1; i >= 0; --i)
    {
        const string objectName = ObjectNameWithCheck(i);
        if(prefix == StringSubstr(objectName, 0, StringLen(prefix)))
        {
            ObjectDeleteWithCheck(objectName);
        }
    }
}
//+------------------------------------------------------------------+
void _RZ_DrawBNLevels(
    const int thePoints
,   const color theColor
,   const ENUM_LINE_STYLE theStyle
,   const int theWidth
,   const double theTopValue
,   const double theBottomValue
)
export
{
//---
    const string objectPrefix = "_RZ_DrawBNLevels_";
    Print("objectPrefix='", objectPrefix, "'");
    DeleteObjectsByPrefix(objectPrefix);
//---
    // if thePoints value is 0 we only delete existing levels...
    if(0 == thePoints)
        return;
//---
    const double chartHH = GetChartHighestHigh();
    const double chartLL = GetChartLowestLow();
    
    const double pointValue = SymbolInfoDouble(NULL, SYMBOL_TRADE_TICK_SIZE);
    
    const double chartHHPoints =  chartHH / pointValue;
    const int chartHHPointsInt = (int)MathRound(chartHHPoints);
    
    const double chartLLPoints = chartLL / pointValue;
    const int chartLLPointsInt = (int)MathRound(chartLLPoints);
    
    const int  startValuePoints = ((chartHHPointsInt / thePoints) + 1) * thePoints;
    const int finishValuePoints = ((chartLLPointsInt / thePoints) - 1) * thePoints;
   
    Print("chartHH=", DoubleToString(chartHH, Digits));
    Print("chartLL=", DoubleToString(chartLL, Digits));
    Print("pointValue=", DoubleToString(pointValue, Digits));
    Print("chartHHPoints=", DoubleToString(chartHHPoints));
    Print("chartHHPointsInt=", chartHHPointsInt);
    Print("chartLLPoints=", DoubleToString(chartLLPoints));
    Print("chartLLPointsInt=", chartLLPointsInt);
    Print("startValuePoints=", startValuePoints);
    Print("finishValuePoints=", finishValuePoints);
  
    for(int i = startValuePoints; i >= finishValuePoints; i -= thePoints)
    {
        const string objectName = objectPrefix + IntegerToString(i);
        const double price1 = NormalizeDouble(i * pointValue, Digits);
        bool created = ObjectCreateWithCheck(
            objectName,
            OBJ_HLINE,
            0,
            0, price1,
            0, 0
        );
        if(created)
        {
            ObjectSetIntegerWithCheck(0, objectName, OBJPROP_COLOR, theColor);
            ObjectSetIntegerWithCheck(0, objectName, OBJPROP_STYLE, theStyle);
            ObjectSetIntegerWithCheck(0, objectName, OBJPROP_WIDTH, theWidth);
            ObjectSetIntegerWithCheck(0, objectName, OBJPROP_SELECTABLE, false);
            ObjectSetIntegerWithCheck(0, objectName, OBJPROP_BACK, true);
        }
    }
}
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                           _RZ_DrawBNLevels.mq4 |
//|                                     roman.zagorowski@hotmail.com |
//+------------------------------------------------------------------+
#property library
#property copyright "roman.zagorowski@hotmail.com"
#property version   "1.00"
#property strict

/*
    2025-11-18
    If the price param is 0 the script removes ALL big number lines and returns.
    If a line already exists on a chart, its it removed and recreated with new parameters.
*/

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
    for(int i = ObjectsTotalWC() - 1; i >= 0; --i)
    {
        const string objectName = ObjectNameWC(i);
        if(prefix == StringSubstr(objectName, 0, StringLen(prefix)))
        {
            ObjectDeleteWC(objectName);
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
    const string objectPrefix = "_RZ_DrawBNLevels_";

    if(0 == thePoints)
    {
        Print("objectPrefix='", objectPrefix, "'");
        DeleteObjectsByPrefix(objectPrefix);
        return;
    }

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
/*   
    Print("chartHH=", DoubleToString(chartHH, Digits));
    Print("chartLL=", DoubleToString(chartLL, Digits));
    Print("pointValue=", DoubleToString(pointValue, Digits));
    Print("chartHHPoints=", DoubleToString(chartHHPoints));
    Print("chartHHPointsInt=", chartHHPointsInt);
    Print("chartLLPoints=", DoubleToString(chartLLPoints));
    Print("chartLLPointsInt=", chartLLPointsInt);
    Print("startValuePoints=", startValuePoints);
    Print("finishValuePoints=", finishValuePoints);
*/  
    for(int i = startValuePoints; i >= finishValuePoints; i -= thePoints)
    {
        const string objectName = objectPrefix + IntegerToString(i);
        
        if(ObjectFind(objectName) > -1)
        {
            ObjectDeleteWC(objectName);
        }
        
        const double price1 = NormalizeDouble(i * pointValue, Digits);
        bool created = ObjectCreateWC(
            objectName,
            OBJ_HLINE,
            0,
            0, price1,
            0, 0
        );
        if(created)
        {
            ObjectSetIntegerWC(0, objectName, OBJPROP_COLOR, theColor);
            ObjectSetIntegerWC(0, objectName, OBJPROP_STYLE, theStyle);
            ObjectSetIntegerWC(0, objectName, OBJPROP_WIDTH, theWidth);
            ObjectSetIntegerWC(0, objectName, OBJPROP_SELECTABLE, false);
            ObjectSetIntegerWC(0, objectName, OBJPROP_BACK, true);
            
            const string objectDescription = DoubleToStr(price1, Digits);
            ObjectSetStringWC(0, objectName, OBJPROP_TEXT, objectDescription);
        }
    }
}
//+------------------------------------------------------------------+

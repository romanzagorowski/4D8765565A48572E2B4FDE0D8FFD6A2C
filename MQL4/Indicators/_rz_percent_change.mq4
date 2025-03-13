//+------------------------------------------------------------------+
//|                                           _rz_percent_change.mq4 |
//|                                     roman.zagorowski@hotmail.com |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

// 2023-11-13   Shows a percent change between two bars of distance N.
//              I wanted to know what has changed more EURUSD or GBPUSD.

#property copyright "roman.zagorowski@hotmail.com"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_separate_window
#property indicator_buffers 1
#property indicator_plots   1
//--- plot PersentChange
#property indicator_label1  "Change %"
#property indicator_type1   DRAW_HISTOGRAM
#property indicator_color1  clrDarkGray
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1
//--- input parameters
input int      NBars=1;
//--- indicator buffers
double         PercentChangeBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,PercentChangeBuffer);
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{
//---
    for(int i = 0; i < rates_total - NBars; ++i)
    {
        PercentChangeBuffer[i] = MathAbs((close[i] - close[i + 1]) / close[i + 1] * 100);
    }
//--- return value of prev_calculated for next call
   return(rates_total);
}
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                       _rz_draw_bn_levels_500.mq4 |
//|                                     roman.zagorowski@hotmail.com |
//+------------------------------------------------------------------+
#property copyright "roman.zagorowski@hotmail.com"
#property version   "1.00"
#property strict
#property script_show_inputs
//--- input parameters
input int      thePoints=500;
input color    theColor=clrLightGray;
input ENUM_LINE_STYLE theStyle=STYLE_DOT;
input int      theWidth=1;
input double   theTopValue=0.0;
input double   theBottomValue=0.0;

#include <_RZ_DrawBNLevels.mqh>

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
{
    _RZ_DrawBNLevels(
        thePoints
    ,   theColor
    ,   theStyle
    ,   theWidth
    ,   theTopValue
    ,   theBottomValue
    );
}
//+------------------------------------------------------------------+

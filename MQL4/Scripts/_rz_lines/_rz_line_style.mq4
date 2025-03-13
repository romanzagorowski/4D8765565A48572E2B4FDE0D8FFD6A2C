//+------------------------------------------------------------------+
//|                                               _rz_line_style.mq4 |
//|                                     roman.zagorowski@hotmail.com |
//+------------------------------------------------------------------+

// 2023-11-15   Applies a color to all selected horizontal and trend lines.

#property copyright "roman.zagorowski@hotmail.com"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property script_show_inputs
//--- input parameters
input ENUM_LINE_STYLE   theStyle=STYLE_SOLID;
input int               theWidth=2;
input color             theColor=clrSilver;

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
{
    for(int objectIndex = 0; objectIndex < ObjectsTotal(); ++objectIndex)
    {
        string objectName = ObjectName(objectIndex);
        bool isSelected = ObjectGetInteger(0, objectName, OBJPROP_SELECTED);
        if(isSelected)
        {
            long objectType = ObjectGetInteger(0, objectName, OBJPROP_TYPE);
            if(OBJ_TREND == objectType || OBJ_HLINE == objectType)
            {
                ObjectSetInteger(0, objectName, OBJPROP_STYLE, theStyle);
                ObjectSetInteger(0, objectName, OBJPROP_WIDTH, theWidth);
                ObjectSetInteger(0, objectName, OBJPROP_COLOR, theColor);
            }
        }
    }
}
//+------------------------------------------------------------------+

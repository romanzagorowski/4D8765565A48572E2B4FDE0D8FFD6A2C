//+------------------------------------------------------------------+
//|                                              _rz_line_object.mq4 |
//|                                     roman.zagorowski@hotmail.com |
//+------------------------------------------------------------------+

// 2023-11-22   Applies a color to all selected objects.

#property copyright "roman.zagorowski@hotmail.com"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property script_show_inputs
//--- input parameters
input color    theColor=clrSilver;
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
            ObjectSetInteger(0, objectName, OBJPROP_COLOR, theColor);
        }
    }
}
//+------------------------------------------------------------------+

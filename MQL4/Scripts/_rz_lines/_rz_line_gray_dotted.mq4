//+------------------------------------------------------------------+
//|                                         _rz_line_gray_dotted.mq4 |
//|                                     roman.zagorowski@hotmail.com |
//+------------------------------------------------------------------+

// 2023-11-06   Makes all selected trend and horizontal lines gray and dotted.
//              Makes a trend line straight horizontal one.

#property copyright "roman.zagorowski@hotmail.com"
#property version   "1.00"
#property strict
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
                ObjectSetInteger(0, objectName, OBJPROP_COLOR, clrGray);
                ObjectSetInteger(0, objectName, OBJPROP_WIDTH, 1);
                ObjectSetInteger(0, objectName, OBJPROP_STYLE, STYLE_DOT);
            }
            if(OBJ_TREND == objectType)
            {
                double price1 = ObjectGetDouble(0, objectName, OBJPROP_PRICE1);
                ObjectSetDouble(0, objectName, OBJPROP_PRICE2, price1);
            }
        }
    }
}
//+------------------------------------------------------------------+

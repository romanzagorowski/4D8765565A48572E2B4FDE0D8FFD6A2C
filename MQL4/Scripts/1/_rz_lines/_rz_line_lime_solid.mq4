//+------------------------------------------------------------------+
//|                                          _rz_line_lime_solid.mq4 |
//|                                     roman.zagorowski@hotmail.com |
//+------------------------------------------------------------------+

// 2023-11-06   Makes the first selected trend line lime and solid.
//              Makes the trend line straight horizontal one.

#property copyright "roman.zagorowski@hotmail.com"
#property version   "1.00"
#property strict

static const color theColor = clrLime;
static const int   theWidth = 2;
static const int   theStyle = STYLE_SOLID;

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
            if(OBJ_TREND == objectType)
            {
                ObjectSetInteger(0, objectName, OBJPROP_COLOR, theColor);
                ObjectSetInteger(0, objectName, OBJPROP_WIDTH, theWidth);
                ObjectSetInteger(0, objectName, OBJPROP_STYLE, theStyle);

                double price1 = ObjectGetDouble(0, objectName, OBJPROP_PRICE1);
                ObjectSetDouble(0, objectName, OBJPROP_PRICE2, price1);
                
                break;  // break the for loop
            }
        }
    }
}
//+------------------------------------------------------------------+

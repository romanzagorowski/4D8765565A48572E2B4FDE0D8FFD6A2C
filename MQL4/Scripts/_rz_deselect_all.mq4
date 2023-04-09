//+------------------------------------------------------------------+
//|                                             _rz_deselect_all.mq4 |
//|                                     roman.zagorowski@hotmail.com |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "roman.zagorowski@hotmail.com"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
{
    for(int i = 0; i < ObjectsTotal(); i++)
    {
        string objectName = ObjectName(i);
        ObjectSetInteger(0, objectName, OBJPROP_SELECTED, 0);
    }
}
//+------------------------------------------------------------------+

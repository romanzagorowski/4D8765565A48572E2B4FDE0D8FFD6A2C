//+------------------------------------------------------------------+
//|                                            _rz_create_button.mq4 |
//|                                     roman.zagorowski@hotmail.com |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "roman.zagorowski@hotmail.com"
#property link      ""
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
{
    const string objectName = "ScriptButton";

    ObjectDelete(0, objectName);

    //if(ObjectFind(0, objectName))
    //{
    //    ObjectDelete(0, objectName);
    //}
    
    //ObjectCreate(0, objectName, OBJ_BUTTON, 0, 0, 0);
    //ObjectSetInteger(0, objectName, OBJPROP_XDISTANCE, 10);
    //ObjectSetInteger(0, objectName, OBJPROP_YDISTANCE, 10);
    //ObjectSetInteger(0, objectName, OBJPROP_XSIZE, 100);
    //ObjectSetInteger(0, objectName, OBJPROP_YSIZE, 30);
    //ObjectSetString(0, objectName, OBJPROP_TEXT, "Run Script");
}
//+------------------------------------------------------------------+

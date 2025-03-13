//+------------------------------------------------------------------+
//|                                          _rz_draw_lines_0050.mq4 |
//|                                     roman.zagorowski@hotmail.com |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "roman.zagorowski@hotmail.com"
#property link      ""
#property version   "1.00"
#property strict
#property script_show_inputs
//--- input parameters
input ENUM_LINE_STYLE      LineStyle = STYLE_DOT;
input int LineWidth = 1;
input color LineColor = clrSilver;
input bool Selectable = true;
//+------------------------------------------------------------------+
const string ___createObjectNamePrefix = "_rz_draw_lines_0050_";
const string ___deleteObjectNamePrefix = "_rz_draw_lines_";
//+------------------------------------------------------------------+
void DeleteExistingLines(string objectNamePrefix)
{
    for(int i = ObjectsTotal(); i >= 0; --i)
    {
        const string objectName = ObjectName(i);
        
        if(StringSubstr(objectName, 0, StringLen(objectNamePrefix)) == objectNamePrefix)
        {
            bool deleted = ObjectDelete(objectName);
            
            if(!deleted)
            {
                Print("ERROR: ObjectDelete() failed (Error: ", GetLastError(), ")");
                continue;
            }
        }
    }
}
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
{
    DeleteExistingLines(___deleteObjectNamePrefix);
    
    const double ll = Low[iLowest(NULL, 0, MODE_LOW)];
    const double hh = High[iHighest(NULL, 0, MODE_HIGH)];

    const double startValue = MathFloor(ll * 100) / 100;
    const double delta = 0.0050;
    const double endValue = hh;
    
    double lineValue = startValue;
    
    Print("INFO: ll=", DoubleToString(ll, Digits), ", hh=", DoubleToString(hh, Digits));
    
    for(int i = 0; i < 1000; ++i)
    {
        string objectName = ___createObjectNamePrefix + IntegerToString(i + 1, 4, '0');

        bool created = ObjectCreate(objectName, OBJ_HLINE, 0, 0, lineValue, 0, lineValue);
        
        if(!created)
        {
            Print("ERROR: ObjectCreate() failed (Error: ", GetLastError(), ")");
            continue;
        }
        
        ObjectSetInteger(0, objectName, OBJPROP_WIDTH, 0, LineWidth);
        ObjectSetInteger(0, objectName, OBJPROP_STYLE, 0, LineStyle);
        ObjectSetInteger(0, objectName, OBJPROP_COLOR, 0, LineColor);
        ObjectSetInteger(0, objectName, OBJPROP_SELECTABLE, 0, Selectable ? 1 : 0);
        
        lineValue += delta;
        
        if(lineValue > endValue)
        {
            break;
        }
    }
}
//+------------------------------------------------------------------+

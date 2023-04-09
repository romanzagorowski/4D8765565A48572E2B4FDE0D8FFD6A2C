//+------------------------------------------------------------------+
//|                                            _rz_draw_r_levels.mq4 |
//|                                     roman.zagorowski@hotmail.com |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "roman.zagorowski@hotmail.com"
#property link      ""
#property version   "1.00"
#property strict
#property script_show_inputs
//--- input parameters
input double   OpenPrice=0.88246;
input double   SLPrice=0.88525;
input int      Levels=5;
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
{
//---
    double risk = OpenPrice - SLPrice;
    
    for(int i = -1; i <= Levels; i++)
    {
        string objectName = "RLevel" + IntegerToString(i);

//-----------------------------------------------------------------------------
        
        if(0 == ObjectFind(ChartID(), objectName))
        {
            Print(
                "The object '" + objectName + "' already exists." +
                " GLE: #" + IntegerToString(GetLastError())
            );
            break;
        }
        
//-----------------------------------------------------------------------------
        
        double levelPrice = OpenPrice + i * risk;
        
        bool created = ObjectCreate(
            ChartID(),
            objectName,
            OBJ_HLINE,
            0,
            0,
            levelPrice
        );
        
        if(!created)
        {
            Print("Failed to create a horizontal line '" + objectName + "' at level " + DoubleToStr(levelPrice, Digits) + "." + 
                " GLE: #" + IntegerToString(GetLastError())
            );
            break;
        }

//-----------------------------------------------------------------------------
        
        bool set = ObjectSet(objectName, OBJPROP_COLOR, clrDimGray);
            
        if(!set)
        {
            Print("Failed to set color for the horizontal line '" + objectName + "'." +
                " GLE: #" + IntegerToString(GetLastError())
            );
            break;
        }
        
//-----------------------------------------------------------------------------
        
        set = ObjectSet(objectName, OBJPROP_STYLE, STYLE_DOT);
                
        if(!set)
        {
            Print("Failed to set style for the horizontal line '" + objectName + "'." +
                " GLE: #" + IntegerToString(GetLastError())
            );
            break;
        }
        
//-----------------------------------------------------------------------------

        string objectText = IntegerToString(i) + "R";

        set = ObjectSetString(ChartID(), objectName, OBJPROP_TEXT, objectText);
                
        if(!set)
        {
            Print("Failed to set text for the horizontal line '" + objectName + "'." +
                " GLE: #" + IntegerToString(GetLastError())
            );
            break;
        }
    }
}
//+------------------------------------------------------------------+

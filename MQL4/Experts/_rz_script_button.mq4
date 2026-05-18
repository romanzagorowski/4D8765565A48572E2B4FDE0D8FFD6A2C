//+------------------------------------------------------------------+
//|                                            _rz_script_button.mq4 |
//|                                     roman.zagorowski@hotmail.com |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "roman.zagorowski@hotmail.com"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

string objectNameSellButton = "SellButton";
string objectNameCloseButton = "CloseButton";
string objectNameBuyButton = "BuyButton";

void CreateButton(string objectName, int xDistance, int yDistance, int xSize, int ySize, string text, color bgColor, color fgColor)
{
    ObjectCreate(0, objectName, OBJ_BUTTON, 0, 0, 0);
    ObjectSetInteger(0, objectName, OBJPROP_CORNER, CORNER_RIGHT_UPPER);
    ObjectSetInteger(0, objectName, OBJPROP_XDISTANCE, xDistance);
    ObjectSetInteger(0, objectName, OBJPROP_YDISTANCE, yDistance);
    ObjectSetInteger(0, objectName, OBJPROP_XSIZE, xSize);
    ObjectSetInteger(0, objectName, OBJPROP_YSIZE, ySize);
    ObjectSetString(0, objectName, OBJPROP_TEXT, text);
    ObjectSetInteger(0, objectName, OBJPROP_BGCOLOR, bgColor);
    ObjectSetInteger(0, objectName, OBJPROP_COLOR, fgColor);
}

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
    const int xOffset = 300;
    
    CreateButton(objectNameSellButton , xOffset +  10, 10, 100, 50, "SELL", clrRed, clrWhite);
    CreateButton(objectNameCloseButton, xOffset + 110, 10, 100, 50, "CLOSE", clrWhite, clrGray);
    CreateButton(objectNameBuyButton  , xOffset + 210, 10, 100, 50, "BUY", clrGreen, clrWhite);
    
    return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
    ObjectDelete(0, objectNameBuyButton);
    ObjectDelete(0, objectNameCloseButton);
    ObjectDelete(0, objectNameSellButton);
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
}

void PressBuyButton()
{
    ObjectSetString(0, objectNameBuyButton, OBJPROP_FONT, "Arial Bold");
    ObjectSetInteger(0, objectNameBuyButton, OBJPROP_FONTSIZE, 20);
    ObjectSetInteger(0, objectNameBuyButton, OBJPROP_COLOR, clrYellow);
    
    
}

//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
{
    if(id == CHARTEVENT_OBJECT_CLICK)
    {
        if(sparam == objectNameBuyButton)
        {
            //ObjectSetInteger(0, sparam, OBJPROP_STATE, false);
            //ChartRedraw(0);
            
            PressBuyButton();
            
            ObjectSetInteger(0, objectNameSellButton, OBJPROP_STATE, false);
            ObjectSetInteger(0, objectNameCloseButton, OBJPROP_STATE, false);

            ChartRedraw(0);

            Print("The button ", sparam, " clicked");
        }
        else if(sparam == objectNameCloseButton)
        {
            //ObjectSetInteger(0, sparam, OBJPROP_STATE, false);
            //ChartRedraw(0);

            ObjectSetInteger(0, objectNameSellButton, OBJPROP_STATE, false);
            ObjectSetInteger(0, objectNameBuyButton, OBJPROP_STATE, false);

            ChartRedraw(0);

            Print("The button ", sparam, " clicked");
        }
        else if(sparam == objectNameSellButton)
        {
            //ObjectSetInteger(0, sparam, OBJPROP_STATE, false);
            //ChartRedraw(0);

            ObjectSetInteger(0, objectNameBuyButton, OBJPROP_STATE, false);
            ObjectSetInteger(0, objectNameCloseButton, OBJPROP_STATE, false);

            ChartRedraw(0);

            Print("The button ", sparam, " clicked");
        }
    }
}
//+------------------------------------------------------------------+

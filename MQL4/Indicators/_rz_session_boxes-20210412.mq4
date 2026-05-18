//+------------------------------------------------------------------+
//|                                            _rz_session_boxes.mq4 |
//|                                     roman.zagorowski@hotmail.com |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "roman.zagorowski@hotmail.com"
#property link      ""
#property version   "1.00"
#property strict
#property indicator_chart_window

//--- input parameters
input int      SessionStartHour = 22;
input int      SessionEndHour   = 9;
input color    SessionBoxColor  = clrBisque;

//--- global variables
string ___objectNamePrefix = NULL;
int    ___rectCount        = 0;
string ___rectObjectName   = NULL;    // It is the active session box object name...

#include <stdlib.mqh>
#include <_rz_withcheck.mqh>

//+------------------------------------------------------------------+
void CreateOldSessionBoxes2(int startHour, int endHour)
{
    enum SEARCH_PHASE { LOOK_FOR_START_HOUR, LOOK_FOR_END_HOUR, FOUND_THEM_BOTH } searchPhase = LOOK_FOR_START_HOUR;

    int startHourBarIndex = -1;
    int   endHourBarIndex = -1;

    int barIndex = ArraySize(Time) - 1;

    while(barIndex >= 0)
    {
        datetime dateTime = Time[barIndex];
        
        MqlDateTime s;
        TimeToStruct(dateTime, s);

        if(searchPhase == LOOK_FOR_START_HOUR)
        {
            if(s.hour == startHour)
            {
                // The first bar we found is the one we looked for.
                // Remeber its index and look for the end hour.
                
                startHourBarIndex = barIndex;
                
                // No need to remember the previous bar index.
                // It always be barIndex + 1!
                
                searchPhase = LOOK_FOR_END_HOUR;
            }
            
            // Anyway, we found the start bar or not - move the the next bar...
                
            // Move to the next bar (we moving from the end so decrease index)
            barIndex--;
        }
        else if(searchPhase == LOOK_FOR_END_HOUR)
        {
            // OK.
            // We can have 2 options here
            // *   we are in range <22, 24)
            // *   we are in range <0, 6> - yes, including 6, we want rects to touch each others
            
            if(s.hour == endHour)
            {
                endHourBarIndex = barIndex + 1;     // We want the rects to touch each other... NO, WE DON'T!!!
                
                searchPhase = FOUND_THEM_BOTH;
                
                // Move to the next bar (we moving from the end so decrease index)
                barIndex--;
            }
            else if(s.hour >= startHour && s.hour < 24)
            {
                // We are still in the first day.
                // We continue to the next bar...
                barIndex--;
            }
            else if(s.hour >= 0 && s.hour < endHour)
            {
                // We are in the second day, but not reached the end hour yet.
                // We continue to the next bar...
                barIndex--;
            }
            else if(s.hour > endHour && s.hour < startHour)
            {
                // We went pass endHour but we before the next start one...
                // There is no end hour in the time series at all? Can be...
                
                // So we close the rect now...
                endHourBarIndex = barIndex + 1;
                
                searchPhase = FOUND_THEM_BOTH;
                
                // We have not reached the next start hour so we can move to the next bar...
                barIndex--;
            }
            else if(s.hour > endHour && s.hour <= startHour)
            {
                // We went pass the end hour and reached the next start hour.
                // It can be a case when start hour is 7 and the end hour is 6 on the H1 chart...
                // Or there is no end hour in the time series...
                // We close the rect here...
                endHourBarIndex = barIndex + 1;
                
                searchPhase = FOUND_THEM_BOTH;
                
                // Wa are at the next start hour here so there is no need to move to the next bar...
                //barIndex--;
            }
            else
            {
                // Wha shall not get here...
                Print("CRITICAL: CreateRect2() We shall not get here...");
            }
        }
        
        if(searchPhase == FOUND_THEM_BOTH)
        {
            // Designate the lowest low and the highest high of the ranve <startHourBarIndex, endHourBarIndex>

            const int count = startHourBarIndex - endHourBarIndex + 1;
            
            double lowestLow   = Low [iLowest (NULL, 0, MODE_LOW , count, endHourBarIndex)];
            double highestHigh = High[iHighest(NULL, 0, MODE_HIGH, count, endHourBarIndex)];
            
            //int pipDigits = Digits % 2 == 0 ? Digits : Digits - 1;
            int pipDigits = Digits;
            
            double rectWidth = highestHigh - lowestLow;
            double rectWidthPips = rectWidth / MathPow(10.0, -pipDigits);
            
            string rectDescription = DoubleToString(rectWidthPips, 0);
            
            string objectName = ___objectNamePrefix + "_" + IntegerToString(___rectCount++);
            
            CreateRect(objectName, Time[startHourBarIndex], highestHigh, Time[endHourBarIndex], lowestLow, rectDescription);

            searchPhase = LOOK_FOR_START_HOUR;
        }
    }
}
//+------------------------------------------------------------------+
void CreateOldSessionBoxes(int startHour, int endHour)
{
    SEARCH_PHASE searchPhase = LOOK_FOR_START_HOUR;

    int startHourBarIndex = -1;
    int   endHourBarIndex = -1;

    for(int barIndex = ArraySize(Time) - 1; barIndex >= 0; barIndex--)
    {
        datetime dateTime = Time[barIndex];
        
        MqlDateTime s;
        TimeToStruct(dateTime, s);

        if(searchPhase == LOOK_FOR_START_HOUR)
        {
            if(s.hour == startHour)
            {
                // The first bar we found is the one we looked for.
                // Remeber its index and search for the end hour.
                
                startHourBarIndex = barIndex;
                
                // No need to remember the previous bar index.
                // It always be barIndex + 1!
                
                searchPhase = LOOK_FOR_END_HOUR;
            }
        }
        else if(searchPhase == LOOK_FOR_END_HOUR)
        {
            if(s.hour == endHour)
            {
                endHourBarIndex = barIndex + 1; // Is it always the previous bar...?
                
                searchPhase = FOUND_THEM_BOTH;
            }
            else if(s.hour < endHour)
            {
                // We continue to the next bar...
            }
            else if(s.hour > endHour)
            {
                // Hmmm... Now what?
                
                // We found no bar with hour = endHour...
                // It's ok.
                // So the previous bar (barIndex + 1) shall have an hour less than endHour!
                endHourBarIndex = barIndex + 1;
                
                searchPhase = FOUND_THEM_BOTH;
            }
            else
            {
                Print("CRITICAL: CreateRect() We shall not get here...");
            }
        }
        
        if(searchPhase == FOUND_THEM_BOTH)
        {
            // Designate the lowest low and the highest high of the ranve <startHourBarIndex, endHourBarIndex>

            const int count = startHourBarIndex - endHourBarIndex + 1;
            
            double lowestLow   = Low [iLowest (NULL, 0, MODE_LOW , count, endHourBarIndex)];
            double highestHigh = High[iHighest(NULL, 0, MODE_HIGH, count, endHourBarIndex)];
            
            //int pipDigits = Digits % 2 == 0 ? Digits : Digits - 1;
            int pipDigits = Digits;
            
            double rectWidth = highestHigh - lowestLow;
            double rectWidthPips = rectWidth / MathPow(10.0, -pipDigits);
            
            string rectDescription = DoubleToString(rectWidthPips, 0);
            
            string objectName = ___objectNamePrefix + "_" + IntegerToString(___rectCount++);
            
            CreateRect(objectName, Time[startHourBarIndex], highestHigh, Time[endHourBarIndex], lowestLow, rectDescription);

            searchPhase = LOOK_FOR_START_HOUR;
        }
    }
}
//+------------------------------------------------------------------+
void DeleteAllSessionBoxes()
{
    const int objectsTotal = ObjectsTotalWC();
    
    Print("DEBUG: DeleteAllSessionBoxes() ___objectNamePrefix='", ___objectNamePrefix, "', objectsTotal=", objectsTotal);

    int deletedObjectsCount = 0;
    
    for(int i = objectsTotal - 1; i >= 0; i--)
    {
        const string objectName = ObjectNameWC(i);

        const int objectType = ObjectTypeWC(objectName);
        
        if(OBJ_RECTANGLE == objectType && StringSubstr(objectName, 0, StringLen(___objectNamePrefix)) == ___objectNamePrefix)
        {
            bool deleted = ObjectDeleteWC(objectName);
            
            if(deleted)
            {
                deletedObjectsCount++;
            }
        }
    }
    
    Print("DEBUG: DeleteAllSessionBoxes() ___objectNamePrefix='", ___objectNamePrefix, "', deletedObjectsCount=", deletedObjectsCount);
}
//+------------------------------------------------------------------+
void CreateRect(string objectName, datetime time1, double price1, datetime time2, double price2, string objectDescription)
{
    bool created = ObjectCreateWC(objectName, OBJ_RECTANGLE, 0, time1, price1, time2, price2);
    
    if(created)
    {
        ObjectSetIntegerWC(0, objectName, OBJPROP_COLOR     , SessionBoxColor);
        ObjectSetIntegerWC(0, objectName, OBJPROP_SELECTABLE, 0);
        ObjectSetIntegerWC(0, objectName, OBJPROP_HIDDEN    , 1);
        ObjectSetStringWC (0, objectName, OBJPROP_TEXT      , objectDescription);
    }
}
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
{
    Print("DEBUG: OnInit() SessionStartHour=", SessionStartHour, ", SessionEndHour=", SessionEndHour, ", SessionBoxColor=", SessionBoxColor);
    
    //-------------------------------------------------------------------------
    
    if(!(SessionStartHour >= 0 && SessionStartHour < 24))
    {
        Print("ERROR: The SessionStartHour parameter must be an integer value between 0 and 23.");
    
        return INIT_PARAMETERS_INCORRECT;
    }
    
    if(!(SessionEndHour >= 0 && SessionEndHour < 24))
    {
        Print("ERROR: The SessionEndHour parameter must be an integer value between 0 and 23.");
    
        return INIT_PARAMETERS_INCORRECT;
    }
    
    if(SessionStartHour == SessionEndHour)
    {
        Print("ERROR: The SessionStartHour and SessionEndHour parameters must have different values.");
    
        return INIT_PARAMETERS_INCORRECT;
    }
    
    //-------------------------------------------------------------------------
    
    ___rectCount = 0;
    ___objectNamePrefix = "_rz_session_boxes_" + IntegerToString(SessionStartHour, 2, '0') + "_" + IntegerToString(SessionEndHour, 2, '0');
    
    //-------------------------------------------------------------------------
    
    // Applying a template with this indicator doesn't call Deinit() function that calls DeleteAllSessionBoxes().
    // So we need to do it right here. But no worries. Most of the time it will delete nothing
    // because all rects will be already deleted in Deinit() function (except for template application).
    DeleteAllSessionBoxes();
    
    //-------------------------------------------------------------------------
    
    // We draw rects only for 1 hour timeframe or shorter...
    if(Period() < PERIOD_H1)
    {
        if(SessionStartHour < SessionEndHour)
        {
            CreateOldSessionBoxes(SessionStartHour, SessionEndHour);
        }
        else
        {
            CreateOldSessionBoxes2(SessionStartHour, SessionEndHour);
        }
    }
    
    return INIT_SUCCEEDED;
}
//+------------------------------------------------------------------+
string DeinitReasonToString(int reason)
{
    switch(reason)
    {
        case REASON_PROGRAM:     return "REASON_PROGRAM";
        case REASON_REMOVE:      return "REASON_REMOVE";
        case REASON_RECOMPILE:   return "REASON_RECOMPILE";
        case REASON_CHARTCHANGE: return "REASON_CHARTCHANGE";
        case REASON_CHARTCLOSE:  return "REASON_CHARTCLOSE";
        case REASON_PARAMETERS:  return "REASON_PARAMETERS";
        case REASON_ACCOUNT:     return "REASON_ACCOUNT";
        case REASON_TEMPLATE:    return "REASON_TEMPLATE";
        case REASON_INITFAILED:  return "REASON_INITFAILED";
        case REASON_CLOSE:       return "REASON_CLOSE";
    }
    
    return IntegerToString(reason);
}

//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
    Print("DEBUG: OnDeinit(), reason=", DeinitReasonToString(reason));
    
    DeleteAllSessionBoxes();
}
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{
    if(SessionStartHour < SessionEndHour)
    {
        MqlDateTime s;
        TimeToStruct(time[0], s);
        
        // Is current bar inside <SessionStartHour, SessionEndHour) range?
        if(s.hour >= SessionStartHour && s.hour < SessionEndHour && Period() < PERIOD_H1)
        {
            if(NULL == ___rectObjectName)
            {
                // Ok. We have just entered a new session.
                // Let's generate a unique name for its rect.
                
                ___rectObjectName = ___objectNamePrefix + "_" + IntegerToString(___rectCount++);
            }
       
            // Yes, it is.

            s.hour = SessionStartHour;
            s.min  = 0;
            s.sec  = 0;
            
            datetime startBarDateTime = StructToTime(s);

            s.hour = SessionEndHour - 1;
            s.min  = 60 - Period();
            s.sec  = 0;
            
            datetime endBarDateTime = StructToTime(s);
            
            int startBarIndex = iBarShift(NULL, 0, startBarDateTime);
            int count = startBarIndex + 1;
            
            double lowestLow   = Low [iLowest (NULL, 0, MODE_LOW , count)];
            double highestHigh = High[iHighest(NULL, 0, MODE_HIGH, count)];

            //int pipDigits = Digits % 2 == 0 ? Digits : Digits - 1;
            int pipDigits = Digits;

            double rectWidthPips = (highestHigh - lowestLow) / MathPow(10, -pipDigits);
            string rectDescription = DoubleToString(rectWidthPips, 0);

            // Is the session box already created?
            bool isRectCreated = (ObjectFind(___rectObjectName) >= 0);
            
            if(isRectCreated)
            {
                // Yes, it is.

                ObjectSetIntegerWC(0, ___rectObjectName, OBJPROP_TIME , 0, startBarDateTime);
                ObjectSetDoubleWC (0, ___rectObjectName, OBJPROP_PRICE, 0, highestHigh);
                ObjectSetIntegerWC(0, ___rectObjectName, OBJPROP_TIME , 1, endBarDateTime);
                ObjectSetDoubleWC (0, ___rectObjectName, OBJPROP_PRICE, 1, lowestLow);

                ObjectSetStringWC(0, ___rectObjectName, OBJPROP_TEXT, rectDescription);
            }
            else
            {
                // No, it is not.
                
                bool created = ObjectCreateWC(___rectObjectName, OBJ_RECTANGLE, 0, startBarDateTime, highestHigh, endBarDateTime, lowestLow);
                
                if(created)
                {
                    ObjectSetIntegerWC(0, ___rectObjectName, OBJPROP_COLOR     , SessionBoxColor);
                    ObjectSetIntegerWC(0, ___rectObjectName, OBJPROP_SELECTED  , 0);
                    ObjectSetIntegerWC(0, ___rectObjectName, OBJPROP_SELECTABLE, 0);
                    ObjectSetIntegerWC(0, ___rectObjectName, OBJPROP_HIDDEN    , 1);
                    ObjectSetStringWC (0, ___rectObjectName, OBJPROP_TEXT      , rectDescription);
                }
            }
        }
        else
        {
            // Ok. We are outside the session hours.
            // Lets clear the ___rectObjectName variable to indicate that.
            
            if(NULL != ___rectObjectName)
            {
                // Ok. We are at the first tick after an active session.
                // Lets forget about the session's box...
                
                ___rectObjectName = NULL;
                
                // The rect stays on the chart but it is not longer updated...
            }
        }
    }
    else if(SessionStartHour > SessionEndHour)
    {
        datetime startBarDateTime = 0;
        datetime endBarDateTime   = 0;
        
        MqlDateTime s;
        TimeToStruct(Time[0], s);
        
        // We are in the first day...        
        if(s.hour >= SessionStartHour && s.hour < 24)
        {
            s.hour = SessionStartHour;
            s.min  = 0;
            s.sec  = 0;
            
            startBarDateTime = StructToTime(s);
            
            s.hour = SessionEndHour - 1;
            s.min  = 60 - Period();
            s.sec  = 0;
            
            endBarDateTime = StructToTime(s);
            endBarDateTime += 86400;   // Move it to the next day...
        }

        // We are in the second day...
        if(s.hour >= 0 && s.hour < SessionEndHour)
        {
            s.hour = SessionEndHour - 1;    // 7
            s.min  = 60 - Period();
            s.sec  = 0;
            
            endBarDateTime = StructToTime(s);

            s.hour = SessionStartHour;  // 22
            s.min  = 0;
            s.sec  = 0;
            
            startBarDateTime = StructToTime(s);
            startBarDateTime -= 86400;   // Move it to the previous day...
        }
        
        if(Time[0] >= startBarDateTime && Time[0] < endBarDateTime && Period() < PERIOD_H1)
        {
            if(NULL == ___rectObjectName)
            {
                // Ok. We have just entered a new session.
                // Let's generate a unique name for its rect.
                
                ___rectObjectName = ___objectNamePrefix + "_" + IntegerToString(___rectCount++);
            }
       
            int startBarIndex = iBarShift(NULL, 0, startBarDateTime);
            int count = startBarIndex + 1;
            
            double lowestLow   = Low [iLowest (NULL, 0, MODE_LOW , count)];
            double highestHigh = High[iHighest(NULL, 0, MODE_HIGH, count)];

            //int pipDigits = Digits % 2 == 0 ? Digits : Digits - 1;
            int pipDigits = Digits;

            double rectWidthPips = (highestHigh - lowestLow) / MathPow(10, -pipDigits);
            string rectDescription = DoubleToString(rectWidthPips, 0);

            // Is the session box already created?
            bool isRectCreated = (ObjectFind(___rectObjectName) >= 0);
            
            if(isRectCreated)
            {
                // Yes, it is.

                ObjectSetIntegerWC(0, ___rectObjectName, OBJPROP_TIME , 0, startBarDateTime);
                ObjectSetDoubleWC (0, ___rectObjectName, OBJPROP_PRICE, 0, highestHigh);
                ObjectSetIntegerWC(0, ___rectObjectName, OBJPROP_TIME , 1, endBarDateTime);
                ObjectSetDoubleWC (0, ___rectObjectName, OBJPROP_PRICE, 1, lowestLow);
                
                ObjectSetStringWC (0, ___rectObjectName, OBJPROP_TEXT, rectDescription);
            }
            else
            {
                // No, it is not.
                
                bool created = ObjectCreateWC(___rectObjectName, OBJ_RECTANGLE, 0, startBarDateTime, highestHigh, endBarDateTime, lowestLow);
                
                if(created)
                {
                    ObjectSetIntegerWC(0, ___rectObjectName, OBJPROP_COLOR     , SessionBoxColor);
                    ObjectSetIntegerWC(0, ___rectObjectName, OBJPROP_SELECTED  , 0);
                    ObjectSetIntegerWC(0, ___rectObjectName, OBJPROP_SELECTABLE, 0);
                    ObjectSetIntegerWC(0, ___rectObjectName, OBJPROP_HIDDEN    , 1);
                    
                    ObjectSetStringWC(0, ___rectObjectName, OBJPROP_TEXT, rectDescription);
                }
            }
        }
        else
        {
            // Ok. We are outside the session hours.
            // Lets clear the ___rectObjectName variable to indicate that.
            
            if(NULL != ___rectObjectName)
            {
                // Ok. We are at the first tick after an active session.
                // Lets forget about the session's box...
                
                ___rectObjectName = NULL;
                
                // The rect stays on the chart but it is not longer updated...
            }
        }
    }
    else
    {
        // We shall never be here...
        Print("CRITICAL: OnCalculate() We shall never get here...");
    }

    return rates_total;
}
//+------------------------------------------------------------------+

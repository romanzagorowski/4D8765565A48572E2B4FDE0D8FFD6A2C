//+------------------------------------------------------------------+
//|                                                 _rz_isnewbar.mq4 |
//|                                     roman.zagorowski@hotmail.com |
//|                                                                  |
//+------------------------------------------------------------------+
#property library
#property copyright "roman.zagorowski@hotmail.com"
#property link      ""
#property version   "1.00"
#property strict

// The first call always returns true.
bool IsNewBar() export
{
    static datetime prevOne = 0;
    
    if(Time[0] != prevOne)
    {
        prevOne = Time[0];

        return true;
    }
    
    return false;
}

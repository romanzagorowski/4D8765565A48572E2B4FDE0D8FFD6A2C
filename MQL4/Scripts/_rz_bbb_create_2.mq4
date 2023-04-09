//+------------------------------------------------------------------+
//|                                             _rz_bbb_create_2.mq4 |
//|                                     roman.zagorowski@hotmail.com |
//+------------------------------------------------------------------+
#property copyright "roman.zagorowski@hotmail.com"
#property link      ""
#property version   "1.00"
#property strict
#property script_show_inputs

#include <stdlib.mqh>   // for ErrorDescription()
#include <_rz_hst.mqh>

//--- input parameters
input string SymbolSufix = "_BBB";
  // it will be added to the end of the newly created symbol

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
{
    //const string dst_symbol = Symbol() + "_BBB";
    const string bbbSymbol = Symbol() + (SymbolSufix == "" ? "_BBB" : SymbolSufix);
    
    //const string dst_hst_file_name = dst_symbol + IntegerToString(Period()) + ".hst";

    // A name of the to be created hst file with BBB chart
    const string bbbFileName = bbbSymbol + IntegerToString(Period()) + ".hst";

    // A handle to the history file of new BBB chart
    int bbbFile = FileOpenHistory(
        bbbFileName
    //,   FILE_BIN|FILE_WRITE|FILE_SHARE_WRITE|FILE_SHARE_READ|FILE_ANSI
    ,   FILE_BIN|FILE_WRITE
    );
    
    if(bbbFile == -1) 
    {
        int error = GetLastError();

        Print("ERROR: Failed to open a hst file for new BBB chart. File name: '", bbbFileName, "', Error: ", error, ", Desctiption: '", ErrorDescription(error), "'");

        return;
    }
    
    // I put the base chart symbol into the copyright header file with some prefix
    const string copyleft = "BBB_" + Symbol();

    WriteHstHeader(bbbFile, bbbSymbol, Period(), Digits(), copyleft);
    
    MqlRates rate;
    
    for(int i = Bars - 1; i >= 0; i--)
    {
        rate.time  = Time[i];
        rate.open  = Open[i];
        rate.high  = High[i];
        rate.low   = Low[i];
        rate.close = Close[i];
        rate.tick_volume = Volume[i];
        rate.spread = 0;
        rate.real_volume = 0;
        
        uint bytesWriten = FileWriteStruct(bbbFile, rate);
        
        if(0 == bytesWriten)
        {
            int error = GetLastError();

            Print("ERROR: Failed to write to the file. File name: '", bbbFileName, "', Error: ", error, ", Description: ", ErrorDescription(error));

            FileClose(bbbFile);

            return;
        }
    }
    
    FileClose(bbbFile);
}
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                          _rz_bbb_goto_date_2.mq4 |
//|                                     roman.zagorowski@hotmail.com |
//+------------------------------------------------------------------+
#property copyright "roman.zagorowski@hotmail.com"
#property link      ""
#property version   "1.00"
#property strict
#property script_show_inputs

#include <_rz_hst.mqh>
#include <stdlib.mqh>

//--- input parameters
//input datetime GotoDate;
input datetime GotoDate = D'2020-08-27 00:00';

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
{
    //-------------------------------------------------------------------------

    // First we need to check if the chart the sctipt was attached to is realy BBB chart.

    string bbbFileName = Symbol() + IntegerToString(Period()) + ".hst";
    
    int bbbFile = FileOpenHistory(bbbFileName, FILE_BIN|FILE_READ|FILE_SHARE_READ);
    
    if(-1 == bbbFile)
    {
        int error = GetLastError();
        
        Print("ERROR: Failed to open a history file for reading (is BBB check). File name: '", bbbFileName, "', Error: ", error, ", Description: '", ErrorDescription(error), "'");
        
        return;
    }

    // The original chart symbol is stored in the BBB chart's header field "copyright" prefixed with "BBB_".
    // So we need to read "copyright" field and check it starts with "BBB_" prefix.
    // If so the rest of the copyright string is the original symbol.
    
    int version;
    string symbol;
    int period;
    int digits;
    string copyleft;
    
    ReadHstHeader(bbbFile, version, symbol, period, digits, copyleft);
    
    FileClose(bbbFile);
    
    if(0 != StringCompare("BBB_", StringSubstr(copyleft, 0, 4)))
    {
        Print("ERROR: The copyright field does not start with 'BBB_', so this is not BBB chart. Aborting...");
        
        return;
    }
    
    // Ok. It is BBB chart and the base symbol is...
    string baseSymbol = StringSubstr(copyleft, 4);
    
    Print("INFO: It is a BBB chart. The base symbol is '", baseSymbol, "'");
    
    //-------------------------------------------------------------------------

    bbbFile = FileOpenHistory(bbbFileName, FILE_BIN|FILE_WRITE|FILE_SHARE_WRITE|FILE_SHARE_READ|FILE_ANSI);
    
    if(-1 == bbbFile)
    {
        int error = GetLastError();

        Print("ERROR: Failed to open the history file for writing. File name: '", bbbFileName, "', Error: ", error, ", Description: '", ErrorDescription(error), "'");

        return;
    }
    else
    {
        Print("INFO: Succeeded to open the history file for writing. File name: '", bbbFileName, "'");
    }
    
    WriteHstHeader(bbbFile, Symbol(), Period(), Digits, copyleft);  // copyleft remains the same so we reuse existing variable!

    //-------------------------------------------------------------------------

    string baseFileName = baseSymbol + IntegerToString(Period()) + ".hst";
    
    int baseFile = FileOpenHistory(baseFileName, FILE_BIN|FILE_READ|FILE_SHARE_WRITE|FILE_SHARE_READ|FILE_ANSI);
    
    if(baseFile == -1)
    {
        int error = GetLastError();

        Print("ERORR: Failed to open the base history file for reading. File name: '", baseFileName, "', Error: ", error, ", Description: '", ErrorDescription(error), "'");

        return;
    }
    else
    {
        Print("INFO: Succeeded to open the base history file for reading. File name: '", baseFileName, "'");
    }
    
    //-------------------------------------------------------------------------

    // Seek the base File just after a header...
    bool sought = FileSeek(baseFile, 148, SEEK_CUR);
    
    if(!sought)
    {
        int error = GetLastError();
        
        Print("ERROR: Failed to seek the base history file. File name: '", baseFileName, "', Error: ", error, ", Description: '", ErrorDescription(error), "'");
        
        return;
    }
    else
    {
        Print("INFO: Succeeded to seek the base history file. File name: '", baseFileName, "'");
    }
    
    //-------------------------------------------------------------------------

    MqlRates rates;
    
    while(true)
    {
        uint bytesRead = FileReadStruct(baseFile, rates);
    
        if(bytesRead != sizeof(rates))
        {
            int error = GetLastError();
            
            Print("ERROR: Failed to read rates from the base history file. Read ", bytesRead, "byte(s). File name: '", baseFileName, "', Error: ", error, ", Description: '", ErrorDescription(error), "'");
            
            return;
        }
        
        if(rates.time > GotoDate)
        {
            break;
        }
        
        uint bytesWritten = FileWriteStruct(bbbFile, rates);
        
        if(bytesWritten != sizeof(rates))
        {
            int error = GetLastError();
            
            Print("ERROR: Failed to write rates to the BBB file. File name:  '", bbbFileName, "', Error: ", error, ", Description: '", ErrorDescription(error), "'");
            
            return;
        }
    }

    FileClose(bbbFile);
    FileClose(baseFile);
    
    //WindowRedraw();
    //ChartRedraw();
    ChartSetSymbolPeriod(0, NULL, 0);
}
//+------------------------------------------------------------------+

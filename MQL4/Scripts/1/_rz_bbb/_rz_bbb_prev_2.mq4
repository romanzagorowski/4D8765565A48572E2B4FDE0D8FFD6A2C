//+------------------------------------------------------------------+
//|                                                 _rz_bbb_prev.mq4 |
//|                                     roman.zagorowski@hotmail.com |
//+------------------------------------------------------------------+
#property copyright "roman.zagorowski@hotmail.com"
#property link      ""
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+

#include <_rz_hst.mqh>
#include <stdlib.mqh>

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
    
    ulong baseFileSize    = FileSize(baseFile);
    ulong baseFileRecords = (baseFileSize - 148) / 60;
    
    //Print("INFO: Estimated number of records in the base history file '", baseFileName, "' is ", baseFileRecords);
    //Print("INFO: Actual number of bars in the '", baseSymbol, "' chart is ", Bars);

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

    uchar record[60];
    
    for(int i = 0; i < Bars - 1; i++)
    {
        uint bytesRead = FileReadArray(baseFile, record, 0, 60);
    
        if(bytesRead != 60)
        {
            int error = GetLastError();
            
            Print("ERROR: Failed to read a record from the base history file. File name: '", baseFileName, "'. Read ", bytesRead, " byte(s). Error: ", error, ", Description: '", ErrorDescription(error), "'");
            
            return;
        }
        
        uint bytesWritten = FileWriteArray(bbbFile, record, 0, 60);
        
        if(bytesWritten != 60)
        {
            int error = GetLastError();
            
            Print("ERROR: Failed to write to the BBB history file. File name: '", bbbFileName, "'. Bytes written: ", bytesWritten, " byte(s). Error: ", error, ", Desctiption: '", ErrorDescription(error), "'");
            
            return;
        }
    }

    FileClose(bbbFile);
    FileClose(baseFile);
    
    //-------------------------------------------------------------------------

    ChartSetSymbolPeriod(0, NULL, 0);
}
//+------------------------------------------------------------------+

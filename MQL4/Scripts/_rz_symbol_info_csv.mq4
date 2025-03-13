//+------------------------------------------------------------------+
//|                                          _rz_symbol_info_csv.mq4 |
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
//---
    string fileName = "_rz_symbol_info.csv";
    
    int fileHandle = FileOpen(fileName, FILE_WRITE|FILE_CSV);
    
    if(INVALID_HANDLE == fileHandle)
    {
        Print("ERROR: FileOpen() #LE: " + IntegerToString(GetLastError()));
        return;
    }
    
    uint bytesWritten = FileWrite(fileHandle
    ,   "Symbol"
    ,   "MinVolume"
    ,   "MaxVolume"
    //,   "BaseCurrency"
    //,   "ProfitCurrency"
    //,   "MarginCurrency"
    );
    
    if(0 == bytesWritten)
    {
        Print("ERROR: FileWrite() #LE: " + IntegerToString(GetLastError()));
        FileClose(fileHandle);
        return;
    }
    
    for(int i = 0; i < SymbolsTotal(false); i++)
    {
        string symbolName = SymbolName(i, false);
        double maxVolume = SymbolInfoDouble(symbolName, SYMBOL_VOLUME_MAX);
        double minVolume = SymbolInfoDouble(symbolName, SYMBOL_VOLUME_MIN);
        
        string baseCurrency = SymbolInfoString(symbolName, SYMBOL_CURRENCY_BASE);
        string profitCurrency = SymbolInfoString(symbolName, SYMBOL_CURRENCY_PROFIT);
        string marginCurrency = SymbolInfoString(symbolName, SYMBOL_CURRENCY_MARGIN);
        
        bytesWritten = FileWrite(fileHandle
        ,   symbolName
        ,   minVolume
        ,   maxVolume
        //,   baseCurrency
        //,   profitCurrency
        //,   marginCurrency
        );

        if(0 == bytesWritten)
        {
            Print("ERROR: FileWrite() #LE: " + IntegerToString(GetLastError()));
            FileClose(fileHandle);
            return;
        }
    }
    
    FileClose(fileHandle);
}
//+------------------------------------------------------------------+

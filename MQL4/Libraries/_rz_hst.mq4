//+------------------------------------------------------------------+
//|                                                      _rz_hst.mq4 |
//|                                     roman.zagorowski@hotmail.com |
//|                                                                  |
//+------------------------------------------------------------------+
#property library
#property copyright "roman.zagorowski@hotmail.com"
#property link      ""
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| My function                                                      |
//+------------------------------------------------------------------+
// int MyCalculator(int value,int value2) export
//   {
//    return(value+value2);
//   }
//+------------------------------------------------------------------+

int WriteHstHeader(int fd, string symbol, int period, int digits, string copyright = "") export
{
    int unused[13] = {};
    ArrayInitialize(unused, 0);
    
    FileWriteInteger(fd, 401);
    FileWriteString (fd, copyright , 64);
    FileWriteString (fd, symbol, 12);
    FileWriteInteger(fd, period);
    FileWriteInteger(fd, digits);
    FileWriteInteger(fd, 0);
    FileWriteInteger(fd, 0);
    FileWriteArray  (fd, unused, 0, 13);
    
    return 0;
}

int ReadHstHeader(int fd, int & version, string & symbol, int & period, int & digits, string & copyright) export
{
    version = FileReadInteger(fd);
    copyright = FileReadString(fd, 64);
    symbol = FileReadString(fd, 12);
    period = FileReadInteger(fd);
    digits = FileReadInteger(fd);
    
    datetime timesign = FileReadDatetime(fd);
    datetime lastsync = FileReadDatetime(fd);
    
    int unused[13];
    uint elementsRead = FileReadArray(fd, unused);
    
    return 0;
}

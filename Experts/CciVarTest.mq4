//+------------------------------------------------------------------+
//|                                                  CciVarTest.mq4 |
//|                                 Copyright 2018, MeSoHi Scripting |
//|                                           https://www.mesohi.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MeSoHi Scripting"
#property link      "https://www.mesohi.com"
#property version   "1.00"
#property strict

//This is to test the console and print CCi current bar values as the chart progresses.
//I will need to learn how to use the console to print messages for debugging.

//--- input parameters
 double Cci = iCCI(Symbol(),0,14,0,1);
 double CciCheck = Cci;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()  //No intialization Required.
  { 
   return(INIT_SUCCEEDED);
  }
  
  
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+


void OnDeinit(const int reason)
  {

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+

//There is no OnBarClose() function or anything similar in the API.  Will have to use logic
//to confirm the close of the bar.  This can be done with any data point that changes on bar
//close.  Example... CciCheck is used to retain the last bars Cci
//data and check it against the current bar Cci value in the stack. When a new bar 
//closes, the value for the last bar in the stack will change.
//The Flag will trigger the logic since the values no longer match.  Logical code is performed and
//CciCheck is set to the most recent Cci value.  This logic mimics OnBarClose().

void OnTick()
  {
   
   Cci = iCCI(Symbol(),0,14,0,1);

   
//This logic has been fixed.  This will print the time and CCi value for coresponding data bar. 
//There is no longer an offset for the CCi value.
         
      if(CciCheck != Cci)
         {
         Print((TimeCurrent() - (PERIOD_H1*60)) + " The current CCI Value = " + Cci);
         CciCheck = Cci;
         }
      

      

  }


//+------------------------------------------------------------------+
//|                                              GeneralTemplate.mq4 |
//|                                        MeSoHi Software Solutions |
//|                                           https://www.mesohi.com |
//+------------------------------------------------------------------+
#property copyright "MeSoHi Software Solutions"
#property link      "https://www.mesohi.com"
#property version   "0.01"
#property strict

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   
   double cciCurrent = iCCI(NULL,0,20,PRICE_CLOSE,0);
   double cciPrevious = iCCI(NULL,0,20,PRICE_CLOSE,1);
   double lastBarClose;
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   if(lastBarClose != 
  }
//+------------------------------------------------------------------+

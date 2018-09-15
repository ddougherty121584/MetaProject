//+------------------------------------------------------------------+
//|                                                 monManTester.mq4 |
//|                                        MeSoHi Software Solutions |
//|                                           https://www.mesohi.com |
//+------------------------------------------------------------------+
#property copyright "MeSoHi Software Solutions"
#property link      "https://www.mesohi.com"
#property version   "1.00"
#property strict

#include <monMan.mqh>

double freeMargin;
input int minHoldingValue = 50;

int OnInit()
  {return(INIT_SUCCEEDED);}

void OnDeinit(const int reason)
  {}

void OnTick()
  {  
   freeMargin = AccountFreeMargin();
   Print("Account free margin = ",AccountFreeMargin());
   Print("Lots to be leveraged = " ,lotCalc(freeMargin, minHoldingValue));
  }


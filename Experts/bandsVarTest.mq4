//+------------------------------------------------------------------+
//|                                                 bandsVarTest.mq4 |
//|                                        MeSoHi Software Solutions |
//|                                           https://www.mesohi.com |
//+------------------------------------------------------------------+
#property copyright "MeSoHi Software Solutions"
#property link      "https://www.mesohi.com"
#property version   "1.00"
#property strict

//Variable storing the BB Values
double bbLower = iBands(NULL,0,20,2,0,PRICE_LOW,MODE_LOWER,1);
double bbUpper = iBands(NULL,0,20,2,0,PRICE_LOW,MODE_UPPER,1);
double bbMain = iBands(NULL,0,20,2,0,PRICE_LOW,MODE_MAIN,1);


//Variables used to mimick OnBarClose logic.   
double barClosePrice = iClose(Symbol(),Period(),1);
double priceCheck = barClosePrice;


int OnInit()
  {return(INIT_SUCCEEDED);}

void OnDeinit(const int reason)
  { }

void OnTick()
  {
//Update Last Bar Close Price
  barClosePrice = iClose(Symbol(),Period(),1);
  
//Update Bolinger Band Values
  bbLower = iBands(NULL,0,20,2,0,PRICE_LOW,MODE_LOWER,1);
  bbUpper = iBands(NULL,0,20,2,0,PRICE_LOW,MODE_UPPER,1);
  bbMain = iBands(NULL,0,20,2,0,PRICE_LOW,MODE_MAIN,1);

//On Bar Close logic
  if(barClosePrice != priceCheck) 
   {
   Print((TimeCurrent() - (PERIOD_H1*60)) +"Lower Bolinger Band Value = " + bbLower);
   Print((TimeCurrent() - (PERIOD_H1*60)) +"Main Bolinger Band Value = " + bbMain);
   Print((TimeCurrent() - (PERIOD_H1*60)) +"Upper Bolinger Band Value = " + bbUpper);
   Print("+---------------------------------------+");

//Update check value for onBarClose Logic. 
   priceCheck = barClosePrice;
   }
  
  
  }


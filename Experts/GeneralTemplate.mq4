//+------------------------------------------------------------------+
//|                                              GeneralTemplate.mq4 |
//|                                        MeSoHi Software Solutions |
//|                                           https://www.mesohi.com |
//+------------------------------------------------------------------+
#property copyright "MeSoHi Software Solutions"
#property link      "https://www.mesohi.com"
#property version   "1.0"
#property strict

//Input Pramaters for strategy in red below.  These parameters can be optimized.

//"EURUSD" Point() is delivered as 0.00001,  a pip is designated as 10 not 1
input int takeProfit = 1000;//100 pip take profit
input double stopLoss = 500;//50 pip stop loss
input double lots = 0.1;
input int cciRate = 20;
input double cciBuyValue = -100;
input double cciSellValue = 100;


//Variables for the CCI trade logic
double cciValue = iCCI(Symbol(),0,cciRate,0,1);
double cciLogicValue = iCCI(Symbol(),0,cciRate,0,2);

//Variables used to mimick OnBarClose logic.   
double barClosePrice = iClose(Symbol(),Period(),1);
double priceCheck = barClosePrice;

//Variable to hold order info
int ticket, cnt;

int OnInit()
  {return(INIT_SUCCEEDED);}

void OnDeinit(const int reason)
  {}

void OnTick()
  {
  
//Updating the CCI values for trade logic and comparison.
   cciValue = iCCI(Symbol(),0,cciRate,0,1);
   cciLogicValue = iCCI(Symbol(),0,cciRate,0,2);
  
//This logic causes the EA to break out of OnTick() runstep if there aren't
//enough bars to populate the CCI signal, or if the Take Profit is set to low.
//TakeProfit MINIMUM VALUE IS HARD CODED BELOW
   if(Bars<cciRate)
     {Print("To Few Bars to Trade.  Need " + cciRate + " Bars"); return;}
   if(takeProfit<10)//Set Minimum take profit here.
     {Print("TakeProfit less than 10"); return;}

//Check if there are orders open and if there is enough margin to trade.
   int total=OrdersTotal();
   if(total<1)
     {
     if(AccountFreeMargin()<(1000*lots))
         {Print("We have no money. Free Margin = ",AccountFreeMargin()); return;}
     }


//Start primary Logic


//BarClose logic allows trading once the new bar has closed.
//Trade logic should be nested inside.
   barClosePrice = iClose(Symbol(),Period(),1);

   if(barClosePrice != priceCheck) 
      {
      
         if(cciValue > cciBuyValue && cciLogicValue < cciBuyValue)
         {
         ticket=OrderSend(Symbol(),OP_BUY,lots,Ask,3,Ask-(stopLoss*Point()),Ask+takeProfit*Point,"CCI Long Entry",16384,0,Green);
         if(ticket>0)
            {
            if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES))
            Print("BUY order opened : ",OrderOpenPrice());
            }
         }
//Check for opened position and check if symbol matches poistion. For Close Logic.
         
         for(cnt=0;cnt<total;cnt++)
         {
         if(!OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES))
            {continue;}
            
            if(OrderType()<=OP_BUY && OrderSymbol()==Symbol())  
            {
               if(cciValue < cciSellValue && cciLogicValue > cciSellValue)
               {
               if(!OrderClose(OrderTicket(),OrderLots(),Bid,3,Violet))
                  {
                  Print("OrderClose error ",GetLastError());
                  return;
                  }
               }
            }

         }
      
      
      //Print("*-------------------------------*");
      //Print("CCI Old Value = " + cciLogicValue);
      //Print("CCI Current Value = " + cciValue);
      //Print((TimeCurrent() - (PERIOD_H1*60)) + " Bar Close Price = " + barClosePrice);
      
//Required update for the "onBarClose()" Logic.  This has not been implemented in class yet.
         priceCheck = barClosePrice;
      }
   
  }


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
input int slippage = 30;


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
   int orders=OrdersTotal();
   if(orders<1)
     {
     if(AccountFreeMargin()<(1000*lots))
         {Print("We have no money. Free Margin = ",AccountFreeMargin()); return;}
     }


//Start primary Logic


//BarClose logic allows trading once the new bar has closed.
//Trade logic should be nested inside.
   barClosePrice = iClose(Symbol(),Period(),1);//Update close price of last bar.

   if(barClosePrice != priceCheck) 
      {

//First Check if there are any open orders. This ensures only a single trade is entered at a time. 
//If FALSE, Run Entry Logic.
      if(orders < 1)
      {
         if(cciValue > cciBuyValue && cciLogicValue < cciBuyValue)//Long Entry Logic
         {
         ticket=OrderSend(Symbol(),OP_BUY,lots,Ask,slippage,Ask-(stopLoss*Point),Ask+(takeProfit*Point),"CCI Long Entry",16384,0,Green);
         if(ticket>0)
            {
            RefreshRates();
            if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES))
            Print("BUY order opened : ",OrderOpenPrice());
            }
         }
         
         
         if(cciValue < cciSellValue && cciLogicValue > cciSellValue)//Short Entry Logic
         {
         ticket=OrderSend(Symbol(),OP_SELL,lots,Bid,slippage,Bid+(stopLoss*Point),Bid-(takeProfit*Point),"CCI Short Entry",16384,0,Green);
         if(ticket>0)
            {
            RefreshRates();
            if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES))
            Print("SELL order opened : ",OrderOpenPrice());
            }
         }
       }

//First Check if an order is open.  This ensures only a single trade entered at a time.
//If TRUE, Run Exit Logic
//Check for opened position and check if symbol matches poistion. For Close Logic.
         
      if(orders >= 1)
      {   
         for(cnt=0;cnt<orders;cnt++)
         {
         if(!OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES))
            {continue;}
            
            if(OrderType()<=OP_BUY && OrderSymbol()==Symbol())//Long Exit Logic
            {
               if(cciValue < cciSellValue && cciLogicValue > cciSellValue)
               {
               RefreshRates();
               if(!OrderClose(OrderTicket(),OrderLots(),Bid,slippage,Violet))
                  {
                  Print("OrderClose error ",GetLastError());
                  return;
                  }
               }
            }
             
             if(OrderType()<=OP_SELL  && OrderSymbol() == Symbol())//Short Exit Logic
            {
               
               if(cciValue > cciBuyValue && cciLogicValue < cciBuyValue)
               {
               RefreshRates();
               if(!OrderClose(OrderTicket(),OrderLots(),Ask,slippage,Violet))
                  {
                  Print("OrdeClose error ", GetLastError());
                  return;
                  }
               }
            }
            

         } 
       }
      
//Test Values for printing.  Here for Debugging logic through terminal.
      //Print("*-------------------------------*");
      //Print("CCI Old Value = " + cciLogicValue);
      //Print("CCI Current Value = " + cciValue);
      //Print((TimeCurrent() - (PERIOD_H1*60)) + " Bar Close Price = " + barClosePrice);
      
//Required update for the "onBarClose()" Logic.  This has not been implemented in class yet.
         priceCheck = barClosePrice;
      }
   
  }


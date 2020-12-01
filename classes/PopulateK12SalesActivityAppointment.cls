// This class is to Auto Launch the list of Records Loaded in the Transition Launch Object
Global class PopulateK12SalesActivityAppointment implements database.Batchable<Sobject>,Database.Stateful,Schedulable
{
       global String strQuery; //this variable used to set query from test class or from shceduler if required
       public String DEFAULT_QUERY;

      
    /* Default Constructor*/
    global PopulateK12SalesActivityAppointment ( )
    {  
           DEFAULT_QUERY ='Select Id,Region__c,User__c,Termination_Date__c,Watson_Training_Date__c,Non_Watson_Training_Date__c'
                                   +' FROM Instructional_Lead_Consultant__c order by Region__C';
                                       
    
          
        this.strQuery = DEFAULT_QUERY;


    }
    /* This method prepares the scope of the batch program based on the query result */
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        system.debug('strQuery@@@'+strQuery);
        return Database.getQueryLocator(strQuery);
    }
     /* This method processes query result in batches */
    global void execute(Database.BatchableContext BC, SObject[] scope)
    {
        List<Instructional_Lead_Consultant__c> newLst  = scope;
        //String currentYear=String.valueof(System.Today().Year()); 
        //Integer currentMonth=(System.Today().Month()) ;   
        
   // FiscalYearSettings fiscalYear = [SELECT Id FROM FiscalYearSettings WHERE name =: String.valueOf(System.Today().Year()) LIMIT 1];
    
    Period perMonth = [SELECT Id, Number,FiscalYearSettings.name FROM Period WHERE
    // FiscalYearSettingsId =: fiscalYear.Id AND 
    Type = 'Month' AND StartDate <=: System.Today() AND EndDate >=: System.Today() LIMIT 1];

      Integer currentMonth =perMonth.Number;
      String currentYear=string.valueof(perMonth.FiscalYearSettings.name);
        Set<Id> ilcSeT= new Set<Id> ();
        
        
           // get ILC users
              for(Instructional_Lead_Consultant__c rec:newLst  )
              ilcSeT.add(rec.user__C);
                 
                 
          //get Manual adjustments of ILC Rep
          Map<String, decimal> recILCMap = new Map<String, decimal>();
          List <ILC_Stage_Milestone_Adjustment__c > ManualList= new List <ILC_Stage_Milestone_Adjustment__c >();
          ManualList=[select  ILC_Name__c,MileStone__c ,Watson_Non_Watson__c,Adjustment_ValueAmount__c,Adjustment_Period__c
          from ILC_Stage_Milestone_Adjustment__c  where ILC_Name__c in:ilcSeT and MileStone__c='Appointment'];
         for(ILC_Stage_Milestone_Adjustment__c  recILC :ManualList){
         string key=recILC.ILC_Name__c+'-'+recILC.Adjustment_Period__c;
         recILCMap.put(key,recILC.Adjustment_ValueAmount__c);
         }
         
        // quota Data
        
        Map<decimal, ILC_Metric_Quota__c> nonPLSMap= new Map<decimal, ILC_Metric_Quota__c> ();
        Map<decimal, ILC_Metric_Quota__c> PLSMap= new Map<decimal, ILC_Metric_Quota__c> ();

        // get Metric Quota Data
        List<ILC_Metric_Quota__c> quotaList= [ select Id,Amount_Value__c,Appointments_Per_Month__c,
        Month_Past_Training_Date__c,Quota_Period__c,
        Quota_Value__c,Summary_Stage__c,Type__c from ILC_Metric_Quota__c where Type__C='Appointment'];
        
        for(ILC_Metric_Quota__c  recData :quotaList){
            nonPLSMap.put(recData.Month_Past_Training_Date__c,recData);
        }
        
        // get the appointments for ILC Reps
        /* List<AggregateResult> tasklist= [SELECT ownerId, Appointment_FiscalMonth__C,
          COUNT(id) tasks        
         from  Task where ownerId in :ilcSeT
         and Task_Type__c='In Person'   and Appointment_Fiscal_Year__C=: currentYear   
         and whatId in
         (select Id  from Opportunity  where product__C= 'K-12 Growth' and watson__C=false) 
          GROUP BY CUBE(ownerId, Appointment_FiscalMonth__C)  ORDER BY GROUPING(ownerId), GROUPING(Appointment_FiscalMonth__C)];
          */
          
          List<AggregateResult> tasklist= [SELECT ownerId, Appointment_FiscalMonth__C,
          COUNT(id) tasks        
         from  Task where ownerId in :ilcSeT
         and Task_Type__c='In Person'   and Appointment_FiscalYear__c=: currentYear   
          GROUP BY CUBE(ownerId, Appointment_FiscalMonth__C)  ORDER BY GROUPING(ownerId), GROUPING(Appointment_FiscalMonth__C)];


        Map<String, integer> taskMap= new Map<String, integer>();        
        for (AggregateResult ar : tasklist) {
                    String KepMaptask=(String)ar.get('ownerId')+'-'+ (String)ar.get('Appointment_FiscalMonth__C');

            taskMap.put(KepMaptask , ((decimal)ar.get('tasks')).intValue());
        }
      System.debug('&&&&&&&&&&&tasklist'+taskMap);
      
      

          // get the event appointments for ILC Reps
         List<AggregateResult> eventlist= [SELECT ownerId, Appointment_FiscalMonth__C,
         COUNT(id) events        
         from  event where ownerId in :ilcSeT
         and Task_Type__c='In Person'   and Appointment_FiscalYear__c=: currentYear   
          GROUP BY CUBE(ownerId, Appointment_FiscalMonth__C)  ORDER BY GROUPING(ownerId), GROUPING(Appointment_FiscalMonth__C)];


        Map<String, integer> eventMap= new Map<String, integer>();        
        for (AggregateResult ar : eventlist) {
                    String KepMapevent=(String)ar.get('ownerId')+'-'+ (String)ar.get('Appointment_FiscalMonth__C');

            eventMap.put(KepMapevent , ((decimal)ar.get('events')).intValue());
        }

      
       // Clear Table
              List< K12_Sales_Activity__c> deletesalesList= new List< K12_Sales_Activity__c> ();
             Decimal eastquota=0,eastactual=0,westquota=0,westactual=0,eastmanual=0,westmanual=0;
             Decimal eastquarterquota1=0,eastquarterquota2=0,eastquarterquota3=0,eastquarterquota4=0;
             Decimal eastquarteractual1=0,eastquarteractual2=0,eastquarteractual3=0,eastquarteractual4=0;
             Decimal eastquartermanual1=0,eastquartermanual2=0,eastquartermanual3=0,eastquartermanual4=0;

             Decimal westquarterquota1=0,westquarterquota2=0,westquarterquota3=0,westquarterquota4=0;
             Decimal westquarteractual1=0,westquarteractual2=0,westquarteractual3=0,westquarteractual4=0;
             Decimal westquartermanual1=0,westquartermanual2=0,westquartermanual3=0,westquartermanual4=0;
             
             Decimal quarterRepquota1=0,quarterRepquota2=0,quarterRepquota3=0,quarterRepquota4=0;
             Decimal quarterRepactual1=0,quarterRepactual2=0,quarterRepactual3=0,quarterRepactual4=0;
             Decimal quarterRepmanual1=0,quarterRepmanual2=0,quarterRepmanual3=0,quarterRepmanual4=0;

             Decimal eastyearquota=0,eastyearactual=0,eastyearmanual=0,westyearquota=0,westyearactual=0,westyearmanual=0;
             Decimal yearRepquota=0,yearRepActual=0,yearRepManual=0;


              
              try{
             deletesalesList =[select Id from K12_Sales_Activity__c where Activity_Type__C='Appointment' and 
             FiscalYear__c=:currentYear and archive__c=false];
              if(deletesalesList.size()>0)
              delete deletesalesList;
              }
              catch(Exception e){}
       
        //List of Records to Insert       
       List< K12_Sales_Activity__c> salesList= new  List<K12_Sales_Activity__c >();
        
        // Process Over the Months from Jan till now
        
        for(integer i=1; i<=currentMonth;i++){
            // looping for NOn PLS functionality
            //looping over Reps
            //Current Month Date
             date myDate = date.newInstance(System.Today().Year() , i, 1);
             eastquota=0;eastactual=0;westquota=0;westactual=0;eastmanual=0;westmanual=0;
                          
              for(Instructional_Lead_Consultant__c rec:newLst  ){
                decimal Repquota=0;
              
              // Processing only if Rep is not terminated or termination is current Year
                  if(rec.Termination_Date__c==null  ||  (rec.Termination_Date__c.year()==System.Today().Year()   && i<=rec.Termination_Date__c.month()) ){
                                
                                // Non Watson Calculation
                                if( rec.Non_Watson_Training_Date__c !=null &&  rec.Non_Watson_Training_Date__c < =System.today() ){
                                        //get months between service date and current date
                                        
                                           System.debug('&&&&&&&&&&&  rec.Non_Watson_Training_Date__c'+rec.Non_Watson_Training_Date__c);                                    

                                           Integer monthsBetween = rec.Non_Watson_Training_Date__c.monthsBetween(myDate );   
                                           if( monthsBetween ==0|| monthsBetween ==-1){
                                              if(rec.Non_Watson_Training_Date__c.month()==i){
                                              monthsBetween =1;
                                              }
                                           }
                                           
                                           System.debug('&&&&&&&&&&&  monthsBetween '+monthsBetween );  
                                           
                             if( monthsBetween >0){                                               
                                           if(monthsBetween >12){
                                            Repquota= nonPLSMap.get(12).Appointments_Per_Month__c;        
                                           }
                                           else{
                                            Repquota= nonPLSMap.get(monthsBetween ).Appointments_Per_Month__c;
                                           }
        
                                K12_Sales_Activity__c salesRec= new K12_Sales_Activity__c();
                                salesRec.user__C=rec.user__C;
                                salesRec.FiscalYear__c=currentyear;
                                salesRec.Quota__c=Repquota;
                                salesRec.Type__c='Non-Watson';
                                salesRec.region__c=rec.region__C;
                                salesRec.FiscalMonth__c=string.valueof(i);
                                salesRec.No_Of_Months_From_Training_Date__c=monthsBetween ;
                                salesRec.Training_Date__c=rec.Non_Watson_Training_Date__c;
                                
                                String taskMapInput=rec.user__C+'-'+i;
                                
                                decimal taskcount= 0;decimal eventcount=0;
                                if(   taskMap.get(taskMapInput)!=null)
                                taskcount= taskMap.get(taskMapInput);
                                if(  eventMap.get(taskMapInput)!=null)
                                eventcount=eventMap.get(taskMapInput);
                                
                                
                                salesRec.Actual__c=taskcount+eventcount;
                                salesRec.Manual_Adj__c=recILCMap.get(taskMapInput);
                                salesRec.Activity_Type__C='Appointment';
                                salesREc.Period__C='Monthly';

                                salesList.add(salesRec);   

                               System.debug('&&&&&&&&&&&  getting summary'); 

                                     //get east summary
                                         if(rec.region__C=='East'){
                                         if(salesRec.Quota__c!=null)
                                         eastquota= eastquota+salesRec.Quota__c;
                                         if(salesRec.Actual__c!=null)
                                         eastactual=eastactual+salesRec.Actual__c; 
                                         if(SalesRec.Manual_Adj__c  !=null)
                                         eastmanual=eastmanual+salesRec.Manual_Adj__c  ;                             
                                         }
                                          //get west summary
                                         if(rec.region__C== 'West'){
                                         if(salesRec.Quota__c!=null)
                                         westquota= westquota+salesRec.Quota__c;
                                         if(salesRec.Actual__c!=null)
                                         westactual=westactual+salesRec.Actual__c; 
                                         if(SalesRec.Manual_Adj__c  !=null)
                                         westmanual=westmanual+salesRec.Manual_Adj__c  ;                             
                               
                                         }

                             }    // end of if monthbetween                         
                                }     
                  }    
              }// end of for
              
              // Summary for each Month Region Wise
              
                                K12_Sales_Activity__c salesRecEast= new K12_Sales_Activity__c();                               
                                salesRecEast.FiscalYear__c=currentyear;
                                salesRecEast.Quota__c=eastquota;
                                salesRecEast.Manual_Adj__c=eastmanual;
                                salesRecEast.Type__c='Non-Watson';
                                salesRecEast.region__c='East';
                                salesRecEast.FiscalMonth__c=string.valueof(i);                                                            
                                salesRecEast.Actual__c=eastactual;
                                salesRecEast.Activity_Type__C='Appointment';
                                salesRecEast.Period__C='Monthly';
                                salesRecEast.Summary__C=true;

                                salesList.add(salesRecEast); 
                                 K12_Sales_Activity__c salesRecWest= new K12_Sales_Activity__c();                               
                                salesRecWest.FiscalYear__c=currentyear;
                                salesRecWest.Quota__c=westquota;
                                salesRecWest.Manual_Adj__c=westmanual;
                                salesRecWest.Type__c='Non-Watson';
                                salesRecWest.region__c='West';
                                salesRecWest.FiscalMonth__c=string.valueof(i);                                                            
                                salesRecWest.Actual__c=westactual;
                                salesRecWest.Activity_Type__C='Appointment';
                                salesRecWest.Period__C='Monthly';
                                salesRecWest.Summary__C=true;
                                salesList.add(salesRecWest);   
  
                               // find quarter summations
                               if(i==1 || i==2|| i==3){
                                 eastquarterquota1=eastquarterquota1+eastquota;
                                 westquarterquota1=westquarterquota1+westquota;
                                 eastquarteractual1=eastquarteractual1+eastactual;
                                 westquarteractual1=westquarteractual1+westactual;
                                 eastquartermanual1=eastquartermanual1+eastmanual;
                                 westquartermanual1=westquartermanual1+westmanual;

                               }
                               else if( i==4 || i==5  || i==6){
                                 eastquarterquota2=eastquarterquota2+eastquota;
                                 westquarterquota2=westquarterquota2+westquota;
                                 eastquarteractual2=eastquarteractual2+eastactual;
                                 westquarteractual2=westquarteractual2+westactual;
                                 eastquartermanual2=eastquartermanual2+eastmanual;
                                 westquartermanual2=westquartermanual2+westmanual;


                               }
                            else if( i==7 || i==8  || i==9){
                                 eastquarterquota3=eastquarterquota3+eastquota;
                                 westquarterquota3=westquarterquota3+westquota;
                                 eastquarteractual3=eastquarteractual3+eastactual;
                                 westquarteractual3=westquarteractual3+westactual;
                                 eastquartermanual3=eastquartermanual3+eastmanual;
                                 westquartermanual3=westquartermanual3+westmanual;

                           
                            }
                            else if( i==10 || i==11  || i==12){
                                 eastquarterquota4=eastquarterquota4+eastquota;
                                 westquarterquota4=westquarterquota4+westquota;
                                 eastquarteractual4=eastquarteractual4+eastactual;
                                 westquarteractual4=westquarteractual4+westactual;
                                 eastquartermanual4=eastquartermanual4+eastmanual;
                                 westquartermanual4=westquartermanual4+westmanual;

                            }

              
        
        }  // end of outer for
        
        // create Quarter records for East Region Summary
                                K12_Sales_Activity__c salesEastQuarter1= new K12_Sales_Activity__c();                               
                                salesEastQuarter1.FiscalYear__c=currentyear;
                                salesEastQuarter1.Quota__c=eastquarterquota1;
                                salesEastQuarter1.Type__c='Non-Watson';
                                salesEastQuarter1.region__c='East';      
                                                                salesEastQuarter1.Manual_Adj__c=eastquartermanual1;
                                                                                    
                                salesEastQuarter1.Actual__c=eastquarteractual1;
                                salesEastQuarter1.Activity_Type__C='Appointment';
                                salesEastQuarter1.Period__C='Quarterly';
                                salesEastQuarter1.quarter__C='Quarter1';
                                salesEastQuarter1.Summary__C=true;
                                salesList.add(salesEastQuarter1); 
                                
                                K12_Sales_Activity__c salesEastQuarter2= new K12_Sales_Activity__c();                               
                                salesEastQuarter2.FiscalYear__c=currentyear;
                                salesEastQuarter2.Quota__c=eastquarterquota2;
                                salesEastQuarter2.Type__c='Non-Watson';
                                salesEastQuarter2.region__c='East';                                                                                          
                                salesEastQuarter2.Actual__c=eastquarteractual2;
                                salesEastQuarter2.Activity_Type__C='Appointment';
                                                                salesEastQuarter2.Manual_Adj__c=eastquartermanual2;

                                salesEastQuarter2.Period__C='Quarterly';
                                salesEastQuarter2.quarter__C='Quarter2';
                                salesEastQuarter2.Summary__C=true;
                                salesList.add(salesEastQuarter2); 
                                
                                K12_Sales_Activity__c salesEastQuarter3= new K12_Sales_Activity__c();                               
                                salesEastQuarter3.FiscalYear__c=currentyear;
                                salesEastQuarter3.Quota__c=eastquarterquota3;
                                salesEastQuarter3.Type__c='Non-Watson';
                                salesEastQuarter3.region__c='East';                                                                                          
                                salesEastQuarter3.Actual__c=eastquarteractual3;
                                salesEastQuarter3.Activity_Type__C='Appointment';
                                salesEastQuarter3.Period__C='Quarterly';
                                salesEastQuarter3.quarter__C='Quarter3';
                                                                salesEastQuarter3.Manual_Adj__c=eastquartermanual3;

                                salesEastQuarter3.Summary__C=true;
                                salesList.add(salesEastQuarter3); 


                                K12_Sales_Activity__c salesEastQuarter4= new K12_Sales_Activity__c();                               
                                salesEastQuarter4.FiscalYear__c=currentyear;
                                salesEastQuarter4.Quota__c=eastquarterquota4;
                                salesEastQuarter4.Type__c='Non-Watson';
                                salesEastQuarter4.region__c='East';                                                                                          
                                salesEastQuarter4.Actual__c=eastquarteractual4;
                                salesEastQuarter4.Activity_Type__C='Appointment';
                                salesEastQuarter4.Period__C='Quarterly';
                                salesEastQuarter4.quarter__C='Quarter4';
                                salesEastQuarter4.Summary__C=true;
                                                                salesEastQuarter4.Manual_Adj__c=eastquartermanual4;

                                salesList.add(salesEastQuarter4); 
                                
                                K12_Sales_Activity__c salesWestQuarter1= new K12_Sales_Activity__c();                               
                                salesWestQuarter1.FiscalYear__c=currentyear;
                                salesWestQuarter1.Quota__c=Westquarterquota1;
                                salesWestQuarter1.Type__c='Non-Watson';
                                salesWestQuarter1.region__c='West';                                                                                          
                                salesWestQuarter1.Actual__c=Westquarteractual1;
                                salesWestQuarter1.Activity_Type__C='Appointment';
                                salesWestQuarter1.Period__C='Quarterly';
                                salesWestQuarter1.quarter__C='Quarter1';
                                salesWestQuarter1.Summary__C=true;
                                                                salesWestQuarter1.Manual_Adj__c=Westquartermanual1;

                                salesList.add(salesWestQuarter1); 
                                
                                K12_Sales_Activity__c salesWestQuarter2= new K12_Sales_Activity__c();                               
                                salesWestQuarter2.FiscalYear__c=currentyear;
                                salesWestQuarter2.Quota__c=Westquarterquota2;
                                salesWestQuarter2.Type__c='Non-Watson';
                                salesWestQuarter2.region__c='West';                                                                                          
                                salesWestQuarter2.Actual__c=Westquarteractual2;
                                salesWestQuarter2.Activity_Type__C='Appointment';
                                salesWestQuarter2.Period__C='Quarterly';
                                salesWestQuarter2.quarter__C='Quarter2';
                                salesWestQuarter2.Summary__C=true;
                                salesWestQuarter2.Manual_Adj__c=Westquartermanual2;

                                salesList.add(salesWestQuarter2); 
                                
                                K12_Sales_Activity__c salesWestQuarter3= new K12_Sales_Activity__c();                               
                                salesWestQuarter3.FiscalYear__c=currentyear;
                                salesWestQuarter3.Quota__c=Westquarterquota3;
                                salesWestQuarter3.Type__c='Non-Watson';
                                salesWestQuarter3.region__c='West';                                                                                          
                                salesWestQuarter3.Actual__c=Westquarteractual3;
                                salesWestQuarter3.Activity_Type__C='Appointment';
                                salesWestQuarter3.Period__C='Quarterly';
                                salesWestQuarter3.quarter__C='Quarter3';
                                salesWestQuarter3.Summary__C=true;
                                salesWestQuarter3.Manual_Adj__c=Westquartermanual3;

                                salesList.add(salesWestQuarter3); 

                                K12_Sales_Activity__c salesWestQuarter4= new K12_Sales_Activity__c();                               
                                salesWestQuarter4.FiscalYear__c=currentyear;
                                salesWestQuarter4.Quota__c=Westquarterquota4;
                                salesWestQuarter4.Type__c='Non-Watson';
                                salesWestQuarter4.region__c='West';                                                                                          
                                salesWestQuarter4.Actual__c=Westquarteractual4;
                                salesWestQuarter4.Activity_Type__C='Appointment';
                                salesWestQuarter4.Period__C='Quarterly';
                                salesWestQuarter4.quarter__C='Quarter4';
                                salesWestQuarter4.Summary__C=true;
                                salesWestQuarter4.Manual_Adj__c=Westquartermanual4;

                                salesList.add(salesWestQuarter4); 
               
        //Find Yearly Summary Data
        
                      eastyearquota=eastquarterquota1+eastquarterquota2+eastquarterquota3+eastquarterquota4;
                      Westyearquota=Westquarterquota1+Westquarterquota2+Westquarterquota3+Westquarterquota4;
                      eastyearactual=eastquarteractual1+eastquarteractual2+eastquarteractual3+eastquarteractual4;
                      Westyearactual=Westquarteractual1+Westquarteractual2+Westquarteractual3+Westquarteractual4;
                      eastyearmanual=eastquartermanual1+eastquartermanual2+eastquartermanual3+eastquartermanual4;
                      Westyearmanual=Westquartermanual1+Westquartermanual2+Westquartermanual3+Westquartermanual4;

                      

                                K12_Sales_Activity__c salesEastYear= new K12_Sales_Activity__c();                               
                                salesEastYear.FiscalYear__c=currentyear;
                                salesEastYear.Quota__c=eastyearquota;
                                salesEastYear.Type__c='Non-Watson';
                                salesEastYear.region__c='East';                                                                                          
                                salesEastYear.Actual__c=eastyearactual;
                                salesEastYear.Activity_Type__C='Appointment';
                                salesEastYear.Period__C='Yearly';   
                                salesEastYear.Summary__C=true;   
                                salesEastYear.Manual_Adj__c=eastyearmanual;
                          
                                salesList.add(salesEastYear); 
                                
                                K12_Sales_Activity__c salesWestYear= new K12_Sales_Activity__c();                               
                                salesWestYear.FiscalYear__c=currentyear;
                                salesWestYear.Quota__c=Westyearquota;
                                salesWestYear.Type__c='Non-Watson';
                                salesWestYear.region__c='West';                                                                                          
                                salesWestYear.Actual__c=Westyearactual;
                                salesWestYear.Activity_Type__C='Appointment';
                                salesWestYear.Period__C='Yearly';   
                                salesWestYear.Summary__C=true;  
                                                                salesWestYear.Manual_Adj__c=westyearmanual;
                           
                                salesList.add(salesWestYear); 
                                
        
              
              // Find the quarter data for each Rep
                
              
              
              
              
                      

for(Instructional_Lead_Consultant__c rec:newLst  ){

             quarterRepquota1=0;quarterRepquota2=0;quarterRepquota3=0;quarterRepquota4=0;
             quarterRepactual1=0;quarterRepactual2=0;quarterRepactual3=0;quarterRepactual4=0;
             quarterRepmanual1=0;quarterRepmanual2=0;quarterRepmanual3=0;quarterRepmanual4=0;

             yearRepquota=0;yearRepActual=0;yearRepManual=0;
                       

      for(integer i=1; i<=currentMonth;i++){
            // looping for NOn PLS functionality
            //looping over Reps
            //Current Month Date

             date myDate = date.newInstance(System.Today().Year() , i, 1);
             
              
                decimal Repquota=0;
              
              // Processing only if Rep is not terminated or termination is current Year
                  if( rec.Termination_Date__c==null  ||  (rec.Termination_Date__c.year()==System.Today().Year()   && i<=rec.Termination_Date__c.month()) ){
                                
                                // Non Watson Calculation
                                if( rec.Non_Watson_Training_Date__c !=null   &&  rec.Non_Watson_Training_Date__c < =System.today() ){
                                        //get months between service date and current date
                                        
                                           System.debug('&&&&&&&&&&&  rec.Non_Watson_Training_Date__c'+rec.Non_Watson_Training_Date__c);                                    

                                           Integer monthsBetween = rec.Non_Watson_Training_Date__c.monthsBetween(myDate );   
                                           if( monthsBetween ==0|| monthsBetween ==-1){
                                              if(rec.Non_Watson_Training_Date__c.month()==i){
                                              monthsBetween =1;
                                              }
                                           }
                                           
                                           System.debug('&&&&&&&&&&&  monthsBetween '+monthsBetween );  
                                           
                             if( monthsBetween >0){                                               
                                           if(monthsBetween >12){
                                            Repquota= nonPLSMap.get(12).Appointments_Per_Month__c;        
                                           }
                                           else{
                                            Repquota= nonPLSMap.get(monthsBetween ).Appointments_Per_Month__c;
                                           }
                                
                                Decimal repactual=0,repmanual=0;

                                String taskMapInput=rec.user__C+'-'+i;
                                
                                decimal taskcount= 0;decimal eventcount=0;
                                if(   taskMap.get(taskMapInput)!=null)
                                taskcount= taskMap.get(taskMapInput);
                                if(  eventMap.get(taskMapInput)!=null)
                                eventcount=eventMap.get(taskMapInput);

                                
                                repactual=taskcount+eventcount;
                                repmanual=recILCMap.get(taskMapInput);

        
        
                             // find quarterRep summations
                               if(i==1 || i==2|| i==3){
                               if(repquota!=null)
                                 quarterRepquota1=quarterRepquota1+repquota;  
                                 if(repactual!=null)                               
                                 quarterRepactual1=quarterRepactual1+repactual; 
                                 if(repmanual!=null)                               
                                 quarterRepmanual1=quarterRepmanual1+repmanual; 
                                
                               }
                               else if( i==4 || i==5  || i==6){
                                if(repquota!=null)
                                 quarterRepquota2=quarterRepquota2+repquota;  
                                if(repactual!=null)                                                             
                                 quarterRepactual2=quarterRepactual2+repactual;  
                                 if(repmanual!=null)                               
                                 quarterRepmanual2=quarterRepmanual2+repmanual; 
                              
                               }
                            else if( i==7 || i==8  || i==9){
                                 if(repquota!=null)
                                 quarterRepquota3=quarterRepquota3+repquota;
                                 if(repactual!=null)                               
                                 quarterRepactual3=quarterRepactual3+repactual; 
                                 if(repmanual!=null)                               
                                 quarterRepmanual3=quarterRepmanual3+repmanual; 
                                                          
                            }
                            else if( i==10 || i==11  || i==12){                           
                                 if(repquota!=null)
                                 quarterRepquota4=quarterRepquota4+repquota;    
                                 if(repactual!=null)                                                           
                                 quarterRepactual4=quarterRepactual4+repactual; 
                                 if(repmanual!=null)                               
                                 quarterRepmanual4=quarterRepmanual4+repmanual; 
                               
                            }

                                
                             }    // end of if monthbetween                         
                                }     
                  }    
              }// end of for
              
              
                             if( rec.Non_Watson_Training_Date__c !=null &&  rec.Non_Watson_Training_Date__c < =System.today()  &&                             
                             (rec.Termination_Date__c==null  ||  (rec.Termination_Date__c.year()==System.Today().Year() ))
                              ){             
                                 K12_Sales_Activity__c salesRepQuarter1= new K12_Sales_Activity__c();
                                salesRepQuarter1.user__C=rec.user__C;
                                salesRepQuarter1.FiscalYear__c=currentyear;
                                salesRepQuarter1.Quota__c=quarterRepquota1;
                                salesRepQuarter1.Type__c='Non-Watson';
                                salesRepQuarter1.region__c=rec.region__C;    
                                salesRepQuarter1.Training_Date__c=rec.Non_Watson_Training_Date__c;                           
                                salesRepQuarter1.Actual__c=quarterRepactual1;
                                salesRepQuarter1.Activity_Type__C='Appointment';
                                salesRepQuarter1.Period__C='Quarterly';
                                salesRepQuarter1.quarter__C='Quarter1';
                                salesRepQuarter1.Manual_Adj__c=quarterRepmanual1;

                                salesList.add(salesRepQuarter1);   
                                
                                K12_Sales_Activity__c salesRepQuarter2= new K12_Sales_Activity__c();
                                salesRepQuarter2.user__C=rec.user__C;
                                salesRepQuarter2.FiscalYear__c=currentyear;
                                salesRepQuarter2.Quota__c=quarterRepquota2;
                                salesRepQuarter2.Type__c='Non-Watson';
                                salesRepQuarter2.Training_Date__c=rec.Non_Watson_Training_Date__c;                           
                                salesRepQuarter2.region__c=rec.region__C;                               
                                salesRepQuarter2.Actual__c=quarterRepactual2;
                                                                salesRepQuarter2.Manual_Adj__c=quarterRepmanual2;

                                salesRepQuarter2.Activity_Type__C='Appointment';
                                salesRepQuarter2.Period__C='Quarterly';
                                salesRepQuarter2.quarter__C='Quarter2';
                                salesList.add(salesRepQuarter2);   
                                
                                K12_Sales_Activity__c salesRepQuarter3= new K12_Sales_Activity__c();
                                salesRepQuarter3.user__C=rec.user__C;
                                salesRepQuarter3.FiscalYear__c=currentyear;
                                salesRepQuarter3.Quota__c=quarterRepquota3;
                                salesRepQuarter3.Type__c='Non-Watson';
                                salesRepQuarter3.region__c=rec.region__C;  
                                salesRepQuarter3.Training_Date__c=rec.Non_Watson_Training_Date__c;                                                        
                                salesRepQuarter3.Actual__c=quarterRepactual3;
                                salesRepQuarter3.Activity_Type__C='Appointment';
                                salesRepQuarter3.Period__C='Quarterly';
                                salesRepQuarter3.quarter__C='Quarter3';
                                                                salesRepQuarter3.Manual_Adj__c=quarterRepmanual3;

                                salesList.add(salesRepQuarter3);   
                                
                                K12_Sales_Activity__c salesRepQuarter4= new K12_Sales_Activity__c();
                                salesRepQuarter4.user__C=rec.user__C;
                                salesRepQuarter4.FiscalYear__c=currentyear;
                                salesRepQuarter4.Quota__c=quarterRepquota4;
                                salesRepQuarter4.Type__c='Non-Watson';
                                salesRepQuarter4.Training_Date__c=rec.Non_Watson_Training_Date__c;                           
                                salesRepQuarter4.region__c=rec.region__C;                               
                                salesRepQuarter4.Actual__c=quarterRepactual4;
                                salesRepQuarter4.Activity_Type__C='Appointment';
                                salesRepQuarter4.Period__C='Quarterly';
                                salesRepQuarter4.quarter__C='Quarter4';
                                                                salesRepQuarter4.Manual_Adj__c=quarterRepmanual4;

                                salesList.add(salesRepQuarter4);   

             yearRepquota=quarterRepquota1+quarterRepquota2+quarterRepquota3+quarterRepquota4;
             yearRepActual=quarterRepactual1+quarterRepactual2+quarterRepactual3+quarterRepactual4;
                          yearRepmanual=quarterRepmanual1+quarterRepmanual2+quarterRepmanual3+quarterRepmanual4;


                                K12_Sales_Activity__c salesRepYear= new K12_Sales_Activity__c();
                                salesRepYear.user__C=rec.user__C;
                                salesRepYear.FiscalYear__c=currentyear;
                                salesRepYear.Quota__c=yearRepquota;
                                salesRepYear.Type__c='Non-Watson';
                                salesRepYear.Training_Date__c=rec.Non_Watson_Training_Date__c;                           
                                salesRepYear.region__c=rec.region__C;                               
                                salesRepYear.Actual__c=yearRepActual;
                                salesRepYear.Activity_Type__C='Appointment';
                                salesRepYear.Period__C='Yearly';
                                salesRepYear.Manual_Adj__c=yearRepmanual;

                                salesList.add(salesRepYear);   

              }

       }// end of outer for
              

              //Insert Records
              if(salesList.size()>0)
              insert salesList;
        }
                                                                            
   
      /* This method is to execute to relase some resources if any*/
    global void finish(Database.BatchableContext BC)
    {   
    }     
        
    global void execute(SchedulableContext sc)
    {
        String strQuery = '';
        PopulateK12SalesActivityAppointment  PopulateOppAppointment= new PopulateK12SalesActivityAppointment  ( );
        database.executebatch(PopulateOppAppointment, 9000);
        
    } 
          
}
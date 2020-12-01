// This class is to Auto Launch the list of Records Loaded in the Transition Launch Object


Global class PopulateK12SalesActivityNonWatson implements database.Batchable<Sobject>,Database.Stateful,Schedulable
{
       global String strQuery; //this variable used to set query from test class or from shceduler if required
       public String DEFAULT_QUERY;

      
    /* Default Constructor*/
    global PopulateK12SalesActivityNonWatson ( )
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
          ManualList=[select  ILC_Name__c,MileStone__c ,Watson_Non_Watson__c,Adjustment_ValueAmount__c,Adjustment_Period__c,
          Summary_Stage__c
          from ILC_Stage_Milestone_Adjustment__c  where ILC_Name__c in:ilcSeT and MileStone__c='Amount' and 
          Watson_Non_Watson__c='Non-Watson'];
          
          
         for(ILC_Stage_Milestone_Adjustment__c  recILC :ManualList){
         string key=recILC.ILC_Name__c+'-'+recILC.Adjustment_Period__c;
         recILCMap.put(key,recILC.Adjustment_ValueAmount__c);
         }
         
        // quota Data
        
        Map<String, ILC_Metric_Quota__c> nonPLSMap= new Map<String, ILC_Metric_Quota__c> ();
        Set<String > stageset= new Set<String >();

        // get Metric Quota Data
        List<ILC_Metric_Quota__c> quotaList= [ select Id,Amount_Value__c,Appointments_Per_Month__c,
        Month_Past_Training_Date__c,Quota_Period__c,
        Quota_Value__c,Summary_Stage__c,Type__c from ILC_Metric_Quota__c where Type__c ='Non-Watson'];
        
        for(ILC_Metric_Quota__c  recData :quotaList){
            nonPLSMap.put(string.valueof(recData.Month_Past_Training_Date__c),recData);
        }
        
        System.debug('&&&&nonPLSMap'+nonPLSMap);

        
        // get the opportunities for ILC Reps for Opportunities in same month
         List<AggregateResult> tasklist= [SELECT  Opportunity_Owner__c,Fiscal_Month__c, COUNT(id) tasks ,
         Sum(Amount__c) amtTask       
         from  Opportunity_Tracking_History__c  where Opportunity_Owner__c   in :ilcSeT and 
         IsClosed__c=false and
         Fiscal_Year__c=: currentYear  and type__c='Monthly'  and Watson__c=false and CreatedinCurrentFiscalMonth__c=true  
             
         GROUP BY Opportunity_Owner__c, Fiscal_Month__c  ORDER BY GROUPING(Opportunity_Owner__c), GROUPING(Fiscal_Month__c)];


        Map<String, integer> taskMap= new Map<String, integer>();  
        Map<String, Decimal> taskMapAmount= new Map<String, Decimal>();  
              
        for (AggregateResult ar : tasklist) {
                    String KepMaptask=(String)ar.get('Opportunity_Owner__c')+'-'+ (String)ar.get('Fiscal_Month__c');
                    taskMap.put(KepMaptask, ((decimal)ar.get('tasks')).intValue());
                    taskMapAmount.put(KepMaptask, ((decimal)ar.get('amtTask')));

        }
        
                // get the opportunities for ILC Reps for Opportunities in same month
         List<AggregateResult> tasklistMonth= [SELECT  Opportunity_Owner__c,Fiscal_Month__c, COUNT(id) tasks,
         Sum(Amount__c) amtTask              
         from  Opportunity_Tracking_History__c  where Opportunity_Owner__c   in :ilcSeT and 
         IsClosed__c=false and 
         Fiscal_Year__c=: currentYear  and type__c='Monthly'  and Watson__c=false and  CreatedinCurrentFiscalMonth__c=false      
         GROUP BY Opportunity_Owner__c, Fiscal_Month__c  ORDER BY GROUPING(Opportunity_Owner__c), GROUPING(Fiscal_Month__c)];

        Map<String, integer> taskMapMonth= new Map<String, integer>();        
        Map<String, Decimal> taskMapMonthAmount= new Map<String, Decimal>();        

        for (AggregateResult ar : tasklistMonth) {
                    String KepMaptask=(String)ar.get('Opportunity_Owner__c')+'-'+ (String)ar.get('Fiscal_Month__c');
                    taskMapMonth.put(KepMaptask, ((decimal)ar.get('tasks')).intValue());
                    taskMapMonthAmount.put(KepMaptask, ((decimal)ar.get('amtTask')));
        }
    
        
        // get the aggregate by Oppteam 
        
         // get the opportunities amounts where fiscalmonth is same as opportunity Created Month
         List<AggregateResult> teamlist= [SELECT  user__C, Fiscal_Month__c,COUNT(id) tasks ,
         Sum(Opportunity_Tracking_History__r.Amount__c) amtTask                     
         from  Opportunity_Team_Member_History__c where Opportunity_Tracking_History__r.Fiscal_Year__c=: currentYear
         and Opportunity_Tracking_History__r.IsClosed__c=false   
         and Opportunity_Tracking_History__r.type__C='Monthly'  and Opportunity_Tracking_History__r.Watson__c=false
         GROUP BY user__C, Fiscal_Month__c ORDER BY GROUPING(user__C), GROUPING(Fiscal_Month__c)];
         
         
        Map<String, integer> teamMap= new Map<String, integer>();   
        Map<String, Decimal> teamMapAmount= new Map<String, Decimal>();        
           
                for (AggregateResult ar : teamlist) {
                   String KepMaptask=(String)ar.get('user__C')+'-'+ (String)ar.get('Fiscal_Month__c');
                    teamMap.put(KepMaptask, ((decimal)ar.get('tasks')).intValue());
                    teamMapAmount.put(KepMaptask, ((decimal)ar.get('amtTask')));
        }
        
        


       // Clear Table
             List< K12_Sales_Activity__c> deletesalesList= new List< K12_Sales_Activity__c> ();
             Decimal eastquota=0,eastactual=0,eastnewactual=0,eastmanual=0;
             Decimal westquota=0,westactual=0,westnewactual=0,westmanual=0;
             Decimal eastAmountactual=0,eastnewAmountactual=0,westAmountactual=0,westnewAmountactual=0;
             
             Decimal eastteam=0,westteam=0;
             Decimal eastAmountteam=0,westAmountteam=0;
                          
                   
              try{
             deletesalesList =[select Id from K12_Sales_Activity__c where Activity_Type__C='Amount'  and 
             FiscalYear__c=:currentYear     and archive__c=false       ];
              if(deletesalesList.size()>0)
              delete deletesalesList;
              }
              catch(Exception e){}
       
        //List of Records to Insert       
       List< K12_Sales_Activity__c> salesList= new  List<K12_Sales_Activity__c >();
        
        // Process Over the Months from Jan till now
        
        
                // Process Over the Months from Jan till now
        
        for(integer i=1; i<=currentMonth;i++){
            // looping for NOn PLS functionality
            //looping over Reps
            //Current Month Date
             date myDate = date.newInstance(System.Today().Year() , i, 1);
             
             //Resetting variables
             eastquota=0;eastactual=0;eastnewactual=0;eastmanual=0;
             westquota=0;westactual=0;westnewactual=0;westmanual=0;
             eastAmountactual=0;eastnewAmountactual=0;westAmountactual=0;westnewAmountactual=0 ;          
             eastteam=0;westteam=0; 
             eastAmountteam=0;westAmountteam=0;              
             
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
                                           Repquota= nonPLSMap.get('12').Amount_Value__c;        
                                           }
                                           else{
                                            Repquota= nonPLSMap.get(string.valueof(monthsBetween )).Amount_Value__c;
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
                                salesREc.Count_New__c=taskMap.get(taskMapInput);
                                salesREc.Opp_Value_New__c=taskMapAmount.get(taskMapInput);
                                salesRec.Count_Existing__c=taskMapMonth.get(taskMapInput);
                                salesRec.Opp_Value_Existing__c=taskMapMonthAmount.get(taskMapInput);
                                salesRec.Count_Team__c=teamMap.get(taskMapInput);
                                salesRec.Opp_Value_Team__c=teamMapAmount.get(taskMapInput);                              
                                salesRec.Manual_Adj__c=recILCMap.get(taskMapInput);
                                salesRec.Activity_Type__C='Amount';
                                salesREc.Period__C='Monthly';

                                salesList.add(salesRec);   

                               System.debug('&&&&&&&&&&&  getting summary'); 
                               
                                     //get east summary
                                         if(rec.region__C=='East'){
                                         if(salesRec.Quota__c!=null)
                                         eastquota= eastquota+salesRec.Quota__c;
                                         
                                         if(salesRec.Count_New__c!=null)
                                         eastnewactual =eastnewactual +salesRec.Count_New__c;                                                                                                                          
                                         if(salesRec.Opp_Value_New__c!=null)
                                         eastnewAmountactual =eastnewAmountactual +salesRec.Opp_Value_New__c; 
                                         if(salesRec.Count_Existing__c!=null)
                                         eastactual=eastactual+salesRec.Count_Existing__c; 
                                         if(salesRec.Opp_Value_Existing__c!=null)
                                         eastAmountactual=eastAmountactual+salesRec.Opp_Value_Existing__c; 
                                         if(salesRec.Count_Team__c!=null)
                                         eastteam =eastteam +salesRec.Count_Team__c; 
                                         if(salesRec.Opp_Value_Team__c!=null)
                                         eastAmountteam=eastAmountteam+salesRec.Opp_Value_Team__c; 

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
                                         
                                         if(salesRec.Count_New__c!=null)
                                         westnewactual =westnewactual +salesRec.Count_New__c;                                                                                                                          
                                         if(salesRec.Opp_Value_New__c!=null)
                                         westnewAmountactual =westnewAmountactual +salesRec.Opp_Value_New__c; 
                                         if(salesRec.Count_Existing__c!=null)
                                         westactual=westactual+salesRec.Count_Existing__c; 
                                         if(salesRec.Opp_Value_Existing__c!=null)
                                         westAmountactual=westAmountactual+salesRec.Opp_Value_Existing__c; 
                                         if(salesRec.Count_Team__c!=null)
                                         westteam =westteam +salesRec.Count_Team__c; 
                                         if(salesRec.Opp_Value_Team__c!=null)
                                         westAmountteam=westAmountteam+salesRec.Opp_Value_Team__c; 
                            
                               
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
                                
                                salesREcEast.Count_New__c=eastnewactual ;
                                salesREcEast.Opp_Value_New__c=eastnewAmountactual ;
                                salesREcEast.Count_Existing__c=eastactual;
                                salesREcEast.Opp_Value_Existing__c=eastAmountactual;
                                salesREcEast.Count_Team__c=eastteam ;
                                salesREcEast.Opp_Value_Team__c=eastAmountteam;                             
                                
                                                                                           
                                salesRecEast.Activity_Type__C='Amount';
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
                                salesREcWest.Count_New__c=Westnewactual ;
                                salesREcWest.Opp_Value_New__c=WestnewAmountactual ;
                                salesREcWest.Count_Existing__c=Westactual;
                                salesREcWest.Opp_Value_Existing__c=WestAmountactual;
                                salesREcWest.Count_Team__c=Westteam ;
                                salesREcWest.Opp_Value_Team__c=WestAmountteam;                                                                                       
                                salesRecWest.Activity_Type__C='Amount';
                                salesRecWest.Period__C='Monthly';
                                salesRecWest.Summary__C=true;
                                salesList.add(salesRecWest);   
  
              
        
        }  // end of outer for
        
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
        PopulateK12SalesActivityNonWatson PopulateOppNonWatson= new PopulateK12SalesActivityNonWatson( );
        database.executebatch(PopulateOppNonWatson, 9000);
        
    } 
          
}
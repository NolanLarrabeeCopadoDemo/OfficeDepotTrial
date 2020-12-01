// This class is to Auto Launch the list of Records Loaded in the Transition Launch Object
Global class PopulateK12SalesActivityPillar implements database.Batchable<Sobject>,Database.Stateful,Schedulable
{
       global String strQuery; //this variable used to set query from test class or from shceduler if required
       public String DEFAULT_QUERY;

      
    /* Default Constructor*/
    global PopulateK12SalesActivityPillar( )
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
       Set<String> stageset= new Set<String> ();

        
           // get ILC users
              for(Instructional_Lead_Consultant__c rec:newLst  )
              ilcSeT.add(rec.user__C);
                 
        List<Product_Subtypes_to_Pillar__c> pillarList=[select Pillar__c from Product_Subtypes_to_Pillar__c where 
        Watson__c=false];         
             for(Product_Subtypes_to_Pillar__c rec:pillarList  ){
             if(!stageset.contains (rec.Pillar__c ))
              stageset.add(rec.Pillar__c );
             }

        
        // get the opportunities for ILC Reps
         List<AggregateResult> tasklist= [SELECT  Pillar_key__C, Sum(Amount__c) tasks        
         from  Opportunity_Tracking_History__c  where Opportunity_Owner__c   in :ilcSeT and 
                  IsClosed__c=false and  

          Fiscal_Year__c=: currentYear  and type__c='Monthly'  and watson__C=false and Pillar_key__C!=null
          GROUP BY CUBE(Pillar_key__C)  ];


        Map<String, integer> taskMap= new Map<String, integer>();        
        for (AggregateResult ar : tasklist) {
        String keyPLS=(String)ar.get('Pillar_key__C');
                    if(keyPLS!=null && keyPLS!='' )
                    taskMap.put(keyPLS, ((decimal)ar.get('tasks')).intValue());
        }
        
       
               // get the opportunities for ILC Reps
         List<AggregateResult> tasklistAmount= [SELECT  Opportunity_Owner__c, Fiscal_Month__c,Sum(Amount__c) tasks        
         from  Opportunity_Tracking_History__c  where Opportunity_Owner__c   in :ilcSeT and 
                  IsClosed__c=false and  

          Fiscal_Year__c=: currentYear  and type__c='Monthly'  and watson__C=false  and pillar__c!=null
         GROUP BY CUBE(Opportunity_Owner__c, Fiscal_Month__c)   ];


        Map<String, integer> taskMapAmount= new Map<String, integer>();        
        for (AggregateResult ar : tasklistAmount) {
                    String keyPLS=(String)ar.get('Opportunity_Owner__c')+'-'+ (String)ar.get('Fiscal_Month__c');
                    if(keyPLS!=null && keyPLS!='' )
                    taskMapAmount.put(keyPLS, ((decimal)ar.get('tasks')).intValue());
        }
       
              List< K12_Sales_Activity__c> deletesalesList= new List< K12_Sales_Activity__c> ();
             Decimal eastquota=0,eastactual=0,westquota=0,westactual=0;
                                        
              try{
             deletesalesList =[select Id from K12_Sales_Activity__c where Activity_Type__C='Pillar' and FiscalYear__c=:currentYear
             and archive__c=false];
              if(deletesalesList.size()>0)
              delete deletesalesList;
              }
              catch(Exception e){}
       
        //List of Records to Insert       
       List< K12_Sales_Activity__c> salesList= new  List<K12_Sales_Activity__c >();
        
        // Process Over the Months from Jan till now
  
  
  
for(String stagerec :stageset){

              eastquota=0;eastactual=0;westquota=0;westactual=0;                                  
        for(integer i=1; i<=currentMonth;i++){
            // looping for NOn PLS functionality
            //looping over Reps
            //Current Month Date
             date myDate = date.newInstance(System.Today().Year() , i, 1);
             eastquota=0;eastactual=0;westquota=0;westactual=0;
                          
              for(Instructional_Lead_Consultant__c rec:newLst  ){
                Integer Repquota=0;
              
              // Processing only if Rep is not terminated or termination is current Year
                  if(rec.Termination_Date__c==null  ||  (rec.Termination_Date__c.year()==System.Today().Year()   && i<=rec.Termination_Date__c.month()) ){
                                
                                // Non Watson Calculation
                                if( rec.Watson_Training_Date__c !=null  &&  rec.Watson_Training_Date__c <=System.today()){
                                        //get months between service date and current date
                                        
                                           System.debug('&&&&&&&&&&&  rec.Watson_Training_Date__c'+rec.Watson_Training_Date__c);                                    

                                           Integer monthsBetween = rec.Watson_Training_Date__c.monthsBetween(myDate );   
                                           if( monthsBetween ==0|| monthsBetween ==-1){
                                              if(rec.Watson_Training_Date__c.month()==i){
                                              monthsBetween =1;
                                              }
                                           }
                                           
                                           System.debug('&&&&&&&&&&&  monthsBetween '+monthsBetween );  
                                           
                             if( monthsBetween >0){                                               
        
                                K12_Sales_Activity__c salesRec= new K12_Sales_Activity__c();

                                salesRec.user__C=rec.user__C;
                                salesRec.FiscalYear__c=currentyear;
                                
                                String taskMapInputAmount=rec.user__C+'-'+i;
                                String taskMapInputAmount1=string.valueof(rec.user__C).substring(0,15)+'-'+i;

                                Repquota=taskMapAmount.get(taskMapInputAmount);
                                if(Repquota==null)
                                Repquota=taskMapAmount.get(taskMapInputAmount1);                                

                                salesRec.Pillar_Monthly_Amount__c=Repquota;
                                salesRec.Type__c='Non-Watson';
                                salesRec.region__c=rec.region__C;
                                salesRec.FiscalMonth__c=string.valueof(i);
                                salesRec.No_Of_Months_From_Training_Date__c=monthsBetween ;
                                salesRec.Training_Date__c=rec.Watson_Training_Date__c;
                                String taskMapInput=rec.user__c+'-'+stagerec +'-'+i;
                                String taskMapInput1=string.valueof(rec.user__C).substring(0,15)+'-'+stagerec +'-'+i;                                  
                                Decimal actual=taskMap.get(taskMapInput);
                                System.debug('&&&&&&&&&&&&&&&&&&&&&&actual1'+actual);
                                if(actual==null)
                                actual=taskMap.get(taskMapInput1);                                
                                System.debug('&&&&&&&&&&&&&&&&&&&&&&actual2'+actual);

                                salesRec.Pillar_Amount__c=actual;
                                salesRec.Activity_Type__C='Pillar';
                                salesREc.Period__C='Monthly';
                                salesRec.Pillar__C=stagerec ;
                                salesList.add(salesRec);   

                               System.debug('&&&&&&&&&&&  getting summary'); 

                                     //get east summary
                                         if(rec.region__C=='East'){
                                         if(salesRec.Pillar_Monthly_Amount__c!=null)
                                         eastquota= eastquota+salesRec.Pillar_Monthly_Amount__c;
                                         if(salesRec.Pillar_Amount__c!=null)
                                         eastactual=eastactual+salesRec.Pillar_Amount__c; 
                            
                                         }
                                          //get west summary
                                         if(rec.region__C== 'West'){
                                         if(salesRec.Pillar_Monthly_Amount__c!=null)
                                         westquota= westquota+salesRec.Pillar_Monthly_Amount__c;
                                         if(salesRec.Pillar_Amount__c!=null)
                                         westactual=westactual+salesRec.Pillar_Amount__c; 

                                         }

                             }    // end of if monthbetween                         
                                }     
                  }    
              }// end of for
              
              // Summary for each Month Region Wise
              
                                K12_Sales_Activity__c salesRecEast= new K12_Sales_Activity__c();                               
                                salesRecEast.FiscalYear__c=currentyear;
                                salesRecEast.Pillar_Monthly_Amount__c=eastquota;
                                salesRecEast.Type__c='Non-Watson';
                                salesRecEast.region__c='East';
                                salesRecEast.FiscalMonth__c=string.valueof(i);                                                            
                                salesRecEast.Pillar_Amount__c=eastactual;
                                salesRecEast.Activity_Type__C='Pillar';
                                salesRecEast.Period__C='Monthly';
                                salesRecEast.Summary__C=true;
                                salesRecEast.Pillar__c=stagerec;
                                salesList.add(salesRecEast); 
                                
                                 K12_Sales_Activity__c salesRecWest= new K12_Sales_Activity__c();                               
                                salesRecWest.FiscalYear__c=currentyear;
                                salesRecWest.Pillar_Monthly_Amount__c=westquota;

                                salesRecWest.Type__c='Non-Watson';
                                salesRecWest.region__c='West';
                                salesRecWest.FiscalMonth__c=string.valueof(i);                                                            
                                salesRecWest.Pillar_Amount__c=westactual;
                                salesRecWest.Activity_Type__C='Pillar';
                                salesRecWest.Period__C='Monthly';
                                salesRecWest.Summary__C=true;
                                salesRecWest.Pillar__c=stagerec;

                                salesList.add(salesRecWest);   
  

              
        
        }  // end of outer for
        
                                
    }///outer most for- stage    
              
              
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
        PopulateK12SalesActivityPillar PopulateOppPillar= new PopulateK12SalesActivityPillar ( );
        database.executebatch(PopulateOppPillar, 9000);
        
    } 
          
}
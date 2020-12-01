global class Mod5BulkLaunchUpdate implements database.Batchable<Sobject>,Schedulable,Database.AllowsCallouts,Database.stateful
{

    global String strQuery;
    

    global List<Customer_Transition__c> orginialCTList ;
    
    // Default Constructor
    global Mod5BulkLaunchUpdate ()
    {
       // this.strQuery = DEFAULT_QUERY;
    }
    //This costructor is called from the Batch Schedule method
    global Mod5BulkLaunchUpdate (String query)
    {
       // if(query != null && query != '')
       //     this.strQuery = query;
       // else
      //      this.strQuery = DEFAULT_QUERY;
     //   System.debug('QUERY IS---->'+strQuery);
    }
    
   
    
    // This method prepares the scope of the batch program based on the query result 
    global Iterable<SObject> start(Database.BatchableContext BC)
    {
        orginialCTList = new List<Customer_Transition__c>();
        List<Split_Account_Detail__c> splitAccounts = new List<Split_Account_Detail__c>();
        
       //Setup of required input for Creation 
      orginialCTList = [Select Id,account__c FROM Customer_Transition__c WHERE Update_Launch_Status__C= true  Limit 1];
        
        if((!orginialCTList.isEmpty())  && (orginialCTList.size() > 0))
        {
           
        splitAccounts =[select Id,BulkLaunchProcessed__c,status__C,Error_Message__c,Linked_Customer_Transition__c,
                        Linked_Customer_Transition__r.omx_primary_key__C,customer_transition__r.Split_Launching_Status__c from
                        Split_Account_Detail__c  where customer_transition__C in:orginialCTList 
                        and   BulkLaunchProcessed__c=true ] ;                                                         
                                                          
        
        }
                    return splitAccounts;

    }
    
    // This method processes query result in batches 
    global void execute(Database.BatchableContext BC, List<Split_Account_Detail__c> scope)
    {
     
    List<Split_Account_Detail__c> splitAccounts = new List<Split_Account_Detail__c>();
    List<customer_transition__c> transDetailsUpdate= new List<customer_transition__c> ();
    Set<String>   masterkey = new Set<String> ();
      splitAccounts = scope;
      
      for(Split_Account_Detail__c detail : splitAccounts)
      {
      
      if(!masterkey.contains(detail.Linked_Customer_Transition__r.omx_primary_key__C) && detail.Linked_Customer_Transition__r.omx_primary_key__C!=null){
      masterkey.add(detail.Linked_Customer_Transition__r.omx_primary_key__C);
      Customer_transition__C custNew= new Customer_transition__C (Id=detail.Linked_Customer_Transition__c);
        if(detail.customer_transition__r.Split_Launching_Status__c=='Fail'){
         custNew.Split_Launching_Status__c='Fail';
         }
         if(detail.customer_transition__r.Split_Launching_Status__c=='Success'){
                    custNew.Split_Launching_Status__c ='Success';
                    custNew.Ready_for_Mod1__c=true;           
          }
       transDetailsUpdate.add(custNew);
      }
      
      
      detail.BulkLaunchProcessed__c=false;
         if(detail.customer_transition__r.Split_Launching_Status__c=='Fail'){
         detail.status__C='Error';
         }
         if(detail.customer_transition__r.Split_Launching_Status__c=='Success'){
                                   detail.status__C='Success';
                                   detail.Error_Message__c ='';
         }
      }
        if(splitAccounts.size()>0)
        update splitAccounts;
        if(transDetailsUpdate.size()>0)
        update transDetailsUpdate;

    }
    
    // This method is to execute to relase some resources if any
    global void finish(Database.BatchableContext BC)
    {
    
     List<Customer_Transition__c > custUpdate = new List<Customer_Transition__c > ();
            for(Customer_transition__C cstRec : orginialCTList)
                {
                Customer_transition__C cust= new Customer_transition__C   (Id=cstRec.Id);
                cust.Update_Launch_Status__C=false;
                custUpdate .add(cust);
                }
        
            if(custUpdate.size()>0)
            update custUpdate ;
    
     CustTransParentChildLevel__c PCLevel2 = [select Mod5LaunchUpdate__c,Mod5_LaunchUpdateInterval__C from 
            CustTransParentChildLevel__c limit 1];
        integer interval = 100;        
        if (PCLevel2.Mod5LaunchUpdate__c<> null) {
            for (CronTrigger existingJob: [SELECT Id FROM CronTrigger where ID=:PCLevel2.Mod5LaunchUpdate__c])
            system.abortJob(existingJob.id);
        }
        
        if(PCLevel2.Mod5_LaunchUpdateInterval__C != null)
            interval = (Integer)PCLevel2.Mod5_LaunchUpdateInterval__C ;
        
        DateTime sysTime = System.now().addSeconds(interval);
        String chronExpression = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        
        Mod5BulkLaunchUpdate Mod5BulkSplitCreateBatchObj = new Mod5BulkLaunchUpdate ();
        ID cronid = System.schedule( 'Mod5BulkLaunchUpdate ' + sysTime, chronExpression, Mod5BulkSplitCreateBatchObj );    
        
        PCLevel2.Mod5LaunchUpdate__c= cronid;
        
        update PCLevel2;    

     
    }     
        
    global void execute(SchedulableContext sc)
    {
        String strQuery = '';
        Mod5BulkLaunchUpdate Mod5BulkSplitCreateBatchObj = new Mod5BulkLaunchUpdate (strQuery);
        database.executebatch(Mod5BulkSplitCreateBatchObj , 500);
    } 
    
    
    
}
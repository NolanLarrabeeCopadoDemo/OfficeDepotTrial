global class Mod5BulkSplitDeleteBatch implements database.Batchable<Sobject>,Schedulable,Database.AllowsCallouts,Database.stateful
{

    global String strQuery;
    

    global List<Customer_Transition__c> orginialCTList ;
    
    //global String DEFAULT_QUERY ='Select Id,account__c '
                              //     +' FROM Customer_Transition__c '
                                //   +'WHERE Mod4FlowStatus__c= \'Splitted\'  Limit 1'; 
    
    // Default Constructor
    global Mod5BulkSplitDeleteBatch()
    {
       // this.strQuery = DEFAULT_QUERY;
    }
    //This costructor is called from the Batch Schedule method
    global Mod5BulkSplitDeleteBatch(String query)
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
      orginialCTList = [Select Id,account__c FROM Customer_Transition__c WHERE Mod4FlowStatus__c= 'Bulk Split Delete'  Limit 1];
        
        if((!orginialCTList.isEmpty())  && (orginialCTList.size() > 0))
        {
           
           //Split Class code Start
           system.debug('creating split details');
            splitAccounts =[Select Id from Split_Account_Detail__c WHERE Customer_Transition__c =:orginialCTList ];    
           //Split Class code End
        
            return splitAccounts;
        }
        else
        {
            return splitAccounts;
        }
        
    }
    
    // This method processes query result in batches 
    global void execute(Database.BatchableContext BC, List<Split_Account_Detail__c> scope)
    {
     
    List<Split_Account_Detail__c> splitAccounts = new List<Split_Account_Detail__c>();
    
      
      splitAccounts = scope;
    
        if(splitAccounts.size()>0)
        delete splitAccounts;
    
    }
    
    // This method is to execute to relase some resources if any
    global void finish(Database.BatchableContext BC)
    {
    
     List<Customer_Transition__c > custUpdate = new List<Customer_Transition__c > ();
            for(Customer_transition__C cstRec : orginialCTList)
                {
                Customer_transition__C cust= new Customer_transition__C   (Id=cstRec.Id);
                cust.Mod4FlowStatus__c  ='Bulk Split Deleted';
                custUpdate .add(cust);
                }
        
            if(custUpdate.size()>0)
            update custUpdate ;
    
     CustTransParentChildLevel__c PCLevel2 = [select Mod5BulkSplitDeleteBatchID__c,Mod5BulkSplitDeleteBatchInterval__c from 
            CustTransParentChildLevel__c limit 1];
        integer interval = 100;        
        if (PCLevel2.Mod5BulkSplitDeleteBatchID__c<> null) {
            for (CronTrigger existingJob: [SELECT Id FROM CronTrigger where ID=:PCLevel2.Mod5BulkSplitDeleteBatchID__c])
            system.abortJob(existingJob.id);
        }
        
        if(PCLevel2.Mod5BulkSplitDeleteBatchInterval__c!= null)
            interval = (Integer)PCLevel2.Mod5BulkSplitDeleteBatchInterval__c;
        
        DateTime sysTime = System.now().addSeconds(interval);
        String chronExpression = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        
        Mod5BulkSplitDeleteBatch Mod5BulkSplitDeleteBatchObj = new Mod5BulkSplitDeleteBatch ();
        ID cronid = System.schedule( 'Mod5BulkSplitDeleteBatch' + sysTime, chronExpression, Mod5BulkSplitDeleteBatchObj );    
        
        PCLevel2.Mod5BulkSplitDeleteBatchID__c= cronid;
        
        update PCLevel2;    

     
    }     
        
    global void execute(SchedulableContext sc)
    {
        String strQuery = '';
        Mod5BulkSplitDeleteBatch Mod5BulkSplitDeleteBatchObj = new Mod5BulkSplitDeleteBatch (strQuery);
        database.executebatch(Mod5BulkSplitDeleteBatchObj, 500);
    } 
    
    
    
}
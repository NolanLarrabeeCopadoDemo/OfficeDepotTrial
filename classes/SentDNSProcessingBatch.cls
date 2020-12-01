global class SentDNSProcessingBatch implements database.Batchable<Sobject>,Schedulable,Database.AllowsCallouts,Database.stateful
{

    private String strQuery;      
    private String DEFAULT_QUERY ='Select id,AOPS_Assigned_AOPS_Account_ID__c,DNS_Status_Confirmed__c,BatchProcessSentDNS__c FROM Customer_Transition__c WHERE DNS_Status_Confirmed__c = true and BatchProcessSentDNS__c =true  Limit 99'; 
    
    // Default Constructor
    global SentDNSProcessingBatch()
    {
        this.strQuery = DEFAULT_QUERY;
    }
    
    //This constructor is called from the Batch Schedule method
    global SentDNSProcessingBatch(String query)
    {
        if(query != null && query != '')
            this.strQuery = query;
        else
            this.strQuery = DEFAULT_QUERY;
        System.debug('QUERY IS---->'+strQuery);
    }
    
    // This method prepares the scope of the batch program based on the query result 
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
       
       return Database.getQueryLocator(strQuery);
    }
    
    
    // This method processes query result in batches 
    global void execute(Database.BatchableContext BC, SObject[] scope)
    {
       List<Customer_Transition__c> orginialCTList = scope;
       system.debug('@@orginialCTList@@'+orginialCTList);
       List<Customer_Transition__c> updatedCTlist = new List<Customer_Transition__c>();
       
       for(Customer_Transition__c eachCT : orginialCTList)
       {
           CustTransitionAOPSCallOut.batchBasicAuthCallout(eachCT.id,eachCT.AOPS_Assigned_AOPS_Account_ID__c,'DNS','Y');
           eachCT.BatchProcessSentDNS__c = false;
           updatedCTlist.add(eachCT);
           
       }
       
       system.debug('@@updatedCTlist@@'+updatedCTlist);
       
       if((!updatedCTlist.isEmpty())&&(updatedCTlist.size() > 0))
       update updatedCTlist;
       
       system.debug('@@updatedCTlist@@'+updatedCTlist);
    
    }
    
    // This method is to execute to relase some resources if any
    global void finish(Database.BatchableContext BC)
    {    
     CustTransParentChildLevel__c PCLevel2 = [select SentDNSProcessingBatchID__c,SentDNSProcessingBatchInterval__c from 
            CustTransParentChildLevel__c limit 1];
        integer interval = 300;        
        if (PCLevel2.SentDNSProcessingBatchID__c<> null) {
            for (CronTrigger existingJob: [SELECT Id FROM CronTrigger where ID=:PCLevel2.SentDNSProcessingBatchID__c])
            system.abortJob(existingJob.id);
        }
        
        if(PCLevel2.SentDNSProcessingBatchInterval__c!= null)
            interval = (Integer)PCLevel2.SentDNSProcessingBatchInterval__c;
        
        DateTime sysTime = System.now().addSeconds(interval);
        String chronExpression = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        
        SentDNSProcessingBatch SentDNSProcessingBatchObj = new SentDNSProcessingBatch ();
        ID cronid = System.schedule( 'SentDNSProcessingBatch' + sysTime, chronExpression, SentDNSProcessingBatchObj );    
        
        PCLevel2.SentDNSProcessingBatchID__c= cronid;
        
        update PCLevel2;    
    }     
        
    global void execute(SchedulableContext sc)
    {
        String strQuery = '';
        SentDNSProcessingBatch SentDNSProcessingBatchObj = new SentDNSProcessingBatch (strQuery);
        database.executebatch(SentDNSProcessingBatchObj, 99);
    } 
    
    
    
}
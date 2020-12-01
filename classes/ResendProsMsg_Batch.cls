global class ResendProsMsg_Batch implements database.Batchable<Sobject>,Schedulable,Database.AllowsCallouts
{

    public String strQuery;
    private DateTime dt = System.now().addDays(-3);
    private String DEFAULT_QUERY = 'select id,account__r.Mod_5_EBS_Sync_Status__c,account__C,account__r.OMXIsUpdated__c,account__r.split_record__c,Message_Complete__c,Republish__c,createddate from Prospect_Message__c where (account__r.oracle_party_id__c = null or (account__r.split_record__c=true and account__r.Mod_5_EBS_Sync_Status__c=null)) and createddate >= :dt';
    
    /* Default Constructor*/
    global ResendProsMsg_Batch()
    {
        this.strQuery = DEFAULT_QUERY;
    }
    /*This costructor is called from the Batch Schedule method*/
    global ResendProsMsg_Batch(String query)
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
       system.debug('>>>>scope>>>'+scope);
       List<Prospect_Message__c> prosMsgList = scope;
       List<Prospect_Message__c> updateProsMsgList = new List<Prospect_Message__c>();
       List<account > accList= new List<account > ();
       for(Prospect_Message__c eachProsMsg : prosMsgList)
       {
       if(eachProsMsg.account__r.split_record__c==true  && eachProsMsg.account__r.Mod_5_EBS_Sync_Status__c==null){
         Account acc= new Account(Id=eachProsMsg.account__C);
         acc.OMXIsUpdated__c=true;
         accList.add(acc);
         }
        else{
        eachProsMsg.Republish__c = 'Resend';
        updateProsMsgList.add(eachProsMsg);
        }
       }
       if(accList.size()>0)
       update accList;
       if((!updateProsMsgList.isEmpty()) && (updateProsMsgList.size() > 0))
       update updateProsMsgList;
    }
    
    // This method is to execute to relase some resources if any
    global void finish(Database.BatchableContext BC)
    {
    
    CustTransParentChildLevel__c PCLevel2 = [select ResendProsMsgBatchID__c from CustTransParentChildLevel__c limit 1];
      integer interval = 600;        
     if (PCLevel2.ResendProsMsgBatchID__c <> null) {
                      for (CronTrigger existingJob: [SELECT Id FROM CronTrigger where ID=:PCLevel2.ResendProsMsgBatchID__c])
                         system.abortJob(existingJob.id);
            }
              
            DateTime sysTime = System.now().addSeconds(interval);
            String chronExpression = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
    
            ResendProsMsg_Batch resendProsMsgBatch = new ResendProsMsg_Batch();
            ID cronid = System.schedule( 'ResendProsMsg_Batch' + sysTime, chronExpression, resendProsMsgBatch );    
            
            PCLevel2.ResendProsMsgBatchID__c = cronid;
            
            update PCLevel2; 
            
    }
    /**
        This method must be there to implement Schedulable interface
    **/
    global void execute(SchedulableContext sc)
    {
        String strQuery = '';
        ResendProsMsg_Batch resendProsMsgBatch = new ResendProsMsg_Batch(strQuery);
        database.executebatch(resendProsMsgBatch, 1);
        
    } 
    
    
    
}
global class Mod5InsertCntcBatch implements database.Batchable<Sobject>,Schedulable,Database.AllowsCallouts
{

    public String strQuery;
    private Map<Id,Id> accMap;
    private List<Id> accId;
    
   /* // Default Constructor
    global Mod5InsertCntcBatch()
    {
        this.strQuery = DEFAULT_QUERY;
    }
    //This costructor is called from the Batch Schedule method
    global Mod5InsertCntcBatch(String query)
    {
        if(query != null && query != '')
            this.strQuery = query;
        else
            this.strQuery = DEFAULT_QUERY;
        System.debug('QUERY IS---->'+strQuery);
    }*/
    
    //This costructor is called from the Batch Schedule method
    global Mod5InsertCntcBatch(Map<Id,Id> accMapParam,List<Id> accIdParam)
    {
        if( (!accMapParam.isEmpty())  && (accMapParam.size() > 0) && (!accIdParam.isEmpty())  && (accIdParam.size() > 0))
            {
            this.accMap = accMapParam;
            this.accId = accIdParam;
            this.strQuery = 'Select firstname,lastname, email,AccountId,phone,fax,ownerId,recordtypeId  from Contact where AccountId in :accId';
            }
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
       List < Contact > contList = scope;
       List<Contact> contInsertList = new List<Contact>();
     
    if( (!accMap.isEmpty())  && (accMap.size() > 0) && (!accId.isEmpty())  && (accId.size() > 0))
    {
        for (Id recordId : accMap.keySet())
        {   
        System.debug('@@@@contList '+contList.size());
        integer countSize = 0;
          for(integer i=0;i<contList.size();i++)
          {
          system.debug('contList '+i+'@@@'+contList[i]);
          
            if(  contList[i].AccountId==   accMap.get(recordId)){
            Contact contnew = new Contact(firstname=contList[i].firstname,lastname=contList[i].lastname,
                                        Override_duplicate_check__c = true,accountId=recordId ,
                                        ownerId=contList[i].ownerId, recordtypeId=contList[i].recordtypeId,
                                        email =contList[i].email, phone=contList[i].phone,fax=contList[i].fax);
            contInsertList.add(contnew);
            }
          }
        }
    }
    if((contInsertList.size() > 0) && (!contInsertList.isEmpty()))
    insert contInsertList;
        
    }
    
    // This method is to execute to relase some resources if any
    global void finish(Database.BatchableContext BC)
    {
    //We can use this in case of Batch Scheduling
    /*
    CustTransParentChildLevel__c PCLevel2 = [select Mod5InsertCntcBatchID__c from CustTransParentChildLevel__c limit 1];
      integer interval = 600;        
     if (PCLevel2.Mod5InsertCntcBatchID__c <> null) {
                      for (CronTrigger existingJob: [SELECT Id FROM CronTrigger where ID=:PCLevel2.Mod5InsertCntcBatchID__c])
                         system.abortJob(existingJob.id);
            }
              
            DateTime sysTime = System.now().addSeconds(interval);
            String chronExpression = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
    
            Mod5InsertCntcBatch mod5InsertCntcBatchObj = new Mod5InsertCntcBatch();
            ID cronid = System.schedule( 'Mod5InsertCntcBatch' + sysTime, chronExpression, mod5InsertCntcBatchObj );    
            
            PCLevel2.Mod5InsertCntcBatchID__c = cronid;
            
            update PCLevel2; 
      */      
    }
    
    // This method must be there to implement Schedulable interface
    global void execute(SchedulableContext sc)
    {
    //We can use this in case of Batch Scheduling
    /*
        String strQuery = '';
        Mod5InsertCntcBatch mod5InsertCntcBatchObj = new Mod5InsertCntcBatch(strQuery);
        database.executebatch(mod5InsertCntcBatchObj, 1);
    */  
    } 
    
    
    
}
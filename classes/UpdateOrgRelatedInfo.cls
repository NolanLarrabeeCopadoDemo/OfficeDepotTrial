global class UpdateOrgRelatedInfo implements database.Batchable<Sobject>,Schedulable,Database.AllowsCallouts,Database.stateful
{

    private String strQuery;      
    private String DEFAULT_QUERY ='Select id,Org__C FROM Account WHERE OrgChildUpdate__C= true   Limit 99'; 
    
    // Default Constructor
    global UpdateOrgRelatedInfo()
    {
        this.strQuery = DEFAULT_QUERY;
    }
    
    //This constructor is called from the Batch Schedule method
    global UpdateOrgRelatedInfo(String query)
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
       List<Account> orginialList = scope;
         
       if(orginialList.size() > 0){
         UpdateOrgChild obj= new UpdateOrgChild();
       obj.updateChild(orginialList);  
       }     
    
    }
    
    // This method is to execute to relase some resources if any
    global void finish(Database.BatchableContext BC)
    {    
     CustTransParentChildLevel__c PCLevel2 = [select UpdateOrgRelatedInfoID__c,UpdateOrgRelatedInfoInterval__c from 
            CustTransParentChildLevel__c limit 1];
        integer interval = 300;        
        if (PCLevel2.UpdateOrgRelatedInfoID__c<> null) {
            for (CronTrigger existingJob: [SELECT Id FROM CronTrigger where ID=:PCLevel2.UpdateOrgRelatedInfoID__c])
            system.abortJob(existingJob.id);
        }
        
        if(PCLevel2.UpdateOrgRelatedInfoInterval__c!= null)
            interval = (Integer)PCLevel2.UpdateOrgRelatedInfoInterval__c;
        
        DateTime sysTime = System.now().addSeconds(interval);
        String chronExpression = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        
        UpdateOrgRelatedInfo UpdateOrgRelatedInfoObj = new UpdateOrgRelatedInfo ();
        ID cronid = System.schedule( 'UpdateOrgRelatedInfo' + sysTime, chronExpression, UpdateOrgRelatedInfoObj );    
        
        PCLevel2.UpdateOrgRelatedInfoID__c= cronid;
        
        update PCLevel2;    
    }     
        
    global void execute(SchedulableContext sc)
    {
        String strQuery = '';
        UpdateOrgRelatedInfo UpdateOrgRelatedInfoObj = new UpdateOrgRelatedInfo (strQuery);
        database.executebatch(UpdateOrgRelatedInfoObj, 99);
    } 
    
    
    
}
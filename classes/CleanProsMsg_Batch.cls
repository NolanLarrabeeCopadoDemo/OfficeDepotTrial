global class CleanProsMsg_Batch implements database.Batchable<Sobject>,Schedulable
{

    //Variable Declaration
    public String strQuery;
    private DateTime dt = System.now().addDays(-7);
    private DateTime todayDate = System.now();
    private String DEFAULT_QUERY = 'select id,createddate from Prospect_Message__c where createddate < :dt';
    private String testDEFAULT_QUERY = 'select id,createddate from Prospect_Message__c where createddate <= :todayDate';
    
    /* Default Constructor*/
    global CleanProsMsg_Batch()
    {
        this.strQuery = DEFAULT_QUERY;
        
        if(Test.isRunningTest())
        this.strQuery = testDEFAULT_QUERY;
    }
    /*This costructor is called from the Batch Schedule method*/
    global CleanProsMsg_Batch(String query)
    {
        if(query != null && query != '')
            this.strQuery = query;
        else
            this.strQuery = DEFAULT_QUERY;
            
        if(Test.isRunningTest())
        this.strQuery = testDEFAULT_QUERY;
        
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
       //Deleting Prospect Message Records beyond Last 1 week
       delete prosMsgList;
    }   
    
    global void finish(Database.BatchableContext BC)
    {
    // This method is to execute to relase some resources if any
    }
    
     /**
        This method must be there to implement Schedulable interface
    **/
    global void execute(SchedulableContext sc)
    {
        String query = '';
        CleanProsMsg_Batch cleanProsMsgBatchObj = new CleanProsMsg_Batch(strQuery);
        Database.executebatch(cleanProsMsgBatchObj, 100);   
        
    } 
}
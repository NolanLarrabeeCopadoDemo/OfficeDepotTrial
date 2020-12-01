global class AccountAssignments_Batch_In implements database.Batchable<Sobject>, Schedulable

{
private Integer inactiveEmpCount = 0;
    public String strQuery; //this variable used to set query from test class or from shceduler if required
    
    // below is set a default query in case not set in test class or in scheduler
    private String DEFAULT_QUERY = 'Select Id, AccountId__c, AccountType__c, Entity_Type__c, Entity_Id__c, PrimaryEmpId__c, PrimaryEmpRole__c, ' 
                            +' OverlayEmpID1__c, OverlayEmpID2__c, OverlayEmpID3__c, OverlayEmpID4__c, OverlayEmpID5__c, OverlayEmpID6__c, OverlayEmpID7__c, OverlayEmpID8__c,' 
                            +' OverlayEmpID9__c, OverlayEmpID10__c, OverlayEmpID11__c, OverlayEmpID12__c, OverlayEmpID13__c, OverlayEmpID14__c, OverlayEmpID15__c,' 
                            +' OverlayEmpID16__c, OverlayEmpID17__c, OverlayEmpID18__c, OverlayEmpID19__c, OverlayEmpID20__c, OverlayEmpID21__c, OverlayEmpID22__c, OverlayEmpID23__c,' 
                            +' OverlayEmpID24__c, OverlayEmpID25__c, OverlayEmpID26__c, OverlayEmpID27__c, OverlayEmpID28__c, OverlayEmpID29__c, OverlayEmpID30__c,' 
                            +' OverlayEmpRole1__c, OverlayEmpRole2__c, OverlayEmpRole3__c, OverlayEmpRole4__c, OverlayEmpRole5__c, OverlayEmpRole6__c, '
                            +' OverlayEmpRole7__c, OverlayEmpRole8__c, OverlayEmpRole9__c, OverlayEmpRole10__c, OverlayEmpRole11__c, OverlayEmpRole12__c,' 
                            +' OverlayEmpRole13__c, OverlayEmpRole14__c, OverlayEmpRole15__c,OverlayEmpRole16__c, OverlayEmpRole17__c, OverlayEmpRole18__c, OverlayEmpRole19__c, OverlayEmpRole20__c,'
                            +' OverlayEmpRole21__c, OverlayEmpRole22__c, OverlayEmpRole23__c, OverlayEmpRole24__c, OverlayEmpRole25__c, OverlayEmpRole26__c, OverlayEmpRole27__c,'
                            +' OverlayEmpRole28__c, OverlayEmpRole29__c, OverlayEmpRole30__c,Status__c, Error_Message__c'
                            +' from AccountAssignments__c where RecordTypeId = \''+Label.Office_depot_Record_Type+'\'  and Status__c = \'Open\' ';
    

    /* Default Constructor*/
    global AccountAssignments_Batch_In()
    {
    }
    /*This costructor is called from the Batch Schedule mathod*/
    global AccountAssignments_Batch_In(String query)
    {
        System.debug('QUEERY IS---->'+query);
        if(query != null && query != '')
            this.strQuery = query;
        else
            this.strQuery = DEFAULT_QUERY;
    }
    
    /* This method prepares the scope of the batch programbased on the query result*/
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        System.debug('QUERY IS ====='+strQuery);
        return Database.getQueryLocator(strQuery);
    }
    
        /* This method processes query result in batches */
    global void execute(Database.BatchableContext BC, SObject[] scope)
    {

    }//end method.
    
    /* This method is to execute to relase some resources if any*/
    global void finish(Database.BatchableContext BC)
    {
        // not required
    } 
    
    
    

    
      
    
    global void execute(SchedulableContext sc)
    {
        String strQuery = 'Select Id, AccountId__c, AccountType__c, Entity_Type__c, Entity_Id__c, PrimaryEmpId__c, PrimaryEmpRole__c, ' 
                            +' OverlayEmpID1__c, OverlayEmpID2__c, OverlayEmpID3__c, OverlayEmpID4__c, OverlayEmpID5__c, OverlayEmpID6__c, OverlayEmpID7__c, OverlayEmpID8__c,' 
                            +' OverlayEmpID9__c, OverlayEmpID10__c, OverlayEmpID11__c, OverlayEmpID12__c, OverlayEmpID13__c, OverlayEmpID14__c, OverlayEmpID15__c,'
                            +' OverlayEmpID16__c, OverlayEmpID17__c, OverlayEmpID18__c, OverlayEmpID19__c, OverlayEmpID20__c, OverlayEmpID21__c, OverlayEmpID22__c, OverlayEmpID23__c,' 
                            +' OverlayEmpID24__c, OverlayEmpID25__c, OverlayEmpID26__c, OverlayEmpID27__c, OverlayEmpID28__c, OverlayEmpID29__c, OverlayEmpID30__c,' 
                            +' OverlayEmpRole1__c, OverlayEmpRole2__c, OverlayEmpRole3__c, OverlayEmpRole4__c, OverlayEmpRole5__c, OverlayEmpRole6__c, '
                            +' OverlayEmpRole7__c, OverlayEmpRole8__c, OverlayEmpRole9__c, OverlayEmpRole10__c, OverlayEmpRole11__c, OverlayEmpRole12__c,' 
                            +' OverlayEmpRole13__c, OverlayEmpRole14__c, OverlayEmpRole15__c,OverlayEmpRole16__c, OverlayEmpRole17__c, OverlayEmpRole18__c, OverlayEmpRole19__c, OverlayEmpRole20__c,'
                            +' OverlayEmpRole21__c, OverlayEmpRole22__c, OverlayEmpRole23__c, OverlayEmpRole24__c, OverlayEmpRole25__c, OverlayEmpRole26__c, OverlayEmpRole27__c,'
                            +' OverlayEmpRole28__c, OverlayEmpRole29__c, OverlayEmpRole30__c, Status__c, Error_Message__c '
                            +' from AccountAssignments__c where  RecordTypeId = \''+Label.Office_depot_Record_Type+'\'  and Status__c = \'Open\'  ';
        AccountAssignments_Batch assignBatch1 = new AccountAssignments_Batch(strQuery);
        database.executebatch(assignBatch1, 1);
        
        
    }  
    
    
}
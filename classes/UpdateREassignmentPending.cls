global class UpdateREassignmentPending implements database.Batchable<Sobject>,Schedulable,Database.AllowsCallouts
{

    public String strQuery;
    @TestVisible private String DEFAULT_QUERY = 'select Approver__c from Reassignment_Queue__c where status__C =\'Pending Approval\'  order by Approver__c' ;
    
    /* Default Constructor*/
    global UpdateREassignmentPending()
    {
        this.strQuery = DEFAULT_QUERY;
    }
    /*This costructor is called from the Batch Schedule method*/
    global UpdateREassignmentPending(String query)
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
       List<Reassignment_Queue__c > currentList = scope;
       List<Pending_ReAssignment_Approvals__c > penRecList= new List<Pending_ReAssignment_Approvals__c > ();
       SEt<Id > accset= new Set<Id > ();
       SEt<Id > userset= new Set<Id > ();

       Date dt=System.today();

       for(Reassignment_Queue__c rec : currentList)
       {
         if(!accset.contains(rec.approver__C))
         accset.add(rec.approver__C);
       }
     List<Pending_ReAssignment_Approvals__c > procList=[ select Id,user__C from Pending_ReAssignment_Approvals__c where
     User__c in :accset and lastmodifieddate>=:dt];
         for(Pending_ReAssignment_Approvals__c  recList:procList){
           userset.add(recList.user__C );
         }

       for(iD rec : accset)
       {
             if(!userset.contains(rec)){
              Pending_ReAssignment_Approvals__c penRec= new Pending_ReAssignment_Approvals__c();
              penRec.User__c=rec;
              penRec.User_ID__c=rec;
              penRecList.add(penRec);
              }
       }
       
       
       if(penRecList.size()>0)
       upsert penRecList User_ID__c;
    }
    
    // This method is to execute to relase some resources if any
    global void finish(Database.BatchableContext BC)
    {            
    }
    /**
        This method must be there to implement Schedulable interface
    **/
    global void execute(SchedulableContext sc)
    {
        String strQuery = '';
        UpdateREassignmentPending resendProsMsgBatch = new UpdateREassignmentPending(strQuery);
        database.executebatch(resendProsMsgBatch, 1);
        
    } 
    
    
    
}
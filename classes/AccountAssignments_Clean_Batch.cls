/***
Description: This Is a batch Apex program. Scope of this is the AccountAssignment__c object records with 'Processed' status.
Functionality of the Batch program is:
1. Delete the old Assignment records which got 'Processed'
2. Cut off date for Old records is configurable via Custom setting, default is set to 15 days.  

Created By: Sunil Bansal
Created Date: 18-May-2012

Modified By: Sunil Bansal
Modified Date: 02-Jan-2013

Modify Reason: Included the schedulable batch within this class to schedule this class independentely
**/
global class AccountAssignments_Clean_Batch implements database.Batchable<Sobject>, Schedulable
{
    public String strQuery; //this variable used to set query from test class or from shceduler if required
    
    // below is set a default query in case not set in test class or in scheduler
    private String DEFAULT_QUERY = 'Select Id from AccountAssignments__c where Status__c = \'Processed\'';
    

    /* Default Constructor*/
    global AccountAssignments_Clean_Batch()
    {
    }
    
    /*This costructor is called from the Batch Schedule mathod*/
    global AccountAssignments_Clean_Batch(String query)
    {
        
        Integer pastDays = 15;
        try
        {
            Map<String, Keyvalue_Map_CS__c> keyValueMap = Keyvalue_Map_CS__c.getAll();
            pastDays = Integer.valueOf(keyValueMap.get('AccountAssignmentCleanPastDaysIn').Data_Value__c);
        }
        catch(Exception e)
        {
            // do nothing
        }
        
        DateTime dt = DateTime.now();
        dt = dt.addDays(-pastDays);
        String strDate = dt.format('yyyy-MM-dd')+'T00:00:00.000Z';
        if(query != null && query != '')
            this.strQuery = query;
        else
            this.strQuery = DEFAULT_QUERY + ' and LastModifiedDate < '+strDate;

        System.debug('QUEERY IS---->'+query);

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
        try
        {
            List<AccountAssignments__c> lstAssignments = scope;
            delete lstAssignments; // delete 'Processed' records
            
        }
        catch(Exception ex)
        {
            System.debug('WHY ERROR CAME here = '+ex.getMessage());
            Util.LOG('AccountAssignments_Clean_Batch.execute', -1, ex.getMessage());
        }
    }
    
    /* This method is to execute to relase some resources if any*/
    global void finish(Database.BatchableContext BC)
    {
        // do Nothing
    }
    
    /**
        This method must be there to implement Schedulable interface
    **/
    global void execute(SchedulableContext sc)
    {
        try
        {
            String strCleanQuery = '';
            AccountAssignments_Clean_Batch cleanBatch = new AccountAssignments_Clean_Batch(strCleanQuery);
            database.executebatch(cleanBatch, 2000);
        }
        catch(Exception ex)
        {
            System.debug('WHY ERROR CAME here = '+ex.getMessage());
            Util.LOG('AccountAssignments_Clean_Schedule.execute', -1, ex.getMessage());
        }
    } 
}
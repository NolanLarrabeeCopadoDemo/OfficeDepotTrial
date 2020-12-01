Global class Update_RecordHistory implements database.Batchable<Sobject>,Schedulable
{
    
    BusinessHours bh = [select id from businesshours where IsDefault=true];
    BusinessHours acctmainbh = [select id from businesshours where name='Acct Maintenance'];
     private static Map<String,Schema.RecordTypeInfo> CaseRecType = Schema.SObjectType.Case.getRecordTypeInfosByName();
    public String strQuery; //this variable used to set query from test class or from shceduler if required
    // Below is set a default query in case not set in test class or in scheduler
    private String DEFAULT_QUERY ='Select id,Start_Date__c,End_Date__c,No_of_Hours__c,Case__r.Recordtypeid from Record_History__c where Start_Date__c!=null and End_Date__c=null'; 
    /* Default Constructor*/
    global Update_RecordHistory()
    {        
        this.strQuery = DEFAULT_QUERY;
    }
    /*This costructor is called from the Batch Schedule method*/
    global Update_RecordHistory(String query)
    {
        System.debug('QUERY IS---->'+query);
        if(query != null && query != '')
        {    
            this.strQuery = query;
        }   
        else
        {
            this.strQuery = DEFAULT_QUERY;
        }                 
    }
    /* This method prepares the scope of the batch program based on the query result */
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(strQuery);
    }
     /* This method processes query result in batches */
    global void execute(Database.BatchableContext BC, SObject[] scope)
    {
        List<Record_History__c> lstrechis=scope;
        System.debug('The size of the list-->'+lstrechis);
        for(Record_History__c rechis_alias:lstrechis)
        {
            if(rechis_alias.Case__r.Recordtypeid==CaseRecType.get('Work Request').getRecordTypeId())
            {
                system.debug('Work request');
                rechis_alias.No_of_Hours__c=(Businesshours.diff(bh.id,rechis_alias.Start_Date__c, System.Now())/(1000*60*60));
            }
            if(rechis_alias.Case__r.Recordtypeid==CaseRecType.get('Account Maintenance').getRecordTypeId())
            {
                system.debug('Account Maintainance');
                rechis_alias.No_of_Hours__c=(Businesshours.diff(acctmainbh.id,rechis_alias.Start_Date__c, System.Now())/(1000*60*60));
            }
        }
        update lstrechis;
    }
     /* This method is to execute to relase some resources if any*/
    global void finish(Database.BatchableContext BC)
    {
                        
    }
     /**
        This method must be there to implement Schedulable interface
    **/
    global void execute(SchedulableContext sc)
    {
        String strQuery = '';
        Update_RecordHistory assignBatch = new Update_RecordHistory(strQuery);
        database.executebatch(assignBatch, 200);
    } 
          
}
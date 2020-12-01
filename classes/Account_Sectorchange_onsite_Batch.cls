/***
Description: The Scope of this Batch Class is Account Object(prospect/customer & Site).This will update Sites with their parent customer's Sector,Segment, Buying_group values.
Functionality of the Batch program is:
1. This query only those Site records where street,city,state,zip changed & primary=true and last modified date or create date was today
2. Matching records will processed to check if the site address is changed. 
3. If the address is changed then the Parent address will be updated with the primary site address

This single class implemnets both interfaces Batchable and Schedulable.


Created By: Ankur Pradhan
Created Date: 07-MAY-2012

Modified By:
Modified Date:

Modify Reason:
**/
global class Account_Sectorchange_onsite_Batch implements database.Batchable<Sobject>, Schedulable
{
    public String strQuery;
    private string DEFAULT_QUERY;
    //Account_Changes__c mc = Account_Changes__c.getOrgDefaults();
    
    

    /* Default Constructor
    global Account_Sectorchange_onsite_Batch()
    {
    }
    */
    /*This costructor is called from teh Batch Schedule mathod*/
    global Account_Sectorchange_onsite_Batch(String query)
    {
       // if(mc.Run_for_All__c == true)
       // {
       //     DEFAULT_QUERY = 'Select Id, Name, RecordTypeId , Related_Account__c, Buying_Group__c,Sector__c,Segment__c, Primary_Site__c from Account where Related_Account__c = null';
       // }
       // else 
       // {
            DEFAULT_QUERY = 'Select Id, Name, RecordTypeId , Related_Account__c, Buying_Group__c,Sector__c,Segment__c, Primary_Site__c from Account where Related_Account__c = null and lastmodifieddate = today';    
       // }
        System.debug('QUEERY IS---->'+query);
        if(query != null && query != '')
            this.strQuery = query;
        else
            this.strQuery = DEFAULT_QUERY;
    }
    
    /* This method prepares the scope of the batch programbased on teh query result*/
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        System.debug('QUERY IS ====='+strQuery);
        return Database.getQueryLocator(strQuery);
    }
    
    /* */
    global void execute(Database.BatchableContext BC, list<account> scope)
    {
        List<Account> lstcustomer = scope;
        Account_address_sector_change sect_change = new  Account_address_sector_change ();
        sect_change.Account_addr_Sect_change (lstcustomer);
    }
    
    /* This method is executed to relase some resources if any*/
    global void finish(Database.BatchableContext BC)
    {
       //Not required
    }
  
    /***************************************************************************************
        This method must be there to implement Schedulable interface
   ************************************************************************************** **/
    global void execute(SchedulableContext sc)
    {
        try 
        {
            //Abort the existing schedule 
            CronTrigger ct = [SELECT id,CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :SC.getTriggerId()];
            if(ct != null)
            {
                System.abortJob(ct.Id);
            }
        } catch (Exception e) 
        {
            System.debug('There are no jobs currently scheduled. ' + e.getMessage()); 
        }

        String strQuery = '';
        Account_Sectorchange_onsite_Batch assignBatch = new Account_Sectorchange_onsite_Batch(strQuery);
        Map<String, Keyvalue_Map_CS__c> keyValueMap = Keyvalue_Map_CS__c.getAll();
        Integer batchSize  = Integer.valueOf(keyValueMap.get('AccountSectorChangesBatchSize').Data_Value__c);
        database.executebatch(assignBatch, batchSize);
    } 
    

}
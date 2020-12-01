/***
Description: The Scope of this Batch Class is Account Object(prospect/customer & Site).This will update prospect/customer addresses based on primary site address
Functionality of the Batch program is:
1. This query only those Site records where street,city,state,zip changed & primary=true and last modified date or create date was today
2. Matching records will processed to check if the site address is changed. 
3. If the address is changed then the Parent address will be updated with the primary site address

This single class implemnets both interfaces Batchable and Schedulable.


Created By: Ankur Pradhan
Created Date: 25-Apr-2012

Modified By:
Modified Date:

Modify Reason:
**/
global class Account_addresschange_Batch implements database.Batchable<Sobject>, Schedulable
{
    global String strQuery;
    private string DEFAULT_QUERY;
    //Account_Changes__c mc = Account_Changes__c.getOrgDefaults();
    
    /*This is the default costructor */
    global Account_addresschange_Batch()
    {
    }
    /*This costructor is called from teh Batch Schedule mathod*/
    global Account_addresschange_Batch(String query)
    {
       // if(mc.Run_for_All__c == true)
       // {
       //     DEFAULT_QUERY = 'Select Id, Name, RecordTypeId , Related_Account__c, Address1__c, Address2__c, City__c, State__c, zip__c, Country__c, County__c, Primary_Site__c from Account where Primary_Site__c = true and Related_Account__c != null';    
       // }
       // else 
       // {
            DEFAULT_QUERY = 'Select Id, Name, RecordTypeId , Related_Account__c, Address1__c, Address2__c, City__c, State__c, zip__c, Country__c, County__c, Primary_Site__c from Account where Primary_Site__c = true and Related_Account__c != null and lastmodifieddate = today';
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
        List<Account> lstsites = scope;
         Account_address_sector_change addr_change = new  Account_address_sector_change ();
         addr_change.Account_addr_Sect_change (lstsites);
    }
    
    /* This method is executed to relase some resources if any*/
    global void finish(Database.BatchableContext BC)
    {
       
       //calling sector change batch
      //EmailHandler.sendEmail('start second batch');//Via Email Handler
        Datetime dt = System.now();
        dt = dt.addMinutes(2);
        String scheduleString='0';//0 seconds
        scheduleString+=' '+ dt.minute();
        scheduleString+=' '+ dt.hour();
        scheduleString+=' '+ dt.day();
        scheduleString+=' '+ dt.month();
        scheduleString+=' ?';
        scheduleString+=' '+ dt.year();     
        System.debug('currently scheduled. time for education eduMasterGroup  ' + scheduleString); 

                                           
        String mappingQuery = '';
        Account_Sectorchange_onsite_Batch assignBatch = new Account_Sectorchange_onsite_Batch(mappingQuery);
        if(!Test.isrunningtest())
        {
            Id ScheduleBatchEducationEducMasterGroupId = System.schedule('Sector Change Batch',scheduleString , assignBatch);
        }
    }
  
    /**
        This method must be there to implement Schedulable interface
    **/
    global void execute(SchedulableContext sc)
    {
        String strQuery = '';
        Account_addresschange_Batch assignBatch = new Account_addresschange_Batch(strQuery);
        Map<String, Keyvalue_Map_CS__c> keyValueMap = Keyvalue_Map_CS__c.getAll();
        Integer batchSize  = Integer.valueOf(keyValueMap.get('Account_addresschange').Data_Value__c);
        database.executebatch(assignBatch,batchSize);
    } 


}
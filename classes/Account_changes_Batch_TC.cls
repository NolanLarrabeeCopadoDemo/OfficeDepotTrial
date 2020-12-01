/***
Description: The test Class  for the account changes batch classes, email handler and emailservice handler classes.
Created By: Ankur Pradhan
Created Date: 10-May-2012

Modified By:
Modified Date:

Modify Reason:
**/
@isTest
private class Account_changes_Batch_TC
{
    public static testMethod void Account_changes_Batch_TC() 
    {
       
       id aid;
    
       Account acc = new Account ();
       acc.name = 'Ank Test Account';
       acc.BillingStreet = '1040 N 326 W';
       acc.billingcity = 'Orem';
       acc.BillingState = 'UT';
       acc.Billingcountry = 'USA';
       acc.Buying_Group__c = 'Buying Groups Federal';
       acc.Sector__c = 'Public';
       acc.Segment__c = 'Federal';
       acc.Oracle_Party_Id__c = 'testdata';
       acc.AOPS_Cust_Id__c = '123456';
       acc.AOPS_Seq_ID__c = '123456';
       insert acc;
        aid = acc.id;
       Account accSite = new Account ();
       accSite.name = 'Ank Test Account1';
       accSite.BillingStreet = '1040 N 326 W';
       accSite.billingcity = 'Orem';
       accSite.BillingState = 'UT';
       accSite.Billingcountry = 'US';
       accSite.Address1__c = '4785 S Citation Drive';
       accSite.Address2__c = '202';
       accSite.City__c = 'Delray Beach';
       accSite.State__c = 'FL';
       accSite.zip__c ='33351';
       accSite.Country__c = 'USA';
       accSite.County__c = 'US';
       accSite.Related_Account__c = acc.id;
       accSite.Primary_Site__c= true;
       accSite.Oracle_Party_Site_Id__c = 'testdata';
       accSite.AOPS_Cust_Id__c = '12345678';
       accSite.AOPS_Seq_ID__c = '12345678';
       insert accSite;
       
       
        // Create a new email and envelope object
       // Messaging.InboundEmail email  = new Messaging.InboundEmail();
       // Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        
        // Create the email body
        //email.plainTextBody = 'start second batch';
        //email.fromAddress ='test@test.com';
        //email.subject = 'Dummy mail';
       
       //EmailServiceHandler esr = new EmailServiceHandler();
       
       String strQuery = '';
       
       Test.StartTest();
       //Executing Address Change
       strQuery = 'Select Id, Name, RecordTypeId , Related_Account__c, Buying_Group__c,Sector__c,Segment__c, Primary_Site__c, Oracle_Party_Site_Id__c from Account where Related_Account__c = null and Oracle_Party_Site_Id__c=\'testdata\'';
       Account_addresschange_Batch addchange_batch = new Account_addresschange_Batch(strQuery);
       Database.executeBatch(addchange_batch,200);
       addchange_batch.strQuery = 'Select Id, Name, RecordTypeId , Related_Account__c, Buying_Group__c,Sector__c,Segment__c, Primary_Site__c, Oracle_Party_Site_Id__c from Account where Related_Account__c = null and id=\''+ acc.id+'\'';
       Database.executeBatch(addchange_batch,200);
       
       //Executing Sector change
      // Account_address_sector_change adscchange = new Account_address_sector_change ();
       strQuery = 'Select Id, Name, RecordTypeId , Related_Account__c, Address1__c, Address2__c, City__c, State__c, zip__c, Country__c, County__c, Primary_Site__c, Oracle_Party_Site_Id__c from Account where Primary_Site__c = true and Oracle_Party_Site_Id__c=\'testdata\'';
       Account_Sectorchange_onsite_Batch sectchangeBatch = new Account_Sectorchange_onsite_Batch(strQuery);
       //adscchange.lstcustomer.add(acc);
       database.executebatch(sectchangeBatch, 100);
       //sectchangeBatch.strQuery = 'Select Id, Name, RecordTypeId , Related_Account__c, Address1__c, Address2__c, City__c, State__c, zip__c, Country__c, County__c, Primary_Site__c from Account where Primary_Site__c = true and id=\''+ accSite.id+'\'';
       //Database.executeBatch(addchange_batch,200); 
       
       //Messaging.InboundEmailResult result = esr.handleInboundEmail(email, env);
       
       Datetime dt = System.now();
        String scheduleString='0';//0 seconds
        scheduleString+=' '+ dt.minute();
        scheduleString+=' '+ dt.hour();
        scheduleString+=' '+ dt.day();
        scheduleString+=' '+ dt.month();
        scheduleString+=' ?';
        scheduleString+=' '+ dt.year();     
        System.debug('currently scheduled. time for education eduMasterGroup  ' + scheduleString); 

         String CRON_EXP = '0 0 0 3 9 ? 2022';                                  
        String mappingQuery = '';
        Account_Sectorchange_onsite_Batch assignBatch = new Account_Sectorchange_onsite_Batch(mappingQuery);
        System.schedule('Sector Change Batch',CRON_EXP , assignBatch);
        Account_addresschange_Batch addchange_batch_T = new Account_addresschange_Batch(mappingQuery);
       System.schedule('Add Change Batch',CRON_EXP , addchange_batch_T);
      /*********************
      String jobId = System.schedule('testBasicScheduledApex',
      TestScheduledApexFromTestMethod.CRON_EXP, 
         new TestScheduledApexFromTestMethod());
       ***************************/       
       Test.StopTest();
       
    }
}
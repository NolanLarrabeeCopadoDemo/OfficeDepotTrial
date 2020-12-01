/** 
    (c) Appirio
    Created:        6/8/2015  Ben Lorenz
    Purpose:        Apex unit tests for class accountProfileStagingEventHandler
**/

@isTest
private class accountProfileStagingEventHandlerTest {
  static testMethod void testaccountprofileupsert() {
    Account_Profile__c [] apLst;
    //create account
    Account a = new Account ();
    a.name = 'TAX CERT TST ACCT';
    a.AOPS_Seq_ID__c = '123666';
    a.AOPS_Cust_Id__c = '123666';
    a.Oracle_Party_Id__c = '123666';
    a.Billingcountry = 'USA';
    a.BillingState = 'UT';
    a.Duns_Enrichment__c = '12345';
    a.DNBI_CREDIT_OUTCOME__c = 'Approved';
    a.BillingStreet = '1040 N 326 W';
    a.billingcity = 'Orem';
    insert a;
    test.startTest();
    apLst = [SELECT Id FROM Account_Profile__c WHERE Account__c = :a.Id];
    system.assert(apLst.isEmpty()==true);
    //insert account profile staging for insert to account profile
    Account_Profile_Staging__c aps = new Account_Profile_Staging__c();
    aps.Expiration_Date__c= date.newinstance(2039, 12, 31);
    aps.Address_State__c='UT';
    aps.Country_Code__c='USA';
    aps.Tax_Status__c='A';
    aps.Customer_ID__c='123666';
    insert aps;
    //validate new Account Profile recored was inserted to Account
    apLst = [SELECT Id, LastModifiedDate,CreatedDate FROM Account_Profile__c WHERE Account__c = :a.Id];
    system.assert(apLst.size()==1);
    system.assert(apLst[0].LastModifiedDate==apLst[0].CreatedDate);
    //insert second account profile staging for upsert to account profile
    Account_Profile_Staging__c aps2 = new Account_Profile_Staging__c();
    aps2.Expiration_Date__c= date.newinstance(2039, 12, 31);
    aps2.Address_State__c='UT';
    aps2.Country_Code__c='USA';
    aps2.Tax_Status__c='B';
    aps2.Customer_ID__c='123666';
    insert aps2;
    //validate
    apLst = [SELECT Id,LastModifiedDate,CreatedDate,Tax_Status__c FROM Account_Profile__c WHERE Account__c = :a.Id];
    system.assert(apLst.size()==1);
    system.assert(apLst[0].Tax_Status__c=='B');
  }
}
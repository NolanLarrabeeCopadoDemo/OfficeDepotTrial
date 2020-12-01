@isTest
public class TC_BeforeAccountTrigger {
     public static testmethod void testBeforeAccountTrigger() {
        Dataloader_User__c dataloaderUser = new Dataloader_User__c(name='Dataloader',User_ID__c=UserInfo.getUserId().substring(0,15));
        insert dataloaderUser;
        
        Account acc1 = new Account ();
        acc1.name = 'SUN Test Account';
        acc1.BillingStreet = '1040 N 326 W';
        acc1.billingcity = 'Orem';
        acc1.BillingState = 'UT';
        acc1.Billingcountry = 'USA';
        acc1.Oracle_Party_Id__c = '1324567';
        acc1.AOPS_Cust_Id__c = '1324567';
        acc1.AOPS_Seq_ID__c = '1324567';
        acc1.OwnerID = '005E0000000lNbV';// This is the salesforce User ID
        acc1.RecordTypeId = System.Label.Customer;
        acc1.Split_Record__c = true;
        insert acc1; 
         
        Account acc2 = new Account ();
        acc2.name = 'SUN Test Account';
        acc2.BillingStreet = '1040 N 326 W';
        acc2.billingcity = 'Orem';
        acc2.BillingState = 'UT';
        acc2.Billingcountry = 'USA';
        acc2.Oracle_Party_Id__c = '123456';
        acc2.AOPS_Cust_Id__c = '123456';
        acc2.AOPS_Seq_ID__c = '123456';
        acc2.OwnerID = '005E0000000lNbV';// This is the salesforce User ID
        acc2.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();
        acc2.Related_Account__c = acc1.id;
        insert acc2;
        
        Account acc3 = new Account ();
        acc3.name = 'SUN Test Account';
        acc3.BillingStreet = '1040 N 326 W';
        acc3.billingcity = 'Orem';
        acc3.BillingState = 'UT';
        acc3.Billingcountry = 'USA';
        acc3.Oracle_Party_Id__c = '1234576';
        acc3.AOPS_Cust_Id__c = '1234576';
        acc3.AOPS_Seq_ID__c = '1234576';
        acc3.OwnerID = '005E0000000lNbV';// This is the salesforce User ID
        acc3.RecordTypeId = System.Label.Customer;
        acc3.Split_Record__c = true;
        insert acc3;
         
        Account acct = [SELECT Id, RecordTypeId,Related_Account__c FROM Account WHERE Id = :acc2.Id];
        // Switch to site OfficeMax
        acct.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site (OfficeMax)').getRecordTypeId();
        acct.Related_Account__c =  acc3.id;
        update acct;
     }

}
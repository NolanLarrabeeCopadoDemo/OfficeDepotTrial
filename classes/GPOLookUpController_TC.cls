@isTest
public class GPOLookUpController_TC {
    static testmethod void InsertRec(){	    
        Id GrandParent_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GrandParent').getRecordTypeId();
        Account acc = new Account ();
        acc.name = 'SUN Test Account';
        acc.BillingStreet = '1040 N 326 W';
        acc.billingcity = 'Orem';
        acc.BillingState = 'UT';
        acc.Billingcountry = 'USA';
        acc.Oracle_Party_Id__c = '123456';
        acc.AOPS_Cust_Id__c = '123456';
        acc.AOPS_Seq_ID__c = '123456';
        acc.OwnerID = '005E0000000lNbV';// This is the salesforce User ID
        acc.Sales_PersonID__c = 'a0AE0000000GGMn'; //Sales person Id for the Salesforce USer
        acc.RecordtypeId=GrandParent_RecordTypeId;
        acc.Current_GPO__c=true;
        insert acc;
        GPOLookUpController.fetchLookUpValues('SUN Test Account');
    }
    
}
@isTest
public class Pros_handler_TC {

    public testmethod static void Accountinsert(){
        Id Parent_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Parent').getRecordTypeId();
        Id Contact_RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact(US)').getRecordTypeId();
        Id SiteId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();
        Account Acc = new Account();
        Acc.Name='Test';
        Acc.Address1__c='New Testing';
        Acc.City__c='City Test';
        Acc.State__c='TMO';
        Acc.Country__c='USA';
        Acc.Zip__c='12321';
        Acc.RecordtypeId=Parent_RecordTypeId;
        Insert Acc;
        
        Account newSite = new Account();
        newSite.Name=Acc.Name;
        newSite.recordtypeId=SiteId;
        newsite.Related_Account__c=Acc.id;
        newSite.Sales_PersonID__c=Acc.Sales_PersonID__c;        
        newSite.Primary_Site__c = true;
        newSite.address1__C= Acc.Address1__c;
        newSite.Address2__c= Acc.Address2__c;
        newSite.city__c=Acc.City__c;
        newSite.state__c=Acc.State__c;
        newSite.zip__c=Acc.Zip__c;
        newSite.Country__c=Acc.Country__c;
        
        Insert newSite;
        
        Contact con = new contact();
        con.FirstName='Test';
        con.LastName='B';
        con.Phone='1232123211';
        con.Email='test@test.com';
        con.Primary_Contact__c=true;
        con.AccountId=Acc.id;
        insert con;
        
        Acc.ORACLE_PARTY_ID__c='121211112112';
        update Acc;
        
        
    }
}
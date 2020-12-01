@isTest 
public class LeaddealShareTest {
    static testMethod void leaddealTest() { 
        //Create Partner User 
        Profile p = [select Id, name from Profile where UserType = 'PowerPartner' limit 1];
        String userName = 'xyz@officedepot.com';
        String email = userName;
        String [] name = userName.split('@');
        
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs(thisUser) {
            Recordtype rtPartner = [Select id, Sobjecttype from recordtype where name = 'Partner' and Sobjecttype = 'Account'];
            Account acc = new Account(Name='Test Account');
            acc.RecordTypeId = rtPartner.Id; 
            insert acc; 
                
            Contact con = new Contact(LastName='userName', AccountId = acc.Id);
            insert con; 
            
            Contact con2 = new Contact(LastName='userName2', AccountId = acc.Id);
            insert con2; 
            
            User partnerUser = 
                new User(Username = userName, FirstName = name[1], LastName = name[0], Alias = name[0], CommunityNickname = userName, LocaleSidKey = 'en_US', EmailEncodingKey = 'UTF-8', Profileid = p.id, LanguageLocaleKey = 'en_US');
            partnerUser.email = email;
            partnerUser.ContactId = con.id;
            partnerUser.IsActive = true;
            partnerUser.TimeZoneSidKey = 'America/Los_Angeles';
            insert partnerUser;
            
            Id RTId = Schema.SobjectType.Lead.getRecordTypeInfosByName().get('Lead (Deals)').getRecordTypeId();            
            Lead newld = new Lead();
            newld.last_name__c = 'Test';
            newld.lastname = 'Test';
            newld.firstName = 'Test';
            newld.first_name__c = 'Test';
            newld.company = 'Test Company';
            newld.Status = 'New';
            newld.RecordTypeId = RTId;
            newld.Email = 'abc@gmail.com';
            system.debug('account id is ' + acc.Id); 
            newld.Sub_Agent__c = acc.Id; 
            newld.Partner_Sub_Agent_Contact__c = con2.id;
            system.debug('newld'+newld);
            insert newld;
            system.debug('newld' + newld);
            newld.Partner_Sub_Agent_Contact__c = con.id;
            update newld;
        }        
    }
}
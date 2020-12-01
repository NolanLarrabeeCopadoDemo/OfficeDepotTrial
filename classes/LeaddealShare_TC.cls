@istest
public class LeaddealShare_TC {
    static testMethod void leaddealTest() {
        List < user > users = new list < user > ();
        List < Account > accounts = new list < Account > ();
        List < Contact > contacts = new list < Contact > ();
        UserRole userRole_1 = [SELECT Id FROM UserRole WHERE DeveloperName = 'support' LIMIT 1];
        Profile profileObj = [select id from profile where name = 'System Administrator'];
        String prflId = profileObj.id;
        Id RTId = Schema.SobjectType.Lead.getRecordTypeInfosByName().get('Lead (Deals)').getRecordTypeId();
        string userName = 'abcd@officedepot.com';
        string email = userName;
        string[] name = userName.split('@');
        user u1 = new user(Username = userName, FirstName = name[1], LastName = name[0], Alias = name[0], CommunityNickname = userName, LocaleSidKey = 'en_US', EmailEncodingKey = 'UTF-8', Profileid = prflId, LanguageLocaleKey = 'en_US');
        u1.email = email;
        u1.UserRoleId = userRole_1.id;
        u1.IsActive = true;
        insert u1;
        System.runAs(u1) {
            Recordtype rtPartner = [Select id, Sobjecttype from recordtype where name = 'Partner' and Sobjecttype = 'Account'];
            Account acc = new Account();
            acc.name = 'Test Company';
            acc.OMX_Primary_Key__c = '123456';
            acc.Oracle_Party_Id__c = '123456';
            acc.AOPS_Cust_Id__c = '123456';
            acc.AOPS_Seq_ID__c = '123456';
            acc.OwnerID = u1.id;
            acc.Address1__c = 'address';
            acc.RecordTypeid = rtPartner.id;
            //insert acc1;
            accounts.add(acc);
            insert accounts;
            Contact con1 = new Contact();
            con1.LastName = 'Test1';
            con1.Decision_Maker__c = 'No';
            con1.AccountId = acc.id;
            insert con1;
            system.debug('con1'+con1);
            Profile p = [select Id, name from Profile where UserType = 'PowerPartner' limit 1];
            userName = 'xyz@officedepot.com';
            email = userName;
            name = userName.split('@');
            user u = new user(Username = userName, FirstName = name[1], LastName = name[0], Alias = name[0], CommunityNickname = userName, LocaleSidKey = 'en_US', EmailEncodingKey = 'UTF-8', Profileid = p.id, LanguageLocaleKey = 'en_US');
            u.email = email;
            u.ContactId = con1.id;
            u.IsActive = true;
            u.TimeZoneSidKey = 'America/Los_Angeles';
            u.Token_Market_Builder__c = 'pqr';
            users.add(u);
            insert users;
            Lead newld = new Lead();
            newld.last_name__c = 'Test';
            newld.lastname = 'Test';
            newld.firstName = 'Test';
            newld.first_name__c = 'Test';
            newld.company = 'Test Company';
            newld.Status = 'New';
            newld.RecordTypeId = RTId;
            newld.OwnerId = userinfo.getUserId();
            newld.Email = 'abc@gmail.com';
            newld.Sub_Agent__c = con1.AccountId;
            newld.Partner_Sub_Agent_Contact__c = con1.id;
            //leads.add(newld);
            system.debug('newld'+newld);
            insert newld;
            system.debug('newld'+newld);
            newld.Partner_Sub_Agent_Contact__c = con1.id;
            update newld;
        }
    }
}
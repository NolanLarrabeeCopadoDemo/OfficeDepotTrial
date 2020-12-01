@isTest
public class EnablePartnerUser_Test {
    @isTest static void method1() {
        Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        UserRole r = new UserRole(name = 'TEST ROLE');
        insert r;
        User sysAdmin = new User(Alias = 'sysAdmin', 
            Email = 'sysAdmin@officedepot.com',
            EmailEncodingKey = 'UTF-8', LastName = 'Testing', 
            LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', 
            ProfileId = sysAdminProfile.Id, userroleid = r.Id,
            TimeZoneSidKey = 'America/Los_Angeles', 
            UserName = 'sysAdmin@officedepot.com');
        insert sysAdmin;
       

        
        System.runAs(sysAdmin) {
            Account account1 = new Account(Name = 'testName');
            insert account1;

            Contact contact1 = new Contact(
            FirstName = 'contactFirst', LastName = 'contactLast', 
            Email = 'contact1@test.com', AccountId = account1.id);
            insert contact1;
            
           // Profile partnerProfile = new Profile();

            String selectedRole = 'User';
            String role = contact1.Account.Name + ' ' + 'Partner' + ' ' + selectedRole;
            UserRole partnerRole = new UserRole(Name = role);
            insert partnerRole;

            Test.startTest();
           // EnablePartnerUserController tester = new EnablePartnerUserController();
            EnablePartnerUserController.getContact(contact1.Id);
            EnablePartnerUserController.checkUserExists(contact1.Id);
            try {
                EnablePartnerUserController.createUser(contact1, selectedRole);
            }
            catch(Exception e) {
                system.debug('in catch');
            }
            
            Test.stopTest();
        }

    }

    
}
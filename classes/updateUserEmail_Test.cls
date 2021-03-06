@isTest
Private class updateUserEmail_Test {
    
    static testMethod void updateUserEmail_method() {
       UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
				system.debug('portalRole is ' + portalRole);

                Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
                User portalAccountOwner1 = new User(
                UserRoleId = portalRole.Id,
                ProfileId = profile1.Id,
                Username = System.now().millisecond() + 'test2@test.com',
                Alias = 'catman',
                Email='bruce.wayne@officedepot.com',
                EmailEncodingKey='UTF-8',
                Firstname='Salman',
                Lastname='Khan',
                LanguageLocaleKey='en_US',
                LocaleSidKey='en_US',
                TimeZoneSidKey='America/Chicago'
                );
                Database.insert(portalAccountOwner1);
                
                //User u1 = [Select ID From User Where Id =: portalAccountOwner1.Id];
                
                System.runAs ( portalAccountOwner1 ) {
                //Create account
                Account portalAccount1 = new Account(
                Name = 'TestAccount',
                OwnerId = portalAccountOwner1.Id
                );
                Database.insert(portalAccount1);
                
                //Create contact
                Contact contact1 = new Contact(
                FirstName = 'Test',
                Lastname = 'McTesty',
                AccountId = portalAccount1.Id,
                Email = System.now().millisecond() + 'test@officedepot.com'
                );
                Database.insert(contact1);
                
                //Create user
               Profile portalProfile = [select id from profile where name = :Label.Partner_Community_User_Custom limit 1];
                User user1 = new User(
                Username = System.now().millisecond() + 'test12345@test.com',
                ContactId = contact1.Id,
                ProfileId = portalProfile.Id,
                Alias = 'fdaffa',
                Email = 'test12345@officedepot.com',
                EmailEncodingKey = 'UTF-8',
                LastName = 'RajuChacha',
                CommunityNickname = 'kumarprab',
                TimeZoneSidKey = 'America/Los_Angeles',
                LocaleSidKey = 'en_US',
                LanguageLocaleKey = 'en_US'
                );
                Database.insert(user1);
                     list<id> userid = new list<id>();
        userid.add(user1.id);
        updateUserEmail.updateEmail(userid);
                }
                

 

 
        
       
        
    }
    
    

}
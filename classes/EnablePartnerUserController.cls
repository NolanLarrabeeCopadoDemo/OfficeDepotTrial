public without sharing class EnablePartnerUserController {
    
    @AuraEnabled
    public static Contact getContact(Id contactId) {
        Contact contact = [SELECT Id, Name, AccountId, Account.Name, email, FirstName, LastName FROM Contact WHERE Id = :contactId];
        system.debug('CAM Enabling Partner User: contactId = ' + contactId);
        return contact;
    }
    
    @AuraEnabled
    public static Boolean checkUserExists(Id checkContactId) {
        system.debug('--> what is there is checkcontactid'+checkContactId);
      	Boolean userExists = false;
      	List<User> users = [SELECT id FROM User WHERE ContactId = :checkContactId AND isActive = TRUE LIMIT 1];
        system.debug('-->List of results when queried with contact id on users'+users);
        if (users.size() != 0) {
            userExists = true;
        }
        return userExists;
    }
    
    @AuraEnabled
    public static void createUser(Contact contact, String selectedRole) {
        User user = createNewUser(contact, selectedRole);
    }
    
    private static User createNewUser(Contact contact, String selectedRole) {
        Profile profile = [SELECT id, Name FROM Profile WHERE Name =: System.Label.Partner_Community_User_Custom];
        Userrole userRole = new Userrole();
        String role = contact.Account.Name +' '+'Partner'+' '+selectedRole;
        // Get the userRole record for this Account
    	try {
        	userRole = [SELECT id, Name FROM Userrole WHERE Name =: role LIMIT 1];
            system.debug('--> userrole id is:'+userRole);
        } catch(QueryException e) {
            throw new AuraHandledException('USER ROLE NOT FOUND - ' + e.getMessage() ); 
        }    
        try {
            // Check to see if an inactive User exists, if true, make them active again and give them the selected role
            List<User> createdUsers = [SELECT id FROM User WHERE email = :contact.email AND isActive = FALSE LIMIT 1];
            system.debug('--> createdusers is'+createdUsers);
            if (createdUsers.size() != 0) {
                system.debug('--> am i here?');
                createdUsers[0].isActive = TRUE;
                createdUsers[0].UserRoleid = userRole.id;
                update createdUsers[0];
                return createdUsers[0];
            }
            else {    // Create a new User record
                User user = new User();
                user.FirstName = contact.FirstName;
                user.LastName = contact.LastName;
                user.Email = contact.Email;
                user.Alias = contact.FirstName.substring(1,2) + contact.LastName.substring(0,3);
                user.ContactId = contact.id;
                user.Phone = contact.Phone;
                user.Username = contact.Email;
                user.ProfileId = profile.Id; 
                user.UserRoleid = userRole.id;
                user.EmailEncodingKey = 'UTF-8';
                user.TimeZoneSidKey = 'America/New_York';
                user.LocaleSidKey = 'en_US';
                user.LanguageLocaleKey = 'en_US';
                insert user;
                return user;
            }
    	} 
        catch(Exception ex) {
        	throw new AuraHandledException(ex.getMessage());  
        }
    }
}
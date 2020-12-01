public class UserExtension {
    public List<User_Staging__c> usersWhoShouldBeInactive{get;set;}
    public Integer count{get;set;}
    
    public UserExtension(ApexPages.StandardController controller) { 
        // Get active users
        Map<string, User> activeUsers = new Map<string, User>();
        //added to filter users with salesforce license by rohini
          Map<Id,Profile> profileIds = new Map<id,profile>([SELECT Id,UserLicenseId FROM Profile where UserLicenseId  in (SELECT Id FROM UserLicense where name ='Salesforce')]);
        for (User u : [SELECT Id, OD_Employee_ID__c, ProfileId, IsActive FROM User WHERE IsActive = true and profileId in:profileIds.Keyset()]) {
            activeUsers.put(u.OD_Employee_ID__c , u);
        }
        
        // Get users who should be inactive and compare
        usersWhoShouldBeInactive = new List<User_Staging__c>();
        
        List<String> chatterProfiles = new List<String>();
        for (Profile chatterP : [SELECT Id FROM Profile WHERE Name = 'Chatter Free User' OR Name = 'Chatter Only User']) {
            chatterProfiles.add(chatterP.Id);
        }
        Set<String> chatterProfilesSet = new Set<String>(chatterProfiles);
        
        for (User_Staging__c us : [SELECT Id, Name, Last_Name__c, OD_Employee_Number__c, TermDate__c, IsActive__c, ProfileId__c, Title__c
                                   FROM User_Staging__c 
                                   WHERE (IsActive__c = false
                                   OR ProfileId__c IN :chatterProfiles
                                   OR ProfileId__c = '')
                                   AND (NOT TITLE__C LIKE '%CWR%')
                                   ORDER BY TermDate__c]) {
            User u = activeUsers.get(us.OD_Employee_Number__c);
            
            if (u != null) {
                Boolean activeShouldBeInactive = (!us.IsActive__c) && u.IsActive;
                Boolean shouldBeChatter = (chatterProfilesSet.contains(us.ProfileId__c) || us.ProfileId__c == null || us.ProfileId__c == '') 
                    && (!chatterProfilesSet.contains(u.ProfileId));
                
                if (activeShouldBeInactive || shouldBeChatter) {
                    // User is active
                    usersWhoShouldBeInactive.add(us);
                }
            }
            
            count = usersWhoShouldBeInactive.size();
        }
    }
    
    @RemoteAction
    public static String deactivateUsers(String OdpIdsToDeactivateStr) {
        System.debug('-------------------> ODP IDs: ' + OdpIdsToDeactivateStr);
        String errors = '';
        
        if (!String.isEmpty(OdpIdsToDeactivateStr)) {
            String[] OdpIdsToDeactivate = OdpIdsToDeactivateStr.split(';');        
            List<User> usersToDeactivate = [SELECT Name, OD_Employee_Id__c, isActive, FederationIdentifier, Username, Email
                                            FROM User 
                                            WHERE OD_Employee_ID__c IN :OdpIdsToDeactivate];
            
            for (User u : usersToDeactivate) {
                u.isActive = false;
                u.OD_Employee_Id__c = 'zzz' + u.OD_Employee_Id__c;
                u.FederationIdentifier = 'zzz' + u.FederationIdentifier;
                u.Username = 'zzz' + u.Username;
                u.Email = 'zzz' + u.Email;
            }
            
            // Update and get errors, if any
            Database.SaveResult[] lsr = Database.update(usersToDeactivate, false);
            Map<Id, String> errorMsgs = new Map<Id, String>();
            
            for (Integer i = 0; i < usersToDeactivate.size(); i++) {
                Database.SaveResult sr = lsr[i];
                System.debug('-------------------> Number of errors: ' + sr.getErrors().size());
                
                for (Database.Error err : sr.getErrors()) {
                    User u = usersToDeactivate[i];
                    
                    errors += '\nName: ' + u.Name 
                            + '\nODP ID: ' + u.OD_Employee_Id__c 
                            + '\nError: ' + err.getMessage()
                            + '\n------------------------------------------';
                }
            }

            if (errors != '') { 
                errors = 'Errors encountered:\n' + errors;
            }
        }
        
        return errors;
    }   
}
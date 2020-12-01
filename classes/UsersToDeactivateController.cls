public class UsersToDeactivateController {
    private static final integer MAX_FUTURE_CALLS = 50;

    public List<UserWrapper> chatterToDeactivate{get;set;}
    public List<UserWrapper> usersToDeactivate{get;set;}
    public Integer chatterCount{get;set;}
    public Integer userCount{get;set;}
    
    public UsersToDeactivateController() { 
        populateLists();
    }
    
    private void populateLists() {
        // Get active users
        Map<string, User> activeUsers = new Map<string, User>();
        // Get chatter profiles
        Set<String> chatterProfiles = new Set<String>();
        
        for (Profile chatterP : [SELECT Id FROM Profile WHERE Name LIKE 'Chatter%']) {
            chatterProfiles.add(chatterP.Id);
        }
        
        List<String> currentUsers= new List<String>();
        
        
           for (User_Staging__c us : [SELECT TermDate__c, IsActive__c, ProfileId__c, OD_Employee_Number__c, Title__c
                                   FROM User_Staging__c 
                                   WHERE (IsActive__c = false
                                   OR ProfileId__c IN :chatterProfiles
                                   OR ProfileId__c = '')
                                   AND (NOT TITLE__C LIKE '%CWR%')
                                   ORDER BY TermDate__c, Title__c]) {
            currentUsers.add(us.OD_Employee_Number__c);
            }

        
        for (User u : [SELECT Id, OD_Employee_ID__c, ProfileId, IsActive, FederationIdentifier, Username, Email, Name,
                       Title, Deactivation_Error__c 
                       FROM User 
                       WHERE IsActive = true and   OD_Employee_ID__c in  :currentUsers ]) {
            activeUsers.put(u.OD_Employee_ID__c , u);
        }
        
        
        
        // Get terminated users and compare
        chatterToDeactivate = new List<UserWrapper>();
        usersToDeactivate = new List<UserWrapper>();
        
        for (User_Staging__c us : [SELECT TermDate__c, IsActive__c, ProfileId__c, OD_Employee_Number__c, Title__c
                                   FROM User_Staging__c 
                                   WHERE (IsActive__c = false
                                   OR ProfileId__c IN :chatterProfiles
                                   OR ProfileId__c = '')
                                   AND (NOT TITLE__C LIKE '%CWR%')
                                   ORDER BY TermDate__c, Title__c]) {
            User u = activeUsers.get(us.OD_Employee_Number__c);
            
            if (u != null) {
                Boolean shouldBeInactive = u.IsActive && (!us.IsActive__c); 
                Boolean shouldBeChatter = (chatterProfiles.contains(us.ProfileId__c) || us.ProfileId__c == null || us.ProfileId__c == '') 
                    && (!chatterProfiles.contains(u.ProfileId));
                
                UserWrapper wrapper = new UserWrapper(u, us);
               
                if (shouldBeInactive ) {
                    usersToDeactivate.add(wrapper);
                }
                else if (shouldBeChatter) {
                    chatterToDeactivate.add(wrapper);
                }
            }
            
            // Get counts
            chatterCount = chatterToDeactivate.size();
            userCount = usersToDeactivate.size();
        }
    }
    
    public void deactivateUsers() {
        // Get selected users
        List<User> selectedUsers = new List<User>();
        
        for (UserWrapper wrapper : usersToDeactivate) {
            if (wrapper.selected == true) {
                selectedUsers.add(wrapper.u);
            }
        }
        
        for (UserWrapper wrapper : chatterToDeactivate) {
            if (wrapper.selected == true) {
                selectedUsers.add(wrapper.u);
            }
        }
        
        // Only process number of permitted future calls
        if (selectedUsers.size() > MAX_FUTURE_CALLS) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Please, select no more than ' + MAX_FUTURE_CALLS + ' users to deactivate at once.'));
            return;
        }
        
        // Deactivate users    
        if (selectedUsers.size() > 0) {
            // Deactivate the users         
            for (User u : selectedUsers) {
                UserManagement.deactivate(u.Id);
                u.Deactivation_Error__c = 'Processing';
            }
            
            update selectedUsers;
            
        }
          
        populateLists();
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Your deactivations are being processed. Please, check back later.'));        
    }
    
    public class UserWrapper {
        public User u {get; set;}
        public User_Staging__c us  {get; set;}
        public boolean selected {get; set;}
        
        public UserWrapper(User u, User_Staging__c us) {
            this.u = u;
            this.us = us;
            this.selected = false;
        }
    }
}
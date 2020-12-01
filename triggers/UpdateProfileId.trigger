trigger UpdateProfileId on User_Setting__c (before insert, before update) {
    Map<String, String> existingUserSettings = new Map<String, String>();
    
    for (User_Setting__c userSetting : [SELECT Id, Name FROM User_Setting__c]) {
        String idStr = '' + userSetting.Id;
        existingUserSettings.put(userSetting.Name.toUpperCase(), idStr.substring(0, 15));
    }

    List<String> profilenames = new List<String>();
    List<String> employeeIds = new List<String>();
    
    for (User_Setting__c usr : Trigger.New) {
        // Reject duplicate user settings
        String currentName = usr.Name.toUpperCase();
        boolean nameExists = existingUserSettings.get(currentName) != null;
        String idStr = '' + usr.Id;
        boolean differentId = true;
        
        if (Trigger.IsUpdate) {
            differentId = idStr.substring(0, 15) != existingUserSettings.get(currentName);
        }
        
        if (nameExists && differentId) {
            usr.addError('Trying to insert duplicate User Setting');
        }
        else {
            profilenames.add(usr.Profile_Name__c);
            employeeIds.add(usr.Name);
        }
    }
    
    List<Profile> profiles = [Select Id, name from Profile where name in :profilenames];
    List<User> users = [SELECT Id, FirstName, LastName, OD_Employee_ID__c FROM User WHERE OD_Employee_ID__c IN :employeeIds];
    
    for (User_Setting__c usr : Trigger.New) {
        for (integer i = 0; i < profiles.size(); i++) {
            if ( usr.Profile_Name__c == profiles[i].name) {
                usr.Profile_Id__c = profiles[i].Id;
            }
        }
        
        // Link user
        usr.User__c = null;
        for (User u : users) {
            if (u.OD_Employee_ID__c == usr.Name) {
                usr.User__c = u.Id;
                break;
            }
        }
    } 
}
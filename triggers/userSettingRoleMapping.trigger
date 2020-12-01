trigger userSettingRoleMapping on User_Staging__c (before insert, before update) {
    final static integer JOB_CODE_LENGTH = 13;

    Map<String,Schema.SObjectField> UserStagingFieldsMap = Schema.getGlobalDescribe().get('User_Staging__c').getDescribe().fields.getMap();
    List<String> UserStagingFields = new List<String>(UserStagingFieldsMap.keySet());
    
    system.debug('UserStagingFields@@@@#### ' + UserStagingFields);

    for (User_Staging__c stagingObj : Trigger.new) { 
        // Replacing #N/A with blank - checking all fields
        for (String field : UserStagingFields) {
            SObjectField UserStagingField = UserStagingFieldsMap.get(field);
            
            System.Debug(UserStagingField);
            System.Debug(stagingObj.get(UserStagingField));

            try {
                if ((stagingObj.get(UserStagingField) != null)&&(stagingObj.get(UserStagingField) == '#N/A')) {
                    stagingObj.put(UserStagingField, '');
                }
            }
            catch (Exception e) {
                stagingObj.put(UserStagingField, '');
            }

            // Making Field with 6-digit format
            if (((field == 'Manager_Employee_Number__c') || (field == 'OD_Employee_Number__c') || (field == 'Federation_Identifier__c')) 
                    && ((stagingObj.get(UserStagingField) != null) && (stagingObj.get(UserStagingField) != ''))) {
                stagingObj.put(UserStagingField, FormatString.preZeroFormat((String)stagingObj.get(UserStagingField), 6));
            }
        }

        Date currdate = System.today();
        if (stagingObj.TermDate__c  < currdate) {
            stagingObj.IsActive__c = false;
            stagingObj.Reassgin_Opportunity__c = true;
        }
    }     

    System.debug('&&&&&&&&TriggerNew' + Trigger.new);

    // Find user setting based on ID or title of user staging
    Map<String, User_Setting__c> titleToUserSetMap = new Map<String, User_Setting__c>();
    
    for (User_Setting__c userSet : [SELECT Title_Code__c, Id FROM User_Setting__c]) {
        titleToUserSetMap.put(userSet.Title_Code__c, userSet);
    }
    
    System.debug('titleToUserSetMap.keySet().size() : ' + titleToUserSetMap.keySet().size());

    for (User_Staging__c userStaging : Trigger.new) {  
        
        // Check that it's a valid title
        if (userStaging.Title__c.length() >= JOB_CODE_LENGTH) {
            System.debug('userStaging.OD_Employee_Number__c : ' + userStaging.OD_Employee_Number__c);
            String jobCode = userStaging.Title__c.substring(0, JOB_CODE_LENGTH);
            System.debug('userStaging.Title__c.substring(0, JOB_CODE_LENGTH) : ' + jobCode);
            
            // Try to get user setting ID from employee number
            User_Setting__c userSettingMatch = titleToUserSetMap.get(userStaging.OD_Employee_Number__c); 
            System.debug('userSettingMatch_1 : ' + userSettingMatch);
            
            // If no user setting found, try to get one by title
            if (userSettingMatch == null) {
                userSettingMatch = titleToUserSetMap.get(jobCode);
                System.debug('userSettingMatch_2 : ' + userSettingMatch);
            }
            if (userSettingMatch == null) {
                userSettingMatch = titleToUserSetMap.get(jobCode.toUpperCase());
                System.debug('userSettingMatch_3 : ' + userSettingMatch);
            }
    
            if (userSettingMatch != null) {
                userStaging.User_Setting__c = userSettingMatch.Id;
            }
        }
    }     

    System.debug('&&&&&&&&TriggerNewUserSetting' + Trigger.new);
}
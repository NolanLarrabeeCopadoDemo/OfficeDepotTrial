/**
 * Based on the User Settings, updates Users with the proper Job Code Levels.
 */
global class User_Job_Code_Level_Batch implements Database.Batchable<SObject>, Database.Stateful, Schedulable {

    // Key: Title Code, Value: Job Code Level.
    global Map<String, String> jobCodeMapping = new Map<String, String>();
    private String query;

    global User_Job_Code_Level_Batch() {
        setJobCodeMapping();
        query = 'SELECT Id, Title, Job_Code_Level__c FROM User WHERE IsActive = true AND Title != null';
    }

    global User_Job_Code_Level_Batch(String query) {
        setJobCodeMapping();
        this.query = query;
    }

    /**
     * Populates the jobCodeMapping variable using the User Settings.
     * This variable contains of mapping of title codes (i.e. USBSD:123456:, etc.)
     * to job code levels (i.e. Manager, etc.). It is populated once but used in
     * each of the batches.
     */
    private void setJobCodeMapping() {
        List<User_Setting__c> userSettings = [
                SELECT Id, Name, Job_Code_Level__c
                FROM User_Setting__c
                WHERE Name != null AND Job_Code_Level__c != null
            ];
        for(User_Setting__c userSetting : userSettings) {
            jobCodeMapping.put(userSetting.Name, userSetting.Job_Code_Level__c);
        }
    }

    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(this.query);
    }

    /**
     * Goes through each User in the batch and updates the Job Code Level if necessary.
     */
    global void execute(Database.BatchableContext bc, List<SObject> scope) {
        List<User> usrs = scope;
        
        List<User> usersToUpdate = new List<User>();
        for(User usr : usrs) {
            String titleCode = usr.Title.length() >= 13 ? usr.Title.substring(0, 13) : null;
            String jobCodeLevelFromUserSetting = jobCodeMapping.get(titleCode);

            // We only update the Job Code Level on the User if the Title Code exists in the User Settings
            // and the corresponding Job Code Level is different than the one currently on the User.
            if(jobCodeLevelFromUserSetting != null && usr.Job_Code_Level__c != jobCodeLevelFromUserSetting) {
                usr.Job_Code_Level__c = jobCodeLevelFromUserSetting;
                usersToUpdate.add(usr);
            }
        }

        update usersToUpdate;
    }

    global void finish(Database.BatchableContext bc) {}

    /**
     * This function is called to run the job when it is put on a schedule.
     */
    global void execute(SchedulableContext sc) {
        Database.executeBatch(new User_Job_Code_Level_Batch(), 2000);
    }
}
/* This trigger is for the custom messaging feature for Communities v2. 
// Each GPO Group object is allowed one custom message in the form of the GPO_Group_Detail__c object. 
// Trigger enforces one custom message per GPO Group. 
// The Default Group is excluded from this logic. 
*/
trigger customMessageTrigger on GPO_Group_Detail__c (before Insert) {
    List<GPO_Group_Detail__c> otherMessages = new List<GPO_Group_Detail__c>();
    GPO_Group__c defaultGroup = [SELECT id FROM GPO_Group__c WHERE Community_Name__c = 'Default Group'];

    if (Trigger.isInsert) {
        for (GPO_Group_Detail__c detail : Trigger.new) {
            if (detail.GPO_Group__c != defaultGroup.id) { //Checks to see if the trigger is being called on a detail of the Default Group, which is excluded. 
                otherMessages = [SELECT id, Name FROM GPO_Group_Detail__c WHERE GPO_Group__c =: detail.GPO_Group__c AND Type__c = 'Greeting Message'];
                if (!otherMessages.isEmpty()) {
                    detail.addError('A Custom Greeting Message for this group already exists');
                }
            }
        }
    }
}
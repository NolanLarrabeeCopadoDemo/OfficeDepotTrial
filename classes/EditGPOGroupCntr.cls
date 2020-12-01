/* Communities v2.1a - Controller extension for EditGPOGroup page */

public class EditGPOGroupCntr {
    public GPO_Group__c selectedGroup {get;set;}
    private gpo_group__c selectedGroup2 {get;set;}
    public GPO_Group__c defaultGroup {get;set;}
    public GPO_Group_Detail__c[] messages {get;set;}
    public GPO_Group_Detail__c[] customMessage {get;set;}
    public String currentGroupId {get;set;}
    public String selected {get;set;}
    public GPO_Group_Detail__c selectedMessage {get;set;}
    public Id messageId ;
    
    public EditGPOGroupCntr(ApexPages.StandardController stdController) {
        //The default messages are pulled from the Default Group and are shared with all gpo groups. 
        defaultGroup = [SELECT id FROM GPO_Group__c WHERE Community_Name__c = 'Default Group'];
        messages = [SELECT id, Type__c, Greeting_Message__c,Name FROM GPO_Group_Detail__c WHERE GPO_Group__c =: defaultGroup.id AND Type__c = 'Greeting Message' ORDER BY Createddate];
        
        // Fix: Current group needs to be pulled like this
        selectedGroup = (GPO_Group__c)stdController.getRecord();
        currentGroupId = selectedGroup.Id;
        selectedGroup2 = [SELECT id, selected_message__c,Welcome_Message__c FROM GPO_Group__c WHERE id =: currentGroupId];
        
        
        if (selectedGroup2.id != defaultGroup.Id){
            customMessage = [SELECT id, Type__c, Greeting_Message__c,Name FROM GPO_Group_Detail__c WHERE GPO_Group__c =: selectedGroup2.id AND Type__c = 'Greeting Message' ORDER BY Createddate];
        }
        
        if (selectedGroup2.selected_message__c == null) { //If the message contents is blank, then show standard message 1. 
            selectedMessage = [SELECT Greeting_Message__c FROM GPO_Group_Detail__c WHERE GPO_Group__c =: defaultGroup.id AND Name =: 'Standard Message 1' LIMIT 1];
        } else {
            selectedMessage = [SELECT id, Greeting_Message__c FROM GPO_Group_Detail__c WHERE id =: selectedGroup2.selected_message__c];
        }
        selected = selectedMessage.Greeting_Message__c;
    }
    
    // Default Messages and Custom Message get added to picklist on page 
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        for(GPO_Group_Detail__c theMessage : messages) {
            if(theMessage.Greeting_Message__c != null) {
                options.add(new SelectOption(theMessage.id,theMessage.Name));
            }
        }
        if (selectedGroup2.id != defaultGroup.Id){
            for(GPO_Group_Detail__c newMessage: customMessage) {
                if (newMessage.Greeting_Message__c != null) {
                    options.add(new SelectOption(newMessage.id,'Custom Greeting Message'));
                }
            }
        }
        return options;
    }
    //picklist get and set methods. 
    public String getmessageId() {
        messageId = selectedMessage.id;
        return messageId;
    }
    public void setmessageId(id messageId) {
        if (messageId != null) {
             this.messageId = messageId;
             selectedGroup.selected_message__c = messageId;
             selectedMessage = [SELECT Greeting_Message__c FROM GPO_Group_Detail__c WHERE id =: selectedGroup.selected_message__c];
             selected = selectedMessage.Greeting_Message__c;
        }
    }
}
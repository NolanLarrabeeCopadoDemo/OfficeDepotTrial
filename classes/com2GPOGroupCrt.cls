/* Communities v2 - Controller for Create_GPO_Group.page */
/* TODO: Needs a test class */
public class com2GPOGroupCrt {
    public GPO_Group__c newGPO {get;set;}
    public GPO_Group__c defaultGroup {get;set;}
    public GPO_Group_Detail__c[] messages {get;set;} //Object used for greeting messages
    public Id messageId ;
    public String selected {get;set;}
    public GPO_Group_Detail__c selectedMessage {get;set;} 
    public GPO_Group_Detail__c defaultMessage {get;set;}
    public String currentGroupId {get;set;}
    
    public com2GPOGroupCrt(ApexPages.StandardController stdController) {
        newGPO = new GPO_Group__c();
        newGPO.hideSections__c = 'Important Downloads;	Request an Account';
        newGPO.hideSectionsPost__c = 'Important Downloads;	Request an Account';
        
        defaultGroup = [SELECT id FROM GPO_Group__c WHERE Community_Name__c = 'Default Group'];
        defaultMessage = [SELECT id, Greeting_Message__c, Name FROM GPO_Group_Detail__c WHERE GPO_Group__c =: defaultGroup.id AND Name = 'Standard Message 1'];
        newGPO.selected_message__c = defaultMessage.id;
        messages = [SELECT id, Type__c, Greeting_Message__c,Name FROM GPO_Group_Detail__c WHERE GPO_Group__c =: defaultGroup.id AND Type__c = 'Greeting Message' ORDER BY CreatedDate];
        currentGroupId = newGPO.Id;
        selectedMessage = [SELECT id, Greeting_Message__c FROM GPO_Group_Detail__c WHERE id =: newGPO.selected_message__c];
        selected = selectedMessage.Greeting_Message__c;
    }
    
    public PageReference Save() {
        try{
            insert newGPO;
        } catch(System.dmlException e) {
            return null;
        }  
        return new PageReference('/'+ newGPO.Id);
    }
    
    public PageReference Cancel() {
        return new PageReference('/a4X'); // The keyPrefix URL for the Communities Tab Page 
    }
    
    // Custom Greeting Message Selection Stuff:
    // Custom Message will be added to picklist through here 
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        for(GPO_Group_Detail__c theMessage : messages) {
            if(theMessage.Greeting_Message__c != null) {
                options.add(new SelectOption(theMessage.id,theMessage.Name));
            }
        }
        return options;
    }
    
    public String getmessageId() {
        messageId = selectedMessage.id;
        return messageId;
    }
    
    public void setmessageId(id messageId) {
        if (messageId != null) {
             this.messageId = messageId;
             newGPO.selected_message__c = messageId;
             selectedMessage = [SELECT Greeting_Message__c FROM GPO_Group_Detail__c WHERE id =: messageId];
             selected = selectedMessage.Greeting_Message__c;
        }
    }
}
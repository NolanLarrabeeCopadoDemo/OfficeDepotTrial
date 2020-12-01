trigger gpoTrigger on GPO_Group__c (before Insert,after Insert,after update) {

    if (Trigger.isBefore) {
        list<ID> accIDs = new list<ID>();
        Map<ID,Boolean> accExistMap = new Map<ID,Boolean>();
        for (gpo_group__c g:Trigger.new) {
            if (g.account__c != null)
                accIDs.add(g.account__c);
        }
        
        for (gpo_group__c g: [select id,account__c from gpo_group__C where account__c = :accIDs])
          accExistMap.put(g.account__c,true);
          
        for (gpo_group__C g: Trigger.new) {
          if (accExistMap.containsKey(g.account__c))
             g.addError('Duplicate Community. A Community has already been set up for this Account');
        }
   }

    if (Trigger.isAfter && Trigger.isInsert) {   
        GPO_Community_Setup__c commSetup = gpo_community_setup__c.getValues('com2Settings');
        Gpo_Group__c defaultTemplateGroup = [SELECT id,Community_Image__c, Welcome_Message__c, Welcome_Title__c,Community_Name__c from GPO_Group__c where Community_Name__c = 'Default Group' LIMIT 1];
        List<GPO_Group__c> gUpd = new List<GPO_Group__c>();
        Map<id,Attachment> aMap = new Map<id,Attachment>();
        Attachment templateImage;
        if (defaultTemplateGroup.Community_Image__c != null) {
            templateImage = [Select id, name, body from Attachment where id =: defaultTemplateGroup.Community_Image__c];
        }
          
        For (gpo_group__c g: Trigger.new) {
            if (templateImage != null) {
                Attachment newImage = new Attachment();        
                newImage.name = templateImage.Name;
                newImage.body = templateImage.Body;
                newImage.parentId = g.id;
                aMap.put(g.id,newImage);
            }
        } 
        insert aMap.values();

        for (GPO_group__c g:Trigger.new) {
            GPO_Group__c gU = new GPO_Group__c(ID = G.ID);
            if (aMap.size() > 0) {
                gU.community_image__C = aMap.get(g.id).id;
            }
       //     gU.Member_Page_View__c = commSetup.signin_link__c + 'GPOMember?gpoGroupid='+g.id;
            gUpd.add(gU);
        }
        
        Update gUpd;
        
    }
    
    if (Trigger.isAfter && Trigger.isUpdate) { 
        set<ID> groupSet = new Set<ID>();
        For (gpo_group__c g:Trigger.new) {
            if (g.Activated__c != Trigger.oldMap.get(g.id).Activated__c) {
                groupSet.add(g.id);
            }
        }
         
        if(groupSet.size() > 0){
            List<Contact> accountContacts = [Select id, GPO_Community__c,AccountID FROM Contact WHERE AccountID =: groupSet];
            For (Contact aContact: accountContacts){
                aContact.GPO_Community__c = aContact.AccountID;
            }
            update accountContacts;
         }
    }    
}
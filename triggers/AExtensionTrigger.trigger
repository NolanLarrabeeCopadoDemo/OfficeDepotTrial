trigger AExtensionTrigger on Account_Extension__c (after update) {
    
    List<Id> extensionIds = new List<Id>();
        Map<Id, Account_Extension__c> extensionMap = new Map<Id, Account_Extension__c>();
    List<Account_Extension__c> extensions =new List<Account_Extension__c>();
    List<Account_Dormant__c> dormants= new List<Account_Dormant__c>();

    for (Account_Extension__c extension : Trigger.new) {
      if(  
       (( Trigger.isUpdate)   &&  
       ( (extension.Name!= trigger.oldMap.get(extension.id).Name )    || 
       (extension.Address1__c!= trigger.oldMap.get(extension.id).Address1__c )    || 
       (extension.Address2__c!= trigger.oldMap.get(extension.id).Address2__c )    || 
       (extension.AOPS_Cust_Id__c!= trigger.oldMap.get(extension.id).AOPS_Cust_Id__c )    || 
       (extension.OMX_Primary_Key__c!= trigger.oldMap.get(extension.id).OMX_Primary_Key__c )    || 
       (extension.City__c!= trigger.oldMap.get(extension.id).City__c )    || 
       (extension.Country__c!= trigger.oldMap.get(extension.id).Country__c )    || 
       (extension.State__c!= trigger.oldMap.get(extension.id).State__c )    || 
       (extension.Zip__c!= trigger.oldMap.get(extension.id).Zip__c ) 
       
       ))
      )
      {
        extensionIds.add(extension.Id);
       extensionMap.put(extension.Id, extension);
      }  
    }
    
   if(extensionIds.size() >0){
   
   /*
    extensions = [SELECT Id, Name, Account_Owner_ID__c, Address1__c, Address2__c, AOPS_Cust_Id__c, AOPS_Seq_ID__c,
                                             OMX_Primary_Key__c, City__c, Country__c, State__c, Zip__c
                                             FROM Account_Extension__c
                                             WHERE Id IN :extensionIds];
                                             
    for (Account_Extension__c extension : extensions) {
        extensionMap.put(extension.Id, extension);
    }
    */
    
    dormants = [SELECT Id, Name, AccountExtension__c, OwnerId, Address1__c, Address2__c, AOPS_Cust_Id__c,
                                         AOPS_Seq_ID__c, OMX_Primary_Key__c, City__c, Country__c, State_Province__c, Zip_Postal_Code__c
                                         FROM Account_Dormant__c
                                         WHERE AccountExtension__c IN :extensionIds];
                                         
   }                                      
                                         
    for (Account_Dormant__c dormant : dormants) {
        Account_Extension__c extension = extensionMap.get(dormant.AccountExtension__c);
        
        if (extension != null) {
            dormant.Name = extension.Name;
            dormant.Address1__c = extension.Address1__c;
            dormant.Address2__c = extension.Address2__c;
            dormant.AOPS_Cust_Id__c = extension.AOPS_Cust_Id__c;
            dormant.AOPS_Seq_ID__c = extension.AOPS_Seq_ID__c;
            dormant.OMX_Primary_Key__c = extension.OMX_Primary_Key__c;
            dormant.City__c = extension.City__c;
            dormant.Country__c = extension.Country__c;
            dormant.State_Province__c = extension.State__c;
            dormant.Zip_Postal_Code__c = extension.Zip__c;
            
            if (extension.Account_Owner_ID__c != null) {
                dormant.OwnerId = Id.valueOf(extension.Account_Owner_ID__c);
            }
        }
    }
    if(dormants.size()>0)
    Database.update(dormants, false);
}
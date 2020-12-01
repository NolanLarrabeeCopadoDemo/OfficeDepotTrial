trigger AccountAfterUpdateTrigger on Account (after update,after insert) {
    
    Map<Id,Id> mapSite= new  Map<Id,Id>();
    Set<Id> accId= new  Set<Id>();
    Set<Id> relatedAccOwnerIds= new  Set<Id>();
    
    List<Account> updateAccount= new List<Account>();
    List<Account> resultUpdateAccount= new List<Account>();
    
    if(Trigger.isInsert){
        for(Account acc:  Trigger.New){
            if(acc.IsProspectLightning__C==true  && acc.Related_Account__c  !=null){
                mapSite.put(acc.Related_Account__c,acc.Id);
                if(!accId.contains(acc.Related_Account__c))
                    accId.add(acc.Related_Account__c);
               // relatedAccOwnerIds.add(acc.Related_Account__r.Assign_Specific_Owner__c);
            }
        }
        for(Id accNew:  accId){
            Account newAcc= new account();
            newAcc.Id= accNew;
            newAcc.Primary_Site_ID__c =mapSite.get(accNew);          
            updateAccount.add(newAcc);
        }
        
        if(updateAccount.size()>0)
            update updateAccount;

    }
    
    
    if(trigger.isUpdate){
        AccountAfterTrigger_Handler.AccountAfterUpdate(trigger.new,Trigger.NewMap,Trigger.oldMap);
    }
}
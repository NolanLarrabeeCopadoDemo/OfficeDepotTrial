// -- Productions
// Modified NBOCK - S-366881 - commented code body to remove inactive trigger from coverage calcs
trigger AccountAssignment on AccountAssignments__c (after Insert) {
    /*Set<String> aaccIds = new Set<String>();
    Set<String> saccIds = new Set<String>();
    Set<String> entityIds = new Set<String>();
    Set<Id> assignmentIds = new Set<Id>();
    Set<Id> assignmentIds_toDelete = new Set<Id>();
    
    Map<Id,String> trimvals= new map<Id,String>();
    for(AccountAssignments__c ata : Trigger.New){
        
        String eid=  ata.Entity_Id__c;            
        boolean zeroflag =false;
        while(eid.startsWith('0')){ 
            eid = eid.substring(1);
            zeroflag = true;
        }              
        if(zeroflag ){
           trimvals.put(ata.Id,eid );
        }
        assignmentIds.add(ata.Id);
        if((ata.AccountType__c=='A') )
           aaccIds.add(ata.Accountid__c);
        else
           saccIds.add(ata.Accountid__c);
        entityIds.add(eid); 

    }
    
    AccountPrimaryOwnerUpdate up = new AccountPrimaryOwnerUpdate(); 
    up.UpdatePrimary(assignmentIds);
   
    

    //List<AccountAssignments__c> aassignments_List = [Select Id, Entity_Id__c from AccountAssignments__c where Entity_Id__c IN :entityIds and Accountid__c IN :aaccIds and AccountType__c = 'A' and Status__c != 'Processed' and IsDeleted = false and Id NOT IN :assignmentIds];
    //List<AccountAssignments__c> sassignments_List = [Select Id, Entity_Id__c from AccountAssignments__c where Entity_Id__c IN :entityIds and Accountid__c IN :saccIds and AccountType__c = 'S' and Status__c != 'Processed' and IsDeleted = false and Id NOT IN :assignmentIds];
    //Changes made to the above line to below line to avoid the skip when the entity Id changes from Oracle Id to AOPS ID's
    List<AccountAssignments__c> aassignments_List = [Select Id, Entity_Id__c from AccountAssignments__c where  Accountid__c IN :aaccIds and AccountType__c = 'A' and IsDeleted = false and Id NOT IN :assignmentIds];
    List<AccountAssignments__c> sassignments_List = [Select Id, Entity_Id__c from AccountAssignments__c where  Accountid__c IN :saccIds and AccountType__c = 'S' and IsDeleted = false and Id NOT IN :assignmentIds];
    List<AccountAssignments__c> trimassign_List = [Select Id from AccountAssignments__c where  Id IN :trimvals.keySet()];      
    for(AccountAssignments__c updateAssignment: trimassign_List ){
        updateAssignment.Entity_Id__c = trimvals.get(updateAssignment.Id);               
    }
   //Deleting the List Because we have a New entry in the today's List
    if(aassignments_List.size()>0){
        for(AccountAssignments__c a :aassignments_List){
            assignmentIds_toDelete.add(a.id); 
        }
    }
        //delete aassignments_List;
    if(sassignments_List.size()>0){
        for(AccountAssignments__c b :sassignments_List){
            assignmentIds_toDelete.add(b.id); 
        }
    }
    if(assignmentIds_toDelete.size()>0){
         List<AccountAssignments__c> dlist = [Select Id from AccountAssignments__c where id In :assignmentIds_toDelete ];
         delete dlist ;
    }
     //END Deleting the List Because we have a New entry in the today's List
    
       // delete sassignments_List;
    if(trimassign_List.size()>0)
        update trimassign_List;
        
   */
    
}
Trigger VP_Project_Trigger on VP_Project__c (before insert, after insert, before update, after update, before delete) {
    if(!VP_Trigger_Validator.HasTriggerExecuted()){
        if(Trigger.isBefore){
            if(Trigger.isDelete){
                    system.debug('VP_Project_Trigger is delete');
                    Set<ID> ids = Trigger.oldMap.keyset(); 
                    Set<String> pIds = new Set<String>();
                    VP_Project__c[] projects = [SELECT ProjectId__c FROM VP_Project__c WHERE Id IN :ids];
                    if (projects.size() < 0) {
                        for (VP_Project__c p : projects) {
                            if (p.ProjectId__c != null) {
                                pIds.add(p.ProjectId__c);
                            }
                        }
                        VP_Project.Trigger_DeleteProjects(pIds);
                    }
            }
            if(Trigger.isUpdate){
                    system.debug('VP_Project_Trigger is update');
                    
                    Set<ID> ids = trigger.newMap.keyset(); 
                    VP_Project.Trigger_UpdateProjects(ids);
            }
        }
     
        if(Trigger.isAfter){
            if(Trigger.isInsert){
                    system.debug('VP_Project_Trigger is insert');       
                    //IF NOT TEST
                    //if(!VP_Project.isApexTestStatic){
                        Set<ID> ids = trigger.newMap.keyset();
                        VP_Project.Trigger_CreateProjects(ids);
                    //}
                    //END IF NOT TEST
            }
            //if(Trigger.isUpdate){
            //        
            //}
        }
    }
}
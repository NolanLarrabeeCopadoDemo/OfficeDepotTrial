// Modified  - S-401328- commented code body to remove inactive trigger from coverage class
trigger UpdateSupportcase on Task (after insert,after update) { // 
    /*System.Debug('Trigger start');
    List<id> caseId = new List<Id>();
    List<Case> caseList = new List<Case>();
    List<Case> caseupdateList = new List<Case>();
    List<Case> caseITList = new List<Case>();
    List<Id> caseIT = new List<Id>();
    List<Id> caseBusiness = new List<Id>();
    Set<id> caseIdForOtherTasks = new Set<id>();
    List<Task> taskList = new List<Task>();
    
    User user = [Select Profile.name,Id from User where Id =: UserInfo.getUserId()];
    if((Trigger.isInsert || Trigger.isUpdate) && Trigger.isAfter){
    //New Condition added to auto close the Case when the Migration Validation task is Approved and Completed. - Case #00348619
            if(user.Profile.name == 'System Administrator' || user.Profile.name == 'Support' || user.Profile.name == 'Operations' || user.Profile.name == 'System Administrator 2'){
                for(Task taskObj: Trigger.new){              
                    if(taskObj.Task_Type__c == 'Business' && (taskObj.Action__c == 'Migration Validation'  ) //taskObj.Action__c == 'Validation' || 
                    && taskObj.Outcome__c =='Approved' && taskObj.Status == 'Completed'){
                        Id whatId = taskObj.WhatId ;
                        system.debug('@@whatId '+whatId);
                        caseId.add(whatId);
                        if(taskObj.Action__c == 'Migration Validation')
                        {
                        caseIdForOtherTasks.add(whatId);
                        }
                    }
    // Below logic is to update the owner to IT queue and Business queue based on Action value  
    //Included the Logic in taskevents trigger              
                   //if(trigger.isinsert){ */
                  /*  if(taskObj.status!='Completed' && taskObj.Task_Type__c == 'IT'  &&   (   taskObj.Action__c== 'Development' || taskObj.Action__c== 'Migration'))
                   { 
                     system.debug('>>>>IT Queue>>>>');
                     Case itCaseupdate=new Case ();
                     itCaseupdate.Id = taskObj.whatId;
                     if(itCaseupdate.IT_BU_Reviewer__c !=null)
                     itCaseupdate.ownerId=System.Label.IT_Queue; //IT queue
                     caseupdateList.add(itCaseupdate);
                     system.debug('>>>>caseupdateList>>>>'+caseupdateList);
                    }
                    else
                    if(taskObj.status!='Completed' && taskObj.Task_Type__c == 'Business' &&  (   taskObj.Action__c== 'Validation' || taskObj.Action__c== 'Migration Validation')){                    
                     system.debug('>>>>Sales Ops Queue>>>>');
                     Case caseupdate=new Case ();
                     caseupdate.Id = taskObj.whatId;
                     caseupdate.ownerId=System.Label.SalesOps_Queue; //Sales Ops Queue
                     caseupdateList.add(caseupdate);
                     system.debug('>>>>caseupdateList>>>>'+caseupdateList);
                    }*/
                   /* system.debug('>>>>caseupdateList>>>>'+caseupdateList);
                //    }
                }
                
                               
                for(Case caseObj: [Select Id, Status from Case where Id IN : caseId] ){
                    caseObj.Status = 'Closed';
                    caseList.add(caseObj);
                }
                //New Condition added to auto close the Case and any other open tasks when the Migration Validation task is Approved and Completed. - Case #00348619
                 
                 
                 system.debug('>>>>caseIdForOtherTasks>>>>'+caseIdForOtherTasks);
                for(Task othrTaskObj: [Select Id, Status from task where whatId IN : caseIdForOtherTasks and 
                Status!='Completed'] ){
                    othrTaskObj.Status = 'Completed';
                    taskList.add(othrTaskObj);
                }
                
                 system.debug('>>>>taskList>>>>'+taskList);
                if(caseupdateList.size()>0)
                update caseupdateList; // Updating Case Owner ID
                if(caseList.size()>0)
                Database.update(caseList); // Updating Case Status as closed
                if(taskList.size()>0)
                Database.update(taskList); //Updating other tasks as Closed when the Migration Validation task is Approved and Completed. - Case #00348619
        }
    }*/

}
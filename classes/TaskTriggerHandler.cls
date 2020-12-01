// Appirio 2015
// Universal trigger handler for Task object
//
// NBOCK - Original - S-364742 - consolidates updateSupportCase, updateLeadonTaskUpdate and TaskEvents triggers
// NBOCK - Modified - S-377010 - 2.5.2016 - update IT Status on case related to Task when task is in progress
// NSHARP - Modified - S-423438 - 7.1.2016 - updated logic to update related case when owner is changed/merged case logic to prevent multiple query error

public class TaskTriggerHandler {
  public Task[] newLst = new Task[] {};
  public Task[] oldLst = new Task[] {};
  public Map <ID, Task> newMap = new Map<ID, Task> {};
  public Map <ID, Task> oldMap = new Map<ID, Task> {};
  Map<Id, Case> maptaskcase = new Map<Id, Case>();
  List<Task> newTasks = new List<Task>();
  Schema.DescribeSobjectResult r = Schema.SobjectType.Task;
  Schema.DescribeSobjectResult c = Schema.SobjectType.Case;
  Map<String, schema.RecordtypeInfo> TskRecType = r.getRecordTypeInfosByName();
  Map<String, schema.RecordtypeInfo> CaseRecType = c.getRecordTypeInfosByName();
  Id supTskRecTypeid = TskRecType.get('Support Task').getRecordTypeId();
  Id supCaseRecTypeId = CaseRecType.get('Support').getRecordTypeId();
  Id itCaseRecTypeId = CaseRecType.get('IT Cases').getRecordTypeId();
  public Boolean isInsert {get; set;}

  public TaskTriggerHandler(Task[] triggered, Task[] triggeredFrom, Map<ID, Task> triggerNewMap, Map<ID, Task> triggerOldMap) {
    newLst = triggered;
    oldLst = triggeredFrom;
    newMap = triggerNewMap;
    oldMap = triggerOldMap;
  }

  public void onBeforeInsert() {
    isInsert = true;
    setTaskFieldsForEmails();
    createFeedItems();

  }

  public void onAfterInsert() {
    isInsert = true;
    updateSupportCase();
    updateLeadOnTaskUpdate();
    taskEvents();
    sendEmailToTaskOwner();//Added by Najma Ateeq for Story #S-377014
    updateCaseITStatus(); // NBOCK S-377010
  }

  public void onBeforeUpdate() {
    isInsert = false;
    setTaskFieldsForEmails();
    createFeedItems();
  }

  public void onAfterUpdate() {
    isInsert = false;
    updateCaseITStatus(); // NBOCK S-377010 - JN Moved to line 54 from line 58 as part of case 00164229
    //updateSupportCase();
    updateLeadOnTaskUpdate();
    system.debug('@@@@@taskEvents');
    taskEvents();
    //updateQAAssignmentonCase();//Added by lalit for S-407214
    updateRelatedCaseLogic(); //START NSHARP S-423438 7.1.2016
    
  }

  /*public void onBeforeDelete(){
      //no methods defined at this time
  }

  public void onAfterDelete(){
      //no methods defined at this time
  }

  public void onAfterUnDelete(){
      //no methods defined at this time
  }*/
  //Added below method by Lalit S-407214
  //This method is used to update QA Assignment field on Case  when a QA Task's Owner is changed
  //START NSHARP S-423438 7.1.2016
  /*public void updateQAAssignmentonCase(){
    List<Case> caseList = new List<Case>();
    Map<Id, Case> caseListMap = new Map<Id, Case>();
    for(Task t : newLst){
      if(t.OwnerId!=null && oldMap.get(t.id).OwnerId!=newMap.get(t.id).OwnerId && t.IT_TASK_TYPE__c == Constants.QA && t.Subject == Constants.QA){        
        if(!caseListMap.containsKey(t.whatId)){
          Case c = new Case(id = t.whatId, IT_QA_External_Assignment__c = t.OwnerId) ;
          caseListMap.put(t.whatId, c);
        }        
      }
    }
    if(caseListMap.size() > 0){
      update caseListMap.values();
    }
  }*/
  //END NSHARP S-423438 7.1.2016
  //update support cases method
  public void updateSupportCase() {
    List<id> caseId = new List<Id>();
    List<Case> caseList = new List<Case>();
    List<Case> caseupdateList = new List<Case>();
    List<Case> caseITList = new List<Case>();
    List<Id> caseIT = new List<Id>();
    List<Id> caseBusiness = new List<Id>();
    Set<id> caseIdForOtherTasks = new Set<id>();
    List<Task> taskList = new List<Task>();

    User user = [Select Profile.name, Id from User where Id = : UserInfo.getUserId()];

    //New Condition added to auto close the Case when the Migration Validation task is Approved and Completed. - Case #00348619
    if (user.Profile.name == 'System Administrator' || user.Profile.name == 'Support' || user.Profile.name == 'Operations' || user.Profile.name == 'System Administrator 2') {
      for (Task taskObj : newLst) {
        if (taskObj.Task_Type__c == 'Business' && (taskObj.Action__c == 'Migration Validation') && taskObj.Outcome__c == 'Approved' && taskObj.Status == 'Completed') {
          Id whatId = taskObj.WhatId;
          caseId.add(whatId);
          if (taskObj.Action__c == 'Migration Validation') {
            caseIdForOtherTasks.add(whatId);
          }
        }
      }
      for (Case caseObj : [Select Id, Status from Case where Id IN : caseId] ) {
        caseObj.Status = 'Closed';
        caseList.add(caseObj);
      }
      //New Condition added to auto close the Case and any other open tasks when the Migration Validation task is Approved and Completed. - Case #00348619
      for (Task othrTaskObj : [Select Id, Status from task where whatId IN : caseIdForOtherTasks and Status != 'Completed'] ) {
        othrTaskObj.Status = 'Completed';
        taskList.add(othrTaskObj);
      }
      if (caseupdateList.size() > 0) {
        update caseupdateList; // Updating Case Owner ID
      }
      if (caseList.size() > 0) {
        Database.update(caseList); // Updating Case Status as closed
      }
      if (taskList.size() > 0) {
        Database.update(taskList); //Updating other tasks as Closed when the Migration Validation task is Approved and Completed. - Case #00348619
      }
    }
  }

  //update lead associated with task
  public void updateLeadOnTaskUpdate() {
    List<Id> leadIds = new List<Id>();
    List<Lead> leadUpdate = new List<Lead>();
    for (Task tasks : newLst) {
      String whoId = tasks.whoId;
      if (tasks.whoId != null && whoId.substring(0, 3) == '00Q'  &&  tasks.recordtypeId != Label.GTFieldSalesTask) {
        LeadIds.add(tasks.whoId);
      }
    }
    if (LeadIds.size() > 0) {
      leadUpdate = [Select id from Lead where Id in:LeadIds];
    }
    if (leadUpdate.size() > 0) {
      update leadUpdate;
    }
  }

  //update disposition codes to email on tasks related to cases (from TaskEvents trigger)
  public void setTaskFieldsForEmails() {
    for (Task task : newLst) {
      if (task.recordtypeid != supTskRecTypeid && task.Task_Type__c == null && task.Call_Disposition__c == null && task.CallDurationInSeconds == null && isInsert == true) {
        task.Disposition_Code__c = 'Email';
        task.Task_Type__c = 'Email';
        task.Call_Disposition__c = 'Email';
      }
    }
  }

  //update related cases, accounts, notes, create additional tasks and send notification emails (from TaskEvents trigger)
  public void taskEvents() {
    List <Account> acctList = new List <Account>();
    List <Account> updateAcctList = new List <Account>();
    List <Cadence__c> cadenceList = [SELECT Lifecycle_Stage__c, Cadence__c from cadence__c];
    Map <String, Decimal> cadenceMap = new Map <String, Decimal>();
    List <Id> acctIds = new List <Id>();
    Map <Id, Date> contactDate = new Map <Id, Date>();
    List<Task> lstPriceEscalatedTasks = new List<Task>();
    Schema.DescribeSobjectResult ar = Schema.SobjectType.Account;
    Map<String, schema.RecordtypeInfo> AccRecType = ar.getRecordTypeInfosByName();
    Id inSalesRecTypeId = TskRecType.get('Inside Sales').getRecordTypeId();
    Id siteRecTypeId = AccRecType.get('Site').getRecordTypeId();
    Id supTskRecType = TskRecType.get('Support Task').getRecordTypeId();
    // Case Related Variables
    List <Case> caseList = new List <Case>();
    List <Case> updateCaseList = new List <Case>();
    List <Id> caseIds = new List <Id>();
    List <Case> updateCases =  new list<Case>();

    for (Cadence__c lclCadence : cadenceList) {
      cadenceMap.put(lclCadence.Lifecycle_Stage__c, lclCadence.Cadence__c);
    }

    Set<Id> casesid = new Set<Id>();
    List<Id> taskIds = new List<Id>(); // added for the story #S-418606 (00716996)

    for (Task thisTask : newLst) {
      if (thisTask.whatId != null &&  String.valueOf(thisTask.whatId).startsWith('500') &&  thisTask.recordtypeid == supTskRecTypeid ) {
        casesid.add(thisTask.whatId);
        taskIds.add(thisTask.id); // added for the story #S-418606 (00716996)
      }
    }
    //Case 00165481 LSLEVIN 4.13.2016 Added isCLosed to below query
  for (case taskcaseList : [select Id ,isClosed, casenumber , IT_Assignment__c, IT_BU_Reviewer__c, Support_Requester__c, IT_Production_Date__c, subject  from case where Id in :casesid ]) {
        maptaskcase.put(taskcaseList.id, taskcaseList);
      }

    list<Task> taskList = new list<Task>();
    
    Map<Id, Task> mapTask = new Map<Id, Task>([select id, lastModifiedBy.name from Task where id in :taskIds]); // added for the story #S-418606 (00716996)

    for (Task thisTask : newLst) {
      List<CaseComment > newNotes = new List<CaseComment >();

      if (thisTask.whatId != null && String.valueOf(thisTask.whatId).startsWith('500') && thisTask.recordtypeid == supTskRecTypeid) {
        integer exec = executeoncetest.execount;
        if (thisTask.status == 'Completed'  && maptaskcase.size() > 0 && exec == 0) {
          // on Complition of task add comments to case
          CaseComment nt = new CaseComment ();
          nt.ParentId = thisTask.whatId;
          String comment;
          String action;
          String outcome;
          String description;

          if (thisTask.description != null && thisTask.description != '') {
            description = thisTask.description;
          } else {
            description = '';
          }
          if (thisTask.Action__c != null && thisTask.Action__c != '') {
            action = thisTask.Action__c;
          } else {
            action = '';
          }
          if (thisTask.Outcome__c != null && thisTask.Outcome__c != '') {
            outcome = thisTask.Outcome__c;
          } else {
            outcome = '';
          }
          
          //commented for the story #S-418606 (00716996)
          //comment = 'Action: ' + action + '\nOutcome: ' + outcome + '\nTask Comment: ' + description;
          
          //added for the story #S-418606 (00716996) #START
          /*
          (1) Task Subject: [NEW - this should contain the content of the Subject field from the task]
      (2) Task Type: [NEW - this should contain the content of the IT TASK TYPE field from the task - this field may sometimes be blank]
      (3) Action: [this is currently already displayed - leave as-is]
      (4) Outcome: [this is currently already displayed - leave as-is]
      (5) Completion Date: [NEW - this should contain the content of the Completion Date field from the task in the date/time format as it displays on the UI]
      (6) Completed By: [NEW - this should contain the name of the person but not the date/time as displayed in the Last Modified By field]
          */
          
          String subjectStr = '', Type = '', CompletionDate = '', CompletedBy = '';
          
          if(thisTask.subject != null && thisTask.subject != '') {
            subjectStr = thisTask.subject;
          }
          
          if(thisTask.IT_TASK_TYPE__c != null && thisTask.IT_TASK_TYPE__c != '') {
            Type = thisTask.IT_TASK_TYPE__c;
          }
          
          if(thisTask.WRF_Task_Complete_Dt__c != null) {
            CompletionDate = thisTask.WRF_Task_Complete_Dt__c.date().format();
          }
          
          if(mapTask.containsKey(thisTask.id)) {
            CompletedBy = (String) mapTask.get(thisTask.id).lastModifiedBy.name;
          }
          
          comment = 'Task Subject: ' + subjectStr + '\nTask Type: ' + Type + '\nAction: ' + action + '\nOutcome: ' + outcome ;
          comment += '\nCompletion Date: ' + CompletionDate + '\nCompleted By: ' + CompletedBy + '\nTask Comment: ' + description;
                     
          //added for the story #S-418606 (00716996) #END
          
          if (comment.length() > 3500) {
            nt.CommentBody = comment.substring(0, 3500);
          } else {
            nt.CommentBody =  comment;
          }
          if (nt.CommentBody != null && nt.CommentBody != '') {
            newNotes.add(nt);
          }
          exec++;
          executeoncetest.execount = exec;

          // based on the outcome create additional/followup tasks.
          Task act = new Task();
          Date dt = date.valueof(maptaskcase.get(thisTask.whatid).IT_Production_Date__c);
          String prodDate = '';
          if (dt != null) {
            prodDate = dt.format();
          }
          boolean flag = true;
          String subject = '#' + maptaskcase.get(thisTask.whatid).casenumber + ' ';

          if (thisTask.Outcome__c != 'No Action Required' && thisTask.Outcome__c != '' && thisTask.Outcome__c != null) {
            if (thisTask.action__c == 'Development' && thisTask.Task_Type__C == 'IT') {
              act.Task_Type__C = 'Business';
              act.ownerId = maptaskcase.get(thisTask.whatid).IT_BU_Reviewer__c;
              act.action__c = 'Validation';
              act.activitydate = system.today().adddays(2);
              maptaskcase.get(thisTask.whatid).ownerId = System.Label.SalesOps_Queue;
            }
            // Added by Subhro for Case# - 00161051
            else if (thisTask.outcome__c == 'Rejected' && thisTask.Action__c == 'Validation' && thisTask.Task_Type__C == 'Business') {
              act.Task_Type__C = 'IT';
              act.ownerId = maptaskcase.get(thisTask.whatid).IT_Assignment__c ;
              act.action__c = 'Development';
              act.activitydate = system.today().adddays(2);
              maptaskcase.get(thisTask.whatid).ownerId = System.Label.IT_Queue;
            }
            // Modified by Mohit for Story S-386208 //
            else if (thisTask.outcome__c == 'Approved' && thisTask.Action__c == 'Validation' && thisTask.Task_Type__C == 'Business' ) {
              if ( maptaskcase.get(thisTask.whatid).IT_Production_Date__c != null ) {
                act.Task_Type__C = 'IT';
                act.ownerId = maptaskcase.get(thisTask.whatid).IT_Assignment__c ;
                act.action__c = 'Migration';
                act.activitydate = system.today().adddays(2);
                Subject += act.action__c + ' - ' + maptaskcase.get(thisTask.whatid).subject + ' - Production Date : ' + prodDate;
                if (subject.length() > 230) {
                  subject = subject.substring(0, 230);
                }
                act.Subject =  subject;
                maptaskcase.get(thisTask.whatid).ownerId = System.Label.IT_Queue;
              } else { // Added by Mohit for Story S-386208 //
                //Case 00165481 LSLEVIN 4.13.2016 Added Below If Start
                system.debug('### maptaskcase.get(thisTask.whatid).isClosed '  + maptaskcase.get(thisTask.whatid).isClosed);
                if(maptaskcase.get(thisTask.whatid).isClosed != true){
                    thisTask.addError(Constants.PRODUCTION_DATE_ERROR);
                }
                //Case 00165481 LSLEVIN 4.13.2016 End
              }
            } else if (thisTask.Action__c == 'Migration' && thisTask.Task_Type__C == 'IT') {
              act.Task_Type__C = 'Business';
              act.ownerId = maptaskcase.get(thisTask.whatid).IT_BU_Reviewer__c ;
              act.action__c = 'Migration Validation';
              act.activitydate = system.today().adddays(2);
              maptaskcase.get(thisTask.whatid).ownerId = System.Label.SalesOps_Queue;
            } else if (thisTask.action__c == 'Migration Validation' && thisTask.Task_Type__C == 'Business' && thisTask.outcome__c == 'Rejected') {
              act.Task_Type__C = 'IT';
              act.ownerId = maptaskcase.get(thisTask.whatid).IT_Assignment__c ;
              act.action__c = 'Migration';
              act.activitydate = system.today().adddays(2);
              Subject += act.action__c + ' - ' + maptaskcase.get(thisTask.whatid).subject + ' - Production Date : ' + prodDate;
              if (subject.length() > 230) {
                subject = subject.substring(0, 230);
              }
              act.Subject =  subject;
              maptaskcase.get(thisTask.whatid).ownerId = System.Label.IT_Queue;
            }
          }

          if (act.subject == null || act.subject == '') {
            subject += act.action__c + ' - ' + maptaskcase.get(thisTask.whatid).subject;
            if (subject.length() > 230) {
              subject = subject.substring(0, 230);
            }
            act.Subject =  subject;
          }

          act.Status = 'New';
          act.whatId = maptaskcase.get(thisTask.whatid).id;
          if (thisTask.outcome__c != 'Need More Info(Rep)') {
            act.recordtypeid = supTskRecTypeid;
          }
          if (act.OwnerId != null) {
            act.From_Case_Tasking_Process__c = true;//Added by Najma Ateeq for Story #S-377014
            newTasks.add(act);
          }

          if (newTasks.size() > 0) {
            insert newTasks;
          }

          if (newNotes.size() > 0) {
            insert newNotes;
          }

          caselist.addAll(maptaskcase.values()); //Replaced 'add' method with 'addAll' method - Case 00173864 - 26th July 2016 - By Abhinav Upadhyay 

          if (caselist.size() > 0 && executeoncetest.updateTaskCase) {
            executeoncetest.updateTaskCase = false;
            updateCases.addAll(caselist);
          }
        }
      }

      //only get Inside sales task with call disposition of 'Sales Related' that are closed and are attached to accounts
      if (thisTask.recordTypeId == inSalesRecTypeId && thisTask.Call_Disposition__c == 'Sales Related' && thisTask.Status == 'Completed' && thisTask.whatId != null && String.valueOf(thisTask.whatId).startsWith('001')) {
        acctIds.add(thisTask.whatId);
      }

      //only for tasks related to cases total number of tasks and closed tasks needs to be counted and updated
      if (thisTask.whatId != null && String.valueOf(thisTask.whatId).startsWith('500')) {
        caseIds.add(thisTask.whatId);
      }

      // Check if the task is account related and email needs to be sent for Price Escalation
      if (IsPriceEscalated(thisTask)) {
        taskList.add(thisTask);
      }
    }
    if (taskList.size() > 0) {
      SendEmail(taskList);
    }

    if (updateCases.size() > 0) {
      update updateCases;
    }

    acctList = [SELECT id, recordTypeid, stage__c, Cadence_Call_Date__c, Cadence_Call_Date_Override__c, Cadence_Call_Date_Override_Value__c, Site_Primary_Contact__r.id, Site_Contact2__r.id, Site_Contact3__r.id, Site_Contact4__r.id, Site_Contact5__r.id, Site_Contact6__r.id FROM Account WHERE Id IN :acctIds];
    for (Account lclAcct : acctList) {
      Date tempDate = System.today();
      if (lclAcct.cadence_call_date_override__c && lclAcct.cadence_call_date_override_value__c != null) {
        tempDate = tempDate.addDays(lclAcct.cadence_call_date_override_value__c.intValue());
      } else if (lclAcct.stage__c != null && lclAcct.stage__c != '') {
        tempDate = tempDate.addDays(cadenceMap.get(lclAcct.stage__c).intValue());
      } else {
        if (cadenceMap != null && cadenceMap.containsKey('SOW'))
          tempDate = tempDate.addDays(cadenceMap.get('SOW').intValue());
      }

      lclAcct.Cadence_Call_Date__c = tempDate;
      updateAcctList.add(lclAcct);

      if (lclAcct.RecordTypeId == siteRecTypeId) {
        if (lclAcct.Site_Primary_Contact__r.id != null) {
          contactDate.put(lclAcct.Site_Primary_Contact__r.id, tempDate);
        }
        if (lclAcct.Site_Contact2__r.id != null) {
          contactDate.put(lclAcct.Site_Contact2__r.id, tempDate);
        }
        if (lclAcct.Site_Contact3__r.id != null) {
          contactDate.put(lclAcct.Site_Contact3__r.id, tempDate);
        }
        if (lclAcct.Site_Contact4__r.id != null) {
          contactDate.put(lclAcct.Site_Contact4__r.id, tempDate);
        }
        if (lclAcct.Site_Contact5__r.id != null) {
          contactDate.put(lclAcct.Site_Contact5__r.id, tempDate);
        }
        if (lclAcct.Site_Contact6__r.id != null) {
          contactDate.put(lclAcct.Site_Contact6__r.id, tempDate);
        }
      }
    }

    acctList = [SELECT id, recordTypeid, stage__c, Cadence_Call_Date__c, Cadence_Call_Date_Override__c,
                Cadence_Call_Date_Override_Value__c, Site_Primary_Contact__r.id, Site_Contact2__r.id,
                Site_Contact3__r.id, Site_Contact4__r.id, Site_Contact5__r.id, Site_Contact6__r.id
                FROM Account
                WHERE recordTypeid = :siteRecTypeId AND
                                     Id NOT IN :acctIds AND
                                     (Site_Primary_Contact__r.id IN :contactDate.keySet() OR
                                      Site_Contact2__r.id IN :contactDate.keySet() OR
                                      Site_Contact3__r.id IN :contactDate.keySet() OR
                                      Site_Contact4__r.id IN :contactDate.keySet() OR
                                      Site_Contact5__r.id IN :contactDate.keySet() OR
                                      Site_Contact6__r.id IN :contactDate.keySet())];

    for (Account lclSite : acctList) {
      if (contactDate.containsKey(lclSite.Site_Primary_Contact__r.id)) {
        lclSite.Cadence_Call_Date__c = contactDate.get(lclSite.Site_Primary_Contact__r.id);
      } else if (contactDate.containsKey(lclSite.Site_Contact2__r.id)) {
        lclSite.Cadence_Call_Date__c = contactDate.get(lclSite.Site_Contact2__r.id);
      } else if (contactDate.containsKey(lclSite.Site_Contact3__r.id)) {
        lclSite.Cadence_Call_Date__c = contactDate.get(lclSite.Site_Contact3__r.id);
      } else if (contactDate.containsKey(lclSite.Site_Contact4__r.id)) {
        lclSite.Cadence_Call_Date__c = contactDate.get(lclSite.Site_Contact4__r.id);
      } else if (contactDate.containsKey(lclSite.Site_Contact5__r.id)) {
        lclSite.Cadence_Call_Date__c = contactDate.get(lclSite.Site_Contact5__r.id);
      } else if (contactDate.containsKey(lclSite.Site_Contact6__r.id)) {
        lclSite.Cadence_Call_Date__c = contactDate.get(lclSite.Site_Contact6__r.id);
      }

      updateAcctList.add(lclSite);
    }

    if (updateAcctList.size() > 0) {
      update updateAcctList;
    }

    /*Case related summary field update logic
    caseList = [SELECT id, recordTypeid, Total_Tasks__c, Total_Completed_Tasks__c FROM case WHERE id IN :caseIds ];
    List<Task> allTaskList = new List<Task>();
    List<Task> completedTaskList = new List<Task>();
    allTaskList = [SELECT Id, WhatId FROM Task WHERE WhatId IN :caseIds AND Task_Type__c != 'Email'];
    completedTaskList = [SELECT Id, WhatId FROM Task WHERE WhatId IN :caseIds AND Task_Type__c != 'Email' AND Status = 'Completed'];

    for (Case lclCase : caseList) {
      Integer allTaskCount = 0;
      Integer compTaskCount = 0;
      if (!allTaskList.isEmpty()) {
        for (Task allTask : allTaskList) {
          if (allTask.WhatId == lclCase.Id) {
            allTaskCount++;
          }
        }
      }
      lclCase.Total_Tasks__c = allTaskCount;

      if (!completedTaskList.isEmpty()) {
        for (Task compTask : completedTaskList) {
          if (compTask.WhatId == lclCase.Id) {
            compTaskCount++;
          }
        }
      }
      lclCase.Total_Completed_Tasks__c = compTaskCount;

      updateCaseList.add(lclCase);
    }

    if (updateCaseList.size() > 0 && executeoncetest.updateTaskCase1) {
      executeoncetest.updateTaskCase1 = false;
      update updateCaseList;
    }
    */
  }

  public void createFeedItems() {
    List<FeedItem> feedItems;
    Map<ID, User> userMap = new Map<ID, User>(); //This is our user map
    for (User u : [SELECT ID, Name FROM User WHERE Name LIKE 'JAsmeet%' OR  Name LIKE 'monika .karamchandani%' OR Name LIKE 'Guha Anand%' OR Name LIKE 'SubhraJyoti%' OR Name LIKE 'Mohit Bansal%' OR Name LIKE 'Niraj Sinh%' OR Name LIKE 'Sushma%']) {
      usermap.put(U.Id, u);
    }

    if (isInsert) {
      feedItems = new List<FeedItem>();
      for (Task t : newLst) {
        if (t.WhatId != null && t.status == 'completed' && (UserMap.get(t.OwnerId) != null )) {
          FeedItem fitem = new FeedItem();
          fitem.type = 'LinkPost';
          fitem.ParentId = t.WhatId;
          fitem.LinkUrl = '/' + t.id; //This is the url to take the user to the activity
          fitem.Title = 'Offshore Updates';  //This is the title that displays for the LinkUrl

          //Get the user by checking the userMap we created earlier
          System.Debug('usr check' + t.ownerId);
          System.Debug('usr check2' + userMap.get(t.ownerId));
          User assignedTo = userMap.get(t.ownerId);

          fitem.Body = ((Trigger.isInsert) ? 'New' : 'Updated') + ' Activity ' + ((t.ActivityDate != null) ? t.ActivityDate.format() : '')
                       + '\nAssigned To: ' + ((assignedTo != null) ? assignedTo.name : 'Unknown')
                       + '\nSubject: ' + t.Subject
                       + '\nStatus: ' + t.Status
                       + '\nActual LOE: ' + t.Actual_LOE__c;
          feedItems.add(fitem);
          system.debug('feed items insert' + feedItems);
        }
      }
    } else {
      feedItems = new List<FeedItem>();
      for (Task t : newLst) {
        if (t.WhatId != null && t.status == 'completed' && oldMap.get(t.id).status != 'completed' && (UserMap.get(t.OwnerId) != null )) {

          System.Debug('entered status');
          FeedItem fitem = new FeedItem();
          fitem.type = 'LinkPost';
          fitem.ParentId = t.WhatId;
          fitem.LinkUrl = '/' + t.id; //This is the url to take the user to the activity
          fitem.Title = 'Offshore Updates';  //This is the title that displays for the LinkUrl

          //Get the user by checking the userMap we created earlier
          System.Debug('usr check' + t.ownerId);
          System.Debug('usr check2' + userMap.get(t.ownerId));
          User assignedTo = userMap.get(t.ownerId);

          fitem.Body = ((Trigger.isInsert) ? 'New' : 'Updated') + ' Activity ' + ((t.ActivityDate != null) ? t.ActivityDate.format() : '')
                       + '\nAssigned To: ' + ((assignedTo != null) ? assignedTo.name : 'Unknown')
                       + '\nSubject: ' + t.Subject
                       + '\nStatus: ' + t.Status
                       + '\nActual LOE: ' + t.Actual_LOE__c;
          feedItems.add(fitem);
          system.debug('feed items update' + feedItems);
        }
      }

    }
    if (feedItems.size() > 0 && executeoncetest.executeonce == 0) {
      executeoncetest.executeonce = 1;
      Insert feedItems;
    }

  }
  //send email method
  private void SendEmail(list<Task> paramTasks) {
    String emailBody = '';
    Set<Id> whatIds = new Set<Id>();
    Set<Id> ownerIds = new Set<Id>();
    for (Task task : paramTasks) {
      whatIds.add(task.whatId);
      ownerIds.add(task.ownerId);
    }
    List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
    Map<Id, Account> lclAccountMap = new Map<Id, Account>([select id, name, AOPS_Cust_Id__c from account where id = :whatIds]);
    Map<Id, User> lclUserMap = new Map<Id, User>([select ManagerId, name, Manager.Email from user where id = :ownerIds]);

    String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
    for (Task task : paramTasks) {
      if (lclAccountMap.containsKey(task.whatId)) {
        emailBody += 'Pricing Escalation - Acct: ' + lclAccountMap.get(task.whatId).AOPS_Cust_Id__c + '-->' + lclAccountMap.get(task.whatId).name + ' ';
      }
      emailBody += (task.Description == null ? (task.Subject == null ? '' : task.Subject) : task.Description) + '\n';

      emailBody += '\n------------------------------------------------------------------------------------------------------\n\n';

      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
      mail.setSubject((task.Description == null ? (task.Subject == null ? '' : task.Subject) : task.Description));
      mail.setSenderDisplayName('Automated Email Notification');
      mail.setUseSignature(false);

      String[] toAddresses = new String[] {'officedepotinsidesales@officedepot.com'};

      // Send to Manager email if present
      if (lclUserMap.containsKey(task.ownerId) && lclUserMap.get(task.ownerId).Manager != null && lclUserMap.get(task.ownerId).Manager.Email != null) {
        toAddresses.add(lclUserMap.get(task.ownerId).Manager.Email);
      }
      mail.setToAddresses(toAddresses);
      mail.setPlainTextBody(emailBody);
      mails.add(mail);
    }
    if (mails.size() > 0) {
      Messaging.sendEmail(mails);
    }
  }

  //price escalated check
  private Boolean IsPriceEscalated(Task paramTask) {
    Boolean escalated = false;
    // Task has to be account related and dispositioned for Pricing Maintenance for escalation
    if ((paramTask.Call_Disposition__c == 'Pricing Maintenance') && (paramTask.Disposition_Code__c == 'Pricing escalation') && (paramTask.whatId != null) && (String.valueOf(paramTask.whatId).startsWith('001')) && (paramTask.ownerId != null)) {
      // In case of new records set true
      if (isInsert) {
        escalated = true;
      } else {
        // Get the before snapshot of the task in case of an update
        Task oldTask = oldMap.get(paramTask.Id);
        //One of 2 fields has been Changed to a different value
        if (oldTask.Call_Disposition__c != paramTask.Call_Disposition__c || oldTask.Disposition_Code__c != paramTask.Disposition_Code__c) {
          escalated = true;
        } else {
          escalated = false;
        }
      }
    } else {
      escalated = false;
    }

    return escalated;
  }
  //Created by Najma Ateeq for Story #S-377014(00609782 - Support Case Tasking Process Updates - Send Email to Assigned User on Task)
  //After task creation send notification to owner of task when task gets crated from CaseTrigger
  private void sendEmailToTaskOwner() {
    List<Messaging.SingleEmailMessage> lstOfEmails = new List<Messaging.SingleEmailMessage>();
    Set<Id> caseIDs = new Set<Id>();

    for (Task tsk : newLst) { //get caseIds
      if (tsk.From_Case_Tasking_Process__c && String.valueOf(tsk.WhatId).substring(0, 3).equals(Case.sObjectType.getDescribe().getKeyPrefix()))
        caseIDs.add(tsk.WhatId);
    }
    if (caseIDs.size() > 0) { //if caseIds exists
      Map<Id, Case> mapOfCases = new Map<Id, Case>([Select Id, CaseNumber, Subject, Type, Description, IT_Impact__c, IT_Track__c from Case where ID IN: caseIDs]);
      for (Task tsk : newLst) {
        if (tsk.From_Case_Tasking_Process__c && String.valueOf(tsk.WhatId).substring(0, 3).equals(Case.sObjectType.getDescribe().getKeyPrefix())
            && mapOfCases.containsKey(tsk.WhatId)) {
          Case cse = mapOfCases.get(tsk.WhatId);
          Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
          String subject = 'New Task Assigned to You for Case #' + cse.CaseNumber ; //subject
          String body = '*** TASK ASSIGNMENT NOTIFICATION *** \n \n'; //body
          body += 'A Task related to the following Support Case has been assigned to you: \n\n';

          body += 'Case #: ' + cse.CaseNumber + '\n';
          body += 'Subject: ' + cse.Subject + '\n';
          body += 'Case Type: ' + (cse.IT_Track__c != null ? cse.IT_Track__c : '') + '\n';
          body += 'Case Description: ' + (cse.Description != null ? cse.Description : '') + '\n';
          body += 'Case Details: ' + (cse.IT_Impact__c != null ? cse.IT_Impact__c : '') + '\n\n';

          body += 'Task Subject: ' + (tsk.Subject != null ? tsk.Subject : '') + '\n';
          body += 'Task Due Date: ' + (tsk.ActivityDate != null ? String.valueOf(tsk.ActivityDate.format()) : '') + '\n';
          body += 'Task Type: ' + (tsk.Task_Type__c != null ? tsk.Task_Type__c : '') + '\n';
          body += 'Task Action Required: ' + (tsk.Action__c != null ? tsk.Action__c : '') + '\n\n';

          body += 'Click here to view the Task assigned to you: ' + System.URL.getSalesforceBaseUrl().toExternalForm() + '/' + tsk.Id;

          mail.setTargetObjectId(tsk.OwnerId);
          mail.setSubject(subject);
          mail.setPlainTextBody(body);
          mail.setSaveAsActivity(false);
          lstOfEmails.add(mail);
        }
      }
      if (lstOfEmails.size() > 0) //if list of email exists
        Messaging.sendEmail(lstOfEmails);
    }

  }

  //NBOCK - S-377010 - 2.5.2016 start
  public void updateCaseITStatus() {
    Set<Id> caseIds = new Set<Id>();
    system.debug('inside of updatecaseit');
    //check for support tasks on cases that are 'In Progress' and add related case to set
    for (Task t : newLst) {
      system.debug('what' + t.whatid);
      if (t.WhatId != null) {
        if (t.Status == Label.STInProgress && String.valueOf(t.WhatId).startsWith('500') && t.RecordTypeid == supTskRecTypeid) {
          caseIds.add(t.WhatId);
        } else if (t.Status == Label.STComplete && t.IT_Task_Type__c == Label.STUAT && t.Subject == Label.STUAT && String.valueOf(t.WhatId).startsWith('500') && t.RecordTypeid == supTskRecTypeid) {
          caseIds.add(t.WhatId);
        }
      }
    }
    //create case map and set IT Status field value based on the type of task
    if (!caseIds.isEmpty()) {
      Map<Id, Case> caseMap = new Map<Id, Case>([SELECT Id, IT_Status__c, status FROM Case Where Id IN :caseIds]);
      system.debug('casemap' + caseMap);
      for (Task t : newLst) {
        if (caseMap.containsKey(t.WhatId)) {
          Case parentCase = caseMap.get(t.WhatId);
          system.debug('1' + parentCase.IT_Status__c + ' ' + parentCase.status);

          //Added if statement for Appirio case 00164229 - J.Norman
          if ((parentCase.IT_Status__c == 'Completed' && parentCase.status != 'Closed')
            || (parentCase.IT_Status__c != 'Completed' && parentCase.status == 'Closed' ) 
            || (parentCase.IT_Status__c == null && parentCase.status != 'Closed' )
            || (parentCase.IT_Status__c != null && parentCase.status != 'Closed' )) {
           
            if (t.Status == Label.STComplete && t.IT_Task_Type__c == Label.STUAT && t.Subject == Label.STUAT) {

              parentCase.IT_Status__c = Label.STAwaitingProdMigration;
            } else if (t.IT_Task_Type__c == Label.STDesign && t.Subject == Label.STDesign) {
              parentCase.IT_Status__c = Label.STInDesign;
            } else if (t.IT_Task_Type__c == Label.STBuild && t.Subject == Label.STBuild) {
              parentCase.IT_Status__c = Label.STInDevelopment;
            } else if (t.IT_Task_Type__c == Label.STCodeReview && t.Subject == Label.STCodeReview) {
              parentCase.IT_Status__c = Label.STInCodeReview;
            } else if (t.IT_Task_Type__c == Label.STUATMigration && t.Subject == Label.STUATMigration) {
              parentCase.IT_Status__c = Label.STAwaitingUATMigration;
            } else if (t.IT_Task_Type__c == Label.STQA && t.Subject == Label.STQA) {
              parentCase.IT_Status__c = Label.STInQA;
            } else if (t.IT_Task_Type__c == Label.STUAT && t.Subject == Label.STUAT) {
              parentCase.IT_Status__c = Label.STInUAT;
            }
            //Start - S-407212
            else if(t.IT_Task_Type__c == Label.STARBRequired && t.Subject == Label.STARBRequired){
              parentCase.IT_Status__c = Label.STInARB;
            }
            else if(t.IT_Task_Type__c == Label.STUsability && t.Subject == Label.STUsability){
              parentCase.IT_Status__c = Label.STInUsability;
            }
            //End - S-407212

          }
        }
      }
      update caseMap.values();
    }
  }
  //NBOCK - S-377010 - 2.5.2016 end

  //START NSHARP S-423438 7.1.2016 - when owner is changed, update related field on case
  //also merged other case functionality to prevent too many soql error
  public void updateRelatedCaseLogic(){
      //Overall list to be updated by all processes
      Map<Id,Case> caseMap = new Map<Id,Case>();

      //Map to hold related case value when task owner is changed
      Map<Id,Task> newOwnerMap = new Map<Id,Task>();
      //Case00348619
      User u = [SELECT Id,Profile.Name FROM User WHERE Id =: UserInfo.getUserId()];
      Set<Id> caseIdForOtherTasks = new Set<Id>();
      List<Task> taskList = new List<Task>();

      for(Task t: newLst){
        //finding newly updated owners and related cases
        //S-423438 and S-407214
        if(t.WhatId != null && t.IT_TASK_TYPE__c != null && t.OwnerId != oldMap.get(t.Id).OwnerId && (t.IT_TASK_TYPE__c == Constants.DESIGN || t.IT_TASK_TYPE__c == Constants.BUILD_UNIT_TEST || t.IT_TASK_TYPE__c == Constants.UAT || t.IT_TASK_TYPE__c == Constants.QA)){
              if(!newOwnerMap.containsKey(t.WhatId)){
              //update case BU Reviewer if task is UAT type
              if(t.IT_TASK_TYPE__c == Constants.UAT){
                newOwnerMap.put(t.WhatId,t);
                if(caseMap.containsKey(t.WhatId)){
                  caseMap.get(t.WhatId).IT_BU_Reviewer__c = t.OwnerId;
                }
                else{
                  Case c = new Case(Id=t.WhatId, IT_BU_Reviewer__c = t.OwnerId);
                  caseMap.put(t.WhatId, c);
                }
              }
              //update case QA External Assignment if task is QA type
              if(t.IT_TASK_TYPE__c == Constants.QA){
                newOwnerMap.put(t.WhatId,t);
                if(caseMap.containsKey(t.WhatId)){
                  caseMap.get(t.WhatId).IT_QA_External_Assignment__c = t.OwnerId;
                }
                else{
                  Case c = new Case(Id=t.WhatId, IT_QA_External_Assignment__c = t.OwnerId);
                  caseMap.put(t.WhatId, c);
                }
              }
              //update case IT Assignment if task is Design or Build/Unit Test type
              if(t.IT_TASK_TYPE__c == Constants.Design || t.IT_TASK_TYPE__c == Constants.BUILD_UNIT_TEST){
                newOwnerMap.put(t.WhatId,t);
                if(caseMap.containsKey(t.WhatId)){
                  system.debug('#### HIT Else: ' + t);
                  caseMap.get(t.WhatId).IT_Assignment__c = t.OwnerId;
                }
                else{
                  system.debug('#### Hit Else else: ' + t);
                  Case c = new Case(Id=t.WhatId, IT_Assignment__c = t.OwnerId);
                  caseMap.put(t.WhatId, c);
                }
              }
            }
          }
        //Case00348619
          //New Condition added to auto close the Case when the Migration Validation task is Approved and Completed. - Case #00348619
          if(u.Profile.name == 'System Administrator' || u.Profile.name == 'Support' || u.Profile.name == 'Operations' || u.Profile.name == 'System Administrator 2'){
            if(t.Task_Type__c == 'Business' && (t.Action__c == 'Migration Validation') && t.Outcome__c == 'Approved' && t.Status == 'Completed'){
              if(caseMap.containsKey(t.WhatId)){
                caseMap.get(t.WhatId).Status = 'Closed';
              }
              else{
                Case c = new Case(Id=t.WhatId, Status='Closed');
                caseMap.put(t.WhatId,c);
              }
              if(t.Action__c == 'Migration Validation'){
                caseIdForOtherTasks.add(t.WhatId);
              }
            }
          }
      }
      //Case00348619
      //New Condition added to auto close the Case and any other open tasks when the Migration Validation task is Approved and Completed. - Case #00348619
      for (Task othrTaskObj : [Select Id, Status from task where whatId IN : caseIdForOtherTasks and Status != 'Completed'] ) {
          othrTaskObj.Status = 'Completed';
            taskList.add(othrTaskObj);
        }

        if(!taskList.isEmpty()){
          update taskList;
        }

        if(!caseMap.values().isEmpty()){
          update caseMap.values();
        }
  }
  //END NSHARP S-423438 7.1.2016
}
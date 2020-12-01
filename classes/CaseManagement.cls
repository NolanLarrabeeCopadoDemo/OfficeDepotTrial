public class CaseManagement {
       
    private static boolean runOnce = false;
     private static string currentuser = UserInfo.getuserid();
     private static Map<String,Schema.RecordTypeInfo> CaseRecType = Schema.SObjectType.Case.getRecordTypeInfosByName();
     private static Map<String,Schema.RecordTypeInfo> TaskRecType = Schema.SObjectType.Task.getRecordTypeInfosByName();
     private static Map<String,Schema.RecordTypeInfo> slarectype = Schema.SObjectType.Case_SLA__c.getRecordTypeInfosByName();
     private static String DefaultBusinessHours_Id;
     private static String BusinessHours_Id;
     private static List<BusinessHours> bh;
     private static set<id> supcases =new set<Id>();
     private static List<Task> newTasks = new List<Task>();
     private static List<CaseComment > newNotes = new List<CaseComment >();
     private static list<ID> cids = new list<ID> ();
     private static list<ID> fullids = new list<ID> ();
     private static Map<ID,ID> case_creator_map = new Map<ID,ID> ();
     private static list<caseshare> c_share = new list<caseshare> ();
     private static Map<Id,Account> map_case_account = new Map<Id,Account>();
     private static Boolean isAccountMaintainance = false;
     private static Map<Id, Case> Case_Map = new Map<Id, Case>();
     private static List<WRF_Task__c> lstRelatedTasks = new List<WRF_Task__c>();
      ////////////Account Maintanance Variables///////////
     private static Map<string,QueueSobject> map_queue_sla= new Map<string,QueueSobject>();
     private static Map<Id,QueueSobject> map_queue_Id = new Map<Id,QueueSobject>();
     private static Map<Id,User> current_user=new Map<Id,User>();
     private static List<QueueSobject> lst_queue = new List<QueueSobject>();
     private static List<User> currentuser_list = new List<User>();
     private static Map<string,Case_SLA__c> map_Case_sla= new Map<string,Case_SLA__c>();
     private static List<Case_SLA__c> lst_sla = new List<Case_SLA__c>();
     private static Set<String> set_userEmpId = new Set<String>();
     private static Map<string,ID>  User_sla = new  Map<string,ID>();
     private static List<User> sla_users = new List<User>();
     private static List<Acct_Maint__c>defaultImplManager = new List<Acct_Maint__c>();
     private static Set<String> defaultImplManagerEMPID = new Set<String>();
     private static List<User> ImplementationUser = new List<User>();
     private static List<Case> update_Case_record= new List<Case>();
     private static List<Case> updateRVP = new List<Case>();
     private static List<Case> list_Case = new List<Case>();
      /////WRF KPI Logic
     private static List<Record_History__c> insertrecordhistory = new List<Record_History__c>();
     private static List<Record_History__c> updaterecordhistory = new List<Record_History__c>();
     private static Set<Id> caseidwrf= new Set<Id>();
     private static Set<Id> caseiddelete=new Set<Id>();
     private static List<Record_History__c> deleterecordhistory=new List<Record_History__c>();

     public Static void gBusinessHours() {
         // Support Ticket: 00801489 Prod Fix Start**
         /*bh = [select id,Name,IsDefault from businesshours];
         for(BusinessHours b: bh)
         {
            if(b.IsDefault)
                DefaultBusinessHours_Id = b.id;
            else
                BusinessHours_Id = b.id;
         }*/
         
         DefaultBusinessHours_Id = Label.Default_BusinessHours_Id;
         BusinessHours_Id = Label.BusinessHours_Id;
         ////Support Ticket: 00801489 Prod Fix End**
     }
     
     public static void beforedeletemethod()
     {
         if(Trigger.Isdelete && trigger.IsBefore)
         {
            for (Case deletecase:(List<case>)Trigger.old)
             {
                  caseiddelete.add(deletecase.id);
             }
             deleterecordhistory=[Select id from Record_History__c where Case__c in:caseiddelete];
             if(deleterecordhistory.size()>0)
             {
                 delete deleterecordhistory;
             }
         }
     }

     public static void onAfterUpdate(){
        if(!Constants.HAS_PROCESSED){
            sendEmailToTaskOwner((List<Case>)Trigger.new, (Map<Id,Case>)Trigger.newMap, (Map<Id,Case>)Trigger.oldMap); // Method added by Rahul to send email to Task owner for Support cases - S-377011
        }
     }

     // Method to send email when IT Status gets change on Case - By Rahul S-377011
    public static void sendEmailToTaskOwner(List<Case> newLst,Map<Id,Case> newMap, Map<Id,Case> oldMap){
         Constants.HAS_PROCESSED = true;
        List<Messaging.SingleEmailMessage> lstOfEmails = new List<Messaging.SingleEmailMessage>();
        Map<Id,Case> supportCaseMap = new map<Id,Case>();
        list<String>  toAddresses = new list<String>();
        list<String>  ccAddresses = new list<String>();
        Map<String,Task> taskStatusMap = new Map<String,Task>();
        //list<CaseComment> caseCommentsToinsert = new list<CaseComment>(); //S-410498 (OD 00695042) [Hemant 5/10/2016] - Stop comment addition
        list<Task> taskList = new list<Task>();
        // Prepare a map of support case if IT status get change
        for(Case cse : newLst){
            if((newMap.get(cse.Id).IT_Status__c != oldMap.get(cse.Id).IT_Status__c) && (CaseRecType.get(Constants.Support).getRecordTypeId()!=null) && (CaseRecType.get(Constants.IT_CASES).getRecordTypeId()!=null) && ((cse.recordTypeId == CaseRecType.get(Constants.Support).getRecordTypeId())||(cse.recordTypeId == CaseRecType.get(Constants.IT_CASES).getRecordTypeId()))) {
                supportCaseMap.put(cse.Id,cse);
            }
        }
        // retrieve all associated task to case
        if(!supportCaseMap.isEmpty())
            taskList = [select Id,Subject,IT_TASK_TYPE__c,ActivityDate,WhatId,OwnerId,Owner.Email from Task where whatId in :supportCaseMap.keySet() order by CreatedDate DESC];
        // Prepare a map of task contains task what Id and IT_TASK_TYPE__c
            for(Task task : taskList){
                if(String.isNotBlank(task.IT_TASK_TYPE__c) && !taskStatusMap.containsKey(task.whatId+''+task.IT_TASK_TYPE__c))
                    taskStatusMap.put(task.whatId+''+task.IT_TASK_TYPE__c,task);
            }
        for(Case cse : supportCaseMap.values()){
                String taskType='';
                // populate approprate task bases on case IT status
                if(cse.IT_Status__c == Label.STInCodeReview)
                        taskType = Label.STCodeReview;
                else if(cse.IT_Status__c == Label.STAwaitingUATMigration)
                        taskType = Label.STUATMigration;
                else if(cse.IT_Status__c == Label.STInQA)
                        taskType = Label.STQA;
                else if(cse.IT_Status__c == Label.STInUAT)
                        taskType = Label.STUAT;
                if(taskStatusMap.containsKey(cse.Id+''+taskType)){
                    Task tsk = taskStatusMap.get(cse.Id+''+taskType);
                    // Prepare Email and body
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    String subject = Constants.EMAIL_SUBJECT_TASK+cse.CaseNumber ; //subject
                    String body = Constants.EMAIL_BODY_HEADER; //body
                    body += 'Case#: ' +cse.CaseNumber+ '\n';
                    body += 'Subject: ' +cse.Subject + '\n';
                    body += 'Case Type: ' + (cse.IT_Track__c != null ? cse.IT_Track__c : '') + '\n';
                    body += 'Case Description: ' +(cse.Description != null ? cse.Description : '') + '\n';
                    body += 'Case Details:' +(cse.IT_Impact__c != null ? cse.IT_Impact__c : '') + '\n\n';
                    body += 'Case IT Status: ' +(cse.IT_Status__c != null ? cse.IT_Status__c : '') + '\n';
                    body += 'Task Subject: ' +(tsk.Subject != null ? tsk.Subject : '') + '\n';
                    body += 'Task Due Date: ' +(tsk.ActivityDate != null ? String.valueOf(tsk.ActivityDate) : '') + '\n';
                    body += 'Click here to view the Task assigned to you: '+ System.URL.getSalesforceBaseUrl().toExternalForm()+'/'+tsk.Id;
                    // Add task owner email in To Address list
                    if(String.isNotBlank(tsk.Owner.Email))
                        toAddresses.add(tsk.Owner.Email);
                    // Extract additional email address list from custom setting
                    list<String> emailAddressFromCustomSetting = new list<String>();
                    if(String.isNotBlank(Label.EmailAddressForTaskNotification)){
                        emailAddressFromCustomSetting = Label.EmailAddressForTaskNotification.Split(';');
                        ccAddresses.addAll(emailAddressFromCustomSetting);
                    }
                    if(toAddresses.size() > 0 || ccAddresses.size() > 0){
                        mail.settoAddresses(toAddresses);
                        mail.setCcAddresses(ccAddresses);
                        mail.setSubject(subject);
                        mail.setPlainTextBody(body);
                        mail.setWhatId(cse.Id);
                        mail.setSaveAsActivity(false);
                        lstOfEmails.add(mail);
                        /* START S-410498 (OD 00695042) [Hemant 5/10/2016] - Stop comment addition
                        // Add case comment
                        CaseComment newCaseComment = new CaseComment();
                        newCaseComment.parentId = cse.Id;
                        newCaseComment.CommentBody = body;
                        caseCommentsToinsert.add(newCaseComment);
                        //END S-410498 (OD 00695042) [Hemant 5/10/2016] - Stop comment addition */
                    }
                }
        }
         if(lstOfEmails.size() > 0){ //if list of email exists
          Messaging.sendEmail(lstOfEmails);
         }
         /* START S-410498 (OD 00695042) [Hemant 5/10/2016] - Stop comment addition
         if(caseCommentsToinsert.size() > 0)
             insert caseCommentsToinsert;
         //END S-410498 (OD 00695042) [Hemant 5/10/2016] - Stop comment addition */
    }
    // End S-377011

     public static void CommonforAll()
     {

         for (Case newcase:(List<case>)Trigger.new)
         {

         }


     }
     /*
     public static void fieldUpdates(Case c)
     {
        if(c.ParentId!=null)
        {
            c.Description= 'Revisit -'+(c.ACCT_Name__c!=null ?c.ACCT_Name__c:'')+' - '+c.WRF_Request_Type__c+' - '+(c.CaseNumber!=null ?c.CaseNumber:'');
            c.Subject= 'Revisit -'+(c.ACCT_Name__c!=null ?c.ACCT_Name__c:'')+' - '+c.WRF_Request_Type__c+' - '+(c.CaseNumber!=null ?c.CaseNumber:'');
        }
        else
        {
            c.Description= (c.ACCT_Name__c!=null ?c.ACCT_Name__c:'')+' - '+c.WRF_Request_Type__c+' - '+(c.CaseNumber!=null ?c.CaseNumber:'');
            c.Subject= (c.ACCT_Name__c!=null ?c.ACCT_Name__c:'')+' - '+c.WRF_Request_Type__c+' - '+(c.CaseNumber!=null ?c.CaseNumber:'');
        }
     }
     */
     public static void KPI_WRF_AccountMain(Map<Id,Record_History__c> updaterecordhis)
     {
         gBusinessHours();
         for (Case c:(List<case>)Trigger.new)
         {
             if((c.recordTypeId == CaseRecType.get('Work Request').getRecordTypeId()) || (c.recordTypeId == CaseRecType.get('Account Maintenance').getRecordTypeId()))
             {
                 //Tracking KPI for Status field for WRF And Account Maintainance both.
                 if(Trigger.isAfter && Trigger.isInsert)
                 {
                      Record_History__c CaseStatusRecHistory = new Record_History__c();
                      CaseStatusRecHistory.Case__c= c.id;
                      CaseStatusRecHistory.Status__c= c.Status;
                      CaseStatusRecHistory.Start_Date__c= System.Now();
                      insertrecordhistory.add(CaseStatusRecHistory);
                 }
                 if(Trigger.isBefore && Trigger.isUpdate)
                 {
                    Case oldCase =  (Case)Trigger.oldMap.get(c.Id);
                    if(c.Status!=oldCase.Status && oldCase.Status!='Closed' && oldCase.Status!='Cancelled')
                    {
                        Record_History__c CaseStatusRecHistory1=updaterecordhis.get(c.id);
                        if(CaseStatusRecHistory1!=null)
                        {
                            CaseStatusRecHistory1.End_Date__c= System.now();
                            if(c.recordTypeId == CaseRecType.get('Work Request').getRecordTypeId())
                            {
                                CaseStatusRecHistory1.No_of_Hours__c = (Businesshours.diff(DefaultBusinessHours_Id,CaseStatusRecHistory1.Start_Date__c, System.Now())/(1000*60*60));
                            }
                            if(c.recordTypeId == CaseRecType.get('Account Maintenance').getRecordTypeId())
                            {
                                CaseStatusRecHistory1.No_of_Hours__c = (Businesshours.diff(BusinessHours_Id,CaseStatusRecHistory1.Start_Date__c, System.Now())/(1000*60*60));
                            }
                            updaterecordhistory.add(CaseStatusRecHistory1);

                            Record_History__c CaseStatusRecHistory2 = new Record_History__c();
                            CaseStatusRecHistory2.Case__c= c.id;
                            CaseStatusRecHistory2.Status__c= c.Status;
                            CaseStatusRecHistory2.Start_Date__c= System.Now();
                            insertrecordhistory.add(CaseStatusRecHistory2);
                        }
                    }
                    //Tracking KPI for individual approvers only for WRF Record type.
                    if(c.recordTypeId == CaseRecType.get('Work Request').getRecordTypeId())
                    {
                         if((c.Approval_Status__c == 'Pending Approval' && oldCase.Approval_Status__c == null)||((oldCase.Approval_Status__c=='Approved' || oldCase.Approval_Status__c=='Rejected' || oldCase.Approval_Status__c=='Approval Recalled') && c.Approval_Status__c=='Pending Approval'))
                          {

                              Record_History__c CaseStatusRecHistory3 = new Record_History__c();
                              CaseStatusRecHistory3.Case__c = c.id;
                              if(c.Next_ApproverId__c == 'Finance')
                                 CaseStatusRecHistory3.Queue_Approver__c = c.Next_ApproverId__c;
                              else
                                  CaseStatusRecHistory3.Approver__c = c.Next_ApproverId__c;

                              CaseStatusRecHistory3.Start_Date__c = System.Now();
                              insertrecordhistory.add(CaseStatusRecHistory3);
                          }
                          //*****Added by Subhro
                          if(oldCase.Approval_Status__c=='Pending Approval')
                          {
                              //system.debug('Update record History-->'+updaterecordhis);
                               if(c.Compliance_Mgr_Action_Date__c!= oldcase.Compliance_Mgr_Action_Date__c || c.DSM_Action_Date__c!= oldcase.DSM_Action_Date__c || c.Strategy_Director_Action_Date__c!= oldcase.Strategy_Director_Action_Date__c ||
                                     c.RSD_Action_Date__c!=oldcase.RSD_Action_Date__c || c.Public_Sector_VP_Action_Date__c!=oldcase.Public_Sector_VP_Action_Date__c || c.Finance_Action_Date__c!=oldcase.Finance_Action_Date__c || c.Sr_Strategy_Dir_Action_Date__c!=oldcase.Sr_Strategy_Dir_Action_Date__c ||
                                     c.RVP_Action_Date__c!=oldcase.RVP_Action_Date__c || c.VP_Sales_Ops_Action_Date__c!=oldcase.VP_Sales_Ops_Action_Date__c || c.Finance_Dir_Action_Date__c!=oldcase.Finance_Dir_Action_Date__c || c.Field_Sales_VP_Action_Date__c!=oldcase.Field_Sales_VP_Action_Date__c || c.SVP_Action_Date__c!=oldcase.SVP_Action_Date__c ||c.Approval_Status__c=='Approval Recalled')
                                     {
                                        //system.debug('Many ifs');
                                         Record_History__c CaseStatusRecHistory4=updaterecordhis.get(c.id);
                                         if(CaseStatusRecHistory4!=null)
                                         {
                                             CaseStatusRecHistory4.End_Date__c= System.now();
                                             CaseStatusRecHistory4.No_of_Hours__c = (Businesshours.diff(DefaultBusinessHours_Id,CaseStatusRecHistory4.Start_Date__c, System.Now())/(1000*60*60));
                                             CaseStatusRecHistory4.Actual_Approver__c = currentuser;
                                             updaterecordhistory.add(CaseStatusRecHistory4);
                                             if(c.Next_ApproverId__c!=null)
                                             {
                                                  Record_History__c CaseStatusRecHistory5 = new Record_History__c();
                                                  CaseStatusRecHistory5.Case__c = c.id;
                                                   if(c.Next_ApproverId__c=='Finance')
                                                      CaseStatusRecHistory5.Queue_Approver__c=c.Next_ApproverId__c;
                                                   else
                                                      CaseStatusRecHistory5.Approver__c = c.Next_ApproverId__c;
                                                  CaseStatusRecHistory5.Start_Date__c= System.Now();
                                                  insertrecordhistory.add(CaseStatusRecHistory5);
                                             }
                                         }
                                     }
                          }
                    }
                 }
             }
         }
         //insert and update the record history
         if(insertrecordhistory.size()>0 && executeoncetest.insertrecordhisCaseapp)
           {
                insert insertrecordhistory;
                executeoncetest.insertrecordhisCaseapp=false;
           }
        if(updaterecordhistory.size()>0 && executeoncetest.updaterecordhisCaseapp)
        {
            update updaterecordhistory;
            executeoncetest.updaterecordhisCaseapp=false;
        }
     }

     //This will be called only for WRF Cases
     public static void WRFCASES(Map<String,List<Account>> map_list_acc ,Map<String,List<Account>> map_list_pros,Map<String,List<Case>> map_list_case,Map<String,List<User>> map_list_user,Map<Id,Record_History__c> updaterecordhis)
     {
        gBusinessHours();
        KPI_WRF_AccountMain(updaterecordhis);
        Set<Id>objectIds = new set<Id>();
        List<ProcessInstanceWorkitem> list_WorkItems = new List<ProcessInstanceWorkitem>();
        for (Case wrfCase:(List<case>)Trigger.new)
        {
            if((wrfCase.recordTypeId == CaseRecType.get('Work Request').getRecordTypeId())&&(wrfCase.status=='Closed'|| wrfCase.status=='Cancelled'))
            {
                objectIds.add(wrfCase.id);
            }
        }
        if(objectIds.size()>0)
        {
            list_WorkItems =[select Id,ProcessInstance.TargetObjectId from ProcessInstanceWorkitem where ProcessInstance.TargetObjectId in :objectIds and ProcessInstance.Status = 'Pending'];
        }

         for (Case wrfCases:(List<case>)Trigger.new) {
             if (wrfCases.recordTypeId == CaseRecType.get('Work Request').getRecordTypeId()){

                if(Trigger.isBefore && (Trigger.isInsert|| Trigger.isUpdate)) {
                    if(Trigger.IsInsert && Trigger.isBefore){
                        wrfCases.WRF_Date_Time_Assigned__c = System.now();
                        //Check to make sure Account ID passed from click tools
                        if((wrfCases.DUP_Acct_ID__c != null)&&(wrfCases.DUP_Acct_ID__c != '')){
                              wrfCases.AccountId = UpdateAccountID(wrfCases, map_list_acc, map_list_pros);
                        }
                        // Set the parent case if parent id is not set but parent case number is set (for WRF's submitted by non-sfdc users)
                        if(wrfCases.ParentId == null && wrfCases.Related_Case_Number__c != null){
                            List<Case> CaseList = new List<Case>();
                            CaseList = map_list_case.get(wrfCases.Related_Case_Number__c);
                            system.debug('CaseList--------'+CaseList);
                            if(CaseList != null){
                                if (CaseList.size() > 0)
                                  wrfCases.ParentId = CaseList[0].id;
                                else
                                  wrfCases.ParentId = null;
                            }else{
                                wrfCases.ParentId = null;
                            }
                        }//End of Populating Parent case ID
                        // Set the requestor if requestor id is not set but requestor name and employee number is set (for WRF's submitted by non-sfdc users)
                        if(wrfCases.WRF_Requestor__c == null && wrfCases.DUP_Requestor_ID__c != null){
                            List<User> UserList=new List<User>();
                            UserList = map_list_user.get(wrfCases.DUP_Requestor_ID__c);
                             if(UserList != null){
                                if (UserList.size() > 0)
                                  wrfCases.WRF_Requestor__c = UserList[0].id;
                                else
                                  wrfCases.WRF_Requestor__c = null;
                              }else{
                                wrfCases.WRF_Requestor__c = null;
                              }
                        }


                    }
                    if(Trigger.isUpdate && Trigger.isBefore)
                    {
                         Case oldCase =  (Case)Trigger.oldMap.get(wrfCases.Id);
                        //Total time in approval.
                         if(wrfCases.Approval_Start_time__c!=null && wrfCases.Status!='Closed'){

                             wrfCases.Total_Hours_Approval__c= (Businesshours.diff(DefaultBusinessHours_Id,wrfCases.Approval_Start_time__c, System.Now())/(1000*60*60));
                         }
                         if(wrfCases.Approval_Status__c == 'Pending Approval'){
                              if(oldcase.Approval_Status__c == null){
                                  wrfCases.Approval_Date_Time_Assigned__c = System.now();
                              }
                          }
                          if((wrfCases.Approval_Status__c == 'Approved' || wrfCases.Approval_Status__c == 'Rejected' || wrfCases.Approval_Status__c == 'Approval Recalled') && oldCase.Approval_Status__c == 'Pending Approval'){
                             if(wrfCases.WRF_Date_CPM_Launched__c!=null){
                                  wrfCases.Hours_Pending_Approval__c = (oldCase.Hours_Pending_Approval__c == null?0:oldCase.Hours_Pending_Approval__c )+ (Businesshours.diff(DefaultBusinessHours_Id,oldCase.WRF_Date_CPM_Launched__c, System.Now())/(1000*60*60));
                             }
                          }

                          //Set WRF Auto Close Date -- Replace WorkFlow
                          If((wrfCases.Status == 'Awaiting Information')&&((OldCase.Status != 'Awaiting Information'))){
                             wrfCases.Auto_Close_Date__c  = System.today() + 30;
                          }


                    }//End of Updates Before Trigger
                }//End of Before, Insert/Update

                if(Trigger.IsAfter && (Trigger.IsInsert || Trigger.IsUpdate))
                {
                    if(Trigger.IsUpdate)
                    {
                         Case oldCase =  (Case)Trigger.oldMap.get(wrfCases.Id);
                        if((wrfCases.Approval_Status__c=='Approved' || wrfCases.Approval_Status__c=='Rejected' ||
                           wrfCases.Approval_Status__c=='Approval Recalled' || wrfCases.Approval_Status__c=='Pending Approval'
                          ) && (wrfCases.Approval_Status__c !=  oldcase.Approval_Status__c)
                         )
                         {
                           //System.debug('KKJ Old approval status - ' + oldcase.Approval_Status__c + ' new approval status - ' + wrfCases.Approval_Status__c);
                           Case_Map.put(wrfCases.id,wrfCases);
                         }

                        //BEGIN :RECALLING APPROVAL LOGIC
                        if(executeoncetest.recallOnlyOnce)
                        {
                            executeoncetest.recallOnlyOnce=false;
                            Boolean items = false;
                            Approval.ProcessWorkItemRequest pwr ;
                            for(ProcessInstanceWorkitem workItems:list_WorkItems)
                            {
                                pwr = new Approval.ProcessWorkItemRequest();
                                pwr.SetComments('Recalled by system since parent WRF case is closed/cancelled..');
                                pwr.setWorkItemId(workItems.id);
                                pwr.setAction('Removed');
                                items=true;
                            }
                            if(items)
                            {
                                Approval.ProcessResult pr = Approval.process(pwr);

                            }
                        }
                        //END :RECALLING APPROVAL LOGIC

                    }//End of Updates After trigger
                }//End of After, Insert/Update

              }//End of recordtype bifurcation
         }// End of the For Loop

        // Fetch and Update the WRF Task stage based on case approval status
         for(WRF_Task__c wrftask : [select id,WRF_Stage__c,Disposition_Code__c,WRF__c,WRF__r.Approval_Status__c,WRF__r.WRF_Opportunity__r.StageName,WRF__r.CPM_Required__c from WRF_Task__c where recordtype.name = 'WRF Task' and WRF__c IN :Case_Map.keySet() and Disposition_Code__c IN ('Bids', 'Public/GPO') and status__c NOT IN ('Completed', 'Cancelled')])
         {
           String lclStatus = Case_Map.get(wrftask.WRF__c).Approval_Status__c;
           //System.debug('Case Approval Status = ' + wrftask.WRF__c + '-' + lclstatus);
           if(wrftask.WRF__r.WRF_Opportunity__r.StageName != '0%-Lost' && wrftask.WRF__r.CPM_Required__c==true)
           {
               if (lclStatus == 'Pending Approval')
                 wrftask.WRF_Stage__c = 'DOA';
               else if (lclStatus == 'Approved')
                 wrftask.WRF_Stage__c = 'Pending Award';
               else if (lclStatus == 'Rejected'  || lclStatus == 'Approval Recalled')
                 wrftask.WRF_Stage__c = 'DOA Rejected/Recalled';
           }

           lstRelatedTasks.add(wrftask);
         }

         // Update the WRF Tasks
         if(lstRelatedTasks.size() > 0 && executeoncetest.updatewrftaskfromcase)
         {
             executeoncetest.updatewrftaskfromcase =false;
             update lstRelatedTasks;
         }

     } // WRF Case Function ends

     public static void ACCOUNTMAINTANANCE(Map<String,List<Account>> map_list_acc ,Map<String,List<Account>> map_list_pros,Map<String,List<Case>> map_list_case,Map<String,List<User>> map_list_user, Set<ID> set_accountid, Set<Id> case_ids,Map<Id,Record_History__c> updaterecordhis){

         if((Trigger.isBefore  && (Trigger.isInsert || Trigger.isUpdate))) {
                PopulateAM_maps(set_accountid);
          }
          gBusinessHours();
          KPI_WRF_AccountMain(updaterecordhis);

         for (Case acCases:(List<case>)Trigger.new) {
             if (acCases.recordTypeId == CaseRecType.get('Account Maintenance').getRecordTypeId()){
                 //Case oldCase =  (Case)Trigger.oldMap.get(acCases.Id);
                  if(Trigger.isBefore && (Trigger.isInsert|| Trigger.isUpdate)) {

                      if (Trigger.isUpdate && Trigger.isBefore){
                      //System.debug('BEFOREEEEEEEEEEEEEEE------------UPDATEEEE_ACCC');
                      Case oldCase =  (Case)Trigger.oldMap.get(acCases.Id);

                           // Created a time based workflow for the same
                            //Added for the "Auto Close Acct Maint" Workflow as per Case # 00155545 -Begins
                              if((acCases.Status == 'Awaiting Information')&&((OldCase.Status != 'Awaiting Information'))){
                                 acCases.Auto_Close_Date__c  =  date.valueof(Businesshours.add(BusinessHours_Id, system.now(), (40 * 60 * 60 * 1000)));
                              }

                            //Added for the "Auto Close Acct Maint" Workflow as per Case # 00155545 -Ended
                           //Created a time based workflow for the same

                          /*  if(acCases.status == 'Awaiting Information' && acCases.Hours_Awtng_Info_Current__c>=40){
                                acCases.status='Closed';
                             }*/

                             //Total time in approval.
                             if(acCases.Approval_Start_time__c!=null && acCases.Status!='Closed'){
                                 acCases.Total_Hours_Approval__c= (Businesshours.diff(BusinessHours_Id,acCases.Approval_Start_time__c, System.Now())/(1000*60*60));
                             }
                             if(acCases.Approval_Status__c == 'Pending Approval'){
                                  if(oldcase.Approval_Status__c == null){
                                      acCases.Approval_Date_Time_Assigned__c = System.now();
                                  }
                              }
                              //*****************OWNER ASSIGNMENT LOGIC***********************
                              if((map_queue_Id.get(acCases.ownerid)!= null)&&(acCases.ownerid!= oldCase.ownerid )){
                                     acCases.AM_Assigned_To__c = null;
                              }

                                if((map_queue_Id.get(acCases.ownerid)!= null)&&(acCases.ownerid!= oldCase.ownerid )){
                                    acCases.AM_Assigned_To__c = null;
                                }

                                if((String.valueOf(acCases.AM_Assigned_To__c) != String.valueOf(oldCase.AM_Assigned_To__c))){
                                    //We will use this to Caluclate the Time sitting with a Particular Person.
                                    acCases.AM_LastAssignedDate__c = datetime.now();
                                    if (oldCase.AM_Assigned_To__c != null){
                                        if(acCases.AM_Assigned_To1__C != null){
                                            acCases.AM_Assigned_To2__C = String.valueOf(acCases.AM_Assigned_To1__C);
                                            acCases.AM_Hours_Previously_Assigned_To_2__C = acCases.AM_Hours_Previously_Assigned_To_1__C;
                                        }
                                            acCases.AM_Assigned_To1__C = String.valueOf(oldCase.AM_Assigned_To__c);
                                            acCases.AM_Hours_Previously_Assigned_To_1__C = Businesshours.diff(BusinessHours_Id, oldCase.AM_LastAssignedDate__c, datetime.now()) / (1000*60*60);
                                    }

                                }

                     if(acCases.WRF_Request_Type__c != oldCase.WRF_Request_Type__c){

                         String revisit = ' ';
                            if((acCases.parentId != null)&& (acCases.parentId != '')){
                                   revisit =  'Revisit - ';
                            }
                          acCases.Subject = acCases.Description = revisit + acCases.ACCT_Name__c + ' - ' + acCases.WRF_Request_Type__c + ' - ' + acCases.CaseNumber;
                      }

                      }//End of Before Update
                     if (Trigger.isInsert && Trigger.isBefore)
                     {
                         //System.debug('BEFORE---------INSERTTTTTTTTTTTTTTTTTT_ACCC');
                      //Added by Subhro
                      //Account Maintainance approval process GMILL
                      if (acCases.WRF_Source__c == 'GMILL' && acCases.WRF_Requestor__c != null)
                        {
                                // create the new approval request to submit
                                Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                                req.setComments('Auto submitted for approval. Please approve.');
                                req.setObjectId(acCases.Id);
                                // submit the approval request for processing
                                Approval.ProcessResult result = Approval.process(req);
                                // display if the reqeust was successful
                                //System.debug('Submitted for approval successfully: '+result.isSuccess());
                        }
                          acCases.DUP_Acct_Type__c = 'Current Customer';
                          //Check to make sure Account ID passed from click tools
                          if((acCases.DUP_Acct_ID__c != null)&&(acCases.DUP_Acct_ID__c != '')){
                              acCases.AccountId = UpdateAccountID(acCases,map_list_acc,map_list_pros);
                          }
                           // Set the requestor if requestor id is not set but requestor name and employee number is set (for WRF's submitted by non-sfdc users)
                        if(acCases.WRF_Requestor__c == null && acCases.DUP_Requestor_ID__c != null){
                            List<User> UserList=new List<User>();
                            UserList = map_list_user.get(acCases.DUP_Requestor_ID__c);
                             if(UserList != null){
                                if (UserList.size() > 0)
                                  acCases.WRF_Requestor__c = UserList[0].id;
                                else
                                  acCases.WRF_Requestor__c = null;
                              }else{
                                acCases.WRF_Requestor__c = null;
                              }
                        }
                        //**************AM Insert Owner Logic*************************
                                //System.debug('##################################----1')  ;
                         Account account_getmap = new Account();
                         account_getmap= map_case_account.get(acCases.accountid);
                         Case_SLA__c sla_getmap= new Case_SLA__c();
                         if(!test.isrunningtest())
                         {
                             if(acCases.WRF_Request_Type__c != null)
                             {
                                 sla_getmap = map_Case_sla.get(acCases.WRF_Request_Type__c.toUpperCase());
                              }
                         }
                         else
                         {sla_getmap = map_Case_sla.get(acCases.WRF_Request_Type__c); }
                         QueueSobject queue_getmap = new QueueSobject();


                         ///OWNER DRIVING LOGIC FOR ACCOUNT MAINT

                          //Assignement Owner Logic
                         //Rule 1: For the BSD-Pricing and Field Contract, Assign to their Respective Queues
                        // Rule 2: Check if you have Account Name  Yes and Assign to Implementation manager on Account IF not
                        // Rule 3:Go to SLA and Assign it As per the SLA
                        // Rule 4: Else Salesofrce
                             String oStatus ='';
                            //////////////////////////////////////////////////////////////////////////////////////////////
                            // Check if request Type is Matching with the SLA
                            if(sla_getmap!= null){

                                    //Set the Due Date for this Task
                                      if(sla_getmap.Turnaround_Time__c!= null){
                                          acCases.AM_Expected_Due_Date__c = Businesshours.add(BusinessHours_Id, system.now(), Integer.valueof(sla_getmap.Turnaround_Time__c)*60*60*1000);

                                      }else{
                                          acCases.AM_Expected_Due_Date__c=System.now();

                                      }

                                        if((sla_getmap.Routed_to__c == 'BSD Pricing')||(sla_getmap.Routed_to__c == 'Field Contracts Queue')){
                                        //Step1: If the Request Type is to BSD Pricing or Field Contracts Assigned directly to Queueu
                                                oStatus = 'Queue';
                                                acCases.AM_Error_Comment__c = 'SLA is BSD-Pricing/Field Contract, Assign directly to the Queues';
                                        }else{
                                        //Step 2 Check if you have Account on Case
                                                if(account_getmap != null){
                                                    if(account_getmap.Implementation_Manager__c != null  && (acCases.recordTypeId != CaseRecType.get('Account Maintenance').getRecordTypeId()))
                                                    {
                                                        //If the Case requester and Implementation Manager are same then assign it back to queue-----Logic implemented by Wipro Offshore
                                                        if(acCases.WRF_Requestor__c==account_getmap.Implementation_Manager__c)
                                                       {
                                                               if(sla_getmap.Owner_Type__c!= null && sla_getmap.Owner_Type__c =='Queue')
                                                                oStatus = 'Queue';
                                                                else if(sla_getmap.Owner_Type__c!= null && sla_getmap.Owner_Type__c =='User')
                                                                    oStatus = 'User';
                                                                else
                                                                    oStatus = 'DIM';
                                                       }
                                                       else
                                                       {
                                                            // Assign it to Account Implementation manager
                                                            acCases.ownerid = account_getmap.Implementation_Manager__c;
                                                            acCases.AM_Assigned_To__c = account_getmap.Implementation_Manager__c;
                                                            acCases.AM_Error_Comment__c = 'Assigned to implementation Manger on Account';
                                                       }
                                                    }
                                                    else
                                                    {   // As the Implementation manager is Null, SLA object will dictate
                                                        acCases.AM_Error_Comment__c = 'As implementation Manager is Null SLA Dictates';
                                                        if(sla_getmap.Owner_Type__c!= null && sla_getmap.Owner_Type__c =='Queue')
                                                            oStatus = 'Queue';
                                                        else if(sla_getmap.Owner_Type__c!= null && sla_getmap.Owner_Type__c =='User')
                                                            oStatus = 'User';
                                                        else
                                                            oStatus = 'DIM';

                                                    }

                                                }
                                                else{
                                        //Step 3 : SLA Dictates
                                                    acCases.AM_Error_Comment__c = 'As Account  is Null SLA Dictates';
                                                        if(sla_getmap.Owner_Type__c!= null && sla_getmap.Owner_Type__c =='Queue')
                                                            oStatus = 'Queue';
                                                        else if(sla_getmap.Owner_Type__c!= null && sla_getmap.Owner_Type__c =='User')
                                                            oStatus = 'User';
                                                        else
                                                            oStatus = 'DIM';
                                                }

                                        }

                                    }
                            else
                            {// The Request Type In SLA is not Matching Request Type on QUEUE
                                acCases.AM_Error_Comment__c = 'Did not understand the Request Type/ SLA is not existing';
                                oStatus = 'Salesforce';
                            }
                            ///////////////////////////////////////////////////////////////////////////////////////////////////////////
                            //Assign it to Queue
                            if(oStatus == 'Queue'){

                                 queue_getmap = map_queue_sla.get(sla_getmap.Routed_to__c.toUpperCase());
                                 if(queue_getmap!= null)
                                 {
                                     acCases.ownerid=queue_getmap.QueueId;
                                 }else{
                                 // As the Queue is not Present Assigning it the Default Setting - John Rodger
                                    oStatus = 'Salesforce';
                                 }

                            }
                            //Assign it to Specific User Marked in SLA
                            if(oStatus == 'User'){

                                 if(User_sla!= null)
                                 {  if(User_sla.get(sla_getmap.Routed_to__c)!= null){
                                    acCases.ownerid = User_sla.get(sla_getmap.Routed_to__c);
                                    acCases.AM_Assigned_To__c = User_sla.get(sla_getmap.Routed_to__c);
                                 }
                                    else{oStatus = 'DIM';}
                                 }else{oStatus = 'DIM';}

                            }
                            //Assigning it to Default Implementation Manager
                            if(oStatus == 'DIM'){
                                if(ImplementationUser != null){
                                    acCases.ownerid = ImplementationUser.get(0).Id;
                                    acCases.AM_Assigned_To__c = ImplementationUser.get(0).Id;
                                }else{
                                    oStatus = 'Salesforce';
                                }

                            }
                            if(oStatus == 'Salesforce'){
                            // Default Implementation Manager is not found So Assigning it to Salesforce.
                                    acCases.ownerid = '00GE0000000uSg0';// Salesforce ID -> commented out hard-coding
                            }
             /// END OWNER DRIVING LOGIC FOR ACCOUNT MAINT



                       //**************End AM Insert Owner Logic*************************
                       //**************DEFAULT VALUE BEFORE INSERT

                        String revisit = ' ';
                    if((acCases.parentId != null)&& (acCases.parentId != '')){
                           revisit =  'Revisit - ';
                    }
                    //Case Number will no be avaliable in this context
                      acCases.Subject = acCases.Description = revisit + acCases.ACCT_Name__c + ' - ' + acCases.WRF_Request_Type__c + ' - ' + acCases.CaseNumber;
                      acCases.Priority = '3-Medium';

                     }//End of Before INSERT
                     //*************SET WORKFLOW VALUES - DEFAULT********************










                 }//END of Before Insert and Update

             }

         }

         //Trigger.isAfter
         if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)){
           //list_Case = [Select id,recordTypeId,AM_Default_Queue_Email__c, Ownerid from Case where id in:case_ids];
           // update_Case_record = new List<Case>();
           // for(Case AM_Case_alias:list_Case)
            //{
            for(Case AM_Case_alias:(List<case>)Trigger.new){
                   //Updating the Queue Email to Default Field which will be used to Send the Email.
                   QueueSobject queue_getmap1= new QueueSobject();
                   queue_getmap1 = map_queue_Id.get(AM_Case_alias.Ownerid);
                   if(queue_getmap1!= null){
                       AM_Case_alias.AM_Default_Queue_Email__c = queue_getmap1.Queue.email;
                   }
                   else{
                       AM_Case_alias.AM_Default_Queue_Email__c = null;
                   }
                   //update_Case_record.add(AM_Case_alias);
            }
    }//END AFTER INSERT AND UPDATE


     }
     //Connor Flynn 
     //Move this module for ticket: 
     public static void SUPPORT(Map<ID,Profile> ProfileMap,Map<String,QueueSobject > qmap,map<String,User> MapofEmailandUser){

        //Connor Flynn S-437498 (00801298) Adding custom setting
        Map<String, Set<String>> mapRecordTypeToOriginSet = new Map<String, Set<String>>();
        
        for(Case_Origin_Value__mdt caseOrigins : [Select Id, RecordType__c, CaseTrigger__c, Origin_Value__c From Case_Origin_Value__mdt Where CaseTrigger__c = false]){
            if(!caseOrigins.CaseTrigger__c && caseOrigins.RecordType__c != null){
                if(!mapRecordTypeToOriginSet.containsKey(caseOrigins.RecordType__c)){
                    mapRecordTypeToOriginSet.put(caseOrigins.RecordType__c, new Set<String>());
                }
                mapRecordTypeToOriginSet.get(caseOrigins.RecordType__c).add(caseOrigins.Origin_Value__c);
            }
        } 
        ////Connor Flynn S-437498 (00801298) Adding custom setting End
        List<QueueSobject > queueList = [select id,Queue.name from QueueSobject where Queue.Name in ('Savo Queue','Salesprism Queue','SalesOps Queue')];        
         for (Case sCases:(List<case>)Trigger.new) {
             if ((sCases.recordTypeId == CaseRecType.get(Constants.SUPPORT).getRecordTypeId()) ||
                 (sCases.recordTypeId == CaseRecType.get(Constants.IT_CASES).getRecordTypeId()) ||
                 (sCases.recordTypeId == CaseRecType.get(Constants.PARTNER_CASE).getRecordTypeId()) || // Added for Ticket 00694816
                 (sCases.recordTypeId == CaseRecType.get(Constants.ACCOUNT_MAINTENANCE).getRecordTypeId()) || // Added for Ticket 00674983
                 (CaseRecType.containsKey(Constants.ECOMMERCE_FIELD_SUPPORT) && sCases.recordTypeId == CaseRecType.get(Constants.ECOMMERCE_FIELD_SUPPORT).getRecordTypeId()) ||
                 (sCases.recordTypeId == CaseRecType.get(Constants.GT_CASES).getRecordTypeId())){

                     if(Trigger.isBefore && (Trigger.isInsert|| Trigger.isUpdate)) {
                         if((sCases.recordTypeId == CaseRecType.get(Constants.SUPPORT).getRecordTypeId() &&
                            ////Connor Flynn S-437498 (00801298) Adding custom setting
                            (mapRecordTypeToOriginSet.containsKey(Constants.SUPPORT) && mapRecordTypeToOriginSet.get(Constants.SUPPORT).contains(sCases.Origin)) &&
                             //(sCases.Origin=='Global Support' ||
                             // sCases.Origin== 'Email' ||
                             // sCases.Origin== 'RCOE' || // Added for Ticket 00683436
                             // sCases.Origin== 'Deployment' || // Added for Ticket 00694096
                             // sCases.Origin== 'Savo' ||
                             // sCases.Origin== 'Diversity Email' || // Added for Ticket 00694816
                             // sCases.Origin== 'SPC Processing' || // Added for Ticket 00674983
                             // sCases.Origin== 'TAM Solutions' || // Added for Ticket 00758381
                             // sCases.Origin== 'Salesprism') &&
                            //Connor Flynn S-437498 (00801298) Adding custom setting End
                             Trigger.isInsert &&
                             sCases.SuppliedEmail!=null) ||
                            // Added for Ticket 00674983 Start:
                            (sCases.recordTypeId == CaseRecType.get(Constants.ACCOUNT_MAINTENANCE).getRecordTypeId() &&
                                //Connor Flynn S-437498 (00801298) Adding custom setting
                                (mapRecordTypeToOriginSet.containsKey(Constants.ACCOUNT_MAINTENANCE) && mapRecordTypeToOriginSet.get(Constants.ACCOUNT_MAINTENANCE).contains(sCases.Origin)) &&
                                //(sCases.Origin=='ODN General Maint' ||
                                // sCases.Origin== 'General Maint' ) &&
                                //Connor Flynn S-437498 (00801298) Adding custom setting End
                                Trigger.isInsert &&
                                sCases.SuppliedEmail!=null) ||
                            // Added for Ticket 00694816 Start:
                            (sCases.recordTypeId == CaseRecType.get(Constants.PARTNER_CASE).getRecordTypeId() &&
                                //Connor Flynn S-437498 (00801298) Adding custom setting
                                (mapRecordTypeToOriginSet.containsKey(Constants.PARTNER_CASE) && mapRecordTypeToOriginSet.get(Constants.PARTNER_CASE).contains(sCases.Origin)) &&
                                //(sCases.Origin=='Partner Email') &&
                                //Connor Flynn S-437498 (00801298) Adding custom setting End
                                Trigger.isInsert &&
                                sCases.SuppliedEmail!=null) ||
                            // End: Added for Ticket 00674983 
                               (CaseRecType.containsKey(Constants.ECOMMERCE_FIELD_SUPPORT) && sCases.recordTypeId == CaseRecType.get(Constants.ECOMMERCE_FIELD_SUPPORT).getRecordTypeId() &&
                                //Connor Flynn S-437498 (00801298) Adding custom setting
                                (mapRecordTypeToOriginSet.containsKey(Constants.ECOMMERCE_FIELD_SUPPORT) && mapRecordTypeToOriginSet.get(Constants.ECOMMERCE_FIELD_SUPPORT).contains(sCases.Origin)) && 
                                //(sCases.Origin=='eComm Email') &&
                                //Connor Flynn S-437498 (00801298) Adding custom setting End
                                Trigger.isInsert &&
                                sCases.SuppliedEmail!=null) ||
                               (sCases.recordTypeId == CaseRecType.get(Constants.GT_CASES).getRecordTypeId() &&
                                //Connor Flynn S-437498 (00801298) Adding custom setting
                                (mapRecordTypeToOriginSet.containsKey(Constants.GT_CASES) && mapRecordTypeToOriginSet.get(Constants.GT_CASES).contains(sCases.Origin)) &&
                                //(sCases.Origin=='GT Alberta' ||
                                // sCases.Origin=='GT Eastern' ||
                                // sCases.Origin=='GT Ontario' ||
                                // sCases.Origin=='GT Manitoba' ||
                                // sCases.Origin=='GT BC' ||
                                // sCases.Origin=='GT Saskatchewan' ||
                                // sCases.Origin=='GT Admins') &&
                                //Connor Flynn S-437498 (00801298) Adding custom setting End
                                Trigger.isInsert &&
                                sCases.SuppliedEmail!=null)) // Mohamad added sCases.Origin=='Global Support' to the condition per fast track 00302861 and sCases.Origin== 'Savo' per fast track 00304991
                            {
                                User supportreqUser= MapofEmailandUser.get(sCases.SuppliedEmail);
                                if(supportreqUser!=null)
                                {
                                    sCases.Support_Requester__c = supportreqUser.id;
                                }
                                else 
                                    sCases.Support_Requester__c = currentuser;
                            }
                            else if(sCases.Support_Requester__c == null)
                          sCases.Support_Requester__c = currentuser;
                     if(sCases.IT_Environment__c  == null)
                        sCases.IT_Environment__c ='Production';
                     if ((sCases.status == 'New')  && (sCases.Outside_Support_Rep__c != null ||sCases.InsideSupportRep__c != null) && (sCases.IT_Environment__c != 'Test') )    // Added the logic for Test defects as per Production Fix: 00164118
                          sCases.status='In Progress'; // sCases.status changed to In Progress By Mohamad due to Case# 00253759
                     //START S-445696 00833533 [10/12/2016] - Done by OD adding on comment
                     /*if ((sCases.status == 'New' || sCases.status == 'Case Review')  && (sCases.IT_Assignment__c != null ||sCases.IT_BU_Reviewer__c != null) && (sCases.IT_Environment__c != 'Test') )   // Added the logic for Test defects as per Production Fix: 00164118
                          sCases.status=  'Backlog'; */ //Remove the change to Backlog
                     //END  S-445696 00833533 
                     //newCase.IT_Track__c != null &&  -- Removed this code to fix the D10557
                     if (sCases.IT_Classification__c == 'Issue' && !sCases.isClosed && (sCases.IT_Environment__c != 'Test') ){
                         if( (sCases.Priority == '3-Medium'||sCases.Priority == '4-Low')&& sCases.IT_Track__c == 'Production Fix'&& sCases.status != 'Backlog' )  // Added the logic for Test defects as per Production Fix: 00164118
                            sCases.IT_Track__c = 'Fast Track';
                         else if( (sCases.Priority == '1-Critical'||sCases.Priority == '2-High')&& sCases.IT_Track__c != 'Production Fix') {  // Added the logic for Test defects as per Production Fix: 00164118
                            sCases.IT_Track__c = 'Production Fix';
                            sCases.status = 'In Progress';
                            }
                        }

                     Boolean flag = false;
                     if(Trigger.isInsert){
                     //Below is to Replace Support Owner ISOSUPPORT Queue WF Rule
                         if(ProfileMap.get(UserInfo.getProfileId()).Name == 'Inside Sales'){
                             sCases.OwnerId = qmap.get('ISOSUPPORT').Queue.ID;
                         }
                        flag=true;
                      }else{
                        Case oldCase =  (Case)Trigger.oldMap.get(sCases.Id);
                        if (oldCase!=null) {
                            if ((oldCase.IT_Assignment__c == null && oldCase.IT_BU_Reviewer__c == null ) && (sCases.IT_Assignment__c != null || sCases.IT_BU_Reviewer__c != null)) {
                                flag = true;

                            }
                        }
                      }

                      if (flag){
                        if(sCases.IT_Assignment__c != null&& sCases.OwnerId != '00GE0000000U4VA')
                          sCases.OwnerId = '00GE0000000U4VA';
                          //Added sCases.OwnerId != 'Salesprism_Queue' for Case#-721365
                          //Added sCases.OwnerId != 'Savo_Queue' for Case#-731867
                        else if (sCases.IT_BU_Reviewer__c != null && sCases.OwnerId != queueList[0].QueueId && sCases.OwnerId != queueList[1].QueueId && sCases.OwnerId != queueList[2].QueueId)
                        {
                          sCases.OwnerId = System.Label.SalesOps_Queue;

                          system.debug('@@@@@queueList[0].id1111111');
                          }
                     }


                 }//END OF BEFORE INSERT/UPDATE
                 //*******AFTER UPDATES SUPPORT***//
                 if (!Trigger.isBefore){

                    supcases = new set<Id>();
                     if(Trigger.isUpdate){
                     Case oldCase =  (Case)Trigger.oldMap.get(sCases.Id);
                         if (sCases.IT_Assignment__c!=null)
                            if (sCases.IT_Assignment__c != oldCase.IT_Assignment__c )
                              supcases.add(sCases.id);
                      //Sharing Logic
                      //if(sCases.recordTypeId == CaseRecType.get('Support').getRecordTypeId()){
                          case_creator_map.put(sCases.id,sCases.createdbyid);
                          cids.add(sCases.id);
                      //}

                     } else if(sCases.IT_Assignment__c!=null) supcases.add(sCases.id);

                 }


             }//End to check if they are support and It cases
         }//End of For Loop


      if (!Trigger.isBefore){
       //*********Sharing logic after the loop***//
            if(cids.size()>0){
                System.debug('#################'+cids.size());
                c_share = new list<caseshare> ();
                for (ID caseid : cids) {
                    System.debug('==============='+caseid);
                     caseshare cshr = new caseshare();
                     cshr.CaseId = caseid;
                     cshr.UserOrGroupId =  case_creator_map.get(caseid);
                     cshr.caseAccessLevel = 'Edit';
                     c_share.add(cshr);
                    System.Debug('c_share'+c_share);
               }

               Database.SaveResult[] dmlResults = Database.insert(c_share,false);
                System.debug('#########RESULT'+dmlResults[0].ID);

           }
           //*********End of Sharing logic after the loop***//
       }

       if(supcases.size()>0){
       system.debug('@@@@@@@supcases11' + supcases);
             Support_CreateTask(supcases);
             system.debug('@@@@@@@supcases' + supcases);

        }


     }




     @TestVisible private static void Support_CreateTask(set<id> supcases_id){
     System.debug('CREATE TASK IS CALLEDDDDDDDDDDDDDDDDDDDDDDDDDD');
        //Added last where clause by Najma Ateeq for Story #S-377012
        for (Case newCase : [select Id, casenumber,Status, subject,IT_BU_Reviewer__c, IT_Assignment__c  from Case where Id = :supcases_id AND IT_Track__c != 'Sprint']) {
          Task act = new Task();
          String subject = 'Case '+newCase.casenumber+' '+ newCase.subject;

          if((newCase.Status != 'Closed' || newCase.Status != 'Cancelled') && newcase.IT_Assignment__c!=null && newCase.IT_BU_Reviewer__c!= null){
          subject = '#'+newCase.casenumber+' Development - '+ newCase.subject;
          if(subject.length()>230)
            subject = subject.substring(0,230);
          act.Subject =  subject;
          act.Task_Type__C='IT';
          act.Action__C = 'Development';
          act.ownerId = newCase.IT_Assignment__c ;
          act.Status = 'New';
          act.activitydate = system.today().adddays(2);
          act.whatId = newCase.id;
          act.External_Sys_ID__c = newCase.Id;
          act.recordtypeid = TaskRecType.get('Support Task').getRecordTypeId();
          //Start - Added by Najma Ateeq for Story #S-377014
          act.From_Case_Tasking_Process__c = true;
          //End - Added by Najma Ateeq for Story #S-377014
          System.Debug('##**'+act);
          newTasks.add(act);
          }
          else{
          if(subject.length()>230)
            subject = subject.substring(0,230);
          act.Subject =  subject;
          act.Task_Type__C='IT';
          act.Action__C = 'Analysis/Development';
          act.ownerId = newCase.IT_Assignment__c ;
          act.Status = 'New';
          act.activitydate = system.today().adddays(0);
          act.whatId = newCase.id;
          act.External_Sys_ID__c = newCase.Id;
          act.recordtypeid = TaskRecType.get('Support Task').getRecordTypeId();
          //Start - Added by Najma Ateeq for Story #S-377014
          act.From_Case_Tasking_Process__c = true;
          //End - Added by Najma Ateeq for Story #S-377014
          System.Debug('##**'+act);
          newTasks.add(act);
          }
          CaseComment nt= new CaseComment ();
          nt.ParentId = newCase.Id;
          nt.CommentBody = 'This Case has been assigned to Development';
          newNotes.add(nt);

        }

        if(newTasks.size() > 0){
          for(integer  i =0;i<newTasks.size();i++) {
            newTasks[i].External_Sys_ID__c = null;

          }

          executeoncetest.CallAgainCase=false;
          insert newTasks;
          //insert newNotes;
        }

     }//end of Support_CreateTask()

     private static void PopulateAM_maps(Set<ID> set_accountid){
     //*******************Populating the Acount map for Account maintanance***************
          if((Trigger.isBefore  && (Trigger.isInsert || Trigger.isUpdate))) {
             // currentuser_list = [Select id,email from User where id=:currentuser];
              if(set_accountid.size()>0){
                  map_case_account = new Map<Id,Account>([select id,Implementation_Manager__c from account where id in:set_accountid]);
              }
              lst_queue = [Select Id, SobjectType, QueueId, Queue.Name, Queue.email from QueueSobject where SobjectType = 'Case'];
              /*for(User c1:currentuser_list){
                 current_user.put(c1.id,c1);
             }*/
              for(QueueSobject alias_queue:lst_queue){
                //Map key is a case sensitive  -- So changing the Key to Upper case
                //map_queue_sla.put(alias_queue.Queue.Name.toUpperCase(),alias_queue);
                if(!test.isrunningtest()){
                  map_queue_sla.put(alias_queue.Queue.Name.toUpperCase(),alias_queue);
                }else{map_queue_sla.put(alias_queue.Queue.Name,alias_queue); }
                map_queue_Id.put(alias_queue.QueueId,alias_queue);
             }
             lst_sla = [select id,Owner_Type__c,Request_Type__c,Routed_to__c,Turnaround_Time__c,recordtypeid from Case_SLA__c];
              for(Case_SLA__c alias_sla:lst_sla){
                 if(alias_sla.recordTypeId == slarectype.get('Account').getRecordTypeId()){
                    if(!test.isrunningtest()){
                         map_Case_sla.put(alias_sla.Request_Type__c.toUpperCase(),alias_sla);
                         system.debug('@@map_Case_sla'+map_Case_sla);
                    }else{map_Case_sla.put(alias_sla.Request_Type__c,alias_sla); }
                    if(alias_sla.Owner_Type__c =='User')
                        set_userEmpId.add(alias_sla.Routed_to__c);
                }
             }
             sla_users = [select Id,Name,OD_Employee_ID__c from user where OD_Employee_ID__c in:set_userEmpId and IsActive= true];
             for(User su:sla_users){
                  User_sla.put(su.OD_Employee_ID__c,su.Id);
             }
             defaultImplManager = [SELECT Implementation_Manager__c from Acct_Maint__c];
             if(defaultImplManager.size()>0){
                defaultImplManagerEMPID.add(defaultImplManager.get(0).Implementation_Manager__c );
             }
             ImplementationUser = [select Id,Name,OD_Employee_ID__c from user where OD_Employee_ID__c in :defaultImplManagerEMPID and IsActive= true];
          }


     }
     //Start - Added by Jyoti for Story S-407215
     public static void setITStatus(List <Case> newCaseList, Map<Id,Case> oldCaseMap, Boolean isInsertEvent){
         Id ItcaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(Constants.IT_CASES).getRecordTypeId();
         List<Group> grp = new List<Group>([select Id from Group where Name =: Constants.IT_QUEUE  and Type =: Constants.QUEUE ]);

         if(isInsertEvent){
             for(Case cas: newCaseList){
                 //system.assertEquals('' , '' +cas.OwnerId);
                 if(cas.RecordTypeId ==ItcaseRecordTypeId  && (cas.Assign_To__c ==Constants.IT_QUEUE || (grp.size()>0 && cas.OwnerId == grp[0].Id) ||(cas.IT_BU_Reviewer__c != null && cas.IT_Assignment__c !=null))  && (cas.IT_Track__c== Constants.FAST_TRACK  || cas.IT_Track__c== Constants.PRODUCTION_FIX || cas.IT_Track__c== Constants.SPRINT)){
                     cas.IT_Status__c= Constants.NOT_STARTED ;
                 }
             }
         }
         else {

             for(Case cas: newCaseList){
                Case oldCase = oldCaseMap.get(cas.Id);

                if(cas.RecordTypeId == ItcaseRecordTypeId && (cas.IT_Track__c== Constants.FAST_TRACK  || cas.IT_Track__c== Constants.PRODUCTION_FIX || cas.IT_Track__c== Constants.SPRINT)){
                    if((cas.IT_Status__c == null) && (cas.Assign_To__c ==Constants.IT_QUEUE || (grp.size()>0 && cas.OwnerId == grp[0].Id && cas.OwnerId != oldCase.OwnerId) || (cas.IT_BU_Reviewer__c != null && cas.IT_Assignment__c !=null && (cas.IT_BU_Reviewer__c != oldCase.IT_BU_Reviewer__c || cas.IT_Assignment__c != oldCase.IT_Assignment__c)))){
                        cas.IT_Status__c= Constants.NOT_STARTED ;
                    }
                 }
                 if(cas.RecordTypeId == ItcaseRecordTypeId  &&  cas.IT_Status__c != oldCase.IT_Status__c  && cas.IT_Status__c == Constants.NOT_STARTED && oldCase.IT_Status__c!= null){
                    cas.IT_Status__c= oldCaseMap.get(cas.Id).IT_Status__c;
                }

             }
         }

     }
     //End - Story S-407215
     public static void ENDOPERATIONS(){

     }

     public static Id UpdateAccountID(Case newCase,  Map<String,List<Account>> map_list_acc,   Map<String,List<Account>> map_list_pros ){
         ID AccountID = null;
         ID lclAccount ;

         if (newcase.AccountId != null){
            lclAccount = newCase.AccountId;
            AccountID  = newCase.AccountId;
         }

        if (newCase.DUP_Acct_Type__c == 'Current Customer') {
            List<Account> CustList = new List<Account>();
            CustList = map_list_acc.get(newCase.DUP_Acct_ID__c);
                if(CustList != null){
                    if (CustList.size() > 0) {
                        lclAccount = CustList[0].id;
                        AccountID = CustList[0].id;
                      }
                }
        }else {
          if (newCase.DUP_Acct_Type__c == 'New Prospect') {
              List<Account> PrspctList= new List<Account>();
              PrspctList = map_list_pros.get(newCase.DUP_Acct_ID__c);
            if(PrspctList != null){
                if (PrspctList.size() > 0) {
                    lclAccount = PrspctList[0].id;
                    AccountID = PrspctList[0].id;
                }
            }
        }
      }

      return AccountID ;

     }

    //Jeff Timor -> Support: 00624549
    public static void updRVP(List<Case> newLst){
        string rvpID;
        string s = 'VP';
        List<String> usrODid = new List<String>();
        List<Case> ExtTermCases = new List<Case>();
        Map<string,String> mapUsr2RVP = new Map<string,String>();
        Map<string,String> mapODid2Usr = new Map<string,String>();
        for(Case c:newLst){
            IF((c.WRF_Request_Type__c == 'Early Pay Discount Terms Requests' || c.WRF_Request_Type__c == 'Extended Payment Terms Requests') && c.DUP_Requestor_ID__c != null) {
                usrODid.add(c.DUP_Requestor_ID__c);
                ExtTermCases.add(c);
            }
        }
        List<user> popUsr = new List<user>([select id, OD_Employee_ID__c, Title,
                                            ManagerId, Manager.Title,
                                            Manager.ManagerId, Manager.Manager.Title,
                                            Manager.Manager.ManagerId, Manager.Manager.Manager.Title
                                            From User where OD_Employee_ID__c in :usrODid]);
        IF(popUsr.size() > 0){
            for(user u:popUsr){
                IF(u.Title != null) {
                    IF( u.Title.contains(s)) {
                        rvpID = (string)u.Id;
                    } Else IF(u.Manager.Title.contains(s)) {
                        rvpID = (string)u.ManagerId;
                    } Else IF(u.Manager.Manager.Title.contains(s)) {
                        rvpID = (string)u.Manager.ManagerId;
                    } Else IF(u.Manager.Manager.Manager.Title.contains(s)) {
                        rvpID = (string)u.Manager.Manager.ManagerId;
                    } Else {
                        rvpID = null;
                    }
                } Else {
                    rvpID = null;
                }
                mapUsr2RVP.put(u.OD_Employee_ID__c,rvpID);
                mapODid2Usr.put(u.OD_Employee_ID__c,(string)u.Id);
            }

            for(Case c:ExtTermCases){
                c.Regional_VP__c = mapUsr2RVP.get(c.DUP_Requestor_ID__c) != null ? mapUsr2RVP.get(c.DUP_Requestor_ID__c) : null;
                c.Support_Requester__c = mapODid2Usr.get(c.DUP_Requestor_ID__c) != null ? mapODid2Usr.get(c.DUP_Requestor_ID__c) : null;
            }
        }
    }
    //End of Support: 00624549
    //Start of Support: 730056
    public static void updUserHierarchy(){
        IF (runOnce == false ) {
            runOnce = true;
            system.debug('*************************** Inside updUserHierarchy');
            string RT = CaseRecType.get('Work Request').getRecordTypeId();
            set<String> usrODid = new set<String>();
            List<Case> WRFCases = new List<Case>();
            List<Case> UpdWRFCases = new List<Case>();
            Map<string,String> mapUsr = new Map<string,String>(); //Should be (EmployeeIDMANAGERShortTitle, ID for Manager)
            //Connor Flynn
            Boolean isBefore = Trigger.isBefore;
            Boolean isInsert = Trigger.isInsert;
            Boolean isUpdate = Trigger.isUpdate;
            List<Case> newLst = Trigger.new;

            for(Case c:newLst){
                IF(c.RecordTypeId == RT && c.DSM__c == null && c.Regional_Dir__c == null) {
                    if(c.DUP_Requestor_ID__c !=null){
                      usrODid.add(c.DUP_Requestor_ID__c);  
                    }                    
                    WRFCases.add(c);
                    system.debug('***************************' + c.WRF_Requestor__c);
                }
            }
            IF(usrODid.size() > 0 ) {
                List<user> popUsr = new List<user>([select id, Short_title__c,
                                                    ManagerId, Manager.Short_title__c,
                                                    Manager.ManagerId, Manager.Manager.Short_title__c,
                                                    Manager.Manager.ManagerId, Manager.Manager.Manager.Short_title__c,
                                                    Manager.Manager.Manager.ManagerId, Manager.Manager.Manager.Manager.Short_title__c
                                                    From User where OD_Employee_ID__c in :usrODid]);

                List<case> popWRFs = new List<case>([select id, WRF_Requestor__c, DSM__c, Regional_Dir__c
                                                     From case where ID in :WRFCases]);
                IF(popUsr.size() > 0){
                    system.debug('*************************** Inside IF(popUsr.size() > 0)');
                    for(user u:popUsr){
                        system.debug('*************************** Inside for(user u:popUsr)');
                        mapUsr.put(u.Id + u.Short_title__c,u.Id);
                        system.debug('*************************** OD Employee ID + Short Title' + u.Id + u.Short_title__c + ' to: ' + u.Id);
                        mapUsr.put(u.Id + u.Manager.Short_title__c,u.ManagerId);
                        system.debug('*************************** OD Employee ID + Short Title' + u.Id + u.Manager.Short_title__c + ' to: ' + u.ManagerId);
                        mapUsr.put(u.Id + u.Manager.Manager.Short_title__c,u.Manager.ManagerId);
                        system.debug('*************************** OD Employee ID + Short Title' + u.Id + u.Manager.Manager.Short_title__c + ' to: ' + u.Manager.ManagerId);
                        mapUsr.put(u.Id + u.Manager.Manager.Manager.Short_title__c,u.Manager.Manager.ManagerId);
                        system.debug('*************************** OD Employee ID + Short Title' + u.Id + u.Manager.Manager.Manager.Short_title__c + ' to: ' + u.Manager.Manager.Manager.ManagerId);
                        mapUsr.put(u.Id + u.Manager.Manager.Manager.Manager.Short_title__c,u.Manager.Manager.Manager.ManagerId);
                        system.debug('*************************** OD Employee ID + Short Title' + u.Id + u.Manager.Manager.Manager.Manager.Short_title__c + ' to: ' + u.Manager.Manager.Manager.ManagerId);
                    }

                    for(Case c:popWRFs){
                        system.debug('*************************** Inside for(Case c:ExtTermCases)');
                        c.DSM__c = mapUsr.get(c.WRF_Requestor__c + 'DSM') != null ? mapUsr.get(c.WRF_Requestor__c + 'DSM') : null;
                        c.Regional_Dir__c = mapUsr.get(c.WRF_Requestor__c + 'MD') != null ? mapUsr.get(c.WRF_Requestor__c + 'MD') : null;
                        UpdWRFCases.add(c);
                    }
                    Update UpdWRFCases;
                }
            }
        }
    }
    //End of Support: 730056
}//class end
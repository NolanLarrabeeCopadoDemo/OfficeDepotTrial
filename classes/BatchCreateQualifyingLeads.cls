//NAIT-130850 02883861 - Qualifying Deal Data Updates one time batch will be deleted once the Qualifying Deal leads are created
global class BatchCreateQualifyingLeads  implements Database.Batchable<sObject>, Database.Stateful
{
	global list<Id> lstQualifyOppIds;
    global boolean bApplyFilter;
    global string strError;
    global list<String> toAddressesEmail;
    global BatchCreateQualifyingLeads()
    {
        lstQualifyOppIds = new list<Id>();
    	toAddressesEmail = new list<String>();
        bApplyFilter = false;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        string oppStage = 'Qualify';
        Id idTechZoneOppRT = label.TechZoneOppRT;
        id idCustomerOppRT =label.Customer;
        id idCustomerGTOppRT =label.Customer_GT_Record_Type;
        id idProspectOppRT =label.Account_Prospect_Record_Type;
        id idProspectGTOppRT =label.Prospect_GT_Record_Type;
        //string query = 'select id,account.recordtypeId,account.recordtype.Name,OwnerId,Name,Product__c,Product_Subtype__c,Supplier__c,Amount,Primary_Competitor1__c,CloseDate,Customer_Lifecycle__c,Initiatives__c,' +
        //    			'Status__c,AccountId,Current_Provider__c,SystemLeadSource__c,DevicesAnnuityPlacements__c,Project_Ongoing__c,Related_Site__c,RepLeadSource__c,' +
        //    			'Store__c,NextStep,Watson_Notes__c from opportunity where Qualifying_Deal_Lead_Temporary__c = null and stagename=\''+oppStage+'\'';
         string query = 'select id,account.recordtypeId,account.recordtype.Name,OwnerId,Name,Product__c,Product_Subtype__c,Supplier__c,Amount,Primary_Competitor1__c,CloseDate,Customer_Lifecycle__c,Initiatives__c,' +
            			'Status__c,AccountId,Current_Provider__c,SystemLeadSource__c,DevicesAnnuityPlacements__c,Project_Ongoing__c,Related_Site__c,RepLeadSource__c,' +
            			'Store__c,NextStep,Watson_Notes__c from opportunity where Qualifying_Deal_Lead_Temporary__c = null';
        if(bApplyFilter == true )	
        	query += 'and recordtypeid <> :idTechZoneOppRT and (account.recordtypeId = :idProspectGTOppRT or account.recordtypeId = :idProspectOppRT or account.recordtypeId = :idCustomerGTOppRT or account.recordtypeId = :idCustomerOppRT)';
        if(lstQualifyOppIds.size() > 0) query += ' and id in:lstQualifyOppIds';
        system.debug('query : ' + query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC,List<opportunity> scope)
    {
        if(scope != null && scope.size() > 0)
        {
            map<id,lead> mapOppIdNewLead = new map<id,lead>();
            map<id,Opportunity> mapOppIdOpportunity = new map<id,Opportunity>();
            id idProspectGTOppRT =label.Prospect_GT_Record_Type;
            id idCustomerGTOppRT =label.Customer_GT_Record_Type;
            for(opportunity qualifyOpp: scope)
            {
                mapOppIdOpportunity.put(qualifyOpp.Id,qualifyOpp);
                
                string leadLastName=qualifyOpp.Name;
                if(qualifyOpp.Name.length() > 80) leadLastName = qualifyOpp.Name.substring(0, 79);
                
                string strWatsonNotes = qualifyOpp.Watson_Notes__c;
                //if(qualifyOpp.Watson_Notes__c.length() > 2000) strWatsonNotes = qualifyOpp.Watson_Notes__c.substring(0, 1999);
                
                id IdLeadRecordtype = label.Qualifying_Lead_Record_Type;
                string strGTAcc = qualifyOpp.account.recordtype.Name;
                if(strGTAcc.contains('GT'))	IdLeadRecordtype = label.Qualifying_Lead_GT_Record_Type;
                //if(qualifyOpp.account.recordtypeid == idCustomerGTOppRT || qualifyOpp.account.recordtypeid == idProspectGTOppRT)	IdLeadRecordtype = label.Qualifying_Lead_GT_Record_Type;
                
                lead qualLead = new Lead(recordtypeid=IdLeadRecordtype,OwnerId = qualifyOpp.OwnerId,LastName =leadLastName ,Company = qualifyOpp.Name,Product__c = qualifyOpp.Product__c,
                                ProductSubtype__c = qualifyOpp.Product_Subtype__c,Current_Supplier__c = qualifyOpp.Supplier__c,Amount__c = qualifyOpp.Amount,
                                PrimaryCompetitor__c = qualifyOpp.Primary_Competitor1__c,Estimated_Close_Date__c = qualifyOpp.CloseDate,LeadLifecycle__c = qualifyOpp.Customer_Lifecycle__c,
                                Initiatives__c = qualifyOpp.Initiatives__c,Status = qualifyOpp.Status__c,Account__c = qualifyOpp.AccountId,CurrentProvider__c = qualifyOpp.Current_Provider__c,
                                SystemLeadSource__c = qualifyOpp.SystemLeadSource__c,DevicesAnnuityPlacements__c = qualifyOpp.DevicesAnnuityPlacements__c,ProjectOngoing__c = qualifyOpp.Project_Ongoing__c,
                                Related_Site__c = qualifyOpp.Related_Site__c,Rep_Lead_Source__c = qualifyOpp.RepLeadSource__c,Store__c = qualifyOpp.Store__c,
                                NextStep__c = qualifyOpp.NextStep,Notes__c = strWatsonNotes);
                
                mapOppIdNewLead.put(qualifyOpp.id,qualLead);
            }
            
            if(mapOppIdNewLead.size() > 0)
            {
                
                	insert mapOppIdNewLead.values();//Insert Qualify Lead from opportunity
                    
                    //Start: Insert Attachment from opportunity on qualify lead

                    list<attachment> lstNewLeadAttachment = new list<attachment>();
                    for(Attachment oppAtt: [SELECT Id,Name,ParentId,ContentType, Description, IsPartnerShared, IsPrivate, Body FROM Attachment WHERE ParentId IN: mapOppIdNewLead.keyset()])
                    {
                        id OppId = oppAtt.ParentId;
                        attachment leadAtt  = oppAtt.clone(false);
                        leadAtt.ParentId = mapOppIdNewLead.get(OppId).id;
                        lstNewLeadAttachment.add(leadAtt);
                    }
                    if(lstNewLeadAttachment.size() > 0)
                    {
                        insert lstNewLeadAttachment;
                    }
                    
                    //Start: Insert Notes from opportunity on qualify lead
                    
                    list<Note> lstNewLeadNote =  new list<Note>();
                    for(Note oppNote: [SELECT Id,ParentId,Title,IsPrivate, Body FROM Note WHERE ParentId IN: mapOppIdNewLead.keyset()])
                    {
                        id OppId = oppNote.ParentId;
                        Note leadNote  = oppNote.clone(false);
                        leadNote.ParentId = mapOppIdNewLead.get(OppId).id;
                        lstNewLeadNote.add(leadNote);
                    }
                    if(lstNewLeadNote.size() > 0)
                    {
                        insert lstNewLeadNote;
                    }
                    //End: Insert Notes from opportunity on qualify lead
                    
                    //Start: Insert Task from opportunity on qualify lead
                    
                    list<Task> lstNewLeadTask =  new list<Task>();
                    for(Task oppTask: [Select AccountId, AccountManagement_ActionPlan__c, Account_Management_Rating__c, Account_Org__c,Account__c , Action__c,
                                       ActivityDate, Actual_LOE__c, Address_Id__c,  Anticipated_Decision_Date__c, Anticipated_RFP_Date__c, 
                                       Appointment_FiscalMonth__c, Appointment_FiscalYear__c, Appointment_Fiscal_Month__c, Areas_for_Improvement__c, 
                                       Assigned_Call_Date__c, Assignment_Group__c, Attended_Weekly_Meeting__c, BOT_Leverage__c, Batch_Id__c, CallDisposition,
                                       CallDurationInSeconds, CallObject, CallType, Call_Disposition__c, Close_Reason__c, Commitment_1__c, Commitment_2__c, 
                                       Commitment_3__c, Complete__c,  ConnectionReceivedId, ConnectionSentId, Contract_Expiration_Date__c,
                                       Contract_Extension_Terms__c,  Created_By_Role__c, Current_Supplier__c, Cust_Account_Id__c, 
                                       Customer_Id__c, DB_Activity_Type__c, Description, Disposition_Code__c, Disposition_Date__c, Estimated_LOE__c, 
                                       Event_Account_Extension__c,  External_Sys_ID__c, From_Case_Tasking_Process__c, Global_Leverage__c, ILC_Batch__c,
                                       IT_TASK_TYPE__c, Id, International_Existing__c, International_Opportunities__c, IsArchived, IsClosed, IsDeleted, IsHighPriority,
                                       IsRecurrence, IsReminderSet, IsVisibleInSelfService, Is_ILC_Rep__c, Knowledge_ActionPlan__c, Knowledge_Skills_Rating__c,
                                        Legacy_CreatedBy__c, Legacy_CreatedDate__c, Legacy_LastModifiedBy__c, 
                                       Legacy_LastModifiedDate__c, Met_Last_Weeks_Commitments__c, No_Action_Required__c, OMX_Primary_Key__c, Oracle_Task_Id__c,
                                       Oracle_Task_Number__c, Oracle_Task_pk__c, Org__c, Outcome__c, OverallRating_ActionPlanComment__c, Overall_Rating__c, OwnerId,
                                       Primary_Campaign_Source__c, Priority, Product_Category__c, Profile_Name__c, Propose_Opportunity_Action_Plan__c, 
                                       Pursue_Opportunity_Action_Plan__c, RecordTypeId, Record_Id__c, RecurrenceActivityId, RecurrenceDayOfMonth, 
                                       RecurrenceDayOfWeekMask, RecurrenceEndDateOnly, RecurrenceInstance, RecurrenceInterval, RecurrenceMonthOfYear, 
                                       RecurrenceRegeneratedType, RecurrenceStartDateOnly, RecurrenceTimeZoneSidKey, RecurrenceType, ReminderDateTime, 
                                       SalesSkills_ActionPlan__c, Sales_Skills_Rating__c, Source_System__c, State__c, StaticText_AccountManagement1__c, 
                                       StaticText_AccountManagement2__c, StaticText_Knowledge1__c, StaticText_Knowledge2__c, StaticText_OverallRating2__c, 
                                       StaticText_SalesSkills1__c, StaticText_SalesSkills2__c, Status, Strategic_Focus_Plan_1__c, Strategic_Focus_Plan_2__c, Subject,
                                       SystemModstamp, TaskSubtype, Task_Type__c, Type, VP_in_Attendance__c, Verbal_Win_Opportunity_Action_Plan__c,
                                       WRF_Task_Await_Action_Dt__c, WRF_Task_Complete_Dt__c, WRF_Task_Complete__c, WRF_Task_Final_Review_Dt__c, 
                                       WRF_Task_In_Progress_Dt__c, WRF_Task_Team_Review_Dt__c, WRF_Task_Under_Review_Dt__c, WhatCount, WhatId, What_Went_Well__c, 
                                       WhoCount, WhoId, X3_Commitments_to_Impact_Results__c FROM Task where whatid in: mapOppIdNewLead.keyset()])
                    {
                        id OppId = oppTask.WhatId;
                        Task leadTask  = oppTask.clone(false);
                        leadTask.whatid=null;
                        leadTask.WhoId = mapOppIdNewLead.get(OppId).id;
                        if(oppTask.IsRecurrence ==false && oppTask.RecurrenceActivityId==null)
                        lstNewLeadTask.add(leadTask);
                    }
                    if(lstNewLeadTask.size() > 0)
                    {
                        insert lstNewLeadTask;
                    }
                    //End: Insert Task from opportunity on qualify lead 
                    
                    //Start: Insert Event from opportunity on qualify lead
                    
                    list<Event> lstNewLeadEvent =  new list<Event>();
                    for(Event oppEvent: [SELECT AccountId,AccountManagement_ActionPlan__c,Account_Management_Rating__c,Account_Org__c,Account__c,Action__c,
                                         ActivityDate,ActivityDateTime,Actual_LOE__c,Address_Id__c,Anticipated_Decision_Date__c,Anticipated_RFP_Date__c,
                                         Appointment_FiscalMonth__c,Appointment_FiscalYear__c,Appointment_Fiscal_Month__c,Areas_for_Improvement__c,
                                         Assigned_Call_Date__c,Assignment_Group__c,Attended_Weekly_Meeting__c,Batch_Id__c,BOT_Leverage__c,Call_Disposition__c,
                                         ClientGuid,Close_Reason__c,Commitment_1__c,Commitment_2__c,Commitment_3__c,Complete__c,Contract_Expiration_Date__c,
                                         Contract_Extension_Terms__c,Created_By_Role__c,Current_Supplier__c,Customer_Id__c,Cust_Account_Id__c,DB_Activity_Type__c,
                                         Description,Disposition_Code__c,Disposition_Date__c,DurationInMinutes,EndDate,EndDateTime,Estimated_LOE__c,EventSubtype,
                                         Event_Account_Extension__c,External_Sys_ID__c,From_Case_Tasking_Process__c,Global_Leverage__c,GroupEventType,Id,ILC_Batch__c,
                                         International_Existing__c,International_Opportunities__c,IsAllDayEvent,IsArchived,IsChild,IsClientManaged,IsDeleted,
                                         IsException,IsGroupEvent,IsPrivate,IsRecurrence,IsRecurrence2,IsRecurrence2Exception,IsRecurrence2Exclusion,IsReminderSet,
                                         IsVisibleInSelfService,Is_ILC_Rep__c,IT_TASK_TYPE__c,Knowledge_ActionPlan__c,Knowledge_Skills_Rating__c,Legacy_CreatedBy__c,
                                         Legacy_CreatedDate__c,Legacy_LastModifiedBy__c,Legacy_LastModifiedDate__c,Location,Met_Last_Weeks_Commitments__c,
                                         No_Action_Required__c,OMX_Primary_Key__c,Oracle_Task_Id__c,Oracle_Task_Number__c,Oracle_Task_pk__c,Org__c,
                                         OriginalInstanceDateTime,Outcome__c,OverallRating_ActionPlanComment__c,Overall_Rating__c,OwnerId,Primary_Campaign_Source__c,
                                         Product_Category__c,Profile_Name__c,Propose_Opportunity_Action_Plan__c,Pursue_Opportunity_Action_Plan__c,RecordTypeId,
                                         Record_Id__c,Recurrence2PatternStartDate,Recurrence2PatternText,Recurrence2PatternTimeZone,Recurrence2PatternVersion,
                                         RecurrenceActivityId,RecurrenceDayOfMonth,RecurrenceDayOfWeekMask,RecurrenceEndDateOnly,RecurrenceInstance,RecurrenceInterval,
                                         RecurrenceMonthOfYear,RecurrenceStartDateTime,RecurrenceTimeZoneSidKey,RecurrenceType,ReminderDateTime,
                                         SalesSkills_ActionPlan__c,Sales_Skills_Rating__c,ShowAs,Source_System__c,StartDateTime,State__c,
                                         StaticText_AccountManagement1__c,StaticText_AccountManagement2__c,StaticText_Knowledge1__c,StaticText_Knowledge2__c,
                                         StaticText_OverallRating2__c,StaticText_SalesSkills1__c,StaticText_SalesSkills2__c,Strategic_Focus_Plan_1__c,
                                         Strategic_Focus_Plan_2__c,Subject,SystemModstamp,Task_Type__c,Type,Verbal_Win_Opportunity_Action_Plan__c,
                                         VP_in_Attendance__c,WhatCount,WhatId,What_Went_Well__c,WhoCount,WhoId,WRF_Task_Await_Action_Dt__c,WRF_Task_Complete_Dt__c,
                                         WRF_Task_Complete__c,WRF_Task_Final_Review_Dt__c,WRF_Task_In_Progress_Dt__c,WRF_Task_Team_Review_Dt__c,
                                         WRF_Task_Under_Review_Dt__c,X3_Commitments_to_Impact_Results__c FROM Event where whatid in: mapOppIdNewLead.keyset()])
                    {
                        id OppId = oppEvent.WhatId;
                        Event leadEvent  = oppEvent.clone(false);
                        leadEvent.whatid=null;
                        leadEvent.whoId = mapOppIdNewLead.get(OppId).id;
                        if(oppEvent.IsRecurrence ==false && oppEvent.RecurrenceActivityId==null)
                        	lstNewLeadEvent.add(leadEvent);
                    }
                    if(lstNewLeadEvent.size() > 0)
                    {
                        insert lstNewLeadEvent;
                    }
                    //End: Insert Event from opportunity on qualify lead 
                    
                    //Start: Update qualify opportunity records with newly created lead Id
                    
                    for(id leadOppId: mapOppIdNewLead.keyset())
                    {
                        mapOppIdOpportunity.get(leadOppId).Qualifying_Deal_Lead_Temporary__c = mapOppIdNewLead.get(leadOppId).Id;
                    }
                    
                    update mapOppIdOpportunity.values();
                    
        			//End: Update qualify opportunity records with newly created lead Id
                
            }
        }        
    }
    
    global void finish(Database.BatchableContext BC)
    {
        
    }
}
trigger CaseApproval on Case (after insert, after update, before update) {
    
    Map<String,Schema.RecordTypeInfo> CaseRecType = Schema.SObjectType.Case.getRecordTypeInfosByName();    
    
    
    Schema.DescribeSObjectResult d1 = Schema.SObjectType.Case;
    Map<String, Schema.RecordTypeInfo> caseRecordTypes = d1.getRecordTypeInfosByName();
    Id businessHoursId = Label.Default_BusinessHours_Id;
    List<Record_History__c> insertRecordHistories = new List<Record_History__c>();
    List<Record_History__c> updateRecordHistories = new List<Record_History__c>();
    Set<Id> caseIds = new Set<Id>();
    Id omxRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer (OfficeMax)').getRecordTypeId();

    if (Trigger.isBefore) {
        
        
    
        
        if (Trigger.isUpdate) {
            for (Case newCase: Trigger.new) {
                
                If(newCase.recordTypeId == CaseRecType.get('Order Case').getRecordTypeId() || newCase.recordTypeId == CaseRecType.get('Supplier').getRecordTypeId())
                {
                    System.debug('Bypass');
                } else {
                    if (newCase.WRF_Link_to_RFP__c == 'Yes' && newCase.Account_RecordtypeId__C == omxRecordTypeId) {
                    newCase.WRF_Request_Type__c = 'Transition';
                }
                caseIds.add(newCase.id);
                
                }

                
            }
        }

        Map<Id, Record_History__c> updateRecordHistoryIds = new Map<Id, Record_History__c> ();
        for (Record_History__c rec: [Select id, Start_Date__c, End_Date__c, Approver__c, No_of_Hours__c, Case__c, WRF_Task__c from Record_History__c where Case__c in : caseIds and Start_Date__c != null and End_Date__c = null and WRF_Task__c = null]) {
            updateRecordHistoryIds.put(rec.Case__c, rec);
        }

        for (Case newCase: Trigger.new) {
            
            If(newCase.recordTypeId == CaseRecType.get('Order Case').getRecordTypeId() || newCase.recordTypeId == CaseRecType.get('Supplier').getRecordTypeId())
                {
                    System.debug('Bypass');
                } else {
            
            Case oldCase = Trigger.oldMap.get (newCase.Id);
            if (newCase.recordTypeId == caseRecordTypes.get('Work Request').getRecordTypeId()) {
                if ((newCase.Approval_Status__c == 'Approved' || newCase.Approval_Status__c == 'Rejected' || newCase.Approval_Status__c == 'Approval Recalled') && oldCase.Approval_Status__c == 'Pending Approval') {
                    if (newCase.WRF_Date_CPM_Launched__c != null) {
                        newCase.Hours_Pending_Approval__c = (oldCase.Hours_Pending_Approval__c == null ? 0 : oldCase.Hours_Pending_Approval__c) + (Businesshours.diff (businessHoursId, oldCase.WRF_Date_CPM_Launched__c, System.Now ()) / (1000 * 60 * 60));
                    }
                }
                if (newCase.Approval_Status__c == 'Pending Approval' && oldCase.Approval_Status__c == null) {
                    Record_History__c caseStatusRecordHistory = new Record_History__c ();
                    caseStatusRecordHistory.Case__c = newCase.id;
                    if (newCase.Next_ApproverId__c == 'Finance')
                        caseStatusRecordHistory.Queue_Approver__c = newCase.Next_ApproverId__c;
                    else
                        caseStatusRecordHistory.Approver__c = newCase.Next_ApproverId__c;
                    caseStatusRecordHistory.Start_Date__c = System.Now ();
                    insertRecordHistories.add (caseStatusRecordHistory);
                }
                if ((oldCase.Approval_Status__c == 'Approved' || oldCase.Approval_Status__c == 'Rejected' || oldCase.Approval_Status__c == 'Approval Recalled') && newCase.Approval_Status__c == 'Pending Approval') {
                    Record_History__c caseStatusRecordHistory = new Record_History__c ();
                    caseStatusRecordHistory.Case__c = newCase.id;
                    if (newCase.Next_ApproverId__c == 'Finance')
                        caseStatusRecordHistory.Queue_Approver__c = newCase.Next_ApproverId__c;
                    else
                        caseStatusRecordHistory.Approver__c = newCase.Next_ApproverId__c;
                    caseStatusRecordHistory.Start_Date__c = System.Now ();
                    insertRecordHistories.add (caseStatusRecordHistory);
                }
                if (oldCase.Approval_Status__c == 'Pending Approval') {

                    if (newCase.Compliance_Mgr_Action_Date__c != oldCase.Compliance_Mgr_Action_Date__c || newCase.DSM_Action_Date__c != oldCase.DSM_Action_Date__c || newCase.Strategy_Director_Action_Date__c != oldCase.Strategy_Director_Action_Date__c ||
                        newCase.RSD_Action_Date__c != oldCase.RSD_Action_Date__c || newCase.Public_Sector_VP_Action_Date__c != oldCase.Public_Sector_VP_Action_Date__c || newCase.Finance_Action_Date__c != oldCase.Finance_Action_Date__c || newCase.Sr_Strategy_Dir_Action_Date__c != oldCase.Sr_Strategy_Dir_Action_Date__c ||
                        newCase.RVP_Action_Date__c != oldCase.RVP_Action_Date__c || newCase.VP_Sales_Ops_Action_Date__c != oldCase.VP_Sales_Ops_Action_Date__c || newCase.Finance_Dir_Action_Date__c != oldCase.Finance_Dir_Action_Date__c || newCase.Field_Sales_VP_Action_Date__c != oldCase.Field_Sales_VP_Action_Date__c || newCase.SVP_Action_Date__c != oldCase.SVP_Action_Date__c || newCase.Approval_Status__c == 'Approval Recalled') {
                        Record_History__c caseStatusRecordHistory = updateRecordHistoryIds.get(newCase.id);
                        if (caseStatusRecordHistory != null) {
                            caseStatusRecordHistory.End_Date__c = System.now ();
                            caseStatusRecordHistory.No_of_Hours__c = (Businesshours.diff (businessHoursId, caseStatusRecordHistory.Start_Date__c, System.Now ()) / (1000 * 60 * 60));
                            caseStatusRecordHistory.Actual_Approver__c = UserInfo.getuserid();
                            updateRecordHistories.add (caseStatusRecordHistory);

                            if (newCase.Next_ApproverId__c != null) {
                                Record_History__c caseStatusRecHistory1 = new Record_History__c ();
                                caseStatusRecHistory1.Case__c = newCase.id;
                                if (newCase.Next_ApproverId__c == 'Finance') {
                                    caseStatusRecHistory1.Queue_Approver__c = newCase.Next_ApproverId__c;
                                } else {
                                    caseStatusRecHistory1.Approver__c = newCase.Next_ApproverId__c;
                                }
                                caseStatusRecHistory1.Start_Date__c = System.Now();
                                insertRecordHistories.add(caseStatusRecHistory1);
                            }
                        }
                    }
                }
            }
        }
        if (insertRecordHistories.size () > 0 && executeoncetest.insertrecordhisCaseapp) {
            insert insertRecordHistories;
            executeoncetest.insertrecordhisCaseapp = false;
        }
        if (updateRecordHistories.size () > 0 && executeoncetest.updaterecordhisCaseapp) {
            update updateRecordHistories;
            executeoncetest.updaterecordhisCaseapp = false;
        }
    }
    }

    // Logic for WRF Task Stage update starts here 
    if (Trigger.isAfter && Trigger.isUpdate) {
        Map<Id, Case> cases = new Map<Id, Case>();
        List<WRF_Task__c> wrfRelatedTasks = new List<WRF_Task__c> ();

        for (Case newCase : Trigger.New) {
            
            If(newCase.recordTypeId == CaseRecType.get('Order Case').getRecordTypeId() || newCase.recordTypeId == CaseRecType.get('Supplier').getRecordTypeId())
                {
                    System.debug('Bypass');
                } else {
            
            Case oldCase = Trigger.oldMap.get (newCase.Id);
            if ((newCase.Approval_Status__c == 'Approved' || newCase.Approval_Status__c == 'Rejected' ||
                newCase.Approval_Status__c == 'Approval Recalled' || newCase.Approval_Status__c == 'Pending Approval')
                && (newCase.Approval_Status__c != oldCase.Approval_Status__c)) {
                cases.put(newCase.id, newCase);
            }
        }}
        // Fetch and Update the WRF Task stage based on Case approval status
        for (WRF_Task__c wrftask: [select id, WRF_Stage__c, Disposition_Code__c, WRF__c, WRF__r.Approval_Status__c from WRF_Task__c
                where recordtype.name = 'WRF Task'
                and WRF__c IN : cases.keySet () and
                Disposition_Code__c IN ('Bids', 'Public/GPO', 'OD N Remediation', 'OD N Bid', 'Remediation', 'MPS Implementation', 'Transition', 'Tech Depot') and status__c NOT IN ('Completed', 'Cancelled')
            ]) {

            String lclStatus = cases.get (wrftask.WRF__c).Approval_Status__c;

            if (lclStatus == 'Pending Approval') {
                wrftask.WRF_Stage__c = 'DOA';
            } else if (lclStatus == 'Approved') {
                wrftask.WRF_Stage__c = 'Pending Award';
            } else if (lclStatus == 'Rejected' || lclStatus == 'Approval Recalled') {
                wrftask.WRF_Stage__c = 'DOA Rejected/Recalled';
            }

            wrfRelatedTasks.add (wrftask);
        }

        // Update the WRF Tasks    
        if (wrfRelatedTasks.size () > 0) {
            update wrfRelatedTasks;
        }
    }
    

    if (Trigger.isInsert) {
        for (Integer i = 0; i < Trigger.new.size (); i++) {
            if (((Trigger.new[i].recordTypeId) == (caseRecordTypes.get ('Account Maintenance').getRecordTypeId ())) &&
                (Trigger.new[i].WRF_Source__c == 'GMILL') &&
                (Trigger.new[i].WRF_Requestor__c != null)) {

                // Create the new approval request to submit
                Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest ();
                req.setComments ('Auto submitted for approval. Please approve.');
                req.setObjectId (Trigger.new[i].Id);
                // Submit the approval request for processing
                Approval.ProcessResult result = Approval.process (req);
                // Display if the reqeust was successful
            }
        }
    }
}
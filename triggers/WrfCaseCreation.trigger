trigger WrfCaseCreation on Case(after insert)
{
    Map<String, Schema.RecordTypeInfo> caseRecordType = Schema.SObjectType.Case.getRecordTypeInfosByName();
    List<Case> casesToSave = new List<Case>();
    List<Case> tasklist_aggdisp = new List<Case>();
    List<Case> tsklstRepDispCRFPRec = new List<Case>();
    Map<ID, ID> accountIdsAndWRFIds = new Map<ID, ID>();
    List<Case> casesToCreate = new List<Case>();
    List<Case> hostedCases = new List<Case>();
    List<Case> leaderCases = new List<Case>();



    for (Case newCase : Trigger.new)
    {
        if (newCase.recordTypeId == caseRecordType.get('Work Request').getRecordTypeId() && newCase.WRF_Request_Type__c == 'Hosted Catalog Update')
        {    
            hostedCases.add(newCase);
            WRFtaskCreation wrfTaskCreation = new WRFtaskCreation();
            wrfTaskCreation.hostedWrfCreation(hostedCases);
        }
        
        //Story - NAIT-109874 Start
         if (newCase.recordTypeId == caseRecordType.get('Work Request').getRecordTypeId() && newCase.WRF_Request_Type__c == 'Leader/Follower SKU Change')
        {
            leaderCases.add(newCase);
            WRFtaskCreation wrfTaskCreation = new WRFtaskCreation();
            wrfTaskCreation.leaderWrfCreation(leaderCases);
        }
        //Story - NAIT-109874 End
        if (newCase.recordTypeId == caseRecordType.get('Work Request').getRecordTypeId() && newCase.WRF_Link_to_RFP__c == 'Yes' && newCase.AccountId != null)
        {
            accountIdsAndWRFIds.put(newCase.AccountId, newCase.Id);
        }
        if (newCase.recordTypeId == caseRecordType.get('Work Request').getRecordTypeId() && newCase.WRF_Request_Type__c == 'Transition')
        {
            if (newCase.isCreatedCustomerCore__C == true)
            {
                casesToSave.add(newCase);
            }
            else if (newCase.subject != null && newCase.subject != '')
            {
                if (newCase.subject.equals('Customer RFP Received Disposition Request'))
                {
                    tsklstRepDispCRFPRec.add(newCase);
                }
                else if (newCase.subject.equals('Extend current OMX Agreement Disposition Request'))
                {
                    tasklist_aggdisp.add(newCase);
                }
                else
                {
                    casesToSave.add(newCase);
                }
            }
            else
            {
                casesToSave.add(newCase);
            }
        }
    }

    WRFtaskCreation wrfTaskCreation = new WRFtaskCreation();

    if (casesToSave.size() > 0)
        wrfTaskCreation.WrfCreation(casesToSave);
        
    if (tasklist_aggdisp.size() > 0)
        wrfTaskCreation.taskaggdisp(tasklist_aggdisp);
        
    if (casesToCreate.size() > 0)
        wrfTaskCreation.createCustomCoreRequest(casesToCreate);
        
    if (tsklstRepDispCRFPRec.size() > 0)
        wrfTaskCreation.taskRepDispCRFPRec(tsklstRepDispCRFPRec);
        
    if (accountIdsAndWRFIds != null && accountIdsAndWRFIds.size() > 0)
        RFPCaseOperation.updateCTrepDesp(accountIdsAndWRFIds);
}
// Appirio 2015
// Universal trigger handler for CPM__c object
//
// NBOCK - Original - S-364743 - consolidation of CPM_Trigger and caseApprovalStatus trigger on CPM object

public class CPMTriggerHandler{
    public CPM__c[] newLst = new CPM__c[]{};
    public CPM__c[] oldLst = new CPM__c[]{};
    public Map <ID, CPM__c> newMap = new Map<ID, CPM__c>{};
    public Map <ID, CPM__c> oldMap = new Map<ID, CPM__c>{};

    public CPMTriggerHandler(CPM__c[] triggered, CPM__c[] triggeredFrom, Map<ID,CPM__c> triggerNewMap, Map<ID,CPM__c> triggerOldMap){
        newLst = triggered;
        oldLst = triggeredFrom;
        newMap = triggerNewMap;
        oldMap = triggerOldMap;
    }

    public void onBeforeInsert(){
        cpmScenarioGT();
    }

    public void onAfterInsert(){
        caseApprovalStatus();
    }

    public void onBeforeUpdate(){
        nextApproverId();
    }

    public void onAfterUpdate(){
        caseApprovalStatus();
    }
    
    public void onBeforeUpsert(List<CPM__c> cpmList) {
        System.debug('CPMTriggerHandler > onBeforeUpsert');
        
        // Assign Account Extension
        List<Id> acctIds = new List<Id>();

        for (CPM__c cpm : cpmList) {
            Id acctId = cpm.Account_Name__c;
            
            if (acctId != null) {
                acctIds.add(acctId);
            }
        }
        
        Map<Id, Id> accountIdToExtensionId = (new AccountExtensionHelper()).getAccountExtensionIds(acctIds); 
        System.debug('CPMTriggerHandler > accountIdToExtensionId.size() = ' + accountIdToExtensionId.size());
        
        for (CPM__c cpm : cpmList) {
            Id acctId = cpm.Account_Name__c;
            cpm.Extension_Account_Name__c = accountIdToExtensionId.get(acctId);
        }
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

    //case approval status method
    public void caseApprovalStatus(){
        Set<ID> casesIds = new Set<ID>();
        for(CPM__c wtsk : newLst){
          casesIds.add(wtsk.support_number__c);
        }

        List<Case> casesList = [Select id,Approval_Status__c, Pricing_Analyst__c  from case where id in :casesIds];
        List<Case> updatedcasesList = new List<Case>();
        List<cpm__c> cpms=[SELECT support_number__c,id,name,Scenario__c , Version__c,Approval_Status__c, Pricing_Analyst__c FROM cpm__c where support_number__c in :casesIds order by version__c desc];
        Map<id,List<cpm__c>> cpmCases = new Map<id,List<cpm__c>> ();

        if(!(cpms.isEmpty())){
          for(cpm__c eachCpm: cpms){
            List<cpm__c> cpmList= new List<cpm__c>();
            cpmList.add(eachCpm);

            if (cpmCases.containsKey(eachCpm.support_number__c)){
              cpmCases.get(eachCpm.support_number__c).add(eachCpm);
            }
            else{
              cpmCases.put(eachCpm.support_number__c,cpmList);
            }
          }

          for(Case eachCase: casesList){
            List<cpm__c> eachCpmList= cpmCases.get(eachCase.id);
            Map<String,String> updatedVersion = new Map<String,String>();
              Map<ID,String> updatedWRFPA = new Map<ID,String>(); //Support Number:00665304 Code Added

            for(cpm__c eachCpm : eachCpmList){
              if (updatedVersion.containsKey(String.valueOf(eachCpm.Scenario__c))){
                List<String>status = updatedVersion.get(String.valueOf(eachCpm.Scenario__c)).split(' - ');
                Integer ver=Integer.valueOf(status[0]);

                if(eachCpm.Version__c > ver){
                  updatedVersion.put(String.valueOf(eachCpm.Scenario__c),eachCpm.Version__c+' - '+eachCpm.Approval_Status__c);
                    updatedWRFPA.put(eachCpm.ID,String.valueOf(eachCpm.Pricing_Analyst__c));
                    updatedWRFPA.put(eachCpm.ID,String.valueOf(eachCpm.Pricing_Analyst__c)); //Support Number:00665304 Code Added

                }
              }
              else{
                updatedVersion.put(String.valueOf(eachCpm.Scenario__c),eachCpm.Version__c+' - '+eachCpm.Approval_Status__c);
                  updatedWRFPA.put(eachCpm.ID,String.valueOf(eachCpm.Pricing_Analyst__c)); //Support Number:00665304 Code Added

              }
            }

            List<String>allStatus = updatedVersion.values();
            Set<String> statusSet = new Set<String>();
            String finalCaseStatus = '';

            if(!(allStatus.isEmpty())){
              for(String stat : allStatus){
                List<String>stats = stat.split(' - ');
                statusSet.add(stats[1]);
                
              }
              // To Update various status
              if(statusSet.contains('Approved')&&(statusSet.size()==1)){
                finalCaseStatus = 'Approved';
              }
              if(statusSet.contains('Pending Approval') || statusSet.contains('') || statusSet.contains(null)){
                finalCaseStatus = 'Pending Approval';
              }
              if(statusSet.contains('Rejected')){
                finalCaseStatus = 'Rejected';
              }

                eachCase.Approval_Status__c = finalCaseStatus;
                //Support Number:00665304 Start of Code 
                IF(updatedWRFPA.get(eachCase.ID) != null){
                    eachCase.Pricing_Analyst__c = updatedWRFPA.get(eachCase.ID);
                }
                //Support Number:00665304 End of Code
                updatedcasesList.add(eachCase);
            }
          }
          if(!(updatedcasesList.isEmpty())){
            update updatedcasesList;
          }
        }
    }

    //set next approver id
    public void nextApproverId(){
        for (CPM__c CM : newLst){
            if(cM.Next_ApproverId__c != oldmap.get(cM.Id).Next_ApproverId__c){
                if(cM.Next_ApproverId__c == 'Finance'){
                    cM.NextApproverIdUser__c = null;
                }
                else{
                    cM.NextApproverIdUser__c = cM.Next_ApproverId__c;
                }
            }
        }
    }

    public void cpmScenarioGT(){
        string proceed = 'NoGo';
        set<String> SupNo = new Set<String>();
        set<Decimal> SceNo = new Set<Decimal>();
        set<Decimal> VerNo = new Set<Decimal>();
        for (CPM__c CM : newLst){
            CM.OwnerId = CM.Pricing_Analyst__c;
            if(CM.Version__c >= 2){
                proceed = 'Go';
                SupNo.add(cm.Support_Number__c);
                SceNo.add(integer.valueof(cm.Scenario__c));
                VerNo.add(integer.valueof(cm.Version__c));
            }
        }
        if(proceed == 'Go'){
            //Capture a list of CPMs that are older versions and set the Approval Status to 'Obsolete'.
            Map<ID,CPM__c> CPUpdMap = new map<ID,CPM__c>();

            CPUpdMap.putall([Select ID, Approval_Status__c, Support_Number__c, Scenario__c, Version__c
                            from CPM__c
                            Where Support_Number__c in : SupNo
                            and Scenario__c in : SceNo
                            and Approval_Status__c != 'Obsolete']);

            set<ID> uPiW = new Set<ID>();

            for(CPM__c uC : CPUpdMap.Values()){
                uPiW.Add(uC.ID);
                uC.Approval_Status__c = 'Obsolete';
            }

            Update CPUpdMap.values();
            //Capture a list of existing processes that will be invalid
            Map<ID, ProcessInstanceWorkitem> workitem = New Map<ID, ProcessInstanceWorkitem>( [select Id
                                             from ProcessInstanceWorkitem
                                             where ProcessInstance.TargetObjectId in : uPiW
                                             and ProcessInstance.Status = 'Pending']);
            if(workitem.size()>0){
                Approval.ProcessWorkItemRequest pwr = new Approval.ProcessWorkItemRequest();
                for(ProcessInstanceWorkitem PiW: workitem.values()){
                    pwr.setWorkitemId(PiW.id);
                    pwr.setComments('A newer version for this scenario was created. Set Approval to Recalled and Approval Status to Obsolete');
                    pwr.setAction('Removed');
                    //Submit approval with Removed Status to all the capture in the above list.
                    Approval.ProcessResult pr = Approval.process(pwr);
                }
            }
        }
    }
}
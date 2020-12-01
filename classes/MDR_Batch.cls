global class MDR_Batch implements Database.Batchable<sObject>,Database.Stateful,Schedulable  { 
// Support Number: 00708646
    global Database.QueryLocator start(Database.BatchableContext bc)
    { 
    //Captures All the MDR records that have a Parent or CMO Parent in the string field but not referenced to the existing MDR in the ID
        string query = 'Select ID, PID__c, CMO_ParentPID__c, CMO_PID__c,  txtParentPID__c , ParentPID__c '
            + 'From MDR__c '
            + 'Where (CMO_ParentPID__c != null and CMO_PID__c = null) or (ParentPID__c = null and txtParentPID__c != null)';
        
        return  Database.getQueryLocator(query);
    }
    
    global void execute(SchedulableContext sc){
        //Batch size set for each iteration
        integer batch_size = 1500;
        MDR_Batch MDRBatch = new MDR_Batch();
        database.executebatch(MDRBatch,batch_size);
    }
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        
        set<ID> iCMO = new Set<ID>();
        set<ID> iPrt = new Set<ID>();
        set<String> sAll = new Set<String>();
        Map<string, string> txt2ID = new Map<string, string>();
        List<MDR__c> Upd_MDRs = new List<MDR__c>();
        
        
        For (SObject s1 : Scope ) {
            MDR__c MD = (MDR__c)s1;
            IF(MD.CMO_ParentPID__c != Null){
                sAll.add(String.ValueOf(Integer.valueOf(MD.CMO_ParentPID__c))); //Add CMO Parent PID to set to Capture and update later in the statement
            }
            IF(MD.txtParentPID__c != Null){
                sAll.add(String.ValueOf(Integer.valueOf(MD.txtParentPID__c))); //Add Parent PID to set to Capture and update later in the statement
            }
        }
        
         
        
        For (MDR__C fMDR : [Select Pid__c, ID from MDR__c where PID__c in :sAll]){
            txt2ID.put(String.ValueOf(Integer.valueOf(fMDR.PID__c)), String.ValueOf(fMDR.ID)); //Map all the PIDs to SFDC IDs
        }
        
        For (SObject s2 : Scope ) {
            MDR__c MD = (MDR__c)s2;
            
            IF(MD.txtParentPID__c != Null){
                MD.ParentPID__c = txt2ID.get(String.ValueOf(Integer.valueOf(MD.txtParentPID__c))); //Update the Parent Lookup with the ID from the PID in the Parent string field
            }
            IF(MD.CMO_ParentPID__c != Null){
                MD.CMO_PID__c = txt2ID.get(String.ValueOf(Integer.valueOf(MD.CMO_ParentPID__c))); //Update the CMO Parent Lookup with the ID from the PID in the CMO string field
            }
            
            Upd_MDRs.add(MD); 
        }
        IF (Upd_MDRs.Size() > 0) {
            Update Upd_MDRs; //DML Statement to Update MDR records in Batch
        }
    }
    
    global void finish(Database.BatchableContext info){
        
    }
                        
}
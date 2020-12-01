public class createDMLRelationshipRecord {
    public static Map<id,DML__C> accDmlMap {get;set;}
    public static void createDMLRelationship(List<Account> acclist){
        List<DML__C> dmlList=new List<DML__C>();
        List<DML_Relation__c> dmlRelList=new List<DML_Relation__c>();
        List<Case> caseList=new List<Case>();
        List<Account> accupList=new List<Account>();
        accDmlMap = new Map<id,DML__C>();
        for(Account a:acclist){
            system.debug('recname'+a.recordtypeId);
            Id PrentId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Parent').getRecordTypeId();
            Id GPrentId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GrandParent').getRecordTypeId();
            Id GGPrentId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Great Grandparent').getRecordTypeId();
            if(a.recordtypeId==PrentId || a.recordtypeId==GPrentId || a.recordtypeId==GGPrentId ){
                system.debug('***INSIDE REC TYPE CHECK***');
                DML__C dmlrec=new DML__C();
                dmlrec.DML_City__c=a.City__c;
                dmlrec.DML_State__c=a.State__c;
                dmlrec.DECISION_MAKER_ZIP_CD__c=a.Zip__c;
                dmlrec.DECISION_MAKER_SEGMENT__c=a.Segment__c;
                dmlrec.DECISION_MAKER_NM__c=a.Name;
                dmlrec.Status__c='Draft';
                dmlrec.Effective_Start_Date__c=Date.today();
                //dmlrec.Reason_for_Creation__c='';
                dmlList.add(dmlrec);
                system.debug('before insert'+dmlList);
                accDmlMap.put(a.id,dmlrec);
              
            }            
        }
        insert dmlList;
        
        List<Account> acc=[Select id,name,Related_DML__C,Related_DML__r.Id from Account where id in :accDmlMap.keySet()];
        
        for(Account a:acc){
            a.Related_DML__C = accDmlMap.get(a.Id).Id;
            accupList.add(a);
        }
        update accupList;
      Id DR_RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Deployment Request').getRecordTypeId();
        for(Account a:accupList){
            Case newCase = new Case();
            newCase.accountId = a.Id;
            newCase.Support_Type__c = 'Deployment';
            newCase.Support_Sub_Type__c = 'New DML Exception';
            newCase.subject = a.Name;
            newCase.RecordTypeId = DR_RecordTypeId;
            DML__c d=accDmlMap.get(a.Id);
            //newCase.Comments = newDMLRecord.Notes__c;
            //newCase.Description = 'Account Name :' + ' ' + a.Name + '\n' + 'Request Type: New DML Exception' + '\n' + 'Reason For DML Creation:' + ' ' + a.Related_DML__r.Reason_for_Creation__c + '\n' + 'Please check the DML by clicking this link:' + '  ' + System.Label.DML_Link + a.Related_DML__r.id;
             newCase.Description = 'Account Name :' + ' ' + a.Name + '\n' + 'Request Type: New DML Exception' + '\n' + 'Please check the DML by clicking this link:' + '  ' + System.Label.DML_Link + d.Id;
			caseList.add(newCase);
            system.debug('before insert'+caseList);
    	}
        Insert caseList; 
    }
 
}
// delete OD Account assignments record after Processing 
trigger DeleteAccountAssignments on AccountAssignments__c (after Update) {
Id CustId = Schema.SObjectType.AccountAssignments__c.getRecordTypeInfosByName().get('OfficeDepot').getRecordTypeId();
List<AccountAssignments__c> deleteList= new List<AccountAssignments__c>();
 for( AccountAssignments__c rec : Trigger.New){
    if(rec.recordtypeId  == CustId  &&   (rec.status__C=='Processed' || rec.status__C=='Partially Processed'    )  && 
     (rec.status__c!= trigger.oldMap.get(rec.id).status__c)){
     AccountAssignments__c  recNew= new AccountAssignments__c (Id=rec.Id);
    deleteList.add(recNew);
    }
 }
 if(deletelist.size()>0)
 delete deletelist;
}
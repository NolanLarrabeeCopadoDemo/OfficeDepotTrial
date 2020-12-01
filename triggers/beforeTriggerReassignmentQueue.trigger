// Logic to Autoapprove Record after 7th day of submission
trigger beforeTriggerReassignmentQueue on Reassignment_Queue__c (after update) {
List<Id > approveList = new List<Id >();
 for(Reassignment_Queue__c rec : Trigger.New){
     if(rec.Autoapprove7thDay__c==true){
     approveList.add(rec.Id);
     //rec.Autoapprove7thDay__c=false;
     }
 }
 ReassignUtils approveInstance = new ReassignUtils();
 list<ReassignUtils.AppRejData> approveResponse = new list<ReassignUtils.AppRejData>();
 if(approveList.size()>0){
 ReassignUtils.BYPASSVALIDATION=true;
 approveResponse =approveInstance.ApproveRej(approveList,'A');
 System.debug(LoggingLevel.Info, '&&&&&&&&approveResponse '+approveResponse );
 }
}
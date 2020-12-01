// delete GT Contact assignments record after Processing 
trigger GT_DeleteContactAssignments on GTContact_Delta__c (after Update) {
List<GTContact_Delta__c> deleteList= new List<GTContact_Delta__c>();
 for( GTContact_Delta__c rec : Trigger.New){
    if(  (rec.Processed_Status__c=='Processed'  )  && 
     (rec.Processed_Status__c!= trigger.oldMap.get(rec.id).Processed_Status__c)){
     GTContact_Delta__c recNew= new GTContact_Delta__c (Id=rec.Id);
    deleteList.add(recNew);
    }
 }
 if(deletelist.size()>0)
 delete deletelist;
}
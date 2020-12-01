trigger beforeUpdateILCtrigger on Instructional_Lead_Consultant__c (before insert,before update) {
    // Popultingduplicate check variable
    for (  Instructional_Lead_Consultant__c  rec  :Trigger.new)
         rec.CheckDuplicate__c=rec.user__C;
    
}
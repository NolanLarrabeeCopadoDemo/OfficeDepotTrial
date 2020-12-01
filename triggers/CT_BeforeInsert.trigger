//Insert Logic for Trigger
 trigger CT_BeforeInsert on Customer_Transition__c (before insert, before update) { 
     
     // Common actions to be taken for insert and update
    if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
        
        // Assign Account Extension
        List<Id> acctIds = new List<Id>();

        for (Customer_Transition__c ct : Trigger.new) {
                
            Id acctId = ct.Account__c;
            
            if (acctId != null) {
                acctIds.add(acctId);
            }
        }
        
        Map<Id, Id> accountIdToExtensionId = (new AccountExtensionHelper()).getAccountExtensionIds(acctIds); 

        for (Customer_Transition__c ct : Trigger.new) {
            Id acctId = ct.Account__c;
            ct.Extension_Account__c = accountIdToExtensionId.get(acctId);
        }
    }
     
 if(ConstantsExt.bypassCTMaintTrigger==true){    
    
 List<Customer_Transition__c > custList = new List<Customer_Transition__c > ();
 List<Customer_Transition__c > NewCustList = new List<Customer_Transition__c >();

  for(Customer_Transition__c a : Trigger.New){ 
     if(Trigger.isInsert  ||
      (Trigger.isUpdate &&  (a.Parent_Transition_ID__c!= trigger.oldMap.get(a.id).Parent_Transition_ID__c)  && 
      (a.status__C =='UnScheduled'  || a.status__C=='Scheduled' || a.status__C=='ReScheduled') && (a.Status__c=='On Deck' || a.Written_Agreement_ID__c==null)
      ))
      {
        custList.add(a);
       }
       
       ///00564213 
       if(Trigger.isUpdate && (a.Transition_Status__c == 'Inactive') && (a.Transition_Status__c != trigger.oldMap.get(a.id).Transition_Status__c) && (a.status__C =='UnScheduled'  || a.status__C=='Scheduled' || 
       a.status__C=='ReScheduled'  || a.status__C=='On Deck' || a.status__C=='Awaiting Disposition') )
      {
        a.Customer_Disposition__c = 'Lost Customer Account';
      }
      // end of ///00564213
      
      //START S-420887 (OD 00716325) [Hemant 6/29/2016] - Set DNS Date Fields
      if(Trigger.isInsert  ||
          (Trigger.isUpdate &&  (a.DNS_Status_Confirmed__c != trigger.oldMap.get(a.id).DNS_Status_Confirmed__c))){
        
        if(a.DNS_Status_Confirmed__c){
            a.DNS_Sent_Date__c = Date.Today();
        }else{
          a.DNS_Sent_Date__c = null;
        }
      }
      
      if(Trigger.isInsert  ||
          (Trigger.isUpdate &&  (a.DNS_Confirmation__c != trigger.oldMap.get(a.id).DNS_Confirmation__c))){
        
        if(a.DNS_Confirmation__c){
          a.DNS_Status_Confirmed_Date__c = Date.Today();
        }else{
          a.DNS_Status_Confirmed_Date__c = null;
        }
      }
      //END S-420887 (OD 00716325) [Hemant 6/29/2016] - Set DNS Date Fields
   
 }
    CT_TriggerFlow  rec= new CT_TriggerFlow();
    rec.CT_TriggerFlow(custList);

}
     
}
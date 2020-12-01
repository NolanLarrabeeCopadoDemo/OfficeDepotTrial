//Before Trigger for Customer Transition
trigger beforeTriggerCTDetails on Customer_Transition_Dtls__c (before insert,before update) {
    // Common actions to be taken for insert and update
    if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
        
        // Assign Account Extension
        List<Id> acctIds = new List<Id>();

        for (Customer_Transition_Dtls__c t : Trigger.new) {
            Id acctId = t.Account_ID__c;
            
            if (acctId != null) {
                acctIds.add(acctId);
            }
        }
        
        Map<Id, Id> accountIdToExtensionId = (new AccountExtensionHelper()).getAccountExtensionIds(acctIds); 

        for (Customer_Transition_Dtls__c t : Trigger.new) {
            Id acctId = t.Account_ID__c;
            t.Account_Extension_ID__c = accountIdToExtensionId.get(acctId);
        }
    }
    
//Variable declarations
List<String> billList= new List<String>();
List<Account> accList= new List<Account>();
Map<String,Id> billRef= new Map<String,Id>();
//get the billing OMX Keys
for(Customer_Transition_Dtls__c eachCTdtls : Trigger.New)
{

//checks currentUser is data loader
      
     if(  
     Trigger.isUpdate  &&       
     (trigger.oldMap.get(eachCTdtls.id).Customer_Transition_ID__c  != eachCTdtls.Customer_Transition_ID__c) &&
     trigger.oldMap.get(eachCTdtls.id).Header_Split_Record__C==true
      ){
      eachCTdtls.Customer_Transition_ID__c=trigger.oldMap.get(eachCTdtls.id).Customer_Transition_ID__c;
       //eachCTdtls.addError('Cannot change a Mod 5 Split Record');
      }

  if (  (trigger.isInsert )  ||
      (Trigger.isUpdate
       &&
       (  eachCTdtls .Bill_To_Reference__c!= trigger.oldMap.get(eachCTdtls .id).Bill_To_Reference__c )
       )
       )
{
if(eachCTdtls.Bill_To_Reference__c!=null)
billList.add(eachCTdtls.Bill_To_Reference__c);
}
}
   //get the Accounts
   if(billList.size()>0){
   for(Account acc : [Select Id,omx_primary_key__C  from account where omx_primary_key__C in:billList])
   billRef.put(acc.omx_primary_key__C ,acc.Id);
   }

        //Fetching Customer Transition to set Billing Account
         for(Customer_Transition_Dtls__c eachCTdtls : Trigger.New) {
         
           if (  (trigger.isInsert )  ||
      (Trigger.isUpdate
       &&
       (  eachCTdtls .Bill_To_Reference__c!= trigger.oldMap.get(eachCTdtls .id).Bill_To_Reference__c )
       )
       ){

          if(eachCTdtls.Bill_To_Reference__c!=null){
          eachCTdtls.Bill_To_Account__c=billRef.get(eachCTdtls.Bill_To_Reference__c);

          }
          }
        }

}
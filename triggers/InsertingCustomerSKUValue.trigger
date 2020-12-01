trigger InsertingCustomerSKUValue on ACE_Customer_View__c (before insert,before update) {

List<ACE_Customer_View__c> ACVList = Trigger.new;
List<ACE_Customer_View__c> updateACVList = new List<ACE_Customer_View__c>();
for(ACE_Customer_View__c ac : ACVList){
    If(ac.SKUID__c!=null){
    ac.Customer_SKU_Changes__c = ac.SKUID__c;
    updateACVList.add(ac);
    }
}

    
}
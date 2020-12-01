trigger UpdateAOPSAssignedOnRecordTypeChange on Account (after update) {
    
    Set<ID> resp = new Set<ID>();
    resp = Util.bizBoxRTIdsByObject('Account');
    
    //Story#01514722 - Below Piece of code is used to skip RecordType (Tech Zone)
    /*for(Account a: trigger.new)
    {
        if(util.checkRT('Account').contains(a.recordtypeId))
            return;
    }*/
    // Never skip trigger if user is Dataloader
    String currentUserId = UserInfo.getUserId().substring(0,15);
    boolean currentUserIsDL = false;
    if(Trigger.new != null)
    {
    for(Account myAccount : Trigger.new)
    {
        //if(Util.bizBoxRTIdsByObject('Account').contains(myAccount.RecordTypeId)){
         if(resp.contains(myAccount.RecordTypeId)){
            return;
        }
    }
    }
    
    List<Dataloader_User__c> dataloaderUsers = Dataloader_User__c.getall().values();
    for (Dataloader_User__c dlu : dataloaderUsers) {
        if (currentUserId == dlu.User_ID__c) {
            currentUserIsDL = true;
        }
    }
    
    // Execute trigger once
    if (executeoncetest.notTriggered_UpdateAOPSAssignedOnRecordTypeChange_after || currentUserIsDL) {
        executeoncetest.notTriggered_UpdateAOPSAssignedOnRecordTypeChange_after = false;
        
        List<Customer_Transition__c> customerTransitionList = new List<Customer_Transition__c>();
        List<Customer_Transition__c> customerTransitionListUpdate = new List<Customer_Transition__c>();
        List<Account> changedRecordTypeAccountList = new List<Account>();
        Map<Id,Customer_Transition__c> custTransitionMap = new Map<Id,Customer_Transition__c>();
    
        
        if(Trigger.isAfter){
         
            
         for(Account accObj : Trigger.New){
              if( Trigger.oldMap.get(accObj.Id).RecordTypeId == label.Customer_OfficeMax && Trigger.newMap.get(accObj.Id).RecordTypeId == Label.Customer){                   
                    changedRecordTypeAccountList.add(accObj);
                }     
            }
            system.debug('@@changedRecordTypeAccountList'+changedRecordTypeAccountList) ;   
                  
           //Added by Abhinav Upadhyay Ref: Case 00134981        
            if (changedRecordTypeAccountList!=null && !changedRecordTypeAccountList.isEmpty()) {
                        customerTransitionList = [Select id,AOPS_Assigned_Date__c,Account__r.id from Customer_Transition__c 
                        where Account__r.id IN :changedRecordTypeAccountList]; 
                        system.debug('@@customerTransitionList '+customerTransitionList ) ;
                        for(Customer_Transition__c custTransObj: customerTransitionList){
                        custTransitionMap.put(custTransObj.Account__r.id, custTransObj);
                        }        
            }
            system.debug('@@custTransitionMap'+custTransitionMap) ;      
                for(Customer_Transition__c custTrans: customerTransitionList){  
                    if(custTransitionMap.containsKey(custTrans.Account__r.id)){ 
                        system.debug('@@inside if') ;
                        Customer_Transition__c custTransObj = new Customer_Transition__c(); 
                        custTransObj = custTransitionMap.get(custTrans.Account__r.id) ;         
                        custTransObj .AOPS_Assigned_Date__c = Date.today();
                        customerTransitionListUpdate.add(custTransObj );
                    }
                }
            
            try{
                if(customerTransitionListUpdate.size()>0)
                update customerTransitionListUpdate;
            }catch(Exception e){
                system.debug('Exception Occured'+e);
            }
        }
    }
}
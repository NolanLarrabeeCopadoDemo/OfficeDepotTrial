trigger OMXAccountTrigger on Account (after insert, after update) {
    
     //Account Service Production Fix
    Set<ID> resp = new Set<ID>();
    resp = Util.bizBoxRTIdsByObject('Account');
    
    //Story#01514722 - Below Piece of code is used to skip RecordType (Tech Zone)

    if (Trigger.New != null) {
 for (Account myAccount: Trigger.new) {
  //if (Util.bizBoxRTIdsByObject('Account').contains(myAccount.RecordTypeId)&&util.checkRT('Account').contains(myAccount.recordtypeId)) {
      if (resp.contains(myAccount.RecordTypeId)) {
   return;
  }
 }

}
    //variable declaration
    set <Id> currentAccountIdList = new set <Id>();
    set <Id> accountIdParentChangeList = new set <Id>();
    set <Id> accountIdOwnerChangeList = new set<Id>();
    set <Id> accountIdSalesREpList= new set <Id>();
    set<string> paccomxid = new set<string>();
    set<Split_Account_Detail__c> updateset = new set<Split_Account_Detail__c>();
    List<Split_Account_Detail__c> updatelist = new List<Split_Account_Detail__c>();
    map<string,set<Split_Account_Detail__c>> maphsplit= new map<string,set<Split_Account_Detail__c>>();
    list<account> insertsite = new list<account>();
    list<account> updateseite = new list<account>();
    Boolean runAsuserDLN = false;
    admin_config__c ac = admin_config__C.getOrgDefaults();
    if (userinfo.getuserId() == ac.ODN_API_User__c)
        runAsuserDLN = true;
       
    set <String> accomxid = new set<String>(); 
    set <String> accomxidSplit= new set<String>(); 
    Map<String,ID> mapCTsrec = new Map<String,ID>();
    Map<String,String> maphiersplit = new Map <String,String> ();
    list<Customer_Transition__c> mod5accs = new list<Customer_Transition__c>();
    
      Id Customer = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
      Id CustOMX = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer (OfficeMax)').getRecordTypeId();
      Id SiteOMX = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site (OfficeMax)').getRecordTypeId();
      
      
        if(Trigger.isUpdate && Trigger.isAfter)
        {  OMXAddressUpdate addUpdate = new OMXAddressUpdate();    
            addUpdate.AccountCompare(Trigger.oldMap,Trigger.new);
           }
        
        
        if (trigger.isUpdate) {
            for(Account a: Trigger.New){           
                /////system.debug('--------'+a.recordtypeid+'----CustOMX-----'+CustOMX+'>>>>'+a.Mod_5_EBS_Sync_Status__c+'>>>>>old>>>>'+trigger.oldMap.get(a.id).Mod_5_EBS_Sync_Status__c);         
                    // Check to get MOD5 Accounts
                    if((a.Mod_5_EBS_Sync_Status__c != trigger.oldMap.get(a.id).Mod_5_EBS_Sync_Status__c) &&   a.recordtypeid== CustOMX && a.Split_Record__c == true  && a.Mod_5_EBS_Sync_Status__c=='SUCCESS'){                    
                        //////system.debug('entering mod5'+a.omx_primary_key__c);
                        
                        if(!accomxidSplit.contains(a.omx_primary_key__c)){
                        accomxidSplit.add(a.omx_primary_key__c);}   
                        
                        List<String> originalOMXKeyList=a.omx_primary_key__c.split('-');
                        String originalOMXKey=originalOMXKeyList[0];
                        ///////system.debug('originalOMXKey'+originalOMXKey);                    
                        if(!accomxid.contains(originalOMXKey)){
                        accomxid.add(originalOMXKey);          
                        }
                    }         
            }
            
            //////System.debug('&&&&&&&&&&accomxid'+accomxid);
    
    // getting the count of Split Records
            List <Split_Account_Detail__c> splitDetails = new List <Split_Account_Detail__c>();
             maphiersplit = new Map <String,String> ();
             mod5accs = new list<Customer_Transition__c>();
            if(accomxid.size()>0){
                try{
                     for(Split_Account_Detail__c sadtlrec : [Select  Customer_Transition__c,OMX_ACCOUNT__c,
                                                                    Original_Account__r.Mod_5_EBS_Sync_Status__c,
                                                                    Linked_Customer_Transition__r.account__r.Mod_5_EBS_Sync_Status__c, 
                                                                    Customer_Transition__r.account__r.Oracle_Party_ID__c
                                                                    FROM Split_Account_Detail__c 
                                                                    WHERE OMX_ACCOUNT__c IN :accomxid  and 
                                                                    Master_Account__c not in :accomxidSplit
                                                                    and 
                                                                    Linked_Customer_Transition__r.account__r.Split_Record__c = true
                                                                    //Master_Account__c LIKE '%-%'
                                                                    and Linked_Customer_Transition__r.account__r.Mod_5_EBS_Sync_Status__c != 'SUCCESS']){
                      
                        if(!maphiersplit.containsKey(sadtlrec.OMX_ACCOUNT__c))
                        maphiersplit.put(sadtlrec.OMX_ACCOUNT__c,sadtlrec.OMX_ACCOUNT__c);
                     } 
                     
                  }                                              
                catch(Exception e){}    
                
                Integer batchscope=Integer.valueof(Label.BatchScope);
                
               List<Customer_transition__C> custList=[select omx_primary_key__C from
                Customer_transition__C where omx_primary_key__C in: accomxid and
                (  Mod4FlowStatus__c='Splitted'   or  Mod5_Process__C=false)
                and  Ready_for_Mod1__c=false];
                
                         ///// system.debug('>>>maphiersplit>>>>'+maphiersplit);
                                                    
                          
                           for( Customer_transition__C s :custList){
                            /////System.debug('&&&&&&&&&&Inside loop'+s);                            
                                  Customer_Transition__c ct = new Customer_Transition__c();
                                  ct.omx_primary_key__c = s.omx_primary_key__C ;
                                  if(maphiersplit.size()==0){
                                      //////system.debug('launching mod5');
                                      ct.MOD5_Ready_To_Launch__c = true;
                                      ct.Split_Launching_Status__c='Submitted';
                                      mod5accs.add(ct);                        
                                  } 
                                  else{                         
                                      if(maphiersplit.get(s.omx_primary_key__C )==null  || maphiersplit.get(s.omx_primary_key__C )=='' ){
                                       //////system.debug('--launching mod5--');
                                       ct.MOD5_Ready_To_Launch__c = true;
                                       ct.Split_Launching_Status__c='Submitted';
                                       mod5accs.add(ct);                                  
                                       }
                                  }
                           }
       
                        
                          
                          /*
                           for( String s :accomxid){
                            System.debug('&&&&&&&&&&Inside loop'+s);                            
                                  Customer_Transition__c ct = new Customer_Transition__c();
                                  ct.omx_primary_key__c = s;
                                  if(maphiersplit.size()==0){
                                      system.debug('launching mod5');
                                      ct.MOD5_Ready_To_Launch__c = true;
                                      ct.Split_Launching_Status__c='Submitted';
                                      mod5accs.add(ct);                        
                                  } 
                                  else{                         
                                      if(maphiersplit.get(s)==null  || maphiersplit.get(s)=='' ){
                                       system.debug('--launching mod5--');
                                       ct.MOD5_Ready_To_Launch__c = true;
                                       ct.Split_Launching_Status__c='Submitted';
                                       mod5accs.add(ct);                                  
                                       }
                                  }
                           }
                                                              
                             */                                   
                                                              
                                                            
            }
            
        if(mod5accs.size()>0){
            system.debug(mod5accs);
            upsert mod5accs omx_primary_key__c;
        }
        
      }  
       
       
    //Logic to update the customer transition owner based on Account owner change
       if (trigger.isUpdate) {              
        for(Account a: Trigger.New){ 
                       
                 if(a.OwnerId != trigger.oldMap.get(a.id).OwnerId){
                        accountIdOwnerChangeList.add(a.Id);
                    }                                               
            }                     
         }         
    
        if(accountIdOwnerChangeList.size()>0){
            AccountCustomerTransitionCreation.changeCustomerTransitionRecordOwner(accountIdOwnerChangeList);
        }
    
    
    // Added by Sushma as per case # 00375823 Begins
        if(Trigger.isinsert){
            for(Account a: Trigger.New){        
                if(a.recordtypeid == CustOMX){
                    insertsite.add(a);
                }
            }
        }
        
        if(trigger.isUpdate){
            for(Account a: Trigger.New){
                if(a.recordtypeid == CustOMX && a.OMXIsUpdated__c== true){
                    updateseite.add(a);
                }
            }
        }
    
        if(insertsite.size()>0)
            OMXAccountPrimarySiteFactory.createPrimarySites(insertsite);
        if(updateseite.size()>0)
            OMXAccountPrimarySiteFactory.updatePrimarySites(updateseite);
    
    // Added by Sushma as per case # 00375823 Ends
    List<Prospect_Message__c>prosList= new List<Prospect_Message__c>();
    List<Prospect_Message__c>prosListNew= new List<Prospect_Message__c>();
        //OfficeMax accounts - create primary site for new accounts
        if (trigger.isInsert) {
        

            for(Account a: Trigger.New){        
    
                           ////// System.debug('Inside OMXAccountTrigger'+a.recordtypeid);
                                                        //////System.debug('Inside OMXAccountTrigger11'+CustOMX);


                if(a.recordtypeid == CustOMX){
                                           ////// System.debug('Inside OMXAccountTrigger1'+a.recordtypeid);

                    //OMXAccountPrimarySiteFactory.createPrimarySites(trigger.new);
                // Calling the customer transition Method when a record gets created
                    if (runAsuserDLN) {
                        if (a.status__c == 'Active' && (a.Legacy_CreatedDate__c >= date.Today()-90 || a.last_order_date__c >= date.Today()-400))
                          currentAccountIdList.add(a.Id);
                    }
                    else
                     currentAccountIdList.add(a.Id);
                        
                }
    
            }
        }
     
        if (trigger.isUpdate) {
            for(Account a: Trigger.New){
               
            if (a.recordtypeid == CustOMX) {
                  
                //OMXAccountPrimarySiteFactory.updatePrimarySites(trigger.new);
               // Calling the customer transition Method when a record gets activated
                if(a.status__c =='Active' &&
                 ((a.last_order_date__c != trigger.oldMap.get(a.id).last_order_date__c && a.last_order_date__c >= date.Today()-400)  
                 || (a.Legacy_CreatedDate__c != trigger.oldMap.get(a.id).Legacy_CreatedDate__c && a.Legacy_CreatedDate__c >= date.Today()-90) 
                 )
                 )
                 {
                    currentAccountIdList.add(a.Id);
                }
                
                // Update Customer transition when sales Rep change // 00484614
                if( (a.Sales_PersonID__c!= trigger.oldMap.get(a.id).Sales_PersonID__c) ){
                    accountIdSalesREpList.add(a.Id);
                }
            }
            
            if (a.recordtypeid == CustOMX || (a.recordtypeid == Customer && a.Omx_Primary_Key__c != null)) {
               // Update Customer transition hierrachy when Parent of account Changes
                if( (a.parentId!= trigger.oldMap.get(a.id).parentId) ){
                    accountIdParentChangeList.add(a.Id);
                }
            }
            
    
            }
        }
        
    
                System.debug('Calling currentAccountIdList'+currentAccountIdList);

        // Calling the customer transition Method when a record gets created
        if(currentAccountIdList.size()>0)
        AccountCustomerTransitionCreation.findAndAddAllParents(currentAccountIdList);
        // Update Customer transition hierrachy when Parent of account Changes
        if(accountIdParentChangeList.size()>0){
            System.debug('Calling Method');
         CustomerTransitionHierarchyUpdate.updateHierarchy(accountIdParentChangeList);    
        }   
        if(accountIdSalesREpList.size()>0){
            System.debug('Calling Method');
          CustomerTransitionHierarchyUpdate.updateTRiggerSalesRep(accountIdSalesREpList);    
        }   
}
// Before Update Trigger for Customer_Transition__c 
trigger CustomerTransition_afterUpdate on Customer_Transition__c (after update) {
      
      //start of 00658900 
    Map<Id,Customer_Transition__c> custCoreMap = new    Map<Id,Customer_Transition__c>();
    Map<Id,Customer_Transition_Dtls__c> CTDMap = new Map<Id,Customer_Transition_Dtls__c>();//added  00805168
    Id WRFRequestID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Work Request').getRecordTypeId();  
    List<Case> cases = new List<Case>();
    if(executeoncetest.customerTransition_beforeUpdate)
    { 
             
        //Bypassing trigger           
           executeoncetest.customerTransition_beforeUpdate=false;
        // Get the records with Final Split decision as Yes and Insert to Split Decision Table
        List<Customer_Transition__c> bulkSplitCreateCTList = new List<Customer_Transition__c>();
        List<Customer_Transition__c> bulkSplitDeleteCTList = new List<Customer_Transition__c>();        
        List<Id> mod5List = new List<Id>();
        List<Customer_Transition__c> mod5ProcessList = new List<Customer_Transition__c>();
        List<Customer_Transition__c> mod5ProcessListV1 = new List<Customer_Transition__c>();
        List<Customer_Transition__c> mod5deleteList= new List<Customer_Transition__c>();       
        Set<Id> ctSplitDetailChck = new Set<Id>();
        List<Customer_Transition__c> updatedCTSpltDtlChk = new List<Customer_Transition__c>();
        system.debug('@CustomerTransition_afterUpdate'+Trigger.New);
      
              //Change starts here   00805168

        List<Id> validateId= new List<Id> ();        
                for (Customer_Transition__c cust : Trigger.New) {
                
                          if (((Trigger.oldMap.get(cust.Id).status__C!= Trigger.newMap.get(cust.Id).status__c)
      && cust.status__C=='On Deck'  && cust.Written_Core_Request_WRF__c==true
        && cust.Written_Agreement_Custom_Core_Request__c=='Create WRF' && cust.Customer_Transition_Type2__c=='Child') 
        || (cust.Written_Agreement_Custom_Core_Request__c != Trigger.oldMap.get(cust.Id).Written_Agreement_Custom_Core_Request__c && cust.Written_Agreement_Custom_Core_Request__c=='Create WRF' && cust.status__c=='On Deck')) {
            custCoreMap.put(cust.Account__C,cust);         
        } 

                   if ((Trigger.oldMap.get(cust.Id).Ready_For_Mod_5__c!= Trigger.newMap.get(cust.Id).Ready_For_Mod_5__c) &&
                         cust.Ready_For_Mod_5__c== true){
                         System.debug('&&&&&&&&&&&&&&&&&&&&setting constant');
                         ConstantsExt.bypassCTMaintTrigger=false;

                         validateId.add(cust.Id);
                
                   }
                 }
       
       
          if(custCoreMap.size()>0){
       for(Id record: custCoreMap.keyset()){
                    Case Ca = New Case( );
                    ca.Accountid = record;
                    ca.WRF_Requestor__c =  custCoreMap.get(record).Account_OwnerId__c;  
                    ca.ownerId=custCoreMap.get(record).Account_OwnerId__c;                    
                    Ca.Reason = 'WRF Request';
                    Ca.Priority = '3-Medium';
                    Ca.Status = 'Open';
                    Ca.RecordTypeId = WRFRequestID;  //Work Request 
                    Ca.WRF_Request_Type__c = 'Transition';
                    Ca.CPM_Required__c= True;
                    Ca.WRF_Finance__c = False;
                    Ca.WRF_Written_Agreement__c = 'Yes';
                    Ca.Approved_for_Analyst_Assignment__c = true;
                    ca.isCreatedCustomerCore__C=true;
                    cases.add(Ca);      
       }
       if(cases.size()>0)
       insert cases;
     }
   //end of 00658900 
  
       
       
        // get active Customer transition details
        // query Customer transition details where Id in validateId and aops flag=Y and recordtype=site and Owner_Active__c=false
        // add to a Map if it returns record
        
        List<Customer_Transition_Dtls__c> CTDList = [select id,AOPS_Flag__c,Customer_Transition_ID__c from Customer_Transition_Dtls__c where
         Customer_Transition_ID__c IN :validateId and AOPS_Flag__c='Y' and RecordType.name='Sites' and Owner_Active__c=false];
        
        If(CTDList!=null && CTDList.size()>0)
        {
            for(Customer_Transition_Dtls__c CTD : CTDList)
            {
                if( !CTDMap.containskey(CTD.Customer_Transition_ID__c))
                CTDMap.put(CTD.Customer_Transition_ID__c,CTD);
            }
            
        }
        // End 00805168
        
       
        for (Customer_Transition__c cust : Trigger.New) {
        
        //Validation error if both Final split - Yes/No and Ready for Mod 5 checked together
               if (((Trigger.oldMap.get(cust.Id).Final_Split_Decision__c != Trigger.newMap.get(cust.Id).Final_Split_Decision__c) &&
                (cust.Final_Split_Decision__c == 'Yes' || cust.Final_Split_Decision__c == 'No')) &&
                ((Trigger.oldMap.get(cust.Id).Ready_For_Mod_5__c!= Trigger.newMap.get(cust.Id).Ready_For_Mod_5__c) &&
                cust.Ready_For_Mod_5__c== true)) {
                system.debug('//Validation error if both Final split - Yes/No and Ready for Mod 5 checked together');
                cust.addError('Final Split and Ready for Mod 5 Cannot be selected together');
            }
        
        //get the list to create split decision data
            else if ((Trigger.oldMap.get(cust.Id).Final_Split_Decision__c != Trigger.newMap.get(cust.Id).Final_Split_Decision__c) &&
                cust.Final_Split_Decision__c == 'Yes'  ) {
                system.debug(' //get the list to create split decision data');
                
                if(cust.No_of_Active_Sites__c  ==0)
                cust.AddError('There are no Active Sites for Splitting');
                else
                {
                    if(cust.No_of_Active_Sites__c  >500){
                    bulkSplitCreateCTList.add(cust);
                      // this will be taken Care by Batch Class 
                    }
                    else{
                    mod5List.add(cust.Id);}
                }
            }
            
        //get the list to delete split decision data
            else if ((Trigger.oldMap.get(cust.Id).Final_Split_Decision__c != Trigger.newMap.get(cust.Id).Final_Split_Decision__c) &&
                //cust.Final_Split_Decision__c == 'No'  &&
                Trigger.oldMap.get(cust.Id).Final_Split_Decision__c=='Yes' ) {
                system.debug(' //get the list to delete split decision data     ');
                if(cust.No_of_Active_Sites__c  >500){
                      // this will be taken Care by Batch Class 
                      bulkSplitDeleteCTList.add(cust);
                    }
                    else{
                mod5deleteList.add(cust);
                }
            }
            //get the Records to trigger the Mod 5 Process
            else if ((Trigger.oldMap.get(cust.Id).Ready_For_Mod_5__c!= Trigger.newMap.get(cust.Id).Ready_For_Mod_5__c) &&
                cust.Ready_For_Mod_5__c== true) {                                
                system.debug(' //get the Records to trigger the Mod 5 Process');
                
                if(CTDMap.containskey(cust.Id)  || (cust.IsaccountOwnerActive__C==false) || (cust.Parent_ID__c !=null && cust.IsParentOwnerActive__c==false))
                {
                    system.debug('Ready for Mod 5');
                    cust.adderror('Ready for Mod 5 cannnot be done due to Inactive owner for Consignees  or Account or Parent');
                    
                }
                
                // Validate here if Map contains values throw error " Ready for Mod 5 cannnot be done due to Inactive owner else add to below list
                else {
                mod5ProcessList.add(cust);
                }
                // End 00805168
            }
        } 
        
        
        System.debug('&&&&&&&&&'+mod5List.size());
        // Call the Method to create split details
        if(mod5List.size()>0){
        SplitRecordsCreator spt= new SplitRecordsCreator();
        spt.createSplitDetails (mod5List);
        
       }
        
           // Call the Method to delete split details
        if(mod5deleteList.size()>0){
        SplitRecordsDelete sptDelete= new SplitRecordsDelete();
        sptDelete.deletesplitDetails(mod5deleteList);
        }
        
        //Call the mod 5 Method validate for splitting 
            
               ////executeoncetest.mod5ByPass=false;
          /// Mod5Helper mod = new Mod5Helper();
 
                    
            if (mod5ProcessList.size() > 0) {            
               Mod5Helper mod = new Mod5Helper();
               mod.validateList(mod5ProcessList );               
               }
               
            //For Bulk Split creation   
            if (bulkSplitCreateCTList.size() > 0) {            
            List<Customer_Transition__c> ctUpdateList = new List<Customer_Transition__c>();
                for(Customer_Transition__c eachCT : bulkSplitCreateCTList)
                {
                Customer_Transition__c newEachCT = new Customer_Transition__c(id=eachCT.Id);
                newEachCT.Mod4FlowStatus__c = 'Bulk Split Create';
                ctUpdateList.add(newEachCT);
                }
                update ctUpdateList;
               }
               
            //For Bulk Split deletion
            if (bulkSplitDeleteCTList.size() > 0) {            
            List<Customer_Transition__c> ctUpdateList = new List<Customer_Transition__c>();
               for(Customer_Transition__c eachCT : bulkSplitDeleteCTList)
                {
                Customer_Transition__c newEachCT = new Customer_Transition__c(id=eachCT.Id);
                newEachCT.Mod4FlowStatus__c = 'Bulk Split Delete';
                ctUpdateList.add(newEachCT);
                }
                update ctUpdateList;
               }
 
            
 
    }
}
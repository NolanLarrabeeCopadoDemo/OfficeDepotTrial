public without sharing class AccountCustomerTransitionCreation{
// Method to update the owner of transition when owner of Account Changes
    public static void changeCustomerTransitionRecordOwner(Set<Id> changedOwnerAccountList){
        List<Customer_Transition__c> custTransitionRecordList = new List<Customer_Transition__c>();
        List<Customer_Transition__c> custTransitionChangeRecordList= new List<Customer_Transition__c>();
        custTransitionRecordList = [Select id, OwnerId,account__c,account__r.ownerId from Customer_Transition__c where account__c in:changedOwnerAccountList];
        for(Customer_Transition__c cust: custTransitionRecordList){
            cust.OwnerId = cust.account__r.OwnerId;
            custTransitionChangeRecordList.add(cust);
        }
        try{
            update custTransitionChangeRecordList;
        }catch(Exception e){
            system.debug('Exception :'+e);
        }
    }
    public static void findAndAddAllParents(Set<Id> currentAccountIdList){
        List<Id> accountIdsList = new List<Id>();
        list<Account> accountList = new List<Account>();
        accountList = [select id, parentId, parent.parentId, parent.parent.parentId, parent.parent.parent.parentId from Account where Id in: currentAccountIdList];
        for(account acc: accountList){
        
            if(acc.parent.parent.parent.parentId!=null){
                accountIdsList.add(acc.parent.parent.parent.parentId);  
            }
            if(acc.parent.parent.parentId!=null){
                accountIdsList.add(acc.parent.parent.parentId); 
            }
            if(acc.parent.parentId!=null){
                accountIdsList.add(acc.parent.parentId);    
            }
            if(acc.parentId!=null){
                accountIdsList.add(acc.parentId);   
            }
            accountIdsList.add(acc.id);
        
        }
        createAssociatedCustomerTransitionRecord(accountIdsList);
    }
    
    public static void createAssociatedCustomerTransitionRecord(List<Id> accountIdsList){
        List<Customer_Transition__c> cstList = new List<Customer_Transition__c>();
        List<Id> accIdWithoutCT = new List<Id>();
        Customer_Transition__c ctRecord;
        List<Customer_Transition__c> custTransList = new List<Customer_Transition__c>();
        List<Customer_Transition__c> greatgrandparent= new List<Customer_Transition__c>();
                    List<Customer_Transition__c> grandparent= new List<Customer_Transition__c>();
                    List<Customer_Transition__c> parent= new List<Customer_Transition__c>();
                    List<Customer_Transition__c> child= new List<Customer_Transition__c>();

        cstList = [select account__c,id from Customer_Transition__c where account__c in :accountIdsList];
                
           Map<id,Customer_Transition__c  > MapCT = new Map<id,Customer_Transition__c  >  ();
       for(Customer_Transition__c ctr :cstList ){
           MapCT.put(ctr.Account__c, ctr );
       }       
       
       if(cstList!=null && !cstList.isEmpty()){    
           for(Id accId: accountIdsList){              
               if(!(MapCT.containskey(accId)))
               accIdWithoutCT.add(accId);

           }
       }
       else{
           for(Id accId: accountIdsList){
               accIdWithoutCT.add(accId);
           }
       }
 
        List<Account> accountsList = new List<Account>();
        accountsList = [select id, name , recordtypeId,parentId,omx_mainframe_account_level__c,omx_primary_key__C, ownerId ,grandparent__C from Account where id in :accIdWithoutCT];
        for(Account acc : accountsList){
            
            ctRecord = new Customer_Transition__c();
             if(acc.grandparent__C == 'Yes'){
                ctRecord.name = 'Customer Transition Grandparent of ' + acc.name;
            }
            else{
                if(acc.omx_mainframe_account_level__c == 'Main Account'){
                   ctRecord.name = 'Customer Transition Child of ' + acc.name;
                }
                else if(acc.omx_mainframe_account_level__c == 'National'){
                    ctRecord.name = 'Customer Transition Parent of ' + acc.name;
                }
                else if(acc.recordtypeId==System.Label.Customer && acc.parentId!=null && acc.grandparent__C != 'Yes'){
                
                  ctRecord.name = 'Customer Transition Parent of ' + acc.name;
                }
                
                ////////Uncomment this once omx_primary_key__C is populated in great grand parent                              
               else if(acc.recordtypeId==System.Label.Customer && acc.parentId==null && acc.grandparent__C != 'Yes'  && acc.omx_primary_key__C!=null){                
                   ctRecord.name = 'Customer Transition Great Grandparent of ' + acc.name;
                } 
                
                else{
                   ctRecord.name = 'Customer Transition Parent of ' + acc.name;
                } 
                              
                ////////comment this once omx_primary_key__C is populated in great grand parent  
                /****8else{
                 ctRecord.name = 'Customer Transition Great Grandparent of ' + acc.name;
                }*///////
           }
            if(ctRecord.name.length()>80)
            ctRecord.name=ctRecord.name.substring(0,79);
            
            ctRecord.account__c = acc.id;
            ctRecord.status__c = 'UnScheduled';
            ctRecord.ownerId=acc.ownerId;
            ctRecord.OMX_Primary_Key__c = acc.OMX_Primary_Key__c;
            if(ctRecord.name.contains('Customer Transition Great Grandparent of'))
            greatgrandparent.add(ctRecord);
            if(ctRecord.name.contains('Customer Transition Grandparent of'))
            grandparent.add(ctRecord);
            if(ctRecord.name.contains('Customer Transition Parent of'))
            parent.add(ctRecord);
            if(ctRecord.name.contains('Customer Transition Child of'))
            child.add(ctRecord);           
        }
        try{ 
            if(  greatgrandparent.size()>0)
            insert greatgrandparent;  
             if(  grandparent.size()>0)
            insert   grandparent;      
            if(  parent.size()>0)
            insert parent;                            
            if(  child.size()>0)
            insert child;            
        }
        catch(Exception e) {
            system.debug('Exception occured'+e);
        }
    }
    
}
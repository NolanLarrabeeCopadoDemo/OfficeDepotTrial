// Author    Mohamad Elkhatib    March 2 2016
/*************************************************************
Description: This class will add Address2 for newly OMX created Accounts.
*************************************************************/

public class OMXAddressUpdate {

   // public void OMXAddressCreation(){}
    
    public void AccountCompare(Map<Id,Account> oldMap,List<Account> newAccounts ) { 

    List<id>  accIdlist = new List<id>();
    Map<Id,Account> accMap = new Map<Id,Account>();
    
    //Getting OMX Accounts by it's Record Type
    Id OMXAcc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer (OfficeMax)').getRecordTypeId();
    
    for (Account a : newAccounts){ 
            
            if (a.RecordTypeId ==  OMXAcc) {
            if( (a.Address1__c != oldMap.get(a.Id).Address1__c) || (a.Address2__c!= oldMap.get(a.Id).Address2__c) || (a.City__c != oldMap.get(a.Id).City__c) ||
            (a.Zip__c != oldMap.get(a.Id).Zip__c) || (a.State__c != oldMap.get(a.Id).State__c) || (a.Country__c != oldMap.get(a.Id).Country__c) ) 
            
               {            
                  accIdlist.add(a.Id); 
                  accMap.put(a.Id,a);                 
               }
         }   
      }
    
    if(accIdlist.size()>0){
        List<Account> primarySites=[select Id,related_account__C , Address1__c,Address2__c,City__c ,Zip__c ,State__c, Country__c from account where (omx_primary_key__c like '%OMX001%' OR omx_primary_key__c like '%OMX002%') and
        related_account__c in :accIdlist];
        
            for(Account acc: primarySites){
                           acc.Address1__c = accMap.get(acc.related_account__c ).Address1__c;
                           acc.Address2__c = accMap.get(acc.related_account__c ).Address2__c;
                           acc.City__c = accMap.get(acc.related_account__c ).City__c;
                           acc.Zip__c = accMap.get(acc.related_account__c ).Zip__c;
                           acc.State__c = accMap.get(acc.related_account__c ).State__c;
                           acc.Country__c = accMap.get(acc.related_account__c ).Country__c ;
                        }      
                     update primarySites;
      }
}
    }
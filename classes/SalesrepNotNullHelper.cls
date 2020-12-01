public class SalesrepNotNullHelper {
    /*public static void updateAccountOwner(List<Account> Acco,Map<Id,Account> oldAcc){       
     List<Id> salesPersonIdList = new List<Id>();
     Map<Id,Id> salesPersonMap = new Map<Id,Id>();
     Id recordTypeId1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Great Grandparent').getRecordTypeId();
     Id recordTypeId2 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GrandParent').getRecordTypeId();  
     for(Account acc : Acco){
        if(acc.Sales_PersonID__c!=''&& acc.Sales_PersonID__c!=oldAcc.get(acc.Id).Sales_PersonID__c&& (acc.RecordTypeId==recordTypeId1||acc.RecordTypeId==recordTypeId2) )
            salesPersonIdList.add(acc.Sales_PersonID__c);
     }
    
     if(!salesPersonIdList.isEmpty()){
        for(Sales_Person__c sp :[Select id,User__c from Sales_Person__c where id in : salesPersonIdList]){
            salesPersonMap.put(sp.id,sp.User__c);
        }
     }
    
     for(Account acc : Acco){
        if(salesPersonMap.containsKey(acc.Sales_PersonID__c)){
            acc.OwnerId = salesPersonMap.get(acc.Sales_PersonID__c);
        }
     }
} */

Static Id GGPRTId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Great Grandparent').getRecordTypeId();
Static Id GPRTId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('GrandParent').getRecordTypeId();  
Static  Set<Id> salesPersonIds= new Set<Id>();    
   Public Static void BeforeInsert(List<Account> Acco)
   {
            for(Account acc : Acco){
             if(acc.RecordTypeId==GGPRTId||acc.RecordTypeId==GPRTId )
                salesPersonIds.add(acc.Sales_PersonID__c);
            }
            
           MaptoSalesPerons(salesPersonIds,Acco);
   }
   
   Public Static void BeforeUpdate(List<Account> Acco,Map<Id,Account> OldAcc)
   {
           for(Account acc : Acco){
             if(acc.Sales_PersonID__c!=oldAcc.get(acc.Id).Sales_PersonID__c && (acc.RecordTypeId==GGPRTId||acc.RecordTypeId==GPRTId) )
                salesPersonIds.add(acc.Sales_PersonID__c);
            }
            
           
               MaptoSalesPerons(salesPersonIds,Acco);
   }
   
   static void MaptoSalesPerons(Set<Id> salesPersonIds,List<Account> Acclist)
   {
    if(!salesPersonIds.isEmpty())
    {
           Map<Id,Sales_Person__c> mSPids=New Map<Id,Sales_Person__c>([Select id,User__c from Sales_Person__c where id in : salesPersonIds]);
          for(Account acc : Acclist){
       
            if(mSPids.containsKey(acc.Sales_PersonID__c)){
                acc.OwnerId = mSPids.get(acc.Sales_PersonID__c).User__c;
            }
         }
     }
   }

}
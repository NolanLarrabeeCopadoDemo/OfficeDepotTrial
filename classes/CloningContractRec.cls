public class CloningContractRec {
    Public Static Boolean Flag= true;
    Public Static void beforeupdate(list<Contract> ContractList){
        // system.debug('loop');
      
    Set<String> fields = Schema.getGlobalDescribe().get('Contract').getDescribe().fields.getMap().keyset(); 
  Map<Id,ContractHistory__c> ContractHistoryMap = new Map<Id,ContractHistory__c>();
  for(Contract record: ContractList) {
      system.debug('record.Account.id'+record);
     // co2.get(record.mypackage05__ChildAcc2__c).put(field,record.getSObject('Owner').get('My_Field__c'));

ContractHistoryMap.put(record.id,new ContractHistory__c(Contract__c=record.id,Account__c=record.AccountId,Name__c=record.Name));

           // flag=false;
    for(String field:fields) {
           
//ContractHistoryMap.put(record.id,new ContractHistory__c(Account__c=record.AccountId));
       // system.debug('ContractHistoryMap.values()1'+ContractHistoryMap.values());
         // system.debug('ContractHistoryMap.values()key1'+ContractHistoryMap.keyset());
        // system.debug('fields'+fields);
      if(field.indexOf('__c')>-1) { // This is a custom field.
         //  system.debug('ContractHistoryMap.values()2'+ContractHistoryMap.values());
           // system.debug('ContractHistoryMap.values()key2'+ContractHistoryMap.keyset());
        try {
          ContractHistoryMap.get(record.id).put(field,record.get(field));
             // system.debug('ContractHistoryMap.values()key3'+ContractHistoryMap.keyset());
           //system.debug('ContractHistoryMap'+ContractHistoryMap);
           // system.debug('ContractHistoryMap.values()3'+ContractHistoryMap.values());
        } catch(exception e) { /* NOTE: This just means copy failed. */ }
      }
    }
        //  flag=false; 
  }
      
      //  system.debug('ContractHistoryMap.values()key4'+ContractHistoryMap.keyset());
       //  system.debug('ContractHistoryMap.values()4'+ContractHistoryMap.values());
  insert ContractHistoryMap.values();
    //CloningContractRec.Flag = true;
    }
    }
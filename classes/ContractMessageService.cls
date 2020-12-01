/* This will be called by Oracle to update the Status back*/

global class ContractMessageService {
  
    webservice static boolean updateContractReqStatus(String contractMsgId, String status,string SysException){
    List<ContractMessage__C> cm = [select id from ContractMessage__c where id =:contractMsgId];
        
    if(cm.size() == 0){
      return false;
    }
    else{
        cm[0].Status__c = status;
        cm[0].Exception__c =  SysException;        
        update(cm);
    }
        
    return true;
  }
    
}
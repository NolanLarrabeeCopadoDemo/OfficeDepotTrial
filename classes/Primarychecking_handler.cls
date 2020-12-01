public class Primarychecking_handler {
 public static void Pcheck(list<Contract> contrlist ){
    Set<ID> accountIdSet = new Set<ID>(); 
    Set<ID> contractIdSet = new Set<ID>();
    Map<ID,List<Contract>> accIdAndContractListMap = new Map<ID,List<Contract>>(); 
    Map<ID,integer> accIdAndContractCountMap = new Map<ID,Integer>();
    List<Contract> oldContractList = new list<Contract>(); 
    Integer Count =0;

    if(trigger.IsInsert && trigger.IsBefore)
    {   
    for (Contract newContract : contrlist)
    {
       if(newContract.Primary__c == true && newContract.AccountId!=NULL )
       {
            if(!accountIdSet.Contains(newContract.AccountId))
            {           
                accountIdSet.add(newContract.AccountId);                   
            }
           else
           {                  
                newContract.AccountId.addError('Only one contract can be the primary.Must not add all contracts as primary contract');
            }               
        }
    }   
    if((accountIdSet !=NULL) && (accountIdSet.size()>0))
    {       
        OldContractList=    [SELECT Id,primary__c,AccountId FROM Contract WHERE AccountId IN :accountIdSet AND primary__c=TRUE];                                             
        for(Contract cnt : OldContractList){                                                
            accIdAndContractCountMap.put(cnt.AccountId,1);                                                                                                                                                                     
        }
        system.debug('::::++++++'+accIdAndContractCountMap);                      
        for(Contract newContract : contrlist)
        {
            if(newContract.AccountId!=NULL && accIdAndContractCountMap.containsKey(newContract.AccountId))
            {
            Count = accIdAndContractCountMap.get(newContract.AccountId);
                if(Count==1)
                {
                    system.debug('+++++count------'+Count);                       
                    newContract.AccountId.addError('One primary contract is already available, inserting another primary contract is not possible.');
                }
            }
        }
    }       
}

}
public static void pcheckaf(list<Contract> contrlist, map <id, contract> afterCon){
   Set<ID> accountIdSet = new Set<ID>();
   Set<ID> contractIdSet = new Set<ID>();
   Map<ID,integer> accIdAndContractCountMap = new Map<ID,Integer>();
   List<Contract> oldContractList = new list<Contract>(); 
   Integer Count =0;

   for(Contract newupContract : contrlist)
   {
       
        if(newupContract.primary__c == true && newupContract.AccountId!=NULL &&  
           (afterCon.get(newupContract.Id).primary__c == FALSE ||
            afterCon.get(newupContract.Id).primary__c ==TRUE ))
        { 
            

                if(!accountIdSet.Contains(newupContract.AccountId))
                {
                    accountIdSet.add(newupContract.AccountId);                                                                                                           

                    system.debug('++++++++'+accountIdSet);

                    contractIdSet.add(newupContract.Id);

                }else if(accountIdSet.Contains(newupContract.AccountId))
                {
                                 

                    newupContract.AccountId.addError('When updating or inserting, Only 1 Contract can be the primary.');
                }
        }                                             
    }  

    if((accountIdSet !=NULL) && (accountIdSet.size()>0))
    {   
        OldContractList=    [SELECT Id,Name,Primary__c,AccountId FROM Contract
                            WHERE AccountId IN :accountIdSet AND Primary__c=TRUE AND Id NOT IN :contractIdSet];

        for(Contract cnt : OldContractList){                               
            accIdAndContractCountMap.put(cnt.AccountId,1); 
            
        }
        for(Contract newContract :contrlist)
        {
            if(newContract.AccountId!=NULL && accIdAndContractCountMap.containsKey(newContract.AccountId))
            {
            Count = accIdAndContractCountMap.get(newContract.AccountId);                               
                if((Count==1)&&(newContract.Primary__c==TRUE))
                {
                  newContract.AccountId.addError('When updating or inserting, Only 1 Contract can be the primary.');
                }
            }
        }           
    }       

     }    
}
public class AccountAfterTrigger_Handler {
    
    public static void AccountAfterUpdate(List<Account> AccList,Map < Id, Account> NewAccount, Map < Id, Account> OldAccount)
    {
        List<DML_Relation__c>  DMLRList= new List<DML_Relation__c>();
        Map<Id,Account> AccId = new Map<Id,Account>();
        for (Account recid:AccList) {
            if ((OldAccount.get(recid.Id).Aops_cust_id__c != NewAccount.get(recid.Id).Aops_cust_id__C)&&NewAccount.get(recid.Id).Aops_cust_id__C!=null)
                AccId.put(recid.Id,recid);
        }
        if(!AccId.isEmpty()){
            for(DML_Relation__c dr : [select id, CUSTOMERID__c,Account__c from DML_Relation__c where Account__C=:AccId.keyset()])
            {
                dr.CUSTOMERID__c=AccId.get(dr.Account__c).AOPS_Cust_Id__c;
                DMLRList.add(dr);
            }
            if(DMLRList.size()>0)
                update DMLRList;
        }
        
    }
    
}
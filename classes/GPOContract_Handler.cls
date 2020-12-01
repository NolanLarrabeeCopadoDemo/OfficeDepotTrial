Public Class GPOContract_Handler
{

   Public Static void AfterInsert(Map<Id,Contract> NewContracts)
   {
       Flag_GP_GGP(NewContracts.values());
   }
   
   Public Static void AfterUpdate(Map<Id,Contract> NewContracts,Map<Id,Contract> OldContracts)
   {
       List<Contract>  Conlist=New List<Contract>();
       for(Contract Con:NewContracts.values())
       {
           if(Con.GPO_Contract__c!=OldContracts.get(Con.Id).GPO_Contract__c)
                Conlist.add(Con);
       }
       
       if(!Conlist.isEmpty())
           Flag_GP_GGP(Conlist);
   }
   
    static void Flag_GP_GGP(List<Contract> NewContracts)
    {
        Set<Id> Accids=New Set<Id>();
        Set<String> Recordtypes=New Set<String>{'Grandparent','Great Grandparent'};
        
        for(Contract Con:NewContracts)
        {
           if(Con.GPO_Contract__c&&(Con.Basis_Level_for_Customer_Agreement__c=='Grandparent Account' || Con.Basis_Level_for_Customer_Agreement__c=='Great Grandparent'))
              Accids.add(Con.AccountId);
        }
        
        if(!Accids.isEmpty())
        {
        List<Account> Acclist=[SELECT Id,Current_GPO__c,RecordType.Name,
                               ParentId,Parent.Current_GPO__c,Parent.RecordType.Name,
                               Parent.ParentId,Parent.Parent.Current_GPO__c,Parent.Parent.RecordType.Name,
                               Parent.Parent.ParentId,Parent.Parent.Parent.Current_GPO__c,Parent.Parent.Parent.RecordType.Name,
                               Parent.Parent.Parent.ParentId,Parent.Parent.Parent.Parent.Current_GPO__c,Parent.Parent.Parent.Parent.RecordType.Name
                               FROM Account 
                               WHERE Id IN:Accids
                               AND (RecordType.Name IN:Recordtypes
                                    OR Parent.RecordType.Name IN:Recordtypes
                                    OR Parent.Parent.RecordType.Name IN:Recordtypes
                                    OR Parent.Parent.Parent.RecordType.Name IN:Recordtypes
                                    OR Parent.Parent.Parent.Parent.RecordType.Name IN:Recordtypes)];
    
        if(!Acclist.isEmpty())
        {
            List<Account>  UpdateAccounts=New List<Account>();
            for(Account Acc:Acclist)
            {
                Acc.Current_GPO__c=true;
                UpdateAccounts.add(Acc);
                
                if(Acc.ParentId!=Null)
                    UpdateAccounts.add(Accounts(Acc.ParentId));
                   
                if(Acc.Parent.ParentId!=Null)
                      UpdateAccounts.add(Accounts(Acc.Parent.ParentId));
                   
                if(Acc.Parent.Parent.ParentId!=Null)
                     UpdateAccounts.add(Accounts(Acc.Parent.Parent.ParentId));
                   
                    
                if(Acc.Parent.Parent.Parent.ParentId!=Null)
                    UpdateAccounts.add(Accounts(Acc.Parent.Parent.Parent.ParentId));
                
            }
            
            Update updateAccounts;
         }
       }
    }
    
     Static Account  Accounts(String AccId)
     {
                   Account A=New Account();
                    A.Id=AccId;
                    A.Current_GPO__c=true;
                    
                    Return A;
     }
}
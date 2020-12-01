public class AccountRestorectrl {
    
    public String ReasonCode {get;set;}
    public String comments {get;set;}
    public Account actTmp {get;set;}
    public ID acctDormantID {get;set;}
    
    public AccountRestorectrl() {
      actTmp = new Account();
    }
    
    public pageReference restoreAcct() {
        acctDormantID  = ApexPages.currentPage().getParameters().get('AcctDormantID'); 
        system.debug('Dormant ID:'+acctDormantID);
        AccountRestore aRestore = new AccountRestore();
        String returnValue;
        list<Account_Dormant__c> aDormant = [select id,AccountExtension__c from Account_Dormant__c where ID=:acctDormantID];
        if (aDormant.size() > 0)
            returnValue = aRestore.RestoreAccount(aDormant,ReasonCode,comments);
        if (returnValue != 'Success' && returnValue != 'Error' && returnValue !=null)
           return new PageReference('/'+returnValue);
        else
            return null;
    }
    
}
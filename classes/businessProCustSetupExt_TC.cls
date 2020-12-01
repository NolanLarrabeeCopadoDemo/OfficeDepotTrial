@isTest
public class businessProCustSetupExt_TC
{
    static testMethod void businessProCustSetupExtTest() 
    {
        Account acc = new Account ();
        acc.name = 'SUN Test Account1';
        
        Contact conObj = new Contact();
        conObj.LastName='LastNametest1';
        insert conObj;  
            
        test.startTest();
        businessProCustSetupExt busNsProCst = new businessProCustSetupExt();
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        businessProCustSetupExt business1 = new businessProCustSetupExt(sc);
        business1.bpAcct = acc;
        business1.bpContact = conObj;
        business1.cancelProAcct();
        business1.saveProAcct();
        test.stopTest();
    }
    static testMethod void businessProCustSetupExtTest1() 
    {
        Account acc = new Account ();
        acc.name = 'SUN Test Account1'; 
            
        test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        businessProCustSetupExt business1 = new businessProCustSetupExt(sc);
        business1.cancelProAcct();
        business1.saveProAcct();
        test.stopTest();
    }
}
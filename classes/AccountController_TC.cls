@isTest()
public class AccountController_TC {
      @IsTest
    Static void AccountControllertest(){
        
        Org__c OrN = new Org__c();
        OrN.Business_name__C = 'Test';
        insert OrN;
        
        Org__c OrN1 = new Org__c();
        OrN1.Business_name__C = 'Test1';
        OrN1.Parent_Org__C=OrN.Id;
        insert OrN1;
        
        Account Acc = new Account();
        Acc.Name='Test';
        Acc.Org__c = OrN.id;
        insert Acc;
        
        AccountController.findAll(Acc.id);
        AccountController.findAll(OrN.id);
        
    } 
}
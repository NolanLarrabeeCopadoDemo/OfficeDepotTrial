@isTest 
public class Test_AccountProductDataExtension {
    
 
   static testMethod void testAccountProductDataExtension() {
    Account account =  Test_Utils.CreateAccount();
    account.CPD_LY__c = 10;
    account.CPD_TY__c = 20;
    account.CPD_Pot__c = 40;
    update account;      
   // Opportunity opportunity = Test_Utils.CreateOpportunityWAccountWithoutSite(true,account.id);    
    ApexPages.StandardController controller = new ApexPages.StandardController(account);
    AccountProductDataExtension extension = new AccountProductDataExtension(controller);           
  } 

}
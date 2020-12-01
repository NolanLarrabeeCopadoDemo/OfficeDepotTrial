@isTest
public class Test_UpdateOrgChild {
  @isTest
    private static void test_UpdateOrgChild() {
           Org__C org = MyUtils_Org.GenerateOrg(12);
           insert org; 
        
        Account prospectAccount = Test_Utils.CreateAccount('Prospect');
        prospectAccount.org__C = org.id;
        //prospectAccount.Pricing_template_cd__c='testtestpri';
        insert prospectAccount;
        
        List<Account> accounts = new  List<Account> ();
        accounts.add(prospectAccount);
        
        Opportunity recentOpportunity= new Opportunity();
        recentOpportunity.Accountid=prospectAccount.id;
        
        Contract recentContract = new Contract();
        recentContract.Org__c=org.id;
        
        Contact recentContact= new Contact();
        recentContact.AccountId=prospectAccount.id;
        recentContact.LastName ='Testk';
        insert recentContact;
        
        Case recentcase = new Case();
        recentcase.AccountId=prospectAccount.id;
        insert recentcase;
        
		UpdateOrgChild UpdateOrgChildobj = new UpdateOrgChild();
        UpdateOrgChildobj.updateChild(accounts);
    }
}
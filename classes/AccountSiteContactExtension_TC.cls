//======================================================================// 
  //Test class for the controller
  //======================================================================//
  @isTest
  public class AccountSiteContactExtension_TC
{
   public static testMethod void Test_AccountSiteContactExtensionmethod() {
    Account account = Test_Utils.CreateAccount();
    contact c = new contact(lastname='test');
    c.Override_Duplicate_Check__c = true;
    c.accountId=account.Id;
    insert c;
    
    sitecontacts__c sc = new sitecontacts__c(account__c=account.id,contact__c=c.id);
    insert sc;
    
    ApexPages.StandardController scontroller = new ApexPages.StandardController(account);
    AccountSiteContactExtension extend = new AccountSiteContactExtension(scontroller);
    extend.ActionCode = 'P';
    extend.selectedSiteContact = sc.id;
    extend.getSiteContacts();
    extend.siteContactUpd();
    update c;
    delete c;
  }
  }
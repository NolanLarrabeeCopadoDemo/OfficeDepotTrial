/*********************************************************************
*Apex Class : RelatedSiteExtension
*Purpose : Queries the contact associated with Account records via Site Contact 1 to and 6, and primary
           and shows the accounts as related List
**********************************************************************/
public with sharing class RelatedSiteExtension {

  private Transient final Contact contact;
  private Transient List<Account> lstAccount;
  
  //===============================================================//
  //Constructor
  //===============================================================//
  public RelatedSiteExtension(ApexPages.StandardController controller) {
    this.contact = (Contact)controller.getRecord();
    PopulateAccountDetails();
  }
  
  public List<Account> getSiteAccounts() {
    return this.lstAccount;
  }
  
  private void PopulateAccountDetails() {
    this.lstAccount = [SELECT Name,Address1__c, Cadence_Call_Date__c, Open_Opp_Amt__c, Address2__c, City__c, State__c, Zip__c, Ranking__c, Ownerid, owner.name,Aops_seq_id__c,Phone,LastActivitydate FROM Account WHERE 
                       Site_Primary_Contact__c = :this.contact.ID OR
                       Site_Contact2__c = :this.contact.ID OR
                       Site_Contact3__c = :this.contact.ID OR
                       Site_Contact4__c = :this.contact.ID OR
                       Site_Contact5__c = :this.contact.ID OR
                       Site_Contact6__c = :this.contact.ID
                       ORDER BY Name
                      ];
  }
  
    
  //======================================================================//
  //Test class for the controller
  //======================================================================//
  @isTest
  private static void Test_AccountSiteContactExtension() {
  
    Account prospectAccount = Test_Utils.CreateAccount('Prospect');
    insert prospectAccount;
    
    Account account = Test_Utils.CreateAccount('Site');
    account.Related_Account__c = prospectAccount.Id;
    insert account;
    
    
    Contact contact = Test_Utils.CreateContact(prospectAccount.Id);    
    
    ApexPages.StandardController scontroller = new ApexPages.StandardController(contact);
    RelatedSiteExtension extend = new RelatedSiteExtension(scontroller);
    List<Account> actList = extend.getSiteAccounts();
    
    //Test that if we don't set Site_Contact values then it doesn't return any account list
    System.assertEquals(actList.size(),0);    
     
  }
  
}
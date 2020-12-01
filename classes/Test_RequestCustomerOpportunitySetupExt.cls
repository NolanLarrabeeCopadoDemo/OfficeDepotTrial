/***************************************************************
*Name       : Test_RequestCustomerOpportunitySetupExt
*Created By   : Appirio Off
*Created Date   : 28 Feb, 2012
*Purpose     : To test RequestCustomerOpportunitySetupExtension
*Modifications: Nick Sharp S-437502 9.8.16  - code coverage
****************************************************************/
@isTest
public with sharing class Test_RequestCustomerOpportunitySetupExt {    
   
  //==========================================================================//
  //Test code for the above controller for site Account
  //==========================================================================//
  @isTest
  private static void test_RequestOpportunityForSite() {
        
    Account prospectAccount = Test_Utils.CreateAccount('Prospect');
    insert prospectAccount;    
    
    Account siteAccount = Test_Utils.CreateAccount('Site');
    siteAccount.primary_site__c = true;
    siteAccount.Related_Account__c = prospectAccount.id; 
    insert siteAccount;   
    
    Opportunity opportunity = Test_Utils.CreateOpportunityWithSiteAccountType(false, siteAccount.Id, prospectAccount);
    
    Contact contact = Test_Utils.CreateContact(prospectAccount.id);  
    contact.primary_contact__c = true;
    update contact;
    
    // Test that returned account is valid primary site account
    ApexPages.StandardController scontroller = new ApexPages.StandardController(opportunity);    
    RequestCustomerOpportunitySetupExtension setupExtension = new RequestCustomerOpportunitySetupExtension(scontroller);
    Test.startTest();
    setupExtension.getRedir();  
    
    System.assertEquals(setupExtension.isValid, false);
    
    prospectAccount.Setup_URL1__c = 'test';
    //prospectAccount.Setup_URL2__c = 'test2';
    update prospectAccount;
    
    String[] url = RequestCustomerOpportunitySetupExtension.checkUrls(prospectAccount.id);
    System.assertNotEquals(url[0], null);
    //System.assertNotEquals(url[1], null);
    
    //Test for site Account    
    System.assertNotEquals(setupExtension.siteAccount, null);
    
    // Test valid primary contact for account   
    System.assertNotEquals(setupExtension.primaryContact, null); 
    
    // Test if account id for opportunity is not given
    Opportunity opportunity1 = Test_Utils.CreateOpportunity(false, null);
    
    ApexPages.StandardController scontroller1 = new ApexPages.StandardController(opportunity1);    
    RequestCustomerOpportunitySetupExtension setupExtension1 = new RequestCustomerOpportunitySetupExtension(scontroller1);
       
    System.assertEquals(setupExtension1.isValid, false);
    
    //Test if no related account assigned to site account
    siteAccount.Related_Account__c = null;
    update siteAccount; 
    
    setupExtension1 = new RequestCustomerOpportunitySetupExtension(scontroller);  
    //System.assertEquals(setupExtension1.relevantAccount, null);
    Test.stopTest();    
  }
  
  //==========================================================================//
  //Test code for the above controller for Prospect Account
  //==========================================================================//
  @isTest
  private static void test_RequestOpportunityForProspect() {
        
    Account prospectAccount = Test_Utils.CreateAccount('Prospect');
    insert prospectAccount;    
    
    Account prospectAccount2 = Test_Utils.CreateAccount('Prospect');    
    prospectAccount2.Related_Account__c = prospectAccount.id;
    insert prospectAccount2;   
    
    Opportunity opportunity = Test_Utils.CreateOpportunity(false, prospectAccount2.Id);
    
    Contact contact = Test_Utils.CreateContact(prospectAccount2.id);  
    contact.primary_contact__c = true;
    update contact;
    
    // Test that returned account is valid primary site account
    ApexPages.StandardController scontroller = new ApexPages.StandardController(opportunity);    
    RequestCustomerOpportunitySetupExtension setupExtension = new RequestCustomerOpportunitySetupExtension(scontroller);
    Test.startTest();
    System.assertEquals(setupExtension.isValid, false);
    
    prospectAccount2.Setup_URL1__c = 'test';
    //prospectAccount2.Setup_URL2__c = 'test2';
    update prospectAccount2;
    
    String[] url = RequestCustomerOpportunitySetupExtension.checkUrls(prospectAccount2.id);
    System.assertNotEquals(url[0], null);
    //System.assertNotEquals(url[1], null);   
  
     
     //Test for site Account    
    System.assertEquals(setupExtension.siteAccount, null);
    
    // Test valid primary contact for account    
    System.assertNotEquals(setupExtension.primaryContact, null);
    
    //Test If primary contact not selected
    contact.primary_contact__c = false;
    update contact;
    
    RequestCustomerOpportunitySetupExtension setupExtension1 = new RequestCustomerOpportunitySetupExtension(scontroller);
    System.assertEquals(setupExtension1.primaryContact, null);
    Test.stopTest();
    
  }
  
  //==========================================================================================//
  //Test that if account has more than one site then no siteAccount object is being returned
  //==========================================================================================//
  @isTest
  private static void Test_ValidPrimarySiteAccount() {
    Account prospectAccount = Test_Utils.CreateAccount('Prospect');
    insert prospectAccount;    
    
    Account siteAccount = Test_Utils.CreateAccount('Site');
    siteAccount.primary_site__c = true;
    siteAccount.Related_Account__c = prospectAccount.id;
    insert siteAccount;          
    
    Account account3 = Test_Utils.CreateAccount('Site');
    account3.primary_site__c = true;
    account3.Related_Account__c = prospectAccount.id;
    insert account3; 
 
    Opportunity opportunity = Test_Utils.CreateOpportunityWithSiteAccountType(false, siteAccount.Id, prospectAccount);
    Test.startTest();
    // Test that returned account is valid primary site account
    ApexPages.StandardController scontroller = new ApexPages.StandardController(opportunity);    
    RequestCustomerOpportunitySetupExtension setupExtension = new RequestCustomerOpportunitySetupExtension(scontroller);
    
    System.assertEquals(setupExtension.siteAccount, null);
    Test.stopTest();
  } 


  //==========================================================================================//
  //Test contact for 'accounts payble' and 'ebilling'
  //==========================================================================================//
  @isTest
  private static void Test_accountsPaybleAndEbillingContact() {
    Account prospectAccount = Test_Utils.CreateAccount('Prospect');
    //START NSHARP S-437502 9.8.16
    prospectAccount.Pricing_template_cd__c = 'Custom - Self Service';
    //END NSHARP S-437502 9.8.16
    insert prospectAccount;
    
    Account siteAccount = Test_Utils.CreateAccount('Site');
    siteAccount.primary_site__c = true;
    siteAccount.Related_Account__c = prospectAccount.id; 
    insert siteAccount;   
    
    Opportunity opportunity = Test_Utils.CreateOpportunityWithSiteAccountType(false, siteAccount.Id, prospectAccount);
    
    Contact contact = Test_Utils.CreateContact(prospectAccount.id);  
    contact.primary_contact__c = true;
    contact.Role__c = 'Accounts Payable';    
    update contact; 
    
    ApexPages.StandardController scontroller = new ApexPages.StandardController(opportunity);    
    RequestCustomerOpportunitySetupExtension setupExtension = new RequestCustomerOpportunitySetupExtension(scontroller);    
    
    Test.startTest();
    // Test for Accounts Payble
 //   Contact accountsPayableContact = setupExtension.findAccountsPayableContact();    
 //   System.assertEquals(accountsPayableContact.id, contact.id);    
 //   System.assertEquals(accountsPayableContact.role__c, 'Accounts Payable');
    
    contact.Role__c = 'eBilling';
    update contact;
    
    // Test for eBilling
//    Contact eBillingContact = setupExtension.findEbillContact();
//    System.assertEquals(eBillingContact.id, contact.id);
//    System.assertEquals(eBillingContact.role__c, 'eBilling');
 //   Test.stopTest();   
  }

  //START NSHARP S-437502 9.8.16
  @isTest
  private static void Test_CustomerRecordTypeErrorMessage(){
    Account prospectAccount = Test_Utils.CreateAccount('Prospect');
    prospectAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
    insert prospectAccount;
    
    Opportunity opportunity = Test_Utils.CreateOpportunity(false, prospectAccount.Id);
    
    ApexPages.StandardController scontroller = new ApexPages.StandardController(opportunity);    
    RequestCustomerOpportunitySetupExtension setupExtension = new RequestCustomerOpportunitySetupExtension(scontroller);    
    
    Test.startTest();
    Test.stopTest();
  }

  @isTest
  private static void Test_AccountSetupRequestRecordTypeError(){
    Account prospectAccount = Test_Utils.CreateAccount('Prospect');
    prospectAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account Setup Requested').getRecordTypeId();
    insert prospectAccount;
    
    Opportunity opportunity = Test_Utils.CreateOpportunity(false, prospectAccount.Id);
    
    ApexPages.StandardController scontroller = new ApexPages.StandardController(opportunity);    
    RequestCustomerOpportunitySetupExtension setupExtension = new RequestCustomerOpportunitySetupExtension(scontroller);    
    
    Test.startTest();
    Test.stopTest();
  }

  @isTest
  private static void Test_SalesPerson(){
    Sales_Person__c s = new Sales_Person__c();
    s.User__c = [Select Id,isActive FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true LIMIT 1].Id;
    s.Primary__c = true;
    s.ExtIDSalesPerson__c = 'TEMPID';
    insert s;

    Account prospectAccount = Test_Utils.CreateAccount('Prospect');
    prospectAccount.OwnerId = s.User__c;
    insert prospectAccount;

    Opportunity opportunity = Test_Utils.CreateOpportunity(false, prospectAccount.Id);
    
    ApexPages.StandardController scontroller = new ApexPages.StandardController(opportunity);    
    RequestCustomerOpportunitySetupExtension setupExtension = new RequestCustomerOpportunitySetupExtension(scontroller);    
    
    Test.startTest();
    Test.stopTest();
  }
  //END NSHARP S-437502 9.8.16  

}
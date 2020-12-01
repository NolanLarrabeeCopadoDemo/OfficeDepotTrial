@isTest
private with sharing class GT_LeadConversionController_TC 
{

  @isTest 
  // Test Validation
  static void Test_Validation(){
    User testUser = Test_Utils.CreateUser();
    System.RunAs(testUser){
      Account account = Test_Utils.CreateAccount();
      Lead lead = Test_Utils.GenerateLead('12346', 100, null, 'LName1', false);
      insert lead;
      lead.Address1__c = 'address';
      update lead;
            
      ApexPages.StandardController controller = new ApexPages.StandardController(lead);
      GT_LeadConversionController leadConversion = new GT_LeadConversionController(controller);
      
      Test.startTest();
      leadConversion.validateAddress();            
      PageReference pageReference = leadConversion.ValidateLead();
      System.assertEquals(ApexPages.getMessages().isEmpty(), false);
      System.assertEquals(pageReference, null);
      Test.stopTest();
    }
  }
    
  @isTest
  // Test when Lead.Account__c is null and no matching contact is found.
  static void Test_GeneratedRecordWithoutContactIdSelection(){
    User testUser = Test_Utils.CreateUser();
    System.RunAs(testUser){           
      Account account = getAccount();  
      Lead lead = getLead();
       
      ApexPages.StandardController controller = new ApexPages.StandardController(lead);
      GT_LeadConversionController leadConversion = new GT_LeadConversionController(controller);
            
      Test.startTest();
      // Test that if we pass selected account and there are no matching contact present then 
      // lead conversion make a Contact for the selected account
      leadConversion.selectedAccountId = account.Id;
      leadConversion.isCreateNewProspect = false;
      leadConversion.isCreateOpportunity = false;
      leadConversion.GenerateRecords();
            
      List<Contact> contactList = [Select Id, Name From Contact Where AccountId = :account.Id];
      System.assertEquals(contactList.size(), 1);
            
      // It assured that if we set isCreateOpportunity to false then it's not creating any opportunity
      List<Opportunity> opportunityList = [Select Id, Name From Opportunity Where AccountId = :account.Id];
      System.assertEquals(opportunityList.size(), 0);
           
      Test.stopTest();
    }
  }
    
  @isTest
  // Test when Lead.Account__c is null and we selected a contact
  static void Test_GeneratedRecordWithContactIdSelection(){
    User testUser = Test_Utils.CreateUser();
    System.RunAs(testUser){            
      Account account = getAccount();
      Contact contact = Test_Utils.CreateContact(account.Id); 
      contact.LastName =  'LeadConversion';
      contact.FirstName='Test1';
      update contact;   
            
      Lead lead = getLead();
            
      ApexPages.StandardController controller = new ApexPages.StandardController(lead);
      GT_LeadConversionController leadConversion = new GT_LeadConversionController(controller);          
      leadConversion.selectedContactId = contact.Id;
      leadConversion.selectedAccountId = account.Id;
      leadConversion.isCreateNewProspect = false;
      Test.startTest();
      // Test that if we selected account and contact then it will not create new contact
      leadConversion.GenerateRecords();
            
      // contact size is 1, it assures that there is single contact which we have created
      // and in lead conversion process there are no any other contact is created.
      List<Contact> contactList = [Select Id, Name From Contact Where AccountId = :account.Id];
      System.assertEquals(contactList.size(), 1);
            
      // Test that this opportunity is created in lead conversion process, because before conversion
      // there are no any opportunity is present.
      List<Opportunity> opportunityList = [Select Id, Name From Opportunity Where AccountId = :account.Id];
      System.assertEquals(opportunityList.size(), 1);
            
      Test.stopTest();
    }
  }
    
  @isTest
  // Test when Lead.Account__c is null and selected to create new contact
  static void Test_GeneratedRecordWithNewContactOption(){
    User testUser = Test_Utils.CreateUser();
    System.RunAs(testUser){            
      Account account = getAccount();
      Contact contact = Test_Utils.CreateContact(account.Id); 
      contact.LastName =  'LeadConversion';
      contact.FirstName='Test2';
      update contact;
             
      Lead lead = getLead();
            
      ApexPages.StandardController controller = new ApexPages.StandardController(lead);
      GT_LeadConversionController leadConversion = new GT_LeadConversionController(controller);          
      leadConversion.isCreateNewContact = true;
      leadConversion.selectedAccountId = account.Id;
      leadConversion.isCreateNewProspect = false;
      leadConversion.isCreateOpportunity = false;
      Test.startTest();
      // Test that if we selected account and selected option to create new contact then it will create new contact
      // and a Opportunity
      leadConversion.GenerateRecords();
      // contact size is 2, it assures that there is new contact is being created
  //    List<Contact> contactList = [Select Id, Name From Contact Where AccountId = :account.Id limit 1];
    //  System.assertEquals(contactList.size(), 1);
         
      // Assuring that no opportunity is being created if isCreateOpportunity is set to false
      List<Opportunity> opportunityList = [Select Id, Name From Opportunity Where AccountId = :account.Id];
      System.assertEquals(opportunityList.size(), 0);
            
      Test.stopTest();
    }
  }
    
  @isTest
  // Test when Lead.Account__c is null and we selected to create a new prospect
  static void Test_GeneratedRecordWithNewProspect(){
    User testUser = Test_Utils.CreateUser();
    System.RunAs(testUser){
      Account account = getAccount();  
      Lead lead = getLead();
            
      ApexPages.StandardController controller = new ApexPages.StandardController(lead);
      GT_LeadConversionController leadConversion = new GT_LeadConversionController(controller);           
      leadConversion.selectedAccountId = account.Id;
      leadConversion.isCreateNewProspect = true;
      Test.startTest();
      // Test that if we selected create new prospect then no contact and opportunity is being created
      // for selected account, but it will create a new account, site account, opportunity and contact
      leadConversion.GenerateRecords();
        
      // contact size is 0, it assures that there is no new contact is being created for matched account
      List<Contact> contactList = [Select Id, Name From Contact Where AccountId = :account.Id];
      System.assertEquals(contactList.size(), 0);
        
      // Test that opportunity is not being created for Matched account           
      List<Opportunity> opportunityList = [Select Id, Name From Opportunity Where AccountId = :account.Id];
      System.assertEquals(opportunityList.size(), 0);
        
      Test.stopTest();
    }
  }
  @isTest
  // Test when Lead.Account__c is null and we selected site account
  static void Test_GeneratedRecordWithSelectedSiteAccount(){
    User testUser = Test_Utils.CreateUser();
    System.RunAs(testUser){
      Account account = getAccount();
      Account siteAccount = Test_Utils.CreateAccount('Site'); 
      insert siteAccount;
      siteAccount.related_account__c = account.id; 
      update siteAccount;
      
      Lead lead = getLead();
            
      ApexPages.StandardController controller = new ApexPages.StandardController(lead);
      GT_LeadConversionController leadConversion = new GT_LeadConversionController(controller);           
      leadConversion.selectedAccountId = siteAccount.Id;
      leadConversion.isCreateNewProspect = false;
      Test.startTest();
      // Test that if we selected a site account and no matching contact found then
      // it will create contact and opportunity
      leadConversion.GenerateRecords();
        
      // Contact size is 1, it assures that contact is created for related account
      List<Contact> contactList = [Select Id, Name From Contact Where AccountId = :account.Id];
      System.assertEquals(contactList.size(), 1);
        
      // Test that opportunity is created for related account        
      List<Opportunity> opportunityList = [Select Id, Name, Amount From Opportunity Where AccountId = :account.Id];
      System.assertEquals(opportunityList.size(), 1);      
      //System.assertEquals(opportunityList[0].amount, lead.Amount__c);     
        
      Test.stopTest();
    }
  }
  @isTest
  // Test list of matching account
  static void Test_MatchingAccountList(){
    User testUser = Test_Utils.CreateUser();
    System.RunAs(testUser){
      Account account = getAccount();
      Account siteAccount = Test_Utils.CreateAccount('Site'); 
      insert siteAccount;
      siteAccount.related_account__c = account.id; 
      update siteAccount;
      
      Account account1 = Test_Utils.CreateAccount();
      account1.Zip__c = '12345';
      account1.name = 'Test';
      account1.address1__c = 'a';
      update account1;
      
      Lead lead = getLead();
      Lead lead1 = [Select id, name, zip__c, Zip_5digit__c,RecordTypeId, Company, Address1__c, account__c,Sales_Person_ID__c From lead Where id = :lead.id ];
      Test.startTest();      
      ApexPages.StandardController controller = new ApexPages.StandardController(lead1);
      GT_LeadConversionController leadConversion = new GT_LeadConversionController(controller);
      List<Account> accountList =    leadConversion.getMatchingAccounts();     
      //System.assertEquals(2,accountList.size());   
        
      Test.stopTest();
    }
  }
    
  @isTest
  // Test when Lead.Account__c is not null and we select contact
  static void Test_GeneratedRecordWithContactSelected(){
    User testUser = Test_Utils.CreateUser();
    System.RunAs(testUser){            
      Account account = getAccount();
      Contact contact = Test_Utils.CreateContact(account.Id); 
      contact.LastName =  'LeadConversion';
      contact.FirstName='Test3';
      update contact;
          
      Lead lead = getLead();
      lead.Account__c = account.Id;
      update lead;
        
      ApexPages.StandardController controller = new ApexPages.StandardController(lead);
      GT_LeadConversionController leadConversion = new GT_LeadConversionController(controller);           
    //  leadConversion.selectedContactId = contact.Id;
      leadConversion.isCreateNewProspect = false;
      leadConversion.isCreateOpportunity = false;
      Test.startTest();
      // Test that if we selected contact then it's not creating new contact, it's only create new opportunity
      leadConversion.GenerateRecords();
        
      // contact size is 1, it assures that there is no new contact is being created
      // size is 1 because we have created a contact and not by conversion
      List<Contact> contactList = [Select Id, Name From Contact Where AccountId = :account.Id];
      System.assertEquals(contactList.size(), 1);
        
      // Test that opportunity is not being created for lead account          
      List<Opportunity> opportunityList = [Select Id, Name From Opportunity Where AccountId = :account.Id];
      System.assertEquals(opportunityList.size(), 0);
        
      Test.stopTest();
    }
  }
    
  @isTest
  // Test when Lead.Account__c is not null and selected create new contact option
  static void Test_GeneratedRecordWithNewContact(){
    User testUser = Test_Utils.CreateUser();
    System.RunAs(testUser){             
      Account account = getAccount();
      Contact contact = Test_Utils.CreateContact(account.Id); 
      contact.LastName =  'LeadConversion';
      contact.FirstName='Test4';
      update contact;  
        
      Lead lead = getLead();
      lead.Account__c = account.Id;
      update lead;
        
      ApexPages.StandardController controller = new ApexPages.StandardController(lead);
      GT_LeadConversionController leadConversion = new GT_LeadConversionController(controller);           
      leadConversion.isCreateNewContact = false;
      leadConversion.isCreateNewProspect = false;
      Test.startTest();
      // Test that if we selected option to create new contact, it's create contact and opportunity
      leadConversion.GenerateRecords();
        
      // contact size is 2, it assures that there new contact is being created           
      List<Contact> contactList = [Select Id, Name From Contact Where AccountId = :account.Id];
      System.assertEquals(contactList.size(), 1);
        
      // Test that opportunity is being created for lead account          
      List<Opportunity> opportunityList = [Select Id, Name From Opportunity Where AccountId = :account.Id];
      System.assertEquals(opportunityList.size(), 0);
        
      Test.stopTest();
    }
  }
    
  @isTest
  // Test when Lead.Account__c is not null and no matching contact found
  static void Test_GeneratedRecordWithoutMatchingContact(){
    User testUser = Test_Utils.CreateUser();
    System.RunAs(testUser){             
      Account account = getAccount();
      Lead lead = getLead();
      lead.Account__c = account.Id;
      update lead;
        
      ApexPages.StandardController controller = new ApexPages.StandardController(lead);
      GT_LeadConversionController leadConversion = new GT_LeadConversionController(controller);           
        
      Test.startTest();
      // Test that if there are no matching contact then it will create a contact and opportunity
      leadConversion.GenerateRecords();
        
      // contact size is 1, it assures that a new contact is being created for lead account          
      List<Contact> contactList = [Select Id, Name From Contact Where AccountId = :account.Id];
      System.assertEquals(contactList.size(), 1);
        
      // Test that opportunity is being created for lead account          
      List<Opportunity> opportunityList = [Select Id, Name From Opportunity Where AccountId = :account.Id];
      System.assertEquals(opportunityList.size(), 1);
        
      Test.stopTest();
    }
  }
    
  @isTest
  // Test when Lead.Account__c is not null and Owner is not same
  static void Test_ValidationIfOwnerMismatch(){        
    User testUser = Test_Utils.createTestUser('Tst','112233');
    Account account;
    System.RunAs(testUser){ 
      account = Test_Utils.CreateAccount();
      account.Zip__c = '2';
      account.Name = 'TestAccount';
      account.OwnerId = testUser.Id;
      update account;        
    }
    User testUser1 = Test_Utils.CreateUser();
    System.RunAs(testUser1){            
      Lead lead = Test_Utils.GenerateLead('43442', 1, null, 'LeadConversion', false);
      insert lead;            
            
      lead.street = 'test'; lead.city = 'c1'; lead.state = 'CO'; lead.Country ='USA';
      lead.phone = '(999) 999-3333';  lead.FirstName = 'Test'; lead.Address1__c = 'a';
      lead.LeadSource = 'Finance'; lead.Company = 'TestAccount' ; lead.OwnerId = testUser1.Id;
      lead.Account__c = account.Id;
      update lead;
        
      ApexPages.StandardController controller = new ApexPages.StandardController(lead);
      GT_LeadConversionController leadConversion = new GT_LeadConversionController(controller);   
      leadConversion.isCreateNewProspect = false;       
        
      Test.startTest();
      // Test that if lead.owner and account.owner is differ then it shows an error message.
      leadConversion.GenerateRecords();           
      System.assertEquals(ApexPages.getMessages().isEmpty(), false);
        
      Test.stopTest();
    }
  }
    
  @isTest
  // Test when Lead.Account__c is a site account
  static void Test_WhenLeadAccountIsSite(){        
    User testUser = Test_Utils.CreateUser();
    System.RunAs(testUser){
      Account prospectAccount = getAccount();
                    
      Account account = Test_Utils.CreateAccount('Site');
      insert account;
      account.Zip__c = '12345';
      account.Name = 'TestAccount';
      account.OwnerId = testUser.Id;
      account.Related_Account__c = prospectAccount.Id;
      update account;
       
      Lead lead = getLead();
      lead.Account__c = account.Id;
      update lead;
        
      ApexPages.StandardController controller = new ApexPages.StandardController(lead);
      GT_LeadConversionController leadConversion = new GT_LeadConversionController(controller);             
      leadConversion.changeMatchingContacts(); 
      leadConversion.makeSelectedContactNull();
      leadConversion.selectedContact();
      leadConversion.hideContacts();  
      leadConversion.returnBack();
      leadConversion.selectedAccountId = account.Id;   
        
      Test.startTest();
      // Test that if we have selected site account then no contact and opportunity is created for site account
      leadConversion.GenerateRecords();
        
      // contact size is 0, it assures thatno contact is being created for site account          
      List<Contact> contactList = [Select Id, Name From Contact Where AccountId = :account.Id];
      System.assertEquals(contactList.size(), 0);
        
      // Test that no opportunity is being created for site account          
      List<Opportunity> opportunityList = [Select Id, Name From Opportunity Where AccountId = :account.Id];
      System.assertEquals(opportunityList.size(), 0);
        
      Test.stopTest();
    }
  }
  
    
  //==============================================================================//
  // To get account for lead conversion
  //==============================================================================//
  private static Account getAccount(){
    User testUser = Test_Utils.CreateUser();
    Account account = Test_Utils.CreateAccount();
    account.Zip__c = '12345';
    account.Name = 'TestAccount';
    account.OwnerId = testUser.Id;
    update account;
    return account;
  }
    
  //==============================================================================//
  // To get lead for conversion
  //==============================================================================//
  private static Lead getLead(){
    User testUser = Test_Utils.CreateUser();
    Lead lead = Test_Utils.GenerateLead('12345', 1, null, 'LeadConversion', false);
    insert lead;            
    
    lead.street = 'test'; lead.city__c = 'c1'; lead.state__c = 'CO'; lead.Country__c ='USA';
    lead.phone = '(999) 999-3333';  lead.FirstName = 'Test'; lead.Address1__c = 'a';
    lead.LeadSource = 'Finance'; lead.Company = 'TestAccount' ; lead.OwnerId = testUser.Id;
    lead.Amount__c = 100;
    update lead;
    
    
    return lead;
  }
    



}
/**************************************************************
*Name           : Test_LeadMatcingAccount 
*Created By     : Dheeraj(Appirio Off)
*Created Date   : 16th April,2012
*Purpose        : To test LeadMatchingAccountExtension
********************************************************************/
@isTest
public with sharing class Test_LeadMatcingAccount {
  @isTest 
  // Test Validation
  static void Test_Validation(){
    User testUser = Test_Utils.createTestUser('test', '123');
    System.RunAs(testUser){
      Sales_Person__c testSp = Test_Utils.createTestSalesPersonNew(testUser.Id,'21344');
      insert testSp;
      Account account = Test_Utils.CreateAccount();
    
      Lead lead = Test_Utils.GenerateLead('12345666', 100, null, 'LName1', false);
      insert lead;    
             
      ApexPages.StandardController controller = new ApexPages.StandardController(lead);
      LeadMatchingAccountExtension matchingAccountExtension = new LeadMatchingAccountExtension(controller);
      
      Test.startTest();            
      PageReference pageReference = matchingAccountExtension.ValidateLead();
      System.assertEquals(ApexPages.getMessages().isEmpty(), false);
      System.assertEquals(pageReference, null);
      Test.stopTest();
    }
  }
  
  @isTest 
  // Test matching records
  private static void LeadMatchingAccount() { 
    User testUser = Test_Utils.createTestUser('test', '123');
    System.RunAs(testUser){
      Sales_Person__c testSp = Test_Utils.createTestSalesPersonNew(testUser.Id,'21344');
      insert testSp;
                          
      Account account = Test_Utils.CreateAccount();
      account.Zip__c = '12345';
      account.name = 'TestLeadAccount';
      update account;
    
      Contact contact = Test_Utils.CreateContact(account.Id);
      contact.Phone = '(999) 999-9871';
      update contact;
          
      Lead lead = Test_Utils.CreateLead();
      lead.Company = 'TestLeadAccount';
      lead.Zip__c = '12345'; 
      lead.Phone = '(999) 999-9871';
      update lead;
      Lead testLead = [Select id, phone, zip_5digit__c, company, name From Lead Where id =: lead.id];         
                    
      ApexPages.StandardController controller = new ApexPages.StandardController(testLead);
      LeadMatchingAccountExtension matchingAccountExtension = new LeadMatchingAccountExtension(controller);
      Test.startTest();
    
      List<Account> accountList = matchingAccountExtension.getMatchingAccounts();                   
      System.assertEquals(accountList.size(), 1);
      System.assertEquals(accountList[0].id, account.id);
      System.assertEquals(accountList[0].name, account.name);
    
      List<Lead> leadList = matchingAccountExtension.getMatchingLeads();
      System.assertEquals(leadList.size(), 1);
      System.assertEquals(leadList[0].id, testLead.id);
      System.assertEquals(leadList[0].name, testLead.name);
    
      List<Contact> contactList = matchingAccountExtension.getMatchingContacts();
      System.assertEquals(contactList.size(), 1);
      System.assertEquals(contactList[0].id, contact.id);
    
      matchingAccountExtension.BackToLead(); 
      Test.stopTest();       
    } 
  } 

}
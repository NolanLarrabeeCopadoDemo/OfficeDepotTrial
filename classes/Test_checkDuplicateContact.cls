/******************************************************************
*Apex Class :Test_checkDuplicateContact
*Created By : Appirio Off (29th Sep,2011)
*Purpose : To test checkDuplicateContact trigger
*Last Modified By : Appirio Off (Dheeraj, 25th Dec,2011)
*******************************************************************/
@isTest
private class Test_checkDuplicateContact {
  
  //======================================================================================================//
  //Test checkDuplicateContacts Trigger on Contact,includes population of contact fields on Account record
  //=====================================================================================================//
   @isTest  
     private static void chkDuplicateContact() {
     
           Id recId= [SELECT Id from RecordType where SObjectType='Contact' and DeveloperName ='Contact_US'].Id;

      //Create Customer Account;
      Account prospectAccount = Test_Utils.CreateAccount('Prospect');
      insert prospectAccount; 
      
      Contact contact = new Contact(LastName = 'TEST15',AccountId = prospectAccount.Id);
      contact.MailingCountry = 'MEX';
            contact.recordtypeId=recId;    

      insert contact;
      
      //Create site Account,related to above Customer Account
      Account siteAccount = Test_Utils.CreateAccount('Site');
      siteAccount.Related_Account__c = prospectAccount.Id;    
      insert siteAccount;
      
      //Create a Master Contact record
      Contact masterContact = Test_Utils.CreateContact(prospectAccount.Id);
      masterContact.Site_Account__c = siteAccount.Id;   
            masterContact.recordtypeId=recId;    
  
      update masterContact; 
      
      
      
      Test.startTest();
      
      //------------------------------------------------------------------------//
    //Test contacts with same LastName
    //------------------------------------------------------------------------// 
      Contact contact1 = masterContact.clone(false,true,false,false);
      try {
            contact1.recordtypeId=recId;    

        insert contact1;
      }
      catch(DMLException e) {       
        // LastName is same in both contact so it must throw exception tested below
        //System.assert(e.getMessage().contains('Duplicate contact found with same Last Name. If you still want to create this contact '));        
      }
      
      //Testing that with same LastName only a single contact added
      List<Contact> lstContact = [SELECT LastName,Email from Contact where LastName = :masterContact.LastName AND AccountId = :masterContact.AccountID];
      //Test size of added contact list (it must be 1)
      //System.assertEquals(lstContact.size(),1);
      
      
      //------------------------------------------------------------------------//
    //Test contacts with same E-mail address
    //------------------------------------------------------------------------// 
    masterContact.Email = 'touchtheskywithGlory@gmail.com';
    update masterContact;
    
      Contact contact2 = masterContact.clone(false,true,false,false);
      contact2.LastName = 'DDDDD';
            contact2.recordtypeId=recId;    

        try {
        insert contact2;
      }
      // E-mail address is same in both contact so it must throw exception tested below
      catch(DMLException e) {
        //System.Assert(e.getMessage().contains('Duplicate contact found with same Email'));     
      } 
  
      //Testing that with same LastName only a single contact added
    lstContact = [SELECT LastName,Email from Contact where Email = :masterContact.Email AND AccountId = :masterContact.AccountID];
    
    //Test size of added contact list (it must be 1)
    //System.assertEquals(lstContact.size(),1);
    
    //------------------------------------------------------------------------//
    //Test override duplicate functionality
    //------------------------------------------------------------------------// 
          Contact contact3 = masterContact.clone(false,true,false,false);
      contact3.LastName = 'DDDDD';

    contact3.Override_Duplicate_Check__c = true;
          contact3.recordtypeId=recId;    

    insert contact3;
    
    lstContact = [SELECT LastName,Email from Contact where Email = :masterContact.Email AND AccountId = :masterContact.AccountID];
    //System.assertEquals(lstContact.size(),2);
    
    //-------------------------------------------------------------------------//
    //Check primary contact,population
    //Since the trigger executes on insert only, contact 2 would be the primary contact
    //-------------------------------------------------------------------------//
    Account account = [SELECT Site_Primary_Contact__c,Site_Contact2__c FROM Account WHERE ID = :siteAccount.ID]; 
    //System.assertEquals(account.Site_Primary_Contact__c,contact2.Id);
    
    Test.stopTest();
  }
  
  //======================================================================================================//
  //Test checkDuplicateContacts Trigger on Contact,includes population of contact fields on Account record
  //=====================================================================================================//
   @isTest  
     private static void chkDuplicateContactWithSiteContacts() {
               Id recId= [SELECT Id from RecordType where SObjectType='Contact' and DeveloperName ='Contact_US'].Id;

      //Create Customer Account;
      Account prospectAccount = Test_Utils.CreateAccount('Prospect');
      insert prospectAccount;     
       
      Contact contact = new Contact(LastName = 'TEST15',AccountId = prospectAccount.Id);
      contact.MailingCountry = 'MEX';      
            contact.recordtypeId=recId;    

      insert contact;
      
      //Create site Account,related to above Customer Account
      Account siteAccount = Test_Utils.CreateAccount('Site');
      siteAccount.Site_Primary_Contact__c = contact.Id;
      //siteAccount.Site_Contact2__c = contact.Id;
      siteAccount.Related_Account__c = prospectAccount.Id;
      insert siteAccount;     
      Contact contact1 = Test_Utils.CreateContactForCheckDuplicate('TEST16', prospectAccount.Id, siteAccount.Id );
      //Create site Account,related to above Customer Account
      Account siteAccount1 = Test_Utils.CreateAccount('Site');
      siteAccount1.Site_Primary_Contact__c = contact.Id;
      siteAccount1.Site_Contact2__c = contact.Id;
      siteAccount1.Related_Account__c = prospectAccount.Id;
      insert siteAccount1;        
      Contact contact2 = Test_Utils.CreateContactForCheckDuplicate('TEST17', prospectAccount.Id, siteAccount1.Id );  
      
      
      //Create site Account,related to above Customer Account
      Account siteAccount4 = Test_Utils.CreateAccount('Site');
      siteAccount4.Site_Primary_Contact__c = contact.Id;
      siteAccount4.Site_Contact2__c = contact.Id;
      siteAccount4.Site_Contact3__c = contact.Id;
      siteAccount4.Site_Contact4__c = contact.Id;
      siteAccount4.Site_Contact5__c = contact.Id;
      siteAccount4.Related_Account__c = prospectAccount.Id;
      Test.startTest();
      insert siteAccount4;  
      Contact contact5 = Test_Utils.CreateContactForCheckDuplicate('TEST20', prospectAccount.Id, siteAccount4.Id );
      Test.stopTest();
     }
     
  //============================================================//
  // Test site accounts
  //============================================================//
   @isTest  
     private static void testValidateSiteAccounts() {
                Id recId= [SELECT Id from RecordType where SObjectType='Contact' and DeveloperName ='Contact_US'].Id;

      //Create Customer Account;
      Account customerAccount = Test_Utils.CreateAccount('Customer');
      insert customerAccount;
      
      Account prospectAccount = Test_Utils.CreateAccount('Prospect');
      insert prospectAccount;
      
      Account siteAccount = Test_Utils.CreateAccount('Site');
      insert siteAccount;
      siteAccount.Related_Account__c = prospectAccount.Id;
      update siteAccount;
      
      Contact contact = new Contact(LastName = 'TESTING',AccountId = customerAccount.Id);
      contact.MailingCountry = 'MEX';  
      contact.recordtypeId=recId;    
      insert contact;
      
     }   
}
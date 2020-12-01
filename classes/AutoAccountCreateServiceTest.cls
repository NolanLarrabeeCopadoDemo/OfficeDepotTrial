//
// (c) 2015 Appirio, Inc.
//
// Test Class for the Auto Account Create Service
//
// 02 September 2015     Luke Slevin       Original
//
@isTest
public with sharing class AutoAccountCreateServiceTest {

  @isTest static void testAutoAccountCreation()
  {
    test.startTest();

    AutoAccountCreateService.AccountInformation accInfo = new AutoAccountCreateService.AccountInformation();
    accInfo.FIRSTNAME = 'Test First Name';
        accInfo.LASTNAME = 'Test Last Name';
        accInfo.EMAIL = 'test@testing.com';
        accInfo.PHONE = '3739283494';
        accInfo.PHONEEXT = '345';
        //accInfo.ACCOUNTTYPE = 'Single User';
        accInfo.ACCOUNTTYPE = 'Single'; //Added for Story S-355191
        accInfo.COMPANYNAME = 'Test Company';
        accInfo.EINNUM = '473847';
        //accInfo.TOTALEMPLOYEES = '18387'; 
        accInfo.TOTALEMPLOYEES = '1-149';   //Added for Story S-355191 //Modified by Lalit for S-407229
        accInfo.ADDRESS1 = '201 South Capital Avenue';
        accInfo.ADDRESS2 = '';
        accInfo.CITY = 'Indianapolis';
        accInfo.STATE = 'Indiana';
        accInfo.ZIP = '46225';
        accInfo.WEBSITE = 'www.appirio.com';
        //accInfo.TAXEXEMPT = 'N';
        accInfo.TAXEXEMPT = 'false';    //Added for Story S-355191
      //accInfo.ACCOUNTBILLING = 'Y';
        accInfo.ACCOUNTBILLING = 'true';    //Added for Story S-355191
        accInfo.STATUSMESSAGE = '';

    AutoAccountCreateService.createAccount(accInfo);
    test.stopTest();

    Account insertedAccount = [SELECT Id, Name FROM Account limit 1];
    system.assertEquals('Test Company',insertedAccount.Name);
    //Added by Lalit for S-407237 START
    AutoAccountCreateService.createAccount(accInfo);
    //Lead insertedLead = [SELECT Id, Company FROM Lead limit 1];
    //system.assertEquals('Test Company',insertedLead.Company);
    //Added by Lalit for S-407237 START
    
  }
  //Added below test method by Lalit for S-407235
   @isTest 
   static void testAutoLeadCreation()
  {
    test.startTest();
    Sales_Person__c salesPerson = new Sales_Person__c();
    salesPerson.Name = '12345';
    salesPerson.IsActive__c = true;
    salesPerson.Primary__c = true;
    salesPerson.User__c = Userinfo.getUserId();
    insert salesPerson;
    
    AutoAccountCreateService.AccountInformation accInfo = new AutoAccountCreateService.AccountInformation();
    accInfo.FIRSTNAME = 'Test First Name';
        accInfo.LASTNAME = 'Test Last Name';
        accInfo.EMAIL = 'test@testing.com';
        accInfo.PHONE = '3739283494';
        accInfo.PHONEEXT = '345';
        accInfo.ACCOUNTTYPE = 'Single'; 
        accInfo.COMPANYNAME = 'Test Company';
        accInfo.EINNUM = '473847';
        //accInfo.TOTALEMPLOYEES = '18387'; 
        accInfo.TOTALEMPLOYEES = '1-150';
        accInfo.ADDRESS1 = '201 South Capital Avenue';
        accInfo.ADDRESS2 = '';
        accInfo.CITY = 'Indianapolis';
        accInfo.STATE = 'Indiana';
        accInfo.ZIP = '46225';
        accInfo.WEBSITE = 'www.appirio.com';
        accInfo.TAXEXEMPT = 'false';
      //accInfo.ACCOUNTBILLING = 'Y';
        accInfo.ACCOUNTBILLING = 'true';
        accInfo.STATUSMESSAGE = '';

    AutoAccountCreateService.createAccount(accInfo);
    test.stopTest();

    Lead insertedLead = [SELECT Id, Company FROM Lead limit 1];
    system.assertEquals('Test Company',insertedLead.Company);
  }
}
/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piecef
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 
 Created by: Sunil Bansal
 Created Date: 12-Nov-2012
 Reason: To do test coverage of DuplicateLeadsExtension class
 
 */
@isTest
private class DuplicateLeadsExtension_TC {

    static testMethod void myUnitTest() 
    {
        Lead ld = new Lead();
        ld.FirstName = 'wonder';
        ld.LastName = 'land';
        ld.Company = 'Tehlaka';
        ld.City__c = 'Miami';
        ld.State__c = 'FL';
        ld.Zip__c = '33445';
        ld.Email = 'testLead@officedepot2.com';
        ld.Phone = '5484567890';
        ld.recordtypeid = System.Label.Lead_US;
        
        insert ld;
        
         Lead ld1 = new Lead();
        ld1.FirstName = 'wonder';
        ld1.LastName = 'land';
        ld1.Company = 'Tehlaka';
        ld1.City__c = 'Miami';
        ld1.State__c = 'FL';
        //ld1.Zip__c = '33445';
        ld1.Email = 'testLead@officedepot2.com';
       // ld1.Phone = '5484567890';
        ld1.recordtypeid = System.Label.Lead_US;
        
        insert ld1;
        
        Account acc = new Account ();
        acc.name = 'Tehlaka2';
        acc.BillingStreet = '1040 N 326 W';
        acc.billingcity = 'Orem';
        acc.BillingState = 'UT';
        acc.Billingcountry = 'USA';
        acc.Oracle_Party_Id__c = '123456';
        acc.AOPS_Cust_Id__c = '123456';
        acc.AOPS_Seq_ID__c = '123456';
        acc.State__c = 'FL';
        acc.Zip__c = '33445';
        
        insert acc;
        
        
        Contact ct = new Contact();
        ct.FirstName = 'wonder';
        ct.LastName = 'land';
        ct.AccountId = acc.Id;
        ct.Email = 'testLead@officedepot2.com';
        ct.Phone = '5484567890';
        
        insert ct;
        
        ApexPages.StandardController newSct = new ApexPages.Standardcontroller(ld);
        DuplicateLeadsExtension dle = new DuplicateLeadsExtension(newSct);
        dle.searchLeads();
        dle.getMatchingAccounts();
        dle.getMatchingContacts();
        
        ApexPages.StandardController newSct1 = new ApexPages.Standardcontroller(ld1);
        DuplicateLeadsExtension dle1 = new DuplicateLeadsExtension(newSct1);
        dle1.searchLeads();
        dle1.getMatchingAccounts();
        dle1.getMatchingContacts();
        
        ld.State__c = 'FL';
        ld.Zip__c = '33445';
        ld.Email = 'testLead@officedepot2.com';
        ld.Phone = '5484567890';
        update ld;
        
        acc.name = 'Tehlaka';
        update acc;
        
        dle.blZip = true;
        dle.blState = true;
        dle.blEmailDomain = true;
        
        dle.strZip = '33445';
        dle.strState = 'FL';
        
        dle.searchLeads();
        dle.getMatchingAccounts();
        dle.getMatchingContacts();
        
        dle.getMatchedLeads();
        
        for(DuplicateLeadsExtension.DuplicateLead dl: dle.lstDuplicateLeads)
        {
            dl.leadChecked = true;
        }
        
        dle.ValidateLead();
        dle.closeLeads();
        dle.linkLead();
        
      
    }
}
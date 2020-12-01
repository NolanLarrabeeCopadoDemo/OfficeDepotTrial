/**********************************************************

Class Name : LeadService_TC 
Created Date : May 21st, 2015
Created By : Mohit Batwada
Purpoae : Test Class for LeadService

***********************************************************/
@isTest
public with sharing class LeadService_TC {
    
    @isTest
    static void testGPOLeadRequiredField(){
        
        User user = Test_Utils.getTestUser('System Administrator','aaa@officedepot.com','227112');
        system.runAs(user){
        Account account = Test_Utils.getTestAccount(user,'123456');
        
        Profile sysAdminProfile = [Select id from Profile where Name = 'System Administrator'];
        LeadService.LeadInformation leadInfo = new LeadService.LeadInformation();
        leadInfo.FIRSTNAME = 'Test First Name';
        leadInfo.COMPANY = 'Test Comppany';
        leadInfo.EMAIL = 'test@test.com';
        leadInfo.PHONE = '(999) 999-3333';//Modified by Lalit for S-404759
        leadInfo.FIRSTNAME = 'sample';
        leadInfo.LASTNAME = 'Name';
        leadInfo.DESCRIPTION = 'Test Description';
        leadInfo.WCW = 123;
        leadInfo.ADDRESS1 = 'Test Address';
        leadInfo.ADDRESS2 = 'Sample Address';
        leadInfo.CITY = 'Test City';
        leadInfo.STATE = 'Test State';
        leadInfo.LOGINNAME = 'qwerty';
        leadInfo.ZIP = '123456';
        leadInfo.DUNS = '078476982' ;
        leadInfo.PROFILEID = sysAdminProfile.Id;
        leadInfo.LEADSOURCE = 'Advertisement';
        leadInfo.STATUS = true;
        leadInfo.ErrorMessage = '';
        leadInfo.CONTACTID = '';
        leadInfo.USERID = '';
        leadInfo.AOPSID = '88710865';
        
        //LeadService leadService = new LeadService();
        leadInfo  = LeadService.createUser(leadInfo, account.Id);
        LeadService.insertLead(leadInfo);
        //This assert is to make sure the testing of catch block in main class
        System.assert(leadInfo.ErrorMessage!=null);//Added by Lalit for S-404759
        }
    }
}
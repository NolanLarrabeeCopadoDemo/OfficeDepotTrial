/**@@
#TRIGGER NAME  : PrimaryContactTrigger_Test (Related classes:PrimaryContactTrigger( ContactBusinessProUtils,PrimaryContactTriggerHandler, PrimaryContactTriggerHelper)
#DESCRIPTION :  Created by Rajendra Shahane for ticket 02831117 - Contact trigger conversion to Lightning
#CREATEDDDATE :  05-06-2020 (DD-MM-YYYY) 
@@**/
@isTest(SeeAllData=false)
public class PrimaryContactTrigger_Test
{
    @TestSetup public static void setup()
    {
        list<string> lstAccrecordtypeId = new list<string>();
        
        Id GPRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GrandParent').getRecordTypeId();
        Id CustTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Id ProspectTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
        Id CustBusinessProTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer (Business Pro)').getRecordTypeId();
        Id SiteGTTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site (GT)').getRecordTypeId();
        lstAccrecordtypeId.add(GPRecordTypeId);	
        lstAccrecordtypeId.add(SiteGTTypeId);	
        lstAccrecordtypeId.add(CustBusinessProTypeId);	
        lstAccrecordtypeId.add(CustTypeId);	
        lstAccrecordtypeId.add(ProspectTypeId);
        List<Account> lstParent = DataFactory.createAccountTestRecords('Test Account', 1, '');
        List<Account> lstAcc = DataFactory.createSpecificAccountRecords('Test Acc', lstParent[0].id, lstAccrecordtypeId);
        list<Account> lstLoyatyAcc = [select id from Account where recordtypeid=:CustBusinessProTypeId limit 1];
        update new account(id=lstLoyatyAcc[0].id,loyatly_number__C = '111');
        list<Account> parent = [select id from Account where recordtypeid=:GPRecordTypeId limit 1];
        id GTContactTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('GT Contact').getRecordTypeId();
        
        list<Account> parent1 = [select id from Account where recordtypeid=:CustTypeId limit 1];
        list<contact> lstContact = New list<contact>();
        lstContact.add(new Contact(lastname='TestCon1',email='testcon1@test.com',Site_Account__c = parent[0].id,MailingStreet = 'Test Mailing Street',accountid=parent[0].id));
        lstContact.add(new Contact(lastname='TestCon2',email='testcon2@test.com',Primary_Contact__c = true,loyalty_number__c = '111',accountid=parent[0].id));
        contact con = new Contact(firstname='first name',lastname='TestCon11',email='testcon11@test.com',recordtypeid = GTContactTypeId,MailingStreet = 'Test Mailing Street',accountid=parent1[0].id);
        lstContact.add(con);
        insert lstContact;
        //User user = getTestUser('System Administrator','aaab@officedepot.com','227112',lstContact[0].id);
        GPO_Template__c gpoTemp = Test_Utils.createGPOTemplate('Sample Template',false);
        gpoTemp.Name = 'Default Template';
        gpoTemp.Home_Page__c =  '/gpo/GPOHome';
        gpoTemp.Member_Page__c = '/gpo/GPOMember';
        insert gpoTemp;
        GPO_Template__c gpoTemp2 = new GPO_Template__c();
        gpoTemp2.Template_Name__c = 'Test Template 2';
        gpoTemp2.Name = 'Communities v2';
        gpoTemp2.Home_Page__c =  '/gpo/GPOHome';
        gpoTemp2.Member_Page__c = '/gpo/GPOMember';
        insert gpoTemp2;
        
        GPO_Community_Setup__c gpoCommunitySetup = Test_Utils.createGPOCommunitySetUp(gpoTemp,false);
        gpoCommunitySetup.member_page__C = '/gpo/GPOMember';
        gpoCommunitySetup.home_page__c = '/gpo/GPOHome';
        gpoCommunitySetup.image_path__c = '/gpo/servlet/servlet.FileDownload?file=';
        gpoCommunitySetup.enabled_group_recordtypeid__c = '012M00000000jDDIAY';
        gpoCommunitySetup.captcha_publicKey__c = '6Lc38AQTAAAAAKynztg9AZWXYB1a5h-YDj7EXKQi';
        gpoCommunitySetup.signin_link__c = '/asdf/';
        insert gpoCommunitySetup;
        
        GPO_Group__c gpoGroup = Test_Utils.createGPOGroup(gpoTemp, parent[0], false);
        gpogroup.Community_Name__c = 'Default Group';
        gpoGroup.Welcome_Title__c = 'Test GPO Group Title';
        gpoGroup.RecordTypeId = Schema.SObjectType.GPO_Group__c.getRecordTypeInfosByName().get('Enabled GPO Community').getRecordTypeId(); //S-321807
        gpoGroup.activated__c = true;
        gpoGroup.private__c = false;
        gpoGroup.account__c = parent[0].id;
        gpoGroup.PO_Number_Setup__c = 'S (--Select Any---)';
        gpoGroup.Cost_Center_Setup__c =  'S (--Select Any---)';
        gpoGroup.Release_Setup__c ='S (--Select Any---)';
        gpoGroup.Desktop_Setup__c = 'S (--Select Any---)';
        gpoGroup.inheritParentLogo__c = true;
        gpoGroup.inheritParentPageComponents__c = true;
        gpoGroup.inheritParentGreetingMessage__c = true;
        insert gpoGroup;
        
        GPO_Group__c gpoGroup1 = Test_Utils.createGPOGroup(gpoTemp, parent1[0], false);
        gpogroup1.Community_Name__c = 'Test Group';
        gpoGroup1.Welcome_Title__c = 'Title11';
        //gpoGroup1.RecordTypeId = Schema.SObjectType.GPO_Group__c.getRecordTypeInfosByName().get('Enabled GPO Community').getRecordTypeId(); //S-321807
        gpoGroup1.activated__c = true;
        //gpoGroup1.private__c = false;
        //gpoGroup1.account__c = parent[0].id;
        insert gpoGroup1;
        
        system.debug('@@gpoGroup ' + gpoGroup.Account__c + ' ' + gpoGroup.Activated__c);
        list<GPO_Group_Detail__c> lstGGD = new list<GPO_Group_Detail__c>();
        GPO_Group_Detail__c defaultMessage = new GPO_Group_Detail__c();
        defaultMessage.GPO_Group__c = gpoGroup.id;
        defaultMessage.Name = 'Generic Group Message';
        defaultMessage.Greeting_Message__c = 'x';
        defaultMessage.Type__c = 'Generic Group Message';
        lstGGD.add(defaultMessage);
        
        GPO_Group_Detail__c defaultmessage1 = new GPO_Group_Detail__c();
        defaultMessage1.GPO_Group__c = gpoGroup.id;
        defaultMessage1.Name = 'Standard Message 1';
        defaultMessage1.Greeting_Message__c = 'x';
        defaultMessage1.Type__c = 'Greeting Message';
        lstGGD.add(defaultMessage1);
        insert lstGGD;
        
        insert new Note(Title='new note',body='test note', ParentId=lstContact[0].id);
        
        /*
If current recordtype of account is 'Site (GT)' and Realted Account is modified then
2a) If Related Account is not same as the Primary Contact Account then Primary Contact for current Account is set to blank(null)
2b) If Related Account is not same as the Site Contact2 Account then Site Contact2 for current Account is set to blank(null)
2c) If Related Account is not same as the Site Contact3 Account then Site Contact3 for current Account is set to blank(null)
2d) If Related Account is not same as the Site Contact4 Account then Site Contact4 for current Account is set to blank(null)
2e) If Related Account is not same as the Site Contact5 Account then Site Contact5 for current Account is set to blank(null)
2f) If Related Account is not same as the Site Contact6 Account then Site Contact6 for current Account is set to blank(null)
*/
        list<Account> lstAcc1 = [select id,Related_Account__c,Site_Contact2__c from Account where recordtypeid =:SiteGTTypeId limit 1];
        lstAcc1[0].Related_Account__c = parent1[0].id;
        //lstAcc1[0].Site_Contact2__c = con.id;
        update lstAcc1;
        
        lstAcc1[0].Site_Contact2__c = con.id;
        lstAcc1[0].Site_Contact3__c = con.id;
        lstAcc1[0].Site_Contact4__c = con.id;
        lstAcc1[0].Site_Contact5__c = con.id;
        lstAcc1[0].Site_Contact6__c = con.id;
        update lstAcc1;
    }
    
    @isTest (SeeAllData=false)
    public static void testContactUpdate()
    {
        id GTContactTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('GT Contact').getRecordTypeId();
        list<Contact> newcon = [select id,accountid from contact where recordtypeid =:GTContactTypeId limit 1];
        Id CustTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        list<Account> parent = [select id from Account where recordtypeid=:CustTypeId limit 1];
        Id ProspectTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
        list<Account> parent1 = [select id from Account where recordtypeid=:ProspectTypeId limit 1];
        
        test.startTest();
        
        newcon[0].AccountId = parent1[0].id;
        update newcon;
        system.assertEquals(1, newcon.size());
        
        test.stopTest();
    }
    
    @isTest (SeeAllData=false)
    public static void testContactDelete()
    {
        test.startTest();
        list<contact> lstContact = [select id from contact limit 2];
        delete lstContact;
        undelete lstContact;
        system.assertEquals(2, lstContact.size());
        test.stopTest();
    }
    
    @isTest (SeeAllData=false)
    public static void testContactDelete11()
    {
        test.startTest();
        list<contact> lstContact = [select id,accountid from contact where accountid != null and lastname='TestCon1' limit 1];
        list<GPO_Group__c> lstGPO = [select id, account__c from GPO_Group__c limit 1];
        lstGPO[0].account__c = lstContact[0].accountid;
        update lstGPO;
        //User user = getTestUser('System Administrator','aaab@officedepot.com','227112',lstContact[0].id);
        
        lstContact[0].Web_Username__c = 'test.od@od.com';
        update lstContact;
        PrimaryContactTriggerHelper.isNull('');
        PrimaryContactTriggerHelper.isNull('test');
        PrimaryContactTriggerHelper.convertNull('#N/A');
        PrimaryContactTriggerHelper.convertNull('Test');
        test.stopTest();
    }
}
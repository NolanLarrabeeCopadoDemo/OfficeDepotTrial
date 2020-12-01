/**********************************************************

 *********************************************************

   Class Name : com2GPOCommunityLandingController_TC
   Created Date : March 21st, 2018
   Created By : Madhavi Sirigiri
   Purpose : Test Class for GPOCommunityLandingController

 ***********************************************************

   Class Name : com2GPOCommunityLandingController_TC
   Created Date : May 21st, 2015
   Created By : Mohit Batwada
   Purpose : Test Class for GPOCommunityLandingController

 ***********************************************************/
@isTest
public with sharing class com2GPOCommunityLandingController_TC {

    @TestSetup
    static void makeData(){
        TechDepotSetting__c my_data = new TechDepotSetting__c(
            Crypto_Key__c='Sz3oFf2pAWtdogFgIfN5nmQ1Jsz3L3muo/68QJYPKjw=',
            Name='Key'
            );
        insert my_data;
    }

    @isTest
    static void testmethod_1(){
        User user = getTestUser('System Administrator','aaab@officedepot.com','227112');
        //Account parentAcc = Test_Utils.getTestAccount(user,'123456');
        System.runAs(user){

            Account account = Test_Utils.getTestAccount(user,'123456');
            Contact contact =  CreateContact(account.Id);


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

            GPO_Group__c gpoGroup = Test_Utils.createGPOGroup(gpoTemp, account, false);
            gpogroup.Community_Name__c = 'Default Group';
            gpoGroup.Welcome_Title__c = 'Test GPO Group Title';
            gpoGroup.RecordTypeId = Schema.SObjectType.GPO_Group__c.getRecordTypeInfosByName().get('Enabled GPO Community').getRecordTypeId(); //S-321807
            gpoGroup.activated__c = true;
            gpoGroup.private__c = false;

            gpoGroup.PO_Number_Setup__c = 'S (--Select Any---)';
            gpoGroup.Cost_Center_Setup__c =  'S (--Select Any---)';
            gpoGroup.Release_Setup__c ='S (--Select Any---)';
            gpoGroup.Desktop_Setup__c = 'S (--Select Any---)';
            gpoGroup.inheritParentLogo__c = true;
            gpoGroup.inheritParentPageComponents__c = true;
            gpoGroup.inheritParentGreetingMessage__c = true;
            insert gpoGroup;

            GPO_Group_Detail__c defaultMessage = new GPO_Group_Detail__c();
            defaultMessage.GPO_Group__c = gpoGroup.id;
            defaultMessage.Name = 'Generic Group Message';
            defaultMessage.Greeting_Message__c = 'x';
            defaultMessage.Type__c = 'Generic Group Message';
            insert defaultMessage;

            GPO_Group_Detail__c defaultmessage1 = new GPO_Group_Detail__c();
            defaultMessage1.GPO_Group__c = gpoGroup.id;
            defaultMessage1.Name = 'Standard Message 1';
            defaultMessage1.Greeting_Message__c = 'x';
            defaultMessage1.Type__c = 'Greeting Message';
            insert defaultMessage1;

            Attachment att = new Attachment();
            att.Name = 'Test';
            att.body = Blob.valueOf('test');
            att.ParentId = gpoGroup.Id;
            insert att;
            gpoGroup.Community_Image__c = att.Id;
            update gpoGroup;

            // Communites v2 Stuff
            GPO_Community_Setup__c com2settings = new GPO_Community_Setup__c();
            com2settings.Name = 'com2Settings';
            com2settings.captcha_privateKey__c = '6Lc38AQTAAAAAJCT62Y_HF9sv3Cadyyvj3UznDbk';
            com2settings.member_page__C = '/gpo/GPOMember';
            com2settings.signin_link__c = '/asdf/';
            insert com2Settings;

            test.starttest();
            com2GPOCommunityLandingController gpoCommunityLanding1_default = new com2GPOCommunityLandingController();
            ApexPages.currentPage().getParameters().put('id','123456');
            ApexPages.currentPage().getParameters().put('recaptcha_challenge_field','test');
            ApexPages.currentPage().getParameters().put('recaptcha_response_field','test');

            ///------------
            GPO_Link__c gl1 = new GPO_Link__c();
            gl1.GPO_Group__c = gpogroup.id;
            gl1.Type__c = 'Invoice Request Form Field';
            gl1.Label__c = 'x';
            gl1.Invoice_Form_Fields__c = 'Billing State';
            insert gl1;

            GPO_Link__c gl2 = new GPO_Link__c();
            gl2.GPO_Group__c = gpogroup.id;
            gl2.Type__c = 'User Registration Field';
            gl2.Label__c = 'xy';
            gl2.User_Registration_Fields__c = 'First Name';
            insert gl2;

            GPO_Link__c gl3 = new GPO_Link__c();
            gl3.GPO_Group__c = gpogroup.id;
            gl3.Type__c = 'Invoice_UserReg_Form_Field';
            gl3.Label__c = 'POTEST';
            gl3.Invoice_UserReg_Fields__c  = 'PO Number';
            insert gl3;

            GPO_Link__c gl4 = new GPO_Link__c();
            gl4.GPO_Group__c = gpogroup.id;
            gl4.Type__c = 'Invoice_UserReg_Form_Field';
            gl4.Label__c = 'CCTEST';
            gl4.Invoice_UserReg_Fields__c  = 'Cost Center';
            insert gl4;

            GPO_Link__c gl5 = new GPO_Link__c();
            gl5.GPO_Group__c = gpogroup.id;
            gl5.Type__c = 'Invoice_UserReg_Form_Field';
            gl5.Label__c = 'RRTEST';
            gl5.Invoice_UserReg_Fields__c  = 'Release';
            insert gl5;

            GPO_Link__c gl6 = new GPO_Link__c();
            gl6.GPO_Group__c = gpogroup.id;
            gl6.Type__c = 'Invoice_UserReg_Form_Field';
            gl6.Label__c = 'DDTEST';
            gl6.Invoice_UserReg_Fields__c  = 'Desktop';
            insert gl6;

            GPO_Link__c gl7 = new GPO_Link__c();
            gl7.GPO_Group__c = gpogroup.id;
            gl7.Type__c = 'User Registration Field';
            gl7.Label__c = 'CCode1';
            gl7.User_Registration_Fields__c = 'Custom Catalog Code';
            insert gl7;

            GPO_Link__c gl8 = new GPO_Link__c();
            gl8.GPO_Group__c = gpogroup.id;
            gl8.Type__c = 'User Registration Field';
            gl8.Label__c = 'MPN';
            gl8.User_Registration_Fields__c = 'Multiple PO Numbers';
            insert gl8;

            GPO_Link__c gl9 = new GPO_Link__c();
            gl9.GPO_Group__c = gpogroup.id;
            gl9.Type__c = 'User Registration Field';
            gl9.Label__c = 'MCC';
            gl9.User_Registration_Fields__c = 'Multiple Cost Centers';
            insert gl9;

            GPO_Link__c gl10 = new GPO_Link__c();
            gl10.GPO_Group__c = gpogroup.id;
            gl10.Type__c = 'User Registration Field';
            gl10.Label__c = 'MRS';
            gl10.User_Registration_Fields__c = 'Multiple Releases';
            insert gl10;

            GPO_Link__c gl11 = new GPO_Link__c();
            gl11.GPO_Group__c = gpogroup.id;
            gl11.Type__c = 'User Registration Field';
            gl11.Label__c = 'MDS';
            gl11.User_Registration_Fields__c = 'Multiple Desktops';
            insert gl11;

            GPO_Link__c gl12 = new GPO_Link__c();
            gl12.GPO_Group__c = gpogroup.id;
            gl12.Type__c = 'User Registration Field';
            gl12.Label__c = 'SSO Id';
            gl12.User_Registration_Fields__c = 'SSO Id';
            insert gl12;

            GPO_Soft_Headers__c SHObj1 = new GPO_Soft_Headers__c();
            SHObj1.GPO_Group__c = gpogroup.id;
            SHObj1.SoftHeader_Type__c = 'PO Number';
            SHObj1.SoftHeader_Value__c = 'PO1';
            insert SHObj1;

            GPO_Soft_Headers__c SHObj2 = new GPO_Soft_Headers__c();
            SHObj2.GPO_Group__c = gpogroup.id;
            SHObj2.SoftHeader_Type__c = 'Cost Center';
            SHObj2.SoftHeader_Value__c = 'CC1';
            insert SHObj2;

            GPO_Soft_Headers__c SHObj3 = new GPO_Soft_Headers__c();
            SHObj3.GPO_Group__c = gpogroup.id;
            SHObj3.SoftHeader_Type__c = 'Release';
            SHObj3.SoftHeader_Value__c = 'RR1';
            insert SHObj3;

            GPO_Soft_Headers__c SHObj4 = new GPO_Soft_Headers__c();
            SHObj4.GPO_Group__c = gpogroup.id;
            SHObj4.SoftHeader_Type__c = 'Desktop';
            SHObj4.SoftHeader_Value__c = 'DD1';
            insert SHObj4;


            com2GPOCommunityLandingController gpoCommunityLanding = new com2GPOCommunityLandingController();
            gpoCommunityLanding.loadtypeahead();

            //gpoCommunityLanding.initDefaultGPO();
            String pubKey = gpoCommunityLanding.publicKey;
            gpoCommunityLanding.errorText = null;
            gpoCommunityLanding.parentAccid = null;
            gpoCommunityLanding.myname = null;
            gpoCommunityLanding.myEmail = null;
            String clg = gpoCommunityLanding.challenge;
            String res = gpoCommunityLanding.response;
            PageReference chkusr = gpoCommunityLanding.checkUser();
            PageReference templateHome = gpoCommunityLanding.getTemplateHomePage();
            PageReference templateMember = gpoCommunityLanding.getTemplateMemberPage();
            String memberPage = gpoCommunityLanding.getMemberPage();
            String homePage = gpoCommunityLanding.getHomePage();
            String imageRoot = gpoCommunityLanding.getImageRootPath();
            Boolean idImage = gpoCommunityLanding.getIsImageDefined();
            Integer int1 = gpoCommunityLanding.getCurrentYear();
            String str1 = gpoCommunityLanding.getWelcomeMessage1();

            gpoCommunityLanding.newLead();

            GPO_Lead__c lead = Test_Utils.createGPOLead(account,false);
            lead.WCW_Range__c = '1-19';
            lead.recaptcha__c = 'testxyz';
            lead.Login_Name__c = 'TestClass_Test';

            //-------
            lead.User_Register_For_SPC__c = true;
            lead.Request_Printed_SPC__c = true;
            lead.PO_Number_User_Setting__c = gpoGroup.PO_Number_Setup__c;
            lead.Cost_Center_User_Setting__c = gpoGroup.PO_Number_Setup__c;
            lead.Release_User_Setting__c = gpoGroup.PO_Number_Setup__c;
            lead.Desktop_User_Setting__c = gpoGroup.PO_Number_Setup__c;
            lead.PO_Number__c = gl3.Label__c;
            lead.Cost_Center__c = gl4.Label__c;
            lead.Release__c = gl5.Label__c;
            lead.Desktop__c = gl6.Label__c;
            lead.SSO_Id__c = 'SSO123';
            lead.CustomCatalogCode__c = '123';
            lead.MultipleShipTo__c = true;
            lead.private__c = true;
            //-------

            // Case Creation Test
            Account acct1 = new Account();
            acct1.AOPS_Cust_ID__c = '00010001';
            acct1.Name = 'testName';
            insert acct1;

            GPO_Group__c group1 = new GPO_Group__c();
            group1.Account__C = acct1.id;
            group1.Welcome_Title__c = 'testTitle';
            insert group1;

            Case testCase1 = new Case();
            String groupid = '00010001';
            com2GPOCommunityLandingController.createCase(testCase1, group1.id);
            testCase1.subject = 'asdf';
            com2GPOCommunityLandingController.createCase(testCase1, group1.id);

            ApexPages.currentPage().getParameters().put('id','0'+group1.id);


            string pagelink_ccnum = 'CC123';
            com2GPOCommunityLandingController.insertLeads(lead,'123456','','qwer123',pagelink_ccnum);

            GPO_Group_Detail__c ggd1 = new GPO_Group_Detail__c();
            ggd1.Greeting_Message__c = 'x';
            ggd1.GPO_Group__c = gpogroup.id;
            ggd1.Name = 'Standard Message 1';
            insert ggd1;

            GPO_Group_Detail__c ggd3 = new GPO_Group_Detail__c();
            ggd3.GPO_Group__c = gpogroup.id;
            insert ggd3;
            group1.selected_message__c = ggd3.id;
            update group1;
            com2GPOCommunityLandingController x = new com2GPOCommunityLandingController();
            x.getWelcomeMessage1();
            x.hideWebsite = true;
            x.hideExtension = true;
            x.hideNotes = true;
            //Added by Lalit for S-404759 START
            Pagereference p = gpoCommunityLanding.reset();
            System.assert (p==null);
            test.stopTest();
            // boolean b = gpoCommunityLanding.getGPOTempateUsed();
            //  System.assert(b);
            //Added by Lalit for S-404759 END
            //      }
        }

    }

    @isTest
    static void testmethod_2(){
        User user = getTestUser('System Administrator','aaab@officedepot.com','227112');
        //Account parentAcc = Test_Utils.getTestAccount(user,'123456');
        System.runAs(user){

            Account account = Test_Utils.getTestAccount(user,'123456');
            Contact contact =  CreateContact(account.Id);

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


            GPO_Group__c gpoGroup = Test_Utils.createGPOGroup(gpoTemp, account, false);
            gpogroup.Community_Name__c = 'Default Group';
            gpoGroup.Welcome_Title__c = 'Test GPO Group Title';
            gpoGroup.RecordTypeId = Schema.SObjectType.GPO_Group__c.getRecordTypeInfosByName().get('Enabled GPO Community').getRecordTypeId(); //S-321807
            gpoGroup.activated__c = true;
            gpoGroup.private__c = false;

            gpoGroup.PO_Number_Setup__c = 'S (--Select Any---)';
            gpoGroup.Cost_Center_Setup__c =  'S (--Select Any---)';
            gpoGroup.Release_Setup__c ='S (--Select Any---)';
            gpoGroup.Desktop_Setup__c = 'S (--Select Any---)';
            gpoGroup.inheritParentLogo__c = true;
            gpoGroup.inheritParentPageComponents__c = true;
            gpoGroup.inheritParentGreetingMessage__c = true;
            insert gpoGroup;

            GPO_Group_Detail__c defaultMessage = new GPO_Group_Detail__c();
            defaultMessage.GPO_Group__c = gpoGroup.id;
            defaultMessage.Name = 'Generic Group Message';
            defaultMessage.Greeting_Message__c = 'x';
            defaultMessage.Type__c = 'Generic Group Message';
            insert defaultMessage;

            GPO_Group_Detail__c defaultmessage1 = new GPO_Group_Detail__c();
            defaultMessage1.GPO_Group__c = gpoGroup.id;
            defaultMessage1.Name = 'Standard Message 1';
            defaultMessage1.Greeting_Message__c = 'x';
            defaultMessage1.Type__c = 'Greeting Message';
            insert defaultMessage1;

            Attachment att = new Attachment();
            att.Name = 'Test';
            att.body = Blob.valueOf('test');
            att.ParentId = gpoGroup.Id;
            insert att;
            gpoGroup.Community_Image__c = att.Id;
            update gpoGroup;

            // Communites v2 Stuff
            GPO_Community_Setup__c com2settings = new GPO_Community_Setup__c();
            com2settings.Name = 'com2Settings';
            com2settings.captcha_privateKey__c = '6Lc38AQTAAAAAJCT62Y_HF9sv3Cadyyvj3UznDbk';
            com2settings.member_page__C = '/gpo/GPOMember';
            com2settings.signin_link__c = '/asdf/';
            insert com2Settings;

            test.starttest();
            com2GPOCommunityLandingController gpoCommunityLanding1_default = new com2GPOCommunityLandingController();
            ApexPages.currentPage().getParameters().put('id','123456');
            ApexPages.currentPage().getParameters().put('recaptcha_challenge_field','test');
            ApexPages.currentPage().getParameters().put('recaptcha_response_field','test');

            ///---------
            GPO_Link__c gl1 = new GPO_Link__c();
            gl1.GPO_Group__c = gpogroup.id;
            gl1.Type__c = 'Invoice Request Form Field';
            gl1.Label__c = 'x';
            gl1.Invoice_Form_Fields__c = 'Billing State';

            insert gl1;

            GPO_Link__c gl2 = new GPO_Link__c();
            gl2.GPO_Group__c = gpogroup.id;
            gl2.Type__c = 'User Registration Field';
            gl2.Label__c = 'xy';
            gl2.User_Registration_Fields__c = 'First Name';
            insert gl2;

            GPO_Link__c gl3 = new GPO_Link__c();
            gl3.GPO_Group__c = gpogroup.id;
            gl3.Type__c = 'Invoice_UserReg_Form_Field';
            gl3.Label__c = 'POTEST';
            gl3.Invoice_UserReg_Fields__c  = 'PO Number';
            gl3.Hide__c = true;
            insert gl3;

            GPO_Link__c gl4 = new GPO_Link__c();
            gl4.GPO_Group__c = gpogroup.id;
            gl4.Type__c = 'Invoice_UserReg_Form_Field';
            gl4.Label__c = 'CCTEST';
            gl4.Invoice_UserReg_Fields__c  = 'Cost Center';
            gl4.Hide__c = true;
            insert gl4;

            GPO_Link__c gl5 = new GPO_Link__c();
            gl5.GPO_Group__c = gpogroup.id;
            gl5.Type__c = 'Invoice_UserReg_Form_Field';
            gl5.Label__c = 'RRTEST';
            gl5.Invoice_UserReg_Fields__c  = 'Release';
            gl5.Hide__c = true;
            insert gl5;

            GPO_Link__c gl6 = new GPO_Link__c();
            gl6.GPO_Group__c = gpogroup.id;
            gl6.Type__c = 'Invoice_UserReg_Form_Field';
            gl6.Label__c = 'DDTEST';
            gl6.Invoice_UserReg_Fields__c  = 'Desktop';
            gl6.Hide__c = true;
            insert gl6;

            GPO_Link__c gl7 = new GPO_Link__c();
            gl7.GPO_Group__c = gpogroup.id;
            gl7.Type__c = 'User Registration Field';
            gl7.Label__c = 'CCode1';
            gl7.User_Registration_Fields__c = 'Custom Catalog Code';
            gl7.Hide__c = true;
            insert gl7;

            GPO_Link__c gl8 = new GPO_Link__c();
            gl8.GPO_Group__c = gpogroup.id;
            gl8.Type__c = 'User Registration Field';
            gl8.Label__c = 'MPN';
            gl8.User_Registration_Fields__c = 'Multiple PO Numbers';
            gl8.Hide__c = true;
            insert gl8;

            GPO_Link__c gl9 = new GPO_Link__c();
            gl9.GPO_Group__c = gpogroup.id;
            gl9.Type__c = 'User Registration Field';
            gl9.Label__c = 'MCC';
            gl9.User_Registration_Fields__c = 'Multiple Cost Centers';
            gl9.Hide__c = true;
            insert gl9;

            GPO_Link__c gl10 = new GPO_Link__c();
            gl10.GPO_Group__c = gpogroup.id;
            gl10.Type__c = 'User Registration Field';
            gl10.Label__c = 'MRS';
            gl10.User_Registration_Fields__c = 'Multiple Releases';
            gl10.Hide__c = true;
            insert gl10;

            GPO_Link__c gl11 = new GPO_Link__c();
            gl11.GPO_Group__c = gpogroup.id;
            gl11.Type__c = 'User Registration Field';
            gl11.Label__c = 'MDS';
            gl11.User_Registration_Fields__c = 'Multiple Desktops';
            gl11.Hide__c = true;
            insert gl11;

            GPO_Link__c gl12 = new GPO_Link__c();
            gl12.GPO_Group__c = gpogroup.id;
            gl12.Type__c = 'User Registration Field';
            gl12.Label__c = 'SSO Id';
            gl12.User_Registration_Fields__c = 'SSO Id';
            gl12.Hide__c = true;
            insert gl12;

            GPO_Soft_Headers__c SHObj1 = new GPO_Soft_Headers__c();
            SHObj1.GPO_Group__c = gpogroup.id;
            SHObj1.SoftHeader_Type__c = 'PO Number';
            SHObj1.SoftHeader_Value__c = 'PO1';
            insert SHObj1;

            GPO_Soft_Headers__c SHObj2 = new GPO_Soft_Headers__c();
            SHObj2.GPO_Group__c = gpogroup.id;
            SHObj2.SoftHeader_Type__c = 'Cost Center';
            SHObj2.SoftHeader_Value__c = 'CC1';
            insert SHObj2;

            GPO_Soft_Headers__c SHObj3 = new GPO_Soft_Headers__c();
            SHObj3.GPO_Group__c = gpogroup.id;
            SHObj3.SoftHeader_Type__c = 'Release';
            SHObj3.SoftHeader_Value__c = 'RR1';
            insert SHObj3;

            GPO_Soft_Headers__c SHObj4 = new GPO_Soft_Headers__c();
            SHObj4.GPO_Group__c = gpogroup.id;
            SHObj4.SoftHeader_Type__c = 'Desktop';
            SHObj4.SoftHeader_Value__c = 'DD1';
            insert SHObj4;
            //-------------------------

            com2GPOCommunityLandingController gpoCommunityLanding = new com2GPOCommunityLandingController();
            gpoCommunityLanding.loadtypeahead();

            //gpoCommunityLanding.initDefaultGPO();
            String pubKey = gpoCommunityLanding.publicKey;
            gpoCommunityLanding.errorText = null;
            gpoCommunityLanding.parentAccid = null;
            gpoCommunityLanding.myname = null;
            gpoCommunityLanding.myEmail = null;
            String clg = gpoCommunityLanding.challenge;
            String res = gpoCommunityLanding.response;
            PageReference chkusr = gpoCommunityLanding.checkUser();
            PageReference templateHome = gpoCommunityLanding.getTemplateHomePage();
            PageReference templateMember = gpoCommunityLanding.getTemplateMemberPage();
            String memberPage = gpoCommunityLanding.getMemberPage();
            String homePage = gpoCommunityLanding.getHomePage();
            String imageRoot = gpoCommunityLanding.getImageRootPath();
            Boolean idImage = gpoCommunityLanding.getIsImageDefined();
            Integer int1 = gpoCommunityLanding.getCurrentYear();
            String str1 = gpoCommunityLanding.getWelcomeMessage1();

            gpoCommunityLanding.newLead();

            GPO_Lead__c lead = Test_Utils.createGPOLead(account,false);
            lead.WCW_Range__c = '1-19';
            lead.recaptcha__c = 'testxyz';
            lead.Login_Name__c = 'TestClass_Test';

            //-------
            lead.User_Register_For_SPC__c = true;
            lead.Request_Printed_SPC__c = true;
            lead.PO_Number_User_Setting__c = gpoGroup.PO_Number_Setup__c;
            lead.Cost_Center_User_Setting__c = gpoGroup.PO_Number_Setup__c;
            lead.Release_User_Setting__c = gpoGroup.PO_Number_Setup__c;
            lead.Desktop_User_Setting__c = gpoGroup.PO_Number_Setup__c;
            lead.PO_Number__c = gl3.Label__c;
            lead.Cost_Center__c = gl4.Label__c;
            lead.Release__c = gl5.Label__c;
            lead.Desktop__c = gl6.Label__c;
            lead.SSO_Id__c = 'SSO123';
            lead.CustomCatalogCode__c = '123';
            lead.MultipleShipTo__c = true;
            //-------

            // Case Creation Test
            Account acct1 = new Account();
            acct1.AOPS_Cust_ID__c = '00010001';
            acct1.Name = 'testName';
            insert acct1;

            GPO_Group__c group1 = new GPO_Group__c();
            group1.Account__C = acct1.id;
            group1.Welcome_Title__c = 'testTitle';
            insert group1;

            Case testCase1 = new Case();
            String groupid = '00010001';
            com2GPOCommunityLandingController.createCase(testCase1, group1.id);
            testCase1.subject = 'asdf';
            com2GPOCommunityLandingController.createCase(testCase1, group1.id);

            ApexPages.currentPage().getParameters().put('id','0'+group1.id);


            string pagelink_ccnum = 'CC123';
            com2GPOCommunityLandingController.insertLeads(lead,'123456','','qwer123',pagelink_ccnum);

            GPO_Group_Detail__c ggd1 = new GPO_Group_Detail__c();
            ggd1.Greeting_Message__c = 'x';
            ggd1.GPO_Group__c = gpogroup.id;
            ggd1.Name = 'Standard Message 1';
            insert ggd1;

            GPO_Group_Detail__c ggd3 = new GPO_Group_Detail__c();
            ggd3.GPO_Group__c = gpogroup.id;
            insert ggd3;
            group1.selected_message__c = ggd3.id;
            update group1;
            com2GPOCommunityLandingController x = new com2GPOCommunityLandingController();
            x.getWelcomeMessage1();
            x.hideWebsite = true;
            x.hideExtension = true;
            x.hideNotes = true;
            //Added by Lalit for S-404759 START
            Pagereference p = gpoCommunityLanding.reset();
            System.assert (p==null);
            test.stopTest();
            // boolean b = gpoCommunityLanding.getGPOTempateUsed();
            //  System.assert(b);
            //Added by Lalit for S-404759 END
            //      }
        }

    }

    static User getCommunityUser(String userName,String empId,Id conId){
        Profile profileObj = [select id from profile where name= 'Customer Community Login User - GPO Admin'];
        String profId = profileObj.id;

        string email = userName;
        string[] name = userName.split('@');
        user u = new user(Username=userName,FirstName =name[1], LastName=name[0], Alias=name[0], CommunityNickname=userName, LocaleSidKey='en_US',
                          EmailEncodingKey='UTF-8', Profileid = profId, LanguageLocaleKey='en_US');
        u.email=email;
        u.MB_Expiration_Date__c = System.now().addminutes(1);
        u.OD_Employee_ID__c =empId;
        u.GT_Employee_ID__c =empId;
        u.ContactId = conId;
        u.IsActive=true;
        u.TimeZoneSidKey='America/Los_Angeles';
        u.Token_Market_Builder__c ='xyz';
        // u.IsPortalEnabled = true;
        try{
            Insert u;
            system.debug('@@@User@@@ : '+u);
            return u;
        }
        catch(Exception e) {
            system.debug('Exception'+e);
        }
        return u;
    }
    public static Contact CreateContact(Id accountId) {
        Contact contact = new Contact(LastName = 'TEST',AccountId = accountId);
        contact.MailingCountry = 'MEX';
        contact.Admin_Context__c =  accountId;
        contact.GPO_Community__c =accountId;
        insert contact;

        return contact;
    }
    public static User getTestUser(String profileName,String userName,String empId){
        Profile profileObj = [select id from profile where name=: profileName];
        String profId = profileObj.id;
        UserRole ContractDivisionRoleId = [SELECT Id from UserRole WHERE Name = 'Contract Division' limit 1];
        string email = userName;
        string[] name = userName.split('@');
        user u = new user(Username=userName,FirstName =name[1], LastName=name[0], Alias=name[0], CommunityNickname=userName, LocaleSidKey='en_US',
                          EmailEncodingKey='UTF-8', Profileid = profId, LanguageLocaleKey='en_US');
        u.email=email;
        u.MB_Expiration_Date__c = System.now().addminutes(1);
        u.OD_Employee_ID__c =empId;
        u.GT_Employee_ID__c =empId;
        u.IsActive=true;
        u.TimeZoneSidKey='America/Los_Angeles';
        u.Token_Market_Builder__c ='xyz';
        u.UserRoleId = ContractDivisionRoleId.Id;
        try{
            Insert u;
            system.debug('@@@User@@@ : '+u);
            return u;
        }
        catch(Exception e) {
            system.debug('Exception'+e);
        }
        return u;
    }

}
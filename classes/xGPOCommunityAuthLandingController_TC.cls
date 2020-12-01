/**
created by Najma Ateeq
 */
@isTest
private class xGPOCommunityAuthLandingController_TC {
    static testMethod void myUnitTest() {
        User user = getTestUser('System Administrator','aaab@officedepot.com','227112');
        
        System.runAs(user){
            Account account = Test_Utils.getTestAccount(user,'123456');
            Account account1 = Test_Utils.getTestAccount(user,'123457');
            Account childAcc = Test_Utils.getTestAccount(user,'1234561');
            childAcc.ParentId = account.Id;
            update  childAcc;
        //    Account prntAcc = Test_Utils.getTestAccount(user,'333333');
            User UserAccountOwner = Test_Utils.createTestUser('uao','233333');
            account.Sales_PersonID__c = UserAccountOwner.id;
            update account;
            Contact contact =  CreateContact(account1.Id);
            GPO_Template__c gpoTemp = Test_Utils.createGPOTemplate('Sample Template',false);
            gpoTemp.Home_Page__c =  '/gpo/GPOHome';
            gpoTemp.Member_Page__c = '/gpo/GPOMember';
            insert gpoTemp;
            
            GPO_Community_Setup__c gpoCommunitySetup = Test_Utils.createGPOCommunitySetUp(gpoTemp,false);
            gpoCommunitySetup.member_page__C = '/gpo/GPOMember';
            gpoCommunitySetup.home_page__c = '/gpo/GPOHome';
            gpoCommunitySetup.image_path__c = '/gpo/servlet/servlet.FileDownload?file=';
            gpoCommunitySetup.enabled_group_recordtypeid__c = Schema.SObjectType.GPO_Group__c.getRecordTypeInfosByName().get('Enabled GPO Community').getRecordTypeId(); //S-321807
            insert gpoCommunitySetup;
            //Communities v2
            GPO_Community_Setup__c gpoCommunitySetUp2 = new GPO_Community_Setup__c();
            gpoCommunitySetUp2.Name = 'com2Settings';
            gpoCommunitySetUp2.defaultTemplate__c = gpoTemp.Id;
            gpoCommunitySetUp2.Admin_ProfileId__c = '00eE0000000IQxT';
            gpoCommunitySetUp2.defaultRecordType__c = '012E000000093wNIAQ';
            gpoCommunitySetup2.member_page__C = '/gpo/GPOMember';
            gpoCommunitySetup2.home_page__c = '/gpo/GPOHome';
            gpoCommunitySetup2.image_path__c = '/gpo/servlet/servlet.FileDownload?file=';
            gpoCommunitySetUp2.enabled_group_recordtypeid__c = '012E000000093wMIAQ';
            insert gpoCommunitySetup2;
            
            GPO_Group__c gpoGroup = Test_Utils.createGPOGroup(gpoTemp, account1, false);
            gpoGroup.Welcome_Title__c = 'Test GPO Group Title';
            gpoGroup.RecordTypeId = Schema.SObjectType.GPO_Group__c.getRecordTypeInfosByName().get('Template Default').getRecordTypeId(); //S-321807
            gpoGroup.activated__c = true;
            gpogroup.Community_Name__c = 'Default Group';
            insert gpoGroup;
            Attachment att = new Attachment();
            att.Name = 'Test';
            att.body = Blob.valueOf('test');
            att.ParentId = gpoGroup.Id;
            insert att;
            gpoGroup.Community_Image__c = att.Id;
            GPO_Group_Detail__c ggd1 = new GPO_Group_Detail__c();
            ggd1.Greeting_Message__c = 'x';
            ggd1.GPO_Group__c = gpogroup.id;
            ggd1.Name = 'Standard Message 1';
            insert ggd1;
            gpoGroup.private__c = false;
       
        gpoGroup.PO_Number_Setup__c = 'S (--Select Any---)';
        gpoGroup.Cost_Center_Setup__c =  'S (--Select Any---)';
        gpoGroup.Release_Setup__c ='S (--Select Any---)';
        gpoGroup.Desktop_Setup__c = 'S (--Select Any---)';
        gpoGroup.inheritParentLogo__c = true;
        gpoGroup.inheritParentPageComponents__c = true;
        gpoGroup.inheritParentGreetingMessage__c = true;
            update gpoGroup;
            GPO_Lead__c lead = Test_Utils.createGPOLead(account,true);
            //User portalUser = getCommunityUser('aaa@officedepot.com','227112',contact.Id);
            User portalUser = getCommunityUser('a_227199@officedepot.com','227199',contact.Id);
            
            // Case Creation Test
           Account acct1 = new Account();
           Account acct2 = new Account();
           acct1.AOPS_Cust_ID__c = '00010001';
           acct1.Name = 'testName';
           acct1.Sales_PersonID__c = UserAccountOwner.id;
           insert acct1;
           GPO_Group__c group1 = new GPO_Group__c();
           group1.Account__C = acct1.id;
           group1.Welcome_Title__c = 'testTitle';
           insert group1;
           Case testCase1 = new Case();
           String groupid = '00010001';
           xGPOCommunityAuthLandingController.createCase(testCase1, groupId);
           testCase1.subject = 'asdf';
           xGPOCommunityAuthLandingController.createCase(testCase1, groupId);
            
            //GPO Link Test
            GPO_Link__c link1 = new GPO_Link__c();
            link1.GPO_Group__c = gpoGroup.Id;
            link1.Type__c = 'Invoice Request Form Field';
            link1.Invoice_Form_Fields__c = 'Business Extension';
            insert link1;
            GPO_Link__c link2 = new GPO_Link__c();
            link2.GPO_Group__c = gpoGroup.Id;
            link2.Type__c = 'Invoice Request Form Field';
            link2.Invoice_Form_Fields__c = 'Business Extension';
            link2.Active__c = true;
            link2.Hide__c = true;
            insert link2;
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
        
         ///////////////////// USER MAINT ??????????????????????????????????
                Account acctMaintTest = new Account();

                acctMaintTest.AOPS_Cust_ID__c = '00013331';
                acctMaintTest.Name = 'testName3333';
                acctMaintTest.Sales_PersonID__c = UserAccountOwner.id;
                insert acctMaintTest;
                GPO_Group__c group2 = new GPO_Group__c();
               group2.Account__C = acctMaintTest.id;
               group2.Welcome_Title__c = 'testTitle';
          //     group2.Public_Page_View__c = 'testTitle';
               group2.Community_Name__c = 'testName';
               insert group2;    
            
            
            
            
            
            
            
            
            //Added for Case#00123471
           
            System.runAs(portalUser){
                
                ApexPages.currentPage().getParameters().put('gpoLeadId',lead.Id);
                ApexPages.currentPage().getParameters().put('appType','A');
                ApexPages.currentPage().getParameters().put('id',account.Id);
                ApexPages.currentPage().getParameters().put('up',account.Id);
                Test.startTest();
                xGPOCommunityAuthLandingController cntrl = new xGPOCommunityAuthLandingController();
                 
                cntrl.enablecommunity();
                cntrl.activateCommunity();
                
                cntrl.switchSite();
                cntrl.save();
                
                cntrl.getItems();
                String mesId = cntrl.getmessageId();
                cntrl.setmessageId(mesId);
                //cntrl.approvalResponse();
                xGPOCommunityAuthLandingController.approvalResponse();
                cntrl.getMyApprovals();
                cntrl.process();
                cntrl.getActiveNodes();
                cntrl.getPagedAccounts();
                cntrl.getTemplateHomePage();
                cntrl.getTemplateMemberPage(); 
                cntrl.ActionVariables();
                cntrl.initAdminDetails();
               // cntrl.getGPOTempateUsed();
                cntrl.getAdminHeader();
                cntrl.getImageRootPath();
                cntrl.getIsImageDefined();
                cntrl.first();
                cntrl.last();
                cntrl.previous();
                cntrl.next();
                cntrl.cancel();
                system.assert(cntrl.getTemplateHomePage()!= null);
                system.assert(cntrl.getTemplateMemberPage()!= null);
                system.assert(cntrl.getMemberPage()!= null);
                system.assert(cntrl.getHomePage() != null);
                
                //
                Integer int1 = cntrl.getCurrentYear();
                //gpoGroup.Community_Image__c = '';
                //update gpoGroup;
                //Boolean idImage = cntrl.getIsImageDefined();
                String k = cntrl.publicKey;
                GPO_Lead__c g1 = new GPO_Lead__c();
                String appType = 'R';
                String[] sIds = new List<String>();
                sIds.add(g1.Id);
                xGPOCommunityAuthLandingController.ApproveLe(sIds,appType);
                insert g1;
                sIds.add(g1.Id);
                appType = 'A';
                xGPOCommunityAuthLandingController.ApproveLe(sIds,appType);
                xGPOCommunityAuthLandingController.keepAliveChk();
               
                
                 Test.stopTest();//end Case#00123471
                
                
                xGPOCommunityAuthLandingController.insertMaint(g1,acctMaintTest.AOPS_Cust_ID__c);
            
                cntrl.defaultTemplateID = '123';
                Boolean b1 = cntrl.hasNext;
                Boolean b2 = cntrl.hasPrevious;
                Integer int2 = cntrl.pageNumber;
                
                xGPOCommunityAuthLandingController.ChildAccountDetail c = new xGPOCommunityAuthLandingController.ChildAccountDetail(account,null,true);
      
        }
        
        
        }
    }
    
    static testMethod void myUnitTest2() {
        User user = getTestUser('System Administrator','aaab@officedepot.com','227112');
        
        System.runAs(user){
            Account account = Test_Utils.getTestAccount(user,'123456');
            Account account1 = Test_Utils.getTestAccount(user,'123457');
            Account childAcc = Test_Utils.getTestAccount(user,'1234561');
            childAcc.ParentId = account.Id;
            update  childAcc;
        //    Account prntAcc = Test_Utils.getTestAccount(user,'333333');
            User UserAccountOwner = Test_Utils.createTestUser('uao','233333');
            account.Sales_PersonID__c = UserAccountOwner.id;
            update account;
            Contact contact =  CreateContact(account1.Id);
            GPO_Template__c gpoTemp = Test_Utils.createGPOTemplate('Sample Template',false);
            gpoTemp.Home_Page__c =  '/gpo/GPOHome';
            gpoTemp.Member_Page__c = '/gpo/GPOMember';
            insert gpoTemp;
            
            GPO_Community_Setup__c gpoCommunitySetup = Test_Utils.createGPOCommunitySetUp(gpoTemp,false);
            gpoCommunitySetup.member_page__C = '/gpo/GPOMember';
            gpoCommunitySetup.home_page__c = '/gpo/GPOHome';
            gpoCommunitySetup.image_path__c = '/gpo/servlet/servlet.FileDownload?file=';
            gpoCommunitySetup.enabled_group_recordtypeid__c = Schema.SObjectType.GPO_Group__c.getRecordTypeInfosByName().get('Enabled GPO Community').getRecordTypeId(); //S-321807
            insert gpoCommunitySetup;
            //Communities v2
            GPO_Community_Setup__c gpoCommunitySetUp2 = new GPO_Community_Setup__c();
            gpoCommunitySetUp2.Name = 'com2Settings';
            gpoCommunitySetUp2.defaultTemplate__c = gpoTemp.Id;
            gpoCommunitySetUp2.Admin_ProfileId__c = '00eE0000000IQxT';
            gpoCommunitySetUp2.defaultRecordType__c = '012E000000093wNIAQ';
            gpoCommunitySetup2.member_page__C = '/gpo/GPOMember';
            gpoCommunitySetup2.home_page__c = '/gpo/GPOHome';
            gpoCommunitySetup2.image_path__c = '/gpo/servlet/servlet.FileDownload?file=';
            gpoCommunitySetUp2.enabled_group_recordtypeid__c = '012E000000093wMIAQ';
            insert gpoCommunitySetup2;
            
            GPO_Group__c gpoGroup = Test_Utils.createGPOGroup(gpoTemp, account1, false);
            gpoGroup.Welcome_Title__c = 'Test GPO Group Title';
            gpoGroup.RecordTypeId = Schema.SObjectType.GPO_Group__c.getRecordTypeInfosByName().get('Template Default').getRecordTypeId(); //S-321807
            gpoGroup.activated__c = true;
            gpogroup.Community_Name__c = 'Default Group';
            insert gpoGroup;
            Attachment att = new Attachment();
            att.Name = 'Test';
            att.body = Blob.valueOf('test');
            att.ParentId = gpoGroup.Id;
            insert att;
            gpoGroup.Community_Image__c = att.Id;
            GPO_Group_Detail__c ggd1 = new GPO_Group_Detail__c();
            ggd1.Greeting_Message__c = 'x';
            ggd1.GPO_Group__c = gpogroup.id;
            ggd1.Name = 'Standard Message 1';
            insert ggd1;
            gpoGroup.private__c = false;
       
        gpoGroup.PO_Number_Setup__c = 'S (--Select Any---)';
        gpoGroup.Cost_Center_Setup__c =  'S (--Select Any---)';
        gpoGroup.Release_Setup__c ='S (--Select Any---)';
        gpoGroup.Desktop_Setup__c = 'S (--Select Any---)';
        gpoGroup.inheritParentLogo__c = true;
        gpoGroup.inheritParentPageComponents__c = true;
        gpoGroup.inheritParentGreetingMessage__c = true;
            update gpoGroup;
            GPO_Lead__c lead = Test_Utils.createGPOLead(account,true);
            //User portalUser = getCommunityUser('aaa@officedepot.com','227112',contact.Id);
            User portalUser = getCommunityUser('a_227199@officedepot.com','227199',contact.Id);
            
            // Case Creation Test
           Account acct1 = new Account();
           Account acct2 = new Account();
           acct1.AOPS_Cust_ID__c = '00010001';
           acct1.Name = 'testName';
           acct1.Sales_PersonID__c = UserAccountOwner.id;
           insert acct1;
           GPO_Group__c group1 = new GPO_Group__c();
           group1.Account__C = acct1.id;
           group1.Welcome_Title__c = 'testTitle';
           insert group1;
         
            
                Account acctMaintTest = new Account();

                acctMaintTest.AOPS_Cust_ID__c = '00013331';
                acctMaintTest.Name = 'testName3333';
                acctMaintTest.Sales_PersonID__c = UserAccountOwner.id;
                insert acctMaintTest;
                GPO_Group__c group2 = new GPO_Group__c();
               group2.Account__C = acctMaintTest.id;
               group2.Welcome_Title__c = 'testTitle';
          //     group2.Public_Page_View__c = 'testTitle';
               group2.Community_Name__c = 'testName';
               insert group2;    
            
            
            
            
            
            
            
            
            //Added for Case#00123471
           
            System.runAs(portalUser){
                
                ApexPages.currentPage().getParameters().put('gpoLeadId',lead.Id);
                ApexPages.currentPage().getParameters().put('appType','A');
                ApexPages.currentPage().getParameters().put('id',account.Id);
                ApexPages.currentPage().getParameters().put('up',account.Id);
                Test.startTest();
                xGPOCommunityAuthLandingController cntrl = new xGPOCommunityAuthLandingController();
                 
               
                
                cntrl.getItems();
                String mesId = cntrl.getmessageId();
                cntrl.setmessageId(mesId);
       
              
                system.assert(cntrl.getHomePage() != null);
                
                //
                Integer int1 = cntrl.getCurrentYear();
                //gpoGroup.Community_Image__c = '';
                //update gpoGroup;
                //Boolean idImage = cntrl.getIsImageDefined();
                String k = cntrl.publicKey;
                GPO_Lead__c g1 = new GPO_Lead__c();
                String appType = 'R';
                String[] sIds = new List<String>();
                sIds.add(g1.Id);
                xGPOCommunityAuthLandingController.ApproveLe(sIds,appType);
                insert g1;
                sIds.add(g1.Id);
                appType = 'A';
                xGPOCommunityAuthLandingController.ApproveLe(sIds,appType);
                xGPOCommunityAuthLandingController.keepAliveChk();
               
                
                 Test.stopTest();//end Case#00123471
                
                
                xGPOCommunityAuthLandingController.insertMaint(g1,acctMaintTest.AOPS_Cust_ID__c);
            
                cntrl.defaultTemplateID = '123';
                Boolean b1 = cntrl.hasNext;
                Boolean b2 = cntrl.hasPrevious;
                Integer int2 = cntrl.pageNumber;
                
                xGPOCommunityAuthLandingController.ChildAccountDetail c = new xGPOCommunityAuthLandingController.ChildAccountDetail(account,null,true);
      
        }
        
        
        }
    }
    
    static User getCommunityUser(String userName,String empId,Id conId){
        Profile profileObj = [select id from profile where name= 'Customer Community Login User - GPO Admin'];
        String profId = profileObj.id;
        
        string email = userName;
        string[] name = userName.split('@');
        user u = new user(Username=userName,FirstName =name[1], LastName=name[0], Alias=name[0], CommunityNickname=userName, LocaleSidKey='en_US', EmailEncodingKey='UTF-8', Profileid = profId, LanguageLocaleKey='en_US');
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
        user u = new user(Username=userName,FirstName =name[1], LastName=name[0], Alias=name[0], CommunityNickname=userName, LocaleSidKey='en_US', EmailEncodingKey='UTF-8', Profileid = profId, LanguageLocaleKey='en_US');
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
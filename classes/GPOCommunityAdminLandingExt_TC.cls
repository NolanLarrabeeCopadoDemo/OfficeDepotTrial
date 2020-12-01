/**
 Created by Najma Ateeq
 */
@isTest
private class GPOCommunityAdminLandingExt_TC {

    static testMethod void myUnitTest() {
        User user = getTestUser('System Administrator','aaab@officedepot.com','227112');
        //Account parentAcc = Test_Utils.getTestAccount(user,'123456');
        System.runAs(user){
        Account account = Test_Utils.getTestAccount(user,'123456');
        //system.debug('account--Najma'+account.Id);
         Account childAcc = Test_Utils.getTestAccount(user,'1234561');
        childAcc.ParentId = account.Id;
        update  childAcc;
        system.debug('childAcc--'+childAcc.Id);
       
        //account.Parent_ID__c =  parentAcc.Id;
        //update account;
        Contact contact =  CreateContact(account.Id);
        
        //User user = Test_Utils.getTestUser('System Administrator','aaa@officedepot.com','227112');
       
        GPO_Template__c gpoTemp = Test_Utils.createGPOTemplate('Sample Template',false);
        gpoTemp.Home_Page__c =  '/gpo/GPOHome';
        gpoTemp.Member_Page__c = '/gpo/GPOMember';
        insert gpoTemp;
        GPO_Community_Setup__c gpoCommunitySetup = Test_Utils.createGPOCommunitySetUp(gpoTemp,false);
        gpoCommunitySetup.member_page__C = '/gpo/GPOMember';
        gpoCommunitySetup.home_page__c = '/gpo/GPOHome';
        gpoCommunitySetup.image_path__c = '/gpo/servlet/servlet.FileDownload?file=';
        gpoCommunitySetup.enabled_group_recordtypeid__c = '012M00000000jDDIAY';
      //  Modified by Rahul Story S-371041
        gpoCommunitySetup.Admin_ProfileId__c = [select Id from Profile where Name ='Customer Community Login User - GPO Admin' limit 1].Id;
        gpoCommunitySetup.defaultRecordType__c = Schema.SObjectType.GPO_Group__c.getRecordTypeInfosByName().get('Template Default').getRecordTypeId(); 
        //End S-371041
        insert gpoCommunitySetup ;
         
        GPO_Group__c gpoGroup = Test_Utils.createGPOGroup(gpoTemp, account, false);
            gpoGroup.Welcome_Title__c = 'Test GPO Group Title';
            //gpoGroup.RecordTypeId = '012M00000000jDEIAY';
            gpoGroup.RecordTypeId = Schema.SObjectType.GPO_Group__c.getRecordTypeInfosByName().get('Template Default').getRecordTypeId(); //S-321807
           gpoGroup.Activated__c = true;
           gpoGroup.Account__c = account.Id;
          // gpoGroup.Ultimate_Parent2__c = account.Id;
            //gpoGroup.Community_Image__c = att.Id;
            //gpoGroup.Parent__c = account.Id;
        insert gpoGroup;
        //system.debug('-----Najma'+[select Id,Ultimate_Parent2__c from GPO_Group__c where id =: gpoGroup.Id limit 1]);
       Attachment att = new Attachment();
         att.Name = 'Test';
         att.body = Blob.valueOf('test');
         att.ParentId = gpoGroup.Id;
         insert att;
         gpoGroup.Community_Image__c = att.Id;
         update gpoGroup;
         
         //GPO_Lead__c lead = Test_Utils.createGPOLead(childAcc,true);
        //User portalUser = getCommunityUser('aaa@officedepot.com','227112',contact.Id);
        User portalUser = getCommunityUser('a_227198@officedepot.com','227198',contact.Id);
        System.runAs(portalUser){
            
            
            GPOCommunityAuthLandingController cntrl = new GPOCommunityAuthLandingController();
            //cntrl.selectedGroup = gpoGroup;
            
            GPOCommunityAdminLandingExt ex = new GPOCommunityAdminLandingExt(cntrl);
            ex.save();
            ex.getPagedAccounts();
            ex.getActiveNodes();
            
            
            
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
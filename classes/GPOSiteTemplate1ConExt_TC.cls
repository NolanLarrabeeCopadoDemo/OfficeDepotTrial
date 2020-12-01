@isTest
private class GPOSiteTemplate1ConExt_TC
{
    static testMethod void myUnitTest() 
    {
         
        
         User user = getTestUser('System Administrator','aaab@officedepot.com','227112');
      //Account parentAcc = Test_Utils.getTestAccount(user,'123456');
      System.runAs(user){
       try{
        Account account = Test_Utils.getTestAccount(user,'123456');
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
        //gpoCommunitySetup.enabled_group_recordtypeid__c = '012M00000000jDDIAY';
        gpoCommunitySetup.enabled_group_recordtypeid__c = Schema.SObjectType.GPO_Group__c.getRecordTypeInfosByName().get('Enabled GPO Community').getRecordTypeId(); //S-321807
        gpoCommunitySetup.captcha_publicKey__c = '6Lc38AQTAAAAAKynztg9AZWXYB1a5h-YDj7EXKQi';
        insert gpoCommunitySetup ;
         
        GPO_Group__c gpoGroup = Test_Utils.createGPOGroup(gpoTemp, account, false);
            gpoGroup.Welcome_Title__c = 'Test GPO Group Title';
            //gpoGroup.RecordTypeId = '012M00000000jDEIAY';
            gpoGroup.RecordTypeId = Schema.SObjectType.GPO_Group__c.getRecordTypeInfosByName().get('Template Default').getRecordTypeId(); //S-321807
           gpoGroup.activated__c = true;
            //gpoGroup.Community_Image__c = att.Id;
            //gpoGroup.Parent__c = account.Id;
        insert gpoGroup;
       Attachment att = new Attachment();
          att.Name = 'Test';
         att.body = Blob.valueOf('test');
         att.ParentId = gpoGroup.Id;
         insert att;
         gpoGroup.Community_Image__c = att.Id;
         update gpoGroup;
         
         GPO_Lead__c lead = Test_Utils.createGPOLead(account,true);
      
          
          ApexPages.currentPage().getParameters().put('id','123456');
          ApexPages.currentPage().getParameters().put('recaptcha_challenge_field','test');
          ApexPages.currentPage().getParameters().put('recaptcha_response_field','test');
          GPOCommunityLandingController gpoCommunityLanding = new GPOCommunityLandingController();
          
          String pubKey = gpoCommunityLanding.publicKey;
          String clg = gpoCommunityLanding.challenge ;
          String res = gpoCommunityLanding.response ;
          PageReference chkusr = gpoCommunityLanding.checkUser();
          PageReference templateHome = gpoCommunityLanding.getTemplateHomePage();
          PageReference templateMember = gpoCommunityLanding.getTemplateMemberPage();
          String memberPage = gpoCommunityLanding.getMemberPage();
          String homePage = gpoCommunityLanding.getMemberPage();
          String imageRoot = gpoCommunityLanding.getImageRootPath();
          Boolean idImage = gpoCommunityLanding.getIsImageDefined();
         // Boolean gpoTemp = gpoCommunityLanding.getGPOTempateUsed();
          gpoCommunityLanding.newLead();
          //gpoCommunityLanding.saveLead();
          
          //GPO_Template__c temp = Test_Utils.createGPOTemplate('test XYZ' , true);
          //GPO_Group__c grp = Test_Utils.createGPOGroup(gpoTemp ,account  , true);
         
          GPO_Group_Detail__c  grpDetail = Test_Utils.createGPOGroupDetail(gpoGroup , 'test detail XXt',true);
         
           //GPOCommunityAuthLandingController  authLand = new GPOCommunityAuthLandingController ();
    gpoCommunityLanding.selectedGroup.ID  =gpoGroup.id; 
    GPOSiteTemplate1ConExt tempCon = new GPOSiteTemplate1ConExt(gpoCommunityLanding);
   // GPOSiteTemplate1ConExt tempCon2 = new GPOSiteTemplate1ConExt(authLand );
    tempCon.Cancel();
    tempCon.getNewsItems();
    
    //tempCon.NewsSave();
        }catch(Exception e){}   
        }    
           
     }    
     
     
     static testMethod void myUnitTest2() {
      User user = getTestUser('System Administrator','aaab@officedepot.com','227112');
      //Account parentAcc = Test_Utils.getTestAccount(user,'123456');
      System.runAs(user){
        Account account = Test_Utils.getTestAccount(user,'123456');
        //Added for Case#00123471
        Account account1 = Test_Utils.getTestAccount(user,'123457');
        //end Case#00123471
         Account childAcc = Test_Utils.getTestAccount(user,'1234561');
        childAcc.ParentId = account.Id;
        update  childAcc;
        
       
        //account.Parent_ID__c =  parentAcc.Id;
        //update account;
        //modified below line for Case#00123471 
        Contact contact =  CreateContact(account1.Id);
        
        //User user = Test_Utils.getTestUser('System Administrator','aaa@officedepot.com','227112');
       try{
        GPO_Template__c gpoTemp = Test_Utils.createGPOTemplate('Sample Template',false);
        gpoTemp.Home_Page__c =  '/gpo/GPOHome';
        gpoTemp.Member_Page__c = '/gpo/GPOMember';
        insert gpoTemp;
        GPO_Community_Setup__c gpoCommunitySetup = Test_Utils.createGPOCommunitySetUp(gpoTemp,false);
        gpoCommunitySetup.member_page__C = '/gpo/GPOMember';
        gpoCommunitySetup.home_page__c = '/gpo/GPOHome';
        gpoCommunitySetup.image_path__c = '/gpo/servlet/servlet.FileDownload?file=';
        //gpoCommunitySetup.enabled_group_recordtypeid__c = '012M00000000jDDIAY';
        gpoCommunitySetup.enabled_group_recordtypeid__c = Schema.SObjectType.GPO_Group__c.getRecordTypeInfosByName().get('Enabled GPO Community').getRecordTypeId(); //S-321807
        insert gpoCommunitySetup ;
        
        //modified below line for Case#00123471  
        GPO_Group__c gpoGroup = Test_Utils.createGPOGroup(gpoTemp, account1, false);
            gpoGroup.Welcome_Title__c = 'Test GPO Group Title';
            //gpoGroup.RecordTypeId = '012M00000000jDEIAY';
            gpoGroup.RecordTypeId = Schema.SObjectType.GPO_Group__c.getRecordTypeInfosByName().get('Template Default').getRecordTypeId(); //S-321807
           gpoGroup.activated__c = true;
            //gpoGroup.Community_Image__c = att.Id;
            //gpoGroup.Parent__c = account.Id;
        insert gpoGroup;
       Attachment att = new Attachment();
          att.Name = 'Test';
         att.body = Blob.valueOf('test');
         att.ParentId = gpoGroup.Id;
         insert att;
         gpoGroup.Community_Image__c = att.Id;
         update gpoGroup;
         
         GPO_Lead__c lead = Test_Utils.createGPOLead(account,true);
         GPO_Group_Detail__c  grpDetail = Test_Utils.createGPOGroupDetail(gpoGroup , 'test detail XXt',true);
        
          
        //User portalUser = getCommunityUser('aaa@officedepot.com','227112',contact.Id);
        User portalUser = getCommunityUser('a_227196@officedepot.com','227196',contact.Id);
        System.runAs(portalUser){
          GPOCommunityAuthLandingController authLand = new GPOCommunityAuthLandingController();
          authLand.selectedGroup.ID  =gpoGroup.id; 
          ApexPages.currentPage().getParameters().put('gpoLeadId',lead.Id);
          ApexPages.currentPage().getParameters().put('appType','A');
          ApexPages.currentPage().getParameters().put('id',account.Id);
          ApexPages.currentPage().getParameters().put('up',account.Id);
          authLand.defaultTemplateGroup = gpoGroup;
          authLand.newEnabledGroup = gpoGroup;
           GPOSiteTemplate1ConExt tempCon2 = new GPOSiteTemplate1ConExt(authLand );
           
          tempCon2.enableCommunityWithTemplateDetails();
         
          tempCon2.NewsSave();
           //GPOCommunityAuthLandingController.ChildAccountDetail c = new GPOCommunityAuthLandingController.ChildAccountDetail(account,null,true);
        }
        
         }
         catch(Exception e){}
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
/**
 * created by Najma Ateeq
 */
@isTest

private class GPO_Contact_Linking_Batch_TC {
    
    public static Account account;
    public static GPO_Template__c gpoTemp;

    static{
     System.runas(new user(ID = UserInfo.getUserID())){
         createTestData();
         }
    }
    
    //Modified for case#00123471
    static testMethod void myUnitTest() {      
        System.runas(new user(ID = UserInfo.getUserID())){
       Test.startTest(); 
       
       try{
        GPO_Group__c gpoGroup = Test_Utils.createGPOGroup(gpoTemp, account, false);
            gpoGroup.Welcome_Title__c = 'Test GPO Group Title';
            //gpoGroup.RecordTypeId = '012M00000000jDEIAY';
            gpoGroup.RecordTypeId = Schema.SObjectType.GPO_Group__c.getRecordTypeInfosByName().get('Template Default').getRecordTypeId(); //S-321807
           gpoGroup.activated__c = true;
            //gpoGroup.Community_Image__c = att.Id;
            //gpoGroup.Parent__c = account.Id; 
          insert gpoGroup;
         }catch(Exception e){} 
          
        
        GPO_Contact_Linking_Batch c = new GPO_Contact_Linking_Batch(); 
        Database.executeBatch(c);
       Test.stopTest();
        }
    }
    
    //Modified for case#00123471
    static testMethod void myUnitTest1() {     
        System.runas(new user(ID = UserInfo.getUserID())){
       Test.StartTest();
       
       try{
        GPO_Group__c gpoGroup = Test_Utils.createGPOGroup(gpoTemp, account, false);
            gpoGroup.Welcome_Title__c = 'Test GPO Group Title';
            //gpoGroup.RecordTypeId = '012M00000000jDEIAY';
            gpoGroup.RecordTypeId = Schema.SObjectType.GPO_Group__c.getRecordTypeInfosByName().get('Template Default').getRecordTypeId(); //S-321807
           gpoGroup.activated__c = true;
            //gpoGroup.Community_Image__c = att.Id;
            //gpoGroup.Parent__c = account.Id; 
          insert gpoGroup;
          }
          Catch (Exception e){}
         
        
        GPO_Contact_Linking_Batch sh1 = new GPO_Contact_Linking_Batch();
        String sch = '0 0 23 * * ?'; 
        system.schedule('Test Territory Check', sch, sh1); Test.stopTest(); 
        }
    }
    
    //Modified for case#00123471
    public static void createTestData(){
         System.runas(new user(ID = UserInfo.getUserID())){
        User user = Test_Utils.getTestUser('System Administrator','aaab@officedepot.com','227112');
         account = Test_Utils.getTestAccount(user,'1234567');
        
        Account childAcc = Test_Utils.getTestAccount(user,'1234561');
        childAcc.ParentId = account.Id;
        update  childAcc;
        
        Account childOfChildAcc = Test_Utils.getTestAccount(user,'12345611');
        childOfChildAcc.ParentId = childAcc.Id;
        update childOfChildAcc;
        
       
        //account.Parent_ID__c =  parentAcc.Id;
        //update account;
        Contact contact =  CreateContact(account.Id);
        Contact contact1 =  CreateContact(childAcc.Id);
        Contact contact2 =  CreateContact(childOfChildAcc.Id);
        
        }
        //User user = Test_Utils.getTestUser('System Administrator','aaa@officedepot.com','227112');
       
        gpoTemp = Test_Utils.createGPOTemplate('Sample Template',false);
        gpoTemp.Home_Page__c =  '/gpo/GPOHome';
        gpoTemp.Member_Page__c = '/gpo/GPOMember';
        insert gpoTemp;
        
        
        GPO_Community_Setup__c gpoCommunitySetup = Test_Utils.createGPOCommunitySetUp(gpoTemp,false);
        gpoCommunitySetup.member_page__C = '/gpo/GPOMember';
        gpoCommunitySetup.home_page__c = '/gpo/GPOHome';
        gpoCommunitySetup.image_path__c = '/gpo/servlet/servlet.FileDownload?file=';
        gpoCommunitySetup.enabled_group_recordtypeid__c = '012M00000000jDDIAY';
        gpoCommunitySetup.defaultTemplate__c = gpoTemp.Id;
        insert gpoCommunitySetup ;
         
      /*  GPO_Group__c gpoGroup = Test_Utils.createGPOGroup(gpoTemp, account, false);
            gpoGroup.Welcome_Title__c = 'Test GPO Group Title';
            gpoGroup.RecordTypeId = '012M00000000jDEIAY';
           gpoGroup.activated__c = true;
            //gpoGroup.Community_Image__c = att.Id;
            //gpoGroup.Parent__c = account.Id; 
          insert gpoGroup; */
        
       /* GPO_Group__c gpoGroup1 = Test_Utils.createGPOGroup(gpoTemp, account, false); 
            gpoGroup1.Welcome_Title__c = 'Test GPO Group Title';
            gpoGroup1.RecordTypeId = '012M00000000jDEIAY';
           gpoGroup1.activated__c = false;
           gpoCommunitySetUp.defaultTemplate__c = null;
            gpoCommunitySetUp.Admin_ProfileId__c = null;
            gpoCommunitySetUp.defaultRecordType__c = null;
            //gpoGroup.Community_Image__c = att.Id;
            //gpoGroup.Parent__c = account.Id;
        insert gpoGroup1;*/
    }
    public static Contact CreateContact(Id accountId) {
    Contact contact = new Contact(LastName = 'TEST',AccountId = accountId);
    contact.MailingCountry = 'MEX';
    contact.Admin_Context__c =  accountId;
    contact.GPO_Community__c =accountId;
    insert contact;
    
    return contact;
  }
}
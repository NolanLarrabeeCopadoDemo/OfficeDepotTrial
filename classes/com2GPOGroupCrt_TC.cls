/*
/ Test Class for com2GPOGroupCrt
*/

@isTest
public class com2GPOGroupCrt_TC {
   
    static testMethod void testClass() {
        
        GPO_Group__c testGroup = new GPO_Group__c();
        ApexPages.StandardController testController = new ApexPages.StandardController(testGroup);
        GPO_Template__c com2 = new GPO_Template__c();
        insert com2;
        GPO_Community_Setup__c gpoCommunitySetup = Test_Utils.createGPOCommunitySetUp(com2,false);
        gpoCommunitySetup.member_page__C = '/gpo/GPOMember';
        gpoCommunitySetup.home_page__c = '/gpo/GPOHome';
        gpoCommunitySetup.image_path__c = '/gpo/servlet/servlet.FileDownload?file=';
        gpoCommunitySetup.enabled_group_recordtypeid__c = '012M00000000jDDIAY';
        gpoCommunitySetup.captcha_publicKey__c = '6Lc38AQTAAAAAKynztg9AZWXYB1a5h-YDj7EXKQi';
        gpoCommunitySetup.defaultTemplate__c = com2.id;
        insert gpoCommunitySetup ;
        //Selected Message
        GPO_Group__c defaultGroup = new GPO_Group__c();
        defaultGroup.Community_Name__c = 'Default Group';
        defaultGroup.Welcome_Title__c = 'test';
        insert defaultGroup;
        GPO_Group_Detail__c defaultMessage = new GPO_Group_Detail__c();
        defaultMessage.GPO_Group__c = defaultGroup.id;
        defaultMessage.Name = 'Standard Message 1';
        defaultMessage.Greeting_Message__c = 'x';
        defaultMessage.Type__c = 'Greeting Message';
        insert defaultMessage;
        //
        
        com2GPOGroupCrt x = new com2GPOGroupCrt(testController);
        x.newgpo.Welcome_Title__C = 'test';
        x.newgpo.GPO_Template__c = com2.id;
        
        PageReference testPage = x.Save();
        testPage = x.Cancel();
        x.newgpo.Welcome_Title__C = null;
        PageReference testPage2 = x.Save();
        //Selected Message
        x.newgpo.selected_message__c = defaultMessage.id;
        x.getItems();
        String mesId = x.getmessageId();
        x.setmessageId(mesId);
        //
        
    }
}
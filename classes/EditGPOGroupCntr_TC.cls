/*
/ Test Class for EditGPOGroupCntr
*/

@isTest
public class EditGPOGroupCntr_TC {
    static testMethod void testClass() {
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
      //  defaultGroup.selected_message__c = defaultMessage1.id;
        insert defaultGroup;
        GPO_Group_Detail__c defaultMessage = new GPO_Group_Detail__c();
        defaultMessage.GPO_Group__c = defaultGroup.id;
        defaultMessage.Name = 'Standard Message 1';
        defaultMessage.Greeting_Message__c = 'x';
        defaultMessage.Type__c = 'Greeting Message';
        insert defaultMessage;
        //
        GPO_Group__c testGroup = new GPO_Group__c();
        testGroup.Welcome_Message__c = 'test';
        testGroup.Welcome_Title__C = 'test';
        insert testGroup;
        ApexPages.StandardController testController = new ApexPages.StandardController(testGroup);
        
        EditGPOGroupCntr x = new EditGPOGroupCntr(testController);
        x.selectedGroup.Welcome_Title__C = 'test';
        x.selectedGroup.GPO_Template__c = com2.id;
        //Selected Message
        x.selectedGroup.selected_message__c = defaultMessage.id;
        x.getItems();
        String mesid = x.getmessageId();
        x.setmessageId(mesid);
        //
        GPO_Group_Detail__c duplicateMessage = new GPO_Group_Detail__c();
        duplicateMessage.GPO_Group__c = testGroup.id;
        duplicateMessage.Name = 'asdf';
        duplicateMessage.Greeting_Message__c = 'asdf';
        duplicateMessage.Type__c = 'Greeting Message';
        insert duplicateMessage;
        //
        testGroup.selected_message__c = defaultMessage.id;
        update testGroup;
        ApexPages.StandardController testController2 = new ApexPages.StandardController(testGroup);
        EditGPOGroupCntr x2 = new EditGPOGroupCntr(testController2);
    }
}
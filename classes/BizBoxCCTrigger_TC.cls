@isTest
public class BizBoxCCTrigger_TC {

    testmethod static void testCompuComBBOXLead(){
        //Insert BizBox Lead
        CompuCom_BBOX_Lead__c comBoxLead = new CompuCom_BBOX_Lead__c();
        comBoxLead.Name = 'Test Com BBOX Lead';
        comBoxLead.First_Name__c = 'Test First';
        comBoxLead.Last_Name__c = 'Test Second';
        comBoxLead.Company__c = 'Test Company';
        comBoxLead.Phone__c = '1234567890';
        comBoxLead.Email__c = 'test@test.com';
        comBoxLead.Discovery_Notes__c = 'Test Notes';
        comBoxLead.Store_Associate_Name__c = 'Test';
        comBoxLead.Store_Associate_ID__c = 'Test Ass';
        comBoxLead.Store_Number__c = 'Store';
        
        insert comBoxLead;
    }
}
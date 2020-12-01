@isTest
public class SubmitCaseControllerTest {
    @isTest
    public static void testSubmitController(){
        
        profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        
        User oUser = new User(Alias = 'test', Email='test@test.com',
                    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = p.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='sdss123@test.com');
        submitCaseController.fetchLoginUserDetails();
    }
     @isTest
    public static void testSave(){
        
        case oCase = new case();
        submitCaseController.saveCase(oCase);
        submitCaseController.getselectOptions(oCase, 'Dev_Source__c');
    }
}
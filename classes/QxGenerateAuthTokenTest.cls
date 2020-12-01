@isTest
public class QxGenerateAuthTokenTest {
    
    @isTest
    public static void generateAuthenticationTokenTest(){
        Test.startTest();
         insert new  ProsCustomSettings__c(Name = 'CCORE',
                                                   User_Name__c = 'test',Symmetric_Key__c = 'Z+b4h9iPodOy6594ozdVfw==',Password__c='test',
                                                  CCORE_Username__c = 'test',CCORE_Password__c = 'test');
        QxGenerateAuthToken.generateAuthenticationToken();
        Test.stopTest();
    }
}
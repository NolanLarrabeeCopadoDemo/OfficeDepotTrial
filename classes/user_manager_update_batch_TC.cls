/**
 * Created by Najma Ateeq for Story #S-331356
 */
@isTest
private class user_manager_update_batch_TC {

    static testMethod void myUnitTest() {
       createTestData();
       	
        Test.startTest();
        user_manager_update_batch sb=new user_manager_update_batch();
        String sch = '0 0 23 * * ?';
        system.schedule('Test check', sch, sb);
        Test.stopTest();
    }
    static testMethod void myUnitTest1() {
       createTestData();
       	
        Test.startTest();
        user_manager_update_batch sb=new user_manager_update_batch();
        database.executeBatch(sb);
        Test.stopTest();
    }
    static void createTestData(){
    	User u2=[SELECT id,ProfileId,OD_Employee_ID__c,TimeZoneSidKey FROM User WHERE id =:UserInfo.getUserId()];
        
        User u = new user(Username='test_test1@acme.com',FirstName ='test123', LastName='xyz123', Alias='a', CommunityNickname='aa', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', ProfileId=u2.ProfileId, LanguageLocaleKey='en_US');
        u.email='aaabc@officedepot.com';
        u.MB_Expiration_Date__c = System.now().addminutes(1);
        u.OD_Employee_ID__c ='622207';
       // u.Manager_Employee_Number__c = '12345';
        u.IsActive=true;
        u.TimeZoneSidKey=u2.TimeZoneSidKey;
        u.Token_Market_Builder__c ='abc';
        Insert u;
        
    	User_Staging__c usrStaging = new User_Staging__c(Email__c='abcd@officedepot.com',OD_Employee_Number__c='622207',Title__c='USSTO:000540:Sales Consultant-Print Serv',Manager_Employee_Number__c = '12345',status__c = 'Pending Manager');
    	insert usrStaging;
    }
}
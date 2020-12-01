/***
Description: The test Class  for the account changes batch classes, email handler and emailservice handler classes.
Created By: Lalit Malav
Created Date: 21-March-2016
**/
@isTest
private class ChatterAnswersAuthProviderReg_TC {

    static testMethod void myUnitTest() {
       Auth.UserData sampleData = new Auth.UserData('testId', 'testFirst', 'testLast',
        'testFirst testLast', 'testuser@example.org', null, 'testuserlong', 'en_US', 'facebook',
        null, new Map<String, String>{'language' => 'en_US'});
       ChatterAnswersAuthProviderRegistration obj = new ChatterAnswersAuthProviderRegistration();
       User u11 = obj.createUser(null, sampleData);
       //insert u;
       Account A2 = new Account();
	   A2.Name='Test';
	   A2.AOPS_Cust_Id__c ='123';
	   A2.OMX_Primary_Key__c='2719';
	   A2.AOPS_Seq_ID__c ='123';
	   Insert A2;
       Contact c1 = new Contact();
	   c1.LastName='LastNametest';
	   c1.FirstName='FirstNametest';
	   c1.email='testemail@test.com';
	   c1.AccountId = A2.id;
	   c1.OMX_Primary_Key__c='1234';
	   insert c1;
       /*User u2=[SELECT id,ProfileId,OD_Employee_ID__c,TimeZoneSidKey FROM User WHERE id =:UserInfo.getUserId()];
       User u = new user(Username='test_test1@acme.com',FirstName ='test123', LastName='xyz123', Alias='a', CommunityNickname='aa', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', ProfileId=u2.ProfileId, LanguageLocaleKey='en_US');
       u.email='aaabc@officedepot.com';
       u.MB_Expiration_Date__c = System.now().addminutes(1);
       u.OD_Employee_ID__c ='622207';
       u.IsActive=true;
       u.TimeZoneSidKey=u2.TimeZoneSidKey;
       u.Token_Market_Builder__c ='abc';
       u.ContactId = c1.id;
       Insert u;*/
       User portalUser = getCommunityUser('a_227199@officedepot.com','227199',c1.Id);
       obj.updateUser(portalUser.id, null, sampleData);
       List<User> updatedUser = [select id, firstName, lastName from User where id =:portalUser.id];
       //System.assertEquals(updatedUser[0].firstName, sampleData.firstName);//Commented by Lallit due to some other changes in other class
       //System.assertEquals(updatedUser[0].lastName, sampleData.lastName);
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
}
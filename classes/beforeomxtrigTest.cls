@isTest
private class beforeomxtrigTest {
    static User testUser;
	private static testMethod void restoreAPItest() {
          User stdTestUser = new User();
     stdTestUser.firstName = 'stdTestUser';
     stdTestUser.LastName = 'test';
     stdTestUser.Alias = '12';
     stdTestUser.Email = 'stdTestUser@officedepot.com';
     stdTestUser.UserName= 'zzdataloadernorth@officedepot.com';
     stdTestUser.ProfileId = [Select id from profile where name = 'System Administrator' limit 1].Id;
     stdTestUser.CommunityNickname = stdTestUser.firstname+'_'+stdTestUser.lastName;
     stdTestUser.EmailEncodingKey ='ISO-8859-1';
     stdTestUser.LanguageLocaleKey = 'en_US';
     //stdTestUser.TimeZoneSidKey ='America/Indianapolis';
     stdTestUser.TimeZoneSidKey ='America/New_York';
     stdTestUser.LocaleSidKey = 'en_US';
     stdTestUser.Country = 'USA';
     stdTestUser.OD_Employee_ID__c ='odEmpId';
     insert stdTestUser;
         System.RunAs(stdTestUser){
             Account account = new Account(Name = 'acct1',omx_primary_key__C='123456');
             insert account;
             Account_Extension__c ae=[select id from account_extension__c where Original_Account_ID__c=:account.id];
             Account_Dormant__C ad = new Account_Dormant__c(AccountExtension__c = ae.id);
             insert ad;
             delete account;
             Account account2 = new Account(Name = 'acct1',omx_primary_key__C='123457');
             insert account2;
         }
	}
}
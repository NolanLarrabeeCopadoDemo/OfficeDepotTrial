@isTest
private class UserHelper_TC
{
static testMethod void UserHelper(){

  UserHelper  oUserHelper  = new UserHelper ();
 UserHelper.allUserData();
 Test.startTest();  // Added by Jasvinder for case :00181811
 UserHelper.allActiveUserData();
 UserHelper.allUsrRleChanged();
 User usr = new user ();
  usr = [Select Id, Name, UserName, EMail from User where isActive = true and OD_Employee_ID__c != null limit 1];
 UserHelper.isActiveUserId(usr.id);
 UserHelper.isValidUserId(usr.id);
 UserHelper.getUserRecord(usr.id);
 Set<string> sstr = new Set<string>();
 sstr.add('M');
 Profile p4 = [SELECT Id FROM profile WHERE name='System Administrator'];
 User u1 = new User(alias = 'test123 ', email='proxy@proxy456.officedepot.com',OD_Employee_ID__c='456218',emailencodingkey='UTF-8', lastname='test123',FirstName='usr1',languagelocalekey='en_US',localesidkey='en_US', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='proxy@proxy456.com',isactive=true, Region__c='M',Market__c='M');
 insert u1;

 User u2 = new User(alias = 'test123 ', email='proxy@proxy446.officedepot.com',OD_Employee_ID__c='785461',emailencodingkey='UTF-8', lastname='tet123',FirstName='usr2',languagelocalekey='en_US',localesidkey='en_US', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='proxy@proxy446.com',isactive=true, Region__c='M',Market__c='M');
 insert u2;

 User u3 = new User(alias = 'test123 ', email='proxy@proxy446.officedepot.com',OD_Employee_ID__c='895621',emailencodingkey='UTF-8', lastname='tet123',languagelocalekey='en_US',localesidkey='en_US', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='proxy@proxy466.com',isactive=true);
 insert u3;


 Set<Id> userIds = new Set<ID>();
 userIds.add(u1.id);
 userIds.add(u2.id);

 Set<String> userIdstring = new Set<String>();
 userIdstring.add(u1.id);
 userIdstring.add(u2.id);

 Set<Id> usersid = new set<Id>();
 usersid.add(u3.id);


  Set<String> userName = new Set<String>();
  userName.add(u1.name);
  userName.add(u2.name);

 UserHelper.allActiveUsersByRegion(sstr );
 userHelper.allActiveUsersByMarket(sstr);
 userHelper.retrieveUserData(userIds);
 userHelper.retrieveUserData(userIdstring);
 userHelper.getUserRecords(usersid);
 userHelper.retrieveUserDataFromNames(userName);
  Test.stopTest();

}

}
@isTest
public class UpdateOwner_TC {
    public static testMethod void test() {
        User stdTestUser = new User();
        stdTestUser.firstName = 'stdTestUser';
        stdTestUser.LastName = 'test';
        stdTestUser.Alias = 'test11';
        stdTestUser.Email = 'mkiolgfjlll@officedepot.com';
        stdTestUser.UserName= 'mkiolgfjlll@metacube.com';
        stdTestUser.ProfileId = [Select id from profile where name = 'System Administrator' limit 1].Id;
        stdTestUser.CommunityNickname = stdTestUser.firstname+'_'+stdTestUser.lastName;
        stdTestUser.EmailEncodingKey ='ISO-8859-1';
        stdTestUser.LanguageLocaleKey = 'en_US';
        stdTestUser.TimeZoneSidKey ='America/New_York';
        stdTestUser.LocaleSidKey = 'en_US';
        stdTestUser.Country = 'USA';
        stdTestUser.OD_Employee_ID__c = '999654';
        stdTestUser.managerid = stdTestUser.id;
        insert stdTestUser;
        
        User u1 = new User();
        u1.firstName = 'managerTestUser';
        u1.LastName = 'test';
        u1.Alias = 'test11';
        u1.Email = 'qwertyhjkdldnjglajsjsj@officedepot.com';
        u1.UserName= 'qwertyhjkdldnjglajsjsj@metacube.com';
        u1.ProfileId = [Select id from profile where name = 'System Administrator' limit 1].Id;
        u1.CommunityNickname = u1.firstname+'_'+u1.lastName;
        u1.EmailEncodingKey ='ISO-8859-1';
        u1.LanguageLocaleKey = 'en_US';
        u1.TimeZoneSidKey ='America/New_York';
        u1.LocaleSidKey = 'en_US';
        u1.Country = 'USA';
        u1.OD_Employee_ID__c = '999655';
        u1.managerid = stdtestUser.id;
        insert u1;
        System.runAs ( new User(Id = UserInfo.getUserId()) ) {
        
        if (stdtestUser.id != null){
            Coaching__c c = new Coaching__c(    Sales_Rep__c = stdtestUser.id );
            insert c;
            Coaching__c c2 = new Coaching__c(   Sales_Rep__c = u1.id );
            insert c2;            
        }
}
        
    }
}
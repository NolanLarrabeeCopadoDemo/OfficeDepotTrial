@isTest
public class UsersToDeactivateController_TC {
    
    static testMethod void test() {
        // Prepare test data    
        Profile supportP = [SELECT Id FROM Profile WHERE Name = 'Support'];
        Profile chatterP = [SELECT Id FROM Profile WHERE Name = 'Chatter Free User'];
    
        User u1 = new User(lastname = 'Test',
                           od_employee_id__c = '987654',
                           Username = 'sdjfasjkfasklf@officedepot.com', 
                           Email = 'sdjfasjkfasklf@officedepot.com', 
                           Alias = 'poiuy', 
                           CommunityNickname = 'poiuy', 
                           LocaleSidKey = 'en_US', 
                           LanguageLocaleKey = 'en_US');
        User_Staging__c us1 = new User_Staging__c(od_employee_number__c = '987654',
                                                  hiredate__c = Date.newInstance(2015,04,08),
                                                  termdate__c = Date.newInstance(2015,04,10),
                                                  isactive__c = false,
                                                  Name = 'Test', 
                                                  Last_Name__c = 'Test',
                                                  Title__c = 'Test Title',
                                                  Email__c = 'sdjfasjkfasklf@officedepot.com');
        User u2 = new User(lastname = 'Test',
                           od_employee_id__c = '987987',
                           Username = 'sdjfa987@officedepot.com', 
                           Email = 'sdjfas987sklf@officedepot.com', 
                           Alias = 'poiuy', 
                           CommunityNickname = 'poixx', 
                           LocaleSidKey = 'en_US', 
                           LanguageLocaleKey = 'en_US',
                           ProfileId = supportP.Id);
        User_Staging__c us2 = new User_Staging__c(od_employee_number__c = '987987',
                                                  hiredate__c = Date.newInstance(2015,04,08),
                                                  isactive__c = true,
                                                  Name = 'Test', 
                                                  Last_Name__c = 'Test',
                                                  Title__c = 'Test123',
                                                  Email__c = 'sdjfasjkfasklf@officedepot.com',
                                                  Profile__c = 'Chatter Free User');
                                                  
        insert u1;
        insert us1;
        insert u2;
        insert us2;
        
        UsersToDeactivateController.UserWrapper wrapper1 = new UsersToDeactivateController.UserWrapper(u1,us1);
        wrapper1.selected = true;
        UsersToDeactivateController.UserWrapper wrapper2 = new UsersToDeactivateController.UserWrapper(u2,us2);
        wrapper2.selected = true;
        
        List<UsersToDeactivateController.UserWrapper> wrapperList = new List<UsersToDeactivateController.UserWrapper>();
        wrapperList.add(wrapper1);
        wrapperList.add(wrapper2);
        
        UsersToDeactivateController controller = new UsersToDeactivateController();
        controller.usersToDeactivate = wrapperList;
        
        // Test
        User usr = [Select id from User where Id = :UserInfo.getUserId()];
 
        System.RunAs(usr) {
            Test.startTest();
            controller.deactivateUsers();
            Test.stopTest();
        }
    }
}
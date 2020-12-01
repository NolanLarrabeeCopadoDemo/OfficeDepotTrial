@isTest
public class UserExtension_TC {
    
    static testMethod void test() {
        User u = new User(lastname = 'Test',
                          od_employee_id__c = '987654',
                          Username = 'sdjfasjkfasklf@officedepot.com', 
                          Email = 'sdjfasjkfasklf@officedepot.com', 
                          Alias = 'poiuy', 
                          CommunityNickname = 'poiuy', 
                          LocaleSidKey = 'en_US', 
                          LanguageLocaleKey = 'en_US');
        User_Staging__c us = new User_Staging__c(od_employee_number__c = '987654',
                                                 hiredate__c = Date.newInstance(2015,04,08),
                                                 termdate__c = Date.newInstance(2015,04,10),
                                                 isactive__c = false,
                                                 Name = 'Test', 
                                                 Last_Name__c = 'Test',
                                                 Title__c = 'Test Title',
                                                 Email__c = 'sdjfasjkfasklf@officedepot.com');
        insert u;
        insert us;
        
        UserExtension ue = new UserExtension(new ApexPages.StandardController(us));
        
        UserExtension.deactivateUsers('987654;');
    }
}
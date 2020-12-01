@isTest(SeeAllData=true)
//Test class for Chatter Group Addition Method
public class AddUser_TC {
    static testMethod void removefromGroup_TC() {    
    Profile p = [SELECT Id FROM Profile WHERE Name='Field Sales']; 
    
test.starttest();
        User u = new User(Alias = 'standt', Email='standarduser@officedepot.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@officedepot.com',OD_Employee_ID__c ='9023311');

insert u;
test.stoptest();
}
}
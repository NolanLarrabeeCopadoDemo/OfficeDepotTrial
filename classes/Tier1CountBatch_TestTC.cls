// Test class for Tier1CountBatch batch job
// Counts the number of Child Accounts with the Tier_1__c flag attached to each Parent, Grandparent, GreatGrandParent
// Story #: 
@isTest
public class Tier1CountBatch_TestTC {
    @isTest
    static void Tier1CountTest() {
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        
       User u = new User(Alias = 'standt', Email='standarduserODAppirio@officedepot.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduserODAppirio@officedepot.com');
        
        User uNot = new User(Alias = 'standt', Email='usernotODAppirio@officedepot.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='usernotODAppirio@officedepot.com');

        User uDM = new User(Alias = 'sndt', Email='dMODAppirio@officedepot.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='dmODAppirio@officedepot.com');
            
            insert u;
        insert uNot;
        insert uDM;
        
        Partner__c partner2 = new Partner__c();
        partner2.name = 'test';
        partner2.OwnerId = u.id;
        partner2.Partner_Migration_Status__c = 'Ready for Migration';
        partner2.Diversity_Manager__c = u.id;
        insert partner2;
        
        Account ggp1 = new Account();
        ggp1.Name = 'Test Tier 1 greatgrandparent account 123';
        insert ggp1;
        
        Customer_Transition__c cggp1 = new Customer_Transition__c();
        cggp1.Name = 'Test Tier 1 greatgrandparent transition 123';
        cggp1.Account__c = ggp1.id;
        insert cggp1;
        
        Account gp1 = new Account();
        gp1.Name = 'Test Tier 1 grandparent account 123';
        insert gp1;
        
        Customer_Transition__c cgp1 = new Customer_Transition__c();
        cgp1.Name = 'Test Tier 1 grandparent transition 123';
        cgp1.Account__c = gp1.id;
        cgp1.Parent_Transition_ID__c = cggp1.id;
        insert cgp1;
        
        Account p1 = new Account();
        p1.Name = 'Test Tier 1 parent account 123';
        insert p1;
        
        Customer_Transition__c cp1 = new Customer_Transition__c();
        cp1.Name = 'Test Tier 1 parent transition 123';
        cp1.Account__c = p1.id;
        cp1.Parent_Transition_ID__c = cgp1.id;
        insert cp1;
        
        Account c1 = new Account();
        c1.Name = 'Test Tier 1 child account 123';
        c1.Tier_1_Partner__c = partner2.id;
        insert c1;
        
        Customer_Transition__c ct1 = new Customer_Transition__c();
        ct1.Name = 'Test Tier 1 child transition 123';
        ct1.Account__c = c1.id;
        ct1.Parent_Transition_ID__c = cp1.id;
        insert ct1;
        
       Test.startTest();
            Tier1CountBatch tb = new Tier1CountBatch();
            database.executeBatch(tb,10);
            String CRON_EXP = '0 0 0 3 9 ? 2022';
     	System.schedule('TestBatch1',CRON_EXP , tb );
        Test.stopTest();
    }
}
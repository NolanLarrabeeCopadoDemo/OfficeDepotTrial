@isTest
public class QuoteTriggerTest {
    
    private static void quoteTestData(){
        RecordType rtCust   = [SELECT Id FROM RecordType WHERE sObjectType = 'Account' AND Name = 'Customer'];
        RecordType rtSite   = [SELECT Id FROM RecordType WHERE sObjectType = 'Account' AND Name = 'Site'];
        
        Account acc = new Account();
        acc.Name='Test Acc';
        acc.RecordtypeId=rtCust.Id;
        insert acc;
        
        Account siteAcc1     = new Account(Name='Siteacc1', RecordtypeId=rtSite.Id, related_Account__c=acc.id);
        Account siteAcc2     = new Account(Name='Siteacc2', RecordtypeId=rtSite.Id, related_Account__c=acc.id);
        List<Account> accounts   = new List<Account>{ siteAcc1, siteAcc2 };
            insert accounts;
        
        Opportunity opp = new Opportunity();
        opp.AccountId = acc.Id;
        opp.name = 'testOpp';
        opp.status__c = 'open';
        opp.stagename = 'Qualify';
        opp.CloseDate = System.today().adddays(100);
        insert opp;
        
        
        Quote q=new Quote();
        q.name = 'testQ';
        q.OpportunityId= opp.Id;
        q.Quote_Id__c = '112233';
        q.Bill_To_Account__c = siteAcc1.Id;
        q.ship_to_account__c=siteAcc2.Id;
        insert q;
        
        RecordType rtQuoteTech   = [SELECT Id FROM RecordType WHERE sObjectType = 'Quote'	 AND Name = 'Tech'];
        Quote qtech=new Quote();
        qtech.name = 'testQTech';
        qtech.OpportunityId= opp.Id;
        qtech.Quote_Id__c = '1235745';
        qtech.Bill_To_Account__c = siteAcc1.Id;
        qtech.ship_to_account__c=siteAcc2.Id;
        qtech.RecordTypeId=rtQuoteTech.Id;
        insert qtech;

    }
    @isTest
    private static void updatePricebookTest(){
        quoteTestData();
    } 
    @isTest
    private static void insertsForSOA() {
     quoteTestData();    
    }
}
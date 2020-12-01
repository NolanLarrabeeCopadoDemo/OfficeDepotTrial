/******************************************************
* Name : GTOpportunityTrigger_TC
* Created By : Alka Taneja
* Created Date : 16 June, 2016
* Story : S-418600 (00715635)
/******************************************************/
@isTest(seeAllData=false)
public class GTOpportunityTrigger_TC {

    public static Opportunity opp;
    public static Account acc;
    
    public static testMethod void TestActvityCreation() {
        
        Test.startTest();
        
        createTestData();
        
        Test.stopTest();
        
       opp = [select id, Amount from Opportunity where id = :opp.id][0];
       
       if(opp.amount < 0) {
           system.assert( false, 'Here is an error message.');
       }

    }
    
    public static void createTestData() {
      
      acc = Test_Utils.GenerateAccount();
      acc.oracle_party_site_id__c = '.a446';
      acc.name = 'testAccount1';
      insert acc;
      
      opp = new Opportunity();  
      opp.Name = 'testOpp';
      opp.AccountId = acc.Id;
      opp.StageName = '0%-Lost';
      opp.CloseDate = System.today().addDays(20);
      opp.Close_Reason__c = 'Other';
      opp.recordTypeid = Label.GTOpportunity;
      opp.Amount_CAD__c = 12;
      insert opp;
      
    }
}
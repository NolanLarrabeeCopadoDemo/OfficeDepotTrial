/**@@
#CLASS NAME  :  OpportunityProductController_Test(Related classes: OpportunityProductController)
#DESCRIPTION :   Modified for NAIT-148129 03050397 - Price Book Screen Times Out When Selecting Products
#MODIFIEDDATE :  18-08-2020 (DD-MM-YYYY) 
@@**/
@isTest
public class OpportunityProductController_Test 
{
    @TestSetup public static void setup()
    {
        List<Account> accountList = DataFactory.createAccountTestRecords('Test acc', 5, '');
        List<Account> childAccountList = DataFactory.createAccountTestRecords('Test acc', 1, accountList[0].id);
        if(accountList != null && accountList.size() > 0)
        {
            insert new opportunity( Name='Test Opp', AccountId = childAccountList[0].id,StageName = 'Advising', CloseDate = date.today().adddays(1),Decision_Date__c = date.today());
        }
    }
    
    @isTest
    public static void testInit()
    {
        list<Opportunity> lstOpportunity = [select id from Opportunity limit 1];
        System.currentPageReference().getParameters().put('oppId',(string)lstOpportunity[0].Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(lstOpportunity[0]);
        OpportunityProductController objcontroller = new OpportunityProductController(sc);
        test.startTest();
        objcontroller.init();
        system.assertEquals(true, objcontroller.oppId != null);
        test.stopTest();
    }
    
    @isTest
    public static void testOppUpdate()
    {
        list<Opportunity> lstOpportunity = [select id from Opportunity limit 1];
        System.currentPageReference().getParameters().put('oppId',(string)lstOpportunity[0].Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(lstOpportunity[0]);
        OpportunityProductController objcontroller = new OpportunityProductController(sc);
        test.startTest();
        OpportunityProductController.updateOpportunityPricebook(lstOpportunity[0].Id, test.getStandardPricebookId());
        system.assertEquals(true, objcontroller.oppId == null);
        test.stopTest();
    }
    
    @isTest
    public static void testProducts()
    {
        list<Opportunity> lstOpportunity = [select id from Opportunity limit 1];
        System.currentPageReference().getParameters().put('oppId',(string)lstOpportunity[0].Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(lstOpportunity[0]);
        OpportunityProductController objcontroller = new OpportunityProductController(sc);
        test.startTest();
        List<pricebookentry> lstPB = OpportunityProductController.getProducts(test.getStandardPricebookId());
        system.assertEquals(true, lstPB != null);
        test.stopTest();
    }
}
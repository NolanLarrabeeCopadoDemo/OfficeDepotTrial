/**@@
#CLASS NAME  :  EditOpportunityProductController_Test(Related classes: EditOpportunityProductController)
#DESCRIPTION :   Modified for NAIT-148130 03050412 - Product and Product Subtype Dependency Upon Editing Products
#MODIFIEDDATE :  18-08-2020 (DD-MM-YYYY) 
@@**/
@isTest
public class EditOpportunityProductController_Test {
    
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
        EditOpportunityProductController objcontroller = new EditOpportunityProductController(sc);
        test.startTest();
        objcontroller.init();
        system.assertEquals(true, objcontroller.oppId != null);
        test.stopTest();
    }
    
     @isTest
    public static void testProducts()
    {
        list<Opportunity> lstOpportunity = [select id from Opportunity limit 1];
        System.currentPageReference().getParameters().put('oppId',(string)lstOpportunity[0].Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(lstOpportunity[0]);
        EditOpportunityProductController objcontroller = new EditOpportunityProductController(sc);
        test.startTest();
        List<OpportunityLineItem> lstPB = EditOpportunityProductController.getProducts(lstOpportunity[0].Id);
        system.assertEquals(true, lstPB != null);
        test.stopTest();
    }
}
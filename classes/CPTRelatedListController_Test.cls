/**@@
    #CLASS NAME  :  CPTRelatedListController_Test 
    #DESCRIPTION :  Test class for "CPTRelatedListController" 
    #CREATEDDATE :  04-27-2020 (DD-MM-YYYY) 
@@**/

@IsTest
public class CPTRelatedListController_Test {
    @TestSetup public static void setup(){
        List<Account> accountList = DataFactory.createAccountTestRecords('Test acc', 5, '');
        if(accountList != null && accountList.size() > 0){
            List<Contract> contractList =  DataFactory.createContractTestRecords('Test contract', accountList [0].id, 5);
            List<Contract_Pricing_Terms__c> cptList = DataFactory.createContractPriceTermsTestRecords('Testing', contractList[0].id, 5);
        }
        
    }
    
    static testMethod void fetchCPT_Method(){
        List<Contract> contractList = [Select id From Contract Limit 5];
        CPTRelatedListController.fetchCPT(contractList[0].id);
    }

    static testMethod void deleteCPT_Method(){
        List<Contract_Pricing_Terms__c> cptList = [Select id From Contract_Pricing_Terms__c Limit 2];
        CPTRelatedListController.deleteCPT(cptList[0].id);
    }
}
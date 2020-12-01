/**@@
    #CLASS NAME  :  MultiSelectPicklistController_Test 
    #DESCRIPTION :  Test class for "MultiSelectPicklistController" 
    #CREATEDDATE :  04-27-2020 (DD-MM-YYYY) 
@@**/

@IsTest
public class MultiSelectPicklistController_Test {
     @TestSetup public static void setup(){
        List<Account> accountList = DataFactory.createAccountTestRecords('Test acc', 5, '');
        if(accountList != null && accountList.size() > 0){
            List<Contract> contractList =  DataFactory.createContractTestRecords('Test contract', accountList [0].id, 5);
            
        }
        
    }
    
    static testMethod void getAvailablePicklistValues_Method(){
        MultiSelectPicklistController.getAvailablePicklistValues('Contract','Contract_Type__c');
    }
    
     static testMethod void savePicklistValue_Method(){
         List<Contract> contractList = [Select id From Contract Limit 5];
        MultiSelectPicklistController.savePicklistValue('Contract','Contract_Type__c',contractList[0].id,'ALL PRODUCTS' );
    }

    static testMethod void getCurrentPicklistValues_Method(){
         List<Contract> contractList = [Select id From Contract Limit 5];
        MultiSelectPicklistController.getCurrentPicklistValues('Contract','Contract_Type__c',contractList[0].id);
    }
}
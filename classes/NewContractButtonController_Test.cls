/**@@
    #CLASS NAME  :  NewContractButtonController_Test 
    #DESCRIPTION :  Test class for "NewContractButtonController" 
    #CREATEDDATE :  04-27-2020 (DD-MM-YYYY) 
@@**/

@IsTest
public class NewContractButtonController_Test {
    
    static testMethod void fetchRecordTypeValues_Method(){
        NewContractButtonController.fetchRecordTypeValues();
    }
    
    static testMethod void getRecTypeId_Method(){
        NewContractButtonController.getRecTypeId('Standard');
    }

}
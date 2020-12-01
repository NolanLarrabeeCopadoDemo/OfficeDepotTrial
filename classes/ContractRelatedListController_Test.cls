/**@@
    #CLASS NAME  :  ContractRelatedListController_Test 
    #DESCRIPTION :  Test class for "ContractRelatedListController" 
    #CREATEDDATE :  04-27-2020 (DD-MM-YYYY) 
@@**/

@IsTest
public class ContractRelatedListController_Test {
    @TestSetup public static void setup(){
        List<recordtype> prospectID = [Select id from recordtype where name='Prospect'];
        List<recordtype> custID = [Select id from recordtype where name='Customer'];
        //List<Account> accountUpdateList =  new List<Account>();
        List<Account> accountList = DataFactory.createAccountTestRecords('Test acc', 5, '');
        
        
        accountList[0].name = 'Grand Parent';
        accountList[0].RecordTypeId = custID[0].id;
        
        accountList[1].name = 'parent';
        accountList[1].RecordTypeId = custID[0].id;
        accountList[1].parentid = accountList[0].id;
        
        accountList[2].parentid = accountList[1].id;
        accountList[2].RecordTypeId = custID[0].id;
        
        accountList[3].parentid = accountList[2].id;
        accountList[3].RecordTypeId = prospectID[0].id;
        
        
        accountList[4].parentid = accountList[2].id;
        accountList[4].RecordTypeId = custID[0].id;
        
        update accountList;
        
        ///List<Account> childAccountList = DataFactory.createAccountTestRecords('Test acc', 1, accountList[0].id);
        if(accountList != null && accountList.size() > 0){
            List<Contract> contractList =  DataFactory.createContractTestRecords('Test contract', accountList[4].id, 5);
                        
            contractList[0].name= '';
            contractList[0].Contract_Status__c = 'Draft'; 
            contractList[0].accountId = accountList[2].id;
            
            contractList[1].name= '';
            contractList[1].Contract_Status__c = 'Draft'; 
            contractList[1].accountId = accountList[3].id;
            
            contractList[2].name= '';
            contractList[2].Contract_Status__c = 'Draft'; 
            contractList[2].accountId = accountList[3].id;
            
            update contractList;
        }
        
    }
    
    static testMethod void fetchContracts_Method(){
        List<Account> accountList = [Select id From Account  ORDER BY id Limit 10];
        List<Contract> contractList = [Select id From Contract ORDER BY id Limit 10];
        ContractRelatedListController.fetchContracts(accountList[0].id);
            ContractRelatedListController.fetchContracts(accountList[1].id);
        ContractRelatedListController.fetchContracts(accountList[2].id);
        ContractRelatedListController.fetchContracts(accountList[4].id);
    }

    static testMethod void deleteContractRecord_Method(){
         List<Account> accountList = [Select id From Account  ORDER BY id Limit 10];
         List<Contract> contractList = [Select id From Contract ORDER BY id Limit 10];
        ContractRelatedListController.deleteContractRecord(contractList[0].id);
    }
}
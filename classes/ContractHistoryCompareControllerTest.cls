/*************************************************************
*Name : ContractHistoryCompareControllerTest
*Created By : Sandesh Ganjare
*Created Date :
*Purpose : Test class for ContractHistoryCompareController class
*JIRA: NAIT-124929
****************************************************************/
@isTest
public with sharing class ContractHistoryCompareControllerTest {
    @TestSetup public static void setup()
    {
        Account a = new Account();
        a.Name='Test Account';
        INSERT a;
        
        Contract c = new Contract();
        c.Name='Test COntract';
        c.AccountId = a.id;
        INSERT c;
        
        List<ContractHistory__c> lstch = new List<ContractHistory__c>();
        ContractHistory__c ch = new ContractHistory__c(); 
        ch.most_favored_contract_language__c = 'Test';
        ch.Contract__c = c.id;
        lstch.add(ch);

        ContractHistory__c ch1 = new ContractHistory__c(); 
        ch1.most_favored_contract_language__c = 'Test1';
        ch1.Contract__c = c.id;
        lstch.add(ch1);

        ContractHistory__c ch2 = new ContractHistory__c(); 
        ch2.most_favored_contract_language__c = 'Test1';
        ch2.Contract__c = c.id;
        lstch.add(ch2);

        INSERT lstch;
    
    }

    static testMethod  void getContractHistoryList_Test (){       
        List<Contract> contractList = [Select id From Contract ORDER BY id Limit 1];
        Test.StartTest();
        List<ContractHistory__c> chlst = ContractHistoryCompareController.getContractHistoryList(String.valueOf(contractList[0].Id));
        Test.StopTest();

        System.assertEquals(true, chlst != null);  
    }

    static testMethod  void getContractFieldsData_Test (){       
        List<Contract> contractList = [Select id From Contract ORDER BY id Limit 1];
        Test.StartTest();
        Map<string, string> fieldmap = ContractHistoryCompareController.getContractFieldsData();
        Test.StopTest();

        System.assertEquals(true, fieldmap != null);  
    }

    static testMethod  void getContractHistoryCompareData_Test (){    
           
        List<String> str = new List<String>();
            str.add('most_favored_contract_language__c');
            str.add('x3rd_party_required_to_provide_a_securit__c');
            str.add('account_extension_name__c');
            str.add('account_name__c');
            str.add('account_org__c');
            String fields = JSON.serialize(str);
            system.debug('=>'+fields);
        List<Contract> contractList = [Select id From Contract ORDER BY id Limit 1];
        List<ContractHistory__c> ContractHistoryList = [SELECT Id, Name, LastModifiedDate, LastModifiedBy.Name FROM ContractHistory__c];
        Test.StartTest();
        List<ContractHistoryCompareController.ContractHistoryWrapper> chwlst = ContractHistoryCompareController.getContractHistoryCompareData(ContractHistoryList[0].Name,'current',String.valueOf(contractList[0].Id),true,fields);
        Test.StopTest();

        System.assertEquals(true, chwlst != null);  
    }
    static testMethod  void getContractHistoryCompareData_Test1 (){    
           
        List<String> str = new List<String>();
            str.add('most_favored_contract_language__c');
            str.add('x3rd_party_required_to_provide_a_securit__c');
            str.add('account_extension_name__c');
            str.add('account_name__c');
            str.add('account_org__c');
            String fields = JSON.serialize(str);
            //system.debug('=>'+fields);
        List<Contract> contractList = [Select id From Contract ORDER BY id Limit 1];
        List<ContractHistory__c> ContractHistoryList = [SELECT Id, Name, LastModifiedDate, LastModifiedBy.Name FROM ContractHistory__c WHERE Contract__c =: contractList[0].Id];
        system.debug('ContractHistoryList=>'+ContractHistoryList.size());
        Test.StartTest();
        List<ContractHistoryCompareController.ContractHistoryWrapper> chwlst = ContractHistoryCompareController.getContractHistoryCompareData(ContractHistoryList[0].Name,ContractHistoryList[1].Name,String.valueOf(contractList[0].Id),true,fields);
        Test.StopTest();

        System.assertEquals(true, chwlst != null);  
    }
}
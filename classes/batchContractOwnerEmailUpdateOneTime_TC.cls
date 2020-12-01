@IsTest
public class batchContractOwnerEmailUpdateOneTime_TC {
     @TestSetup static void setup(){
        List<Account> accountList = DataFactory.createAccountTestRecords('Test acc', 5, '');
        if(accountList != null && accountList.size() > 0){
            List<Contract> contractList =  DataFactory.createContractTestRecords('Test contract', accountList[0].id, 5);
            
        
        contractList[0].Contract_Owner__c = 'Anthony Falbo'; 
         contractList[1].Contract_Owner__c = 'Jean Davis'; 
         contractList[2].Contract_Owner__c = 'Denise DeFerrari'; 
         contractList[3].Contract_Owner__c = 'Pricing Compliance Queue';
            update contractList;
        }
        
    }
    static testMethod void SpringCMContract2_Method(){
        Test.startTest();
        batchContractOwnerEmailUpdateOneTime uca = new batchContractOwnerEmailUpdateOneTime();
        Id batchId = Database.executeBatch(uca);
        Test.stopTest();
        
    }

}
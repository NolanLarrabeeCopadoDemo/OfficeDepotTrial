@Istest
public class DataFactory_Test {
    
     public static testmethod void dataFactoryTestMethod(){
        List<User> listUser = DataFactory.createUserTestRecords('Test User',2);
        List<Account> accList = DataFactory.createAccountTestRecords('Test acc', 5, '');
        List<Contract> conList = DataFactory.createContractTestRecords('Test con',accList[0].Id, 5);
        List<Contract_Pricing_Terms__c> cptList = DataFactory.createContractPriceTermsTestRecords('Test CPT',conList[0].Id, 5);
     }

}
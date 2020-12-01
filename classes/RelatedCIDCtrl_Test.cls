/**
* @author Sandesh Ganjare, sandesh.ganjare@officedepot.com
* @date 08/09/2020
*
* 
* @description This class fetch all the records of Customer Intelligent Document object related to Accounts in hierarchy.
*              
*               Test class => RelatedCustomerIntelligentDocumentCtrl class
* JIRA: NAIT-137444: 02944812 - Ability to Input/Maintain Fact Sheet Fields in SFDC
*/
@isTest
public class RelatedCIDCtrl_Test {
    @testSetup static void setup() {
        List<Account> TestAccountGP =  DataFactory.createAccountTestRecords('Account',1,'');
       
        List<Account> TestAccount =  DataFactory.createAccountTestRecords('Test Account',1,TestAccountGP[0].Id);
        //TestAccount[0].Parentid = TestAccountGP[0].Id;
        //UPDATE TestAccount;

        Fact_Sheet__c fs = new Fact_Sheet__c();
        fs.Can_Customer_Care_Maintain_Account__c='No';
        fs.Can_Restrictions_Be_Overridden_Without_A__c='No';
        fs.Custmustclearcreditpriortorebill__c='No';
        fs.Account__c= TestAccount[0].Id;
        fs.Additional_Account_Handling_Comments__c='Test Test';
        INSERT fs;
     }
 
     @IsTest
     static void getRelatedCIDTest(){
        List<Fact_Sheet__c> customerIntelligentDocumentList = new List<Fact_Sheet__c>();
        List<Account> accountList = [SELECT id,Parentid FROM Account Where Parentid!=null LIMIT 1 ];
        Test.StartTest();
            customerIntelligentDocumentList = RelatedCustomerIntelligentDocumentCtrl.getRelatedCID(String.valueOf(accountList[0].Id));
        Test.StopTest();
        System.assertEquals(true,customerIntelligentDocumentList.size()>0);
     }
}
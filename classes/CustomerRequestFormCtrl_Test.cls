@isTest//(SeeAllData=false)
public class CustomerRequestFormCtrl_Test {
    @TestSetup
    static void makeData(){
        List<User> userList = DataFactory.createUserTestRecords('Test', 1);

        Recordtype rcd =  [select id from recordtype where name = 'Customer'];
        List<Account> accountList = DataFactory.createAccountTestRecords('Test acc', 1, '');
        accountList[0].Oracle_Party_Id__c = '12345678'; 
        accountList[0].AOPS_Cust_Id__c = '12345678';          
        accountList[0].OwnerId=userList[0].id;
        accountList[0].recordtypeid = rcd.id;
        accountList[0].Industry_OD_SIC_Rep__c = 'Accounting';
        accountList[0].Org_WCW_Count_DB__c =11112234;
        accountList[0].Org_WCW_Count_Rep__c = 55 ;
        accountList[0].ZIP__C = '111111';
        accountList[0].AccountNumber ='223112';
        //accountList[0].Sales_PersonID__c = salesPerson.id; //Sales person Id for the Salesforce USer

        UPDATE accountList;

        //Group g1 = new Group(Name='TAM Solutions',DeveloperNAME = 'TAM_Solutions', type='Queue');
        //insert g1;

       
    }

    @isTest
    private static void coverage_getDataValidate() {
        Boolean isTicketCreated = false;
        //Group testGroup = [select ID from Group where Name='TAM Solutions' LIMIT 1];
        //QueuesObject testQueue = new QueueSObject(QueueID = testGroup.id, SObjectType = 'Case');
        //insert testQueue;
        List<Account> lstAccount = [select id,AOPS_Cust_Id__c from Account where AOPS_Cust_Id__c='12345678' Limit 1];
        Test.startTest();
            isTicketCreated = CustomerRequestFormCtrl.createCustomerRequest('Testnewrequest', lstAccount[0].AOPS_Cust_Id__c, 'VGVzdCBkYXRh', 'TestfileName');
        Test.stopTest();

        System.assertEquals(true, isTicketCreated);
    }
}
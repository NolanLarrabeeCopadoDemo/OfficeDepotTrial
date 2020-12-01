@IsTest
public without sharing class DMLDisplay_Test {
    
    @TestSetup
    static void makeData(){

        Schema.RecordTypeInfo prospect_recordtype = MyUtils.getRecordTypeInfo('Account', 'Prospect');
        Account my_account = new Account(
            Name='Test_Account',
            RecordTypeId = prospect_recordtype.getRecordTypeId()
        );

        insert my_account;

        Sales_Person__c my_sales_person = new Sales_Person__c(
            IsActive__c = true,
            Primary__c = true,
            Name = 'TSP100',
            User__c = UserInfo.getUserId()
        );
        insert my_sales_person;

        DML__c my_dml = new DML__c(
            Effective_Start_Date__c = Date.today() - 1,
            Effective_End_Date__c = Date.today() + 10,
            Decision_Maker_Rep__c = my_sales_person.Id
        );
        insert my_dml;

        DML_Relation__c my_relation = new DML_Relation__c(
            DML__c = my_dml.Id,
            Account__c = my_account.Id,
            Effective_Start_Date__c = Date.today() - 1,
            Effective_End_Date__c = Date.today() + 10
        );

        insert my_relation;
    }

    @isTest
    public static void test_valid_run(){
        Test.startTest();
        Account my_account = [SELECT Id FROM Account LIMIT 1];
        System.debug(LoggingLevel.INFO, my_account);
        DML__c my_dml = [SELECT Id FROM DML__c LIMIT 1];
        System.debug(LoggingLevel.INFO, my_account);
        DML_Relation__c my_dml_relation = [SELECT Id FROM DML_Relation__c WHERE IsActive__c=true LIMIT 1];
        System.debug(LoggingLevel.INFO, my_account);
        
        System.assertEquals(my_dml.Id, DmlDisplay.getDmlIdFromAccount(my_account.Id)); 

        Test.stopTest();
    }

    @isTest
    public static void test_exception(){
        Test.startTest();
        Account my_account = [SELECT Id FROM Account LIMIT 1];
        DML__c my_dml = [SELECT Id FROM DML__c LIMIT 1];
        DML_Relation__c my_dml_relation = [SELECT Id FROM DML_Relation__c WHERE IsActive__c=true LIMIT 1];
        DELETE my_dml_relation;

        try{
            DmlDisplay.getDmlIdFromAccount(my_account.Id);
        } catch (Exception e){
            System.debug(LoggingLevel.INFO, 'We caught it.');
        }
        Test.stopTest();
    }
}
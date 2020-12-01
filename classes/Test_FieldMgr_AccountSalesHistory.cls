/**************************************************************
*Name           : Test_FieldMgr_AccountSalesHistory 
*Created By     : Dheeraj(Appirio Off)
*Created Date   : 16th Feb,2012
*Purpose        : To test FieldMgr_AccountSalesHistoryExtension
********************************************************************/
@isTest
private class Test_FieldMgr_AccountSalesHistory {

    @isTest 
    private static void testAccountSalesHistoryForManager() { 
        Profile profileObj = [select id from profile where name=:Label.GT_Field_Sales_Label];
        String profId = profileObj.id;
        UserRole ContractDivisionRoleId = [SELECT Id from UserRole WHERE Name = 'Contract Division' limit 1];
        User userWithContractDivisionRole = [SELECT Id, Name FROM User WHERE UserRoleId = :ContractDivisionRoleId.Id AND isActive = true limit 1];
        System.runAs(userWithContractDivisionRole){
            Account account =  Test_Utils.CreateAccountForSalesHistory();
            FieldMgr_AccountSalesHistoryExtension extension = new FieldMgr_AccountSalesHistoryExtension();
            Test.startTest(); 
            List<AggregateResult> aggregateResult =  extension.getAggregateResult();
            
            extension.refresh();
            /*System.assertEquals((Double)aggregateResult[0].get('Year_Goal__c'), 10);
            System.assertEquals((Double)aggregateResult[0].get('YTD_Sales_LY__c'), 15);
            System.assertEquals((Double)aggregateResult[0].get('MTD_Sales_TY__c'), 2);
            System.assertEquals((Double)aggregateResult[0].get('Month_Goal__c'), 05);
            System.assertEquals((Double)aggregateResult[0].get('ADS_Last_Qtr__c'), 10);
            System.assertEquals((Double)aggregateResult[0].get('Quarter_Goal__c'), 8);
            System.assertEquals((Double)aggregateResult[0].get('ADS_Current_Month__c'), 6);*/
            
            
        }
        userWithContractDivisionRole.Profileid = profId;
        update userWithContractDivisionRole;
        System.runAs(userWithContractDivisionRole){
            Account account =  Test_Utils.CreateAccountForSalesHistory();
            FieldMgr_AccountSalesHistoryExtension extension = new FieldMgr_AccountSalesHistoryExtension();
           
            List<AggregateResult> aggregateResult =  extension.getAggregateResult();
            
            extension.refresh();
            /*System.assertEquals((Double)aggregateResult[0].get('Year_Goal__c'), 10);
            System.assertEquals((Double)aggregateResult[0].get('YTD_Sales_LY__c'), 15);
            System.assertEquals((Double)aggregateResult[0].get('MTD_Sales_TY__c'), 2);
            System.assertEquals((Double)aggregateResult[0].get('Month_Goal__c'), 05);
            System.assertEquals((Double)aggregateResult[0].get('ADS_Last_Qtr__c'), 10);
            System.assertEquals((Double)aggregateResult[0].get('Quarter_Goal__c'), 8);
            System.assertEquals((Double)aggregateResult[0].get('ADS_Current_Month__c'), 6);*/
            
            Test.stopTest();
        }
    }
}
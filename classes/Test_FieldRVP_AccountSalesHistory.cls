/**************************************************************
*Name           : Test_FieldRVP_AccountSalesHistory 
********************************************************************/
@isTest
private class Test_FieldRVP_AccountSalesHistory {

    @isTest 
    private static void testAccountSalesHistoryForManager() { 
        
        //User UserRegion = [SELECT Id from User where isactive= true AND Region__c = 'Northeast' limit 1];
        
        Profile profilealias = [SELECT Id FROM profile WHERE name='System Administrator'];
        User UserRegion= new User(alias = 'test123 ', email='proxy@officedepot.com',emailencodingkey='UTF-8', lastname='test123',languagelocalekey='en_US',localesidkey='en_US', profileid = profilealias.Id,timezonesidkey='America/Los_Angeles',username='proxy@proxy456.com',isactive= true,region__c = 'Northeast');
        insert UserRegion;
        
        
        UserRole ContractDivisionRoleId1 = [SELECT Id from UserRole WHERE Name = 'Contract Division' limit 1];
        //User userWithContractDivisionRole = [SELECT Id, Name FROM User WHERE UserRoleId = :ContractDivisionRoleId.Id AND isActive = true limit 1];
        Set<Id> stId = new Set<Id>();
        stId.add(ContractDivisionRoleId1.Id);
        System.runAs(UserRegion){
          Account account =  Test_Utils.CreateAccountForSalesHistory();
          FieldRVP_AccountSalesHistoryExtension extension = new FieldRVP_AccountSalesHistoryExtension();
          Test.startTest(); 
          List<AggregateResult> aggregateResult =  extension.getAggregateResult();
          Set<id> st =extension.getAllSubOrdinateRoleID(stId) ;
          extension.refresh();
     //     System.assertEquals((Double)aggregateResult[0].get('Year_Goal__c'), 10);
     //     System.assertEquals((Double)aggregateResult[0].get('YTD_Sales_LY__c'), 15);
      //    System.assertEquals((Double)aggregateResult[0].get('MTD_Sales_TY__c'), 2);
     //     System.assertEquals((Double)aggregateResult[0].get('Month_Goal__c'), 05);
     //     System.assertEquals((Double)aggregateResult[0].get('ADS_Last_Qtr__c'), 10);
    //      System.assertEquals((Double)aggregateResult[0].get('Quarter_Goal__c'), 8);
     //     System.assertEquals((Double)aggregateResult[0].get('ADS_Current_Month__c'), 6);
          
          Test.stopTest();
        }
    }
}
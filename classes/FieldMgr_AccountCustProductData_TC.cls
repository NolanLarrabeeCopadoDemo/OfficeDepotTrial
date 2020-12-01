/**************************************************************
*Name           : Test_FieldMgr_AccountCustProductData 
*Created By     : Dheeraj(Appirio Off)
*Created Date   : 16th Feb,2012
*Purpose        : To test FieldMgr_AccountProductDataExtension
********************************************************************/
@isTest
private class FieldMgr_AccountCustProductData_TC {
    @isTest 
    private static void testAcctCustProductDataExtension() { 
        
        UserRole ContractDivisionRoleId = [SELECT Id from UserRole WHERE Name = 'Contract Division' limit 1];
        User userWithContractDivisionRole = [SELECT Id, Name FROM User WHERE UserRoleId = :ContractDivisionRoleId.Id AND isActive = true limit 1];        
        System.runAs(userWithContractDivisionRole){
            Account account =  Test_Utils.CreateAccountForProductData();    
            Account account1 =  Test_Utils.CreateAccountForProductData();             
       
            FieldMgr_AccountCustProductDataExtension extension = new FieldMgr_AccountCustProductDataExtension();
       
            Test.startTest();
            extension.refresh(); 
            List<AggregateResult> aggregateResult =  extension.getAggregateResult();
           
            // Test that aggregate result is calculated for manager 
            //System.assertEquals((Double)aggregateResult[0].get('Office_Essentials_Pot__c'), 40);
         //   System.assertEquals((Double)aggregateResult[0].get('Total_TY_Sales_to_Date__c'), 970);
         //   System.assertEquals((Double)aggregateResult[0].get('Paper_TY'), 10);
        //    System.assertEquals((Double)aggregateResult[0].get('Filing_Binding_TY__c'), 40);
           // System.assertEquals((Double)aggregateResult[0].get('Total_Potential_to_Date'), 420);
         //   System.assertEquals((Double)aggregateResult[0].get('Tech_TY__c'), 600);
            //System.assertEquals((Double)aggregateResult[0].get('Paper_Pot__c'), 20);
         //   System.assertEquals((Double)aggregateResult[0].get('Filing_Binding_LY__c'), 40);
        //    System.assertEquals((Double)aggregateResult[0].get('Paper_LY'), 20);            
                    
            Test.stopTest();
        }
  }   
}
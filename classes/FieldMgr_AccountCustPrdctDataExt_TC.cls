/**************************************************************
*Name           : Test_FieldMgr_AccountCustProductData 
*Created By     : Dheeraj(Appirio Off)
*Created Date   : 16th Feb,2012
*Purpose        : To test FieldMgr_AccountProductDataExtension
********************************************************************/
@isTest
private class FieldMgr_AccountCustPrdctDataExt_TC {
    @isTest 
    private static void testAcctCustProductDataExtension() { 
        
        UserRole ContractDivisionRoleId = [SELECT Id from UserRole WHERE Name = 'Contract Division' limit 1];
        User userWithContractDivisionRole = [SELECT Id, Name FROM User WHERE UserRoleId = :ContractDivisionRoleId.Id AND isActive = true limit 1];        
        System.runAs(userWithContractDivisionRole){
            Account account =  Test_Utils.CreateAccountForProductData();    
            Account account1 =  Test_Utils.CreateAccountForProductData();             
       
            FieldMgr_AccountCustPrdctDataExt extension = new FieldMgr_AccountCustPrdctDataExt();
       
            Test.startTest();
            extension.refresh(); 
            List<AggregateResult> aggregateResult =  extension.getAggregateResult();
            List<AggregateResult> agg = extension.getAllLAccountsForCurrentUser();
           
           
            Test.stopTest();
        }
  }   
}
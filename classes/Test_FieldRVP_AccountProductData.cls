/**************************************************************
*Name           : Test_FieldRVP_AccountProductData 

********************************************************************/
@isTest
private class Test_FieldRVP_AccountProductData {
    @isTest 
    private static void testAccountProductDataExtension() {
    
     
             
        //List<User> Userwithregion_list = [SELECT Id, Name from User WHERE isactive= true AND region__c = 'Northeast' limit 1];
        Profile profilealias = [SELECT Id FROM profile WHERE name='System Administrator'];
        User Userwithregion= new User(alias = 'test123 ', email='proxy@officedepot.com',emailencodingkey='UTF-8', lastname='test123',languagelocalekey='en_US',localesidkey='en_US', profileid = profilealias.Id,timezonesidkey='America/Los_Angeles',username='proxy@proxy456.com',isactive= true,region__c = 'Northeast');
        insert Userwithregion;
            
      UserRole ContractDivisionRoleId = [SELECT Id from UserRole WHERE Name = 'Contract Division' limit 1];
//        User userWithContractDivisionRole = [SELECT Id, Name FROM User WHERE UserRoleId = :ContractDivisionRoleId.Id AND isActive = true limit 1];        
            Set<Id> stId = new Set<Id>();
            stId.add(ContractDivisionRoleId.Id);
            
            System.runAs(Userwithregion){
            Account account =  Test_Utils.CreateAccountForProductData();    
            Account account1 =  Test_Utils.CreateAccountForProductData();             
       
            FieldRVP_AccountProductDataExtension extension = new FieldRVP_AccountProductDataExtension();
       
            Test.startTest();
            extension.refresh(); 
            List<AggregateResult> aggregateResult =  extension.getAggregateResult();
            Set<id> st =extension.getAllSubOrdinateRoleID(stId) ;
            // Test that aggregate result is calculated for manager 
            //System.assertEquals((Double)aggregateResult[0].get('Office_Essentials_Pot__c'), 40);
         //   System.assertEquals((Double)aggregateResult[0].get('Total_TY_Sales_to_Date__c'), 970);
         //   System.assertEquals((Double)aggregateResult[0].get('Paper_TY'), 10);
         //   System.assertEquals((Double)aggregateResult[0].get('Filing_Binding_TY__c'), 40);
           // System.assertEquals((Double)aggregateResult[0].get('Total_Potential_to_Date'), 420);
        //    System.assertEquals((Double)aggregateResult[0].get('Tech_TY__c'), 600);
            //System.assertEquals((Double)aggregateResult[0].get('Paper_Pot__c'), 20);
        //    System.assertEquals((Double)aggregateResult[0].get('Filing_Binding_LY__c'), 40);
        //    System.assertEquals((Double)aggregateResult[0].get('Paper_LY'), 20);            
                    
            Test.stopTest();
        }
  }   
}
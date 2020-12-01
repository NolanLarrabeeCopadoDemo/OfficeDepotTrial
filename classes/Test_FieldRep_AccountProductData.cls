/**************************************************************
*Name           : Test_FieldRep_AccountProductData 
*Created By     : Dheeraj(Appirio Off)
*Created Date   : 16th Feb,2012
*Purpose        : To test FieldRep_AccountProductDataExtension
********************************************************************/
@isTest
private class Test_FieldRep_AccountProductData {
    @isTest 
    private static void testAccountProductDataExtension() { 
        
    Account account;
    
    UserRole ContractDivisionRoleId = [SELECT Id from UserRole WHERE Name = 'Contract Division' limit 1];
    User userWithContractDivisionRole = [SELECT Id, Name FROM User WHERE UserRoleId = :ContractDivisionRoleId.Id AND isActive = true limit 1];   
    UserRole EmergingChannelRoleId = [SELECT Id from UserRole WHERE Name like '%Emerging%' limit 1];        
    Profile p4 = [SELECT Id FROM profile WHERE name='System Administrator'];   
    User u1 = new User(alias = 'tes170', email='proxy7@proxy456.officedepot.com',OD_Employee_ID__c='125525',emailencodingkey='UTF-8', lastname='test123',languagelocalekey='en_US',localesidkey='en_US', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='125525@proxy4056.com',isactive=true);
    u1.UserRoleId = ContractDivisionRoleId.id;
    insert u1; 
        
    User u2 = new User(alias = 'tes100', email='proxy7@proxy456.officedepot.com',OD_Employee_ID__c='124300',emailencodingkey='UTF-8', lastname='test123',languagelocalekey='en_US',localesidkey='en_US', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='124300@proxy4056.com',isactive=true);
    u2.UserRoleId = EmergingChannelRoleId.id;
    insert u2;
    
    System.runAs(u1){
        account =  Test_Utils.CreateAccountForProductData();                     
    }
       
    FieldRep_AccountProductDataExtension extension = new FieldRep_AccountProductDataExtension();    
    
    
    User userWithEmergingChannelRole = [SELECT Id, Name FROM User WHERE UserRoleId = :EmergingChannelRoleId.Id AND isActive = true limit 1];       
    System.runAs(u2) {
        Account accountForEmergingChannelRole = Test_Utils.CreateAccountForProductData();
    }
    System.runAs(u1){
        Test.startTest();
        List<AggregateResult> aggregateResultList = extension.getAllLAccountsForCurrentUser();    
        
        // Test that aggregate results are only for single user
        //System.assertEquals((Double)aggregateResultList[0].get('Office_Essentials_Pot__c'), 20);
        //System.assertEquals((Double)aggregateResultList[0].get('Total_TY_Sales_to_Date__c'), 505);
        //System.assertEquals((Double)aggregateResultList[0].get('Paper_TY'), 5);
        //System.assertEquals((Double)aggregateResultList[0].get('Filing_Binding_TY__c'), 20);
        //System.assertEquals((Double)aggregateResultList[0].get('Total_Potential_to_Date'), 210);
        //System.assertEquals((Double)aggregateResultList[0].get('Tech_TY__c'), 300);
        //System.assertEquals((Double)aggregateResultList[0].get('Paper_Pot__c'), 10);
        //System.assertEquals((Double)aggregateResultList[0].get('Filing_Binding_LY__c'), 20);
        //System.assertEquals((Double)aggregateResultList[0].get('Paper_LY'), 10);
        //System.assertEquals((Double)aggregateResultList[0].get('Total_Sales_Diff__c'), 59);
        Test.stopTest();
    }
     
  }  
}
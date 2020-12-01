/*******************************************************************
*Name           : Test_OverlayRep_AccountProductData 
*Created By     : Dheeraj(Appirio Off)
*Created Date   : 16th March, 2012
*Purpose        : To test OverlayRep_AccountProductDataExtension
********************************************************************/
@isTest
public with sharing class Test_OverlayRep_AccountProductData {  
    @isTest 
    private static void testAccountProductDataExtension() {    
    
        // Make site account data and add account to accountTeamMember for user1
        User testUser1 = Test_Utils.createTestUser('User1', '12345');          
        System.runAs(testUser1) {
            Account account = Test_Utils.CreateAccountForProductData();
            AccountTeamMember accountTeamMember = Test_Utils.createAccountTeamMember(account, testUser1);
        }
                
        Account account =  Test_Utils.CreateAccountForProductData();
        AccountTeamMember accountTeamMember = Test_Utils.createAccountTeamMemberForOverlays(account, Util.getCurrentDashboardUserId(Util.getCurrentPageName()));
        OverlayRep_AccountProductDataExtension extension = new OverlayRep_AccountProductDataExtension();
        
        Test.startTest();
        List<AggregateResult> aggregateResultList = extension.getAllLAccountsForCurrentUser();    
        
        // Test that aggregate results are only for user who is logged in
        System.assertEquals((Double)aggregateResultList[0].get('Office_Essentials_Pot__c'), 20);
        System.assertEquals((Double)aggregateResultList[0].get('Total_TY_Sales_to_Date__c'), 505);
        System.assertEquals((Double)aggregateResultList[0].get('Paper_TY'), 5);
        System.assertEquals((Double)aggregateResultList[0].get('Filing_Binding_TY__c'), 20);
        System.assertEquals((Double)aggregateResultList[0].get('Total_Potential_to_Date'), 210);
        System.assertEquals((Double)aggregateResultList[0].get('Tech_TY__c'), 300);
        System.assertEquals((Double)aggregateResultList[0].get('Paper_Pot__c'), 10);
        System.assertEquals((Double)aggregateResultList[0].get('Filing_Binding_LY__c'), 20);
        System.assertEquals((Double)aggregateResultList[0].get('Paper_LY'), 10);
    
        Test.stopTest();
    }
     
   
    

}
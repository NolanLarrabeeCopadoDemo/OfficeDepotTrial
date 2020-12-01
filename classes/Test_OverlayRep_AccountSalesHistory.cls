/*******************************************************************
*Name           : Test_OverlayRep_AccountSalesHistory 
*Created By     : Dheeraj(Appirio Off)
*Created Date   : 16th March, 2012
*Purpose        : To test OverlayRep_AccountSalesHistoryExtension
********************************************************************/

@isTest 
public with sharing class Test_OverlayRep_AccountSalesHistory {
    @isTest
    private static void testAccountSalesHistoryForManager() {
    	// Make site account data and add account to accountTeamMember for user1
        User testUser1 = Test_Utils.createTestUser('User1', '12345');         
        System.runAs(testUser1){
            Account account =  Test_Utils.CreateAccountForSalesHistory();            
            AccountTeamMember accountTeamMember = Test_Utils.createAccountTeamMember(account, testUser1);             
        } 
    	
        Account account = Test_Utils.CreateAccountForSalesHistory();        
        AccountTeamMember accountTeamMember = Test_Utils.createAccountTeamMemberForOverlays(account, Util.getCurrentDashboardUserId(Util.getCurrentPageName()));
        OverlayRep_AccountSalesHistoryExtension extension = new OverlayRep_AccountSalesHistoryExtension();
        List<AggregateResult> accountList = Test_Utils.getAggregateSiteAccountList(UserInfo.getUserId());
            
        Test.startTest();
        OverlayRep_AccountSalesHistoryExtension.SiteAccounts siteAccount = extension.getAllSiteAccountsForCurrentUser();
        System.assertEquals(siteAccount.MTD_Sales_TY_IMU2, ((Double)accountList[0].get('MTD_Sales_TY_IMU2__c')/((Double)accountList[0].get('MTD_Sales_TY__c')) ));
        System.assertEquals(siteAccount.MTD_Sales_LY_IMU2, ((Double)accountList[0].get('MTD_Sales_LY_IMU2__c')/((Double)accountList[0].get('MTD_Sales_LY__c')) ));        
        System.assertEquals(siteAccount.Monthly_LY_IMU_Per, ((Double)accountList[0].get('Monthly_LY_IMU_Per__c')/((Double)accountList[0].get('Monthly_LY__c')) ));
        System.assertEquals(siteAccount.QTD_Sales_TY_IMU2, ((Double)accountList[0].get('QTD_Sales_TY_IMU2__c')/((Double)accountList[0].get('QTD_Sales_TY__c')) ));          
        Test.stopTest();         
    }
}
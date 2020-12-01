/**************************************************************
*Name           : Test_FieldRep_AccountSalesHistory 
*Created By     : Dheeraj(Appirio Off)
*Created Date   : 16th Feb,2012
*Purpose        : To test FieldRep_AccountSalesHistory
********************************************************************/
@isTest
private class FieldRep_AcctCustSalesHistory_TC {
    @isTest 
    private static void testAcctCustSalesHistoryForManager() {
        
        UserRole ContractDivisionRoleId = [SELECT Id from UserRole WHERE Name = 'Contract Division' limit 1];
        //User userWithContractDivisionRole = [SELECT Id, Name FROM User WHERE UserRoleId = :ContractDivisionRoleId.Id AND isActive = true limit 1];        
        UserRole EmergingChannelRoleId = [SELECT Id from UserRole WHERE Name like '%Emerging%' limit 1];        
        Profile p4 = [SELECT Id FROM profile WHERE name='System Administrator'];   
        User u1 = new User(alias = 'tes120', email='proxy7@proxy456.officedepot.com',OD_Employee_ID__c='124425',emailencodingkey='UTF-8', lastname='test123',languagelocalekey='en_US',localesidkey='en_US', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='124125@proxy4056.com',isactive=true);
        u1.UserRoleId = ContractDivisionRoleId.id;
        insert u1; 
        
        User u2 = new User(alias = 'tes180', email='proxy7@proxy456.officedepot.com',OD_Employee_ID__c='124400',emailencodingkey='UTF-8', lastname='test123',languagelocalekey='en_US',localesidkey='en_US', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='124400@proxy4056.com',isactive=true);
        u2.UserRoleId = EmergingChannelRoleId.id;
        insert u2;
        //System.runAs(userWithContractDivisionRole){
        System.runAs(u1){
            Account account =  Test_Utils.CreateAccountForSalesHistory();               
        } 
        
        //User userWithEmergingChannelRole = [SELECT Id, Name FROM User WHERE UserRoleId = :EmergingChannelRoleId.Id AND isActive = true limit 1];        
        System.runAs(u2) {
            Account accountForEmergingChannelRole = Test_Utils.CreateAccountForSalesHistory();
        }        
        Test.startTest();
        System.runAs(u1){ 
            FieldRep_AcctCustSalesHistoryExtension extension = new FieldRep_AcctCustSalesHistoryExtension();
            List<AggregateResult> accountList = Test_Utils.getAggregateSiteAccountList(UserInfo.getUserId());
            
            FieldRep_AcctCustSalesHistoryExtension.SiteAccounts siteAccount = extension.getAllSiteAccountsForCurrentUser();
         //   System.assertEquals(siteAccount.MTD_Sales_TY_IMU2, ((Double)accountList[0].get('MTD_Sales_TY_IMU2__c')/((Double)accountList[0].get('MTD_Sales_TY__c')) ));
        //    System.assertEquals(siteAccount.MTD_Sales_LY_IMU2, ((Double)accountList[0].get('MTD_Sales_LY_IMU2__c')/((Double)accountList[0].get('MTD_Sales_LY__c')) ));        
        //    System.assertEquals(siteAccount.Monthly_LY_IMU_Per, ((Double)accountList[0].get('Monthly_LY_IMU_Per__c')/((Double)accountList[0].get('Monthly_LY__c')) ));
        //    System.assertEquals(siteAccount.QTD_Sales_TY_IMU2, ((Double)accountList[0].get('QTD_Sales_TY_IMU2__c')/((Double)accountList[0].get('QTD_Sales_TY__c')) ));
            //Test.stopTest();
        }
        Test.stopTest();         
    }    
   
}
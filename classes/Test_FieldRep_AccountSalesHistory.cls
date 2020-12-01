/**************************************************************
*Name           : Test_FieldRep_AccountSalesHistory 
*Created By     : Dheeraj(Appirio Off)
*Created Date   : 16th Feb,2012
*Purpose        : To test FieldRep_AccountSalesHistory
********************************************************************/
@isTest
private class Test_FieldRep_AccountSalesHistory {
    @isTest 
    private static void testAccountSalesHistoryForManager() {
        
        UserRole ContractDivisionRoleId = [SELECT Id from UserRole WHERE Name = 'Contract Division' limit 1];
        //User userWithContractDivisionRole = [SELECT Id, Name FROM User WHERE UserRoleId = :ContractDivisionRoleId.Id AND isActive = true limit 1];        
        UserRole EmergingChannelRoleId = [SELECT Id from UserRole WHERE Name like '%Emerging%' limit 1];        
        Profile p4 = [SELECT Id FROM profile WHERE name='System Administrator'];   
        User u1 = new User(alias = 'tes171', email='proxy7@proxy456.officedepot.com',OD_Employee_ID__c='171525',emailencodingkey='UTF-8', lastname='test123',languagelocalekey='en_US',localesidkey='en_US', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='171525@proxy4056.com',isactive=true);
        u1.UserRoleId = ContractDivisionRoleId.id;
        insert u1; 
            
        User u2 = new User(alias = 'tes101', email='proxy7@proxy456.officedepot.com',OD_Employee_ID__c='124311',emailencodingkey='UTF-8', lastname='test123',languagelocalekey='en_US',localesidkey='en_US', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='124311@proxy4056.com',isactive=true);
        u2.UserRoleId = EmergingChannelRoleId.id;
        insert u2;
        
        System.runAs(u1){
            Account account =  Test_Utils.CreateAccountForSalesHistory();               
        } 
        
        
        //User userWithEmergingChannelRole = [SELECT Id, Name FROM User WHERE UserRoleId = :EmergingChannelRoleId.Id AND isActive = true limit 1];        
        System.runAs(u1) {
            Account accountForEmergingChannelRole = Test_Utils.CreateAccountForSalesHistory();
        }        
        Test.startTest();
        System.runAs(u1){ 
            FieldRep_AccountSalesHistoryExtension extension = new FieldRep_AccountSalesHistoryExtension();
            List<AggregateResult> accountList = Test_Utils.getAggregateSiteAccountList(UserInfo.getUserId());
            
            FieldRep_AccountSalesHistoryExtension.SiteAccounts siteAccount = extension.getAllSiteAccountsForCurrentUser();
            System.assertEquals(siteAccount.MTD_Sales_TY_IMU2, ((Double)accountList[0].get('MTD_Sales_TY_IMU2__c')/((Double)accountList[0].get('MTD_Sales_TY__c')) ));
            System.assertEquals(siteAccount.MTD_Sales_LY_IMU2, ((Double)accountList[0].get('MTD_Sales_LY_IMU2__c')/((Double)accountList[0].get('MTD_Sales_LY__c')) ));        
            System.assertEquals(siteAccount.Monthly_LY_IMU_Per, ((Double)accountList[0].get('Monthly_LY_IMU_Per__c')/((Double)accountList[0].get('Monthly_LY__c')) ));
            System.assertEquals(siteAccount.QTD_Sales_TY_IMU2, ((Double)accountList[0].get('QTD_Sales_TY_IMU2__c')/((Double)accountList[0].get('QTD_Sales_TY__c')) ));
            //Test.stopTest();
        }
        Test.stopTest();         
    }    
   
}
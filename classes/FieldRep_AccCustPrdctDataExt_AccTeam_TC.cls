/*************************************
Name : FieldRep_AccCustPrdctDataExt_AccTeam_TC
Description : This class is used to access the methods of FieldRep_AccountCustPrdctDataExt_AccTeam class
Created By : Abhinav
Created Date : Sept 15,2015
*************************************/
@isTest
private class FieldRep_AccCustPrdctDataExt_AccTeam_TC {
    static testMethod void myUnitTest() {
        // implement unit test();
        Test.startTest();
        
        Profile sa = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        //LSLEVIN 2.10.16 S-376887 Updated below lines employee id to include OD
        User u1 = new User(alias = 'test123 ', email = 'proxy@proxy456.officedepot.com', OD_Employee_ID__c = 'yyxxOD123456', emailencodingkey = 'UTF-8', lastname = 'test123', languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = sa.Id, timezonesidkey = 'America/Los_Angeles', username = 'proxy@proxy456.com', isactive = true);
        insert u1;
        system.runAs(u1){
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.BillingStreet = '1040 N 326 W';
        acc.billingcity = 'Orem';
        acc.BillingState = 'UT';
        acc.Billingcountry = 'USA';
        acc.Oracle_Party_Id__c = '123456';
        acc.AOPS_Cust_Id__c = '123456';
        acc.AOPS_Seq_ID__c = '123456';
        acc.OwnerID = u1.id;
        insert acc;
        
        AccountteamMember atm = new AccountteamMember();
        atm.AccountId = acc.Id;
        atm.UserId = u1.Id;
        insert atm;
        
        FieldRep_AccountCustPrdctDataExt_AccTeam obj = new FieldRep_AccountCustPrdctDataExt_AccTeam();
        
        Double imu = obj.calculate_imu_per(1000,1000);
        System.assertEquals(1, imu);
        Double diff = obj.calculate_diff_per (5000,1000);
        System.assertEquals(4000, diff);
        
        FieldRep_AccountCustPrdctDataExt_AccTeam.SiteAccounts obj_sa = new FieldRep_AccountCustPrdctDataExt_AccTeam.SiteAccounts();
        Test.stopTest();
    }
    }
}
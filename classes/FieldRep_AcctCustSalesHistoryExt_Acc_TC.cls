/**
 * Created by Najma Ateeq for Story #S-331356
 */
@isTest
private class FieldRep_AcctCustSalesHistoryExt_Acc_TC {

    static testMethod void myUnitTest() {
       createTestData();
       FieldRep_AcctCustSalesHistoryExt_AccTeam obj = new FieldRep_AcctCustSalesHistoryExt_AccTeam();
      // obj.RefreshAccounts();
    }
    static void createTestData(){
    	Map<String,Schema.RecordTypeInfo> AccRecType = Schema.SObjectType.Account.getRecordTypeInfosByName();
    	 Account acc1 = new Account ();
        acc1.name = 'SUN Test Account 1';
        acc1.BillingStreet = '1040 N 326 W';
        acc1.billingcity = 'Orem';
        acc1.BillingState = 'UT';
        acc1.Billingcountry = 'USA';
        acc1.Oracle_Party_Id__c = '12345614';
        acc1.AOPS_Cust_Id__c = '12345614';
        acc1.RecordtypeId = AccRecType.get('Customer').getRecordTypeId();
        acc1.AOPS_Seq_ID__c = '12345614';
       // acc1.Related_Account__c = acc.Id;
       // acc.OwnerID = '005E0000000lNbV';// This is the salesforce User ID
        //acc.Sales_PersonID__c = 'a0AE0000000GGMn'; //Sales person Id for the Salesforce USer
        insert acc1;
        
        AccountTeamMember m = new AccountTeamMember();
        m.userid = UserInfo.getUserId();
        m.AccountId = acc1.Id;
        insert m;
    }
}
/**
 * Created by Najma Ateeq for Story #S-386202(OD Case Number - 00617674) 
 */
@isTest
private class CT_Curr_Controller_Report_TC {

    static testMethod void myUnitTest() {
        Account acc = Test_Utils.CreateAccount();
        Customer_Transition__c ct = new Customer_Transition__c();
        ct.Transition_Status__c = 'Active';
        ct.Review_Start_Date__C = Date.today();
        ct.Account__c = acc.Id;
        //ct.WA_Count__c = 100;
        //ct.NWA_Count__c = 100;
        //ct.Top_Lvl_WA_Cnt__c = 100;
        //ct.Top_Lvl_NWA_Count__c = 100;
        insert ct;
        System.assert(ct != null);
        CT_Curr_Controller_Report con = new CT_Curr_Controller_Report();
    }
}
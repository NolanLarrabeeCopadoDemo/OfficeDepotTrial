@isTest
public class SalesDataBeforeTrigger_TC {
     @isTest
    private static void  test_SalesData() {
        Org__C org = MyUtils_Org.GenerateOrg(12);
        insert org; 
        //creating customer account record
        Account prospectAccount = Test_Utils.CreateAccount('Customer');
        prospectAccount.org__C = org.id;
        prospectAccount.AOPS_Cust_Id__c='123456';
        prospectAccount.AOPS_Seq_ID__c='000001';
        insert prospectAccount;
        Sales_Data__C recentSales = new Sales_Data__C ();
        recentSales.AOPS_Id__c='123456';
        insert recentSales;
        recentSales.AOPS_Id__c='123456';
        update recentSales;
        
        //creating Site account record 
        Account prospectAccountSite = Test_Utils.CreateAccount('Site');
        prospectAccountSite.org__C = org.id;
        prospectAccountSite.AOPS_Cust_Id__c='123457';
        prospectAccountSite.AOPS_Seq_ID__c='000002';
        insert prospectAccountSite;
        Sales_Data__C recentSalesSite = new Sales_Data__C ();
        recentSalesSite.AOPS_Id__c='123457';
        insert recentSalesSite;
        recentSalesSite.AOPS_Id__c='123457';
        update recentSalesSite;
        
                Sales_Data__C recentSalesNew  = new Sales_Data__C ();
                recentSalesNew.org__C=org.Id;
                recentSalesNew.account_type__C='Org';
                insert recentSalesNew ; 
                
    }
}
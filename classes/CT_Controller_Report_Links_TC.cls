@isTest
public class CT_Controller_Report_Links_TC {
    
    public static testMethod void test_CTCRL() {
	Test.startTest();    
    CM_Report_Center_Links__c rL = new CM_Report_Center_Links__c(
        Name = 'Test 1',
    	Report_Description__c = 'Just some typing',
        Report_Label__c = 'Just some Label',
        Report_Link__c = 'http://www.google.com',
        Sort_Order__c = 1);
    
    CM_Report_Center_Links__c rL2 = new CM_Report_Center_Links__c(
        Name = 'Test 2',
    	Report_Description__c = 'Just some typing and more',
        Report_Label__c = 'Just some Label and maybe less',
        Report_Link__c = 'http://www.yahoo.com',
        Sort_Order__c = 2);
    
    insert rl;
    insert rl2;
        
    CT_Controller_Report_Links cT = new CT_Controller_Report_Links();
    Test.setCurrentPage(Page.CT_Reports_Resource);
    	ApexPages.currentPage().getParameters();
    Test.stopTest();
        
    }

}
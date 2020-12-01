@isTest
public class CT_Test_Controller {
static testMethod void test() {
    
    Account Pa = new Account(Name='Parent_27', RecordtypeID = '012E00000008dTa');
  	Account Ca = new Account(Name='Child_27', RecordtypeID = '012E00000008dTa');
  	Account CaX = new Account(Name='Child_27_Exc', RecordtypeID = '012E00000008dTa');
      
      insert Pa;
      insert Ca;
      insert CaX;
    
    Date d = Date.today();
        
      Customer_Transition__c cTn = new Customer_Transition__c(name='Customer Transition of Parent CT_Test_27', 
		 Account__c = Pa.id, Cascade_down__c = true, Written_Agreement__c = true, Review_Start_Date__c = d.addDays(67) );
  	insert cTn;
      
  Customer_Transition__c cTc = new Customer_Transition__c(name='Customer Transition of Child_CT_Test_27', 
		 Account__c = Ca.id, Parent_Transition_ID__C = ctn.ID, Written_Agreement__c = false,  Review_Start_Date__c = d.addDays(1));
  Customer_Transition__c cTx = new Customer_Transition__c(name='Customer Transition of Child_CT_Test_27_Exc', 
		 Account__c = CaX.id, Parent_Transition_ID__C = ctn.ID, Written_Agreement__c = false, Review_Start_Date__c = d.addDays(550));
      
      Insert cTc;
      Insert cTx;
    
    CT_Curr_Controller_Report cT = new CT_Curr_Controller_Report();
    Test.setCurrentPage(Page.CT_Dashboard_WA_RSD_Cnt);
    Test.startTest();
    	ApexPages.currentPage().getParameters();
    Test.stopTest();
}
}
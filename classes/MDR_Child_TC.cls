@isTest
public class MDR_Child_TC {
    //Support Ticket: 00708646
    public static testMethod void test_CTCRL() {
	Test.startTest();    
    MDR__c mdr = new MDR__c(
        Name = 'Test 1',
        PID__c = '00015', 
        Enrollment__c= 15, 
        FILETYPE_L__c= '00015', 
        POVLVLCODE_L__c= '00015',
        School_Type__c= '00015', 
        PUPEXPAIM_L__c= '00015', 
        CHARTER_L__c = 'N', 
        schclass_l__c = 'A'
    );
    insert mdr;
    MDR__c mdr2 = new MDR__c(
        Name = 'Test 2',
        PID__c = '00002', 
        Enrollment__c= 23, 
        FILETYPE_L__c= '00015', 
        POVLVLCODE_L__c= '00015',
        School_Type__c= '00015', 
        ParentPID__c = mdr.id,
        PUPEXPAIM_L__c= '00015', 
        CHARTER_L__c = 'Y', 
        schclass_l__c = 'A'
    );
    
    insert mdr2;
        
    Test.setCurrentPage(Page.Mdr_Child);
    	ApexPages.currentPage().getParameters();
    Test.stopTest();
        
    }

}
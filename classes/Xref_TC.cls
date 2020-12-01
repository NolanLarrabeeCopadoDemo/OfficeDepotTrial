// Test class for Xref classes
@isTest
private class Xref_TC 
{
    static testMethod void TestXref(){
        Account pacc = new Account ();
        pacc.name = 'SUN Test Account1';
        pacc.recordtypeid=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer (OfficeMax)').getRecordTypeId(); 
        pacc.BillingStreet = '1040 N 326 W';
        pacc.billingcity = 'Orem';
        pacc.BillingState = 'UT';
        pacc.Billingcountry = 'USA';
        pacc.Oracle_Party_Id__c = '543456';
        pacc.omx_primary_key__C = '003456';
        pacc.Split_Record__c = false;
        pacc.status__c='Inactive';
        pacc.address1__C='test';
        pacc.OMX_Mainframe_Account_Number__c = '003456';
        insert pacc;
        
        //Test.startTest(); // added for the story #S-355234
         Test.startTest();
        Account acc = new Account ();
        acc.name = 'SUN Test Account';
        acc.BillingStreet = '1040 N 326 W';
        acc.billingcity = 'Orem';
        acc.BillingState = 'UT';
        acc.Billingcountry = 'USA';
        acc.Oracle_Party_Id__c = '123456';
        acc.Split_Record__c = false;
        acc.omx_primary_key__C = '123456';
        acc.parentid=pacc.id;
        acc.recordtypeid=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer (OfficeMax)').getRecordTypeId();
        acc.address1__C='testing records address 25';
        acc.OMX_Mainframe_Account_Number__c = '123456';
        insert acc;
		
        Customer_Transition__c CT = new Customer_Transition__c(omx_primary_key__C='981236', name='test',account__c = acc.id,Status__c='Scheduled');
        insert CT;
        
        
        Test.setCurrentPage(Page.Xref);
        ApexPages.CurrentPage().getParameters().put('ID',ct.id);
        ApexPages.StandardController controller1 = new ApexPages.StandardController(ct);
        XrefData xref = new XrefData(controller1);
        
        //xref.getLoadData(); // commented for the story #S-355234
        
        // added for the story #S-355234 #START
        List<OfficeMax_OfficeDepot_CrossReference__c> ooc = new List<OfficeMax_OfficeDepot_CrossReference__c>(xref.getLoadData());   
        system.assertEquals(ooc.size(), 0);  
        // added for the story #S-355234 #END
        
        Test.setCurrentPage(Page.XrefDataAccount);
        ApexPages.CurrentPage().getParameters().put('ID',acc.id);
        ApexPages.StandardController controller = new ApexPages.StandardController(acc);
        XrefDataAccount xref1 = new XrefDataAccount(controller);
        
        // added for the story #S-355234
        
        // xref1.getLoadData(); // commented for the story #S-355234
        
        // added for the story #S-355234 #START
        List<OfficeMax_OfficeDepot_CrossReference__c> ooc1 = new List<OfficeMax_OfficeDepot_CrossReference__c>(xref1.getLoadData());   
        system.assertEquals(ooc1.size(), 0);    
        // added for the story #S-355234 #END
        
        Test.stopTest(); // added for the story #S-355234
    }
}
@isTest
private class OMXSplit_TC 
{
    static testMethod void method(){

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
        acc.recordtypeid=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site (OfficeMax)').getRecordTypeId();
        acc.address1__C='testing records address 25';
        acc.OMX_Mainframe_Account_Number__c = '123456';
        acc.related_account__c = pacc.id;
        insert acc;     
        
        Prospect_message__c pm = new Prospect_message__c(account__c = pacc.id);
        insert pm;
        
        Test.startTest(); // added for the #S-355234 
        
        OMXSplitSites cont = new OMXSplitSites();
        OMXSplitSites.getSplitSites(pm.id);
        OMXsiteSplitStatus cont1 = new OMXsiteSplitStatus();
        OMXsiteSplitStatus.getSplitSites('123456','Error','Testing Record failed');
        
        Test.stopTest(); // added for the #S-355234 
    }
    
    // added for the #S-355234 #START
	static testMethod void method1(){
		
		Account pacc = new Account ();
        pacc.name = 'SUN Test Account1';
        pacc.recordtypeid=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer (OfficeMax)').getRecordTypeId(); 
        pacc.BillingStreet = '1040 N 326 W';
        pacc.billingcity = 'Orem';
        pacc.BillingState = 'UT';
        pacc.Billingcountry = 'USA';
        pacc.omx_primary_key__C = '003456';
        pacc.Split_Record__c = false;
        pacc.status__c='Inactive';
        pacc.address1__C='test';
        pacc.OMX_Mainframe_Account_Number__c = '003456';
        insert pacc;
        
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
        acc.recordtypeid=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site (OfficeMax)').getRecordTypeId();
        acc.address1__C='testing records address 25';
        acc.OMX_Mainframe_Account_Number__c = '123456';
        acc.related_account__c = pacc.id;
        acc.oracle_party_site_id__c = '23456';
        insert acc;     
        
        Prospect_message__c pm = new Prospect_message__c(account__c = pacc.id);
        insert pm;
        
        Test.startTest(); 
        
        OMXSplitSites cont = new OMXSplitSites();
        OMXSplitSites.getSplitSites(pm.id);
        
        pacc.oracle_party_id__c = '543456';
        update pacc;
        OMXSplitSites.siteResponse st = OMXSplitSites.getSplitSites(pm.id);
        
        system.assertNotEquals(st.ORACLE_PARTY_SITES.size(), 0);
        
        Test.stopTest(); 
	 	
	}
	// added for the #S-355234 #END
}
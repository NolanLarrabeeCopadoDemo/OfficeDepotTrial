// 
// (c) 2015 Appirio, Inc.
//
// Tier1_Extension Test Class
//
// 10 Feb 2015     Luke Slevin       Original
//

@isTest
private class Tier1_ExtensionTest {
	
	@isTest static void test_LoadOpportunitiesForChildAccounts() {
		Partner__c partner = new Partner__c();
        partner.name = 'Appirio Supply, Inc.';
        insert partner;

        ApexPages.StandardController sc = new ApexPages.StandardController(partner);
		Tier1_Extension ext = new Tier1_Extension(sc);

		PageReference pageRef = Page.Tier1_Opportunity_Related_List;
      
        Test.setCurrentPage(pageRef);

        system.assert(ext.lstAccountOpportunities != null);

	}	
}
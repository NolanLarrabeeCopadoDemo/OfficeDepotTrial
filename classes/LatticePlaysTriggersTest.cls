// Appirio 2015
//
// Test class for LatticePlaysTriggers 
// LSLEVIN - Original - 2.18.2016 - S-376888
@isTest
private class LatticePlaysTriggersTest {
	
	@isTest static void test_LatticePlaysTriggerCustomer() {
		Schema.DescribeSObjectResult schemaA = Schema.SObjectType.Account; 
		Map<String,Schema.RecordTypeInfo> AccountRecordTypeInfo = schemaA.getRecordTypeInfosByName();


		Account acc = new Account();
		acc.Name = 'Testing LP Account';
		acc.recordTypeId = AccountRecordTypeInfo .get('Customer').getRecordTypeId();
		insert acc;

		Lattice_Play__c lp = new Lattice_Play__c();
		lp.Account_Id__c = acc.Id;
		insert lp;
	}

	@isTest static void test_LatticePlaysTriggerSite() {
		Schema.DescribeSObjectResult schemaA = Schema.SObjectType.Account; 
		Map<String,Schema.RecordTypeInfo> AccountRecordTypeInfo = schemaA.getRecordTypeInfosByName();


		Account acc = new Account();
		acc.Name = 'Testing LP Account';
		acc.recordTypeId = AccountRecordTypeInfo .get('Site').getRecordTypeId();
		insert acc;

		Lattice_Play__c lp = new Lattice_Play__c();
		lp.Account_Id__c = acc.Id;
		insert lp;
	}

	@isTest static void test_LatticePlaysTriggerNull() {
		Account acc = new Account();
		acc.Name = 'Testing LP Account';
		insert acc;

		Lattice_Play__c lp = new Lattice_Play__c();
		insert lp;
	}
	
}
/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class opportunitySearch_TC {
	static void createData(){
		Canada_Opportunity_Competitor__c coc = new Canada_Opportunity_Competitor__c();
		coc.Name = 'testRec';
		coc.Canada_Competetior__c = 'testCanada';
		coc.Canada_Competetior_FR__c = 'testCanadaFR';
		insert coc;
	}
    static testMethod void oppSearchTest() {
        // TO DO: implement unit test
        createData();
        User testUser = Test_Utils.createTestUser('rc',String.valueOf(Date.today()));
        testUser.CompanyName = 'Grand & Toy';
        insert testUser;
        Test.StartTest();
       	System.runAs(testUser){
       		String competetiors = opportunitySearch.getFieldValues();
       		System.assertEquals(competetiors,'+testCanada');
       }
       Test.StopTest();
       
    }
    static testMethod void oppSearchTestDiffLanguage() {
        // TO DO: implement unit test
        createData();
        User testUser = Test_Utils.createTestUser('rc',String.valueOf(Date.today()));
        testUser.CompanyName = 'Grand & Toy';
        testUser.LanguageLocaleKey = 'fr';
        insert testUser;
        Test.StartTest();
       	System.runAs(testUser){
       		String competetiors = opportunitySearch.getFieldValues();
       		System.assertEquals(competetiors,'+testCanadaFR');
       }
       Test.StopTest();
    }
}
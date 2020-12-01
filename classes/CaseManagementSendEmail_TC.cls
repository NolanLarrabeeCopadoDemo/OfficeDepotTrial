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
 Created by - Rahul Chitkara
 Story - S-377011
 Usage - Test class for CaseManagement.cls Method - sendEmailToTaskOwner
 */ 
 
@isTest
private class CaseManagementSendEmail_TC {
	@testSetup static void CreateCaseAndTask() {
		Map<String,Schema.RecordTypeInfo> CaseRecType = Schema.SObjectType.Case.getRecordTypeInfosByName();    
        List<case> cases = new List<case>();
        Case cs = new Case();
        cs.recordTypeId = CaseRecType.get(Constants.Support).getRecordTypeId();
        cs.WRF_Request_Type__c = 'Transition';
        cs.IT_Status__c = Label.STAwaitingUATMigration;
        insert cs;
        Task ts = new Task();
        ts.status ='New';
        ts.IT_TASK_TYPE__c = Label.STCodeReview;
        ts.WhatId= cs.Id;
        insert ts;
	}
	// Since this method used for Email sending hence avoiding assert - If Email Deliverability is off, it cause issue while running test class. 
    static testMethod void validateSendEmailToTaskOwner() {
    	Test.StartTest();
        Case cs = [select Id,IT_Status__c from Case limit 1];
        cs.IT_Status__c = Label.STInCodeReview;
        update cs; // Update case with different IT status
        list<CaseComment> caseComments = new list<CaseComment>();
        caseComments = [select Id from CaseComment where parentId =:cs.Id];
        //System.assertNotEquals(caseComments.size(),0); // Assert if comment are inserted 
        Test.StopTest();
    }
}
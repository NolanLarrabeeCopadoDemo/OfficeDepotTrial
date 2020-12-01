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
private class EmailServiceHandler_TC {

    static testMethod void EmailServiceHandler_TC() {
        
        AccountAssignments__c accassign=new AccountAssignments__c();
        accassign.AccountId__c='12345';
        accassign.AccountType__c='A';
        accassign.Entity_Id__c='123456789';
        accassign.OverlayEmpID10__c='123';
        accassign.OverlayEmpID1__c='1231';
        accassign.OverlayEmpID11__c='1232';
        accassign.OverlayEmpID12__c='1233';
        accassign.OverlayEmpID13__c='1234';
        accassign.OverlayEmpID14__c='1235';
        accassign.OverlayEmpID15__c='1236';
        accassign.OverlayEmpID2__c='1237';
        insert accassign;
        
     // Create a new email, envelope object and Attachment
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        
        email.subject = 'Start Account Assignment Job';
        email.plainTextBody = 'Hello, this a test email body. for testing purposes only. Bye';
        envelope.fromAddress = 'user@acme.com';


        // setup controller object       
        EmailServiceHandler reassign=new EmailServiceHandler();
        //reassign.strQuery='Select Id, AccountId__c, AccountType__c, Entity_Type__c, Entity_Id__c, PrimaryEmpId__c, PrimaryEmpRole__c from AccountAssignments__c where Status__c = \'Open\' and (Name Like \'%6\' OR Name Like \'%7\')';
        //Database.executeBatch(reassign);
        reassign.handleInboundEmail(email, envelope);
    }
}
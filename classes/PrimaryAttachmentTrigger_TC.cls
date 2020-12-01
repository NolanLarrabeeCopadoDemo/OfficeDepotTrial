@isTest
public class PrimaryAttachmentTrigger_TC {

    @isTest
    static void testAttachmentToFile() {

        Id RecordTypeIdAcct = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Tech_Zone_Customer').getRecordTypeId();
        Account testAccount = new Account();
        testAccount.Name='Test Account' ;
        testAccount.RecordTypeId = RecordTypeIdAcct;
        insert testAccount;

        Id RecordTypeIdOppt = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Tech_Zone').getRecordTypeId();        
        Opportunity oppt = new Opportunity(Name ='New Test Deal',
                            AccountID = testAccount.ID,
                            StageName = 'Closed Won',
                            Amount = 3000,
                            CloseDate = System.today(),
                            RecordTypeid = RecordTypeIdOppt
                            );
   		insert oppt;
        
        Attachment attach=new Attachment();      
        attach.Name='Unit Test Attachment';
        attach.ParentId = oppt.Id;
        Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body');
        attach.body = bodyBlob;
        insert attach;
	}
}
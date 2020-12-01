@isTest
public class ContentDocumentTriggerTest {
    //Prepare test data
    private static void testData(){
        Account acct = new Account(Name='TEST_ACCT');
        insert acct;
        ContentVersion contentVersion = new ContentVersion(
            Title = 'Test Content',
            PathOnClient = 'TestContent.jpg',
            VersionData = Blob.valueOf('Test Content')
        );
        insert contentVersion;    
        List<ContentDocument> documents = [SELECT Id FROM ContentDocument];
        //create ContentDocumentLink  record 
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = acct.id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType = 'V';
        insert cdl;
    }
    @isTest
    private static void contentDocumentInsertTestData(){
        testData();
    }
    @isTest
    private static void contentDocumentInsertTestDataContentDistribution(){
        testData();
        ContentVersion cv = [Select Id,Title from contentVersion LIMIT 1];
        ContentDistribution myPublicContent = new ContentDistribution();
        myPublicContent.ContentVersionId = cv.Id;
        myPublicContent.Name = 'My_Test_Doc';
        myPublicContent.PreferencesAllowOriginalDownload = false;
        myPublicContent.PreferencesAllowPDFDownload = false;
        myPublicContent.PreferencesAllowViewInBrowser = true;
        insert myPublicContent;
    }
}
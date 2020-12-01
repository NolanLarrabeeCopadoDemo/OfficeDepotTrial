@isTest
public class DocumentDownloadLink_TC {

    @isTest
    static void testgetDocumentURL(){
        
        Test.startTest();
        // Should Fail with Document not found.
        try{
            DocumentDownloadLink.getDocumentURL('My_Test_Doc', false);
        } catch(DocumentDownloadLink.DocumentDownloadLinkException e){
            System.assertEquals('No Document Link Found for My_Test_Doc', e.getMessage());
        }
    
        // Create Content Data.
        ContentVersion testDocumentContent = new ContentVersion(); 
        testDocumentContent.ContentURL = 'fooBar';
        testDocumentContent.Title ='My_Test_Doc';


        Insert testDocumentContent;


        // Should get correct result now.
        String result = DocumentDownloadLink.getDocumentURL('My_Test_Doc', false);
        System.assertEquals(URL.getSalesForceBaseURL().toExternalForm() + '/sfc/servlet.shepherd/version/download/' + testDocumentContent.Id, result);
        Test.stopTest();
    }

    @isTest
    static void test_getPublicLink(){
        // Create Content Data.
        ContentVersion testDocumentContent = new ContentVersion();
        // If you are not making a content url....  You need path and version data....
        testDocumentContent.PathOnClient = 'a_test';
        testDocumentContent.VersionData = Blob.valueOf('a test');
        testDocumentContent.Title ='My_Test_Doc';
        Insert testDocumentContent;

        ContentVersion myContentVersion = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =: testDocumentContent.Id LIMIT 1];

        //ContentDocument document = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument LIMIT 1];

        //create ContentDocumentLink  record for that account
        ContentDocumentLink myContentLink = new ContentDocumentLink(
            LinkedEntityId = MyUtils.SuperUser().Id,
            ContentDocumentId = myContentVersion.ContentDocumentId, 
            ShareType = 'V',
            Visibility='AllUsers');
            
        Insert myContentLink;
        
        Test.startTest();
        try{
            DocumentDownloadLink.getPublicLink(myContentVersion.Id);
        } catch(DocumentDownloadLink.DocumentDownloadLinkException e){
            System.assertEquals('Failed to locate the document for download. Please create a ticket mentioning the page you are on.', e.getMessage());
        
        }
        try{
            DocumentDownloadLink.retrieveDocumentURL('My_Test_Doc', true);
        } catch(AuraHandledException e){
            System.assertEquals('Script-thrown exception', e.getMessage());
        }

        ContentDistribution myPublicContent = new ContentDistribution();
        myPublicContent.ContentVersionId = myContentVersion.Id;
        myPublicContent.Name = 'My_Test_Doc';
        myPublicContent.PreferencesAllowOriginalDownload = false;
        myPublicContent.PreferencesAllowPDFDownload = false;
        myPublicContent.PreferencesAllowViewInBrowser = true;
        Insert myPublicContent;

        DocumentDownloadLink.getPublicLink(testDocumentContent.Id);
        DocumentDownloadLink.retrieveDocumentURL('My_Test_Doc', true);
        Test.stopTest();
    }
}
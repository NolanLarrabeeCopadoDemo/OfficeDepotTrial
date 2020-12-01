@IsTest
public class contentDocumentGenerator_TC
{
    @IsTest
    private static void cntnDstrbtn()
    {
        Map<Id, Id> contentDocToLinkedEntityMap = new Map<Id, Id>();
        Map<Id, Id> linkedEntityToContentDocMap = new Map<Id, Id>();
        // case c = new case();
        // c.IT_impact__C = 'testingg';
        // c.Jira_component__C = 'Sales Enablement (Disrupters)';
        // insert c;
        // ContentVersion contentVersion = new ContentVersion
        // (
        //     Title = 'Test Content',
        //     PathOnClient = 'TestContent.jpg',
        //     VersionData = Blob.valueOf('Test Content')
        // );
        // insert contentVersion;
        // List<ContentDocument> documents = [SELECT Id FROM ContentDocument];
        // List<ContentDocumentLink> docLink = new List<ContentDocumentLink> ();
        // ContentDocumentLink cdl = New ContentDocumentLink();
        // cdl.LinkedEntityId = c.id;
        // cdl.ContentDocumentId = documents[0].Id;
        // cdl.shareType = 'V';
        // insert cdl;
        // docLink.add(cdl);
        // for (ContentDocumentLink cdlnk: docLink)
        // {
        //     contentDocToLinkedEntityMap.put(cdlnk.ContentDocumentId, cdlnk.LinkedEntityId);
        //     linkedEntityToContentDocMap.put(cdlnk.LinkedEntityId, cdlnk.ContentDocumentId);
        // }
        Test.startTest();
        contentDocumentGenerator.generatePublicLink(linkedEntityToContentDocMap, contentDocToLinkedEntityMap);
        Test.stopTest();
    }
}
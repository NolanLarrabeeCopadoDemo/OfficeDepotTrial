@isTest
public class ContentDocumentLinkTrigger_TC {
    
private static String QUOTE_MODEL_NAME = 'OfficeDepot';
    private static String QX_SETUP_NAME = 'Master';
    private static String MAPPING_SET_NAME = 'New_Written_Agreement';
    private static String CONTEXT_DATA_PROVIDER_NAME = 'SfdcContext';
    
    @isTest
    public static void contentDocuemntLinkTest(){
         case c = new case();
c.IT_impact__C = 'testingg';
c.Jira_component__C ='Sales Enablement (Disrupters)	';
insert c;
        test.startTest();
        ContentVersion contentVersion = new contentVersion();
        contentVersion.Title = 'Costomer Copy';
        contentVersion.PathOnClient = 'Costomer Copy.pdf';
        Blob afterblob = EncodingUtil.base64Decode('test');
        // system.debug(afterblob);
        //  system.debug(paramvalue);
        contentVersion.VersionData = afterblob;
        contentVersion.IsMajorVersion = true;
        
        insert contentVersion;
        
        Id contentDoc = [SELECT ContentDocumentId FROM ContentVersion Where Id =:contentVersion.Id].ContentDocumentId;
            
            ContentDocumentLink contentDocumentLink = new ContentDocumentLink();
            contentDocumentLink.LinkedEntityId = c.id;
            contentDocumentLink.ContentDocumentId = contentDoc;
            contentDocumentLink.ShareType = 'I';
            contentDocumentLink.Visibility = 'AllUsers';
            
            insert contentDocumentLink;
              
        Test.stopTest();
    }
}
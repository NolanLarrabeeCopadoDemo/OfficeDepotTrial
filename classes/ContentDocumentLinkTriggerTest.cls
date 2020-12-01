@isTest
public class ContentDocumentLinkTriggerTest {
    
    private static String QUOTE_MODEL_NAME = 'OfficeDepot';
    private static String QX_SETUP_NAME = 'Master';
    private static String MAPPING_SET_NAME = 'New_Written_Agreement';
    private static String CONTEXT_DATA_PROVIDER_NAME = 'SfdcContext';
    
    @isTest
    public static void contentDocuemntLinkTest(){
        insert new  ProsCustomSettings__c(Name = 'CCORE',
                                          User_Name__c = 'test',Symmetric_Key__c = 'Z+b4h9iPodOy6594ozdVfw==',Password__c='test',
                                          CCORE_Username__c = 'test',CCORE_Password__c = 'test');
        String currentProfile = [SELECT Id,Name,Profile.Name FROM User WHERE Id = :UserInfo.getUserId()].Profile.Name;
        //insert new ProsCustomSettings__c(name='Sandbox'); 
        insert new  PROS_Access_Custom_Setting__c(Name = 'In Review_VIEW', Profiles__c = currentProfile);
        insert new  PROS_Access_Custom_Setting__c(Name = 'Draft_VIEW', Profiles__c = currentProfile);
        Account acc = new Account();
        acc.Name = 'test acc';
        insert acc;
        
        CameleonCPQ__QxSetup__c newSetup = new CameleonCPQ__QxSetup__c(Name=QX_SETUP_NAME,
                                                                       
                                                                       CameleonCPQ__QuoteModelName__c=QUOTE_MODEL_NAME, 
                                                                       CameleonCPQ__MappingSetName__c=MAPPING_SET_NAME, 
                                                                       CameleonCPQ__LinesManagementPolicy__c=1);
        insert newSetup;
        
        CameleonCPQ__QxQuote__c quote = new CameleonCPQ__QxQuote__c();
        quote.Name = 'test-1';
        quote.CameleonCPQ__Status__c = 'Draft';
        quote.CameleonCPQ__AccountId__c = acc.Id;
        insert quote;
        Test.startTest();
        
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
            contentDocumentLink.LinkedEntityId = quote.Id;
            contentDocumentLink.ContentDocumentId = contentDoc;
            contentDocumentLink.ShareType = 'I';
            contentDocumentLink.Visibility = 'AllUsers';
            
            insert contentDocumentLink;
              
        Test.stopTest();
    }
    
}
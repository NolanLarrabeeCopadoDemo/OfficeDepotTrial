/* Pavani Akula */

@isTest
public class QxVFGenerateReportControllerTest {
    
    private static String QUOTE_MODEL_NAME = 'OfficeDepot';
    private static String QX_SETUP_NAME = 'Master';
    private static String MAPPING_SET_NAME = 'New_Written_Agreement';
    private static String CONTEXT_DATA_PROVIDER_NAME = 'SfdcContext';   
    
    @isTest
    public static void generateReportTest(){

        String currentProfile = [SELECT Id,Name,Profile.Name FROM User WHERE Id = :UserInfo.getUserId()].Profile.Name;
        insert new  PROS_Access_Custom_Setting__c(Name = 'Draft_VIEW', Profiles__c = currentProfile);
        insert new  PROS_Access_Custom_Setting__c(Name = 'In Review_VIEW', Profiles__c = currentProfile);
        insert new  PROS_Access_Custom_Setting__c(Name = 'Pricing Analyst_NO ACCESS', Profiles__c = currentProfile);
        insert new  PROS_Access_Custom_Setting__c(Name = 'Hosted Flag_VIEW', Profiles__c = currentProfile);
        

        // Create default CPQ settings if do not exist yet
        CameleonCPQ__QxSettings__c[] QxSettings = [SELECT /*CameleonCPQ__ApiURL__c, */CameleonCPQ__BaseURL__c, CameleonCPQ__TenantId__c, CameleonCPQ__EnvironmentId__c FROM CameleonCPQ__QxSettings__c WHERE SetupOwnerId=:UserInfo.getOrganizationId()];

        if (QxSettings==null || QxSettings.size()==0) {
            QxSettings = new CameleonCPQ__QxSettings__c[]{new CameleonCPQ__QxSettings__c(SetupOwnerId=UserInfo.getOrganizationId(), CameleonCPQ__BaseURL__c='https://localhost:8080', /*CameleonCPQ__ApiURL__c='https://spreadsheetpublicapi.azure-api.net',*/ CameleonCPQ__TenantId__c='PROS', CameleonCPQ__EnvironmentId__c='TEST')}; 

                insert QxSettings; 
        }
        //QxSettings[0].CameleonCPQ__ApiSubscriptionKey__c='d231fa3664e1435eb04e2e1c77f56ae6';
        update QxSettings;
        
        CameleonCPQ__QxSetup__c newSetup = new CameleonCPQ__QxSetup__c(Name=QX_SETUP_NAME,
                                                                       CameleonCPQ__QuoteModelName__c=QUOTE_MODEL_NAME,
                                                                       CameleonCPQ__MappingSetName__c=MAPPING_SET_NAME, 
                                                                       CameleonCPQ__LinesManagementPolicy__c=1);
        //newSetup.CameleonCPQ__ContextDataProviderName__c = CONTEXT_DATA_PROVIDER_NAME;

        insert newSetup;
                
        CameleonCPQ__QxQuote__c newQuote = new CameleonCPQ__QxQuote__c(Name='UNIT TESTS QUOTE PROCESS', CameleonCPQ__ExternalQuoteId__c ='d8829a8d-191b-447d-87a2-6f38bb929aa1',CameleonCPQ__Status__c='Draft');
        try{
            Test.startTest();
            CameleonCPQ.QxHttpCalloutMockImpl theMock = new CameleonCPQ.QxHttpCalloutMockImpl();
            Test.setMock(HttpCalloutMock.class, theMock); 
            CameleonCPQ.QxHttpCalloutMockImpl.setAsMock();
            insert newQuote;
            newQuote.CameleonCPQ__Status__c = 'Approved Internally';
            
            update newQuote;

            QxVFGenerateReportController.generateReport(newQuote.Id, 'Print Cube Proposal');
            Test.stopTest();

        }
        catch(Exception e){
            System.debug('Exception :'+e);
            System.debug('Exception :'+e.getStackTraceString());
        }
    }
    
    @isTest
    public static void sleepTest(){
        Test.startTest();
        QxVFGenerateReportController.sleep(200);
        Test.stopTest();
    }
}
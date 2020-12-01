@isTest
public class QxCPQQuoteTriggerHandlerTest {
    
    private static String QUOTE_MODEL_NAME = 'OfficeDepot';
    private static String QX_SETUP_NAME = 'Master';
    private static String MAPPING_SET_NAME = 'New_Written_Agreement';
    private static String CONTEXT_DATA_PROVIDER_NAME = 'SfdcContext';
    
    @isTest
    public static void handleBeforeInsertTest(){
        String currentProfile = [SELECT Id,Name,Profile.Name FROM User WHERE Id = :UserInfo.getUserId()].Profile.Name;
        insert new  PROS_Access_Custom_Setting__c(Name = 'Draft_VIEW', Profiles__c = currentProfile);
        insert new  PROS_Access_Custom_Setting__c(Name = 'Pricing Analyst_NO ACCESS', Profiles__c = currentProfile);
        insert new  PROS_Access_Custom_Setting__c(Name = 'In Review_VIEW', Profiles__c = currentProfile);
        
        // Create default CPQ settings if do not exist yet
        CameleonCPQ__QxSettings__c[] QxSettings = [SELECT /*CameleonCPQ__ApiURL__c,*/ CameleonCPQ__BaseURL__c, CameleonCPQ__TenantId__c, CameleonCPQ__EnvironmentId__c FROM CameleonCPQ__QxSettings__c WHERE SetupOwnerId=:UserInfo.getOrganizationId()];
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
        
         Account acc = new Account();
        acc.Name = 'test acc';
        acc.Custom_Core_Id__c = '';
        insert acc;
        
         Account acc2 = new Account();
        acc2.Name = 'test acc';
        acc2.Custom_Core_Id__c = '123';
        acc2.AOPS_Cust_Id__c = 'TEST123';
        insert acc2;
        
        CameleonCPQ__QxQuote__c newQuote = new CameleonCPQ__QxQuote__c(Name='UNIT TESTS QUOTE PROCESS', CameleonCPQ__ExternalQuoteId__c ='d8829a8d-191b-447d-87a2-6f38bb929aa1',
                                                                       CameleonCPQ__AccountId__c = acc.Id,CameleonCPQ__Status__c = 'Approved');
        
        CameleonCPQ__QxQuote__c newQuote2 = new CameleonCPQ__QxQuote__c(Name='UNIT TESTS QUOTE PROCESS', CameleonCPQ__ExternalQuoteId__c ='d8829a8d-191b-447d-87a2-6f38bb929aa1',
                                                                    CameleonCPQ__AccountId__c = acc2.Id,CameleonCPQ__Status__c = 'Draft');
        
        CameleonCPQ.QxHttpCalloutMockImpl theMock = new CameleonCPQ.QxHttpCalloutMockImpl();
            Test.setMock(HttpCalloutMock.class, theMock); 
            CameleonCPQ.QxHttpCalloutMockImpl.setAsMock();
        try{
            insert newQuote;

            insert newQuote2;
            newQuote.CameleonCPQ__SyncStatus__c = 'COMPLETE';
            newQuote.Core_Id__c = '123';
            newQuote.CameleonCPQ__Status__c = 'Accepted';
            newQuote.Primary_Quote__c = true;
            update newQuote;
            
            newQuote.Core_Id__c = null;
            newQuote.CameleonCPQ__Status__c = 'Approved';
            newQuote.Addition_Flag__c = true;
            newQuote.PROSAgreement__ContractId__c = null;
            update newQuote;
            
            newQuote.CameleonCPQ__Status__c = 'Inactive';
            update newQuote;
            
            /*newQuote.CameleonCPQ__SyncStatus__c = 'COMPLETE';
            newQuote.PROSAgreement__ContractId__c = '123';
            update newQuote;*/
            
            System.debug('newQuote2 :'+newQuote2);
            newQuote2.CameleonCPQ__Status__c = 'Approved Internally';
            update newQuote2;
            newQuote2.CameleonCPQ__AccountId__c = null;
            update newQuote2;
        }
        catch(Exception e){
            System.debug(e);
            System.debug(e.getStackTraceString());
        }
        try{
            newQuote.Primary_Quote__c = FALSE;
            newQuote.CameleonCPQ__Status__c = 'Accepted';
            //newQuite.AOPS_Cust_Id__c = 'TEST';
            update newQuote;
        }
        catch(Exception e){
            System.debug('Exception :'+e.getStackTraceString());
        }
        
       /* List<CameleonCPQ__QxQuote__c> qList = new List<CameleonCPQ__QxQuote__c>();
        qList.add(newQuote);
            
        QxCPQQuoteTriggerHandler qt = new QxCPQQuoteTriggerHandler();
        qt.handleBeforeDelete(qList);
        */
        delete newQuote;
            

    }
}
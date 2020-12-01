@isTest
public class QxCPQQuoteCheckAccessTest {
    
    @isTest
    public static void checkHostedFlagTest(){
        CameleonCPQ__QxSetup__c setup = new CameleonCPQ__QxSetup__c();
        setup.Name = 'Default';
        setup.CameleonCPQ__QuoteModelName__c = 'OfficeDepot';
        setup.CameleonCPQ__MappingSetName__c = '';
        setup.PROSAgreement__AgreementConfigName__c = 'OfficeDepot_Agreement_1';
        setup.CameleonCPQ__LinesManagementPolicy__c = 1;
        insert setup;
        List<CameleonCPQ__QxQuote__c> quotes = new List<CameleonCPQ__QxQuote__c>();
        List<Id> accIds = new List<Id>();
        String currentProfile = [SELECT Id,Name,Profile.Name FROM User WHERE Id = :UserInfo.getUserId()].Profile.Name;
        insert new ProsCustomSettings__c(name='Sandbox'); 
        insert new  PROS_Access_Custom_Setting__c(Name = 'Hosted Flag_VIEW', Profiles__c = currentProfile);
        Account acc = new Account();
        acc.Name = 'test acc';
        insert acc;
        CameleonCPQ__QxQuote__c quote = new CameleonCPQ__QxQuote__c();
        quote.Name = 'test-1';
        quote.CameleonCPQ__Status__c = 'Draft';
        quote.CameleonCPQ__AccountId__c = acc.Id;
        quote.RecordTypeId = Schema.SObjectType.CameleonCPQ__QxQuote__c.getRecordTypeInfosByName().get('Default').getRecordTypeId();
        insert quote;
        quotes.add(quote);
        accIds.add(acc.Id);
        QxCPQQuoteCheckAccess.checkHostedFlag(quotes, accIds);
    }
    
    @isTest
    public static void checkQuoteStatusTest(){
        String currentProfile = [SELECT Id,Name,Profile.Name FROM User WHERE Id = :UserInfo.getUserId()].Profile.Name;
        insert new  PROS_Access_Custom_Setting__c(Name = 'Draft_VIEW', Profiles__c = currentProfile);
        insert new  PROS_Access_Custom_Setting__c(Name = 'In Review_VIEW', Profiles__c = currentProfile);
        insert new  PROS_Access_Custom_Setting__c(Name = 'Pricing Analyst_ACCESS', Profiles__c = currentProfile);
        CameleonCPQ__QxSetup__c setup = new CameleonCPQ__QxSetup__c();
        setup.Name = 'Default';
        setup.CameleonCPQ__QuoteModelName__c = 'OfficeDepot';
        setup.CameleonCPQ__MappingSetName__c = '';
        setup.PROSAgreement__AgreementConfigName__c = 'OfficeDepot_Agreement_1';
        setup.CameleonCPQ__LinesManagementPolicy__c = 1;
        insert setup;
        Test.startTest();
        try{
            CameleonCPQ__QxQuote__c quote = new CameleonCPQ__QxQuote__c();
            quote.Name = 'test-1';
            quote.CameleonCPQ__Status__c = 'Draft';
            insert quote;
            QxCPQQuoteCheckAccess.checkQuoteStatus(quote);
        }
        catch(Exception e){
            
        }
        Test.stopTest();
    }
    
    @isTest
    public static void checkPricingAnalystTest(){
        Test.startTest();
        String currentProfile = [SELECT Id,Name,Profile.Name FROM User WHERE Id = :UserInfo.getUserId()].Profile.Name;
        insert new  PROS_Access_Custom_Setting__c(Name = 'Pricing Analyst_NO ACCESS', Profiles__c = currentProfile);
        insert new  PROS_Access_Custom_Setting__c(Name = 'Pricing Analyst_ACCESS', Profiles__c = currentProfile);
        CameleonCPQ__QxSetup__c setup = new CameleonCPQ__QxSetup__c();
        setup.Name = 'Default';
        setup.CameleonCPQ__QuoteModelName__c = 'OfficeDepot';
        setup.CameleonCPQ__MappingSetName__c = '';
        setup.PROSAgreement__AgreementConfigName__c = 'OfficeDepot_Agreement_1';
        setup.CameleonCPQ__LinesManagementPolicy__c = 1;
        insert setup;
        try{
            CameleonCPQ__QxQuote__c quote = new CameleonCPQ__QxQuote__c();
            quote.Name = 'test-1';
            quote.CameleonCPQ__Status__c = 'Draft';
            quote.PricingAnalyst__c = UserInfo.getUserId();
            insert quote;
            QxCPQQuoteCheckAccess.checkPricingAnalyst(quote);
        }
        catch(Exception e){
            System.debug('Exception :'+e);
            System.debug('Exception :'+e.getStackTraceString());
        }
        Test.stopTest();
    }
}
@isTest
/*
 * Copyright (c) 2015 - 2018 by PROS, Inc.  All Rights Reserved.
 * This software is the confidential and proprietary information of
 * PROS, Inc. ("Confidential Information").
 * You may not disclose such Confidential Information, and may only
 * use such Confidential Information in accordance with the terms of
 * the license agreement you entered into with PROS.
 */
 
/**
 * Unitary Test Methods for QxVFCloneQuoteController.
 *
 * @author rderval
 */
public class QxVFCPQCloneQuoteControllerTest {
 /** 
     * Unitary Test Method 
     */
    private static testMethod void cloneQuote()
    {
        String currentProfile = [SELECT Id,Name,Profile.Name FROM User WHERE Id = :UserInfo.getUserId()].Profile.Name;
        insert new  PROS_Access_Custom_Setting__c(Name = 'Draft_VIEW', Profiles__c = currentProfile);
        insert new  PROS_Access_Custom_Setting__c(Name = 'Pricing Analyst_NO ACCESS', Profiles__c = currentProfile);
        insert new  PROS_Access_Custom_Setting__c(Name = 'Pricing Analyst_ACCESS', Profiles__c = currentProfile);
        
        // Create default CPQ settings if do not exist yet
        CameleonCPQ__QxSettings__c[] QxSettings = [SELECT /*CameleonCPQ__ApiURL__c,*/ CameleonCPQ__BaseURL__c, CameleonCPQ__TenantId__c, CameleonCPQ__EnvironmentId__c FROM CameleonCPQ__QxSettings__c WHERE SetupOwnerId=:UserInfo.getOrganizationId()];
        if (QxSettings==null || QxSettings.size()==0) {
            QxSettings = new CameleonCPQ__QxSettings__c[]{new CameleonCPQ__QxSettings__c(SetupOwnerId=UserInfo.getOrganizationId(), CameleonCPQ__BaseURL__c='https://localhost:8080', /*CameleonCPQ__ApiURL__c='https://spreadsheetpublicapi.azure-api.net',*/ CameleonCPQ__TenantId__c='PROS', CameleonCPQ__EnvironmentId__c='TEST')}; 
            insert QxSettings; 
        }
        //QxSettings[0].CameleonCPQ__ApiSubscriptionKey__c='d231fa3664e1435eb04e2e1c77f56ae6';
        update QxSettings;
        
        CameleonCPQ__QxSetup__c setup = new CameleonCPQ__QxSetup__c();
        setup.Name = 'Default';
        setup.CameleonCPQ__QuoteModelName__c = 'OfficeDepot';
        setup.CameleonCPQ__MappingSetName__c = '';
        setup.PROSAgreement__AgreementConfigName__c = 'OfficeDepot_Agreement_1';
        setup.CameleonCPQ__LinesManagementPolicy__c = 1;
        insert setup;

        Account acc = new Account();
        acc.Name = 'test acc';
        acc.AOPS_Cust_Id__c = '1234';
        insert acc;
        
        CameleonCPQ__QxQuote__c newQuote = new CameleonCPQ__QxQuote__c(Name='UNIT TESTS QUOTE PROCESS', CameleonCPQ__Status__c = 'Fully Approved',
                                                                       CameleonCPQ__AccountId__c = acc.Id,Core_Id__c = '1234',
                                                                       PROSAgreement__EndDate__c = null, CameleonCPQ__ExternalQuoteId__c ='d8829a8d-191b-447d-87a2-6f38bb929aa1');
        insert newQuote;
        
        QxVFCPQCloneQuoteController.CloneQuoteResult cloneQuoteResult1 = QxVFCPQCloneQuoteController.cloneSfdcQuote(newQuote.Id,'Test Clone of ');
        System.assertNotEquals(cloneQuoteResult1.targetId, null);

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CameleonCPQ.QxHttpCalloutMockImpl());
        
        //QxVFCPQCloneQuoteController.CloneQuoteResult cloneQuoteResult2 = QxVFCPQCloneQuoteController.cloneQxQuote(newQuote.Id, cloneQuoteResult1.targetId);
        Test.stopTest();
    }
    
    @isTest
    public static void createAgreementTest(){
        String currentProfile = [SELECT Id,Name,Profile.Name FROM User WHERE Id = :UserInfo.getUserId()].Profile.Name;
        insert new  PROS_Access_Custom_Setting__c(Name = 'Draft_VIEW', Profiles__c = currentProfile);
        insert new  PROS_Access_Custom_Setting__c(Name = 'Pricing Analyst_NO ACCESS', Profiles__c = currentProfile);
        insert new  PROS_Access_Custom_Setting__c(Name = 'Pricing Analyst_ACCESS', Profiles__c = currentProfile);
        
        // Create default CPQ settings if do not exist yet
        CameleonCPQ__QxSettings__c[] QxSettings = [SELECT /*CameleonCPQ__ApiURL__c,*/ CameleonCPQ__BaseURL__c, CameleonCPQ__TenantId__c, CameleonCPQ__EnvironmentId__c FROM CameleonCPQ__QxSettings__c WHERE SetupOwnerId=:UserInfo.getOrganizationId()];
        if (QxSettings==null || QxSettings.size()==0) {
            QxSettings = new CameleonCPQ__QxSettings__c[]{new CameleonCPQ__QxSettings__c(SetupOwnerId=UserInfo.getOrganizationId(), CameleonCPQ__BaseURL__c='https://localhost:8080', /*CameleonCPQ__ApiURL__c='https://spreadsheetpublicapi.azure-api.net',*/ CameleonCPQ__TenantId__c='PROS', CameleonCPQ__EnvironmentId__c='TEST')}; 
            insert QxSettings; 
        }
        //QxSettings[0].CameleonCPQ__ApiSubscriptionKey__c='d231fa3664e1435eb04e2e1c77f56ae6';
        update QxSettings;
        
        //AOPS_Cust_Id__c
        
        CameleonCPQ__QxSetup__c setup = new CameleonCPQ__QxSetup__c();
        setup.Name = 'Default';
        setup.CameleonCPQ__QuoteModelName__c = 'OfficeDepot';
        setup.CameleonCPQ__MappingSetName__c = '';
        setup.PROSAgreement__AgreementConfigName__c = 'OfficeDepot_Agreement_1';
        setup.CameleonCPQ__LinesManagementPolicy__c = 1;
        insert setup;

        Account acc = new Account();
        acc.Name = 'test acc';
        acc.AOPS_Cust_Id__c = '1234';
        insert acc;

        CameleonCPQ__QxQuote__c newQuote = new CameleonCPQ__QxQuote__c(Name='UNIT TESTS QUOTE PROCESS', CameleonCPQ__Status__c = 'Fully Approved',
                                                                       CameleonCPQ__AccountId__c = acc.Id,Core_Id__c = '1234',
                                                                       PROSAgreement__EndDate__c = null,
                                                                       CameleonCPQ__ExternalQuoteId__c ='d8829a8d-191b-447d-87a2-6f38bb929aa1');
        
        insert newQuote;
         CameleonCPQ__QxQuote__c newQuote2 = new CameleonCPQ__QxQuote__c(Name='UNIT TESTS QUOTE PROCESS', CameleonCPQ__Status__c = 'Draft',
                                                                       CameleonCPQ__AccountId__c = acc.Id,Core_Id__c = '1234',
                                                                       CameleonCPQ__ExternalQuoteId__c ='d8829a8d-191b-447d-87a2-6f38bb929aa1');
        
        insert newQuote2;
        CameleonCPQ__QxQuote__c newQuote3 = new CameleonCPQ__QxQuote__c(Name='UNIT TESTS QUOTE PROCESS', CameleonCPQ__Status__c = 'Draft',
                                                                       CameleonCPQ__AccountId__c = acc.Id,Core_Id__c = '1234',PROSAgreement__AgreementStatus__c = 'Published',
                                                                       CameleonCPQ__ExternalQuoteId__c ='d8829a8d-191b-447d-87a2-6f38bb929aa1');
        
        insert newQuote3;
        CameleonCPQ__QxQuote__c newQuote4 = new CameleonCPQ__QxQuote__c(Name='UNIT TESTS QUOTE PROCESS', CameleonCPQ__Status__c = 'Draft',
                                                                       CameleonCPQ__AccountId__c = acc.Id,Core_Id__c = '1234',PROSAgreement__AgreementStatus__c = 'Published',
                                                                       CameleonCPQ__ExternalQuoteId__c ='d8829a8d-191b-447d-87a2-6f38bb929aa1');
        
        insert newQuote4;
        QxVFCPQCloneQuoteController.createAgreement(newQuote.Id);
        QxVFCPQCloneQuoteController.createAgreement(newQuote2.Id);
        QxVFCPQCloneQuoteController.createAgreement(newQuote3.Id);
        QxVFCPQCloneQuoteController.createAgreement(newQuote4.Id);
    }
    
    @isTest
    public static void cloneQxQuoteTest(){
        String currentProfile = [SELECT Id,Name,Profile.Name FROM User WHERE Id = :UserInfo.getUserId()].Profile.Name;
        insert new  PROS_Access_Custom_Setting__c(Name = 'Draft_VIEW', Profiles__c = currentProfile);
        insert new  PROS_Access_Custom_Setting__c(Name = 'Pricing Analyst_NO ACCESS', Profiles__c = currentProfile);
        insert new  PROS_Access_Custom_Setting__c(Name = 'Pricing Analyst_ACCESS', Profiles__c = currentProfile);
        insert new  PROS_Access_Custom_Setting__c(Name = 'Draft_VIEW', Profiles__c = currentProfile);
        insert new  PROS_Access_Custom_Setting__c(Name = 'In Review_VIEW', Profiles__c = currentProfile);
        
        // Create default CPQ settings if do not exist yet
        CameleonCPQ__QxSettings__c[] QxSettings = [SELECT /*CameleonCPQ__ApiURL__c,*/ CameleonCPQ__BaseURL__c, CameleonCPQ__TenantId__c, CameleonCPQ__EnvironmentId__c FROM CameleonCPQ__QxSettings__c WHERE SetupOwnerId=:UserInfo.getOrganizationId()];
        if (QxSettings==null || QxSettings.size()==0) {
            QxSettings = new CameleonCPQ__QxSettings__c[]{new CameleonCPQ__QxSettings__c(SetupOwnerId=UserInfo.getOrganizationId(), CameleonCPQ__BaseURL__c='https://localhost:8080', /*CameleonCPQ__ApiURL__c='https://spreadsheetpublicapi.azure-api.net',*/ CameleonCPQ__TenantId__c='PROS', CameleonCPQ__EnvironmentId__c='TEST')}; 
            insert QxSettings; 
        }
        //QxSettings[0].CameleonCPQ__ApiSubscriptionKey__c='d231fa3664e1435eb04e2e1c77f56ae6';
        update QxSettings;
        
        CameleonCPQ__QxSetup__c setup = new CameleonCPQ__QxSetup__c();
        setup.Name = 'Default';
        setup.CameleonCPQ__QuoteModelName__c = 'OfficeDepot';
        setup.CameleonCPQ__MappingSetName__c = '';
        setup.PROSAgreement__AgreementConfigName__c = 'OfficeDepot_Agreement_1';
        setup.CameleonCPQ__LinesManagementPolicy__c = 1;
        insert setup;
        
        Account acc = new Account();
        acc.Name = 'test acc';
        acc.AOPS_Cust_Id__c = '1234';
        insert acc;

        CameleonCPQ__QxQuote__c newQuote = new CameleonCPQ__QxQuote__c(Name='UNIT TESTS QUOTE PROCESS', CameleonCPQ__AccountId__c = acc.Id,Core_Id__c = '1234',
                                                                       CameleonCPQ__ExternalQuoteId__c ='d8829a8d-191b-447d-87a2-6f38bb929aa1',PROSAgreement__Quote_Type__c='Initial');
        insert newQuote;
        CameleonCPQ.QxHttpCalloutMockImpl.setAsMock();
        Test.setMock(HttpCalloutMock.class, new CameleonCPQ.QxHttpCalloutMockImpl());
        Test.startTest();
        QxVFCPQCloneQuoteController.cloneQxQuote(newQuote.Id,newQuote.Id);
        try{
            QxVFCPQCloneQuoteController.cloneQxQuote(null,newQuote.Id);
        }
        catch(Exception e){
            
        }
        try{
            QxVFCPQCloneQuoteController.cloneQxQuote(newQuote.Id,null);
        }
        catch(Exception e){
            
        }
        PageReference pageRef = Page.QxCPQCloneQuote;
        Test.setCurrentPage(pageRef);
          ApexPages.StandardController sc = new ApexPages.StandardController(newQuote);
        new QxVFCPQCloneQuoteController(sc);
        Test.stopTest();
    }
}
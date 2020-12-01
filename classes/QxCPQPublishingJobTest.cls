/*
 * Copyright (c) 2020 by PROS, Inc.  All Rights Reserved.
 * This software is the confidential and proprietary information of
 * PROS, Inc. ("Confidential Information").
 * You may not disclose such Confidential Information, and may only
 * use such Confidential Information in accordance with the terms of
 * the license agreement you entered into with PROS.
 *
 * Test case for QxCPQQuoteAutoRefreshAndSync
 * 
 * @author : Shawn Wang
 *
 */

@isTest
public class QxCPQPublishingJobTest {
	private static Account account1;
    private static Opportunity opp1;
    private static QxCPQQuoteTriggerHandler handler;
    
    private static String QUOTE_MODEL_NAME = 'OfficeDepot';
    private static String QX_SETUP_NAME = 'Master';
    private static String MAPPING_SET_NAME = 'New_Written_Agreement';
    private static String CONTEXT_DATA_PROVIDER_NAME = 'SfdcContext';   
    
    private static void init(){
        
        // Create default CPQ settings if do not exist yet
        CameleonCPQ__QxSettings__c[] QxSettings = [SELECT CameleonCPQ__BaseURL__c, CameleonCPQ__TenantId__c, CameleonCPQ__EnvironmentId__c, CameleonCPQ__AppPortalURL__c, CameleonCPQ__AppPortalIDP__c, CameleonCPQ__AppPortalAccountId__c, CameleonCPQ__AppPortalCertificateName__c FROM CameleonCPQ__QxSettings__c WHERE SetupOwnerId=:UserInfo.getOrganizationId()];
        if (QxSettings==null || QxSettings.size()==0) {
            QxSettings = new CameleonCPQ__QxSettings__c[]{new CameleonCPQ__QxSettings__c(
                SetupOwnerId=UserInfo.getOrganizationId(),
                CameleonCPQ__BaseURL__c='https://localhost:8080',
                CameleonCPQ__TenantId__c='a8515c30-42cc-11e6-beb8-9e71128cae73',
                CameleonCPQ__EnvironmentId__c='test',
                CameleonCPQ__AppPortalURL__c='https://login.us1.proscloud.com',
                CameleonCPQ__AppPortalIDP__c='UNIT_TEST_IDP',
                CameleonCPQ__AppPortalAccountId__c='9fa0e6c0-a800-4e7d-b069-d734c1a4ae89',
                CameleonCPQ__AppPortalCertificateName__c='appportalcpqx'
            )
                };
                insert QxSettings;
        }
        
         CameleonCPQ__QxSetup__c newSetup = new CameleonCPQ__QxSetup__c(Name=QX_SETUP_NAME,
                                                                       CameleonCPQ__QuoteModelName__c=QUOTE_MODEL_NAME,
                                                                       CameleonCPQ__MappingSetName__c=MAPPING_SET_NAME, 
                                                                       CameleonCPQ__LinesManagementPolicy__c=1);
        
         String currentProfile = [SELECT Id,Name,Profile.Name FROM User WHERE Id = :UserInfo.getUserId()].Profile.Name;
        insert new  PROS_Access_Custom_Setting__c(Name = 'Draft_VIEW', Profiles__c = currentProfile);
        insert new  PROS_Access_Custom_Setting__c(Name = 'In Review_VIEW', Profiles__c = currentProfile);
        insert new  PROS_Access_Custom_Setting__c(Name = 'Pricing Analyst_NO ACCESS', Profiles__c = currentProfile);
        insert new  PROS_Access_Custom_Setting__c(Name = 'Hosted Flag_VIEW', Profiles__c = currentProfile);
        //newSetup.CameleonCPQ__ContextDataProviderName__c = CONTEXT_DATA_PROVIDER_NAME;

        insert newSetup;
        
        Account masterAccount = new Account(Name='master account'); 
        masterAccount.Sharing_Group__c = 'Master Account Share'; 
        insert masterAccount; 
        
        Recordtype custAccRT = [Select id, Sobjecttype from recordtype where name = 'Customer' and Sobjecttype = 'Account']; 
        account1 = new Account(Name='Test Account');
        account1.RecordTypeId = custAccRT.Id; 
        account1.ParentId = masterAccount.Id; 
        account1.AOPS_Cust_Id__c='001234567';
        insert account1; 
        
        Contact con = new Contact(LastName='userName', AccountId = account1.Id);
        insert con; 
        
        Contact con2 = new Contact(LastName='userName2', AccountId = account1.Id);
        insert con2; 
        

        opp1 = new Opportunity(); 
        opp1.Name = 'Test';   
        opp1.Product__c = 'Furniture - Catalog';
        opp1.StageName = 'Prospecting'; 
        opp1.CloseDate = Date.today().addDays(1);
        opp1.AccountId = account1.Id;
        opp1.Amount=10000000;
        opp1.Primary_Competitor1_DonotInUse__c = 'comp1';
        //system.debug('opp '+ opp1);
        insert opp1;


    }
    
    static TestMethod void test_agreementPublishingJob(){
        init();
        
        CameleonCPQ__QxQuote__c testQuote1 = new CameleonCPQ__QxQuote__c(Name='TEST 1',OpportunityId__c=opp1.Id,CameleonCPQ__Status__c='Draft', Core_Id__c ='1234');
        insert testQuote1;
        CameleonCPQ__QxQuote__c testQuote2 = new CameleonCPQ__QxQuote__c(Name='TEST 2',OpportunityId__c=opp1.Id,CameleonCPQ__Status__c='Fully Approved',PROSAgreement__AgreementStatus__c='Drafting', Core_Id__c ='1234');
        insert testQuote2;
        CameleonCPQ__QxQuote__c testQuote3 = new CameleonCPQ__QxQuote__c(Name='TEST 3',OpportunityId__c=opp1.Id,CameleonCPQ__Status__c='Fully Approved',PROSAgreement__AgreementStatus__c='Drafting', Core_Id__c ='1234');
        insert testQuote3;

        
        String hour = String.valueOf(Datetime.now().hour());
        String min = String.valueOf(Datetime.now().minute()); 
        String ss = String.valueOf(Datetime.now().second());
        //parse to cron expression
        String nextFireTime = ss + ' ' + min + ' ' + hour + ' * * ?';
        
        Test.startTest();
        CameleonCPQ.QxHttpCalloutMockImpl theMock = new CameleonCPQ.QxHttpCalloutMockImpl();
        Test.setMock(HttpCalloutMock.class, theMock); 
        CameleonCPQ.QxHttpCalloutMockImpl.setAsMock();
        QxCPQPublishingJob jobScheduler = new QxCPQPublishingJob();
        System.schedule('Test CPQ Qx Publishing Job', nextFireTime, jobScheduler);
        Test.stopTest();
        
    }
}
/*
 * Copyright (c) 2018 by PROS, Inc.  All Rights Reserved.
 * This software is the confidential and proprietary information of
 * PROS, Inc. ("Confidential Information").
 * You may not disclose such Confidential Information, and may only
 * use such Confidential Information in accordance with the terms of
 * the license agreement you entered into with PROS.
 *
 *
 *@author : Romain Derval
 */
@isTest
public class QxCPQQuoteTest {
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
    
    static TestMethod void test_handleBeforeInsert_primaryQuote_1(){
        init();
        Test.startTest(); 
        
        CameleonCPQ__QxQuote__c testQuote1 = new CameleonCPQ__QxQuote__c(Name='TEST 1',OpportunityId__c=opp1.Id,Primary_Quote__c = true);
		insert testQuote1;
        CameleonCPQ__QxQuote__c resultTestQuote1 = [SELECT Id,Name,Primary_Quote__c FROM CameleonCPQ__QxQuote__c WHERE Id=:testQuote1.Id];
        System.assertEquals(true, resultTestQuote1.Primary_Quote__c, 'Primary Quote Flag should be checked');

        CameleonCPQ__QxQuote__c testQuote2 = new CameleonCPQ__QxQuote__c(Name='TEST 2',OpportunityId__c=opp1.Id);
		insert testQuote2;
        resultTestQuote1 = [SELECT Id,Name,Primary_Quote__c FROM CameleonCPQ__QxQuote__c WHERE Id=:testQuote1.Id];
        System.assertEquals(true, resultTestQuote1.Primary_Quote__c, 'Primary Quote Flag should be checked');
        CameleonCPQ__QxQuote__c resultTestQuote2 = [SELECT Id,Name,Primary_Quote__c FROM CameleonCPQ__QxQuote__c WHERE Id=:testQuote2.Id];
        System.assertEquals(false, resultTestQuote2.Primary_Quote__c, 'Primary Quote Flag should be unchecked');
        
        CameleonCPQ__QxQuote__c testQuote3 = new CameleonCPQ__QxQuote__c(Name='TEST 3',OpportunityId__c=opp1.Id, Primary_Quote__c=true);
        insert testQuote3;        
        resultTestQuote1 = [SELECT Id,Name,Primary_Quote__c FROM CameleonCPQ__QxQuote__c WHERE Id=:testQuote1.Id];
        System.assertEquals(false, resultTestQuote1.Primary_Quote__c, 'Primary Quote Flag should be unchecked');
         resultTestQuote2 = [SELECT Id,Name,Primary_Quote__c FROM CameleonCPQ__QxQuote__c WHERE Id=:testQuote2.Id];
        System.assertEquals(false, resultTestQuote2.Primary_Quote__c, 'Primary Quote Flag should be unchecked');
        CameleonCPQ__QxQuote__c resultTestQuote3 = [SELECT Id,Name,Primary_Quote__c FROM CameleonCPQ__QxQuote__c WHERE Id=:testQuote3.Id];
        System.assertEquals(true, resultTestQuote3.Primary_Quote__c, 'Primary Quote Flag should be checked');


        
        Test.stopTest();
    }
    
    static TestMethod void test_handleBeforeInsert_primaryQuote_2(){
        init();
        Test.startTest(); 
        CameleonCPQ__QxQuote__c testQuote1 = new CameleonCPQ__QxQuote__c(Name='TEST 1',OpportunityId__c=opp1.Id,CameleonCPQ__Status__c='Accepted');
		insert testQuote1;
        CameleonCPQ__QxQuote__c resultTestQuote1 = [SELECT Id,Name,Primary_Quote__c FROM CameleonCPQ__QxQuote__c WHERE Id=:testQuote1.Id];
       // System.assertEquals(true, resultTestQuote1.Primary_Quote__c, 'Primary Quote Flag should be checked');

        Boolean expectedExceptionThrown = false;
		try{
            CameleonCPQ__QxQuote__c testQuote2 = new CameleonCPQ__QxQuote__c(Name='TEST 3',OpportunityId__c=opp1.Id, Primary_Quote__c=true);
            insert testQuote2;      
            throw new MyException('An exception should have been thrown, cannot insert primary quote');
        }catch(Exception e){
            expectedExceptionThrown =  e.getMessage().contains(QxCPQQuoteHelper.ERROR_MSG_FLAG_WITH_ACCEPTED_PRIMARY_QUOTE) ? true : false;           
        }finally{
            System.AssertEquals(expectedExceptionThrown, false);
        }

        
        Test.stopTest();
    }
    
    static TestMethod void test_handleBeforeUpdate_primaryQuote_1(){
        init();
        Test.startTest(); 
        CameleonCPQ__QxQuote__c testQuote1 = new CameleonCPQ__QxQuote__c(Name='TEST 1',OpportunityId__c=opp1.Id);
		insert testQuote1;
        CameleonCPQ__QxQuote__c testQuote2 = new CameleonCPQ__QxQuote__c(Name='TEST 2',OpportunityId__c=opp1.Id);
        insert testQuote2;         
        CameleonCPQ__QxQuote__c resultTestQuote1 = [SELECT Id,Name,Primary_Quote__c FROM CameleonCPQ__QxQuote__c WHERE Id=:testQuote1.Id];
       // System.assertEquals(true, resultTestQuote1.Primary_Quote__c, 'Primary Quote Flag should be checked');
        CameleonCPQ__QxQuote__c resultTestQuote2 = [SELECT Id,Name,Primary_Quote__c FROM CameleonCPQ__QxQuote__c WHERE Id=:testQuote2.Id];
       // System.assertEquals(false, resultTestQuote2.Primary_Quote__c, 'Primary Quote Flag should be unchecked');
        
        //Flag  2nd quote a primary
        testQuote2.Primary_Quote__c = true;
        update testQuote2;
        resultTestQuote1 = [SELECT Id,Name,Primary_Quote__c FROM CameleonCPQ__QxQuote__c WHERE Id=:testQuote1.Id];
        System.assertEquals(false, resultTestQuote1.Primary_Quote__c, 'Primary Quote Flag should be unchecked');
        resultTestQuote2 = [SELECT Id,Name,Primary_Quote__c FROM CameleonCPQ__QxQuote__c WHERE Id=:testQuote2.Id];
        System.assertEquals(true, resultTestQuote2.Primary_Quote__c, 'Primary Quote Flag should be checked');
        
        
        //Try to unflag a quote
		Boolean expectedExceptionThrown = false;
		try{
            testQuote2.Primary_Quote__c = false;
            update testQuote2;  
            throw new MyException('An exception should have been thrown, cannot insert primary quote');
        }catch(Exception e){
            expectedExceptionThrown =  e.getMessage().contains(QxCPQQuoteHelper.ERROR_MSG_UNFLAG_PRIMARY_QUOTE) ? true : false;           
        }finally{
            System.AssertEquals(expectedExceptionThrown, false);
        }
        

        Test.stopTest();
    }
    
    static TestMethod void test_handleBeforeUpdate_primaryQuote_2(){
        init();
        Test.startTest(); 
        CameleonCPQ__QxQuote__c testQuote1 = new CameleonCPQ__QxQuote__c(Name='TEST 1',OpportunityId__c=opp1.Id,CameleonCPQ__Status__c='Accepted');
		insert testQuote1;
        CameleonCPQ__QxQuote__c testQuote2 = new CameleonCPQ__QxQuote__c(Name='TEST 2',OpportunityId__c=opp1.Id);
        insert testQuote2;         
        CameleonCPQ__QxQuote__c resultTestQuote1 = [SELECT Id,Name,Primary_Quote__c FROM CameleonCPQ__QxQuote__c WHERE Id=:testQuote1.Id];
       // System.assertEquals(true, resultTestQuote1.Primary_Quote__c, 'Primary Quote Flag should be checked');
        CameleonCPQ__QxQuote__c resultTestQuote2 = [SELECT Id,Name,Primary_Quote__c FROM CameleonCPQ__QxQuote__c WHERE Id=:testQuote2.Id];
       // System.assertEquals(false, resultTestQuote2.Primary_Quote__c, 'Primary Quote Flag should be unchecked');
        
        
        //Try to flag a quote with another accepted primary quote
        Boolean expectedExceptionThrown = false;
        try{
            testQuote2.Primary_Quote__c = true;
            update testQuote2;  
            throw new MyException('ERROR_MSG_FLAG_WITH_ACCEPTED_PRIMARY_QUOTE');
        }catch(Exception e){
            expectedExceptionThrown =  e.getMessage().contains(QxCPQQuoteHelper.ERROR_MSG_FLAG_WITH_ACCEPTED_PRIMARY_QUOTE) ? true : false;           
        }finally{
            System.AssertEquals(expectedExceptionThrown, false);
        }
        
        Test.stopTest();
    }
    
    static TestMethod void test_handleBeforeInsert_AccountLookUp_1(){
        init();
        Test.startTest(); 
        CameleonCPQ__QxQuote__c testQuote1 = new CameleonCPQ__QxQuote__c(Name='TEST 1',OpportunityId__c=opp1.Id,CameleonCPQ__Status__c='Accepted');
		insert testQuote1;   
        CameleonCPQ__QxQuote__c resultTestQuote1 = [SELECT Id,Name,Primary_Quote__c,CameleonCPQ__AccountId__c FROM CameleonCPQ__QxQuote__c WHERE Id=:testQuote1.Id];
        System.assertEquals(account1.Id, resultTestQuote1.CameleonCPQ__AccountId__c, 'Wrong Account Lookup at Quote Level');
 
        Test.stopTest();
    }  
    
    @isTest
    public static void cloneQuoteProcessTest(){
        
        init();
        
        Id RecordTypeIdQuote = [SELECT Id,Name,DeveloperName,sObjectType FROM RecordType 
                                WHERE sObjectType='CameleonCPQ__QxQuote__c' AND DeveloperName = 'Amendment_Written_Agreement'].Id;
        
        CameleonCPQ__QxSetup__c newSetup = new CameleonCPQ__QxSetup__c(Name=QX_SETUP_NAME,
                                                                       CameleonCPQ__QuoteModelName__c=QUOTE_MODEL_NAME,
                                                                       CameleonCPQ__MappingSetName__c=MAPPING_SET_NAME, 
                                                                       CameleonCPQ__LinesManagementPolicy__c=1);
        insert newSetup;
        
        String currentProfile = [SELECT Id,Name,Profile.Name FROM User WHERE Id = :UserInfo.getUserId()].Profile.Name;
        //insert new ProsCustomSettings__c(name='Sandbox'); 
        insert new  PROS_Access_Custom_Setting__c(Name = 'Hosted Flag_VIEW', Profiles__c = currentProfile);
        insert new  PROS_Access_Custom_Setting__c(Name = 'Draft_VIEW', Profiles__c = currentProfile);
        insert new  PROS_Access_Custom_Setting__c(Name = 'In Review_VIEW', Profiles__c = currentProfile);
        account1.State__c = 'WA';
        update account1;
        
        CameleonCPQ__QxQuote__c testQuote1 = new CameleonCPQ__QxQuote__c(Name='TEST 1',CameleonCPQ__AccountId__c = account1.Id);
		insert testQuote1;
        Test.startTest();
        
        QxCPQQuoteHelper.cloneQuoteProcess(testQuote1, testQuote1);
        Test.stopTest(); 
    }
    
    @isTest
    public static void hierarchyTest(){
         init();
        
        Id RecordTypeIdQuote = [SELECT Id,Name,DeveloperName,sObjectType FROM RecordType 
                                WHERE sObjectType='CameleonCPQ__QxQuote__c' AND DeveloperName = 'Amendment_Written_Agreement'].Id;
        
        CameleonCPQ__QxSetup__c newSetup = new CameleonCPQ__QxSetup__c(Name=QX_SETUP_NAME,
                                                                       CameleonCPQ__QuoteModelName__c=QUOTE_MODEL_NAME,
                                                                       CameleonCPQ__MappingSetName__c=MAPPING_SET_NAME, 
                                                                       CameleonCPQ__LinesManagementPolicy__c=1);
        insert newSetup;
        
        String currentProfile = [SELECT Id,Name,Profile.Name FROM User WHERE Id = :UserInfo.getUserId()].Profile.Name;
        //insert new ProsCustomSettings__c(name='Sandbox'); 
        insert new  PROS_Access_Custom_Setting__c(Name = 'Hosted Flag_VIEW', Profiles__c = currentProfile);
        insert new  PROS_Access_Custom_Setting__c(Name = 'Draft_VIEW', Profiles__c = currentProfile);
        insert new  PROS_Access_Custom_Setting__c(Name = 'In Review_VIEW', Profiles__c = currentProfile);
       
        account1.State__c = 'WA';
        account1.Written_Agreement__c = true;
        update account1;
        Account acc2 = new Account();
        Recordtype custAccRT = [Select id, Sobjecttype from recordtype where name = 'Customer' and Sobjecttype = 'Account']; 
        acc2 = new Account(Name='Test Account');
        acc2.RecordTypeId = custAccRT.Id; 
        // acc2.ParentId = masterAccount.Id;
        acc2.Hierarchy__c = 'P'; 
        acc2.State__c = 'WA';
        acc2.Written_Agreement__c = true;
        insert acc2; 
        
        Account acc3 = new Account();
        //Recordtype custAccRT = [Select id, Sobjecttype from recordtype where name = 'Customer' and Sobjecttype = 'Account']; 
        acc3 = new Account(Name='Test Account');
        acc3.RecordTypeId = custAccRT.Id; 
        // acc2.ParentId = masterAccount.Id;
        acc3.Hierarchy__c = 'GP'; 
        acc3.State__c = 'WA';
        acc3.Written_Agreement__c = true;
        insert acc3; 
        
        Account acc4 = new Account();
        //Recordtype custAccRT = [Select id, Sobjecttype from recordtype where name = 'Customer' and Sobjecttype = 'Account']; 
        acc4 = new Account(Name='Test Account');
        acc4.RecordTypeId = custAccRT.Id; 
        // acc2.ParentId = masterAccount.Id;
        acc4.Hierarchy__c = 'GG'; 
        insert acc4; 
       
        Test.startTest(); 
        
        account1.State__c = 'ND';
        update account1;
        CameleonCPQ__QxQuote__c testQuote1 = new CameleonCPQ__QxQuote__c(Name='TEST 1',CameleonCPQ__SyncStatus__c='COMPLETE',CameleonCPQ__AccountId__c = account1.Id);
		insert testQuote1;
        account1.Hierarchy__c = 'C';
        update account1;
        testQuote1.Default_Parent__c = acc2.Id;
        update testQuote1;
        
        testQuote1.CameleonCPQ__AccountId__c = acc2.Id;
        testQuote1.Default_Grandparent__c = acc3.Id;
        update testQuote1;
        
        Test.stopTest();
    }
    
     @isTest
    public static void computeContractTermsTest(){
        
        init();
        
        Id RecordTypeIdQuote = [SELECT Id,Name,DeveloperName,sObjectType FROM RecordType 
                                WHERE sObjectType='CameleonCPQ__QxQuote__c' AND DeveloperName = 'Amendment_Written_Agreement'].Id;
        
        CameleonCPQ__QxSetup__c newSetup = new CameleonCPQ__QxSetup__c(Name=QX_SETUP_NAME,
                                                                       CameleonCPQ__QuoteModelName__c=QUOTE_MODEL_NAME,
                                                                       CameleonCPQ__MappingSetName__c=MAPPING_SET_NAME, 
                                                                       CameleonCPQ__LinesManagementPolicy__c=1);
        insert newSetup;
        
        CameleonCPQ.QxHttpCalloutMockImpl theMock = new CameleonCPQ.QxHttpCalloutMockImpl();
        Test.setMock(HttpCalloutMock.class, theMock); 
        CameleonCPQ.QxHttpCalloutMockImpl.setAsMock();
        
        String currentProfile = [SELECT Id,Name,Profile.Name FROM User WHERE Id = :UserInfo.getUserId()].Profile.Name;
        //insert new ProsCustomSettings__c(name='Sandbox'); 
        insert new  PROS_Access_Custom_Setting__c(Name = 'Hosted Flag_VIEW', Profiles__c = currentProfile);
        insert new  PROS_Access_Custom_Setting__c(Name = 'Draft_VIEW', Profiles__c = currentProfile);
        insert new  PROS_Access_Custom_Setting__c(Name = 'In Review_VIEW', Profiles__c = currentProfile);
        
        Contract crt = new Contract();
        crt.AccountId = account1.Id;
        crt.Contract_Type__c = 'CBS';
        crt.Contract_Development_Negotiation_MGR__c = UserInfo.getUserId();
        crt.Contract_Lifecycle_Manager__c = UserInfo.getUserId();
        crt.primary__c = true;
        crt.Item_count_threshold_tier_To1__c = 20;
        crt.Item_count_threshold_tier_From1__c = 1;
        crt.Item_count_threshold_tier_Count1__c = 3;
        crt.Item_count_threshold_tier_To2__c = 100;
        crt.Item_count_threshold_tier_From2__c = 21;
        crt.Item_count_threshold_tier_Count2__c = 4;
        crt.Item_count_threshold_tier_To3__c = 500;
        crt.Item_count_threshold_tier_From3__c = 101;
        crt.Item_count_threshold_tier_Count3__c = 5;
        crt.Item_count_threshold_tier_To4__c = 100000;
        crt.Item_count_threshold_tier_From4__c = 501;
        crt.Item_count_threshold_tier_Count4__c = 6;
        crt.Is_there_a_Most_Favored_Customer_claus__c='Yes';
        crt.Contract_allow_for_dependent_pricing_rel__c='Yes';
        crt.Active_Contract__c = account1.Id;
        crt.Custom_pricing_should_not_be_more_or_les__c = 'Cannot be less';
        insert crt;
        
        account1.State__c = 'WA';
        update account1;
        
        CameleonCPQ__QxQuote__c testQuote1 = new CameleonCPQ__QxQuote__c(Deactivate_Validation_Rules__c=true, Name='TEST 1',Default_Account__c=account1.Id,CameleonCPQ__AccountId__c = account1.Id);
		insert testQuote1;
        
        Test.startTest();
        try{
        
        QxCPQQuoteHelper.changeParentLookup(testQuote1);
           
        QxCPQQuoteHelper.computeContractTerms(testQuote1);
    	 Account acc2 = new Account();
        Recordtype custAccRT = [Select id, Sobjecttype from recordtype where name = 'Customer' and Sobjecttype = 'Account']; 
        acc2 = new Account(Name='Test Account');
        acc2.RecordTypeId = custAccRT.Id; 
        // acc2.ParentId = masterAccount.Id;
        acc2.Hierarchy__c = 'P'; 
        acc2.State__c = 'WA';
        acc2.Written_Agreement__c = true;
        insert acc2; 
            crt.AccountId = acc2.Id;
            update crt;
            CameleonCPQ__QxQuote__c testQuote2 = new CameleonCPQ__QxQuote__c(Deactivate_Validation_Rules__c=true, Name='TEST 1',Default_Parent__c=acc2.Id,CameleonCPQ__AccountId__c = account1.Id);
		insert testQuote2;
            QxCPQQuoteHelper.computeContractTerms(testQuote2);
       Account acc3 = new Account();
        acc3 = new Account(Name='Test Account');
        acc3.RecordTypeId = custAccRT.Id; 
        // acc2.ParentId = masterAccount.Id;
        acc3.Hierarchy__c = 'GP'; 
        acc3.State__c = 'WA';
        acc3.Written_Agreement__c = true;
        insert acc3; 
             crt.AccountId = acc3.Id;
            update crt;
             CameleonCPQ__QxQuote__c testQuote3 = new CameleonCPQ__QxQuote__c(Deactivate_Validation_Rules__c=true, Name='TEST 1',Default_Grandparent__c=acc3.Id,CameleonCPQ__AccountId__c = account1.Id);
		insert testQuote3;
            QxCPQQuoteHelper.computeContractTerms(testQuote3);
             Account acc4 = new Account();
        acc4 = new Account(Name='Test Account');
        acc4.RecordTypeId = custAccRT.Id; 
        // acc2.ParentId = masterAccount.Id;
        acc4.Hierarchy__c = 'GGP'; 
        acc4.State__c = 'WA';
        acc4.Written_Agreement__c = true;
        insert acc4; 
             crt.AccountId = acc4.Id;
            update crt;
       
            CameleonCPQ__QxQuote__c testQuote4 = new CameleonCPQ__QxQuote__c(Deactivate_Validation_Rules__c=true, Name='TEST 1',Default_Great_Grandparent__c=acc4.Id,CameleonCPQ__AccountId__c = account1.Id);
		
        QxCPQQuoteHelper.computeContractTerms(testQuote4);
            QxCPQQuoteHelper.computeContractTerms(testQuote1);
        QxCPQQuoteHelper.setAgreementContractRecordType(crt.Id);
        QxCPQQuoteHelper.assignAmendmentValues(testQuote1);
            QxCPQQuoteHelper.createAgreementObject(testQuote1, true);
            insert testQuote4;
        }
        catch(Exception e){
            System.debug('Exception :'+e);
            System.debug('Exception :'+e.getStackTraceString());
            System.assertEquals(true, false, e);
        }
        Test.stopTest(); 
    }
    
    @isTest
    public static void processViolationsToDOATest(){
        init();
        
        Id RecordTypeIdQuote = [SELECT Id,Name,DeveloperName,sObjectType FROM RecordType 
                                WHERE sObjectType='CameleonCPQ__QxQuote__c' AND DeveloperName = 'Amendment_Written_Agreement'].Id;
        
        CameleonCPQ__QxSetup__c newSetup = new CameleonCPQ__QxSetup__c(Name=QX_SETUP_NAME,
                                                                       CameleonCPQ__QuoteModelName__c=QUOTE_MODEL_NAME,
                                                                       CameleonCPQ__MappingSetName__c=MAPPING_SET_NAME, 
                                                                       CameleonCPQ__LinesManagementPolicy__c=1);
        insert newSetup;
        
        String currentProfile = [SELECT Id,Name,Profile.Name FROM User WHERE Id = :UserInfo.getUserId()].Profile.Name;
        //insert new ProsCustomSettings__c(name='Sandbox'); 
        insert new  PROS_Access_Custom_Setting__c(Name = 'Hosted Flag_VIEW', Profiles__c = currentProfile);
        insert new  PROS_Access_Custom_Setting__c(Name = 'Draft_VIEW', Profiles__c = currentProfile);
        insert new  PROS_Access_Custom_Setting__c(Name = 'In Review_VIEW', Profiles__c = currentProfile);
        
        CameleonCPQ.QxHttpCalloutMockImpl theMock = new CameleonCPQ.QxHttpCalloutMockImpl();
        Test.setMock(HttpCalloutMock.class, theMock); 
        CameleonCPQ.QxHttpCalloutMockImpl.setAsMock();
        
         CameleonCPQ__QxQuote__c testQuote1 = new CameleonCPQ__QxQuote__c(Name='TEST 1',CameleonCPQ__AccountId__c = account1.Id,CameleonCPQ__Status__c = 'Approved');
		insert testQuote1;
        CameleonCPQ__QxQuoteLine__c cl = new CameleonCPQ__QxQuoteLine__c();
        cl.CameleonCPQ__LineTemplateId__c = 'ProductLineTemplate';
        cl.CameleonCPQ__QuoteId__c = testQuote1.id;
        cl.Customer_Comm__c = 'Notification and customer approval';
        cl.Change_Increases__c = 1;
        cl.Change_Decreases__c = 1;
        cl.Change_Addition__c = 1;
        cl.Change_Deletion__c = 1;
        insert cl;
        CameleonCPQ__QxQuoteLine__c cl2 = new CameleonCPQ__QxQuoteLine__c();
        cl2.CameleonCPQ__LineTemplateId__c = 'ComplianceViolationLT';
        cl2.CameleonCPQ__QuoteId__c = testQuote1.id;
        cl2.Violation_Requirement__c = 'Yes';
        cl2.Violation_Count__c =1;
        cl2.RecordTypeId = Schema.SObjectType.CameleonCPQ__QxQuoteLine__c.getRecordTypeInfosByName().get('CPT').getRecordTypeId();
        insert cl2;
        
        testQuote1.CameleonCPQ__SyncStatus__c = 'COMPLETE';
        
        update testQuote1;
    }

    static TestMethod void test_StatusUpdate1(){
        init();
         
        Test.startTest();
        CameleonCPQ.QxHttpCalloutMockImpl theMock = new CameleonCPQ.QxHttpCalloutMockImpl();
        Test.setMock(HttpCalloutMock.class, theMock); 
        CameleonCPQ.QxHttpCalloutMockImpl.setAsMock();
        
        
        CameleonCPQ__QxQuote__c testQuote1 = new CameleonCPQ__QxQuote__c(Name='TEST 1',CameleonCPQ__Status__c='Draft',OpportunityId__c=opp1.Id,Primary_Quote__c = true,CameleonCPQ__SyncStatus__c='COMPLETE',CameleonCPQ__ExternalQuoteId__c='ddd9e33a-456b-43b4-b5a7-51ca3afe8c98');
		insert testQuote1;

        CameleonCPQ__QxQuote__c resultTestQuote1 = [SELECT Id,Name,CameleonCPQ__Status__c,Primary_Quote__c,OpportunityId__c,CameleonCPQ__SyncStatus__c,CameleonCPQ__ExternalQuoteId__c FROM CameleonCPQ__QxQuote__c WHERE Id=:testQuote1.Id];
		//System.assertEquals('ddd9e33a-456b-43b4-b5a7-51ca3afe8c98', resultTestQuote1.CameleonCPQ__ExternalQuoteId__c, 'Wrong Filename');
        resultTestQuote1.CameleonCPQ__Status__c = 'In Review Internally';
		update resultTestQuote1;
        resultTestQuote1 = [SELECT Id,Name,CameleonCPQ__Status__c,Primary_Quote__c,OpportunityId__c,CameleonCPQ__SyncStatus__c,CameleonCPQ__ExternalQuoteId__c FROM CameleonCPQ__QxQuote__c WHERE Id=:testQuote1.Id];
		resultTestQuote1.CameleonCPQ__Status__c = 'Approved Internally';
		update resultTestQuote1;
        resultTestQuote1 = [SELECT Id,Name,CameleonCPQ__Status__c,Primary_Quote__c,OpportunityId__c,CameleonCPQ__SyncStatus__c,CameleonCPQ__ExternalQuoteId__c FROM CameleonCPQ__QxQuote__c WHERE Id=:testQuote1.Id];
        resultTestQuote1.Go_live_Date__c = Date.today().addDays(5);
        update resultTestQuote1;
        resultTestQuote1 = [SELECT Id,Name,CameleonCPQ__Status__c,Primary_Quote__c,OpportunityId__c,CameleonCPQ__SyncStatus__c,CameleonCPQ__ExternalQuoteId__c FROM CameleonCPQ__QxQuote__c WHERE Id=:testQuote1.Id];
        resultTestQuote1.CameleonCPQ__Status__c = 'Fully Approved';
		update resultTestQuote1;

        
        Test.stopTest();
    }
    
    static TestMethod void test_reportGen1(){
        init();
        CameleonCPQ__QxQuote__c testQuote1 = new CameleonCPQ__QxQuote__c(Name='TEST 1',CameleonCPQ__Status__c='Draft',OpportunityId__c=opp1.Id,Primary_Quote__c = true,CameleonCPQ__SyncStatus__c='COMPLETE',CameleonCPQ__ExternalQuoteId__c='ddd9e33a-456b-43b4-b5a7-51ca3afe8c98');
		insert testQuote1;

        CameleonCPQ__QxQuote__c resultTestQuote1 = [SELECT Id,Name,CameleonCPQ__Status__c,Primary_Quote__c,OpportunityId__c,CameleonCPQ__SyncStatus__c,CameleonCPQ__ExternalQuoteId__c FROM CameleonCPQ__QxQuote__c WHERE Id=:testQuote1.Id];
		 
        Test.startTest();
        CameleonCPQ.QxHttpCalloutMockImpl theMock = new CameleonCPQ.QxHttpCalloutMockImpl();
        Test.setMock(HttpCalloutMock.class, theMock); 
        CameleonCPQ.QxHttpCalloutMockImpl.setAsMock();
        
        

		String sessionId = 'test session id';
        String quoteId = resultTestQuote1.Id;
        CameleonCPQ.QxApiClient.GenerateQuoteReportResponse response = new CameleonCPQ.QxApiClient.GenerateQuoteReportResponse ();
		response = QxVFGenerateReportController.createReport(sessionId,quoteId, 'Customer Copy');
		CameleonCPQ.QxApiClient.GetQuoteReportStatusResponse gqrStatusResponse = QxVFGenerateReportController.getReportStatus(sessionId, quoteId, response.reportId);
		CameleonCPQ.QxApiClient.GetQuoteReportResponse report = QxVFGenerateReportController.getQuoteReport(sessionId, quoteId, response.reportId);

		ContentVersion newContentVersion = QxVFGenerateReportController.createAttachment(Blob.valueOf('This test file content'),quoteId,'PDF','Customer Copy');
        QxVFGenerateReportController.createDocumentLink(quoteId,newContentVersion);
        
        Test.stopTest();
    }
    
    static TestMethod void send_Email_Test1(){
        init();
        CameleonCPQ__QxQuote__c testQuote1 = new CameleonCPQ__QxQuote__c(Name='TEST 1',CameleonCPQ__Status__c='Draft',OpportunityId__c=opp1.Id,Primary_Quote__c = true,CameleonCPQ__SyncStatus__c='COMPLETE',CameleonCPQ__ExternalQuoteId__c='ddd9e33a-456b-43b4-b5a7-51ca3afe8c98',Sales_Rep__c=UserInfo.getUserId());
		insert testQuote1;

        CameleonCPQ__QxQuote__c resultTestQuote1 = [SELECT Id,Name,CameleonCPQ__Status__c,Primary_Quote__c,OpportunityId__c,CameleonCPQ__SyncStatus__c,CameleonCPQ__ExternalQuoteId__c,Sales_Rep__c,Quote_Number__c,PricingAnalyst__c FROM CameleonCPQ__QxQuote__c WHERE Id=:testQuote1.Id];
		 
        Test.startTest();
		
        QxCPQQuoteHelper.sendStatusChangeEmail(resultTestQuote1);
        
        Test.stopTest();
    }
    
    
    public class MyException extends Exception {

	}
}
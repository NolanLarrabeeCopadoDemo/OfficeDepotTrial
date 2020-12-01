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
public class QxCPQAgreementTest {
	private static Account account1;
    private static Opportunity opp1;
    private static QxCPQQuoteTriggerHandler handler;
    
    private static String QUOTE_MODEL_NAME = 'OfficeDepot';
    private static String QX_SETUP_NAME = 'Master';
    private static String MAPPING_SET_NAME = 'New_Written_Agreement';
    private static String CONTEXT_DATA_PROVIDER_NAME = 'SfdcContext';   
    
    private static void init(){
        
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
        account1 = new Account(Name='Test Account', AOPS_Cust_Id__c='00123456');
        account1.RecordTypeId = custAccRT.Id; 
        account1.ParentId = masterAccount.Id; 
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

    static TestMethod void test_AgreementUpdate(){
        init();
        Test.startTest(); 
        
        CameleonCPQ__QxQuote__c testQuote1 = new CameleonCPQ__QxQuote__c(Name='TEST 1',OpportunityId__c=opp1.Id,Primary_Quote__c = true);
		insert testQuote1;
        CameleonCPQ__QxQuote__c resultTestQuote1 = [SELECT Id,Name,Primary_Quote__c FROM CameleonCPQ__QxQuote__c WHERE Id=:testQuote1.Id];
       
       PROS_Agreement__c agreement1 = new PROS_Agreement__c(Name='Ag 1',Quote__c=resultTestQuote1.Id,Active__c=false);
       PROS_Agreement__c agreement2 = new PROS_Agreement__c(Name='Ag 2',Quote__c=resultTestQuote1.Id,Active__c=true);
       PROS_Agreement__c agreement3 = new PROS_Agreement__c(Name='Ag 3',Quote__c=resultTestQuote1.Id,Active__c=false);
       insert agreement1;
       insert agreement2;
       insert agreement3;
       System.assertEquals(false, agreement1.Active__c, 'Wrong Active flag for current agreement');
       System.assertEquals(true,  agreement2.Active__c, 'Wrong Active flag for current agreement');
       System.assertEquals(false, agreement3.Active__c, 'Wrong Active flag for current agreement');
       agreement3.Active__c=true;
       update agreement3;
       PROS_Agreement__c currentTestAg = [SELECT Id,Name,Active__c FROM PROS_Agreement__c WHERE Id=:agreement1.Id];
       System.assertEquals(false, currentTestAg.Active__c, 'Wrong Active flag for current agreement');
       currentTestAg = [SELECT Id,Name,Active__c FROM PROS_Agreement__c WHERE Id=:agreement2.Id];
       System.assertEquals(false, currentTestAg.Active__c, 'Wrong Active flag for current agreement');
       currentTestAg = [SELECT Id,Name,Active__c FROM PROS_Agreement__c WHERE Id=:agreement3.Id];
       System.assertEquals(true,  currentTestAg.Active__c, 'Wrong Active flag for current agreement');
       Test.stopTest();       
   }
    
    static TestMethod void test_AgreementCreationCtrl(){
        init();
        Test.startTest(); 
        String result = '';
        CameleonCPQ__QxQuote__c testQuote1 = new CameleonCPQ__QxQuote__c(Name='TEST 1',OpportunityId__c=opp1.Id,CameleonCPQ__Status__c='Draft');
        insert testQuote1; 
        result = QxCPQAgreementCreationCtrl.createAgreement(testQuote1.id);
        CameleonCPQ__QxQuote__c resultTestQuote1 = [SELECT Id,Name,Primary_Quote__c,CameleonCPQ__AccountId__c FROM CameleonCPQ__QxQuote__c WHERE Id=:testQuote1.Id];
        System.AssertEquals(result, 'Core not generated and/or Customer AOPS Id not existing (Prospect)');
        
        CameleonCPQ__QxQuote__c testQuote2 = new CameleonCPQ__QxQuote__c(Name='TEST 2',OpportunityId__c=opp1.Id,CameleonCPQ__Status__c='Draft', Core_Id__c ='1234');
        insert testQuote2; 
        result = QxCPQAgreementCreationCtrl.createAgreement(testQuote2.id);
        System.AssertEquals(result, 'Quote must be Fully Approved to publish Agreement');
        
        CameleonCPQ__QxQuote__c testQuote3 = new CameleonCPQ__QxQuote__c(Name='TEST 1',OpportunityId__c=opp1.Id,CameleonCPQ__Status__c='Fully Approved', Core_Id__c ='1234');
        insert testQuote3; 
        result = QxCPQAgreementCreationCtrl.createAgreement(testQuote3.id);
        System.AssertEquals(result, 'OK');
        
        Test.stopTest();
        
    }
    
    static TestMethod void test_AgreementCustomCreationCtrl(){
        init();
        Test.startTest(); 
        
        CameleonCPQ__QxQuote__c testQuote1 = new CameleonCPQ__QxQuote__c(Name='TEST 1',OpportunityId__c=opp1.Id,Primary_Quote__c = true);
        insert testQuote1;
        CameleonCPQ__QxQuote__c resultTestQuote1 = [SELECT Id,Name,Primary_Quote__c FROM CameleonCPQ__QxQuote__c WHERE Id=:testQuote1.Id];
        
        PROS_Agreement__c agreement1 = new PROS_Agreement__c(Name='Ag 1',Quote__c=resultTestQuote1.Id,Active__c=true);
        insert agreement1;
        PROS_Agreement__c currentTestAg = [SELECT Id,Name,Active__c FROM PROS_Agreement__c WHERE Id=:agreement1.Id];
        QxCPQAgreementCustomActionCtrl newEmptyCtrl = new QxCPQAgreementCustomActionCtrl();
        ApexPages.StandardController sc = new ApexPages.StandardController(currentTestAg);
        QxCPQAgreementCustomActionCtrl newCtrl = new QxCPQAgreementCustomActionCtrl(sc);
        newCtrl.backtoQuote();
        newCtrl.publishAction();
        Test.stopTest();
        
    }
}
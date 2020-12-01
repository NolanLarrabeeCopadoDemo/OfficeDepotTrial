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
public class QxCPQQuoteLineItemTest {
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
        account1 = new Account(Name='Test Account');
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

	static TestMethod void test_assignQuoteType(){
        
        init();
        Test.startTest(); 
        
        CameleonCPQ__QxQuote__c testQuote1 = new CameleonCPQ__QxQuote__c(Name='TEST 1',OpportunityId__c=opp1.Id,Primary_Quote__c = true);
        insert testQuote1;
        
        CameleonCPQ__QxQuoteLine__c executiveSummaryLine = new CameleonCPQ__QxQuoteLine__c(Name='Test QLI 1', CameleonCPQ__LineTemplateId__c='ExecutiveSummaryLT', CameleonCPQ__QuoteId__c=testQuote1.Id);
        CameleonCPQ__QxQuoteLine__c complianceLine = new CameleonCPQ__QxQuoteLine__c(Name='Test QLI 2', CameleonCPQ__LineTemplateId__c='ComplianceLT', CameleonCPQ__QuoteId__c=testQuote1.Id);
        CameleonCPQ__QxQuoteLine__c rebateLine = new CameleonCPQ__QxQuoteLine__c(Name='Test QLI 3', CameleonCPQ__LineTemplateId__c='RebateLT', CameleonCPQ__QuoteId__c=testQuote1.Id);
        insert executiveSummaryLine;
        insert complianceLine;
        insert rebateLine;
        
        CameleonCPQ__QxQuoteLine__c resultTestQLI1 = [SELECT Id,Name,CameleonCPQ__LineTemplateId__c,Product_Quote__c,Executive_Summary_Quote__c FROM CameleonCPQ__QxQuoteLine__c WHERE Id=:executiveSummaryLine.Id];
        System.assertEquals(null, resultTestQLI1.Product_Quote__c, 'Wrong Look up assignment');
        System.assertEquals(testQuote1.Id, resultTestQLI1.Executive_Summary_Quote__c, 'Wrong Look up assignment');
        
        CameleonCPQ__QxQuoteLine__c resultTestQLI2 = [SELECT Id,Name,CameleonCPQ__LineTemplateId__c,Rebate_Quote__c,Compliance_Quote__c FROM CameleonCPQ__QxQuoteLine__c WHERE Id=:complianceLine.Id];
        System.assertEquals(null, resultTestQLI2.Rebate_Quote__c, 'Wrong Look up assignment');
        System.assertEquals(testQuote1.Id, resultTestQLI2.Compliance_Quote__c, 'Wrong Look up assignment');
        
        
        CameleonCPQ__QxQuoteLine__c resultTestQLI3 = [SELECT Id,Name,CameleonCPQ__LineTemplateId__c,Rebate_Quote__c,Compliance_Quote__c FROM CameleonCPQ__QxQuoteLine__c WHERE Id=:rebateLine.Id];
        System.assertEquals(null, resultTestQLI3.Compliance_Quote__c, 'Wrong Look up assignment');
        System.assertEquals(testQuote1.Id, resultTestQLI3.Rebate_Quote__c, 'Wrong Look up assignment');
        Test.stopTest();
	}
	
	static TestMethod void test_beforeUpdate(){
		
	init();
	Test.startTest(); 

	CameleonCPQ__QxQuote__c testQuote1 = new CameleonCPQ__QxQuote__c(Name='TEST 1',OpportunityId__c=opp1.Id,Primary_Quote__c = true);
	insert testQuote1;
	
	CameleonCPQ__QxQuoteLine__c testLine = new CameleonCPQ__QxQuoteLine__c(Name='Test QLI 1', CameleonCPQ__LineTemplateId__c='ComplianceViolationLT', CameleonCPQ__QuoteId__c=testQuote1.Id, Violation_Count__c=3);
	insert testLine;
	
	CameleonCPQ__QxQuoteLine__c resultTestQLI1 = [SELECT Id,Name,CameleonCPQ__LineTemplateId__c,Product_Quote__c,Executive_Summary_Quote__c,Violation_Count__c FROM CameleonCPQ__QxQuoteLine__c WHERE Id=:testLine.Id];
	System.assertEquals(3, resultTestQLI1.Violation_Count__c, 'Wrong Violation Count value');
	
	resultTestQLI1.Violation_Requirement__c = 'No';
	update resultTestQLI1;
	
	
	CameleonCPQ__QxQuoteLine__c resultTestQLI2 = [SELECT Id,Name,CameleonCPQ__LineTemplateId__c,Rebate_Quote__c,Compliance_Quote__c,Violation_Count__c FROM CameleonCPQ__QxQuoteLine__c WHERE Id=:resultTestQLI1.Id];
	System.assertEquals(null, resultTestQLI2.Violation_Count__c, 'Wrong Violation Count value');
	Test.stopTest();
	}

}
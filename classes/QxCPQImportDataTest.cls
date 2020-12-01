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
public class QxCPQImportDataTest {
private static Contract_Pricing_Terms__c cpt1;

private static void init(){
	cpt1 = new Contract_Pricing_Terms__c(Name='Office Supplies');
	//cpt1.Account_Level__c=	'Grand Parent';
	cpt1.Contract__c='80044000002NZPyAAO';
	cpt1.Effective_Date_of_this_language__c= Date.parse('11/1/2016');
	cpt1.Price_Incr_Cap_Type_Unit__c= '%';
	cpt1.Price_Incr_Cap_Amt__c= 50;
	cpt1.CC_Initial_Freeze_Period_in_days__c=365;
	cpt1.Department_Groups__c='All Except Paper & Toner';
	cpt1.Departments__c='08 - LIGHTING;13 - NOTETAKING;18 - SHRED/STORE SERVICES;22 - MARKETING SERVICES;23 - SAFETY, SECURITY, AND MEDICAL;26 - SEASONAL PRODUCTS;27 - SHREDDERS;41 - COMPUCOM SERVICES;45 - COMPUCOM SUB SERVICE;49 - ADMIN SERVICES;84 - CUST SUPPORT SUBS;87 - SOFTWARE AS A SERV;89 - TECH SERVICES SUB;88 - ESD SOFTWARE';
	cpt1.In_days__c=15;
	cpt1.CC_Prc_Chg_Notice_Reqd_days__c=15;
	cpt1.Comm_Req_CC_Price_Chg__c='Notification and customer approval';
	cpt1.Addition_communication_requirements__c='Notification only';
	cpt1.Deletion_communication_requirements__c='Notification only';
	cpt1.Vendor_Letter_Required_For_CC_Increase__c='Yes';
	cpt1.CC_Price_Incr_Capped__c='Needs validation';
	cpt1.Price_Incr_Cap_App_Level__c=null;
	insert cpt1;
}

    static TestMethod void test_buildJSON_1(){
        init();
        Test.startTest(); 
        
        Map<Id,String> customerNbs = new Map<Id,String>();
        Map<Id,String> customerNames = new Map<Id,String>();
        Map<Id,String> contractNbs = new Map<Id,String>();
        Map<Id,String> contractAccountLevels = new Map<Id,String>();
        customerNbs.put('80044000002NZPyAAO','999999999');
        customerNames.put('80044000002NZPyAAO','My Test Customer');
        contractNbs.put('80044000002NZPyAAO','000123456');
        contractAccountLevels.put('80044000002NZPyAAO','Grandparent');
        List<Contract_Pricing_Terms__c> cpts = new List<Contract_Pricing_Terms__c>();
        cpts.add(cpt1);
        
        String jsonString = QxCPQImportQuoteData.buildJsonFormat(cpts,customerNbs,customerNames,contractAccountLevels,contractNbs);
        
        System.assertNotEquals(null,jsonString,'Built JSON String should not be null');
        
        Test.stopTest();
        
    }
    
    static TestMethod void test_buildJSON_2(){
        init();
        Test.startTest(); 
        
        Map<Id,String> customerNbs = new Map<Id,String>();
        Map<Id,String> customerNames = new Map<Id,String>();
        Map<Id,String> contractNbs = new Map<Id,String>();
        Map<Id,String> contractAccountLevels = new Map<Id,String>();
        customerNbs.put('80044000002NZPyAAO','999999999');
        customerNames.put('80044000002NZPyAAO','My Test Customer');
        contractNbs.put('80044000002NZPyAAO','000123456');
        contractAccountLevels.put('80044000002NZPyAAO','Grandparent');
        List<Contract_Pricing_Terms__c> cpts = new List<Contract_Pricing_Terms__c>();
        cpts.add(cpt1);
        
        String jsonString = QxCPQQuoteHelper.buildJsonFormat(cpts,customerNbs,customerNames,contractAccountLevels,contractNbs);
        
        System.assertNotEquals(null,jsonString,'Built JSON String should not be null');
        
        Test.stopTest();
        
    }
}
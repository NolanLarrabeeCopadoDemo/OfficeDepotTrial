/*
created by Najma Ateeq for Story #S-386202(OD Case Number - 00617674)
*/
@isTest(seeAllData = true)
private class Test_Utils_TC {
    public static Account acc = new Account();
    public static Account siteAcc = new Account();
    public static Contact con = new Contact();
    public static  User u  = new User();
    public static  Opportunity opp = new Opportunity();
    static{
         acc = Test_Utils.CreateAccount();
         siteAcc = Test_Utils.CreateAccount('Site');
         con = Test_Utils.CreateContact(acc.Id);
         u = Test_Utils.CreateUser();
        try{
         opp = Test_Utils.CreateOpportunity(true,acc.Id);
        }
        catch (Exception e) {
            System.debug( 'Success!');
        }
        
    }
    
    
    static testMethod void myUnitTest() {
        
        test.startTest();
        
        Test_Utils.GenerateAccount();

        Test_Utils.Test_CreateGPOLead();
        Test_Utils.GenerateBasicTask();
        Test_Utils.CreateSalesDispositionTask(acc.Id);
        Test_Utils.CreateAccountForSalesHistory();
        Test_Utils.CreateAccountForProductData();
        Test_Utils.CreateAccountForRelatedAccount(acc.Id);
        Test_Utils.createTestSalesPerson(UserInfo.getUserId(), '1232');
        Test_Utils.getAggregateSiteAccountList(UserInfo.getUserId());
        
        //Test_Utils.createAccountAssignments(acc, 'PROSPECT','Open', 'Hello', false);//madhavi
        test.stoptest();

    } 
    
    static testMethod void myUnitTest0(){
        
        test.startTest();
        
        Test_Utils.CreateNote(con);
        Test_Utils.CreateContactWithAccountAndLastName(acc.Id,'test last name');
        Test_Utils.CreateContactForCheckDuplicate('test not dup',acc.Id,siteAcc.Id);
        Test_Utils.createContactSA(false);
        Test_Utils.createProspectSA(false);
        Test_Utils.CreateLead();
        Store__c store = new Store__c();
        Test_Utils.CreateLeadForUser(store);//madhavi
        Test_Utils.CreateLeadForConversion(acc);
        Test_Utils.CreateLeadForConversionGeneration(acc);//madhavi
        Test_Utils.CreateLeadForConversionWithoutAccount(u);//madhavi
        Test_Utils.GenerateLead('123123',10,'test','test lname', false);//madhavi
        Test_Utils.CreateOpportunityWithSiteAccountType(false,acc.Id,siteAcc);//madhavi
        //Test_Utils.CreateOpportunityWAccount(false,acc.Id);//madhavi
        
        test.stoptest();
        Test_Utils.CreateOpportunity(false);
        
        
    } 
    
    static testMethod void myUnitTest1() {
        
        test.startTest();
         Quote q = new quote();
         try{
           q = Test_Utils.createQuote(opp);
           Test_Utils.createQuoteLineItemCust(q);
        }
        catch (Exception e) {
            System.debug( 'Success!');
        }
       
        
        Test_Utils.createCadence();
        Test_Utils.createCase();
        Test_Utils.getTestUser('System Administrator','testOD9922@gmail.com','testOD9922');
        
       GPO_Template__c g = Test_Utils.createGPOTemplate('test temp', true);
       GPO_Group__c  gg = Test_Utils.createGPOGroup(g,acc,false);
       gg.Welcome_Title__c = 'test w t';
       insert gg;
       
       GPO_Group__c  gg1 = Test_Utils.createPrivateGPOGroup(g,acc,false,false);
       gg1.Welcome_Title__c = 'test w t';
       //insert gg1;
       
       Test_Utils.createGPOGroupDetail(gg ,'test',true);
       Test_Utils.createGPOCommunitycom2SetUp(g,false);
       Test_Utils.createGPOLead(acc,true);
       Test_Utils.createGPOLead_for_privgrp(acc,true);
       Test_Utils.Test_CreateGPOLead();
       Test_Utils.createGPOCommunitySetUp(g, false);
       Customer_Transition__c ct = Test_Utils.CreateCustomerTransaction(true,acc);
       Test_Utils.createSplitAccount(true,ct,acc);
       Test_Utils.createPricingTemplate();
       test.stoptest();
       
    }
     static testMethod void myUnitTest2() {
         
         test.startTest();
        //Test_Utils.CreateAssignmentRule();
        //User u = Test_Utils.CreateUser();
        Test_Utils.createTestUser('test','OD1293929');
        Test_Utils.createAccountTeamMember(acc,u);
        Test_Utils.createAccountTeamMemberForOverlays(acc,u.Id);
        Test_Utils.CreateOpportunityWAccountWithoutSite(false,acc.Id);
        Test_Utils.getUserWithContractDivisionRole();
        //Test_Utils.getUserWithEmergingChannelRole();
        Test_Utils.createTestSalesPersonNew(u.Id,'2323');
        Test_Utils.createAccountSetupReq(acc);
        Test_Utils.createStore();
        Test_Utils.getAccountRecordType('Site');
        test.stoptest();
        
    }
}
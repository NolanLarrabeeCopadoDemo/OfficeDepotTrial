@IsTest
private class EndlessAisleInternalApproval_TC {

    @TestSetup
    static void makeData() {
        List<User> usrs = [SELECT Id, FirstName, LastName, Job_Code_Level__c, IsActive, ManagerId
                            FROM User WHERE IsActive = true AND Profile.Name = 'System Administrator' AND Name != 'Salesforce' LIMIT 10];
        for(User usr : usrs) { usr.FirstName = ''; }

        usrs[0].LastName = 'Account Owner';
        usrs[1].LastName = 'Quote Owner';

        usrs[2].LastName = 'Quote Owner Manager';
        usrs[2].Job_Code_Level__c = 'Manager';
        usrs[3].LastName = 'Quote Owner Director';
        usrs[3].Job_Code_Level__c = 'Director';
        usrs[4].LastName = 'Quote Owner Senior Director';
        usrs[4].Job_Code_Level__c = 'Senior Director';
        usrs[5].LastName = 'Quote Owner VP';
        usrs[5].Job_Code_Level__c = 'VP';
        usrs[6].LastName = 'Shared SVP';
        usrs[6].Job_Code_Level__c = 'SVP';
        usrs[7].LastName = 'Account Owner Manager';
        usrs[7].Job_Code_Level__c = 'Manager';
        usrs[8].LastName = 'Account Owner Director';
        usrs[8].Job_Code_Level__c = 'Director';
        usrs[9].LastName = 'Account Owner VP';
        usrs[9].Job_Code_Level__c = 'VP';
        usrs[9].IsActive = true;

        usrs[1].ManagerId = usrs[2].Id; // Assign Quote Owner Manager.
        usrs[2].ManagerId = usrs[3].Id; // Assign the Quote Owner Director.
        usrs[3].ManagerId = usrs[4].Id; // Assign Quote Owner Senior Director.
        usrs[4].ManagerId = usrs[5].Id; // Assign Quote Owner VP.
        usrs[5].ManagerId = usrs[6].Id; // Assign Quote Owner SVP, same as Account Owner SVP.
        usrs[0].ManagerId = usrs[7].Id; // Assign the Account Owner Manager.
        usrs[7].ManagerId = usrs[8].Id; // Assign Account Owner Director.
        usrs[8].ManagerId = usrs[9].Id; // Assign Account Owner VP, skip Senior Director.
        usrs[9].ManagerId = usrs[6].Id; // Assign Account Owner SVP, same as Quote Owner SVP.
        update usrs;

        makeNonSetupObjectData();
    }

    @future
    static void makeNonSetupObjectData() {
        Id siteRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();
        User accOwner = [SELECT Id FROM User WHERE LastName = 'Account Owner'];
        User quoteOwner = [SELECT Id FROM User WHERE LastName = 'Quote Owner'];
        Account acc = new Account(Name='TestAcc1', OwnerId=accOwner.Id);
        insert acc;
        Account billToAcc = new Account(Name='BillToAcc', OwnerId=accOwner.Id, Related_Account__c=acc.Id);
        Account shipToAcc = new Account(Name='ShipToAcc', OwnerId=accOwner.Id, Related_Account__c=acc.Id, RecordTypeId=siteRecordTypeId);
        insert new List<Account> { billToAcc, shipToAcc };
        Opportunity opp = new Opportunity(Name='TestOpp1', StageName='Propose', CloseDate=Date.today(), Decision_Date__c=Date.today(), AccountId=acc.Id, Probability_Move_to_Verbal_Close__c='80% - 90%');
        insert opp;
        Id standardPBID = Test.getStandardPricebookId();
        Quote q = new Quote(Name='TestQuote1', Pricebook2Id=standardPBID, OpportunityId=opp.Id, OwnerId=quoteOwner.Id,
                            Bill_To_Account__c=billToAcc.Id, Ship_To_Account__c=shipToAcc.Id);
        insert q;
        Pricebook2 pBook = new Pricebook2(Name='Test');
        insert pBook;
        Product2 prod = new Product2(Name='Test');
        insert prod;
        PriceBookEntry pbEntry = new PriceBookEntry(UnitPrice=1, Pricebook2Id=standardPBID, Product2Id=prod.Id, UseStandardPrice=false, IsActive=true);
        insert pbEntry;
    }
    
    // Tests for getQuote function.
    @IsTest
    static void testGetQuote() {
        Quote q = [SELECT Id FROM Quote WHERE Name = 'TestQuote1'];

        Test.startTest();
        Quote retrievedQuote = EndlessAisleInternalApproval.getQuote(q.Id);
        Test.stopTest();

        q = [SELECT Id, QuoteNumber FROM Quote WHERE Name = 'TestQuote1'];

        System.assertEquals(q.Id, retrievedQuote.Id);
        System.assertEquals(q.QuoteNumber, retrievedQuote.QuoteNumber);
    }

    @IsTest
    static void testgetQuoteBadId() {
        boolean exceptionThrown = false;

        Test.startTest();
        try {
            Quote retrievedQuote = EndlessAisleInternalApproval.getQuote('abc');
        } catch(Exception e) {
            exceptionThrown = true;
        }
        Test.stopTest();

        System.assertEquals(true, exceptionThrown);
    }

    // Tests for getApprovalUser function.
    @IsTest
    static void testGetApprovalUsersSingleRuleMet() {
        Quote q = [SELECT Id FROM Quote WHERE Name = 'TestQuote1'];
        PriceBookEntry pbEntry = [SELECT Id FROM PriceBookEntry LIMIT 1];
        QuoteLineItem lineItem = new QuoteLineItem(QuoteId=q.Id, PricebookEntryId=pbEntry.Id, UnitPrice=2, Quantity=1);
        insert lineItem;
        Tech_Sales_Internal_Approval_Rule_Header__c rule = new Tech_Sales_Internal_Approval_Rule_Header__c(Rule_Name__c='Rule1', Approver__c='Quote Owner Manager', Active__c=true, Project__c = 'Tech Sale');
        insert rule;
        Tech_Sales_Int_Approval_Rule_Criteria__c criteria = new Tech_Sales_Int_Approval_Rule_Criteria__c(Criteria_Field__c='Price', Operator__c='Greater Than', Value__c=1, Tech_Sales_Internal_Approval_Rule_Header__c=rule.Id);
        insert criteria;

        Test.startTest();
        List<User> approvers = EndlessAisleInternalApproval.getApprovalUsers(q.Id);
        Test.stopTest();

        System.assertEquals(1, approvers.size());
        System.assertEquals('Quote Owner Manager', approvers[0].Name);
    }

    @IsTest
    static void testGetApprovalUsersBadId() {
        Tech_Sales_Internal_Approval_Rule_Header__c rule = new Tech_Sales_Internal_Approval_Rule_Header__c(Rule_Name__c='Rule1', Approver__c='Quote Owner Manager', Active__c=true, Project__c = 'Tech Sale');
        insert rule;
        Tech_Sales_Int_Approval_Rule_Criteria__c criteria = new Tech_Sales_Int_Approval_Rule_Criteria__c(Criteria_Field__c='Price', Operator__c='Greater Than', Value__c=1, Tech_Sales_Internal_Approval_Rule_Header__c=rule.Id);
        insert criteria;

        boolean exceptionThrown = false;
        Test.startTest();
        try {
            List<User> approvers = EndlessAisleInternalApproval.getApprovalUsers('abc');
        } catch(Exception e) {
            exceptionThrown = true;
        }
        Test.stopTest();

        System.assertEquals(true, exceptionThrown);
    }

    @IsTest
    static void testGetApprovalUsersMultipleRulesMet() {
        Quote q = [SELECT Id FROM Quote WHERE Name = 'TestQuote1'];
        PriceBookEntry pbEntry = [SELECT Id FROM PriceBookEntry LIMIT 1];
        QuoteLineItem lineItem = new QuoteLineItem(QuoteId=q.Id, PricebookEntryId=pbEntry.Id, UnitPrice=2.01, Quantity=1, Cost__c=2);
        insert lineItem;
        Tech_Sales_Internal_Approval_Rule_Header__c rule1 = new Tech_Sales_Internal_Approval_Rule_Header__c(Rule_Name__c='Rule1', Approver__c='Quote Owner Director', Active__c=true, Project__c = 'Tech Sale');
        Tech_Sales_Internal_Approval_Rule_Header__c rule2 = new Tech_Sales_Internal_Approval_Rule_Header__c(Rule_Name__c='Rule2', Approver__c='Account Owner Manager', Active__c=true, Project__c = 'Tech Sale');
        Tech_Sales_Internal_Approval_Rule_Header__c rule3 = new Tech_Sales_Internal_Approval_Rule_Header__c(Rule_Name__c='Rule3', Approver__c='Quote Owner VP', Active__c=true, Project__c = 'Tech Sale');
        insert new List<Tech_Sales_Internal_Approval_Rule_Header__c> { rule1, rule2, rule3 };
        Tech_Sales_Int_Approval_Rule_Criteria__c criteria1 = new Tech_Sales_Int_Approval_Rule_Criteria__c(Criteria_Field__c='Cost', Operator__c='Greater Than', Value__c=1, Tech_Sales_Internal_Approval_Rule_Header__c=rule1.Id);
        Tech_Sales_Int_Approval_Rule_Criteria__c criteria2 = new Tech_Sales_Int_Approval_Rule_Criteria__c(Criteria_Field__c='Quantity', Operator__c='Greater Than Or Equal To', Value__c=1, Tech_Sales_Internal_Approval_Rule_Header__c=rule2.Id);
        Tech_Sales_Int_Approval_Rule_Criteria__c criteria3 = new Tech_Sales_Int_Approval_Rule_Criteria__c(Criteria_Field__c='Margin Percentage', Operator__c='Less Than', Value__c=2.5, Tech_Sales_Internal_Approval_Rule_Header__c=rule3.Id);
        insert new List<Tech_Sales_Int_Approval_Rule_Criteria__c> { criteria1, criteria2, criteria3 };

        Test.startTest();
        List<User> approvers = EndlessAisleInternalApproval.getApprovalUsers(q.Id);
        Test.stopTest();

        System.assertEquals(3, approvers.size());
        System.assert(containsUser(approvers, 'Quote Owner Director'));
        System.assert(containsUser(approvers, 'Account Owner Manager'));
        System.assert(containsUser(approvers, 'Quote Owner VP'));
    }

    @IsTest
    static void testGetApprovalUsersRuleNotMet() {
        Quote q = [SELECT Id FROM Quote WHERE Name = 'TestQuote1'];
        PriceBookEntry pbEntry = [SELECT Id FROM PriceBookEntry LIMIT 1];
        QuoteLineItem lineItem = new QuoteLineItem(QuoteId=q.Id, PricebookEntryId=pbEntry.Id, UnitPrice=3.5, Quantity=1, Cost__c=2);
        insert lineItem;
        Tech_Sales_Internal_Approval_Rule_Header__c rule1 = new Tech_Sales_Internal_Approval_Rule_Header__c(Rule_Name__c='Rule1', Approver__c='Quote Owner Director', Active__c=true, Project__c = 'Tech Sale');
        Tech_Sales_Internal_Approval_Rule_Header__c rule2 = new Tech_Sales_Internal_Approval_Rule_Header__c(Rule_Name__c='Rule2', Approver__c='Account Owner Manager', Active__c=true, Project__c = 'Tech Sale');
        Tech_Sales_Internal_Approval_Rule_Header__c rule3 = new Tech_Sales_Internal_Approval_Rule_Header__c(Rule_Name__c='Rule3', Approver__c='Quote Owner VP', Active__c=true, Project__c = 'Tech Sale');
        insert new List<Tech_Sales_Internal_Approval_Rule_Header__c> { rule1, rule2, rule3 };
        Tech_Sales_Int_Approval_Rule_Criteria__c criteria1 = new Tech_Sales_Int_Approval_Rule_Criteria__c(Criteria_Field__c='Cost', Operator__c='Less Than Or Equal To', Value__c=2, Tech_Sales_Internal_Approval_Rule_Header__c=rule1.Id);
        Tech_Sales_Int_Approval_Rule_Criteria__c criteria2 = new Tech_Sales_Int_Approval_Rule_Criteria__c(Criteria_Field__c='Quantity', Operator__c='Greater Than', Value__c=1, Tech_Sales_Internal_Approval_Rule_Header__c=rule2.Id);
        Tech_Sales_Int_Approval_Rule_Criteria__c criteria3 = new Tech_Sales_Int_Approval_Rule_Criteria__c(Criteria_Field__c='Margin Amount', Operator__c='Greater Than Or Equal To', Value__c=1.5, Tech_Sales_Internal_Approval_Rule_Header__c=rule3.Id);
        insert new List<Tech_Sales_Int_Approval_Rule_Criteria__c> { criteria1, criteria2, criteria3 };

        Test.startTest();
        List<User> approvers = EndlessAisleInternalApproval.getApprovalUsers(q.Id);
        Test.stopTest();

        System.assertEquals(2, approvers.size());
        System.assert(containsUser(approvers, 'Quote Owner Director'));
        System.assert(!containsUser(approvers, 'Account Owner Manager'));
        System.assert(containsUser(approvers, 'Quote Owner VP'));
    }

    @IsTest
    static void testGetApprovalUsersNoRules() {
        Quote q = [SELECT Id FROM Quote WHERE Name = 'TestQuote1'];
        PriceBookEntry pbEntry = [SELECT Id FROM PriceBookEntry LIMIT 1];
        QuoteLineItem lineItem = new QuoteLineItem(QuoteId=q.Id, PricebookEntryId=pbEntry.Id, UnitPrice=2.01, Quantity=1, Cost__c=2);
        insert lineItem;

        Test.startTest();
        List<User> approvers = EndlessAisleInternalApproval.getApprovalUsers(q.Id);
        Test.stopTest();

        System.assertEquals(0, approvers.size());
    }

    @IsTest
    static void testGetApprovalUsersNonexistentAndInactiveUsers() {
        Quote q = [SELECT Id FROM Quote WHERE Name = 'TestQuote1'];
        PriceBookEntry pbEntry = [SELECT Id FROM PriceBookEntry LIMIT 1];
        QuoteLineItem lineItem = new QuoteLineItem(QuoteId=q.Id, PricebookEntryId=pbEntry.Id, UnitPrice=2.55, Quantity=1, Cost__c=2);
        insert lineItem;
        Tech_Sales_Internal_Approval_Rule_Header__c rule1 = new Tech_Sales_Internal_Approval_Rule_Header__c(Rule_Name__c='Rule1', Approver__c='Quote Owner Manager', Active__c=true, Project__c = 'Tech Sale');
        Tech_Sales_Internal_Approval_Rule_Header__c rule2 = new Tech_Sales_Internal_Approval_Rule_Header__c(Rule_Name__c='Rule2', Approver__c='Account Owner Manager', Active__c=true, Project__c = 'Tech Sale');
        Tech_Sales_Internal_Approval_Rule_Header__c rule3 = new Tech_Sales_Internal_Approval_Rule_Header__c(Rule_Name__c='Rule3', Approver__c='Account Owner Director', Active__c=true, Project__c = 'Tech Sale');
        Tech_Sales_Internal_Approval_Rule_Header__c rule4 = new Tech_Sales_Internal_Approval_Rule_Header__c(Rule_Name__c='Rule4', Approver__c='Account Owner Senior Director', Active__c=true, Project__c = 'Tech Sale');
        Tech_Sales_Internal_Approval_Rule_Header__c rule5 = new Tech_Sales_Internal_Approval_Rule_Header__c(Rule_Name__c='Rule5', Approver__c='Account Owner VP', Active__c=true, Project__c = 'Tech Sale');
        insert new List<Tech_Sales_Internal_Approval_Rule_Header__c> { rule1, rule2, rule3, rule4, rule5 };
        Tech_Sales_Int_Approval_Rule_Criteria__c criteria1 = new Tech_Sales_Int_Approval_Rule_Criteria__c(Criteria_Field__c='Cost', Operator__c='Greater Than', Value__c=1, Tech_Sales_Internal_Approval_Rule_Header__c=rule1.Id);
        Tech_Sales_Int_Approval_Rule_Criteria__c criteria2 = new Tech_Sales_Int_Approval_Rule_Criteria__c(Criteria_Field__c='Price', Operator__c='Greater Than', Value__c=1, Tech_Sales_Internal_Approval_Rule_Header__c=rule2.Id);
        Tech_Sales_Int_Approval_Rule_Criteria__c criteria3 = new Tech_Sales_Int_Approval_Rule_Criteria__c(Criteria_Field__c='Price', Operator__c='Greater Than', Value__c=1, Tech_Sales_Internal_Approval_Rule_Header__c=rule3.Id);
        Tech_Sales_Int_Approval_Rule_Criteria__c criteria4 = new Tech_Sales_Int_Approval_Rule_Criteria__c(Criteria_Field__c='Price', Operator__c='Greater Than', Value__c=1, Tech_Sales_Internal_Approval_Rule_Header__c=rule4.Id);
        Tech_Sales_Int_Approval_Rule_Criteria__c criteria5 = new Tech_Sales_Int_Approval_Rule_Criteria__c(Criteria_Field__c='Margin Percentage', Operator__c='Greater Than', Value__c=1, Tech_Sales_Internal_Approval_Rule_Header__c=rule5.Id);
        insert new List<Tech_Sales_Int_Approval_Rule_Criteria__c> { criteria1, criteria2, criteria3, criteria4 };

        Test.startTest();
        List<User> approvers = EndlessAisleInternalApproval.getApprovalUsers(q.Id);
        Test.stopTest();

        System.assertEquals(4, approvers.size());
        System.assert(containsUser(approvers, 'Quote Owner Manager'));
        System.assert(containsUser(approvers, 'Account Owner Manager'));
        System.assert(containsUser(approvers, 'Account Owner Director'));
        System.assert(!containsUser(approvers, 'Account Owner Senior Director'));
        //System.assert(!containsUser(approvers, 'Account Owner VP'));
    }

    @IsTest
    static void testGetApprovalUsersOverlappingUser() {
        Quote q = [SELECT Id FROM Quote WHERE Name = 'TestQuote1'];
        PriceBookEntry pbEntry = [SELECT Id FROM PriceBookEntry LIMIT 1];
        QuoteLineItem lineItem = new QuoteLineItem(QuoteId=q.Id, PricebookEntryId=pbEntry.Id, UnitPrice=2.01, Quantity=1, Cost__c=2);
        insert lineItem;
        Tech_Sales_Internal_Approval_Rule_Header__c rule1 = new Tech_Sales_Internal_Approval_Rule_Header__c(Rule_Name__c='Rule1', Approver__c='Quote Owner Director', Active__c=true, Project__c = 'Tech Sale');
        Tech_Sales_Internal_Approval_Rule_Header__c rule2 = new Tech_Sales_Internal_Approval_Rule_Header__c(Rule_Name__c='Rule2', Approver__c='Account Owner Director', Active__c=true, Project__c = 'Tech Sale');
        Tech_Sales_Internal_Approval_Rule_Header__c rule3 = new Tech_Sales_Internal_Approval_Rule_Header__c(Rule_Name__c='Rule3', Approver__c='Quote Owner SVP', Active__c=true, Project__c = 'Tech Sale');
        Tech_Sales_Internal_Approval_Rule_Header__c rule4 = new Tech_Sales_Internal_Approval_Rule_Header__c(Rule_Name__c='Rule4', Approver__c='Account Owner SVP', Active__c=true, Project__c = 'Tech Sale');
        insert new List<Tech_Sales_Internal_Approval_Rule_Header__c> { rule1, rule2, rule3, rule4 };
        Tech_Sales_Int_Approval_Rule_Criteria__c criteria1 = new Tech_Sales_Int_Approval_Rule_Criteria__c(Criteria_Field__c='Cost', Operator__c='Greater Than', Value__c=1, Tech_Sales_Internal_Approval_Rule_Header__c=rule1.Id);
        Tech_Sales_Int_Approval_Rule_Criteria__c criteria2 = new Tech_Sales_Int_Approval_Rule_Criteria__c(Criteria_Field__c='Price', Operator__c='Greater Than', Value__c=1, Tech_Sales_Internal_Approval_Rule_Header__c=rule2.Id);
        Tech_Sales_Int_Approval_Rule_Criteria__c criteria3 = new Tech_Sales_Int_Approval_Rule_Criteria__c(Criteria_Field__c='Price', Operator__c='Greater Than', Value__c=1, Tech_Sales_Internal_Approval_Rule_Header__c=rule3.Id);
        Tech_Sales_Int_Approval_Rule_Criteria__c criteria4 = new Tech_Sales_Int_Approval_Rule_Criteria__c(Criteria_Field__c='Margin Percentage', Operator__c='Less Than', Value__c=5, Tech_Sales_Internal_Approval_Rule_Header__c=rule4.Id);
        insert new List<Tech_Sales_Int_Approval_Rule_Criteria__c> { criteria1, criteria2, criteria3, criteria4 };

        Test.startTest();
        List<User> approvers = EndlessAisleInternalApproval.getApprovalUsers(q.Id);
        Test.stopTest();

        System.assertEquals(3, approvers.size());
        System.assert(containsUser(approvers, 'Quote Owner Director'));
        System.assert(containsUser(approvers, 'Account Owner Director'));
        System.assert(containsUser(approvers, 'Shared SVP'));
    }

    @IsTest
    static void testGetApprovalUsersOverlappingRules() {
        Quote q = [SELECT Id FROM Quote WHERE Name = 'TestQuote1'];
        PriceBookEntry pbEntry = [SELECT Id FROM PriceBookEntry LIMIT 1];
        QuoteLineItem lineItem = new QuoteLineItem(QuoteId=q.Id, PricebookEntryId=pbEntry.Id, UnitPrice=2.01, Quantity=1, Cost__c=2);
        insert lineItem;
        Tech_Sales_Internal_Approval_Rule_Header__c rule1 = new Tech_Sales_Internal_Approval_Rule_Header__c(Rule_Name__c='Rule1', Approver__c='Quote Owner Director', Active__c=true, Project__c = 'Tech Sale');
        Tech_Sales_Internal_Approval_Rule_Header__c rule2 = new Tech_Sales_Internal_Approval_Rule_Header__c(Rule_Name__c='Rule2', Approver__c='Quote Owner Director', Active__c=true, Project__c = 'Tech Sale');
        insert new List<Tech_Sales_Internal_Approval_Rule_Header__c> { rule1, rule2 };
        Tech_Sales_Int_Approval_Rule_Criteria__c criteria1 = new Tech_Sales_Int_Approval_Rule_Criteria__c(Criteria_Field__c='Cost', Operator__c='Greater Than', Value__c=1, Tech_Sales_Internal_Approval_Rule_Header__c=rule1.Id);
        Tech_Sales_Int_Approval_Rule_Criteria__c criteria2 = new Tech_Sales_Int_Approval_Rule_Criteria__c(Criteria_Field__c='Quantity', Operator__c='Less Than', Value__c=2, Tech_Sales_Internal_Approval_Rule_Header__c=rule2.Id);
        insert new List<Tech_Sales_Int_Approval_Rule_Criteria__c> { criteria1, criteria2 };

        Test.startTest();
        List<User> approvers = EndlessAisleInternalApproval.getApprovalUsers(q.Id);
        Test.stopTest();

        System.assertEquals(1, approvers.size());
        System.assert(containsUser(approvers, 'Quote Owner Director'));
    }

    @IsTest
    static void testGetApprovalUsersInactiveRule() {
        Quote q = [SELECT Id FROM Quote WHERE Name = 'TestQuote1'];
        PriceBookEntry pbEntry = [SELECT Id FROM PriceBookEntry LIMIT 1];
        QuoteLineItem lineItem = new QuoteLineItem(QuoteId=q.Id, PricebookEntryId=pbEntry.Id, UnitPrice=2.01, Quantity=1, Cost__c=2);
        insert lineItem;
        Tech_Sales_Internal_Approval_Rule_Header__c rule1 = new Tech_Sales_Internal_Approval_Rule_Header__c(Rule_Name__c='Rule1', Approver__c='Quote Owner Director', Active__c=true, Project__c = 'Tech Sale');
        Tech_Sales_Internal_Approval_Rule_Header__c rule2 = new Tech_Sales_Internal_Approval_Rule_Header__c(Rule_Name__c='Rule2', Approver__c='Account Owner Director', Active__c=false, Project__c = 'Tech Sale');
        Tech_Sales_Internal_Approval_Rule_Header__c rule3 = new Tech_Sales_Internal_Approval_Rule_Header__c(Rule_Name__c='Rule3', Approver__c='Quote Owner VP', Active__c=true, Project__c = 'Tech Sale');
        insert new List<Tech_Sales_Internal_Approval_Rule_Header__c> { rule1, rule2, rule3 };
        Tech_Sales_Int_Approval_Rule_Criteria__c criteria1 = new Tech_Sales_Int_Approval_Rule_Criteria__c(Criteria_Field__c='Cost', Operator__c='Greater Than', Value__c=1, Tech_Sales_Internal_Approval_Rule_Header__c=rule1.Id);
        Tech_Sales_Int_Approval_Rule_Criteria__c criteria2 = new Tech_Sales_Int_Approval_Rule_Criteria__c(Criteria_Field__c='Quantity', Operator__c='Greater Than Or Equal To', Value__c=1, Tech_Sales_Internal_Approval_Rule_Header__c=rule2.Id);
        Tech_Sales_Int_Approval_Rule_Criteria__c criteria3 = new Tech_Sales_Int_Approval_Rule_Criteria__c(Criteria_Field__c='Margin Percentage', Operator__c='Less Than', Value__c=5.5, Tech_Sales_Internal_Approval_Rule_Header__c=rule3.Id);
        insert new List<Tech_Sales_Int_Approval_Rule_Criteria__c> { criteria1, criteria2, criteria3 };

        Test.startTest();
        List<User> approvers = EndlessAisleInternalApproval.getApprovalUsers(q.Id);
        Test.stopTest();

        System.assertEquals(2, approvers.size());
        System.assert(containsUser(approvers, 'Quote Owner Director'));
        System.assert(containsUser(approvers, 'Quote Owner VP'));
    }

    @IsTest
    static void testGetApprovalUsersOrdering() {
        Endless_Aisle_Internal_Approver_Ordering__mdt metadata = [SELECT Id, Approver_1__c, Approver_2__c, Approver_3__c, Approver_4__c,
                                                            Approver_5__c, Approver_6__c, Approver_7__c, Approver_8__c, Approver_9__c,
                                                            Approver_10__c FROM Endless_Aisle_Internal_Approver_Ordering__mdt LIMIT 1];
        Quote q = [SELECT Id FROM Quote WHERE Name = 'TestQuote1'];
        PriceBookEntry pbEntry = [SELECT Id FROM PriceBookEntry LIMIT 1];
        QuoteLineItem lineItem = new QuoteLineItem(QuoteId=q.Id, PricebookEntryId=pbEntry.Id, UnitPrice=2.01, Quantity=1, Cost__c=2);
        insert lineItem;
        Tech_Sales_Internal_Approval_Rule_Header__c rule1 = new Tech_Sales_Internal_Approval_Rule_Header__c(Rule_Name__c='Rule1', Approver__c='Quote Owner Manager', Active__c=true, Project__c = 'Tech Sale');
        Tech_Sales_Internal_Approval_Rule_Header__c rule2 = new Tech_Sales_Internal_Approval_Rule_Header__c(Rule_Name__c='Rule2', Approver__c='Quote Owner Director', Active__c=true, Project__c = 'Tech Sale');
        Tech_Sales_Internal_Approval_Rule_Header__c rule3 = new Tech_Sales_Internal_Approval_Rule_Header__c(Rule_Name__c='Rule3', Approver__c='Quote Owner Senior Director', Active__c=true, Project__c = 'Tech Sale');
        Tech_Sales_Internal_Approval_Rule_Header__c rule4 = new Tech_Sales_Internal_Approval_Rule_Header__c(Rule_Name__c='Rule4', Approver__c='Quote Owner VP', Active__c=true, Project__c = 'Tech Sale');
        Tech_Sales_Internal_Approval_Rule_Header__c rule5 = new Tech_Sales_Internal_Approval_Rule_Header__c(Rule_Name__c='Rule5', Approver__c='Quote Owner SVP', Active__c=true, Project__c = 'Tech Sale');
        Tech_Sales_Internal_Approval_Rule_Header__c rule6 = new Tech_Sales_Internal_Approval_Rule_Header__c(Rule_Name__c='Rule6', Approver__c='Account Owner Manager', Active__c=true, Project__c = 'Tech Sale');
        Tech_Sales_Internal_Approval_Rule_Header__c rule7 = new Tech_Sales_Internal_Approval_Rule_Header__c(Rule_Name__c='Rule7', Approver__c='Account Owner Director', Active__c=true, Project__c = 'Tech Sale');
        Tech_Sales_Internal_Approval_Rule_Header__c rule8 = new Tech_Sales_Internal_Approval_Rule_Header__c(Rule_Name__c='Rule8', Approver__c='Account Owner SVP', Active__c=true, Project__c = 'Tech Sale');
        insert new List<Tech_Sales_Internal_Approval_Rule_Header__c> { rule1, rule2, rule3, rule4, rule5, rule6, rule7, rule8 };
        Tech_Sales_Int_Approval_Rule_Criteria__c criteria1 = new Tech_Sales_Int_Approval_Rule_Criteria__c(Criteria_Field__c='Cost', Operator__c='Greater Than', Value__c=1, Tech_Sales_Internal_Approval_Rule_Header__c=rule1.Id);
        Tech_Sales_Int_Approval_Rule_Criteria__c criteria2 = new Tech_Sales_Int_Approval_Rule_Criteria__c(Criteria_Field__c='Cost', Operator__c='Greater Than', Value__c=1, Tech_Sales_Internal_Approval_Rule_Header__c=rule2.Id);
        Tech_Sales_Int_Approval_Rule_Criteria__c criteria3 = new Tech_Sales_Int_Approval_Rule_Criteria__c(Criteria_Field__c='Cost', Operator__c='Greater Than', Value__c=1, Tech_Sales_Internal_Approval_Rule_Header__c=rule3.Id);
        Tech_Sales_Int_Approval_Rule_Criteria__c criteria4 = new Tech_Sales_Int_Approval_Rule_Criteria__c(Criteria_Field__c='Cost', Operator__c='Greater Than', Value__c=1, Tech_Sales_Internal_Approval_Rule_Header__c=rule4.Id);
        Tech_Sales_Int_Approval_Rule_Criteria__c criteria5 = new Tech_Sales_Int_Approval_Rule_Criteria__c(Criteria_Field__c='Cost', Operator__c='Greater Than', Value__c=1, Tech_Sales_Internal_Approval_Rule_Header__c=rule5.Id);
        Tech_Sales_Int_Approval_Rule_Criteria__c criteria6 = new Tech_Sales_Int_Approval_Rule_Criteria__c(Criteria_Field__c='Cost', Operator__c='Greater Than', Value__c=1, Tech_Sales_Internal_Approval_Rule_Header__c=rule6.Id);
        Tech_Sales_Int_Approval_Rule_Criteria__c criteria7 = new Tech_Sales_Int_Approval_Rule_Criteria__c(Criteria_Field__c='Cost', Operator__c='Greater Than', Value__c=1, Tech_Sales_Internal_Approval_Rule_Header__c=rule7.Id);
        Tech_Sales_Int_Approval_Rule_Criteria__c criteria8 = new Tech_Sales_Int_Approval_Rule_Criteria__c(Criteria_Field__c='Cost', Operator__c='Greater Than', Value__c=1, Tech_Sales_Internal_Approval_Rule_Header__c=rule8.Id);
        insert new List<Tech_Sales_Int_Approval_Rule_Criteria__c> { criteria1, criteria2, criteria3, criteria4, criteria5, criteria6, criteria7, criteria8 };

        Test.startTest();
        List<User> approvers = EndlessAisleInternalApproval.getApprovalUsers(q.Id);
        Test.stopTest();

        List<String> ordering = new List<String> { metadata.Approver_1__c, metadata.Approver_2__c, metadata.Approver_3__c, metadata.Approver_4__c,
                                    metadata.Approver_5__c, metadata.Approver_6__c, metadata.Approver_7__c, metadata.Approver_8__c,
                                    metadata.Approver_9__c, metadata.Approver_10__c };
        Integer quoteSvpIndex = ordering.indexOf('Quote Owner SVP');
        Integer accountSvpIndex = ordering.indexOf('Account Owner SVP');
        if(quoteSvpIndex != -1 && accountSvpIndex != -1) {
            Integer lastSvpIndex = quoteSvpIndex > accountSvpIndex ? quoteSvpIndex : accountSvpIndex;
            ordering.remove(lastSvpIndex);
        }
        Integer accountSeniorDirectorIndex = ordering.indexOf('Account Owner Senior Director');
        if(accountSeniorDirectorIndex != -1) { ordering.remove(accountSeniorDirectorIndex); }
        Integer accountVpIndex = ordering.indexOf('Account Owner VP');
        if(accountVpIndex != -1) { ordering.remove(accountVpIndex); }

        for(Integer i = 0; i < approvers.size(); i++) {
            if(ordering.get(i).contains('SVP')) {
                System.assertEquals('Shared SVP', approvers.get(i).Name);
            } else {
                System.assertEquals(ordering.get(i), approvers.get(i).Name);
            }
        }
    }

    @IsTest
    static void testGetApprovalUsersMultipleCriteriaMet() {
        Quote q = [SELECT Id FROM Quote WHERE Name = 'TestQuote1'];
        PriceBookEntry pbEntry = [SELECT Id FROM PriceBookEntry LIMIT 1];
        QuoteLineItem lineItem = new QuoteLineItem(QuoteId=q.Id, PricebookEntryId=pbEntry.Id, UnitPrice=2, Quantity=1);
        insert lineItem;
        Tech_Sales_Internal_Approval_Rule_Header__c rule = new Tech_Sales_Internal_Approval_Rule_Header__c(Rule_Name__c='Rule1', Approver__c='Quote Owner Manager', Active__c=true, Project__c = 'Tech Sale');
        insert rule;
        Tech_Sales_Int_Approval_Rule_Criteria__c criteria1 = new Tech_Sales_Int_Approval_Rule_Criteria__c(Criteria_Field__c='Price', Operator__c='Greater Than', Value__c=1, Tech_Sales_Internal_Approval_Rule_Header__c=rule.Id);
        Tech_Sales_Int_Approval_Rule_Criteria__c criteria2 = new Tech_Sales_Int_Approval_Rule_Criteria__c(Criteria_Field__c='Quantity', Operator__c='Greater Than Or Equal To', Value__c=1, Tech_Sales_Internal_Approval_Rule_Header__c=rule.Id);
        Tech_Sales_Int_Approval_Rule_Criteria__c criteria3 = new Tech_Sales_Int_Approval_Rule_Criteria__c(Criteria_Field__c='Cost', Operator__c='Less Than', Value__c=1000, Tech_Sales_Internal_Approval_Rule_Header__c=rule.Id);
        insert new List<Tech_Sales_Int_Approval_Rule_Criteria__c> { criteria1, criteria2, criteria3 };

        Test.startTest();
        List<User> approvers = EndlessAisleInternalApproval.getApprovalUsers(q.Id);
        Test.stopTest();

        System.assertEquals(1, approvers.size());
        System.assertEquals('Quote Owner Manager', approvers[0].Name);
    }

    @IsTest
    static void testGetApprovalUsersSomeCriteriaNotMet() {
        Quote q = [SELECT Id FROM Quote WHERE Name = 'TestQuote1'];
        PriceBookEntry pbEntry = [SELECT Id FROM PriceBookEntry LIMIT 1];
        QuoteLineItem lineItem = new QuoteLineItem(QuoteId=q.Id, PricebookEntryId=pbEntry.Id, UnitPrice=2, Quantity=1);
        insert lineItem;
        Tech_Sales_Internal_Approval_Rule_Header__c rule = new Tech_Sales_Internal_Approval_Rule_Header__c(Rule_Name__c='Rule1', Approver__c='Quote Owner Manager', Active__c=true, Project__c = 'Tech Sale');
        insert rule;
        Tech_Sales_Int_Approval_Rule_Criteria__c criteria1 = new Tech_Sales_Int_Approval_Rule_Criteria__c(Criteria_Field__c='Price', Operator__c='Greater Than', Value__c=1, Tech_Sales_Internal_Approval_Rule_Header__c=rule.Id);
        Tech_Sales_Int_Approval_Rule_Criteria__c criteria2 = new Tech_Sales_Int_Approval_Rule_Criteria__c(Criteria_Field__c='Quantity', Operator__c='Greater Than', Value__c=5, Tech_Sales_Internal_Approval_Rule_Header__c=rule.Id);
        Tech_Sales_Int_Approval_Rule_Criteria__c criteria3 = new Tech_Sales_Int_Approval_Rule_Criteria__c(Criteria_Field__c='Cost', Operator__c='Less Than', Value__c=1000, Tech_Sales_Internal_Approval_Rule_Header__c=rule.Id);
        insert new List<Tech_Sales_Int_Approval_Rule_Criteria__c> { criteria1, criteria2, criteria3 };

        Test.startTest();
        List<User> approvers = EndlessAisleInternalApproval.getApprovalUsers(q.Id);
        Test.stopTest();

        System.assertEquals(0, approvers.size());
    }

    private static boolean containsUser(List<User> usrs, String name) {
        for(User usr : usrs) {
            if(usr.Name == name) {
                return true;
            }
        }
        return false;
    }

    // Tests for getApprovalGroups function.
    @IsTest
    static void testGetApprovalGroupsSingleRuleMet() {
        Quote q = [SELECT Id FROM Quote WHERE Name = 'TestQuote1'];
        PriceBookEntry pbEntry = [SELECT Id FROM PriceBookEntry LIMIT 1];
        QuoteLineItem lineItem = new QuoteLineItem(QuoteId=q.Id, PricebookEntryId=pbEntry.Id, UnitPrice=2.01, Quantity=1, Cost__c=2);
        insert lineItem;
        Tech_Sales_Internal_Approval_Rule_Header__c rule = new Tech_Sales_Internal_Approval_Rule_Header__c(Rule_Name__c='Rule1', Approver__c='Procurement', Active__c=true, Project__c = 'Tech Sale');
        insert rule;
        Tech_Sales_Int_Approval_Rule_Criteria__c criteria = new Tech_Sales_Int_Approval_Rule_Criteria__c(Criteria_Field__c='Price', Operator__c='Less Than', Value__c=3, Tech_Sales_Internal_Approval_Rule_Header__c=rule.Id);
        insert criteria;

        Test.startTest();
        List<String> approvers = EndlessAisleInternalApproval.getApprovalGroups(q.Id);
        Test.stopTest();

        System.assertEquals(1, approvers.size());
        System.assertEquals('Procurement', approvers[0]);
    }

    @IsTest
    static void testGetApprovalGroupsBadId() {
        Tech_Sales_Internal_Approval_Rule_Header__c rule = new Tech_Sales_Internal_Approval_Rule_Header__c(Rule_Name__c='Rule1', Approver__c='Procurement', Active__c=true, Project__c = 'Tech Sale');
        insert rule;
        Tech_Sales_Int_Approval_Rule_Criteria__c criteria = new Tech_Sales_Int_Approval_Rule_Criteria__c(Criteria_Field__c='Price', Operator__c='Less Than', Value__c=3, Tech_Sales_Internal_Approval_Rule_Header__c=rule.Id);
        insert criteria;

        boolean exceptionThrown = false;
        Test.startTest();
        try {
            List<String> approvers = EndlessAisleInternalApproval.getApprovalGroups('abc');
        } catch(Exception e) {
            exceptionThrown = true;
        }
        Test.stopTest();

        System.assertEquals(true, exceptionThrown);
    }

    @IsTest
    static void testGetApprovalGroupsRuleNotMet() {
        Quote q = [SELECT Id FROM Quote WHERE Name = 'TestQuote1'];
        PriceBookEntry pbEntry = [SELECT Id FROM PriceBookEntry LIMIT 1];
        QuoteLineItem lineItem = new QuoteLineItem(QuoteId=q.Id, PricebookEntryId=pbEntry.Id, UnitPrice=2.01, Quantity=1, Cost__c=2);
        insert lineItem;
        Tech_Sales_Internal_Approval_Rule_Header__c rule = new Tech_Sales_Internal_Approval_Rule_Header__c(Rule_Name__c='Rule1', Approver__c='Procurement', Active__c=true, Project__c = 'Tech Sale');
        insert rule;
        Tech_Sales_Int_Approval_Rule_Criteria__c criteria = new Tech_Sales_Int_Approval_Rule_Criteria__c(Criteria_Field__c='Price', Operator__c='Greater Than', Value__c=3, Tech_Sales_Internal_Approval_Rule_Header__c=rule.Id);
        insert criteria;

        Test.startTest();
        List<String> approvers = EndlessAisleInternalApproval.getApprovalGroups(q.Id);
        Test.stopTest();

        System.assertEquals(0, approvers.size());
    }

    @IsTest
    static void testGetApprovalGroupsNoRules() {
        Quote q = [SELECT Id FROM Quote WHERE Name = 'TestQuote1'];
        PriceBookEntry pbEntry = [SELECT Id FROM PriceBookEntry LIMIT 1];
        QuoteLineItem lineItem = new QuoteLineItem(QuoteId=q.Id, PricebookEntryId=pbEntry.Id, UnitPrice=2.01, Quantity=1, Cost__c=2);
        insert lineItem;

        Test.startTest();
        List<String> approvers = EndlessAisleInternalApproval.getApprovalGroups(q.Id);
        Test.stopTest();

        System.assertEquals(0, approvers.size());
    }

    @IsTest
    static void testGetApprovalGroupsOverlappingRules() {
        Quote q = [SELECT Id FROM Quote WHERE Name = 'TestQuote1'];
        PriceBookEntry pbEntry = [SELECT Id FROM PriceBookEntry LIMIT 1];
        QuoteLineItem lineItem = new QuoteLineItem(QuoteId=q.Id, PricebookEntryId=pbEntry.Id, UnitPrice=2.01, Quantity=1, Cost__c=2);
        insert lineItem;
        Tech_Sales_Internal_Approval_Rule_Header__c rule1 = new Tech_Sales_Internal_Approval_Rule_Header__c(Rule_Name__c='Rule1', Approver__c='Procurement', Active__c=true, Project__c = 'Tech Sale');
        Tech_Sales_Internal_Approval_Rule_Header__c rule2 = new Tech_Sales_Internal_Approval_Rule_Header__c(Rule_Name__c='Rule2', Approver__c='Procurement', Active__c=true, Project__c = 'Tech Sale');
        insert new List<Tech_Sales_Internal_Approval_Rule_Header__c> { rule1, rule2 };
        Tech_Sales_Int_Approval_Rule_Criteria__c criteria1 = new Tech_Sales_Int_Approval_Rule_Criteria__c(Criteria_Field__c='Price', Operator__c='Greater Than', Value__c=1, Tech_Sales_Internal_Approval_Rule_Header__c=rule1.Id);
        Tech_Sales_Int_Approval_Rule_Criteria__c criteria2 = new Tech_Sales_Int_Approval_Rule_Criteria__c(Criteria_Field__c='Cost', Operator__c='Greater Than', Value__c=1, Tech_Sales_Internal_Approval_Rule_Header__c=rule2.Id);
        insert new List<Tech_Sales_Int_Approval_Rule_Criteria__c> { criteria1, criteria2 };

        Test.startTest();
        List<String> approvers = EndlessAisleInternalApproval.getApprovalGroups(q.Id);
        Test.stopTest();

        System.assertEquals(1, approvers.size());
        System.assertEquals('Procurement', approvers[0]);
    }

    @IsTest
    static void testGetApprovalGroupsInactiveRule() {
        Quote q = [SELECT Id FROM Quote WHERE Name = 'TestQuote1'];
        PriceBookEntry pbEntry = [SELECT Id FROM PriceBookEntry LIMIT 1];
        QuoteLineItem lineItem = new QuoteLineItem(QuoteId=q.Id, PricebookEntryId=pbEntry.Id, UnitPrice=2.01, Quantity=1, Cost__c=2);
        insert lineItem;
        Tech_Sales_Internal_Approval_Rule_Header__c rule = new Tech_Sales_Internal_Approval_Rule_Header__c(Rule_Name__c='Rule1', Approver__c='Procurement', Active__c=false, Project__c = 'Tech Sale');
        insert rule;
        Tech_Sales_Int_Approval_Rule_Criteria__c criteria = new Tech_Sales_Int_Approval_Rule_Criteria__c(Criteria_Field__c='Price', Operator__c='Greater Than', Value__c=1, Tech_Sales_Internal_Approval_Rule_Header__c=rule.Id);
        insert criteria;

        Test.startTest();
        List<String> approvers = EndlessAisleInternalApproval.getApprovalGroups(q.Id);
        Test.stopTest();

        System.assertEquals(0, approvers.size());
    }

    @IsTest
    static void testGetApprovalGroupsMultipleCriteriaMet() {
        Quote q = [SELECT Id FROM Quote WHERE Name = 'TestQuote1'];
        PriceBookEntry pbEntry = [SELECT Id FROM PriceBookEntry LIMIT 1];
        QuoteLineItem lineItem = new QuoteLineItem(QuoteId=q.Id, PricebookEntryId=pbEntry.Id, UnitPrice=2.01, Quantity=1, Cost__c=2);
        insert lineItem;
        Tech_Sales_Internal_Approval_Rule_Header__c rule = new Tech_Sales_Internal_Approval_Rule_Header__c(Rule_Name__c='Rule1', Approver__c='Procurement', Active__c=true, Project__c = 'Tech Sale');
        insert rule;
        Tech_Sales_Int_Approval_Rule_Criteria__c criteria1 = new Tech_Sales_Int_Approval_Rule_Criteria__c(Criteria_Field__c='Price', Operator__c='Less Than', Value__c=3, Tech_Sales_Internal_Approval_Rule_Header__c=rule.Id);
        Tech_Sales_Int_Approval_Rule_Criteria__c criteria2 = new Tech_Sales_Int_Approval_Rule_Criteria__c(Criteria_Field__c='Quantity', Operator__c='Less Than', Value__c=3, Tech_Sales_Internal_Approval_Rule_Header__c=rule.Id);
        Tech_Sales_Int_Approval_Rule_Criteria__c criteria3 = new Tech_Sales_Int_Approval_Rule_Criteria__c(Criteria_Field__c='Cost', Operator__c='Less Than', Value__c=1000, Tech_Sales_Internal_Approval_Rule_Header__c=rule.Id);
        insert new List<Tech_Sales_Int_Approval_Rule_Criteria__c> { criteria1, criteria2, criteria3 };

        Test.startTest();
        List<String> approvers = EndlessAisleInternalApproval.getApprovalGroups(q.Id);
        Test.stopTest();

        System.assertEquals(1, approvers.size());
        System.assertEquals('Procurement', approvers[0]);
    }

    @IsTest
    static void testGetApprovalGroupsSomeCriteriaNotMet() {
        Quote q = [SELECT Id FROM Quote WHERE Name = 'TestQuote1'];
        PriceBookEntry pbEntry = [SELECT Id FROM PriceBookEntry LIMIT 1];
        QuoteLineItem lineItem = new QuoteLineItem(QuoteId=q.Id, PricebookEntryId=pbEntry.Id, UnitPrice=2.01, Quantity=1, Cost__c=2);
        insert lineItem;
        Tech_Sales_Internal_Approval_Rule_Header__c rule = new Tech_Sales_Internal_Approval_Rule_Header__c(Rule_Name__c='Rule1', Approver__c='Procurement', Active__c=true, Project__c = 'Tech Sale');
        insert rule;
        Tech_Sales_Int_Approval_Rule_Criteria__c criteria1 = new Tech_Sales_Int_Approval_Rule_Criteria__c(Criteria_Field__c='Price', Operator__c='Less Than', Value__c=3, Tech_Sales_Internal_Approval_Rule_Header__c=rule.Id);
        Tech_Sales_Int_Approval_Rule_Criteria__c criteria2 = new Tech_Sales_Int_Approval_Rule_Criteria__c(Criteria_Field__c='Quantity', Operator__c='Greater Than', Value__c=3, Tech_Sales_Internal_Approval_Rule_Header__c=rule.Id);
        Tech_Sales_Int_Approval_Rule_Criteria__c criteria3 = new Tech_Sales_Int_Approval_Rule_Criteria__c(Criteria_Field__c='Cost', Operator__c='Less Than', Value__c=1000, Tech_Sales_Internal_Approval_Rule_Header__c=rule.Id);
        insert new List<Tech_Sales_Int_Approval_Rule_Criteria__c> { criteria1, criteria2, criteria3 };

        Test.startTest();
        List<String> approvers = EndlessAisleInternalApproval.getApprovalGroups(q.Id);
        Test.stopTest();

        System.assertEquals(0, approvers.size());
    }

    // Tests for initiateApprovalProcess function.
    @IsTest
    static void testInitiateApprovalProcessWithApprovers() {
        Quote q = [SELECT Id FROM Quote WHERE Name = 'TestQuote1'];
        PriceBookEntry pbEntry = [SELECT Id FROM PriceBookEntry LIMIT 1];
        QuoteLineItem lineItem = new QuoteLineItem(QuoteId=q.Id, PricebookEntryId=pbEntry.Id, UnitPrice=2.01, Quantity=1, Cost__c=2);
        insert lineItem;
        Tech_Sales_Internal_Approval_Rule_Header__c rule1 = new Tech_Sales_Internal_Approval_Rule_Header__c(Rule_Name__c='Rule1', Approver__c='Quote Owner Director', Active__c=true, Project__c = 'Tech Sale');
        Tech_Sales_Internal_Approval_Rule_Header__c rule2 = new Tech_Sales_Internal_Approval_Rule_Header__c(Rule_Name__c='Rule2', Approver__c='Account Owner Manager', Active__c=true, Project__c = 'Tech Sale');
        Tech_Sales_Internal_Approval_Rule_Header__c rule3 = new Tech_Sales_Internal_Approval_Rule_Header__c(Rule_Name__c='Rule3', Approver__c='Quote Owner VP', Active__c=true, Project__c = 'Tech Sale');
        Tech_Sales_Internal_Approval_Rule_Header__c rule4 = new Tech_Sales_Internal_Approval_Rule_Header__c(Rule_Name__c='Rule4', Approver__c='Procurement', Active__c=true, Project__c = 'Tech Sale');
        insert new List<Tech_Sales_Internal_Approval_Rule_Header__c> { rule1, rule2, rule3, rule4 };
        Tech_Sales_Int_Approval_Rule_Criteria__c criteria1 = new Tech_Sales_Int_Approval_Rule_Criteria__c(Criteria_Field__c='Cost', Operator__c='Greater Than', Value__c=1, Tech_Sales_Internal_Approval_Rule_Header__c=rule1.Id);
        Tech_Sales_Int_Approval_Rule_Criteria__c criteria2 = new Tech_Sales_Int_Approval_Rule_Criteria__c(Criteria_Field__c='Quantity', Operator__c='Greater Than Or Equal To', Value__c=1, Tech_Sales_Internal_Approval_Rule_Header__c=rule2.Id);
        Tech_Sales_Int_Approval_Rule_Criteria__c criteria3 = new Tech_Sales_Int_Approval_Rule_Criteria__c(Criteria_Field__c='Margin Percentage', Operator__c='Less Than', Value__c=2.5, Tech_Sales_Internal_Approval_Rule_Header__c=rule3.Id);
        Tech_Sales_Int_Approval_Rule_Criteria__c criteria4 = new Tech_Sales_Int_Approval_Rule_Criteria__c(Criteria_Field__c='Price', Operator__c='Less Than', Value__c=3, Tech_Sales_Internal_Approval_Rule_Header__c=rule4.Id);
        insert new List<Tech_Sales_Int_Approval_Rule_Criteria__c> { criteria1, criteria2, criteria3, criteria4 };

        Test.startTest();
        EndlessAisleInternalApproval.initiateApprovalProcess(q.Id);
        Test.stopTest();

        q = [SELECT Id, Internal_Approval_Allowed__c, Internal_Approval_Status__c, Status, Procurement__c, Approver_1__c, Approver_2__c,
                Approver_3__c, Approver_4__c, Approver_5__c, Approver_6__c, Approver_7__c, Approver_8__c, Approver_9__c, Approver_10__c
                FROM Quote WHERE Name = 'TestQuote1'];
        
        System.assertEquals(false, q.Internal_Approval_Allowed__c);
        System.assertEquals('Submitted', q.Internal_Approval_Status__c);
        System.assertEquals('In Review By OD', q.Status);
        System.assertEquals(true, q.Procurement__c);
        System.assertNotEquals(null, q.Approver_1__c);
        System.assertNotEquals(null, q.Approver_2__c);
        System.assertNotEquals(null, q.Approver_3__c);
        System.assertEquals(null, q.Approver_4__c);
        System.assertEquals(null, q.Approver_5__c);
        System.assertEquals(null, q.Approver_6__c);
        System.assertEquals(null, q.Approver_7__c);
        System.assertEquals(null, q.Approver_8__c);
        System.assertEquals(null, q.Approver_9__c);
        System.assertEquals(null, q.Approver_10__c);
    }

    @IsTest
    static void testInitiateApprovalProcessNoApprovers() {
        Quote q = [SELECT Id FROM Quote WHERE Name = 'TestQuote1'];
        PriceBookEntry pbEntry = [SELECT Id FROM PriceBookEntry LIMIT 1];
        QuoteLineItem lineItem = new QuoteLineItem(QuoteId=q.Id, PricebookEntryId=pbEntry.Id, UnitPrice=2.01, Quantity=1, Cost__c=2);
        insert lineItem;

        Test.startTest();
        EndlessAisleInternalApproval.initiateApprovalProcess(q.Id);
        Test.stopTest();

        q = [SELECT Id, Internal_Approval_Allowed__c, Internal_Approval_Status__c, Status, Procurement__c, Approver_1__c, Approver_2__c,
                Approver_3__c, Approver_4__c, Approver_5__c, Approver_6__c, Approver_7__c, Approver_8__c, Approver_9__c, Approver_10__c
                FROM Quote WHERE Name = 'TestQuote1'];
        
        System.assertEquals(false, q.Internal_Approval_Allowed__c);
        System.assertEquals('Approved', q.Internal_Approval_Status__c);
        System.assertEquals('Approved by OD', q.Status);
        System.assertEquals(false, q.Procurement__c);
        System.assertEquals(null, q.Approver_1__c);
        System.assertEquals(null, q.Approver_2__c);
        System.assertEquals(null, q.Approver_3__c);
        System.assertEquals(null, q.Approver_4__c);
        System.assertEquals(null, q.Approver_5__c);
        System.assertEquals(null, q.Approver_6__c);
        System.assertEquals(null, q.Approver_7__c);
        System.assertEquals(null, q.Approver_8__c);
        System.assertEquals(null, q.Approver_9__c);
        System.assertEquals(null, q.Approver_10__c);
    }

    @IsTest
    static void testInitiateApprovalProcessBadId() {
        boolean exceptionThrown = false;
        Test.startTest();
        try {
            EndlessAisleInternalApproval.initiateApprovalProcess('abc');
        } catch(Exception e) {
            exceptionThrown = true;
        }
        Test.stopTest();

        System.assertEquals(true, exceptionThrown);
    }
}
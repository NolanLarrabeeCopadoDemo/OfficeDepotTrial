@IsTest
private class CCPA_Process_Delete_Requests_Batch_TC {

    @TestSetup
    static void makeData() {
        Id prospectRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
        List<Account> accts = MyUtilsDataFactory.makeAccounts(4);
        for(Account acct : accts) { acct.RecordTypeId = prospectRecordTypeId; }
        insert accts;

        List<Contact> cntcts = MyUtilsDataFactory.makeContacts(3);
        cntcts[0].AccountId = accts[0].Id;
        cntcts[1].AccountId = accts[1].Id;
        cntcts[2].AccountId = accts[2].Id;
        insert cntcts;

        List<Lead> lds = MyUtilsDataFactory.makeLeads(4);
        insert lds;
    }
    
    @IsTest
    static void noActions() {
        Test.startTest();
        Database.executeBatch(new CCPA_Process_Delete_Requests_Batch(), 10);
        Test.stopTest();
    }

    @IsTest
    static void contactDeletions() {
        List<Contact> cntcts = [SELECT Id FROM Contact];
        CCPA_Request__c request1 = new CCPA_Request__c(Request_ID__c='111');
        insert request1;
        CCPA_Request__c request2 = new CCPA_Request__c(Request_ID__c='222');
        insert request2;
        CCPA_Action__c action1 = new CCPA_Action__c(CCPA_Request__c=request1.Id, Request_ID__c='111',
                                                    Key_Name__c='SFDC_CONTACT_PROSPECT', Key_Value__c=cntcts[1].Id);
        insert action1;
        CCPA_Action__c action2 = new CCPA_Action__c(CCPA_Request__c=request2.Id, Request_ID__c='222',
                                                    Key_Name__c='SFDC_CONTACT_PROSPECT', Key_Value__c=cntcts[2].Id);
        insert action2;

        Test.startTest();
        Database.executeBatch(new CCPA_Process_Delete_Requests_Batch(), 10);
        Test.stopTest();

        List<Contact> retrievedCntcts = [SELECT Id FROM Contact];
        System.assertEquals(1, retrievedCntcts.size());
        System.assertEquals(cntcts[0].Id, retrievedCntcts[0].Id);
    }

    @IsTest
    static void contactDeltionsExcludePortalUsers() {
        List<Contact> cntcts = [SELECT Id FROM Contact];
        Profile portalProfile = [SELECT Id FROM Profile WHERE Name = 'Partner Community User Custom' LIMIT 1];
        List<User> usrs = MyUtilsDataFactory.makeUsers(1);
        usrs[0].ProfileId = portalProfile.Id;
        usrs[0].ContactId = cntcts[1].Id;
        insert usrs;
        CCPA_Request__c request1 = new CCPA_Request__c(Request_ID__c='111');
        insert request1;
        CCPA_Request__c request2 = new CCPA_Request__c(Request_ID__c='222');
        insert request2;
        CCPA_Request__c request3 = new CCPA_Request__c(Request_ID__c='333');
        insert request3;
        CCPA_Action__c action1 = new CCPA_Action__c(CCPA_Request__c=request1.Id, Request_ID__c='111',
                                                    Key_Name__c='SFDC_CONTACT_PROSPECT', Key_Value__c=cntcts[0].Id);
        insert action1;
        CCPA_Action__c action2 = new CCPA_Action__c(CCPA_Request__c=request2.Id, Request_ID__c='222',
                                                    Key_Name__c='SFDC_CONTACT_PROSPECT', Key_Value__c=cntcts[1].Id);
        insert action2;
        CCPA_Action__c action3 = new CCPA_Action__c(CCPA_Request__c=request3.Id, Request_ID__c='333',
                                                    Key_Name__c='SFDC_CONTACT_PROSPECT', Key_Value__c=cntcts[2].Id);
        insert action3;

        Test.startTest();
        Database.executeBatch(new CCPA_Process_Delete_Requests_Batch(), 10);
        Test.stopTest();

        List<Contact> retrievedCntcts = [SELECT Id FROM Contact];
        System.assertEquals(1, retrievedCntcts.size());
        System.assertEquals(cntcts[1].Id, retrievedCntcts[0].Id);
    }

    @IsTest
    static void supportLinkedToContactDeletions() {
        Id supportRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Support').getRecordTypeId();
        List<Contact> cntcts = [SELECT Id FROM Contact];
        Case case1 = new Case(ContactId=cntcts[0].Id, RecordTypeId=supportRecordTypeId);
        Case case2 = new Case(ContactId=cntcts[1].Id, RecordTypeId=supportRecordTypeId);
        Case case3 = new Case(ContactId=cntcts[2].Id, RecordTypeId=supportRecordTypeId);
        insert new List<Case> { case1, case2, case3 };
        CCPA_Request__c request1 = new CCPA_Request__c(Request_ID__c='111');
        insert request1;
        CCPA_Request__c request2 = new CCPA_Request__c(Request_ID__c='222');
        insert request2;
        CCPA_Action__c action1 = new CCPA_Action__c(CCPA_Request__c=request1.Id, Request_ID__c='111',
                                                    Key_Name__c='SFDC_CONTACT_PROSPECT', Key_Value__c=cntcts[1].Id);
        insert action1;
        CCPA_Action__c action2 = new CCPA_Action__c(CCPA_Request__c=request2.Id, Request_ID__c='222',
                                                    Key_Name__c='SFDC_CONTACT_PROSPECT', Key_Value__c=cntcts[2].Id);
        insert action2;

        Test.startTest();
        Database.executeBatch(new CCPA_Process_Delete_Requests_Batch(), 10);
        Test.stopTest();

        List<Case> retrievedCases = [SELECT Id FROM Case];
        System.assertEquals(1, retrievedCases.size());
        System.assertEquals(case1.Id, retrievedCases[0].Id);
    }

    @IsTest
    static void leadDeletions() {
        List<Lead> lds = [SELECT Id FROM Lead];
        CCPA_Request__c request1 = new CCPA_Request__c(Request_ID__c='111');
        insert request1;
        CCPA_Request__c request2 = new CCPA_Request__c(Request_ID__c='222');
        insert request2;
        CCPA_Action__c action1 = new CCPA_Action__c(CCPA_Request__c=request1.Id, Request_ID__c='111',
                                                    Key_Name__c='SFDC_LEAD', Key_Value__c=lds[1].Id);
        insert action1;
        CCPA_Action__c action2 = new CCPA_Action__c(CCPA_Request__c=request2.Id, Request_ID__c='222',
                                                    Key_Name__c='SFDC_LEAD', Key_Value__c=lds[2].Id);
        insert action2;

        Test.startTest();
        Database.executeBatch(new CCPA_Process_Delete_Requests_Batch(), 10);
        Test.stopTest();

        List<Lead> retrievedLds = [SELECT Id FROM Lead];
        System.assertEquals(2, retrievedLds.size());
        System.assertEquals(false, containsLead(retrievedLds, lds[1]));
        System.assertEquals(false, containsLead(retrievedLds, lds[2]));
    }

    @IsTest
    static void leadStagingDeletions() {
        List<Lead> lds = [SELECT Id FROM Lead];
        LeadStaging__c leadStaging1 = new LeadStaging__c(CreatedLead__c=lds[0].Id);
        LeadStaging__c leadStaging2 = new LeadStaging__c(CreatedLead__c=lds[1].Id);
        LeadStaging__c leadStaging3 = new LeadStaging__c(CreatedLead__c=lds[2].Id);
        insert new List<LeadStaging__c> { leadStaging1, leadStaging2, leadStaging3 };
        CCPA_Request__c request1 = new CCPA_Request__c(Request_ID__c='111');
        insert request1;
        CCPA_Request__c request2 = new CCPA_Request__c(Request_ID__c='222');
        insert request2;
        CCPA_Action__c action1 = new CCPA_Action__c(CCPA_Request__c=request1.Id, Request_ID__c='111',
                                                    Key_Name__c='SFDC_LEAD', Key_Value__c=lds[1].Id);
        insert action1;
        CCPA_Action__c action2 = new CCPA_Action__c(CCPA_Request__c=request2.Id, Request_ID__c='222',
                                                    Key_Name__c='SFDC_LEAD', Key_Value__c=lds[2].Id);
        insert action2;

        Test.startTest();
        Database.executeBatch(new CCPA_Process_Delete_Requests_Batch(), 10);
        Test.stopTest();

        List<LeadStaging__c> retrievedLeadStaging = [SELECT Id FROM LeadStaging__c];
        System.assertEquals(1, retrievedLeadStaging.size());
        System.assertEquals(leadStaging1.Id, retrievedLeadStaging[0].Id);
    }

    @IsTest
    static void campaignMemberDeletions() {
        List<Contact> cntcts = [SELECT Id FROM Contact];
        List<Lead> lds = [SELECT Id FROM Lead];
        Campaign camp = new Campaign(Name='test');
        insert camp;
        CampaignMember campaignMem1 = new CampaignMember(ContactId=cntcts[0].Id, CampaignId=camp.Id);
        CampaignMember campaignMem2 = new CampaignMember(ContactId=cntcts[1].Id, CampaignId=camp.Id);
        CampaignMember campaignMem3 = new CampaignMember(LeadId=lds[0].Id, CampaignId=camp.Id);
        CampaignMember campaignMem4 = new CampaignMember(LeadId=lds[1].Id, CampaignId=camp.Id);
        insert new List<CampaignMember> { campaignMem1, campaignMem2, campaignMem3, campaignMem4 };
        CCPA_Request__c request1 = new CCPA_Request__c(Request_ID__c='111');
        insert request1;
        CCPA_Request__c request2 = new CCPA_Request__c(Request_ID__c='222');
        insert request2;
        CCPA_Action__c action1 = new CCPA_Action__c(CCPA_Request__c=request1.Id, Request_ID__c='111',
                                                    Key_Name__c='SFDC_CONTACT_PROSPECT', Key_Value__c=cntcts[1].Id);
        insert action1;
        CCPA_Action__c action2 = new CCPA_Action__c(CCPA_Request__c=request2.Id, Request_ID__c='222',
                                                    Key_Name__c='SFDC_LEAD', Key_Value__c=lds[1].Id);
        insert action2;

        Test.startTest();
        Database.executeBatch(new CCPA_Process_Delete_Requests_Batch(), 10);
        Test.stopTest();

        List<CampaignMember> campaignMembers = [SELECT Id FROM CampaignMember];
        System.assertEquals(2, campaignMembers.size());
        System.assertEquals(true, containsCampaignMember(campaignMembers, campaignMem1));
        System.assertEquals(true, containsCampaignMember(campaignMembers, campaignMem3));
    }

    @IsTest
    static void referralDeletions() {

        // Note that Resulting_Lead__c is not tested.

        List<Contact> cntcts = [SELECT Id FROM Contact];
        List<Lead> lds = [SELECT Id FROM Lead];
        Referral__c ref1 = new Referral__c(Resulting_Lead__c=lds[0].Id, Referred_Lead__c=lds[1].Id, Referred_To__c='Grand & Toy', Referred_By__c='Tech-Zone');
        Referral__c ref2 = new Referral__c(Referred_Contact__c=cntcts[0].Id, Referred_To__c='Grand & Toy', Referred_By__c='Tech-Zone');
        Referral__c ref3 = new Referral__c(Referred_Lead__c=lds[2].Id, Referred_To__c='Grand & Toy', Referred_By__c='Tech-Zone');
        Referral__c ref4 = new Referral__c(Referred_Contact__c=cntcts[1].Id, Referred_To__c='Grand & Toy', Referred_By__c='Tech-Zone');
        User bsdUser = ReferralTestUtil_TC.createBSDUser();
        insert new List<Referral__c> { ref1, ref2, ref3, ref4 };
        CCPA_Request__c request1 = new CCPA_Request__c(Request_ID__c='111');
        CCPA_Request__c request2 = new CCPA_Request__c(Request_ID__c='222');
        CCPA_Request__c request3 = new CCPA_Request__c(Request_ID__c='333');
        insert new List<CCPA_Request__c> { request1, request2, request3 };
        CCPA_Action__c action1 = new CCPA_Action__c(CCPA_Request__c=request1.Id, Request_ID__c='111',
                                                    Key_Name__c='SFDC_CONTACT_PROSPECT', Key_Value__c=cntcts[1].Id);
        CCPA_Action__c action2 = new CCPA_Action__c(CCPA_Request__c=request2.Id, Request_ID__c='222',
                                                    Key_Name__c='SFDC_LEAD', Key_Value__c=lds[2].Id);
        insert new List<CCPA_Action__c> { action1, action2 };

        Test.startTest();
        Database.executeBatch(new CCPA_Process_Delete_Requests_Batch(), 10);
        Test.stopTest();

        List<Referral__c> refs = [SELECT Id, Resulting_Lead__c, Referred_Lead__c, Referred_Contact__c FROM Referral__c];
        System.assertEquals(2, refs.size());
        System.assertEquals(true, containsReferral(refs, ref1));
        System.assertEquals(true, containsReferral(refs, ref2));
    }

    @IsTest
    static void eventDeletions() {
        Id supportRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Support').getRecordTypeId();
        List<Lead> lds = [SELECT Id FROM Lead];
        List<Contact> cntcts = [SELECT Id FROM Contact];
        Case case1 = new Case(ContactId=cntcts[0].Id, RecordTypeId=supportRecordTypeId);
        Case case2 = new Case(ContactId=cntcts[1].Id, RecordTypeId=supportRecordTypeId);
        insert new List<Case> { case1, case2 };
        Event event1 = new Event(WhoId=cntcts[0].Id, DurationInMinutes=1, ActivityDateTime=Datetime.newInstance(2020, 1, 17));
        Event event2 = new Event(WhoId=lds[0].Id, DurationInMinutes=1, ActivityDateTime=Datetime.newInstance(2020, 1, 17));
        Event event3 = new Event(WhatId=case1.Id, DurationInMinutes=1, ActivityDateTime=Datetime.newInstance(2020, 1, 17));
        Event event4 = new Event(WhatId=case2.Id, DurationInMinutes=1, ActivityDateTime=Datetime.newInstance(2020, 1, 17));
        Event event5 = new Event(WhoId=cntcts[1].Id, DurationInMinutes=1, ActivityDateTime=Datetime.newInstance(2020, 1, 17));
        Event event6 = new Event(WhoId=lds[1].Id, DurationInMinutes=1, ActivityDateTime=Datetime.newInstance(2020, 1, 17));
        insert new List<Event> { event1, event2, event3, event4, event5, event6 };
        CCPA_Request__c request1 = new CCPA_Request__c(Request_ID__c='111');
        CCPA_Request__c request2 = new CCPA_Request__c(Request_ID__c='222');
        insert new List<CCPA_Request__c> { request1, request2 };
        CCPA_Action__c action1 = new CCPA_Action__c(CCPA_Request__c=request1.Id, Request_ID__c='111',
        Key_Name__c='SFDC_CONTACT_PROSPECT', Key_Value__c=cntcts[1].Id);
        CCPA_Action__c action2 = new CCPA_Action__c(CCPA_Request__c=request2.Id, Request_ID__c='222',
        Key_Name__c='SFDC_LEAD', Key_Value__c=lds[1].Id);
        insert new List<CCPA_Action__c> { action1, action2 };
        
        Test.startTest();
        Database.executeBatch(new CCPA_Process_Delete_Requests_Batch(), 10);
        Test.stopTest();

        List<Event> evnts = [SELECT Id FROM Event];
        System.assertEquals(3, evnts.size());
        System.assertEquals(true, containsEvent(evnts, event1));
        System.assertEquals(true, containsEvent(evnts, event2));
        System.assertEquals(true, containsEvent(evnts, event3));
    }

    @IsTest
    static void contactEmailObfuscation() {
        List<Contact> cntcts = [SELECT Id FROM Contact];
        cntcts[0].Email = 'test1@test.com';
        cntcts[0].Email1__c = 'test1@test.com';
        cntcts[1].Email = 'test2@test.com';
        cntcts[1].Email1__c = 'test2@test.com';
        cntcts[1].Email2__c = 'test2@test.com';
        cntcts[1].Email3__c = 'test2@test.com';
        cntcts[2].Email2__c = 'test3@test.com';
        cntcts[2].Email3__c = 'test3@test.com';
        update cntcts;
        CCPA_Request__c request1 = new CCPA_Request__c(Request_ID__c='111');
        CCPA_Request__c request2 = new CCPA_Request__c(Request_ID__c='222');
        insert new List<CCPA_Request__c> { request1, request2 };
        CCPA_Action__c action1 = new CCPA_Action__c(CCPA_Request__c=request1.Id, Request_ID__c='111', Key_Name__c='EMAIL', Key_Value__c='test1@test.com');
        CCPA_Action__c action2 = new CCPA_Action__c(CCPA_Request__c=request2.Id, Request_ID__c='222', Key_Name__c='EMAIL', Key_Value__c='test3@test.com');
        insert new List<CCPA_Action__c> { action1, action2 };

        Test.startTest();
        Database.executeBatch(new CCPA_Process_Delete_Requests_Batch(), 10);
        Test.stopTest();

        Contact contact1 = [SELECT Id, Email, Email1__c, Email2__c, Email3__c FROM Contact WHERE Id =: cntcts[0].Id];
        Contact contact2 = [SELECT Id, Email, Email1__c, Email2__c, Email3__c FROM Contact WHERE Id =: cntcts[1].Id];
        Contact contact3 = [SELECT Id, Email, Email1__c, Email2__c, Email3__c FROM Contact WHERE Id =: cntcts[2].Id];
        System.assertEquals(true, contact1.Email == 'zzz@zzz.com' && contact1.Email1__c == 'zzz@zzz.com' && contact1.Email2__c != 'zzz@zzz.com' && contact1.Email3__c != 'zzz@zzz.com');
        System.assertEquals(true, contact2.Email != 'zzz@zzz.com' && contact2.Email1__c != 'zzz@zzz.com' && contact2.Email2__c != 'zzz@zzz.com' && contact2.Email3__c != 'zzz@zzz.com');
        System.assertEquals(true, contact3.Email != 'zzz@zzz.com' && contact3.Email1__c != 'zzz@zzz.com' && contact3.Email2__c == 'zzz@zzz.com' && contact3.Email3__c == 'zzz@zzz.com');
    }

    @IsTest
    static void contactEmailObfuscationExcludePortalUsers() {
        List<Contact> cntcts = [SELECT Id FROM Contact];
        Profile portalProfile = [SELECT Id FROM Profile WHERE Name = 'Partner Community User Custom' LIMIT 1];
        List<User> usrs = MyUtilsDataFactory.makeUsers(1);
        usrs[0].ProfileId = portalProfile.Id;
        usrs[0].ContactId = cntcts[1].Id;
        insert usrs;

        cntcts[0].Email = 'test1@test.com';
        cntcts[0].Email1__c = 'test1@test.com';
        cntcts[1].Email = 'test2@test.com';
        cntcts[1].Email1__c = 'test2@test.com';
        cntcts[1].Email2__c = 'test2@test.com';
        cntcts[1].Email3__c = 'test2@test.com';
        cntcts[2].Email2__c = 'test3@test.com';
        cntcts[2].Email3__c = 'test3@test.com';
        update cntcts;
        CCPA_Request__c request1 = new CCPA_Request__c(Request_ID__c='111');
        CCPA_Request__c request2 = new CCPA_Request__c(Request_ID__c='222');
        CCPA_Request__c request3 = new CCPA_Request__c(Request_ID__c='333');
        insert new List<CCPA_Request__c> { request1, request2, request3 };
        CCPA_Action__c action1 = new CCPA_Action__c(CCPA_Request__c=request1.Id, Request_ID__c='111', Key_Name__c='EMAIL', Key_Value__c='test1@test.com');
        CCPA_Action__c action2 = new CCPA_Action__c(CCPA_Request__c=request2.Id, Request_ID__c='222', Key_Name__c='EMAIL', Key_Value__c='test2@test.com');
        CCPA_Action__c action3 = new CCPA_Action__c(CCPA_Request__c=request2.Id, Request_ID__c='333', Key_Name__c='EMAIL', Key_Value__c='test3@test.com');
        insert new List<CCPA_Action__c> { action1, action2, action3 };

        Test.startTest();
        Database.executeBatch(new CCPA_Process_Delete_Requests_Batch(), 10);
        Test.stopTest();

        Contact contact1 = [SELECT Id, Email, Email1__c, Email2__c, Email3__c FROM Contact WHERE Id =: cntcts[0].Id];
        Contact contact2 = [SELECT Id, Email, Email1__c, Email2__c, Email3__c FROM Contact WHERE Id =: cntcts[1].Id];
        Contact contact3 = [SELECT Id, Email, Email1__c, Email2__c, Email3__c FROM Contact WHERE Id =: cntcts[2].Id];
        System.assertEquals(true, contact1.Email == 'zzz@zzz.com' && contact1.Email1__c == 'zzz@zzz.com' && contact1.Email2__c != 'zzz@zzz.com' && contact1.Email3__c != 'zzz@zzz.com');
        System.assertEquals(true, contact2.Email != 'zzz@zzz.com' && contact2.Email1__c != 'zzz@zzz.com' && contact2.Email2__c != 'zzz@zzz.com' && contact2.Email3__c != 'zzz@zzz.com');
        System.assertEquals(true, contact3.Email != 'zzz@zzz.com' && contact3.Email1__c != 'zzz@zzz.com' && contact3.Email2__c == 'zzz@zzz.com' && contact3.Email3__c == 'zzz@zzz.com');
    }

    @IsTest
    static void supportEmailObfuscation() {
        Id supportRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Support').getRecordTypeId();
        List<Contact> cntcts = [SELECT Id, AccountId FROM Contact];
        cntcts[0].Email = 'test1@test.com';
        cntcts[1].Email = 'test2@test.com';
        cntcts[2].Email = 'test3@test.com';
        update cntcts;
        Case support1 = new Case(AM_Contact_Email__c='test1@test.com', ContactId=cntcts[0].Id, WRF_Eproc_Email__c='test1@test.com', RecordTypeId=supportRecordTypeId, AccountId=cntcts[0].AccountId);
        Case support2 = new Case(AM_Contact_Email__c='test2@test.com', ContactId=cntcts[1].Id, WRF_Eproc_Email__c='test2@test.com', WRF_IT_Contact_Email__c='test2@test.com', Requestor_Email_2__c='test2@test.com', RecordTypeId=supportRecordTypeId, AccountId=cntcts[1].AccountId);
        Case support3 = new Case(WRF_IT_Contact_Email__c='test3@test.com', ContactId=cntcts[2].Id, Requestor_Email_2__c='test3@test.com', RecordTypeId=supportRecordTypeId, AccountId=cntcts[2].AccountId);
        insert new List<Case> { support1, support2, support3 };
        CCPA_Request__c request1 = new CCPA_Request__c(Request_ID__c='111');
        CCPA_Request__c request2 = new CCPA_Request__c(Request_ID__c='222');
        insert new List<CCPA_Request__c> { request1, request2 };
        CCPA_Action__c action1 = new CCPA_Action__c(CCPA_Request__c=request1.Id, Request_ID__c='111', Key_Name__c='EMAIL', Key_Value__c='test1@test.com');
        CCPA_Action__c action2 = new CCPA_Action__c(CCPA_Request__c=request2.Id, Request_ID__c='222', Key_Name__c='EMAIL', Key_Value__c='test3@test.com');
        insert new List<CCPA_Action__c> { action1, action2 };

        Test.startTest();
        Database.executeBatch(new CCPA_Process_Delete_Requests_Batch(), 10);
        Test.stopTest();

        support1 = [SELECT Id, AM_Contact_Email__c, ContactEmail, WRF_Eproc_Email__c, WRF_IT_Contact_Email__c, Requestor_Email_2__c FROM Case WHERE Id =: support1.Id];
        support2 = [SELECT Id, AM_Contact_Email__c, ContactEmail, WRF_Eproc_Email__c, WRF_IT_Contact_Email__c, Requestor_Email_2__c FROM Case WHERE Id =: support2.Id];
        support3 = [SELECT Id, AM_Contact_Email__c, ContactEmail, WRF_Eproc_Email__c, WRF_IT_Contact_Email__c, Requestor_Email_2__c FROM Case WHERE Id =: support3.Id];
        System.assertEquals(true, support1.AM_Contact_Email__c == 'zzz@zzz.com' && support1.ContactEmail == 'zzz@zzz.com' && support1.WRF_Eproc_Email__c == 'zzz@zzz.com' && support1.WRF_IT_Contact_Email__c != 'zzz@zzz.com', support1.Requestor_Email_2__c != 'zzz@zzz.com');
        System.assertEquals(true, support2.AM_Contact_Email__c != 'zzz@zzz.com' && support2.ContactEmail != 'zzz@zzz.com' && support2.WRF_Eproc_Email__c != 'zzz@zzz.com' && support2.WRF_IT_Contact_Email__c != 'zzz@zzz.com', support2.Requestor_Email_2__c != 'zzz@zzz.com');
        System.assertEquals(true, support3.AM_Contact_Email__c != 'zzz@zzz.com' && support3.ContactEmail == 'zzz@zzz.com' && support3.WRF_Eproc_Email__c != 'zzz@zzz.com' && support3.WRF_IT_Contact_Email__c == 'zzz@zzz.com', support3.Requestor_Email_2__c == 'zzz@zzz.com');
    }

    @IsTest
    static void leadStagingEmailObfuscation() {
        LeadStaging__c leadStaging1 = new LeadStaging__c(Email__c='test1@test.com');
        LeadStaging__c leadStaging2 = new LeadStaging__c(Email__c='test2@test.com');
        LeadStaging__c leadStaging3 = new LeadStaging__c(Email__c='test3@test.com');
        insert new List<LeadStaging__c> { leadStaging1, leadStaging2, leadStaging3 };
        CCPA_Request__c request1 = new CCPA_Request__c(Request_ID__c='111');
        CCPA_Request__c request2 = new CCPA_Request__c(Request_ID__c='222');
        insert new List<CCPA_Request__c> { request1, request2 };
        CCPA_Action__c action1 = new CCPA_Action__c(CCPA_Request__c=request1.Id, Request_ID__c='111', Key_Name__c='EMAIL', Key_Value__c='test1@test.com');
        CCPA_Action__c action2 = new CCPA_Action__c(CCPA_Request__c=request2.Id, Request_ID__c='222', Key_Name__c='EMAIL', Key_Value__c='test3@test.com');
        insert new List<CCPA_Action__c> { action1, action2 };

        Test.startTest();
        Database.executeBatch(new CCPA_Process_Delete_Requests_Batch(), 10);
        Test.stopTest();

        leadStaging1 = [SELECT Id, Email__c FROM LeadStaging__c WHERE Id =: leadStaging1.Id];
        leadStaging2 = [SELECT Id, Email__c FROM LeadStaging__c WHERE Id =: leadStaging2.Id];
        leadStaging3 = [SELECT Id, Email__c FROM LeadStaging__c WHERE Id =: leadStaging3.Id];
        System.assertEquals('zzz@zzz.com', leadStaging1.Email__c);
        System.assertEquals('test2@test.com', leadStaging2.Email__c);
        System.assertEquals('zzz@zzz.com', leadStaging3.Email__c);
    }

    @IsTest
    static void leadEmailObfuscation() {
        Lead lead1 = new Lead(Email='test1@test.com', LastName='Test1', Company='Test1');
        Lead lead2 = new Lead(Email='test2@test.com', Referrer_Email__c='test2@test.com', LastName='Test2', Company='Test2');
        Lead lead3 = new Lead(Referrer_Email__c='test3@test.com', LastName='Test3', Company='Test3');
        insert new List<Lead> { lead1, lead2, lead3 };
        CCPA_Request__c request1 = new CCPA_Request__c(Request_ID__c='111');
        CCPA_Request__c request2 = new CCPA_Request__c(Request_ID__c='222');
        insert new List<CCPA_Request__c> { request1, request2 };
        CCPA_Action__c action1 = new CCPA_Action__c(CCPA_Request__c=request1.Id, Request_ID__c='111', Key_Name__c='EMAIL', Key_Value__c='test1@test.com');
        CCPA_Action__c action2 = new CCPA_Action__c(CCPA_Request__c=request2.Id, Request_ID__c='222', Key_Name__c='EMAIL', Key_Value__c='test3@test.com');
        insert new List<CCPA_Action__c> { action1, action2 };

        Test.startTest();
        Database.executeBatch(new CCPA_Process_Delete_Requests_Batch(), 10);
        Test.stopTest();

        lead1 = [SELECT Id, Email, Referrer_Email__c FROM Lead WHERE Id =: lead1.Id];
        lead2 = [SELECT Id, Email, Referrer_Email__c FROM Lead WHERE Id =: lead2.Id];
        lead3 = [SELECT Id, Email, Referrer_Email__c FROM Lead WHERE Id =: lead3.Id];
        System.assertEquals(true, lead1.Email == 'zzz@zzz.com' && lead1.Referrer_Email__c != 'zzz@zzz.com');
        System.assertEquals(true, lead2.Email =='test2@test.com' && lead2.Referrer_Email__c == 'test2@test.com');
        System.assertEquals(true, lead3.Email != 'zzz@zzz.com' && lead3.Referrer_Email__c == 'zzz@zzz.com');
    }

    @IsTest
    static void referralEmailObfuscation() {
        List<Contact> cntcts = [SELECT Id FROM Contact];
        cntcts[0].Email = 'test1@test.com';
        cntcts[1].Email = 'test2@test.com';
        cntcts[2].Email = 'test3@test.com';
        update cntcts;
        Referral__c referral1 = new Referral__c(Referred_Contact__c=cntcts[0].Id, Referred_To__c='Grand & Toy', Referred_By__c='Tech-Zone');
        Referral__c referral2 = new Referral__c(Referred_Contact__c=cntcts[1].Id, Referred_To__c='Grand & Toy', Referred_By__c='Tech-Zone');
        Referral__c referral3 = new Referral__c(Referred_Contact__c=cntcts[2].Id, Referred_To__c='Grand & Toy', Referred_By__c='Tech-Zone');
        insert new List<Referral__c> { referral1, referral2, referral3 };
        CCPA_Request__c request1 = new CCPA_Request__c(Request_ID__c='111');
        CCPA_Request__c request2 = new CCPA_Request__c(Request_ID__c='222');
        insert new List<CCPA_Request__c> { request1, request2 };
        CCPA_Action__c action1 = new CCPA_Action__c(CCPA_Request__c=request1.Id, Request_ID__c='111', Key_Name__c='EMAIL', Key_Value__c='test1@test.com');
        CCPA_Action__c action2 = new CCPA_Action__c(CCPA_Request__c=request2.Id, Request_ID__c='222', Key_Name__c='EMAIL', Key_Value__c='test3@test.com');
        insert new List<CCPA_Action__c> { action1, action2 };

        Test.startTest();
        Database.executeBatch(new CCPA_Process_Delete_Requests_Batch(), 10);
        Test.stopTest();

        referral1 = [SELECT Id, Email__c FROM Referral__c WHERE Id =: referral1.Id];
        referral2 = [SELECT Id, Email__c FROM Referral__c WHERE Id =: referral2.Id];
        referral3 = [SELECT Id, Email__c FROM Referral__c WHERE Id =: referral3.Id];
        System.assertEquals('zzz@zzz.com', referral1.Email__c);
        System.assertEquals('test2@test.com', referral2.Email__c);
        System.assertEquals('zzz@zzz.com', referral3.Email__c);
    }
    
    @IsTest
    static void campaignMemberEmailObfuscation() {
        List<Contact> cntcts = [SELECT Id FROM Contact];
        cntcts[0].Email = 'test1@test.com';
        cntcts[1].Email = 'test2@test.com';
        update cntcts;
        List<Lead> lds = MyUtilsDataFactory.makeLeads(2);
        lds[0].Email = 'test3@test.com';
        lds[1].Email = 'test2@test.com';
        insert lds;
        Campaign camp = new Campaign(Name='test');
        insert camp;
        CampaignMember campaignMem1 = new CampaignMember(CampaignId=camp.Id, ContactId=cntcts[0].Id);
        CampaignMember campaignMem2 = new CampaignMember(CampaignId=camp.Id, ContactId=cntcts[1].Id, LeadId=lds[1].Id);
        CampaignMember campaignMem3 = new CampaignMember(CampaignId=camp.Id, LeadId=lds[0].Id);
        insert new List<CampaignMember> { campaignMem1, campaignMem2, campaignMem3 };
        CCPA_Request__c request1 = new CCPA_Request__c(Request_ID__c='111');
        CCPA_Request__c request2 = new CCPA_Request__c(Request_ID__c='222');
        insert new List<CCPA_Request__c> { request1, request2 };
        CCPA_Action__c action1 = new CCPA_Action__c(CCPA_Request__c=request1.Id, Request_ID__c='111', Key_Name__c='EMAIL', Key_Value__c='test1@test.com');
        CCPA_Action__c action2 = new CCPA_Action__c(CCPA_Request__c=request2.Id, Request_ID__c='222', Key_Name__c='EMAIL', Key_Value__c='test3@test.com');
        insert new List<CCPA_Action__c> { action1, action2 };

        Test.startTest();
        Database.executeBatch(new CCPA_Process_Delete_Requests_Batch(), 10);
        Test.stopTest();

        campaignMem1 = [SELECT Id, Email FROM CampaignMember WHERE Id =: campaignMem1.Id];
        campaignMem2 = [SELECT Id, Email FROM CampaignMember WHERE Id =: campaignMem2.Id];
        campaignMem3 = [SELECT Id, Email FROM CampaignMember WHERE Id =: campaignMem3.Id];
        System.assertEquals('zzz@zzz.com', campaignMem1.Email);
        System.assertEquals('test2@test.com', campaignMem2.Email);
        System.assertEquals('zzz@zzz.com', campaignMem3.Email);
    }

    @IsTest
    static void contactPhoneObfuscation() {
        List<Account> accts = [SELECT Id FROM Account];
        Contact contact1 = new Contact(NPX_contact_phone_2__c='(111) 111-1111', Phone_Ext__c='(111) 111-1111', Phone3__c='(111) 111-1111',
                                        Phone2__c='(111) 111-1111', Phone1__c='(111) 111-1111', Phone='(111) 111-1111', Fax='(111) 111-1111',
                                        LastName='Test1', AccountId=accts[0].Id);
        Contact contact2 = new Contact(NPX_contact_phone_2__c='(222) 222-2222', Phone_Ext__c='(222) 222-2222', Phone3__c='(222) 222-2222',
                                        Phone2__c='(222) 222-2222', Phone1__c='(222) 222-2222', Phone='(222) 222-2222', Fax='(222) 222-2222',
                                        OtherPhone='(222) 222-2222', HomePhone='(222) 222-2222', AssistantPhone='(222) 222-2222', MobilePhone='(222) 222-2222',
                                        Phone3_Rep__c='(222) 222-2222', Phone2_Rep__c='(222) 222-2222', Phone1_Rep__c='(222) 222-2222',
                                        LastName='Test2', Phone_Type1__c='Mobile', Phone_Type2__c='Mobile', Phone_Type3__c='Mobile', AccountId=accts[1].Id);
        Contact contact3 = new Contact(OtherPhone='(333) 333-3333', HomePhone='(333) 333-3333', AssistantPhone='(333) 333-3333', MobilePhone='(333) 333-3333',
                                        Phone3_Rep__c='(333) 333-3333', Phone2_Rep__c='(333) 333-3333', Phone1_Rep__c='(333) 333-3333',
                                        LastName='Test3', Phone_Type1__c='Mobile', Phone_Type2__c='Mobile', Phone_Type3__c='Mobile', AccountId=accts[2].Id);
        insert new List<Contact> { contact1, contact2, contact3 };
        CCPA_Request__c request1 = new CCPA_Request__c(Request_ID__c='111');
        CCPA_Request__c request2 = new CCPA_Request__c(Request_ID__c='222');
        insert new List<CCPA_Request__c> { request1, request2 };
        CCPA_Action__c action1 = new CCPA_Action__c(CCPA_Request__c=request1.Id, Request_ID__c='111', Key_Name__c='PHONE', Key_Value__c='1111111111');
        CCPA_Action__c action2 = new CCPA_Action__c(CCPA_Request__c=request2.Id, Request_ID__c='222', Key_Name__c='PHONE', Key_Value__c='3333333333');
        insert new List<CCPA_Action__c> { action1, action2 };

        Test.startTest();
        Database.executeBatch(new CCPA_Process_Delete_Requests_Batch(), 10);
        Test.stopTest();

        contact1 = [SELECT Id, NPX_contact_phone_2__c, Phone_Ext__c, Phone3__c, Phone2__c, Phone1__c, Phone, Fax, OtherPhone, HomePhone,
                    AssistantPhone, MobilePhone, Phone3_Rep__c, Phone2_Rep__c, Phone1_Rep__c, LastName FROM Contact WHERE Id =: contact1.Id];
        contact2 = [SELECT Id, NPX_contact_phone_2__c, Phone_Ext__c, Phone3__c, Phone2__c, Phone1__c, Phone, Fax, OtherPhone, HomePhone,
                    AssistantPhone, MobilePhone, Phone3_Rep__c, Phone2_Rep__c, Phone1_Rep__c, LastName FROM Contact WHERE Id =: contact2.Id];
        contact3 = [SELECT Id, NPX_contact_phone_2__c, Phone_Ext__c, Phone3__c, Phone2__c, Phone1__c, Phone, Fax, OtherPhone, HomePhone,
                    AssistantPhone, MobilePhone, Phone3_Rep__c, Phone2_Rep__c, Phone1_Rep__c, LastName FROM Contact WHERE Id =: contact3.Id];
        System.assertEquals(true,
            contact1.NPX_contact_phone_2__c == '(000) 000-0000' && contact1.Phone3__c == '(000) 000-0000' && contact1.Phone2__c == '(000) 000-0000' &&
            contact1.Phone1__c == '(000) 000-0000' && contact1.Phone == '(000) 000-0000' && contact1.Fax == '(000) 000-0000' && contact1.Phone_Ext__c == null
        );
        System.assertEquals(true,
            contact2.NPX_contact_phone_2__c == '(222) 222-2222' && contact2.Phone3__c == '(222) 222-2222' && contact2.Phone2__c == '(222) 222-2222' &&
            contact2.Phone1__c == '(222) 222-2222' && contact2.Phone == '(222) 222-2222' && contact2.Fax == '(222) 222-2222' && contact2.Phone_Ext__c == '(222) 222-2222' &&
            contact2.OtherPhone == '(222) 222-2222' && contact2.HomePhone == '(222) 222-2222' && contact2.AssistantPhone == '(222) 222-2222' && contact2.MobilePhone == '(222) 222-2222' &&
            contact2.Phone3_Rep__c == '(222) 222-2222' && contact2.Phone2_Rep__c == '(222) 222-2222' && contact2.Phone1_Rep__c == '(222) 222-2222'
        );
        System.assertEquals(true,
            contact3.OtherPhone == '(000) 000-0000' && contact3.HomePhone == '(000) 000-0000' && contact3.AssistantPhone == '(000) 000-0000' && contact3.MobilePhone == '(000) 000-0000' &&
            contact3.Phone3_Rep__c == '(000) 000-0000' && contact3.Phone2_Rep__c == '(000) 000-0000' && contact3.Phone1_Rep__c == '(000) 000-0000'
        );
    }

    @IsTest
    static void contactPhoneObfuscationExcludePortalUsers() {
        Profile portalProfile = [SELECT Id FROM Profile WHERE Name = 'Partner Community User Custom' LIMIT 1];
        List<Account> accts = [SELECT Id FROM Account];
        Contact contact1 = new Contact(NPX_contact_phone_2__c='(111) 111-1111', Phone_Ext__c='(111) 111-1111', Phone3__c='(111) 111-1111',
                                        Phone2__c='(111) 111-1111', Phone1__c='(111) 111-1111', Phone='(111) 111-1111', Fax='(111) 111-1111',
                                        LastName='Test1', AccountId=accts[0].Id);
        Contact contact2 = new Contact(NPX_contact_phone_2__c='(222) 222-2222', Phone_Ext__c='(222) 222-2222', Phone3__c='(222) 222-2222',
                                        Phone2__c='(222) 222-2222', Phone1__c='(222) 222-2222', Phone='(222) 222-2222', Fax='(222) 222-2222',
                                        OtherPhone='(222) 222-2222', HomePhone='(222) 222-2222', AssistantPhone='(222) 222-2222', MobilePhone='(222) 222-2222',
                                        Phone3_Rep__c='(222) 222-2222', Phone2_Rep__c='(222) 222-2222', Phone1_Rep__c='(222) 222-2222',
                                        LastName='Test2', Phone_Type1__c='Mobile', Phone_Type2__c='Mobile', Phone_Type3__c='Mobile', AccountId=accts[1].Id);
        Contact contact3 = new Contact(OtherPhone='(333) 333-3333', HomePhone='(333) 333-3333', AssistantPhone='(333) 333-3333', MobilePhone='(333) 333-3333',
                                        Phone3_Rep__c='(333) 333-3333', Phone2_Rep__c='(333) 333-3333', Phone1_Rep__c='(333) 333-3333',
                                        LastName='Test3', Phone_Type1__c='Mobile', Phone_Type2__c='Mobile', Phone_Type3__c='Mobile', AccountId=accts[2].Id);
        insert new List<Contact> { contact1, contact2, contact3 };
        List<User> usrs = MyUtilsDataFactory.makeUsers(1);
        usrs[0].ProfileId = portalProfile.Id;
        usrs[0].ContactId = contact2.Id;
        insert usrs;
        CCPA_Request__c request1 = new CCPA_Request__c(Request_ID__c='111');
        CCPA_Request__c request2 = new CCPA_Request__c(Request_ID__c='222');
        CCPA_Request__c request3 = new CCPA_Request__c(Request_ID__c='333');
        insert new List<CCPA_Request__c> { request1, request2, request3 };
        CCPA_Action__c action1 = new CCPA_Action__c(CCPA_Request__c=request1.Id, Request_ID__c='111', Key_Name__c='PHONE', Key_Value__c='1111111111');
        CCPA_Action__c action2 = new CCPA_Action__c(CCPA_Request__c=request2.Id, Request_ID__c='222', Key_Name__c='PHONE', Key_Value__c='2222222222');
        CCPA_Action__c action3 = new CCPA_Action__c(CCPA_Request__c=request3.Id, Request_ID__c='333', Key_Name__c='PHONE', Key_Value__c='3333333333');
        insert new List<CCPA_Action__c> { action1, action2, action3 };

        Test.startTest();
        Database.executeBatch(new CCPA_Process_Delete_Requests_Batch(), 10);
        Test.stopTest();

        contact1 = [SELECT Id, NPX_contact_phone_2__c, Phone_Ext__c, Phone3__c, Phone2__c, Phone1__c, Phone, Fax, OtherPhone, HomePhone,
                    AssistantPhone, MobilePhone, Phone3_Rep__c, Phone2_Rep__c, Phone1_Rep__c, LastName FROM Contact WHERE Id =: contact1.Id];
        contact2 = [SELECT Id, NPX_contact_phone_2__c, Phone_Ext__c, Phone3__c, Phone2__c, Phone1__c, Phone, Fax, OtherPhone, HomePhone,
                    AssistantPhone, MobilePhone, Phone3_Rep__c, Phone2_Rep__c, Phone1_Rep__c, LastName FROM Contact WHERE Id =: contact2.Id];
        contact3 = [SELECT Id, NPX_contact_phone_2__c, Phone_Ext__c, Phone3__c, Phone2__c, Phone1__c, Phone, Fax, OtherPhone, HomePhone,
                    AssistantPhone, MobilePhone, Phone3_Rep__c, Phone2_Rep__c, Phone1_Rep__c, LastName FROM Contact WHERE Id =: contact3.Id];
        System.assertEquals(true,
            contact1.NPX_contact_phone_2__c == '(000) 000-0000' && contact1.Phone3__c == '(000) 000-0000' && contact1.Phone2__c == '(000) 000-0000' &&
            contact1.Phone1__c == '(000) 000-0000' && contact1.Phone == '(000) 000-0000' && contact1.Fax == '(000) 000-0000' && contact1.Phone_Ext__c == null
        );
        System.assertEquals(true,
            contact2.NPX_contact_phone_2__c == '(222) 222-2222' && contact2.Phone3__c == '(222) 222-2222' && contact2.Phone2__c == '(222) 222-2222' &&
            contact2.Phone1__c == '(222) 222-2222' && contact2.Phone == '(222) 222-2222' && contact2.Fax == '(222) 222-2222' && contact2.Phone_Ext__c == '(222) 222-2222' &&
            contact2.OtherPhone == '(222) 222-2222' && contact2.HomePhone == '(222) 222-2222' && contact2.AssistantPhone == '(222) 222-2222' && contact2.MobilePhone == '(222) 222-2222' &&
            contact2.Phone3_Rep__c == '(222) 222-2222' && contact2.Phone2_Rep__c == '(222) 222-2222' && contact2.Phone1_Rep__c == '(222) 222-2222'
        );
        System.assertEquals(true,
            contact3.OtherPhone == '(000) 000-0000' && contact3.HomePhone == '(000) 000-0000' && contact3.AssistantPhone == '(000) 000-0000' && contact3.MobilePhone == '(000) 000-0000' &&
            contact3.Phone3_Rep__c == '(000) 000-0000' && contact3.Phone2_Rep__c == '(000) 000-0000' && contact3.Phone1_Rep__c == '(000) 000-0000'
        );
    }

    @IsTest
    static void supportPhoneObfuscation() {
        Id supportRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Support').getRecordTypeId();
        List<Contact> cntcts = [SELECT Id FROM Contact];
        Case case1 = new Case(Venue_Phone__c='(111) 111-1111', AM_Contact_Phone__c='(111) 111-1111',
                              	WRF_Decision_Maker_Phone__c='(111) 111-1111', WRF_Eproc_Phone__c='(111) 111-1111',
                                ContactId=cntcts[0].Id, RecordTypeId=supportRecordTypeId);
        Case case2 = new Case(Venue_Phone__c='(222) 222-2222', AM_Contact_Phone__c='(222) 222-2222',
                              	WRF_Decision_Maker_Phone__c='(222) 222-2222', WRF_Eproc_Phone__c='(222) 222-2222',
                              	WRF_IT_Contact_Phone__c='(222) 222-2222', AM_Contact_Fax__c='(222) 222-2222',
                              	WRF_Consultant_Phone__c='(222) 222-2222', SuppliedPhone='(222) 222-2222',
                              	DUP_Requestor_Mobile__c='(222) 222-2222',
                                  ContactId=cntcts[1].Id, RecordTypeId=supportRecordTypeId);
        Case case3 = new Case(WRF_IT_Contact_Phone__c='(333) 333-3333', AM_Contact_Fax__c='(333) 333-3333',
                              	WRF_Consultant_Phone__c='(333) 333-3333', SuppliedPhone='(333) 333-3333',
                              	DUP_Requestor_Mobile__c='(333) 333-3333',
                                  ContactId=cntcts[2].Id, RecordTypeId=supportRecordTypeId);
        insert new List<Case> { case1, case2, case3 };
        CCPA_Request__c request1 = new CCPA_Request__c(Request_ID__c='111');
        CCPA_Request__c request2 = new CCPA_Request__c(Request_ID__c='222');
        insert new List<CCPA_Request__c> { request1, request2 };
        CCPA_Action__c action1 = new CCPA_Action__c(CCPA_Request__c=request1.Id, Request_ID__c='111', Key_Name__c='PHONE', Key_Value__c='1111111111');
        CCPA_Action__c action2 = new CCPA_Action__c(CCPA_Request__c=request2.Id, Request_ID__c='222', Key_Name__c='PHONE', Key_Value__c='3333333333');
        insert new List<CCPA_Action__c> { action1, action2 };

        Test.startTest();
        Database.executeBatch(new CCPA_Process_Delete_Requests_Batch(), 10);
        Test.stopTest();


        case1 = [SELECT Id, Venue_Phone__c, AM_Contact_Phone__c, WRF_Decision_Maker_Phone__c, WRF_Eproc_Phone__c, WRF_IT_Contact_Phone__c,
                 	AM_Contact_Fax__c, WRF_Consultant_Phone__c, SuppliedPhone, DUP_Requestor_Mobile__c FROM Case WHERE Id =: case1.Id];
        case2 = [SELECT Id, Venue_Phone__c, AM_Contact_Phone__c, WRF_Decision_Maker_Phone__c, WRF_Eproc_Phone__c, WRF_IT_Contact_Phone__c,
                 	AM_Contact_Fax__c, WRF_Consultant_Phone__c, SuppliedPhone, DUP_Requestor_Mobile__c FROM Case WHERE Id =: case2.Id];
        case3 = [SELECT Id, Venue_Phone__c, AM_Contact_Phone__c, WRF_Decision_Maker_Phone__c, WRF_Eproc_Phone__c, WRF_IT_Contact_Phone__c,
                 	AM_Contact_Fax__c, WRF_Consultant_Phone__c, SuppliedPhone, DUP_Requestor_Mobile__c FROM Case WHERE Id =: case3.Id];
        System.assertEquals(true,
            case1.Venue_Phone__c == '(000) 000-0000' && case1.AM_Contact_Phone__c == '(000) 000-0000' &&
            case1.WRF_Decision_Maker_Phone__c == '(000) 000-0000' && case1.WRF_Eproc_Phone__c == '(000) 000-0000'
        );
        System.assertEquals(true,
            case2.Venue_Phone__c == '(222) 222-2222' && case2.AM_Contact_Phone__c == '(222) 222-2222' &&
            case2.WRF_Decision_Maker_Phone__c == '(222) 222-2222' && case2.WRF_Eproc_Phone__c == '(222) 222-2222' &&
            case2.WRF_IT_Contact_Phone__c == '(222) 222-2222' && case2.AM_Contact_Fax__c == '(222) 222-2222' &&
            case2.WRF_Consultant_Phone__c == '(222) 222-2222' && case2.SuppliedPhone == '(222) 222-2222' &&
            case2.DUP_Requestor_Mobile__c == '(222) 222-2222'
        );
        System.assertEquals(true,
            case3.WRF_IT_Contact_Phone__c == '(000) 000-0000' && case3.AM_Contact_Fax__c == '(000) 000-0000' &&
            case3.WRF_Consultant_Phone__c == '(000) 000-0000' && case3.SuppliedPhone == '(000) 000-0000' &&
            case3.DUP_Requestor_Mobile__c == '(000) 000-0000'
        );
    }

    @IsTest
    static void leadPhoneObfuscation() {
        List<Lead> lds = [SELECT Id, Phone, Fax, MobilePhone FROM Lead LIMIT 3];
        lds[0].Phone = '(111) 111-1111';
        lds[1].Phone = '(222) 222-2222';
        lds[1].Fax = '(222) 222-2222';
        lds[1].MobilePhone = '(222) 222-2222';
        lds[2].Fax = '(333) 333-3333';
        lds[2].MobilePhone = '(333) 333-3333';
        update lds;
        CCPA_Request__c request1 = new CCPA_Request__c(Request_ID__c='111');
        CCPA_Request__c request2 = new CCPA_Request__c(Request_ID__c='222');
        insert new List<CCPA_Request__c> { request1, request2 };
        CCPA_Action__c action1 = new CCPA_Action__c(CCPA_Request__c=request1.Id, Request_ID__c='111', Key_Name__c='PHONE', Key_Value__c='1111111111');
        CCPA_Action__c action2 = new CCPA_Action__c(CCPA_Request__c=request2.Id, Request_ID__c='222', Key_Name__c='PHONE', Key_Value__c='3333333333');
        insert new List<CCPA_Action__c> { action1, action2 };

        Test.startTest();
        Database.executeBatch(new CCPA_Process_Delete_Requests_Batch(), 10);
        Test.stopTest();

        Lead lead1 = [SELECT Id, Phone, Fax, MobilePhone FROM Lead WHERE Id =: lds[0].Id];
        Lead lead2 = [SELECT Id, Phone, Fax, MobilePhone FROM Lead WHERE Id =: lds[1].Id];
        Lead lead3 = [SELECT Id, Phone, Fax, MobilePhone FROM Lead WHERE Id =: lds[2].Id];
        System.assertEquals(true, lead1.Phone == '(000) 000-0000');
        System.assertEquals(true, lead2.Phone =='(222) 222-2222' && lead2.Fax == '(222) 222-2222' && lead2.MobilePhone == '(222) 222-2222');
        System.assertEquals(true, lead3.Fax == '(000) 000-0000' && lead3.MobilePhone == '(000) 000-0000');
    }

    @IsTest
    static void leadStagingPhoneObfuscation() {
        LeadStaging__c leadStaging1 = new LeadStaging__c(Phone__c='(111) 111-1111');
        LeadStaging__c leadStaging2 = new LeadStaging__c(Phone__c='(222) 222-2222');
        LeadStaging__c leadStaging3 = new LeadStaging__c(Phone__c='(333) 333-3333');
        insert new List<LeadStaging__c> { leadStaging1, leadStaging2, leadStaging3 };
        CCPA_Request__c request1 = new CCPA_Request__c(Request_ID__c='111');
        CCPA_Request__c request2 = new CCPA_Request__c(Request_ID__c='222');
        insert new List<CCPA_Request__c> { request1, request2 };
        CCPA_Action__c action1 = new CCPA_Action__c(CCPA_Request__c=request1.Id, Request_ID__c='111', Key_Name__c='PHONE', Key_Value__c='1111111111');
        CCPA_Action__c action2 = new CCPA_Action__c(CCPA_Request__c=request2.Id, Request_ID__c='222', Key_Name__c='PHONE', Key_Value__c='3333333333');
        insert new List<CCPA_Action__c> { action1, action2 };

        Test.startTest();
        Database.executeBatch(new CCPA_Process_Delete_Requests_Batch(), 10);
        Test.stopTest();

        leadStaging1 = [SELECT Id, Phone__c FROM LeadStaging__c WHERE Id =: leadStaging1.Id];
        leadStaging2 = [SELECT Id, Phone__c FROM LeadStaging__c WHERE Id =: leadStaging2.Id];
        leadStaging3 = [SELECT Id, Phone__c FROM LeadStaging__c WHERE Id =: leadStaging3.Id];
        System.assertEquals('(000) 000-0000', leadStaging1.Phone__c);
        System.assertEquals('(222) 222-2222', leadStaging2.Phone__c);
        System.assertEquals('(000) 000-0000', leadStaging3.Phone__c);
    }

    @IsTest
    static void campaignMemberPhoneObfuscation() {
        List<Contact> cntcts = [SELECT Id FROM Contact];
        cntcts[0].Phone = '(111) 111-1111';
        cntcts[0].Fax = '(111) 111-1111';
        cntcts[0].MobilePhone = '(111) 111-1111';
        cntcts[1].Phone = '(222) 222-2222';
        cntcts[1].Fax = '(222) 222-2222';
        cntcts[1].MobilePhone = '(222) 222-2222';
        update cntcts;
        Lead ld = new Lead(Phone='(333) 333-3333', Fax='(333) 333-3333', MobilePhone='(333) 333-3333', LastName='Test1', Company='Test1');
        insert ld;
        Campaign camp = new Campaign(Name='test');
        insert camp;
        CampaignMember campaignMem1 = new CampaignMember(ContactId=cntcts[0].Id, CampaignId=camp.Id);
        CampaignMember campaignMem2 = new CampaignMember(ContactId=cntcts[1].Id, CampaignId=camp.Id);
        CampaignMember campaignMem3 = new CampaignMember(LeadId=ld.Id, CampaignId=camp.Id);
        insert new List<CampaignMember> { campaignMem1, campaignMem2, campaignMem3 };
        CCPA_Request__c request1 = new CCPA_Request__c(Request_ID__c='111');
        CCPA_Request__c request2 = new CCPA_Request__c(Request_ID__c='222');
        insert new List<CCPA_Request__c> { request1, request2 };
        CCPA_Action__c action1 = new CCPA_Action__c(CCPA_Request__c=request1.Id, Request_ID__c='111', Key_Name__c='PHONE', Key_Value__c='1111111111');
        CCPA_Action__c action2 = new CCPA_Action__c(CCPA_Request__c=request2.Id, Request_ID__c='222', Key_Name__c='PHONE', Key_Value__c='3333333333');
        insert new List<CCPA_Action__c> { action1, action2 };

        Test.startTest();
        Database.executeBatch(new CCPA_Process_Delete_Requests_Batch(), 10);
        Test.stopTest();

        campaignMem1 = [SELECT Id, Phone, Fax, MobilePhone FROM CampaignMember WHERE Id =: campaignMem1.Id];
        campaignMem2 = [SELECT Id, Phone, Fax, MobilePhone FROM CampaignMember WHERE Id =: campaignMem2.Id];
        campaignMem3 = [SELECT Id, Phone, Fax, MobilePhone FROM CampaignMember WHERE Id =: campaignMem3.Id];
        System.assertEquals(true, campaignMem1.Phone == '(000) 000-0000' && campaignMem1.Fax == '(000) 000-0000' && campaignMem1.MobilePhone == '(000) 000-0000');
        System.assertEquals(true, campaignMem2.Phone =='(222) 222-2222' && campaignMem2.Fax == '(222) 222-2222' && campaignMem2.MobilePhone == '(222) 222-2222');
        System.assertEquals(true, campaignMem3.Phone == '(000) 000-0000' && campaignMem3.Fax == '(000) 000-0000' && campaignMem3.MobilePhone == '(000) 000-0000');
    }

    @IsTest
    static void referralPhoneObfuscation() {
        List<Lead> lds = [SELECT Id FROM Lead];
        Referral__c ref1 = new Referral__c(Referred_Lead__c=lds[0].Id, Referred_To__c='Grand & Toy', Referred_By__c='Tech-Zone');
        Referral__c ref2 = new Referral__c(Referred_Lead__c=lds[1].Id, Referred_To__c='Grand & Toy', Referred_By__c='Tech-Zone');
        Referral__c ref3 = new Referral__c(Referred_Lead__c=lds[2].Id, Referred_To__c='Grand & Toy', Referred_By__c='Tech-Zone');
        insert new List<Referral__c> { ref1, ref2, ref3 };
        ref1.Phone__c = '(111) 111-1111';
        ref2.Phone__c = '(222) 222-2222';
        ref3.Phone__c = '(333) 333-3333';
        update new List<Referral__c> { ref1, ref2, ref3 };
        CCPA_Request__c request1 = new CCPA_Request__c(Request_ID__c='111');
        CCPA_Request__c request2 = new CCPA_Request__c(Request_ID__c='222');
        insert new List<CCPA_Request__c> { request1, request2 };
        CCPA_Action__c action1 = new CCPA_Action__c(CCPA_Request__c=request1.Id, Request_ID__c='111', Key_Name__c='PHONE', Key_Value__c='1111111111');
        CCPA_Action__c action2 = new CCPA_Action__c(CCPA_Request__c=request2.Id, Request_ID__c='222', Key_Name__c='PHONE', Key_Value__c='3333333333');
        insert new List<CCPA_Action__c> { action1, action2 };

        Test.startTest();
        Database.executeBatch(new CCPA_Process_Delete_Requests_Batch(), 10);
        Test.stopTest();

        ref1 = [SELECT Id, Phone__c FROM Referral__c WHERE Id =: ref1.Id];
        ref2 = [SELECT Id, Phone__c FROM Referral__c WHERE Id =: ref2.Id];
        ref3 = [SELECT Id, Phone__c FROM Referral__c WHERE Id =: ref3.Id];
        System.assertEquals('(000) 000-0000', ref1.Phone__c);
        System.assertEquals('(222) 222-2222', ref2.Phone__c);
        System.assertEquals('(000) 000-0000', ref3.Phone__c);
    }

    @IsTest
    static void actionStatusesUpdatedWhenCompleted() {
        List<Contact> cntcts = [SELECT Id FROM Contact];
        CCPA_Request__c request1 = new CCPA_Request__c(Request_ID__c='111');
        CCPA_Request__c request2 = new CCPA_Request__c(Request_ID__c='222');
        insert new List<CCPA_Request__c> { request1, request2 };
        CCPA_Action__c action1 = new CCPA_Action__c(CCPA_Request__c=request1.Id, Request_ID__c='111',
                                                    Key_Name__c='SFDC_CONTACT_PROSPECT', Key_Value__c=cntcts[0].Id);
        CCPA_Action__c action2 = new CCPA_Action__c(CCPA_Request__c=request1.Id, Request_ID__c='111',
                                                    Key_Name__c='SFDC_CONTACT_PROSPECT', Key_Value__c=cntcts[1].Id);
        CCPA_Action__c action3 = new CCPA_Action__c(CCPA_Request__c=request2.Id, Request_ID__c='222',
                                                    Key_Name__c='SFDC_CONTACT_PROSPECT', Key_Value__c=cntcts[2].Id);
        insert new List<CCPA_Action__c> { action1, action2, action3 };

        Test.startTest();
        Database.executeBatch(new CCPA_Process_Delete_Requests_Batch(), 10);
        Test.stopTest();

        action1 = [SELECT Id, Sales_Cloud_Complete__c FROM CCPA_Action__c WHERE Id =: action1.Id];
        action2 = [SELECT Id, Sales_Cloud_Complete__c FROM CCPA_Action__c WHERE Id =: action2.Id];
        action3 = [SELECT Id, Sales_Cloud_Complete__c FROM CCPA_Action__c WHERE Id =: action3.Id];
        System.assertEquals(true, action1.Sales_Cloud_Complete__c);
        System.assertEquals(true, action2.Sales_Cloud_Complete__c);
        System.assertEquals(true, action3.Sales_Cloud_Complete__c);
    }

    @IsTest
    static void actionStatusesUpdatedWhenNotNeeded() {
        CCPA_Request__c request1 = new CCPA_Request__c(Request_ID__c='111');
        CCPA_Request__c request2 = new CCPA_Request__c(Request_ID__c='222');
        insert new List<CCPA_Request__c> { request1, request2 };
        CCPA_Action__c action1 = new CCPA_Action__c(CCPA_Request__c=request1.Id, Request_ID__c='111',
                                                    Key_Name__c='AOPS_ACCOUNT', Key_Value__c='Test');
        CCPA_Action__c action2 = new CCPA_Action__c(CCPA_Request__c=request1.Id, Request_ID__c='111',
                                                    Key_Name__c='AOPS_CONTACT', Key_Value__c='Test');
        CCPA_Action__c action3 = new CCPA_Action__c(CCPA_Request__c=request2.Id, Request_ID__c='222',
                                                    Key_Name__c='CLICKSTREAM_SESSION', Key_Value__c='Test');
        CCPA_Action__c action4 = new CCPA_Action__c(CCPA_Request__c=request2.Id, Request_ID__c='222',
                                                    Key_Name__c='CLICKSTREAM_COOKIE', Key_Value__c='Test');
        insert new List<CCPA_Action__c> { action1, action2, action3, action4 };

        Test.startTest();
        Database.executeBatch(new CCPA_Process_Delete_Requests_Batch(), 10);
        Test.stopTest();

        action1 = [SELECT Id, Sales_Cloud_Complete__c FROM CCPA_Action__c WHERE Id =: action1.Id];
        action2 = [SELECT Id, Sales_Cloud_Complete__c FROM CCPA_Action__c WHERE Id =: action2.Id];
        action3 = [SELECT Id, Sales_Cloud_Complete__c FROM CCPA_Action__c WHERE Id =: action3.Id];
        action4 = [SELECT Id, Sales_Cloud_Complete__c FROM CCPA_Action__c WHERE Id =: action4.Id];
        System.assertEquals(true, action1.Sales_Cloud_Complete__c);
        System.assertEquals(true, action2.Sales_Cloud_Complete__c);
        System.assertEquals(true, action3.Sales_Cloud_Complete__c);
        System.assertEquals(true, action4.Sales_Cloud_Complete__c);
    }

    @IsTest
    static void requestStatusesUpdatedWhenCompleted() {
        Lead lead1 = new Lead(Email='test1@test.com', LastName='Test1', Company='Test1');
        Lead lead2 = new Lead(Email='test2@test.com', LastName='Test2', Company='Test2');
        Lead lead3 = new Lead(Email='test3@test.com', LastName='Test3', Company='Test3');
        Lead lead4 = new Lead(Email='test4@test.com', LastName='Test4', Company='Test4');
        insert new List<Lead> { lead1, lead2, lead3, lead4 };
        CCPA_Request__c request1 = new CCPA_Request__c(Request_ID__c='111');
        CCPA_Request__c request2 = new CCPA_Request__c(Request_ID__c='222');
        insert new List<CCPA_Request__c> { request1, request2 };
        CCPA_Action__c action1 = new CCPA_Action__c(CCPA_Request__c=request1.Id, Request_ID__c='111', Key_Name__c='EMAIL',
                                                    Key_Value__c='test1@test.com', Marketing_Cloud_Status__c='Completed');
        CCPA_Action__c action2 = new CCPA_Action__c(CCPA_Request__c=request1.Id, Request_ID__c='111', Key_Name__c='EMAIL',
                                                    Key_Value__c='test2@test.com', Marketing_Cloud_Status__c='Completed');
        CCPA_Action__c action3 = new CCPA_Action__c(CCPA_Request__c=request2.Id, Request_ID__c='222', Key_Name__c='EMAIL',
                                                    Key_Value__c='test3@test.com', Marketing_Cloud_Status__c='Completed');
        CCPA_Action__c action4 = new CCPA_Action__c(CCPA_Request__c=request2.Id, Request_ID__c='222', Key_Name__c='EMAIL',
                                                    Key_Value__c='test4@test.com', Marketing_Cloud_Status__c='Completed');
        insert new List<CCPA_Action__c> { action1, action2, action3, action4 };

        Test.startTest();
        Database.executeBatch(new CCPA_Process_Delete_Requests_Batch(), 10);
        Test.stopTest();

        request1 = [SELECT Id, Sales_Cloud_Complete__c, Sales_Cloud_Delete_Timestamp__c, Marketing_Cloud_Complete__c, Marketing_Cloud_Delete_Timestamp__c FROM CCPA_Request__c WHERE Id =: request1.Id];
        request2 = [SELECT Id, Sales_Cloud_Complete__c, Sales_Cloud_Delete_Timestamp__c, Marketing_Cloud_Complete__c, Marketing_Cloud_Delete_Timestamp__c FROM CCPA_Request__c WHERE Id =: request2.Id];
        System.assertEquals(true, request1.Sales_Cloud_Complete__c);
        System.assertEquals(true, request1.Sales_Cloud_Delete_Timestamp__c != null);
        System.assertEquals(true, request1.Marketing_Cloud_Complete__c);
        System.assertEquals(true, request1.Marketing_Cloud_Delete_Timestamp__c != null);
        System.assertEquals(true, request2.Sales_Cloud_Complete__c);
        System.assertEquals(true, request2.Sales_Cloud_Delete_Timestamp__c != null);
        System.assertEquals(true, request2.Marketing_Cloud_Complete__c);
        System.assertEquals(true, request2.Marketing_Cloud_Delete_Timestamp__c != null);
    }

    @IsTest
    static void requestStatusesUpdatedWhenNotNeeded() {
        List<Account> accts = [SELECT Id FROM Account];
        CCPA_Request__c request1 = new CCPA_Request__c(Request_ID__c='111');
        CCPA_Request__c request2 = new CCPA_Request__c(Request_ID__c='222');
        insert new List<CCPA_Request__c> { request1, request2 };
        CCPA_Action__c action1 = new CCPA_Action__c(CCPA_Request__c=request1.Id, Request_ID__c='111', Key_Name__c='AOPS_ACCOUNT',
                                                    Key_Value__c='AOPS_ACCOUNT', Marketing_Cloud_Status__c='No Action');
        CCPA_Action__c action2 = new CCPA_Action__c(CCPA_Request__c=request1.Id, Request_ID__c='111', Key_Name__c='AOPS_CONTACT',
                                                    Key_Value__c='AOPS_ACCOUNT', Marketing_Cloud_Status__c='No Action');
        CCPA_Action__c action3 = new CCPA_Action__c(CCPA_Request__c=request2.Id, Request_ID__c='222', Key_Name__c='CLICKSTREAM_SESSION',
                                                    Key_Value__c='AOPS_ACCOUNT', Marketing_Cloud_Status__c='No Action');
        CCPA_Action__c action4 = new CCPA_Action__c(CCPA_Request__c=request2.Id, Request_ID__c='222', Key_Name__c='CLICKSTREAM_COOKIE',
                                                    Key_Value__c='AOPS_ACCOUNT', Marketing_Cloud_Status__c='No Action');
        insert new List<CCPA_Action__c> { action1, action2, action3, action4 };

        Test.startTest();
        Database.executeBatch(new CCPA_Process_Delete_Requests_Batch(), 10);
        Test.stopTest();

        request1 = [SELECT Id, Sales_Cloud_Complete__c, Sales_Cloud_Delete_Timestamp__c, Marketing_Cloud_Complete__c, Marketing_Cloud_Delete_Timestamp__c FROM CCPA_Request__c WHERE Id =: request1.Id];
        request2 = [SELECT Id, Sales_Cloud_Complete__c, Sales_Cloud_Delete_Timestamp__c, Marketing_Cloud_Complete__c, Marketing_Cloud_Delete_Timestamp__c FROM CCPA_Request__c WHERE Id =: request2.Id];
        System.assertEquals(true, request1.Sales_Cloud_Complete__c);
        System.assertEquals(true, request1.Sales_Cloud_Delete_Timestamp__c != null);
        System.assertEquals(true, request1.Marketing_Cloud_Complete__c);
        System.assertEquals(true, request1.Marketing_Cloud_Delete_Timestamp__c != null);
        System.assertEquals(true, request2.Sales_Cloud_Complete__c);
        System.assertEquals(true, request2.Sales_Cloud_Delete_Timestamp__c != null);
        System.assertEquals(true, request2.Marketing_Cloud_Complete__c);
        System.assertEquals(true, request2.Marketing_Cloud_Delete_Timestamp__c != null);
    }

    @IsTest
    static void requestStatusesNotUpdatedWhenIncomplete() {
        Lead lead1 = new Lead(Email='test1@test.com', LastName='Test1', Company='Test1');
        Lead lead2 = new Lead(Email='test2@test.com', LastName='Test2', Company='Test2');
        Lead lead3 = new Lead(Email='test3@test.com', LastName='Test3', Company='Test3');
        Lead lead4 = new Lead(Email='test4@test.com', LastName='Test4', Company='Test4');
        insert new List<Lead> { lead1, lead2, lead3, lead4 };
        CCPA_Request__c request1 = new CCPA_Request__c(Request_ID__c='111');
        CCPA_Request__c request2 = new CCPA_Request__c(Request_ID__c='222');
        insert new List<CCPA_Request__c> { request1, request2 };
        CCPA_Action__c action1 = new CCPA_Action__c(CCPA_Request__c=request1.Id, Request_ID__c='111', Key_Name__c='EMAIL',
                                                    Key_Value__c='test1@test.com', Marketing_Cloud_Status__c='Completed');
        CCPA_Action__c action2 = new CCPA_Action__c(CCPA_Request__c=request1.Id, Request_ID__c='111', Key_Name__c='EMAIL',
                                                    Key_Value__c='test2@test.com', Marketing_Cloud_Status__c='Processing');
        CCPA_Action__c action3 = new CCPA_Action__c(CCPA_Request__c=request2.Id, Request_ID__c='222', Key_Name__c='EMAIL',
                                                    Key_Value__c='test3@test.com', Marketing_Cloud_Status__c='Failed');
        CCPA_Action__c action4 = new CCPA_Action__c(CCPA_Request__c=request2.Id, Request_ID__c='222', Key_Name__c='EMAIL',
                                                    Key_Value__c='test4@test.com', Marketing_Cloud_Status__c='Completed');
        insert new List<CCPA_Action__c> { action1, action2, action3, action4 };

        Test.startTest();
        CCPA_Process_Delete_Requests_Batch batch = new CCPA_Process_Delete_Requests_Batch();
        batch.processActions(new List<CCPA_Action__c> { action1, action4 });
        Test.stopTest();

        request1 = [SELECT Id, Sales_Cloud_Complete__c, Sales_Cloud_Delete_Timestamp__c, Marketing_Cloud_Complete__c, Marketing_Cloud_Delete_Timestamp__c FROM CCPA_Request__c WHERE Id =: request1.Id];
        request2 = [SELECT Id, Sales_Cloud_Complete__c, Sales_Cloud_Delete_Timestamp__c, Marketing_Cloud_Complete__c, Marketing_Cloud_Delete_Timestamp__c FROM CCPA_Request__c WHERE Id =: request2.Id];
        System.assertEquals(false, request1.Sales_Cloud_Complete__c);
        System.assertEquals(true, request1.Sales_Cloud_Delete_Timestamp__c == null);
        System.assertEquals(false, request1.Marketing_Cloud_Complete__c);
        System.assertEquals(true, request1.Marketing_Cloud_Delete_Timestamp__c == null);
        System.assertEquals(false, request2.Sales_Cloud_Complete__c);
        System.assertEquals(true, request2.Sales_Cloud_Delete_Timestamp__c == null);
        System.assertEquals(false, request2.Marketing_Cloud_Complete__c);
        System.assertEquals(true, request2.Marketing_Cloud_Delete_Timestamp__c == null);
    }

    @IsTest
    static void doesNotResetTimestampForCompletedRequests() {
        Lead lead1 = new Lead(Email='test1@test.com', LastName='Test1', Company='Test1');
        Lead lead2 = new Lead(Email='test2@test.com', LastName='Test2', Company='Test2');
        insert new List<Lead> { lead1, lead2 };
        CCPA_Request__c request1 = new CCPA_Request__c(Request_ID__c='111', Sales_Cloud_Complete__c=true);
        CCPA_Request__c request2 = new CCPA_Request__c(Request_ID__c='222', Marketing_Cloud_Complete__c=true);
        insert new List<CCPA_Request__c> { request1, request2 };
        CCPA_Action__c action1 = new CCPA_Action__c(CCPA_Request__c=request1.Id, Request_ID__c='111', Key_Name__c='EMAIL', Key_Value__c='test1@test.com', Marketing_Cloud_Status__c='Completed');
        CCPA_Action__c action2 = new CCPA_Action__c(CCPA_Request__c=request2.Id, Request_ID__c='222', Key_Name__c='EMAIL', Key_Value__c='test2@test.com', Marketing_Cloud_Status__c='Completed');
        insert new List<CCPA_Action__c> { action1, action2 };

        Test.startTest();
        Database.executeBatch(new CCPA_Process_Delete_Requests_Batch(), 10);
        Test.stopTest();

        request1 = [SELECT Id, Sales_Cloud_Complete__c, Sales_Cloud_Delete_Timestamp__c, Marketing_Cloud_Complete__c, Marketing_Cloud_Delete_Timestamp__c FROM CCPA_Request__c WHERE Id =: request1.Id];
        request2 = [SELECT Id, Sales_Cloud_Complete__c, Sales_Cloud_Delete_Timestamp__c, Marketing_Cloud_Complete__c, Marketing_Cloud_Delete_Timestamp__c FROM CCPA_Request__c WHERE Id =: request2.Id];
        System.assertEquals(true, request1.Marketing_Cloud_Complete__c);
        System.assertNotEquals(null, request1.Marketing_Cloud_Delete_Timestamp__c);
        System.assertEquals(null, request1.Sales_Cloud_Delete_Timestamp__c);
        System.assertEquals(true, request2.Sales_Cloud_Complete__c);
        System.assertNotEquals(null, request2.Sales_Cloud_Delete_Timestamp__c);
        System.assertEquals(null, request2.Marketing_Cloud_Delete_Timestamp__c);
    }

    @IsTest
    static void actionsProcessedAcrossMultipleBatches() {
        Lead lead1 = new Lead(Email='test1@test.com', LastName='Test1', Company='Test1');
        Lead lead2 = new Lead(Email='test2@test.com', LastName='Test2', Company='Test2');
        Lead lead3 = new Lead(Email='test3@test.com', LastName='Test3', Company='Test3');
        Lead lead4 = new Lead(Email='test4@test.com', LastName='Test4', Company='Test4');
        insert new List<Lead> { lead1, lead2, lead3, lead4 };
        CCPA_Request__c request = new CCPA_Request__c(Request_ID__c='111');
        insert request;
        CCPA_Action__c action1 = new CCPA_Action__c(CCPA_Request__c=request.Id, Request_ID__c='111', Key_Name__c='EMAIL', Key_Value__c='test1@test.com', Marketing_Cloud_Status__c='Completed');
        CCPA_Action__c action2 = new CCPA_Action__c(CCPA_Request__c=request.Id, Request_ID__c='111', Key_Name__c='EMAIL', Key_Value__c='test2@test.com', Marketing_Cloud_Status__c='Completed');
        CCPA_Action__c action3 = new CCPA_Action__c(CCPA_Request__c=request.Id, Request_ID__c='111', Key_Name__c='EMAIL', Key_Value__c='test3@test.com', Marketing_Cloud_Status__c='Completed');
        CCPA_Action__c action4 = new CCPA_Action__c(CCPA_Request__c=request.Id, Request_ID__c='111', Key_Name__c='EMAIL', Key_Value__c='test4@test.com', Marketing_Cloud_Status__c='Completed');
        insert new List<CCPA_Action__c> { action1, action2, action3, action4 };

        Test.startTest();
        CCPA_Process_Delete_Requests_Batch cpdrb = new CCPA_Process_Delete_Requests_Batch();
        cpdrb.processActions(new List<CCPA_Action__c> { action1, action2 });
        cpdrb.processActions(new List<CCPA_Action__c> { action3, action4 });
        Test.stopTest();

        List<Lead> lds = [SELECT Id, Email FROM Lead WHERE Id =: lead1.Id OR Id =: lead2.Id OR Id =: lead3.Id OR Id =: lead4.Id];
        action1 = [SELECT Id, Sales_Cloud_Complete__c FROM CCPA_Action__c WHERE Id =: action1.Id];
        action2 = [SELECT Id, Sales_Cloud_Complete__c FROM CCPA_Action__c WHERE Id =: action2.Id];
        action3 = [SELECT Id, Sales_Cloud_Complete__c FROM CCPA_Action__c WHERE Id =: action3.Id];
        action4 = [SELECT Id, Sales_Cloud_Complete__c FROM CCPA_Action__c WHERE Id =: action4.Id];
        request = [SELECT Id, Sales_Cloud_Complete__c, Sales_Cloud_Delete_Timestamp__c, Marketing_Cloud_Complete__c, Marketing_Cloud_Delete_Timestamp__c FROM CCPA_Request__c WHERE Id =: request.Id];
        for(Lead ld : lds) { System.assertEquals('zzz@zzz.com', ld.Email); }
        System.assertEquals(true, action1.Sales_Cloud_Complete__c);
        System.assertEquals(true, action2.Sales_Cloud_Complete__c);
        System.assertEquals(true, action3.Sales_Cloud_Complete__c);
        System.assertEquals(true, action4.Sales_Cloud_Complete__c);
        System.assertEquals(true, request.Sales_Cloud_Complete__c);
        System.assertNotEquals(null, request.Sales_Cloud_Delete_Timestamp__c);
        System.assertEquals(true, request.Marketing_Cloud_Complete__c);
        System.assertNotEquals(null, request.Marketing_Cloud_Delete_Timestamp__c);
    }

    private static Boolean containsAccount(List<Account> accts, Account acct) {
        for(Account a : accts) {
            if(a.Id == acct.Id) { return true; }
        }
        return false;
    }

    private static Boolean containsLead(List<Lead> lds, Lead ld) {
        for(Lead l : lds) {
            if(l.Id == ld.Id) { return true; }
        }
        return false;
    }

    private static Boolean containsCampaignMember(List<CampaignMember> campaignMembers, CampaignMember campaignMem) {
        for(CampaignMember c : campaignMembers) {
            if(c.Id == campaignMem.Id) { return true; }
        }
        return false;
    }

    private static Boolean containsReferral(List<Referral__c> refs, Referral__c ref) {
        for(Referral__c r : refs) {
            if(r.Id == ref.Id) { return true; }
        }
        return false;
    }

    private static Boolean containsEvent(List<Event> evnts, Event evnt) {
        for(Event e : evnts) {
            if(e.Id == evnt.Id) { return true; }
        }
        return false;
    }

    private static Boolean containsEmailMessage(List<EmailMessage> messages, EmailMessage message) {
        for(EmailMessage m : messages) {
            if(m.Id == message.Id) { return true; }
        }
        return false;
    }
}
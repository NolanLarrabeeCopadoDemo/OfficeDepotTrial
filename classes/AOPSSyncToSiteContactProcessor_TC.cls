@IsTest
private class AOPSSyncToSiteContactProcessor_TC {
    
    @IsTest
    static void newSiteContact() {
        Id siteRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();
        List<Account> accts = MyUtilsDataFactory.makeAccounts(1);
        accts[0].RecordTypeId = siteRecordTypeId;
        accts[0].AOPS_Seq_ID__c = '12345678-12345';
        ExecuteOnceTest.OnceProspectMsg = false;
        insert accts;
        List<Contact> cntcts = MyUtilsDataFactory.makeContacts(1);
        cntcts[0].AOPS_Contact_Number__c = '87654321';
        insert cntcts;

        Test.startTest();
        SiteContacts_Final_Staging__c stagingRec = new SiteContacts_Final_Staging__c(AOPS_Account_Number__c='12345678', Shipto_Addr_Seq__c='12345',
                                            AOPS_Contact_Number__c='87654321', Default_Ship_Contact__c='Y', Allowed_To_Buy__c='Y', Purpose__c=null, Is_Changed__c=true);
        insert stagingRec;
        Test.stopTest();

    }

    @IsTest
    static void updateSiteContact() {
        Id siteRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();
        List<Account> accts = MyUtilsDataFactory.makeAccounts(1);
        accts[0].RecordTypeId = siteRecordTypeId;
        accts[0].AOPS_Seq_ID__c = '12345678-12345';
        ExecuteOnceTest.OnceProspectMsg = false;
        insert accts;
        List<Contact> cntcts = MyUtilsDataFactory.makeContacts(1);
        cntcts[0].AOPS_Contact_Number__c = '87654321';
        insert cntcts;
        SiteContacts__c siteContact = new SiteContacts__c(Account__c=accts[0].Id, Contact__c=cntcts[0].Id, Shipto_Addr_Seq__c='11111', Default_Ship_Contact__c='N', Allowed_To_Buy__c='N', Purpose__c=null);
        insert siteContact;

        Test.startTest();
        SiteContacts_Final_Staging__c stagingRec = new SiteContacts_Final_Staging__c(AOPS_Account_Number__c='12345678', Shipto_Addr_Seq__c='12345',
                                            AOPS_Contact_Number__c='87654321', Default_Ship_Contact__c='Y', Allowed_To_Buy__c='Y', Purpose__c=null);
        insert stagingRec;
        Test.stopTest();

        List<SiteContacts__c> siteContacts = [SELECT Id, Account__c, Contact__c, Shipto_Addr_Seq__c, AOPS_Contact_Number__c, AOPS_Account_Number__c, Default_Ship_Contact__c, Allowed_To_Buy__c, Purpose__c FROM SiteContacts__c];
    }

    @IsTest
    static void multipleCreatesAndUpdates() {
        Id siteRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();
        List<Account> accts = MyUtilsDataFactory.makeAccounts(2);
        for(Account acct : accts) acct.RecordTypeId = siteRecordTypeId;
        accts[0].AOPS_Seq_ID__c = '11111111-11111';
        accts[1].AOPS_Seq_ID__c = '22222222-22222';

        ExecuteOnceTest.OnceProspectMsg = false;
        insert accts;
        List<Contact> cntcts = MyUtilsDataFactory.makeContacts(4);
        cntcts[0].AOPS_Contact_Number__c = '22222222';
        cntcts[1].AOPS_Contact_Number__c = '44444444';
        cntcts[2].AOPS_Contact_Number__c = '55555555';
        cntcts[3].AOPS_Contact_Number__c = '66666666';
        insert cntcts;
        SiteContacts__c siteContact1 = new SiteContacts__c(Account__c=accts[0].Id, Contact__c=cntcts[2].Id, Shipto_Addr_Seq__c='22222', Default_Ship_Contact__c='N', Allowed_To_Buy__c='N', Purpose__c=null);
        SiteContacts__c siteContact2 = new SiteContacts__c(Account__c=accts[1].Id, Contact__c=cntcts[3].Id, Shipto_Addr_Seq__c='22222', Default_Ship_Contact__c='N', Allowed_To_Buy__c='N', Purpose__c=null);
        insert new List<SiteContacts__c> { siteContact1, siteContact2 };

        Test.startTest();
        SiteContacts_Final_Staging__c stagingRec1 = new SiteContacts_Final_Staging__c(AOPS_Account_Number__c='11111111', Shipto_Addr_Seq__c='11111',
                                            AOPS_Contact_Number__c='33333333', Default_Ship_Contact__c='Y', Allowed_To_Buy__c='Y', Purpose__c=null);
        SiteContacts_Final_Staging__c stagingRec2 = new SiteContacts_Final_Staging__c(AOPS_Account_Number__c='11111111', Shipto_Addr_Seq__c='11111',
                                            AOPS_Contact_Number__c='44444444', Default_Ship_Contact__c='Y', Allowed_To_Buy__c='Y', Purpose__c=null);
        SiteContacts_Final_Staging__c stagingRec3 = new SiteContacts_Final_Staging__c(AOPS_Account_Number__c='22222222', Shipto_Addr_Seq__c='22222',
                                            AOPS_Contact_Number__c='55555555', Default_Ship_Contact__c='Y', Allowed_To_Buy__c='Y', Purpose__c=null);
        SiteContacts_Final_Staging__c stagingRec4 = new SiteContacts_Final_Staging__c(AOPS_Account_Number__c='22222222', Shipto_Addr_Seq__c='22222',
                                            AOPS_Contact_Number__c='55555555', Default_Ship_Contact__c='Y', Allowed_To_Buy__c='Y', Purpose__c=null, Action__c='D');
        insert new List<SiteContacts_Final_Staging__c> { stagingRec1, stagingRec2, stagingRec3, stagingRec4 };
        Test.stopTest();

    }
    
    @IsTest
    static void errorWhileSyncing() {

        // No Sites or Contacts created, so the sync should fail.
        Test.startTest();
        SiteContacts_Final_Staging__c stagingRec = new SiteContacts_Final_Staging__c(AOPS_Account_Number__c='12345678', Shipto_Addr_Seq__c='12345',
                                            AOPS_Contact_Number__c='87654321', Default_Ship_Contact__c='Y', Allowed_To_Buy__c='Y', Purpose__c=null);
        insert stagingRec;
        Test.stopTest();

        List<SiteContacts__c> createdSiteContacts = [SELECT Id FROM SiteContacts__c];
        List<SiteContacts_Final_Staging__c> createdStagingRecs = [SELECT Id, Sync_Failed__c FROM SiteContacts_Final_Staging__c];
       /* System.assertEquals(0, createdSiteContacts.size());
        System.assertEquals(1, createdStagingRecs.size());
        System.assert(createdStagingRecs[0].Sync_Failed__c); */
    }
    
    @IsTest
    static void addFailedRecords() {
		
        SiteContacts_Final_Staging__c stagingRec = new SiteContacts_Final_Staging__c(AOPS_Account_Number__c='12345678', Shipto_Addr_Seq__c='12345',
                                            AOPS_Contact_Number__c='87654321', Default_Ship_Contact__c='Y', Allowed_To_Buy__c='Y', Purpose__c=null);
        insert stagingRec;
        
		List<SiteContacts_Final_Staging__c> l = new List<SiteContacts_Final_Staging__c>();
        l.add(stagingRec);
        AOPSSyncToSiteContactProcessor proc = new AOPSSyncToSiteContactProcessor(l);
        proc.addToFailureList(stagingRec, 'error');
        try {
        	l = null;
            l.size();
        } catch(Exception ex) {
            proc.handleException(ex);
        }
        
    }
}
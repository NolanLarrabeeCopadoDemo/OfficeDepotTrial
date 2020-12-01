@IsTest
private class AOPSSyncToContactProcessor_TC {

	@IsTest
    static void testProcessor() {
        
        Id custRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        User owner = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' AND IsActive = true LIMIT 1];
        
        Account acc = new Account(Name='TestAcc1', OwnerId=owner.Id, RecordtypeId=custRecordTypeId, Aops_Cust_Id__c='0123456');
        insert acc;
        
        Contact_Final_Staging__c stagingRec1 = new Contact_Final_Staging__c(AOPS_Account_Number__c='0123456',AOPS_Contact_Number__c='12345',
                                    Action__c='C',First_Name__c='fname',Last_Name__c='lname',Is_Contact_Email_Changed__c=true,Is_Contact_Master_Changed__c=true,
                                    Is_Contact_OptIn_Changed__c=true,Is_Contact_Phone_Changed__c=true,Is_Contact_WebUser_Changed__c=true,Sync_Failed__c=false,
                                    Unique_Record_ID__c='012345612345'
                                    );
        
        insert stagingRec1;
    }
    
/*    
    @TestSetup
    static void makeData() {
        Id acctRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Id ownerId = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' LIMIT 1].Id;
        List<Account> accts = MyUtilsDataFactory.makeAccounts(2);
        accts[0].AOPS_Cust_ID__c = '21111111';
        accts[0].OwnerId = ownerId;
        accts[0].RecordTypeId = acctRecordTypeId;
        accts[1].AOPS_Cust_ID__c = '22222222';
        accts[1].OwnerId = ownerId;
        accts[1].RecordTypeId = acctRecordTypeId;
        insert accts;
    }
    
    @IsTest
    static void noAopsIdOrFieldMatch() {
        Id cntctRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact(US)').getRecordTypeId();
        Account acct = [SELECT Id, OwnerId FROM Account WHERE AOPS_Cust_ID__c = '21111111'];
        Contact_Final_Staging__c finalStagingRec = new Contact_Final_Staging__c(Unique_Record_ID__c='01111111', Is_Contact_Master_Changed__c=true,
        AOPS_Contact_Number__c='11111111', AOPS_Account_Number__c='21111111', First_Name__c='FirstTest', Last_Name__c='LastTest');

        Test.startTest();
        insert finalStagingRec;
        Test.stopTest();

        List<Contact> cntcts = [SELECT Id, AOPS_Account_Number__c, FirstName, LastName, AccountId, OwnerId, RecordTypeId FROM Contact WHERE AOPS_Contact_Number__c =: finalStagingRec.AOPS_Contact_Number__c];
        System.assertEquals(1, cntcts.size());
        Contact cntct = cntcts[0];
        System.assertEquals(finalStagingRec.AOPS_Account_Number__c, cntct.AOPS_Account_Number__c);
        System.assertEquals(finalStagingRec.First_Name__c, cntct.FirstName);
        System.assertEquals(finalStagingRec.Last_Name__c, cntct.LastName);
        System.assertEquals(acct.Id, cntct.AccountId);
        System.assertEquals(acct.OwnerId, cntct.OwnerId);
        System.assertEquals(cntctRecordTypeId, cntct.RecordTypeId);
        
        checkStagingRecordMarkedAsSynced(finalStagingRec.Id);
    }

    @IsTest
    static void noAopsIdOrFieldMatchMasterNotUpdated() {
        Contact_Final_Staging__c finalStagingRec = new Contact_Final_Staging__c(Unique_Record_ID__c='01111111',
            Is_Contact_Phone_Changed__c=true, AOPS_Account_Number__c='21111111', AOPS_Contact_Number__c='11111111', Phone1__c='1112223333');

        Test.startTest();
        insert finalStagingRec;
        Test.stopTest();

        List<Contact> cntcts = [SELECT Id, AOPS_Account_Number__c, FirstName, LastName FROM Contact WHERE AOPS_Contact_Number__c =: finalStagingRec.AOPS_Contact_Number__c];
        System.assertEquals(0, cntcts.size());
        
        finalStagingRec = [SELECT Id, Is_Contact_Phone_Changed__c FROM Contact_Final_Staging__c WHERE Id =: finalStagingRec.Id];
        System.assertEquals(true, finalStagingRec.Is_Contact_Phone_Changed__c);
    }

    @IsTest
    static void aopsIdExists() {
        Id cntctRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact(US)').getRecordTypeId();
        Account acct = [SELECT Id, OwnerId FROM Account WHERE AOPS_Cust_ID__c = '21111111'];
        Contact cntct = new Contact(AOPS_Contact_Number__c='11111111', AccountId=acct.Id, OwnerId=acct.OwnerId, RecordTypeId=cntctRecordTypeId,
                                    FirstName='DifferentFirst', LastName = 'DifferentLast');
        insert cntct;
        Contact_Final_Staging__c finalStagingRec = new Contact_Final_Staging__c(Unique_Record_ID__c='01111111', Is_Contact_Master_Changed__c=true,
            AOPS_Contact_Number__c='11111111', AOPS_Account_Number__c='21111111', First_Name__c='FirstTest', Last_Name__c='LastTest', Title__c='Mr.');

        Test.startTest();
        insert finalStagingRec;
        Test.stopTest();

        List<Contact> cntcts = [SELECT Id, AOPS_Account_Number__c, AccountId, OwnerId, RecordTypeId, FirstName, LastName, Title FROM Contact WHERE AOPS_Contact_Number__c =: finalStagingRec.AOPS_Contact_Number__c];
        System.assertEquals(1, cntcts.size());
        cntct = cntcts[0];
        System.assertEquals(finalStagingRec.AOPS_Account_Number__c, cntct.AOPS_Account_Number__c);
        System.assertEquals(finalStagingRec.First_Name__c, cntct.FirstName);
        System.assertEquals(finalStagingRec.Last_Name__c, cntct.LastName);
        System.assertEquals(finalStagingRec.Title__c, cntct.Title);
        System.assertEquals(acct.Id, cntct.AccountId);
        System.assertEquals(acct.OwnerId, cntct.OwnerId);
        System.assertEquals(cntctRecordTypeId, cntct.RecordTypeId);
        
        checkStagingRecordMarkedAsSynced(finalStagingRec.Id);
    }

    @IsTest
    static void noAopsIdFieldsMatch() {
        Id cntctRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact(US)').getRecordTypeId();
        Account acct = [SELECT Id, OwnerId FROM Account WHERE AOPS_Cust_ID__c = '21111111'];
        Contact cntct = new Contact(AOPS_Account_Number__c='21111111', AccountId=acct.Id, OwnerId=acct.OwnerId, RecordTypeId=cntctRecordTypeId,
                                    FirstName='FirstTest', LastName='LastTest', Phone='1112223333');
        insert cntct;
        Contact_Final_Staging__c finalStagingRec = new Contact_Final_Staging__c(Unique_Record_ID__c='01111111', Is_Contact_Phone_Changed__c=true,
            AOPS_Contact_Number__c='11111111', AOPS_Account_Number__c='21111111', First_Name__c='FirstTest', Last_Name__c='LastTest',
            Phone1__c='2222222222', Phone1_Type__c='Mobile');

        Test.startTest();
        insert finalStagingRec;
        Test.stopTest();

        List<Contact> cntcts = [SELECT Id, FirstName, LastName, AOPS_Account_Number__c, AccountId, OwnerId, RecordTypeId, AOPS_Contact_Number__c FROM Contact WHERE AOPS_Contact_Number__c =: finalStagingRec.AOPS_Contact_Number__c];
        System.assertEquals(1, cntcts.size());
        cntct = cntcts[0];
        System.assertEquals(finalStagingRec.AOPS_Account_Number__c, cntct.AOPS_Account_Number__c);
        System.assertEquals(finalStagingRec.AOPS_Contact_Number__c, cntct.AOPS_Contact_Number__c);
        System.assertEquals(finalStagingRec.First_Name__c, cntct.FirstName);
        System.assertEquals(finalStagingRec.Last_Name__c, cntct.LastName);
        System.assertEquals(acct.Id, cntct.AccountId);
        System.assertEquals(acct.OwnerId, cntct.OwnerId);
        System.assertEquals(cntctRecordTypeId, cntct.RecordTypeId);
        
        checkStagingRecordMarkedAsSynced(finalStagingRec.Id);
    }

    @IsTest
    static void onlyRequiredFieldsUpdated() {
        Id cntctRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact(US)').getRecordTypeId();
        Account acct = [SELECT Id, OwnerId FROM Account WHERE AOPS_Cust_ID__c = '21111111'];
        Contact cntct = new Contact(AOPS_Contact_Number__c='11111111', AccountId=acct.Id, OwnerId=acct.OwnerId, RecordTypeId=cntctRecordTypeId,
                                    FirstName='DifferentFirst', LastName='DifferentLast', Title='Mr.', Phone='1112223333');
        insert cntct;
        Contact_Final_Staging__c finalStagingRec = new Contact_Final_Staging__c(Unique_Record_ID__c='01111111', Is_Contact_Phone_Changed__c=true,
            AOPS_Contact_Number__c = '11111111', AOPS_Account_Number__c='21111111', First_Name__c='FirstTest', Last_Name__c='LastTest',
            Phone1__c='1112223333', Phone1_Type__c='Mobile');

        Test.startTest();
        insert finalStagingRec;
        Test.stopTest();

        List<Contact> cntcts = [SELECT Id, FirstName, LastName, Title, AOPS_Account_Number__c FROM Contact WHERE AOPS_Contact_Number__c =: finalStagingRec.AOPS_Contact_Number__c];
        System.assertEquals(1, cntcts.size());
        cntct = cntcts[0];
        System.assertEquals(finalStagingRec.AOPS_Account_Number__c, cntct.AOPS_Account_Number__c);
        System.assertEquals('DifferentFirst', cntct.FirstName);
        System.assertEquals('DifferentLast', cntct.LastName);
        System.assertEquals('Mr.', cntct.Title);
    }

    @IsTest
    static void multipleStagingRecords() {
        Id cntctRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact(US)').getRecordTypeId();
        Id ownerId = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' LIMIT 1].Id;
        Account acct1 = [SELECT Id, OwnerId FROM Account WHERE AOPS_Cust_ID__c = '21111111'];
        Account acct2 = [SELECT Id, OwnerId FROM Account WHERE AOPS_Cust_ID__c = '22222222'];
        Contact cntct1 = new Contact(AOPS_Contact_Number__c='11111111', AccountId=acct1.Id, OwnerId=acct1.OwnerId, RecordTypeId=cntctRecordTypeId,
                                    FirstName='DifferentFirst1', LastName='DifferentLast1');
        Contact cntct2 = new Contact(AOPS_Account_Number__c='22222222', AccountId=acct2.Id, OwnerId=acct2.OwnerId, RecordTypeId=cntctRecordTypeId,
                                    FirstName='FirstTest2', LastName='LastTest2', Phone='1112223333');
        insert new List<Contact> { cntct1, cntct2 };
        Contact_Final_Staging__c finalStagingRec1 = new Contact_Final_Staging__c(Unique_Record_ID__c='01111111', Is_Contact_Master_Changed__c=true,
            AOPS_Contact_Number__c='11111111', AOPS_Account_Number__c='21111111', First_Name__c='FirstTest1', Last_Name__c='LastTest1', Title__c='Mr.');
        Contact_Final_Staging__c finalStagingRec2 = new Contact_Final_Staging__c(Unique_Record_ID__c='02222222', Is_Contact_Master_Changed__c=true,
            AOPS_Contact_Number__c='12222222', AOPS_Account_Number__c='22222222', First_Name__c='FirstTest2', Last_Name__c='LastTest2',
            Phone1__c='1112223333', Phone1_Type__c='Mobile', Title__c='Mr.');
        Contact_Final_Staging__c finalStagingRec3 = new Contact_Final_Staging__c(Unique_Record_ID__c='03333333', Is_Contact_Master_Changed__c=true,
            AOPS_Contact_Number__c='13333333', AOPS_Account_Number__c='21111111', First_Name__c='FirstTest3', Last_Name__c='LastTest3');
        Contact_Final_Staging__c finalStagingRec4 = new Contact_Final_Staging__c(Unique_Record_ID__c='04444444', Is_Contact_Master_Changed__c=true,
            AOPS_Contact_Number__c='14444444', AOPS_Account_Number__c='22222222', First_Name__c='FirstTest4', Last_Name__c='LastTest4');

        Test.startTest();
        insert new List<Contact_Final_Staging__c> { finalStagingRec1, finalStagingRec2, finalStagingRec3, finalStagingRec4 };
        Test.stopTest();

        List<Contact> updatedCntct1 = [SELECT Id, AOPS_Account_Number__c, FirstName, LastName, Title FROM Contact WHERE AOPS_Contact_Number__c = '11111111'];
        List<Contact> updatedCntct2 = [SELECT Id, AOPS_Account_Number__c, FirstName, LastName, Title FROM Contact WHERE AOPS_Contact_Number__c = '12222222'];
        List<Contact> createdCntct3 = [SELECT Id, AOPS_Account_Number__c, FirstName, LastName, Title FROM Contact WHERE AOPS_Contact_Number__c = '13333333'];
        List<Contact> createdCntct4 = [SELECT Id, AOPS_Account_Number__c, FirstName, LastName, Title FROM Contact WHERE AOPS_Contact_Number__c = '14444444'];

        System.assertEquals(1, updatedCntct1.size());
        System.assertEquals(finalStagingRec1.Title__c, updatedCntct1[0].Title);
        checkStagingRecordMarkedAsSynced(finalStagingRec1.Id);
        System.assertEquals(1, updatedCntct2.size());
        System.assertEquals(finalStagingRec2.Title__c, updatedCntct2[0].Title);
        checkStagingRecordMarkedAsSynced(finalStagingRec2.Id);
        System.assertEquals(1, createdCntct3.size());
        checkStagingRecordMarkedAsSynced(finalStagingRec3.Id);
        System.assertEquals(1, createdCntct4.size());
        checkStagingRecordMarkedAsSynced(finalStagingRec4.Id);
    }

    @IsTest
    static void phoneFieldUpdates() {
        Id cntctRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact(US)').getRecordTypeId();
        Account acct = [SELECT Id, OwnerId FROM Account WHERE AOPS_Cust_ID__c = '21111111'];
        Contact cntct = new Contact(AOPS_Contact_Number__c='11111111', AccountId=acct.Id, OwnerId=acct.OwnerId, RecordTypeId=cntctRecordTypeId,
                                    FirstName='DifferentFirst', LastName = 'DifferentLast', Phone='3332221111');
        insert cntct;
        Contact_Final_Staging__c finalStagingRec = new Contact_Final_Staging__c(Unique_Record_ID__c='01111111', Is_Contact_Phone_Changed__c=true,
            AOPS_Contact_Number__c='11111111', AOPS_Account_Number__c='21111111', Phone1__c='1112223333', Default_Phone1__c='Y');

        Test.startTest();
        insert finalStagingRec;
        Test.stopTest();

        List<Contact> cntcts = [SELECT Id, Phone_1_AOPS__c, Phone, SFDC_Phone_Number__c, Phone_Changed_By_AOPS__c FROM Contact WHERE AOPS_Contact_Number__c =: finalStagingRec.AOPS_Contact_Number__c];
        System.assertEquals(1, cntcts.size());
        System.assertEquals(finalStagingRec.Phone1__c, cntcts[0].Phone_1_AOPS__c);
        System.assertEquals(finalStagingRec.Phone1__c, cntcts[0].Phone);
        System.assertEquals('3332221111', cntcts[0].SFDC_Phone_Number__c);
        System.assertEquals(true, cntcts[0].Phone_Changed_By_AOPS__c);
    }

    @IsTest
    static void emailFieldUpdates() {
        Id cntctRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact(US)').getRecordTypeId();
        Account acct = [SELECT Id, OwnerId FROM Account WHERE AOPS_Cust_ID__c = '21111111'];
        Contact cntct = new Contact(AOPS_Contact_Number__c='11111111', AccountId=acct.Id, OwnerId=acct.OwnerId, RecordTypeId=cntctRecordTypeId,
                                    FirstName='DifferentFirst', LastName = 'DifferentLast', Email='different@test.com');
        insert cntct;
        Contact_Final_Staging__c finalStagingRec = new Contact_Final_Staging__c(Unique_Record_ID__c='01111111', Is_Contact_Email_Changed__c=true,
            AOPS_Contact_Number__c='11111111', AOPS_Account_Number__c='21111111', Email1__c='test@test.com', Default_Email1__c='Y');

        Test.startTest();
        insert finalStagingRec;
        Test.stopTest();

        List<Contact> cntcts = [SELECT Id, Email_1_AOPS__c, Email, SFDC_Email_Address__c, Email_Changed_By_AOPS__c FROM Contact WHERE AOPS_Contact_Number__c =: finalStagingRec.AOPS_Contact_Number__c];
        System.assertEquals(1, cntcts.size());
        System.assertEquals(finalStagingRec.Email1__c, cntcts[0].Email_1_AOPS__c);
        System.assertEquals(finalStagingRec.Email1__c, cntcts[0].Email);
        System.assertEquals('different@test.com', cntcts[0].SFDC_Email_Address__c);
        System.assertEquals(true, cntcts[0].Email_Changed_By_AOPS__c);
    }

    @IsTest
    static void optInFieldUpdates() {
        Id cntctRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact(US)').getRecordTypeId();
        Account acct = [SELECT Id, OwnerId FROM Account WHERE AOPS_Cust_ID__c = '21111111'];
        Contact cntct = new Contact(AOPS_Contact_Number__c='11111111', AccountId=acct.Id, OwnerId=acct.OwnerId, RecordTypeId=cntctRecordTypeId,
                                    FirstName='DifferentFirst', LastName = 'DifferentLast', P_OptIn1__c='Y');
        insert cntct;
        Contact_Final_Staging__c finalStagingRec = new Contact_Final_Staging__c(Unique_Record_ID__c='01111111', Is_Contact_OptIn_Changed__c=true,
            AOPS_Contact_Number__c='11111111', AOPS_Account_Number__c='21111111', P_OptIn1__c='N');

        Test.startTest();
        insert finalStagingRec;
        Test.stopTest();

        List<Contact> cntcts = [SELECT Id, P_OptIn1__c FROM Contact WHERE AOPS_Contact_Number__c =: finalStagingRec.AOPS_Contact_Number__c];
        System.assertEquals(1, cntcts.size());
        System.assertEquals(finalStagingRec.P_OptIn1__c, cntcts[0].P_OptIn1__c);
    }

    @IsTest
    static void webUserFieldUpdates() {
        Id cntctRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact(US)').getRecordTypeId();
        Account acct = [SELECT Id, OwnerId FROM Account WHERE AOPS_Cust_ID__c = '21111111'];
        Contact cntct = new Contact(AOPS_Contact_Number__c='11111111', AccountId=acct.Id, OwnerId=acct.OwnerId, RecordTypeId=cntctRecordTypeId,
                                    FirstName='DifferentFirst', LastName = 'DifferentLast');
        insert cntct;
        Contact_Final_Staging__c finalStagingRec = new Contact_Final_Staging__c(Unique_Record_ID__c='01111111', Is_Contact_WebUser_Changed__c=true,
            AOPS_Contact_Number__c='11111111', AOPS_Account_Number__c='21111111', Web_Username__c='Test');

        Test.startTest();
        insert finalStagingRec;
        Test.stopTest();

        List<Contact> cntcts = [SELECT Id, Web_Username__c FROM Contact WHERE AOPS_Contact_Number__c =: finalStagingRec.AOPS_Contact_Number__c];
        System.assertEquals(1, cntcts.size());
        System.assertEquals(finalStagingRec.Web_Username__c, cntcts[0].Web_Username__c);
    }

    @IsTest
    static void recordFails() {
        Contact_Final_Staging__c finalStagingRec1 = new Contact_Final_Staging__c(Unique_Record_ID__c='01111111', Is_Contact_Master_Changed__c=true,
            AOPS_Contact_Number__c='11111111', AOPS_Account_Number__c='21111111', First_Name__c='FirstTest1', Last_Name__c='LastTest1');
        Contact_Final_Staging__c finalStagingRec2 = new Contact_Final_Staging__c(Unique_Record_ID__c='02222222', Is_Contact_Master_Changed__c=true,
            AOPS_Contact_Number__c='12222222');

        Test.startTest();
        insert new List<Contact_Final_Staging__c> { finalStagingRec1, finalStagingRec2 };
        Test.stopTest();

        List<Contact> createdCntct1 = [SELECT Id, AOPS_Account_Number__c, FirstName, LastName, Title FROM Contact WHERE AOPS_Contact_Number__c = '11111111'];
        List<Contact> createdCntct2 = [SELECT Id, AOPS_Account_Number__c, FirstName, LastName, Title FROM Contact WHERE AOPS_Contact_Number__c = '12222222'];
        List<Contact_Final_Staging__c> createdStaging1 = [SELECT Id, Is_Contact_Master_Changed__c, Sync_Failed__c FROM Contact_Final_Staging__c WHERE Unique_Record_ID__c = '01111111'];
        List<Contact_Final_Staging__c> createdStaging2 = [SELECT Id, Is_Contact_Master_Changed__c, Sync_Failed__c FROM Contact_Final_Staging__c WHERE Unique_Record_ID__c = '02222222'];

        System.assertEquals(0, createdCntct1.size());
        System.assertEquals(0, createdCntct2.size());

        System.assertEquals(1, createdStaging1.size());
        System.assertEquals(true, createdStaging1[0].Is_Contact_Master_Changed__c);
        System.assertEquals(true, AOPSSyncToContactProcessor.isFailedRecord(createdStaging1[0]));
        System.assertEquals(1, createdStaging2.size());
        System.assertEquals(true, createdStaging2[0].Is_Contact_Master_Changed__c);
        System.assertEquals(true, AOPSSyncToContactProcessor.isFailedRecord(createdStaging2[0]));
    }


    // Opt In Out Tests.

    @IsTest
    static void newOptInOutNewContact() {
        Contact_Final_Staging__c finalStagingRec = new Contact_Final_Staging__c(Unique_Record_ID__c='01111111', Is_Contact_Master_Changed__c=true,
        Is_Contact_OptIn_Changed__c=true, AOPS_Contact_Number__c='11111111', AOPS_Account_Number__c='21111111', First_Name__c='FirstTest',
        Last_Name__c='LastTest', E_OptIn1__c='Y');

        Test.startTest();
        insert finalStagingRec;
        Test.stopTest();

        List<AOPSContactOptInOut__c> optInOuts = [SELECT Id, Contact_ID__c, Email_1_OptIn_AOPS__c, Email_1_Opt_Date__c FROM AOPSContactOptInOut__c];
        System.assertEquals(1, optInOuts.size());
        System.assertNotEquals(null, optInOuts[0].Contact_ID__c);
        System.assertEquals('Y', optInOuts[0].Email_1_OptIn_AOPS__c);
        System.assertNotEquals(null, optInOuts[0].Email_1_Opt_Date__c);
    }

    @IsTest
    static void newOptInOutOldContact() {
        Contact cntct = new Contact(AOPS_Contact_Number__c='11111111', FirstName='DifferentFirst', LastName = 'DifferentLast', E_OptIn1__c='Y');
        insert cntct;
        Contact_Final_Staging__c finalStagingRec = new Contact_Final_Staging__c(Unique_Record_ID__c='01111111', Is_Contact_Master_Changed__c=true,
        Is_Contact_OptIn_Changed__c=true, AOPS_Contact_Number__c='11111111', AOPS_Account_Number__c='21111111', First_Name__c='FirstTest',
        Last_Name__c='LastTest', E_OptIn1__c='N');

        Test.startTest();
        insert finalStagingRec;
        Test.stopTest();

        List<AOPSContactOptInOut__c> optInOuts = [SELECT Id, Contact_ID__c, Email_1_OptIn_AOPS__c, Email_1_Opt_Date__c FROM AOPSContactOptInOut__c];
        System.assertEquals(1, optInOuts.size());
        System.assertEquals(cntct.Id, optInOuts[0].Contact_ID__c);
        System.assertEquals('N', optInOuts[0].Email_1_OptIn_AOPS__c);
        System.assertNotEquals(null, optInOuts[0].Email_1_Opt_Date__c);
    }

    @IsTest
    static void updateOptInOut() {
        Contact cntct = new Contact(AOPS_Contact_Number__c='11111111', FirstName='DifferentFirst', LastName = 'DifferentLast', E_OptIn1__c='Y');
        insert cntct;
        AOPSContactOptInOut__c optInOut = new AOPSContactOptInOut__c(Contact_ID__c=cntct.Id, Email_1_OptIn_AOPS__c='Y', Email_1_Opt_Date__c=DateTime.newInstance(2020, 5, 1));
        insert optInOut;
        Contact_Final_Staging__c finalStagingRec = new Contact_Final_Staging__c(Unique_Record_ID__c='01111111', Is_Contact_Master_Changed__c=true,
        Is_Contact_OptIn_Changed__c=true, AOPS_Contact_Number__c='11111111', AOPS_Account_Number__c='21111111', First_Name__c='FirstTest',
        Last_Name__c='LastTest', E_OptIn1__c='N');

        Test.startTest();
        insert finalStagingRec;
        Test.stopTest();

        List<AOPSContactOptInOut__c> optInOuts = [SELECT Id, Contact_ID__c, Email_1_OptIn_AOPS__c, Email_1_Opt_Date__c FROM AOPSContactOptInOut__c];
        System.assertEquals(1, optInOuts.size());
        System.assertEquals(cntct.Id, optInOuts[0].Contact_ID__c);
        System.assertEquals('N', optInOuts[0].Email_1_OptIn_AOPS__c);
        System.assert(optInOuts[0].Email_1_Opt_Date__c > optInOut.Email_1_Opt_Date__c);
    }

    @IsTest
    static void optInOutEmailSet() {
        Contact_Final_Staging__c finalStagingRec = new Contact_Final_Staging__c(Unique_Record_ID__c='01111111', Is_Contact_Master_Changed__c=true,
            Is_Contact_Email_Changed__c=true, AOPS_Contact_Number__c='11111111', AOPS_Account_Number__c='21111111', First_Name__c='FirstTest',
            Last_Name__c='LastTest', Email1__c='test@test.com', Email1_AOPS_Seq__c='1234', Email1_Type__c='Test');

        Test.startTest();
        insert finalStagingRec;
        Test.stopTest();

        List<AOPSContactOptInOut__c> optInOuts = [SELECT Id, Email_1_AOPS__c, Email_1_AOPS_Seq__c, Email_1_Type_AOPS__c, Email_1_OptIn_AOPS__c, Email_1_Opt_Date__c FROM AOPSContactOptInOut__c];
        System.assertEquals(1, optInOuts.size());
        System.assertEquals(finalStagingRec.Email1__c, optInOuts[0].Email_1_AOPS__c);
        System.assertEquals(finalStagingRec.Email1_AOPS_Seq__c, optInOuts[0].Email_1_AOPS_Seq__c);
        System.assertEquals(finalStagingRec.Email1_Type__c, optInOuts[0].Email_1_Type_AOPS__c);
        System.assertEquals('Y', optInOuts[0].Email_1_OptIn_AOPS__c);
        System.assertNotEquals(null, optInOuts[0].Email_1_Opt_Date__c);
    }

    @IsTest
    static void optInOutPhoneSet() {
        Contact_Final_Staging__c finalStagingRec = new Contact_Final_Staging__c(Unique_Record_ID__c='01111111', Is_Contact_Master_Changed__c=true,
            Is_Contact_Phone_Changed__c=true, AOPS_Contact_Number__c='11111111', AOPS_Account_Number__c='21111111', First_Name__c='FirstTest',
            Last_Name__c='LastTest', Phone1__c='(111) 222-3333', Phone_EXT__c='1234', Phone1_AOPS_Seq__c='1234', Phone1_Type__c='Mobile');

        Test.startTest();
        insert finalStagingRec;
        Test.stopTest();

        List<AOPSContactOptInOut__c> optInOuts = [SELECT Id, Phone_1_AOPS__c, Phone_1_Ext_AOPS__c, Phone_1_AOPS_Seq__c, Phone_1_Type_AOPS__c, Phone_1_OptIn_AOPS__c, Phone_1_Opt_Date__c FROM AOPSContactOptInOut__c];
        System.assertEquals(1, optInOuts.size());
        System.assertEquals(finalStagingRec.Phone1__c, optInOuts[0].Phone_1_AOPS__c);
        System.assertEquals(finalStagingRec.Phone_EXT__c, optInOuts[0].Phone_1_Ext_AOPS__c);
        System.assertEquals(finalStagingRec.Phone1_AOPS_Seq__c, optInOuts[0].Phone_1_AOPS_Seq__c);
        System.assertEquals(finalStagingRec.Phone1_Type__c, optInOuts[0].Phone_1_Type_AOPS__c);
        System.assertEquals('Y', optInOuts[0].Phone_1_OptIn_AOPS__c);
        System.assertNotEquals(null, optInOuts[0].Phone_1_Opt_Date__c);
    }

    @IsTest
    static void optInOutNoUpdateNeeded() {
        Contact cntct = new Contact(AOPS_Contact_Number__c='11111111', FirstName='DifferentFirst', LastName = 'DifferentLast', E_OptIn1__c='Y');
        insert cntct;
        AOPSContactOptInOut__c optInOut = new AOPSContactOptInOut__c(Contact_ID__c=cntct.Id, Email_1_OptIn_AOPS__c='Y', Email_1_Opt_Date__c=DateTime.newInstance(2020, 5, 1));
        insert optInOut;
        Contact_Final_Staging__c finalStagingRec = new Contact_Final_Staging__c(Unique_Record_ID__c='01111111', AOPS_Contact_Number__c='11111111',
        AOPS_Account_Number__c='21111111', First_Name__c='FirstTest', Last_Name__c='LastTest', E_OptIn1__c='N');

        Test.startTest();
        insert finalStagingRec;
        Test.stopTest();

        List<AOPSContactOptInOut__c> optInOuts = [SELECT Id, Contact_ID__c, Email_1_OptIn_AOPS__c, Email_1_Opt_Date__c FROM AOPSContactOptInOut__c];
        System.assertEquals(1, optInOuts.size());
        System.assertEquals('Y', optInOuts[0].Email_1_OptIn_AOPS__c);
        System.assert(optInOuts[0].Email_1_Opt_Date__c == optInOut.Email_1_Opt_Date__c);
    }

    @IsTest
    static void optInOutMultipleCreatesAndUpdates() {
        Contact cntct1 = new Contact(AOPS_Contact_Number__c='11111111', FirstName='DifferentFirst1', LastName = 'DifferentLast1', E_OptIn1__c='Y');
        Contact cntct2 = new Contact(AOPS_Contact_Number__c='22222222', FirstName='DifferentFirst2', LastName = 'DifferentLast2', E_OptIn1__c='Y');
        Contact cntct3 = new Contact(AOPS_Contact_Number__c='33333333', FirstName='DifferentFirst3', LastName = 'DifferentLast3', E_OptIn1__c='Y');
        Contact cntct4 = new Contact(AOPS_Contact_Number__c='44444444', FirstName='DifferentFirst4', LastName = 'DifferentLast4', E_OptIn1__c='Y');
        insert new List<Contact> { cntct1, cntct2, cntct3, cntct4 };
        AOPSContactOptInOut__c optInOut1 = new AOPSContactOptInOut__c(Contact_ID__c=cntct2.Id, Email_1_OptIn_AOPS__c='Y', Email_1_Opt_Date__c=DateTime.newInstance(2020, 5, 1));
        AOPSContactOptInOut__c optInOut2 = new AOPSContactOptInOut__c(Contact_ID__c=cntct4.Id, Email_1_OptIn_AOPS__c='Y', Email_1_Opt_Date__c=DateTime.newInstance(2020, 5, 1));
        insert new List<AOPSContactOptInOut__c> { optInOut1, optInOut2 };
        Contact_Final_Staging__c finalStagingRec1 = new Contact_Final_Staging__c(Unique_Record_ID__c='01111111', Is_Contact_Master_Changed__c=true,
            Is_Contact_OptIn_Changed__c=true, AOPS_Contact_Number__c='11111111', AOPS_Account_Number__c='21111111', First_Name__c='FirstTest1',
            Last_Name__c='LastTest1', E_OptIn1__c='N');
        Contact_Final_Staging__c finalStagingRec2 = new Contact_Final_Staging__c(Unique_Record_ID__c='02222222', Is_Contact_Master_Changed__c=true,
            Is_Contact_OptIn_Changed__c=true, AOPS_Contact_Number__c='22222222', AOPS_Account_Number__c='21111111', First_Name__c='FirstTest2',
            Last_Name__c='LastTest2', E_OptIn1__c='N');
        Contact_Final_Staging__c finalStagingRec3 = new Contact_Final_Staging__c(Unique_Record_ID__c='03333333', Is_Contact_Master_Changed__c=true,
            Is_Contact_OptIn_Changed__c=true, AOPS_Contact_Number__c='33333333', AOPS_Account_Number__c='21111111', First_Name__c='FirstTest3',
            Last_Name__c='LastTest3', E_OptIn1__c='N');
        Contact_Final_Staging__c finalStagingRec4 = new Contact_Final_Staging__c(Unique_Record_ID__c='04444444', Is_Contact_Master_Changed__c=true,
            Is_Contact_OptIn_Changed__c=true, AOPS_Contact_Number__c='44444444', AOPS_Account_Number__c='21111111', First_Name__c='FirstTest4',
            Last_Name__c='LastTest4', E_OptIn1__c='N');

        Test.startTest();
        insert new List<Contact_Final_Staging__c> { finalStagingRec1, finalStagingRec2, finalStagingRec3, finalStagingRec4 };
        Test.stopTest();

        List<AOPSContactOptInOut__c> optInOuts = [SELECT Id, Contact_ID__c, Email_1_OptIn_AOPS__c, Email_1_Opt_Date__c FROM AOPSContactOptInOut__c];
        System.assertEquals(4, optInOuts.size());
        for(AOPSContactOptInOut__c optInOut : optInOuts) {
            System.assertEquals('N', optInOut.Email_1_OptIn_AOPS__c);
            System.assert(optInOut.Email_1_Opt_Date__c > DateTime.newInstance(2020, 5, 1));
        }
    }

    private static void checkStagingRecordMarkedAsSynced(Id sfdcId) {
        Contact_Final_Staging__c finalStagingRec = [SELECT Id, Is_Contact_Master_Changed__c, Is_Contact_Phone_Changed__c,
                Is_Contact_Email_Changed__c, Is_Contact_OptIn_Changed__c, Is_Contact_WebUser_Changed__c FROM Contact_Final_Staging__c WHERE Id =: sfdcId];
        
        System.assertEquals(false, finalStagingRec.Is_Contact_Master_Changed__c);
        System.assertEquals(false, finalStagingRec.Is_Contact_Phone_Changed__c);
        System.assertEquals(false, finalStagingRec.Is_Contact_Email_Changed__c);
        System.assertEquals(false, finalStagingRec.Is_Contact_OptIn_Changed__c);
        System.assertEquals(false, finalStagingRec.Is_Contact_WebUser_Changed__c);
    }
*/
}
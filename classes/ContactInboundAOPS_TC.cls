//
// (c) 2015 Appirio, Inc.
//
// Test class for ContactInboundAOPS
//
// 11 Mar 2015     Appirio CM (JGUPTA) - S-294658 (Office Depot Case 340885)
//
//


@isTest
private class ContactInboundAOPS_TC {
    static account acc ;
    static testMethod void myUnitTest() {

        String aopsCon = '123123' ;
        String aopsAcc = '111' ;

        createTestData() ;
        acc.AOPS_Cust_Id__c = aopsAcc ;
        insert acc ;

        ContactInboundAOPS.ContactInboundWrapper con = createContactData(aopsCon,aopsAcc, '1') ;
        // Insert new contact since there is no already existing contact with same aops contact number
        ContactInboundAOPS.upsertContactList(new List<ContactInboundAOPS.ContactInboundWrapper>{con});

        List<Contact> conList = new List<Contact>([Select ID from Contact where AOPS_Contact_Number__c = :aopsCon ]);
        system.assertEquals(1,conList.size());

    }

    static testMethod void myUnitTest1() {

        String aopsCon = '123123' ;
        String aopsAcc = '111' ;

        createTestData() ;
        acc.AOPS_Cust_Id__c = aopsAcc ;
        insert acc ;

        //START S-420971 (OD 00731422) [Hemant 6/30/2016] - Increase code coverage
        GPO_Template__c gpoTemp = Test_Utils.createGPOTemplate('Sample Template',true);
        GPO_Community_Setup__c gpoCommunitySetup = Test_Utils.createGPOCommunitySetUp(gpoTemp,true);
        GPO_Group__c gpoGroup = Test_Utils.createGPOGroup(gpoTemp, acc, false);
        gpoGroup.Welcome_Title__c = 'Test GPO Group Title';
        gpoGroup.Activated__c = true;
        gpoGroup.RecordTypeId = gpoCommunitySetup.defaultRecordType__c;
        insert gpoGroup;

        system.assertNotEquals(null, gpoGroup.Id);
        //END S-420971 (OD 00731422) [Hemant 6/30/2016] - Increase code coverage

        ContactInboundAOPS.ContactInboundWrapper con = createContactData(aopsCon,aopsAcc, '1') ;
        // Create new single contact
        // ContactInboundAOPS.upsertContact('testfname', 'testlName', '21422233333','testSingleCOntact1@test.com', '123web', 'VP', 'Active', aopsCon, aopsAcc, '2');
        ContactInboundAOPS.upsertContact(con);
        List<Contact> conList1 = new List<Contact>([Select ID from Contact where AOPS_Contact_Number__c = :aopsCon ]);
        system.assertEquals(1,conList1.size());

        // update existing created contact with same aops contact number
        ContactInboundAOPS.upsertContactList(new List<ContactInboundAOPS.ContactInboundWrapper>{con});

        List<Contact> conList2 = new List<Contact>([Select ID from Contact where AOPS_Contact_Number__c = :aopsCon ]);
        system.assertEquals(1,conList2.size());

        //START S-420971 (OD 00731422) [Hemant 6/30/2016] - Increase code coverage
        con = createContactData(null,null,'1') ;
        ContactInboundAOPS.upsertContact(con);

        con = createContactData('98989','22222','1') ;
        ContactInboundAOPS.upsertContact(con);

        con = createContactData('98989',aopsAcc, '1') ;
        con.webUserName = null;
        ContactInboundAOPS.upsertContact(con);

        String s = ContactInboundAOPS.convertNull('#N/A');
        s = ContactInboundAOPS.convertNull('TEST str');

        Contact contact = new Contact(LastName = 'Test_lastName', AccountId = acc.Id, MailingCountry = 'MEX', AOPS_Contact_Number__c = aopsCon);
        insert contact;
        system.assertNotEquals(null, contact.Id);

        con = createContactData(aopsCon,aopsAcc, '1') ;
        ContactInboundAOPS.upsertContact(con);
    }

    static testMethod void ContactInboundAOPSTest(){
        ContactInboundAOPS.ContactInboundWrapper conWrap = createContactData('111', '222', '1');
        conWrap.status = 'I';
        Account testAccount = Test_Utils.CreateAccount('Prospect');
        testAccount.AOPS_Cust_Id__c = '222';

        Contact testContact = new Contact();
        testContact.FirstName = 'Test';
        testContact.LastName = 'Contact';
        testContact.Email = 'test@test.com';
        testContact.AOPS_Contact_Number__c = '111';
        gpo_lead__c testLead = new gpo_lead__c();
        testLead.Email__c = 'testclass@testing.com';
        testLead.Private__c = true;
        Profile p = [SELECT Id FROM Profile WHERE Name='Customer Community Login User - GPO User'];
        User u = new User(Alias = 'standt', Email='standarduser@example.com',
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', ProfileId = p.Id,
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@example.com');
        User runUser = [Select Id from User where Profile.Name = 'System Administrator' AND Id != :UserInfo.getUserId() AND isActive= true limit 1];
        Test.StartTest();
        insert testAccount;

        GPO_Template__c gpoTemp = Test_Utils.createGPOTemplate('Sample Template',true);
        GPO_Community_Setup__c gpoCommunitySetup = Test_Utils.createGPOCommunitySetUp(gpoTemp,true);
        GPO_Group__c gpoGroup = Test_Utils.createGPOGroup(gpoTemp, testAccount, false);
        gpoGroup.Welcome_Title__c = 'Test GPO Group Title';
        gpoGroup.Activated__c = true;
        gpoGroup.RecordTypeId = gpoCommunitySetup.defaultRecordType__c;
        gpoGroup.Account__c = testAccount.Id;
        insert gpoGroup;

        testContact.AccountId = testAccount.Id;
        insert testContact;
        testLead.Account__c = testAccount.Id;
        insert testLead;
        u.ContactId = testContact.id;
        system.runAs(runUser){
            insert u;
        }
        ContactInboundAOPS.upsertContact(conWrap);
        Test.StopTest();
        List<Contact> conList = new List<Contact>([Select ID from Contact where AOPS_Contact_Number__c = '111' ]);
        system.assertEquals(1,conList.size());
    }
    //END S-420971 (OD 00731422) [Hemant 6/30/2016] - Increase code coverage

    static void createTestData() {
        acc= Test_Utils.CreateAccount('Prospect');
    }

    static ContactInboundAOPS.ContactInboundWrapper createContactData(String aopsConId, String aopsAccID, string seqNum ) {
        ContactInboundAOPS.ContactInboundWrapper con = new ContactInboundAOPS.ContactInboundWrapper();
        double longtime = system.now().getTime() ;
        con.fName = 'Test Contact'+longtime ;
        con.lName = 'Test Last Name' ;
        con.phone = '1090121212';
        con.email = 'testclass'+longtime +'@testing.com';
        con.webUserName = 'web123';
        con.role = 'CEO' ;
        con.aopsCntId = aopsConId ;
        con.aopsActId = aopsAccID ;
        con.aopsSequenceNum = seqNum  ;
        return con ;
    }
}
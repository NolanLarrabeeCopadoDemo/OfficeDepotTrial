@isTest
public without sharing class SearchOrCreateSiteContact_Test {


    @TestSetup
    static void makeData(){
        Schema.RecordTypeInfo customer = MyUtils.getRecordTypeInfo('Account',
                                                                   'Customer');
        Schema.RecordTypeInfo site =
            MyUtils.getRecordTypeInfo('Account', 'Site');
        Schema.RecordTypeInfo contact_us = MyUtils.getRecordTypeInfo('Contact',
                                                                     'Contact_US');
        Account my_customer_account = new Account(
            Name='Test Customer',
            RecordTypeId = customer.getRecordTypeId(),
            AOPS_Cust_Id__c ='00092382'
            );

        insert my_customer_account;

        Account my_site_account = new Account(
            Name='Test Customer_Site',
            RecordTypeId = site.getRecordTypeId(),
            AOPS_Seq_ID__c ='00092382-0001',
            Related_Account__c = my_customer_account.Id
            );
        insert my_site_account;
        List<Contact> my_contacts = new List<Contact>{
            new Contact(
                FirstName='Some',
                LastName='Tester',
                Email='SomeTest@yop.com',
                AccountId=my_customer_account.Id,
                RecordTypeId=contact_us.getRecordTypeId()
            ),
            new Contact(
                FirstName='Some',
                LastName='Tester3',
                Email='SomeTest3@yop.com',
                AccountId=my_customer_account.Id,
                RecordTypeId=contact_us.getRecordTypeId()
            )
        };
        insert my_contacts;

    }

    @isTest
    public static void test_createSiteExistingContact(){
        Account my_site = [SELECT Id FROM Account WHERE AOPS_Seq_ID__c = '00092382-0001'];
        Contact my_contact = [SELECT Id FROM Contact WHERE Email = 'SomeTest@yop.com'];
        Test.startTest();

        SearchOrCreateSiteContact.createSiteExistingContact(my_site.Id,
                                                            my_contact.Id);

        Test.stopTest();
        SiteContacts__c my_site_contact = 
        [
            SELECT 
                Id 
            FROM SiteContacts__c 
            WHERE Account__c = :my_site.Id 
            AND Contact__c = :my_contact.Id
        ];

    }

    @isTest
    public static void test_getParentAccount(){
        Account my_customer = [SELECT Id FROM Account WHERE AOPS_Cust_Id__c = '00092382'];
        Account my_site = [SELECT Id FROM Account WHERE AOPS_Seq_ID__c = '00092382-0001'];
        Test.startTest();
        Account site_acc = SearchOrCreateSiteContact.getSiteInfo(my_site.Id);
        Test.stopTest();
        System.assertEquals(my_customer.Id, site_acc.Related_Account__c);
    }

    @isTest
    public static void test_createSiteNewContact(){
        Account my_customer =
        [
            SELECT 
                Id 
            FROM Account 
            WHERE AOPS_Cust_Id__c = '00092382'
        ];
        Account my_site =
        [
            SELECT 
                Id 
            FROM Account 
            WHERE AOPS_Seq_ID__c = '00092382-0001'
        ];
        Contact my_contact = new Contact(
            FirstName='Some',
            LastName='Tester2',
            Email='SomeTest2@yop.com',
            AccountId=my_customer.Id
            );

        Test.startTest();
        SearchOrCreateSiteContact.createSiteNewContact(my_site.Id, my_contact);
        Test.stopTest();

        SiteContacts__c my_site_contact =
        [
            SELECT 
                Id, 
                Contact__c,
                Account__c 
            FROM SiteContacts__c 
            WHERE Account__c = :my_site.Id 
            AND Contact__c = :my_contact.Id 
        ];

        my_contact = [SELECT Id, RecordTypeId FROM Contact WHERE Email='SomeTest2@yop.com'];
        System.assertEquals(MyUtils.getRecordTypeInfo('Contact','Contact_US').getRecordTypeId(), my_contact.RecordTypeId);
    }

    @isTest
    public static void test_getSiteContacts(){
        Account my_customer =
        [
            SELECT 
                Id 
            FROM Account 
            WHERE AOPS_Cust_Id__c = '00092382'
        ];
        Account my_site =
        [
            SELECT 
                Id 
            FROM Account 
            WHERE AOPS_Seq_ID__c = '00092382-0001'
        ];
        Contact my_contact = new Contact(
            FirstName='Some',
            LastName='Tester2',
            Email='SomeTest2@yop.com',
            AccountId=my_customer.Id
            );

        Test.startTest();
        SearchOrCreateSiteContact.createSiteNewContact(my_site.Id, my_contact);

        try{
            SearchOrCreateSiteContact.createSiteNewContact(my_site.Id, my_contact);
        } catch (Exception e) {}

        List<Contact> my_site_contacts = SearchOrCreateSiteContact.getSiteContacts(my_customer.Id, my_site.Id);
        Test.stopTest();

        System.assertNotEquals(0, my_site_contacts.size());
    }
}
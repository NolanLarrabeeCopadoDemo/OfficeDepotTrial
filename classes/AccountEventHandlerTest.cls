//
// (c) 2015 Appirio, Inc.
//
// Test Class for the Account Events Trigger
//
// 02 September 2015     Luke Slevin       Original
//
@isTest
private class AccountEventHandlerTest {

    @isTest static void test_method_one() {
        List<Account> accList = new List<Account>();
        List<Contact> conList = new List<Contact>();

        Default_Pricing_Template__c DPT = new Default_Pricing_Template__c(name='OD Flex 15 / $6K-$24K',Template_Name__c='OD Flex 15 / $6K-$24K');
        insert DPT;

        Pricing_template__c temp = new Pricing_template__c(name = 'OD Flex 15 / $6K-$24K' ,Parent_Id__c = '123456');
        insert temp;

        for(Integer i = 0; i <10; i++){

        }

        insert conList;

        for(Integer i = 0; i <5; i++){
            Account acct = Test_Utils.GenerateAccount();
            acct.Name = 'Test Account ' + i;
            acct.Potential_DeDuplicate__c = false;
            acct.Pricing_template_cd__c = 'OD Flex 15 / $6K-$24K';
            accList.add(acct);

            Contact primaryContact = new Contact();
            primaryContact.Primary_Contact__c = true;
            primaryContact.Firstname = 'Test First Name';
            primaryContact.LastName = 'Test Last Name';
            primaryContact.Email = 'test@testing.com';
            primaryContact.Phone = '3824738273';
            primaryContact.Phone_Ext__c = '46372';
            primaryContact.AccountId = acct.Id;
            conList.add(primaryContact);
        }

        for(Integer i = 5; i <10; i++){
            Account acct = Test_Utils.GenerateAccount();
            acct.Name = 'Test Account ' + i;
            acct.Potential_DeDuplicate__c = true;
            acct.Pricing_template_cd__c = 'OD Flex 15 / $6K-$24K';
            accList.add(acct);

            Contact primaryContact = new Contact();
            primaryContact.Primary_Contact__c = true;
            primaryContact.Firstname = 'Test First Name';
            primaryContact.LastName = 'Test Last Name';
            primaryContact.Email = 'test@testing.com';
            primaryContact.Phone = '3824738273';
            primaryContact.Phone_Ext__c = '46372';
            primaryContact.AccountId = acct.Id;
            conList.add(primaryContact);
        }

        insert accList;
        insert conList;

        for(Integer i = 0; i <5; i++){
            accList[i].DNBI_CREDIT_OUTCOME__c = 'Approved';
        }

        for(Integer i = 5; i <10; i++){
            accList[i].DNBI_CREDIT_OUTCOME__c = 'Declined';
        }

        accList[0].Potential_DeDuplicate__c = true;
        accList[8].Potential_DeDuplicate__c = false;

        update accList;

        system.assertEquals(false,accList[0].Prospect_Creation_Failure__c);
        system.assertEquals(false,accList[8].Prospect_Creation_Failure__c);

    }
    //Start Added by Najma Ateeq for Story #S-386203
    public static testmethod void UnitTest1() {
        // Create Cust ODP
        recordType recType = [Select Id from RecordType where Name = 'Customer' AND sObjectType = 'Account'];
        Account acc = new Account ();
        acc.name = 'SUN Test Account';
        acc.BillingStreet = '1040 N 326 W';
        acc.billingcity = 'Orem';
        acc.BillingState = 'UT';
        acc.Billingcountry = 'USA';
        acc.Oracle_Party_Id__c = '123456';
        acc.AOPS_Cust_Id__c = '123456';
        acc.AOPS_Seq_ID__c = '123456';
      
        
        //acc.OwnerID = '005E0000000lNbV';// This is the salesforce User ID
        //acc.Sales_PersonID__c = 'a0AE0000000GGMn'; //Sales person Id for the Salesforce USer
        acc.RecordTypeId = recType.Id;

        Database.SaveResult result = Database.insert(acc);
        Id accId = result.getId();
        
        Account acct = [SELECT Id, RecordTypeId FROM Account WHERE Id = :accId];
        System.debug('------------------------> ' + acct.RecordTypeId);
        
        // Switch to Cust OMX
         Id CustOMX = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer (OfficeMax)').getRecordTypeId();
        acct.RecordTypeId = CustOMX;
        acct.Mod_5_EBS_Sync_Status__c  = 'SUCCESS';
        acct.OMXIsUpdated__c = true;
        acct.DNBI_MatchScore__c = 1234;
        acct.Primary_Site__c = false;
        update acct;
        
        acct = [SELECT Id, RecordTypeId FROM Account WHERE Id = :accId];
        System.debug('------------------------> ' + acct.RecordTypeId);

    }
    static testmethod void UnitTest2()
    {
    recordType recType = [Select Id from RecordType where Name = 'Site' AND sObjectType = 'Account'];
        Account acc = new Account ();
        acc.name = 'SUN Test Account';
        acc.BillingStreet = '1040 N 326 W';
        acc.billingcity = 'Orem';
        acc.BillingState = 'UT';
        acc.Billingcountry = 'USA';
        acc.Oracle_Party_Id__c = '123456';
        acc.AOPS_Cust_Id__c = '123456';
        acc.AOPS_Seq_ID__c = '123456';
        //acc.OwnerID = '005E0000000lNbV';// This is the salesforce User ID
        //acc.Sales_PersonID__c = 'a0AE0000000GGMn'; //Sales person Id for the Salesforce USer
        acc.RecordTypeId = recType.Id;

        Database.SaveResult result = Database.insert(acc);
        Id accId = result.getId();
        
        Account acct = [SELECT Id, RecordTypeId FROM Account WHERE Id = :accId];
        Address_Abbreviation__c ab = new Address_Abbreviation__c ();
        ab.Name = 'UNITED STATES OF AMERICA';
        ab.Abbreviation__c = 'USA';
        insert ab;
        
        // Switch to Cust OMX
         Id SiteOMX = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site (OfficeMax)').getRecordTypeId();
        acct.RecordTypeId = SiteOMX;
        acct.omx_primary_key__C = '1232-12312';
        acct.Split_Record__c  = false;
        acct.address1__C = 'UNITED STATES OF AMERICA-te';
        update acct;
        
        acct = [SELECT Id, RecordTypeId FROM Account WHERE Id = :accId];
      

    }
    static testMethod void UnitTest3(){
     test.startTest();

        ID usrID = UserInfo.getUserId();
        
        Sales_Person__c s1= new Sales_Person__c();
        s1.IsActive__c=true;
        s1.Role_Relate_Id__c ='222222';
        s1.Primary__c =true;
        s1.user__c = usrID;
        insert s1;
        
         Set<Id> accountList = new Set<ID>();
         Account topAccount = new Account (name = 'GP SUN Test - Top Account',
                                 AOPS_Seq_ID__c = '123666',
                                 AOPS_Cust_Id__c = '123666',
                                 Oracle_Party_Id__c = '123666',
                                 recordtypeid=System.Label.Customer_OfficeMax,
                                 Billingcountry = 'USA',
                                 BillingState = 'UT',
                                 Ownerid=usrID,
                                 Duns_Enrichment__c = '12345', 
                                 DNBI_CREDIT_OUTCOME__c = 'Approved',
                                 BillingStreet = '1040 N 326 W',
                                 billingcity = 'Orem',
                                 address2__c='Address2');
         insert topAccount;
         Customer_Transition__c c = new Customer_Transition__c();
         c.Account__c = topAccount.Id;
         insert c;
        accountList.add(topAccount.id);

         Account middleAccount = new Account (name = 'P SUN Test Middle Account',
                                 AOPS_Seq_ID__c = '123466',
                                 AOPS_Cust_Id__c = '123466',
                                 Oracle_Party_Id__c = '123466',
                                 Billingcountry = 'USA',
                                 BillingState = 'UT',
                                 parentid=topAccount.id,
                                 Ownerid=usrID,
                                 Duns_Enrichment__c = '12345', 
                                 DNBI_CREDIT_OUTCOME__c = 'Approved',
                                 BillingStreet = '1040 N 325 W',
                                 billingcity = 'Orem');
         insert middleAccount;
        accountList.add(middleAccount.id);
        
        Account lowAccount = new Account (name = 'GP SUN Test - Low Account',
                                 AOPS_Seq_ID__c = '123566',
                                 AOPS_Cust_Id__c = '125666',
                                 Oracle_Party_Id__c = '123566',
                                 recordtypeid=System.Label.Site_OfficeMax,
                                 Billingcountry = 'USA',
                                 BillingState = 'UT',
                                 Ownerid=usrID,
                                 Duns_Enrichment__c = '12345', 
                                 DNBI_CREDIT_OUTCOME__c = 'Approved',
                                 BillingStreet = '1040 N 327 W',
                                 billingcity = 'Orem');
         insert lowAccount;
        accountList.add(lowAccount.id);
        
        topAccount.status__c ='Inactive';
        update topAccount;
        topAccount.status__c ='Active';
        topAccount.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        update topAccount;

        test.stopTest();
        
    }
    static testMethod void UnitTest4()
        {
        test.startTest();
        List<recordtype> accSetupGTRecId= [select id from recordtype where name ='Account Setup Requested GT'];
        List<recordtype> custGTRecId= [select id from recordtype where name ='Customer (GT)'];
        Account acc1 = new Account();
        acc1.RecordtypeId = accSetupGTRecId[0].id;
        acc1.AOPS_Seq_ID__c = '658387';
        acc1.OMX_Primary_Key__c='123654';
        acc1.Name='Test Account';
        insert acc1;
        
        Contact c1 = new Contact();
        c1.LastName='LastNametest1';
        c1.email='testemail1@test.com';
        c1.AccountId = acc1.id;
        c1.firstname='first';
        c1.OMX_primary_key__c='1234';
        c1.title = 'Manager';
        c1.Primary_Contact__c = true;
        
        insert c1;
        
        Contact c2 = new Contact();
        c2.LastName='LastNametest2';
        c2.email='testemail2@test.com';
        c2.AccountId = acc1.id;
        c2.firstname='Second';
        c2.OMX_primary_key__c='1235';
        c2.title = 'Rep';
        c2.Primary_Contact__c = false;
        
        insert c2;
        
        acc1.RecordtypeId = custGTRecId[0].id;
        update acc1;

        
        test.stopTest();
        }
        static testMethod void UnitTest5() 
        {
        
        Account oldRelatedAcc = new Account ();
        oldRelatedAcc.recordtypeId=Label.Customer_GT_Record_Type;
        //oldRelatedAcc.Related_Account__c=acc;
        oldRelatedAcc.name = 'SUN Test Account1';
        oldRelatedAcc.BillingStreet = '1039 N 326 W';
        oldRelatedAcc.billingcity = 'Orem';
        oldRelatedAcc.BillingState = 'UT';
        oldRelatedAcc.Billingcountry = 'USA';
        oldRelatedAcc.Oracle_Party_Id__c = '123457';
        oldRelatedAcc.AOPS_Cust_Id__c = '123457';
        oldRelatedAcc.AOPS_Seq_ID__c = '123457';
        //oldRelatedAcc.OwnerID = '005E0000000lNbV';// This is the salesforce User ID
        //oldRelatedAcc.Sales_PersonID__c = 'a0AE0000000GGMn'; //Sales person Id for the Salesforce USer
        insert oldRelatedAcc;
        
        Account relatedAcc = new Account ();
        relatedAcc.recordtypeId=Label.Customer_GT_Record_Type;
        //relatedAcc.Related_Account__c=acc;
        relatedAcc.name = 'SUN Test Account2';
        relatedAcc.BillingStreet = '1038 N 326 W';
        relatedAcc.billingcity = 'Orem';
        relatedAcc.BillingState = 'UT';
        relatedAcc.Billingcountry = 'USA';
        relatedAcc.Oracle_Party_Id__c = '123458';
        relatedAcc.AOPS_Cust_Id__c = '123458';
        relatedAcc.AOPS_Seq_ID__c = '123458';
        //relatedAcc.OwnerID = '005E0000000lNbV';// This is the salesforce User ID
        //relatedAcc.Sales_PersonID__c = 'a0AE0000000GGMn'; //Sales person Id for the Salesforce USer
        relatedAcc.Split_Record__C = true;
        insert relatedAcc;
        
        Account acc = new Account ();
        acc.recordtypeId=Label.Site_GT_Record_Type;
        acc.Related_Account__c=oldRelatedAcc.id;
        acc.name = 'SUN Test Account3';
        acc.BillingStreet = '1037 N 326 W';
        acc.billingcity = 'Orem';
        acc.BillingState = 'UT';
        acc.Billingcountry = 'USA';
        acc.Oracle_Party_Id__c = '123459';
        acc.AOPS_Cust_Id__c = '123459';
        acc.AOPS_Seq_ID__c = '123459';
        //acc.OwnerID = '005E0000000lNbV';// This is the salesforce User ID
        //acc.Sales_PersonID__c = 'a0AE0000000GGMn'; //Sales person Id for the Salesforce USer
        insert acc;
        
        List<Contact> List_Con = new List<Contact>();

        Contact Site_Primary_Contact = new Contact();
        Site_Primary_Contact.LastName='LastNametest1';
        Site_Primary_Contact.email='testemail1@test.com';
        Site_Primary_Contact.AccountId = oldRelatedAcc.id;
        Site_Primary_Contact.OMX_Primary_Key__c='123456';
        List_Con.add(Site_Primary_Contact);
        
        Contact Site_Contact2 = new Contact();
        Site_Contact2.LastName='LastNametest2';
        Site_Contact2.email='testemail2@test.com';
        Site_Contact2.AccountId = oldRelatedAcc.id;
        Site_Contact2.OMX_Primary_Key__c='123457';
        List_Con.add(Site_Contact2);
        
        Contact Site_Contact3 = new Contact();
        Site_Contact3.LastName='LastNametest3';
        Site_Contact3.email='testemail3@test.com';
        Site_Contact3.AccountId = oldRelatedAcc.id;
        Site_Contact3.OMX_Primary_Key__c='123458';
        List_Con.add(Site_Contact3);
        
        Contact Site_Contact4 = new Contact();
        Site_Contact4.LastName='LastNametest4';
        Site_Contact4.email='testemail4@test.com';
        Site_Contact4.AccountId = oldRelatedAcc.id;
        Site_Contact4.OMX_Primary_Key__c='123459';
        List_Con.add(Site_Contact4);
        
        insert List_Con;
        
        acc.Related_Account__c=relatedAcc.id;
        acc.Legacy_CreatedDate__c = Date.today();
        
        update acc;
        
        
        
        
    }
    static testMethod void  UnitTest6(){
        Account oldRelatedAcc = new Account ();
        oldRelatedAcc.recordtypeId=Label.Customer_GT_Record_Type;
        //oldRelatedAcc.Related_Account__c=acc;
        oldRelatedAcc.name = 'SUN Test Account1';
        oldRelatedAcc.BillingStreet = '1039 N 326 W';
        oldRelatedAcc.billingcity = 'Orem';
        oldRelatedAcc.BillingState = 'UT';
        oldRelatedAcc.Billingcountry = 'USA';
        oldRelatedAcc.Oracle_Party_Id__c = '123457';
        oldRelatedAcc.AOPS_Cust_Id__c = '123457';
        oldRelatedAcc.AOPS_Seq_ID__c = '123457';
        //oldRelatedAcc.OwnerID = '005E0000000lNbV';// This is the salesforce User ID
        //oldRelatedAcc.Sales_PersonID__c = 'a0AE0000000GGMn'; //Sales person Id for the Salesforce USer
        insert oldRelatedAcc;
        
         Account acc = new Account ();
        acc.recordtypeId=Label.Site_GT_Record_Type;
        acc.Related_Account__c=oldRelatedAcc.id;
        acc.name = 'SUN Test Account3';
        acc.BillingStreet = '1037 N 326 W';
        acc.billingcity = 'Orem';
        acc.BillingState = 'UT';
        acc.Billingcountry = 'USA';
        acc.Oracle_Party_Id__c = '123459';
        acc.AOPS_Cust_Id__c = '123459';
        acc.AOPS_Seq_ID__c = '123459';
        //acc.OwnerID = '005E0000000lNbV';// This is the salesforce User ID
        //acc.Sales_PersonID__c = 'a0AE0000000GGMn'; //Sales person Id for the Salesforce USer
        insert acc;
        
        acc.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer (GT)').getRecordTypeId();
        update acc;
    }
    //End - Added by Najma Ateeq for Story #S-386203
    //Added by Lalit for S-399112 START
    static testMethod void  UnitTest7(){
    	Default_Pricing_Template__c DPT = new Default_Pricing_Template__c(name='OD Flex 15 / $6K-$24K',Template_Name__c='OD Flex 15 / $6K-$24K');
        insert DPT;

        Pricing_template__c temp = new Pricing_template__c(name = 'OD Flex 15 / $6K-$24K' ,Parent_Id__c = '123456');
        insert temp;
        Account oldRelatedAcc = new Account ();
        oldRelatedAcc.recordtypeId=Label.Customer_GT_Record_Type;
        //oldRelatedAcc.Related_Account__c=acc;
        oldRelatedAcc.name = 'SUN Test Account1';
        oldRelatedAcc.BillingStreet = '1039 N 326 W';
        oldRelatedAcc.billingcity = 'Orem';
        oldRelatedAcc.BillingState = 'UT';
        oldRelatedAcc.Billingcountry = 'USA';
        oldRelatedAcc.Oracle_Party_Id__c = '123457';
        oldRelatedAcc.AOPS_Cust_Id__c = '123457';
        oldRelatedAcc.AOPS_Seq_ID__c = '123457';
        insert oldRelatedAcc;
        
         Account acc = new Account ();
        acc.recordtypeId=Label.Site_GT_Record_Type;
        acc.Related_Account__c=oldRelatedAcc.id;
        acc.name = 'SUN Test Account3';
        acc.BillingStreet = '1037 N 326 W';
        acc.billingcity = 'Orem';
        acc.BillingState = 'UT';
        acc.Billingcountry = 'USA';
        acc.Oracle_Party_Id__c = '123459';
        acc.AOPS_Cust_Id__c = '123459';
        acc.AOPS_Seq_ID__c = '123459';
        
        insert acc;
        
        acc.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer (GT)').getRecordTypeId();
        acc.DNBI_CREDIT_OUTCOME__c = 'Approved';
        acc.Potential_Duplicate__c = false;
        acc.Primary_Site__c = false;
        acc.AccountSource = 'BSD Auto Account Setup';
        acc.Pricing_template_cd__c = 'OD Flex 15 / $6K-$24K';
        update acc;
        List<Account_Setup_Request__c> ASRList = [select id from Account_Setup_Request__c where Account__c = :acc.id];
        //System.assert(ASRList.size() == 1);
    }
    //Added by Lalit for S-399112 END

}
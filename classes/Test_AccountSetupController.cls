@isTest
public class Test_AccountSetupController {

    static String genericError = 'Sorry, we experienced an error while processing your account setup request. For support, please open a ticket with the account information by emailing salesforce@officedepot.com.';


    @TestSetup
    static void makeData(){

        Pricing_Template__c myPricingTemplate = new Pricing_Template__c( Template__c = 'MyTestPricingTemplate', Name='MyTestTemplate');
        Insert myPricingTemplate;

        List<User> system_admins_and_test =
        [SELECT Id FROM USER Where Profile.Name IN ('System Administrator', 'System Administrator 2', 'Testing Field Sales', 'System Administrator API')
         AND IsActive = true LIMIT 2];

        List<Sales_Person__c> my_sales_persons = new List<Sales_Person__c>();
        Integer index = 0;

        for(User my_user: system_admins_and_test) {
            my_sales_persons.add(new Sales_Person__c(
                                     IsActive__c = true,
                                     Primary__c = true,
                                     Name = 'TSP100' + String.valueOf(index),
                                     User__c = my_user.Id
                                     ));

            index += 1;
        }
        my_sales_persons.add(new Sales_Person__c(
                            IsActive__c = true,
                            Primary__c = true,
                            Name = 'Awaiting SalesID',
                            User__c = system_admins_and_test[0].Id
                            ));
        insert my_sales_persons;

        //Sandesh Ganjare NAIT-148117 - Start
        Account_Setup_Settings__c Settings = new Account_Setup_Settings__c();
        Settings.Name = 'Bypass Implementation Questions';
        Settings.Values__c = 'Pricing,Support,System Administrator,System Administrator GT,System Administrator 2';
        INSERT Settings;

       //Sandesh Ganjare NAIT-148117 - End
    }


    @isTest
    private static void coverage_getDataValidate() {

        User someUser = [Select Id, isActive FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true LIMIT 1];
        Account prospectAccount = Test_Utils.CreateAccount('Prospect');

        prospectAccount.OwnerId = someUser.Id;
        prospectAccount.Oracle_Party_ID__c ='73623749';
        prospectAccount.Industry_OD_SIC_Rep__c ='En';
        prospectAccount.Sector__c ='Private';
        prospectAccount.Segment__c ='>10K';
        prospectAccount.Est_Spend__c = 10000.0;
        prospectAccount.Pricing_template_cd__c = 'MyTestPricingTemplate';
        Insert prospectAccount;
        Account siteAccount = Test_Utils.CreateAccount('Site');
        siteAccount.primary_site__c = true;
        siteAccount.Related_Account__c = prospectAccount.id;
        Insert siteAccount;


        Id OppFieldSalesRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Field Sales (US)').getRecordTypeId();
        Opportunity myOpportunity = new Opportunity(Name = 'TEST', CloseDate = System.today(),StageName = 'Verbal Win',Amount = 200, AccountId = prospectAccount.id, RecordTypeId=OppFieldSalesRecordTypeId);
        Insert myOpportunity;
        Contact contact = Test_Utils.CreateContact(prospectAccount.id);
        contact.primary_contact__c = true;
        Update contact;

        Sales_Person__c sales_person = new Sales_Person__c();
        sales_person.User__c = someUser.Id;
        sales_person.Primary__c = true;
        sales_person.ExtIDSalesPerson__c = '32134123';
        Insert sales_person;
		//Id QuoterecId = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('Furniture').getRecordTypeId();
        //Quote Quoterec = new Quote(Name = 'TEST',OpportunityId=myOpportunity.id,status = 'Accepted by Customer',recordtypeId = QuoterecId);
        //Insert Quoterec;

        Account_Setup_Request__c  AccRec = new Account_Setup_Request__c (Account__c=prospectAccount.id);
        Insert AccRec;
        String rec1='{"Id":"'+AccRec.id+'","IsAccountSetUpSubmitted__c":false,"Account__c":"'+prospectAccount.id+'","BillTo_Name__c":"NO CHECK","Primary_Contact_Email__c":"dee@test.com","Primary_Contact_First_Name__c":"Deepak","Primary_Contact_Last_Name__c":"bharadwaj","Primary_Contact_Phone__c":"(222) 222-2222","Account_Phone__c":"(123) 123-1234","Street_Address_Bill__c":"BOCA RATON","Street_Address_2_Bill__c":"Hyd","State_Bill__c":"FL","Zip_Bill__c":"33496","City_Bill__c":"BOCA RATON","BILL_COUNTRY__c":"USA","ShipTo_Name__c":"NO CHECK","Street_Address_Ship__c":"BOCA RATON","Street_Address_2_Ship__c":"Hyd","State_Ship__c":"FL","Zip_Ship__c":"33496","City_Ship__c":"BOCA RATON","SHIP_COUNTRY__c":"USA","Does_your_Customer_have_any_ordering_pr__c":"No","Special_Delivery_Requirements__c":"No","EDI_or_Punch_Out__c":"No","Billing_Delivery_Method_Media_type__c":"Paper","AP_Contact_First_Name__c":"Thiru","AP_Contact_Last_Name__c":"Thiru","AP_Contact_Email__c":"rohi@fmail.com","AP_Contact_Phone__c":"(123) 456-1234","PD_Incl_Backup_Inc__c":"No","Billing_Frequency__c":"Weekly","Tax_Exempt__c":"Yes","Tax_Exempt_States__c":"ID,LA,NJ,OK","Why_are_you_tax_exempt__c":"0","IsAccountSetUp__c":true,"PD_Doc_Name__c":"Standard Invoice","DML__c":"EXPEDITORS","Show_Net_30_Question__c":false,"Show_Net_20__c":true,"IsAccountSetUp__c":false}';
        String rec2='{"Account__c":"' + prospectAccount.id + '","BillTo_Name__c":"NO CHECK","Primary_Contact_Email__c":"dee@test.com","Primary_Contact_First_Name__c":"Deepak","Primary_Contact_Last_Name__c":"bharadwaj","Primary_Contact_Phone__c":"(222) 222-2222","Account_Phone__c":"(123) 123-1234","Street_Address_Bill__c":"BOCA RATON","Street_Address_2_Bill__c":"Hyd","State_Bill__c":"FL","Zip_Bill__c":"33496","City_Bill__c":"BOCA RATON","BILL_COUNTRY__c":"USA","ShipTo_Name__c":"NO CHECK","Street_Address_Ship__c":"BOCA RATON","Street_Address_2_Ship__c":"Hyd","State_Ship__c":"FL","Zip_Ship__c":"33496","City_Ship__c":"BOCA RATON","SHIP_COUNTRY__c":"USA","Does_your_Customer_have_any_ordering_pr__c":"No","Special_Delivery_Requirements__c":"No","EDI_or_Punch_Out__c":"No","Billing_Delivery_Method_Media_type__c":"Paper","AP_Contact_First_Name__c":"Thiru","AP_Contact_Last_Name__c":"Thiru","AP_Contact_Email__c":"rohi@fmail.com","AP_Contact_Phone__c":"(123) 456-1234","PD_Incl_Backup_Inc__c":"No","Billing_Frequency__c":"Weekly","Tax_Exempt__c":"Yes","Tax_Exempt_States__c":"ID,LA,NJ,OK","Why_are_you_tax_exempt__c":"0","IsAccountSetUp__c":true,"PD_Doc_Name__c":"Standard Invoice","DML__c":"EXPEDITORS","Show_Net_30_Question__c":false,"Show_Net_20__c":true,"IsAccountSetUp__c": false}';

        AccountSetUpController.getDataValidate(myOpportunity.Id);// Sandesh ganjare
        try{
            AccountSetUpController.getAccountData(myOpportunity.id);
        } catch (AuraHandledException e){
            System.debug(LoggingLevel.INFO, 'Need Pricing Templates');
        }

        AccountSetUpController.getAccountData(myOpportunity.id);
        

        AccountSetUpController.commitAccountSetupRequest(rec2);
        AccountSetUpController.CreateSCOETicket('Testnewrequest', myOpportunity.Id, 'VGVzdCBkYXRh', 'TestfileName');
        
        Test.startTest();
        Test.stopTest();
    }

    @isTest
    private static void coverage_SubmitProspect() {

        User someUser = [Select Id, isActive FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true LIMIT 1];
        Account prospectAccount = Test_Utils.CreateAccount('Prospect');
        prospectAccount.OwnerId = someUser.Id;
        prospectAccount.Oracle_Party_ID__c ='73623749';
        prospectAccount.Industry_OD_SIC_Rep__c ='En';
        prospectAccount.Sector__c ='Private';
        prospectAccount.Segment__c ='>10K';
        prospectAccount.Est_Spend__c = 10000.0;
        prospectAccount.Pricing_template_cd__c = 'OD Flex 15';
        Insert prospectAccount;
        Account siteAccount = Test_Utils.CreateAccount('Site');
        siteAccount.primary_site__c = true;
        siteAccount.Related_Account__c = prospectAccount.id;
        Insert siteAccount;


        Id OppFieldSalesRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Field Sales (US)').getRecordTypeId();
        Opportunity myOpportunity = new Opportunity(Name = 'TEST', CloseDate = System.today(),StageName = 'Open',Amount = 200, AccountId = prospectAccount.id, RecordTypeId=OppFieldSalesRecordTypeId);
        Insert myOpportunity;
        Contact contact = Test_Utils.CreateContact(prospectAccount.id);
        contact.primary_contact__c = true;
        Update contact;

        Sales_Person__c sales_person = new Sales_Person__c();
        sales_person.User__c = someUser.Id;
        sales_person.Primary__c = true;
        sales_person.ExtIDSalesPerson__c = '32134123';
        Insert sales_person;
		//Id QuoterecId = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('Furniture').getRecordTypeId();
        //Quote Quoterec = new Quote(Name = 'TEST',OpportunityId=myOpportunity.id,status = 'Accepted by Customer',recordtypeId= QuoterecId);
        //Insert Quoterec;

        Account_Setup_Request__c  AccRec = new Account_Setup_Request__c (Account__c=prospectAccount.id);
        Insert AccRec;

        DML__c myDML = new DML__c();
        myDML.DECISION_MAKER_NM__c = 'EXPEDITORS';
        myDML.Effective_Start_Date__c = System.now().date();
        Insert myDML;


        String rec1='{"Id":"'+AccRec.id+'","Tax_Exempt__c":"Yes","Tax_Exempt_States__c":"AL","Why_are_you_tax_exempt__c":"Government","Employer_TIN__c":"111111","IsAccountSetUpSubmitted__c":false,"Account__c":"'+prospectAccount.id+'","BillTo_Name__c":"NO CHECK","Primary_Contact_Email__c":"dee@test.com","Primary_Contact_First_Name__c":"Deepak","Primary_Contact_Last_Name__c":"bharadwaj","Primary_Contact_Phone__c":"(222) 222-2222","Account_Phone__c":"(123) 123-1234","Street_Address_Bill__c":"BOCA RATON","Street_Address_2_Bill__c":"Hyd","State_Bill__c":"FL","Zip_Bill__c":"33496","City_Bill__c":"BOCA RATON","BILL_COUNTRY__c":"USA","ShipTo_Name__c":"NO CHECK","Street_Address_Ship__c":"BOCA RATON","Street_Address_2_Ship__c":"Hyd","State_Ship__c":"FL","Zip_Ship__c":"33496","City_Ship__c":"BOCA RATON","SHIP_COUNTRY__c":"USA","Does_your_Customer_have_any_ordering_pr__c":"No","Special_Delivery_Requirements__c":"No","EDI_or_Punch_Out__c":"No","Billing_Delivery_Method_Media_type__c":"Paper","AP_Contact_First_Name__c":"Thiru","AP_Contact_Last_Name__c":"Thiru","AP_Contact_Email__c":"rohi@fmail.com","AP_Contact_Phone__c":"(123) 456-1234","PD_Incl_Backup_Inc__c":"No","Billing_Frequency__c":"Weekly","Tax_Exempt__c":"Yes","Tax_Exempt_States__c":"ID,LA,NJ,OK","Why_are_you_tax_exempt__c":"0","IsAccountSetUp__c":true,"PD_Doc_Name__c":"Standard Invoice","DML__c":"'+myDML.Id +'","Show_Net_30_Question__c":false,"Show_Net_20__c":true}';
        String rec2='{"Account__c":"' + prospectAccount.id + '","BillTo_Name__c":"NO CHECK","Primary_Contact_Email__c":"dee@test.com","Primary_Contact_First_Name__c":"Deepak","Primary_Contact_Last_Name__c":"bharadwaj","Primary_Contact_Phone__c":"(222) 222-2222","Account_Phone__c":"(123) 123-1234","Street_Address_Bill__c":"BOCA RATON","Street_Address_2_Bill__c":"Hyd","State_Bill__c":"FL","Zip_Bill__c":"33496","City_Bill__c":"BOCA RATON","BILL_COUNTRY__c":"USA","ShipTo_Name__c":"NO CHECK","Street_Address_Ship__c":"BOCA RATON","Street_Address_2_Ship__c":"Hyd","State_Ship__c":"FL","Zip_Ship__c":"33496","City_Ship__c":"BOCA RATON","SHIP_COUNTRY__c":"USA","Does_your_Customer_have_any_ordering_pr__c":"No","Special_Delivery_Requirements__c":"No","EDI_or_Punch_Out__c":"No","Billing_Delivery_Method_Media_type__c":"Paper","AP_Contact_First_Name__c":"Thiru","AP_Contact_Last_Name__c":"Thiru","AP_Contact_Email__c":"rohi@fmail.com","AP_Contact_Phone__c":"(123) 456-1234","PD_Incl_Backup_Inc__c":"No","Billing_Frequency__c":"Weekly","Tax_Exempt__c":"Yes","Tax_Exempt_States__c":"ID,LA,NJ,OK","Why_are_you_tax_exempt__c":"0","IsAccountSetUp__c":true,"PD_Doc_Name__c":"Standard Invoice","DML__c":"'+myDML.Id +'","Show_Net_30_Question__c":false,"Show_Net_20__c":true,"IsAccountSetUp__c": false}';
        
        Test.startTest();
        AccountSetUpController.SubmitProspect(rec1,'TestFileName','VGVzdCBkYXRh','text/plain');
        Test.stopTest();
    }

    @isTest
    private static void test_getAccountData_Exceptions(){
        Id OppFieldSalesRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Field Sales (US)').getRecordTypeId();
        Test.startTest();
        try{
            AccountSetUpController.getAccountData(null);
        } catch (AuraHandledException e){}

        try{
            AccountSetUpController.getAccountData('');
        } catch (AuraHandledException e){}

        Account prospectAccount = Test_Utils.CreateAccount('Prospect');
        prospectAccount.Pricing_template_cd__c = 'MyTestPricingTemplate';
        Insert prospectAccount;
        Account siteAccount = Test_Utils.CreateAccount('Site');
        siteAccount.primary_site__c = true;
        siteAccount.Related_Account__c = prospectAccount.id;
        

        Opportunity myOpportunity = new Opportunity(Name = 'TEST', CloseDate = System.today(), StageName = 'Open', Amount = 200, AccountId = prospectAccount.Id, RecordTypeId=OppFieldSalesRecordTypeId);
        Insert myOpportunity;

        Account_Setup_Request__c firstASR = new Account_Setup_Request__c(Account__c=prospectAccount.Id, City_Ship__c='WeeWoo', CreatedDate=System.now()-1, LastModifiedDate=System.now()-1);
        Insert firstASR;

        Contact myContact = Test_Utils.CreateContact(prospectAccount.id);
        myContact.primary_contact__c = true;
        Update myContact;
        Account_Setup_Request__c myASR;
        try {
            myASR = AccountSetUpController.getAccountData(myOpportunity.Id);
        } catch(AuraHandledException e){
            System.debug('We get an exception due to primary site missing.');
        }
        
        Insert siteAccount;

        myASR = AccountSetUpController.getAccountData(myOpportunity.Id);
        
        System.assertEquals(firstASR.Id, myASR.Id);
        Account_Setup_Request__c secondASR = new Account_Setup_Request__c(Account__c=prospectAccount.Id, City_Ship__c='bebop', CreatedDate=System.now(), LastModifiedDate=System.now());
        Insert secondASR;
        System.debug('Foo ' + secondASR.CreatedDate);
        myASR = AccountSetUpController.getAccountData(myOpportunity.Id);
        System.assertEquals(secondASR.Id, myASR.Id);

        //Now delete them and see is it all still runs
        List<Account_Setup_Request__c> toDelete = new List<Account_Setup_Request__c>{firstASR, secondASR};
        Delete toDelete;

        try {
            myASR = AccountSetUpController.getAccountData(myOpportunity.Id);
        } catch(AuraHandledException e){
            System.debug('Will Fail for Oracle Party Id');
        }

        prospectAccount.Oracle_Party_ID__c = '6282610';

        try {
            myASR = AccountSetUpController.getAccountData(myOpportunity.Id);
        } catch(AuraHandledException e){
            System.debug('Will Failed again?');
        }
        Test.stopTest();
    }

    @isTest
    private static void test_CreateDMLOption() {
        Id OppFieldSalesRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Field Sales (US)').getRecordTypeId();
        DML__C dml = new DML__C(DECISION_MAKER_NM__c='tst',Effective_Start_Date__c=system.today());
        Insert dml;
        //Sandesh Ganjare       
        
        Org__C org = new Org__C(Business_Name__c = 'TEST',
        GLOBAL_ULTIMATE_DUNS_NUM__c='1234567',   
        DUNS_Number__c = '123123456',
        Address_1__c = 'Melino Park',
        City__c = 'Bocca',
        State__c  ='FL',
        Zip__c = '12345');
        Insert org;
        List<String> AllStates = new List<String> {'AL', 'AK', 'AZ', 'AR', 'CA', 'CO', 'CT', 'DC', 'DE', 'FL'};
            String selectedStates ='{"ID,LA,NJ,OK"}';
        DML_Relation__c dmlr = new DML_Relation__c(DML__c =dml.id, org__C=org.id,CUSTOMERID__c='123456',Effective_Start_Date__c=system.today());
        Insert dmlr;
        Account prospectAccount = Test_Utils.CreateAccount('Prospect');
        Insert prospectAccount;
        prospectAccount.Org__c=org.id;
        update prospectAccount;
        Account siteAccount = Test_Utils.CreateAccount('Site');
        siteAccount.primary_site__c = true;
        siteAccount.Related_Account__c = prospectAccount.id;
        Insert siteAccount;
        id rec=[Select Id from recordtype where name='Field Sales (US)'].id;
        Opportunity opportunity = new Opportunity
            (
                Name = 'TEST',
                CloseDate = System.today(),
                StageName = 'Open',
                Amount = 200,
                AccountId = prospectAccount.id,
                RecordTypeId=OppFieldSalesRecordTypeId
            );
        // TODO: If a new fiscal year is not set up, this test will fail. This needs to be fixed in the trigger?????? Somewhere?
        Insert opportunity;
        Contact contact = Test_Utils.CreateContact(prospectAccount.id);
        contact.primary_contact__c = true;
        update contact;
        String dmlrec ='{"sobjectType":"DML__c","DECISION_MAKER_NM__c":"Rhi","Notes__c":"hi check json","Reason_for_Creation__c":"Picklist1"}';
        AccountSetUpController.getDMLData(opportunity.id);

        Alternate_DML__c altdml = new Alternate_DML__c();
        altdml.ZIP_CODE__c='123123';
        altdml.BUSINESS_NAME__c='Test';
        altdml.STREET_ADDR__c='Street 2';
        altdml.CITY__c='Hyderabad';
        altdml.STATE__c='Telangana';
        altdml.OPERATIONAL_DUNS_NUM__c='897898789';
        altdml.GLOBAL_ULTIMATE_DUNS_NUM__c=org.GLOBAL_ULTIMATE_DUNS_NUM__c;
        Insert altdml;

        Test.startTest();
        AccountSetUpController.CreateDMLOption(opportunity.id, dmlrec);
        AccountSetUpController.getStatesMap(AllStates,selectedStates);
        AccountSetUpController.getAltDML(opportunity.id);
        AccountSetUpController.CreateAltDML(altdml.Id);
        AccountSetUpController.CreateSugAltDML(altdml.Id);
        Test.stopTest();

    }


    /*******************************************************************************************************
     * @author Adam Albright, adam.albright@officedepot.com
     * @date 05-December-2018
     *
     * @description This method tests the account validation method is persorming correctly.
     * @param
     *
     */
    @isTest
    private static void testAccountValidation(){
        Id ASR_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account Setup Requested').getRecordTypeId();
        Id Customer_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Id Prospect_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();

        Test.startTest();
        List<Sales_Person__c> bad_salesperson = [SELECT Id, Name FROM Sales_Person__c WHERE Name = 'Awaiting SalesID'];
        List<Sales_Person__c> my_salesperson = [SELECT Id, Name FROM Sales_Person__c WHERE Name != 'Awaiting SalesID'];
        Account myAccount;

        try {
            AccountSetUpController.validateAccount(myAccount);
        } catch(AccountSetUpController.ASRException e){
            System.AssertEquals(e.getMessage(), 'Site Account does not have a related Account');
        }
        myAccount = new Account();
        myAccount.RecordTypeId = Customer_RecordTypeId;

        try{
            AccountSetUpController.validateAccount(myAccount);
        } catch(AccountSetUpController.ASRException e){
            System.AssertEquals(e.getMessage(), 'Account setup cannot continue as Opportunity is already tied to a customer');
        }
        
        myAccount.RecordTypeId = ASR_RecordTypeId;
        try {
            AccountSetUpController.validateAccount(myAccount);
        } catch (AccountSetUpController.ASRException e) {
            System.AssertEquals(e.getMessage(), 'Account setup cannot continue as Opportunity is already tied to an Account that is currently being setup');
        }
        
        myAccount.RecordTypeId = Prospect_RecordTypeId;
        try {
           AccountSetUpController.validateAccount(myAccount);
        } catch (AccountSetUpController.ASRException e) {
            System.AssertEquals(e.getMessage(), 'This prospect is not yet ready for Customer Setup. If you just created this Prospect please wait a few minutes for replication before requesting Customer Setup.\nIf its been over 30min since creation and you are receiving this error - please put in a Support Ticket with the subject: Request customer setup is not functioning');
        }
        myAccount.Oracle_Party_ID__c = '615243';

        try {
            AccountSetUpController.validateAccount(myAccount);
        } catch (AccountSetUpController.ASRException e) {
            System.AssertEquals(e.getMessage(), 'Please complete the Industry field on the account page before submitting for customer setup');
        }
        myAccount.Industry_OD_SIC_Rep__c = '423';

        try {
            AccountSetUpController.validateAccount(myAccount);
        } catch (AccountSetUpController.ASRException e) {
           System.AssertEquals(e.getMessage(), 'Please complete the Sector field on the account page before submitting for customer setup');
        }
        myAccount.Sector__c = 'Private';

        try {
            AccountSetUpController.validateAccount(myAccount);
        } catch (AccountSetUpController.ASRException e) {
            System.AssertEquals(e.getMessage(), 'Please complete the Segment field on the account page before submitting for customer setup');
        }
        myAccount.Segment__c = 'Technology';

        try {
            AccountSetUpController.validateAccount(myAccount);
        } catch (AccountSetUpController.ASRException e) {
            System.AssertEquals(e.getMessage(), 'Please complete the Account Potential field on the account page before submitting for customer setup');
        }
        myAccount.Est_Spend__c = 3026.6;

        try {
            AccountSetUpController.validateAccount(myAccount);
        } catch (AccountSetUpController.ASRException e) {
            System.AssertEquals(e.getMessage(), 'Please complete the Pricing Template field on the account page before submitting for customer setup');
        }
        myAccount.Pricing_template_cd__c = MyUtils_Account.AccountPricingTemplates()[0];

        try {
            AccountSetUpController.validateAccount(myAccount);
        } catch (AccountSetUpController.ASRException e) {
            System.AssertEquals(e.getMessage(), 'Please ensure an active and primary Sales Person Id is associated with the account you are trying to set up.');
        }
        myAccount.Sales_PersonId__c = bad_salesperson[0].Id;

        try {
            AccountSetUpController.validateAccount(myAccount);
        } catch (AccountSetUpController.ASRException e) {
            System.AssertEquals(e.getMessage(), 'Please ensure an active and primary Sales Person Id is associated with the account you are trying to set up.');
        }
        myAccount.Sales_PersonId__c = my_salesperson[0].Id;

        AccountSetUpController.validateAccount(myAccount);

        Test.stopTest();
    }


    /*******************************************************************************************************
     * @author Adam Albright, adam.albright@officedepot.com
     * @date 05-December-2018
     *
     * @description Verifies that the contact validation method works correctly.
     *
     */
    @isTest
    private static void testContactValidation(){

        List<Contact> myContacts = new List<Contact>();
        Contact myFirstContact = new Contact(FirstName = 'Rawmp', primary_contact__c=true);
        Contact mySecondContact = new Contact(FirstName = 'Macto', primary_contact__c=true);

        Test.startTest();

        System.AssertEquals(AccountSetUpController.validateContacts(myContacts), 'You must have a primary contact selected before continuing.  If you have added a contact please remember to flag it as primary by selecting the "primary contact" checkbox');

        myContacts.add(myFirstContact);

        // Since we now have contact wilth the propper data, we should get ok.
        System.AssertEquals(AccountSetUpController.validateContacts(myContacts), 'ok');

        // Add a contact to simulate bad data.
        myContacts.add(mySecondContact);
        System.AssertEquals(AccountSetUpController.validateContacts(myContacts), 'You currently have 2 or more contacts flagged as primary - you must SELECT only one of these as the primary in order to request a customer setup');

        Test.stopTest();
    }


    /*******************************************************************************************************
     * @author Adam Albright, adam.albright@officedepot.com
     * @date 05-December-2018
     *
     * @description Verifies that the opportunity validation method works correctly.
     *
     
    @isTest
    private static void testOpportunityValidation(){

        // This field cannot be update. Ths is required to for testing.
        Opportunity myOpportunity = new Opportunity();
        CameleonCPQ__QxSetup__c my_pros_setup = new CameleonCPQ__QxSetup__c(
            Name='Amendment_Non_Written_Agreement', 
            CameleonCPQ__QuoteModelName__c='Some Name'
            // CameleonCPQ__ContextDataProviderName__c = 'Another Name' 
        );

        insert my_pros_setup; //Sandesh Ganjare
        CameleonCPQ__QxQuote__c my_pros_quote = new CameleonCPQ__QxQuote__c(Name = 'PROS_Quote');

        insert my_pros_quote;

        Test.startTest();
        try {
            AccountSetUpController.validateOpportunity(myOpportunity);
        } catch (AccountSetUpController.ASRException e) {
            System.AssertEquals(e.getMessage(), 'Opportunity is not associated with an Account');
        }
        myOpportunity.AccountId = '001440000227ktSAAQ';
        myOpportunity.Stagename = 'Open';

        try {
            AccountSetUpController.validateOpportunity(myOpportunity);
        } catch (AccountSetUpController.ASRException e) {
            System.AssertEquals(e.getMessage(), 'Verbal Win" or "Close" to request Customer setup');
        }

        myOpportunity.Stagename = 'Verbal Win';
        try {
            AccountSetUpController.validateOpportunity(myOpportunity);
        } catch (AccountSetUpController.ASRException e) {
            // System.AssertEquals(e.getMessage(), 'A Pros Quote must be associated with the opportunity before requesting Customer Setup.');
            System.AssertEquals(e.getMessage(), 'Opportunity is not tied to Quote.');
        }

        myOpportunity.Stagename = 'Close';
        try {
            AccountSetUpController.validateOpportunity(myOpportunity);
        } catch (AccountSetUpController.ASRException e) {
            //System.AssertEquals(e.getMessage(), 'A Pros Quote must be associated with the opportunity before requesting Customer Setup.');
            System.AssertEquals(e.getMessage(), 'Opportunity is not tied to Quote.');
        }


        // Shound not Throw Exception
        AccountSetUpController.validateOpportunity(myOpportunity);

        Test.stopTest();
    }
    */

    /*******************************************************************************************************
     * @author Adam Albright, adam.albright@officedepot.com
     * @date 12-December-2018
     *
     * @description Verifies that addPrimarySiteInformation checks the data appropiatly before generating a AccountSetupRequest
     *
     */
     @isTest
     private static void test_addPrimarySiteInformation_Exceptions(){
        Account prospectAccount;
        Account_Setup_Request__c myASR;
        String expectedError = 'Sorry, we experienced an error while processing your account setup request. For support, please open a ticket with the account information by emailing salesforce@officedepot.com.';

        Test.startTest();
        // Exception on both Null
        try{
            myASR = AccountSetUpController.addPrimarySiteInformation(myASR, prospectAccount);
        } catch (AccountSetUpController.ASRException e){
            System.AssertEquals(e.getMessage(), expectedError);
        }

        // Exception on Account_Setup_Request__c null
        prospectAccount = new Account();
        try{
            myASR = AccountSetUpController.addPrimarySiteInformation(myASR, prospectAccount);
        } catch (AccountSetUpController.ASRException e){
            System.AssertEquals(e.getMessage(), expectedError);
        }

        // Exception on prospectAccount null
        myASR = new Account_Setup_Request__c();
        prospectAccount = null;
        try{
            myASR = AccountSetUpController.addPrimarySiteInformation(myASR, prospectAccount);
        } catch (AccountSetUpController.ASRException e){
            System.AssertEquals(e.getMessage(), expectedError);
        }

        // No exception if both not null
        prospectAccount = new Account();
        myASR = new Account_Setup_Request__c();
        myASR = AccountSetUpController.addPrimarySiteInformation(myASR, prospectAccount);
        Test.stopTest();
     }


    /*******************************************************************************************************
     * @author Adam Albright, adam.albright@officedepot.com
     * @date 12-December-2018
     *
     * @description Verifies that addPrimarySiteInformation corectly maps data from the prospect to the Account Setup request
     *
     */
     @isTest
     private static void test_addPrimarySiteInformation_Mapping(){
        Account prospectAccount = new Account();
        Account_Setup_Request__c myASR = new Account_Setup_Request__c();


        // Makes Sure fields are mapped correctly.
        prospectAccount.Address1__c = 'Foo1';
        prospectAccount.Address2__c = 'Foo2';
        prospectAccount.State__c = 'Foo3';
        prospectAccount.zip__c = 'Foo4';
        prospectAccount.City__c = 'Foo5';
        prospectAccount.Country__c = 'Foo6';
        // Ship to DEtails
        prospectAccount.Name = 'Foo7';
        prospectAccount.Address1__c = 'Foo8';
        prospectAccount.Address2__c = 'Foo9';
        prospectAccount.State__c = 'Foo0';
        prospectAccount.Zip__c = 'Foo11';
        prospectAccount.City__c = 'Foo12';
        prospectAccount.Country__c = 'Foo13';
        prospectAccount.Oracle_Party_Site_ID__c = 'Foo14';
        myASR = AccountSetUpController.addPrimarySiteInformation(myASR, prospectAccount);

        Test.startTest();
        System.AssertEquals(myASR.Street_Address_Bill__c, prospectAccount.Address1__c);
        System.AssertEquals(myASR.Street_Address_2_Bill__c, prospectAccount.Address2__c);
        System.AssertEquals(myASR.State_Bill__c, prospectAccount.State__c);
        System.AssertEquals(myASR.Zip_Bill__c, prospectAccount.zip__c);
        System.AssertEquals(myASR.City_Bill__c, prospectAccount.City__c);
        System.AssertEquals(myASR.BILL_COUNTRY__c, prospectAccount.Country__c);
        // Ship to DEtails
        System.AssertEquals(myASR.ShipTo_Name__c, prospectAccount.Name);
        System.AssertEquals(myASR.Street_Address_Ship__c, prospectAccount.Address1__c);
        System.AssertEquals(myASR.Street_Address_2_Ship__c, prospectAccount.Address2__c);
        System.AssertEquals(myASR.State_Ship__c, prospectAccount.State__c);
        System.AssertEquals(myASR.Zip_Ship__c, prospectAccount.Zip__c);
        System.AssertEquals(myASR.City_Ship__c, prospectAccount.City__c);
        System.AssertEquals(myASR.SHIP_COUNTRY__c, prospectAccount.Country__c);
        System.AssertEquals(myASR.SHIPTO_ORACLE_PARTY_SITE_ID__c, prospectAccount.Oracle_Party_Site_ID__c);
        Test.stopTest();
     }


    /*******************************************************************************************************
     * @author Adam Albright, adam.albright@officedepot.com
     * @date 12-December-2018
     *
     * @description Verifies that addPrimaryContactInformation throws exceptions when null data is passed.
     *
     */
     @isTest
     private static void test_addPrimaryContactInformation_Exceptions(){
        Contact myPrimaryContact; 
        Account_Setup_Request__c myASR;


        Test.startTest();
        // Exception on both Null
        try{
            myASR = AccountSetUpController.addPrimaryContactInformation(myASR, myPrimaryContact);
        } catch (AccountSetUpController.ASRException e){
            System.AssertEquals(e.getMessage(), genericError);
        }

        // Exception on Account_Setup_Request__c null
        myPrimaryContact = new Contact();
        try{
            myASR = AccountSetUpController.addPrimaryContactInformation(myASR, myPrimaryContact);
        } catch (AccountSetUpController.ASRException e){
            System.AssertEquals(e.getMessage(), genericError);
        }

        // Exception on myPrimaryContact null
        myASR = new Account_Setup_Request__c();
        myPrimaryContact = null;
        try{
            myASR = AccountSetUpController.addPrimaryContactInformation(myASR, myPrimaryContact);
        } catch (AccountSetUpController.ASRException e){
            System.AssertEquals(e.getMessage(), genericError);
        }

        // No exception if both not null
        myPrimaryContact = new Contact();
        myASR = new Account_Setup_Request__c();
        myASR = AccountSetUpController.addPrimaryContactInformation(myASR, myPrimaryContact);
        Test.stopTest();
     }


    /*******************************************************************************************************
     * @author Adam Albright, adam.albright@officedepot.com
     * @date 12-December-2018
     *
     * @description Verifies that addPrimaryContactInformation corectly maps data from the contact to the Account Setup request
     *
     */
     @isTest
     private static void test_addPrimaryContactInformation_Mapping(){
        Contact myPrimaryContact = new Contact();
        Account_Setup_Request__c myASR = new Account_Setup_Request__c();


        // Makes Sure fields are mapped correctly.
        myPrimaryContact.Email = 'sa@aaaa.com';
        myPrimaryContact.Fax = '3216536273';
        myPrimaryContact.FirstName = 'foo';
        myPrimaryContact.Title = 'foo1';
        myPrimaryContact.LastName = 'foo2';
        myPrimaryContact.MobilePhone = '4322466432';
        myPrimaryContact.Phone = '4342466432';
        myPrimaryContact.Salutation = 'Mr.';

        myASR = AccountSetUpController.addPrimaryContactInformation(myASR, myPrimaryContact);

        Test.startTest();
        System.AssertEquals(myASR.Primary_Contact_Email__c, myPrimaryContact.Email);
        System.AssertEquals(myASR.Primary_Contact_Fax__c, myPrimaryContact.Fax);
        System.AssertEquals(myASR.Primary_Contact_First_Name__c, myPrimaryContact.FirstName);
        System.AssertEquals(myASR.Primary_Contact_Job_Title__c, myPrimaryContact.Title);
        System.AssertEquals(myASR.Primary_Contact_Last_Name__c, myPrimaryContact.LastName);
        System.AssertEquals(myASR.Primary_Contact_Mobile_Phone__c, myPrimaryContact.MobilePhone);
        System.AssertEquals(myASR.Primary_Contact_Phone__c, myPrimaryContact.Phone);
        System.AssertEquals(myASR.Primary_Contact_Salutation__c, myPrimaryContact.Salutation);
        Test.stopTest();
     }


    /*******************************************************************************************************
     * @author Adam Albright, adam.albright@officedepot.com
     * @date 12-December-2018
     *
     * @description Verifies that addAccountInformation checks for nulls generating a AccountSetupRequest
     *
     */
     @isTest
     private static void test_addAccountInformation_Exceptions(){
        Account myAccountToSetup;
        Account_Setup_Request__c myASR;

        Test.startTest();
        // Exception on both Null
        try{
            myASR = AccountSetUpController.addAccountInformation(myASR, myAccountToSetup);
        } catch (AccountSetUpController.ASRException e){
            System.AssertEquals(genericError, e.getMessage());
        }

        // Exception on Account_Setup_Request__c null
        myAccountToSetup = new Account();
        try{
            myASR = AccountSetUpController.addAccountInformation(myASR, myAccountToSetup);
        } catch (AccountSetUpController.ASRException e){
            System.AssertEquals(genericError, e.getMessage());
        }

        // Exception on myAccountToSetup null
        myASR = new Account_Setup_Request__c();
        myAccountToSetup = null;
        try{
            myASR = AccountSetUpController.addAccountInformation(myASR, myAccountToSetup);
        } catch (AccountSetUpController.ASRException e){
            System.AssertEquals(genericError, e.getMessage());
        }

        // No exception if both not null
        myAccountToSetup = new Account();
        myASR = new Account_Setup_Request__c();
        myASR = AccountSetUpController.addAccountInformation(myASR, myAccountToSetup);
        Test.stopTest();
     }


    /*******************************************************************************************************
     * @author Adam Albright, adam.albright@officedepot.com
     * @date 12-December-2018
     *
     * @description Verifies that addAccountInformation corectly maps data from the prospect to the Account Setup request
     *
     */
     @isTest
     private static void test_addAccountInformation_Mapping(){
        Account myAccountToSetup = new Account();
        Account_Setup_Request__c myASR = new Account_Setup_Request__c();
        Sales_Person__c mySalesPerson = new Sales_Person__c(Name='NameFoo', IsActive__c=true, Primary__c=true);
        Insert mySalesPerson;

        myAccountToSetup.Id = '0011800000bWuXWAA0';
        myAccountToSetup.Name = 'Foo1';
        myAccountToSetup.OwnerId = '005440000097CV1';
        myAccountToSetup.Phone = '2341273527';
        myAccountToSetup.Segment__c = 'Foo2';
        myAccountToSetup.Duns_Number__c = 'Foo3';
        myAccountToSetup.Ultimate_Duns_Number__c = 'Foo4';
        myAccountToSetup.Payment_Term__c = 'Foo5';
        myAccountToSetup.Est_Spend__c = 240000.1;
        myAccountToSetup.Oracle_Party_ID__c = '32352342';
        myAccountToSetup.Sales_PersonID__c = mySalesPerson.Id;
       
        myASR = AccountSetUpController.addAccountInformation(myASR, myAccountToSetup);

        Test.startTest();
        System.AssertEquals(myASR.Account__c, myAccountToSetup.Id);
        System.AssertEquals(myASR.BillTo_Name__c, myAccountToSetup.Name);
        System.AssertEquals(myASR.Account_Owner__c, myAccountToSetup.OwnerId);
        System.AssertEquals(myASR.Account_Phone__c, myAccountToSetup.Phone);
        System.AssertEquals(myASR.Segment__c, myAccountToSetup.Segment__c);
        System.AssertEquals(myASR.Duns_Number__c, myAccountToSetup.Duns_Number__c);
        System.AssertEquals(myASR.Ultimate_Duns_Number__c, myAccountToSetup.Ultimate_Duns_Number__c);
        System.AssertEquals(myASR.Invoice_Payment_Method__c, myAccountToSetup.Payment_Term__c);
        System.AssertEquals(myASR.Est_Spend__c, myAccountToSetup.Est_Spend__c);
        System.AssertEquals(myASR.ORACLE_PARTY_ID__c, myAccountToSetup.Oracle_Party_ID__c);
        System.AssertEquals(myASR.Rep_ID__c, myAccountToSetup.Sales_PersonID__r.name);

        // Check white collar workers assigne correctly.
        myAccountToSetup.Org_WCW_Count_Rep__c = 5;
        myASR = AccountSetUpController.addAccountInformation(myASR, myAccountToSetup);
        System.AssertEquals(myASR.Number_of_WCW_employees__c, String.valueOf(myAccountToSetup.Org_WCW_Count_Rep__c));

        // Check Show net 20 and net 30 based on Est Spend and Payment Term Options
        myAccountToSetup.Est_Spend__c = 250001;
        myAccountToSetup.Payment_Term__c = 'Account Billing';
        myASR = AccountSetUpController.addAccountInformation(myASR, myAccountToSetup);
        System.AssertEquals(myASR.Show_Net_20__c, true);
        System.AssertEquals(myASR.Show_Net_30_Question__c, true);

        // Set Net20 and 30 based on credit card payment terms.
        myAccountToSetup.Payment_Term__c = 'Credit Card';
        myASR = AccountSetUpController.addAccountInformation(myASR, myAccountToSetup);
        System.AssertEquals(myASR.Show_Net_20__c, false);
        System.AssertEquals(myASR.Show_Net_30_Question__c, false);

        // Check Show net 20 and NOT net 30 based on Est Spend and Payment Term Options
        myAccountToSetup.Est_Spend__c = 2222;
        myAccountToSetup.Payment_Term__c = 'Account Billing';
        myASR = AccountSetUpController.addAccountInformation(myASR, myAccountToSetup);
        System.AssertEquals(myASR.Show_Net_20__c, true);
        System.AssertEquals(myASR.Show_Net_30_Question__c, false);
        
        Test.stopTest();
    }


    /*******************************************************************************************************
     * @author Adam Albright, adam.albright@officedepot.com
     * @date 12-December-2018
     *
     * @description Verifies that addPricingTemplateInfo checks for nulls generating a AccountSetupRequest
     *
     */
     @isTest
     private static void test_addPricingTemplateInfo_Exceptions(){
        Pricing_Template__c myPricingTemplate;
        Account_Setup_Request__c myASR;
        
        Test.startTest();
        // Exception on both Null
        try{
            myASR = AccountSetUpController.addPricingTemplateInfo(myASR, myPricingTemplate);
        } catch (AccountSetUpController.ASRException e){
            System.AssertEquals(genericError, e.getMessage());
        }

        // Exception on Account_Setup_Request__c null
        myPricingTemplate = new Pricing_Template__c();
        try{
            myASR = AccountSetUpController.addPricingTemplateInfo(myASR, myPricingTemplate);
        } catch (AccountSetUpController.ASRException e){
            System.AssertEquals(genericError, e.getMessage());
        }

        // Exception on myPricingTemplate null
        myASR = new Account_Setup_Request__c();
        myPricingTemplate = null;
        try{
            myASR = AccountSetUpController.addPricingTemplateInfo(myASR, myPricingTemplate);
        } catch (AccountSetUpController.ASRException e){
            System.AssertEquals(genericError, e.getMessage());
        }

        // No exception if both not null
        myPricingTemplate = new Pricing_Template__c();
        myASR = new Account_Setup_Request__c();
        myASR = AccountSetUpController.addPricingTemplateInfo(myASR, myPricingTemplate);
        Test.stopTest();
     }


    /*******************************************************************************************************
     * @author Adam Albright, adam.albright@officedepot.com
     * @date 12-December-2018
     *
     * @description Verifies that addPricingTemplateInfo corectly maps data from the pricing template to the Account Setup request
     *
     */
     @isTest
     private static void test_addPricingTemplateInfo_Mapping(){
        Pricing_Template__c myPricingTemplate = new Pricing_Template__c();
        Account_Setup_Request__c myASR = new Account_Setup_Request__c();

        // myASR.\w* = 
        myPricingTemplate.Off_Contract_Code__c = 'foo1';
        myPricingTemplate.Off_Contract_Percent__c = 'foo2';
        myPricingTemplate.Off_Wholesale_Code__c = 'foo3';
        myPricingTemplate.Off_Wholesale_percent__c = 'foo4';
        myPricingTemplate.GP_Floor_Percernt__c = 'foo5';
        myPricingTemplate.Price_Plan_Id__c = 'foo6';
        myPricingTemplate.Exclude_Universal_Pricing__c = 'foo7';
        myPricingTemplate.Loyalty__c = 'foo8';
        myPricingTemplate.Delivery_Code__c = 'foo9';
        myPricingTemplate.Priority_1__c = 'foo0';
        myPricingTemplate.Priority_2__c = 'foo11';
        myPricingTemplate.Priority_3__c = 'foo12';
        myPricingTemplate.Priority_4__c = 'foo13';
        myPricingTemplate.Priority_5__c = 'foo14';
        myPricingTemplate.Priority_6__c = 'foo15';
        myPricingTemplate.Priority_7__c = 'foo16';
        myPricingTemplate.Priority_8__c = 'foo17';
        myPricingTemplate.Priority_9__c = 'foo18';
        myPricingTemplate.Priority_10__c = 'foo19';
        myPricingTemplate.Revenue_Band__c = 'foo21';
        myPricingTemplate.Contract_Number_1__c = 'foo22';
        myPricingTemplate.Contract_Number_2__c = 'foo34';
        myPricingTemplate.Contract_Number_3__c = 'foo24';
        myPricingTemplate.Contract_Number_4__c = 'foo52';
        myPricingTemplate.Contract_Number_5__c = 'foo35';
        myPricingTemplate.Contract_Number_6__c = 'foo36';
        myPricingTemplate.Contract_Number_7__c = 'foo46';
        myPricingTemplate.Contract_Number_8__c = 'foo57';
        myPricingTemplate.Contract_Number_9__c = 'foo67';
        myPricingTemplate.Contract_Number_10__c = 'foo78';
        myPricingTemplate.Off_Contract_Percent__c = 'foo87';
        myPricingTemplate.Acct_Auto_Setup__c = 'foo98';
        myPricingTemplate.Cust_Prod_Xref__c = 'foo75';
        myPricingTemplate.Freight_Charge__c = 'foo64';
        myPricingTemplate.Account_Setup_Notes_c__c = 'foo47';

        Test.startTest();

        myASR = AccountSetUpController.addPricingTemplateInfo(myASR, myPricingTemplate);

        System.AssertEquals(myASR.Off_Contract__c, myPricingTemplate.Off_Contract_Code__c);
        System.AssertEquals(myASR.Off_Contract_Percent__c, myPricingTemplate.Off_Contract_Percent__c);
        System.AssertEquals(myASR.Off_Wholesale__c, myPricingTemplate.Off_Wholesale_Code__c);
        System.AssertEquals(myASR.Off_Wholesale_percent__c, myPricingTemplate.Off_Wholesale_percent__c);
        System.AssertEquals(myASR.GP_Floor__c, myPricingTemplate.GP_Floor_Percernt__c);
        System.AssertEquals(myASR.Price_Plan__c, myPricingTemplate.Price_Plan_Id__c);
        System.AssertEquals(myASR.Exclude_Account_from_Universal_Pricing__c, myPricingTemplate.Exclude_Universal_Pricing__c);
        System.AssertEquals(myASR.Loyalty_Type__c, myPricingTemplate.Loyalty__c);
        System.AssertEquals(myASR.Deliver_Charge_Code__c, myPricingTemplate.Delivery_Code__c);
        System.AssertEquals(myASR.Core_Item_Price_List_Priority_Code_1__c, myPricingTemplate.Priority_1__c);
        System.AssertEquals(myASR.Core_Item_Price_List_Priority_Code_2__c, myPricingTemplate.Priority_2__c);
        System.AssertEquals(myASR.Core_Item_Price_List_Priority_Code_3__c, myPricingTemplate.Priority_3__c);
        System.AssertEquals(myASR.Core_Item_Price_List_Priority_Code_4__c, myPricingTemplate.Priority_4__c);
        System.AssertEquals(myASR.Core_Item_Price_List_Priority_Code_5__c, myPricingTemplate.Priority_5__c);
        System.AssertEquals(myASR.Core_Item_Price_List_Priority_Code_6__c, myPricingTemplate.Priority_6__c);
        System.AssertEquals(myASR.Core_Item_Price_List_Priority_Code_7__c, myPricingTemplate.Priority_7__c);
        System.AssertEquals(myASR.Core_Item_Price_List_Priority_Code_8__c, myPricingTemplate.Priority_8__c);
        System.AssertEquals(myASR.Core_Item_Price_List_Priority_Code_9__c, myPricingTemplate.Priority_9__c);
        System.AssertEquals(myASR.Core_Item_Price_List_Priority_Code_10__c, myPricingTemplate.Priority_10__c);
        System.AssertEquals(myASR.Revenue_Band__c, myPricingTemplate.Revenue_Band__c);
        System.AssertEquals(myASR.Core_Item_Price_List_ID_1__c, myPricingTemplate.Contract_Number_1__c);
        System.AssertEquals(myASR.Core_Item_Price_List_ID_2__c, myPricingTemplate.Contract_Number_2__c);
        System.AssertEquals(myASR.Core_Item_Price_List_ID_3__c, myPricingTemplate.Contract_Number_3__c);
        System.AssertEquals(myASR.Core_Item_Price_List_ID_4__c, myPricingTemplate.Contract_Number_4__c);
        System.AssertEquals(myASR.Core_Item_Price_List_ID_5__c, myPricingTemplate.Contract_Number_5__c);
        System.AssertEquals(myASR.Core_Item_Price_List_ID_6__c, myPricingTemplate.Contract_Number_6__c);
        System.AssertEquals(myASR.Core_Item_Price_List_ID_7__c, myPricingTemplate.Contract_Number_7__c);
        System.AssertEquals(myASR.Core_Item_Price_List_ID_8__c, myPricingTemplate.Contract_Number_8__c);
        System.AssertEquals(myASR.Core_Item_Price_List_ID_9__c, myPricingTemplate.Contract_Number_9__c);
        System.AssertEquals(myASR.Core_Item_Price_List_ID_10__c, myPricingTemplate.Contract_Number_10__c);
        System.AssertEquals(myASR.Off_Contract_percent__c, myPricingTemplate.Off_Contract_Percent__c);
        System.AssertEquals(myASR.OPERATION__c, myPricingTemplate.Acct_Auto_Setup__c);
        System.AssertEquals(myASR.Cross_Reference_Number__c, myPricingTemplate.Cust_Prod_Xref__c);
        System.AssertEquals(myASR.Small_Order_Fee_Flag__c, myPricingTemplate.Freight_Charge__c);
        System.AssertEquals(myASR.Rep_Comments__c, myPricingTemplate.Account_Setup_Notes_c__c);

        Test.stopTest();
    }


    @isTest
    private static void test_opportunity_to_account_map(){
        Account my_account = new Account(Name='Test Account');
        Opportunity my_opportunity = new Opportunity(
            Name='My_opportunity', 
            Amount=422.29
        );

        Test.startTest();
        my_account = AccountSetUpController.map_opportunity_data_to_account(my_opportunity, my_account);
        System.assertEquals(my_account.Initial_Opportunity_Annual_Amount__c, my_opportunity.Amount);
        Test.stopTest();
    }
    
    /*@isTest
    private static void test_getSpclOppCheck()
    {
        Account prospectAccount = Test_Utils.CreateAccount('Customer');

        //prospectAccount.OwnerId = someUser.Id;
        prospectAccount.Oracle_Party_ID__c ='73623749';
        prospectAccount.Industry_OD_SIC_Rep__c ='En';
        prospectAccount.Sector__c ='Private';
        prospectAccount.Segment__c ='>10K';
        prospectAccount.Est_Spend__c = 10000.0;
        prospectAccount.Pricing_template_cd__c = 'MyTestPricingTemplate';
        Insert prospectAccount;
        Account siteAccount = Test_Utils.CreateAccount('Site');
        siteAccount.primary_site__c = true;
        siteAccount.Related_Account__c = prospectAccount.id;
        Insert siteAccount;
        
        Contact primaryContact = new Contact();
        //primaryContact.Salutation
        primaryContact.FirstName = 'Test12';
		primaryContact.LastName = '345';
		primaryContact.AccountId =prospectAccount.Id;
        primaryContact.Primary_Contact__c = true;
        insert primaryContact;
        
        Id OppFieldSalesRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('PPE-CBFS').getRecordTypeId();
        Opportunity myOpportunity = new Opportunity(Name = 'TEST', CloseDate = System.today(),StageName = 'Verbal Win',Amount = 200, AccountId = prospectAccount.id, RecordTypeId=OppFieldSalesRecordTypeId);
        Insert myOpportunity;
        AccountSetUpController.getSpclOppCheck(myOpportunity.Id);
    }*/
    
    //Sandesh Ganjare NAIT-148117 - Start
    @isTest
    private static void coverage_getProfileCheck() {
        Boolean results = true;
        Test.StartTest();           
            results = AccountSetUpController.getProfileCheck();         
        Test.StopTest();
        
        System.assertEquals(false, results);
    }
    //Sandesh Ganjare NAIT-148117 - End
}
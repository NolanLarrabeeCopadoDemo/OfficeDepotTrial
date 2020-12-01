/*********************************************
*Author : Ritesh (Appirio Off)
*Purpose : The class is intended to serve as data generation utility for all test methods
           The rationale is to isolote all data creation logic in one place, so that any validation
           and data generation errors can be handled in this class only
*Created on : July 27th, 2011
*History : v1.0 Created, Added data generation for Account,Product,and Opportunity,
                and Opportunity Line Item, Site
           v1.1 Added phone number and Country to bypass validation errors
***********************************************/
public without sharing class Test_Utils {

  //==========================================================//
  //Generate Account methods only generates a new Account, doesn't do any DML
  //==========================================================//
  public static Account GenerateAccount() {
   return  CreateAccount('Prospect');
  }
    //==========================================================//
  //Generate Account assignment record by Rahul
  //Story - S-389134
  //==========================================================//
  public static AccountAssignments__c createAccountAssignments(Account acc,String accType,String EntityType,String status,String Entity_Id,Boolean isInsert){
        AccountAssignments__c accAssignment = new AccountAssignments__c();
        accAssignment.AccountId__c = String.valueOf(acc.Id).subString(0,14);
        accAssignment.AccountType__c = accType;
        accAssignment.Entity_Type__c = EntityType;
        accAssignment.Status__c = status;
        accAssignment.Entity_Id__c = Entity_Id;
        if(isInsert)
            insert accAssignment;
        return accAssignment;   
  }
// END S-389134
  //==========================================================//
  //Generate Account methods only generates a new Account, doesn't do any DML
  //==========================================================//
  public static Account CreateAccount(String recordType) {

    Schema.DescribeSObjectResult descSchema = Schema.SObjectType.Account;

    Map<String,Schema.RecordTypeInfo> rtMapByName = descSchema.getRecordTypeInfosByName();
    Schema.RecordTypeInfo rtByName = rtMapByName.get(recordType);

    User usr = CreateUser();
    Sales_Person__c salesPerson = createTestSalesPerson(usr.Id,'testSalesPerson');

    Account account = new Account(Name = 'TEST');
    account.ShippingStreet = 'ABC';
    account.ShippingState = 'ABC';
    account.ShippingCity = 'ABC';
    account.Ranking__c = 100;
    account.Rep_call_date__c = date.today();
    //account.Opportunity_Amt__c = 100;
    account.Country__c = 'USA';
    account.RecordTypeId = rtByName.getRecordTypeId();
    //account.Primary_Contact_Phone__c = '(999) 999-9999';
    account.Sales_PersonID__c = salesPerson.Id;
    account.Assign_Specific_Owner__c = usr.id;
    // account.Auto_Assign__c = true;
    account.Auto_Assign__c = false;

    //insert account;

    return account;
  }


  public static GPO_Lead__c  Test_CreateGPOLead(){
     GPO_Lead__c  gpoLead = new GPO_Lead__c ();
     insert gpoLead;
     return gpoLead;
  }

  //==========================================================================//
  //Create a Note
  //==========================================================================//
  public static Note CreateNote(Contact contact) {
    Note note = new Note(Title = 'Test', ParentId = contact.Id);
    insert note;
    return note;
  }

  //==========================================================================//
  //Create a bare bones task object and return
  //==========================================================================//
  public static Task GenerateBasicTask() {
    Task task = new Task(ActivityDate = System.today(),Subject = 'Email', Status='In Progress');
    return task;
  }

  //======================================================================//
  // To create task
  //=====================================================================//
  public static Task CreateSalesDispositionTask(Id accountId) {
    RecordType recType = [select id from recordtype where name = 'Inside Sales' AND SobjectType = 'Task'];
    Task task = GenerateBasicTask();
    task.WhatId = accountId;
    task.RecordTypeId = recType.Id;
    task.Status = 'Completed';
    task.Call_Disposition__c = 'Sales Related';
    task.Disposition_Code__c = 'Sales Related';
    task.Task_Type__c = 'Email';

    insert task;

    return task;
  }


  //===========================================================//
  //Create Account with defaults
  //===========================================================//
  public static Account CreateAccount() {
    Account account = GenerateAccount();
    insert account;

    return account;
  }


  //===========================================================//
  //Create Account for sales history
  //===========================================================//
  public static Account CreateAccountForSalesHistory() {
    Account account = CreateAccount('Site');
    account.MTD_Sales_TY__c = 2;
    account.MTD_Sales_LY__c = 2.0;
    account.Monthly_LY__c = 8;
    account.Month_Goal__c = 10;
    account.Month_Goal__c = 5;
    account.ADS_Current_Month__c = 6;
    account.ADS_Last_Month__c = 2;
    account.QTD_Sales_TY__c = 16;
    account.QTD_Sales_LY__c = 60;
    account.Quarter_LY__c = 8;
    account.Quarter_Goal__c = 8;
    account.ADS_Current_Qtr__c = 50;
    account.ADS_Last_Qtr__c = 10;
    account.YTD_Sales_TY__c = 15;
    account.YTD_Sales_LY__c = 15;
    account.Year_LY__c = 10;
    account.Year_Goal__c = 10;
    account.ADS_Current_Yr__c = 20;
    account.ADS_Last_Yr__c = 50;
    account.MTD_Sales_TY_IMU__c = 1;

    account.QTD_Sales_TY_IMU__c = 500;
    account.QTD_Sales_TY__c = 100;
    account.Monthly_LY_IMU__c = 500;
    account.Monthly_LY__c = 100;
    account.MTD_Sales_LY_IMU__c = 500;
    account.MTD_Sales_LY__c = 100;

    
    insert account;
    return account;
  }

  //===========================================================//
  //Create Account for ProductDataExtension
  //===========================================================//
  public static Account CreateAccountForProductData() {
    Account account = CreateAccount('Site');
      account.Tech_LY__c = 10;  // Assign last year currency for 'Tech'
      account.Tech_TY__c = 300;   // Assign this year currency for 'Tech'
        account.Paper_TY__c = 5;
        account.Paper_LY__c =  10;
        account.Paper_Pot__c = 10;
        account.Paper_Last_Order__c = System.today();
        account.Paper_Last_Order_amt__c = 10;
        account.Ink_Toner_TY__c = 20;
        account.Ink_Toner_LY__c = 20;
        account.Ink_Toner_Pot__c = 20;
        account.Ink_Toner_Last_Order__c = System.today();
        account.Ink_Toner_Last_Order_amt__c = 20;
        account.Furniture_TY__c = 20;
        account.Furniture_LY__c = 20;
        account.Furniture_Pot__c = 20;
        account.Furniture_Last_Order__c = System.today();
        account.Furniture_last_order_amt__c = 20;
        account.CBS_TY__c = 20;
        account.CBS_LY__c = 20;
        account.CBS_Pot__c = 20;
        account.CBS_Last_Order__c = System.today();
        account.CBS_Last_order_amt__c = 20;
        account.CPD_TY__c = 20;
        account.CPD_LY__c = 20;
        account.CPD_Pot__c = 20;
        account.CPD_Last_Order__c = System.today();
        account.CPD_Last_order_amt__c = 20;
        account.Tech_Pot__c = 20;
        account.Tech_Last_Order__c = System.today();
        account.Tech_Last_Order_amt__c = 20;
        account.Filing_Binding_TY__c = 20;
        account.Filing_Binding_LY__c = 20;
        account.Filing_Binding_Pot__c = 20;
        account.Filing_Binding_Last_Order__c = System.today();
        account.Filing_Binding_Last_Order_amt__c = 20;
        account.Labels_Forms_TY__c = 20;
        account.Labels_Forms_LY__c = 20;
        account.Labels_Forms_Pot__c = 20;
        account.Labels_Forms_Last_Order__c = System.today();
        account.Labels_Forms_Last_Order_amt__c = 20;
        account.Writing_Drafting_TY__c = 20;
        account.Writing_Drafting_LY__c = 20;
        account.Writing_Drafting_Pot__c = 20;
        account.Writing_Drafting_Last_Order__c = System.today();
        account.Writing_Drafting_Last_Order_amt__c = 20;
        account.Office_Essentials_TY__c = 20;
        account.Office_Essentials_LY__c = 20;
        account.Office_Essentials_Pot__c = 20;
        account.Office_Essentials_Last_Order__c = System.today();
        account.Office_Essentials_Last_Order_amt__c = 20;
        account.MPS_TY__c = 20;
        account.MPS_LY__c = 20;
        account.MPS_Pot__c = 20;
        account.MPS_Last_Order__c = System.today();
        account.MPS_Last_order_amt__c = 20;
        account.Miscellaneous_TY__c = 20;
        account.Miscellaneous_LY__c = 20;
        account.Miscellaneous_Pot__c = 20;
        account.Miscellaneous_Last_Order__c = System.today();
        account.Miscellaneous_Last_Order_amt__c = 20;
        insert account;
        return account;
   }

  //===========================================================//
  //Create Account for Related site account
  //===========================================================//
   public static Account CreateAccountForRelatedAccount(id RelatedAccId) {
    RecordType siteRecType = [select id from recordtype where developername = 'Site' AND SobjectType = 'Account'];
    Account account =  new Account(Name = 'TestrelatedAccount',stage__c = 'SOW',
    cadence_call_date_override__c=false,
    recordTypeId=siteRecType.id,Related_Account__c = RelatedAccId);
    return account;
   }

  //===========================================================//
  //Create SalesPerson For Account with defaults
  //===========================================================//
  public static Sales_Person__c createTestSalesPerson(String userId,String extId){
    Sales_Person__c testSalesPerson = new Sales_Person__c();
    testSalesPerson.ExtIDSalesPerson__c = extId;
    testSalesPerson.IsActive__c = true;
    testSalesPerson.Primary__c = true;
    testSalesPerson.User__c = userId;
    testSalesPerson.Name = '1234567'; //NBOCK - S-377000 - added to prevent test failure
    insert testSalesPerson;

    return testSalesPerson;
  }

  //===============================================================//
  // Get aggregate account list
  //================================================================//
  public static List<AggregateResult> getAggregateSiteAccountList(Id UserId){
    Id siteRecordTypeID = Test_Utils.getAccountRecordType('Site');
    return [SELECT sum(MTD_Sales_TY__c) MTD_Sales_TY__c,
            sum(MTD_Sales_TY_IMU__c) MTD_Sales_TY_IMU2__c,
            sum(MTD_Sales_LY__c) MTD_Sales_LY__c,
            sum(MTD_Sales_LY_IMU__c) MTD_Sales_LY_IMU2__c,
            sum(MTD_Sales_Diff__c) MTD_Sales_Diff__c,
            sum(Monthly_LY__c) Monthly_LY__c,
            sum(Monthly_LY_IMU__c) Monthly_LY_IMU_Per__c,
            sum(Month_Goal__c) Month_Goal__c,
            sum(ADS_Current_Month__c) ADS_Current_Month__c,
            sum(ADS_Last_Month__c) ADS_Last_Month__c,
            sum(QTD_Sales_TY__c) QTD_Sales_TY__c,
            sum(QTD_Sales_TY_IMU__c) QTD_Sales_TY_IMU2__c,
            sum(QTD_Sales_LY__c) QTD_Sales_LY__c,
            sum(QTD_Sales_LY_IMU__c) QTD_Sales_LY_IMU2__c,
            sum(QTD_Sales_Diff__c) QTD_Sales_Diff__c,
            sum(Quarter_LY__c) Quarter_LY__c,
            sum(Quarter_LY_IMU__c) Quarter_LY_IMU_per__c,
            sum(Quarter_Goal__c) Quarter_Goal__c,
            sum(ADS_Current_Qtr__c) ADS_Current_Qtr__c,
            sum(ADS_Last_Qtr__c) ADS_Last_Qtr__c,
            sum(YTD_Sales_TY__c) YTD_Sales_TY__c,
            sum(YTD_Sales_TY_IMU__c) YTD_Sales_TY_IMU2__c,
            sum(YTD_Sales_LY__c) YTD_Sales_LY__c,
            sum(YTD_Sales_LY_IMU__c) YTD_Sales_LY_IMU2__c,
            sum(YTD_Sales_Diff__c) YTD_Sales_Diff__c,
            sum(Year_LY__c) Year_LY__c,
            sum(Year_LY_IMU__c) Year_LY_IMU_per__c,
            sum(Year_Goal__c) Year_Goal__c,
            sum(ADS_Current_Yr__c) ADS_Current_Yr__c,
            sum(ADS_Last_Yr__c) ADS_Last_Yr__c
            from Account where RecordTypeId =:siteRecordTypeID and ownerId=:UserId];
  }

  //===========================================================//
  //Create Contact with defaults
  //===========================================================//
  public static Contact CreateContact(Id accountId) {
    Contact contact = new Contact(LastName = 'TEST',AccountId = accountId);
    contact.MailingCountry = 'MEX';
    //START NSHARP S-388120 3.24.16
    contact.FirstName = 'Jon';
    //END NSHARP S-388120 3.24.16
    insert contact;

    return contact;
  }

  //===========================================================//
  //Create Contact with defaults
  //===========================================================//
  public static Contact CreateContactWithAccountAndLastName(Id accountId, String lastName) {
    Contact contact = new Contact(LastName = lastName, AccountId = accountId);
    contact.MailingCountry = 'MEX';
    //START NSHARP S-388120 3.24.16
    contact.FirstName = 'Jon';
    //END NSHARP S-388120 3.24.16
    insert contact;

    return contact;
  }

  //===========================================================//
  //Create Contact with defaults
  //===========================================================//
  public static Contact CreateContactForCheckDuplicate(String name, Id accountId, Id siteAccountId) {
    Contact contact = new Contact(LastName = name, AccountId = accountId, Site_Account__c = siteAccountId, MailingCountry = 'MEX');
    //START NSHARP S-388120 3.24.16
    contact.FirstName = 'Jon';
    //END NSHARP S-388120 3.24.16
    insert contact;

    return contact;
  }

  //===========================================================//
  //Create Lead with defaults
  //===========================================================//
  public static Lead CreateLead() {
    Lead lead = new Lead(LastName = 'TEST', Amount__c = 25.00, Company = 'test',phone = '(999) 999-9999', city__c = 'city1', state__c = 'state1', country__c='USA', FirstName = 'firstName');
    insert lead;

    return lead;
  }

  /*public static Lead CreateLead1(Sales_Person__c sp) {
    Lead lead = new Lead(LastName = 'TEST',Company = 'test', Sales_Person_ID__c = sp.Id);
    insert lead;

    return lead;
  }*/

  //===========================================================//
  //Create Lead for LeadConversion
  //===========================================================//

  public static Lead CreateLeadForConversion(Account account) {
    User user = CreateUser();
   // Sales_Person__c salesPerson = createTestSalesPerson(user.Id,'testSalesPerson1');
    Lead lead = new Lead(Account__c = account.Id, address1__c = 'test', zip__c = '123', ownerId = user.Id,
    phone = '(999) 999-9999', amount__c = 25.00, city__c = 'city1', state__c = 'state1', country__c='USA', FirstName = 'firstName', LastName = 'lastName', WCW_Count__c = 1, Company ='testing comp' );
    insert lead;
    return lead;
  }

  public static Lead CreateLeadForConversionGeneration(Account account) {
    User user = CreateUser();
  //  Sales_Person__c salesPerson = createTestSalesPerson(user.Id,'testSalesPerson3');
    Lead lead = new Lead(Account__c = account.Id, amount__c = 25.00, address1__c = 'test', zip__c = '14423', ownerId = user.Id,
    phone = '(999) 999-9999', city__c = 'city1', state = 'FL', FirstName = 'Test', LastName = 'Test', WCW_Count__c = 1, Company ='testing comp' );
    
        insert lead;
    return lead;
  }

  public static Lead CreateLeadForConversionWithoutAccount(User testUser) {
    //User user = CreateUser();
    //User userWithContractDivisionRole = [SELECT Id, Name FROM User where name = 'Jen Bryant' limit 1];
    /*UserRole InsideSalesRole = [SELECT Id from UserRole WHERE Name = 'Inside Sales' limit 1];
    User userWithInsideSalesRole = [SELECT Id, Name FROM User WHERE UserRoleId = :InsideSalesRole.Id AND isActive = true limit 1];
    //User user = CreateUser();*/

    //Sales_Person__c testSp = Test_Utils.createTestSalesPersonNew(testUser.Id,'21347');

    Lead lead = new Lead(street = 'test', zip__c = '14423', /*ownerId = testUser.Id,*/
    phone = '(999) 999-9999', city = 'city1', amount__c=25.00, state = 'FL', FirstName = 'Test', LastName = 'Test', WCW_Count__c = 1);
    lead.Company = 'test comp ' + String.valueOf(System.now());
   
        insert lead;
    return lead;
  }


  //===========================================================//
  //Create Lead with store
  //===========================================================//
  public static Lead CreateLeadForUser(Store__c testStore) {
    Lead lead = new Lead();
    lead.Company = 'testComp';
    lead.Status = 'Open';
    lead.amount__c = 25.00;
    lead.LastName = 'LName1';
    lead.Auto_Assign__c = true;
    lead.zip__c = '12345';
    lead.Store__c = testStore.Id;
    lead.product__c = 'CPD-Promo';
    lead.Industry = null;
    lead.WCW_Count__c = 771;

   
    insert lead;

    return lead;
  }

  //===========================================================//
  //Generate Lead (this will not do any dml operation)
  //===========================================================//

  public static Lead GenerateLead(String zip, Decimal WCW_count, String industry, String lName, boolean autoAssign) {
    Lead lead = new Lead();
    lead.Company = 'testComp';
    lead.Status = 'Open';
    lead.amount__c = 25.00;
    lead.LastName = lName;
    lead.Auto_Assign__c = autoAssign;
    lead.zip__c = zip;
    lead.Industry = null;
    lead.WCW_Count__c = WCW_count;
    lead.Industry = industry;

    return lead;
  }

  /*public static Lead GenerateLead1(String zip__c, Decimal WCW_count, String industry, String lName, boolean autoAssign, Store__c testStore) {
    Lead lead = new Lead();
    lead.Company = 'testComp';
    lead.Status = 'Open';
    lead.LastName = lName;
    lead.Auto_Assign__c = autoAssign;
    lead.zip__c = zip__c;
    lead.Industry = null;
    lead.WCW_Count__c = WCW_count;
    lead.Industry = industry;
    lead.product__c = 'CPD-Promo';
    lead.Store__c = testStore.Id;

    return lead;
  }*/

  //===============================================================//
  // Create Lead with store
  //===============================================================//
   /*public static Lead CreateLeadForUserNew(Store__c testStore) {
    Lead lead = new Lead();
    lead.Company = 'testComp';
    lead.Status = 'Open';
    lead.LastName = 'LName1';
    lead.Auto_Assign__c = true;
    lead.zip__c = '12666';
    lead.Store__c = testStore.Id;
    lead.Industry = null;
    lead.WCW_Count__c = 1;
    lead.product__c = 'CPD-Promo';
    insert lead;
    return lead;
  }*/

  //===========================================================//
  //Create Opportunity with defaults
  //===========================================================//
  public static Opportunity CreateOpportunity(Boolean isLineItemNeeded,Id accountID) {
    //Account account = CreateAccount();
    //account.Opportunity_Amt__c = 100;
    //update account;
    Opportunity opportunity = new Opportunity(Name = 'TEST',CloseDate = System.today(),StageName = 'Open',Amount = 200,AccountId = accountID );
    insert opportunity;
    if(isLineItemNeeded) {
      PricebookEntry priceEntry = CreatePricebookEntry();
      OpportunityLineItem lineItem = CreateOpportunityLineItem(opportunity.id, priceEntry.Id);
    }

    return opportunity;
  }

  //===========================================================//
  //Create Opportunity with site
  //===========================================================//
  public static Opportunity CreateOpportunityWithSiteAccountType (Boolean isLineItemNeeded,Id accountID, Account prospectAccount) {

    Opportunity opportunity = new Opportunity(Name = 'TEST',CloseDate = System.today(),StageName = 'Open',Amount = 200,AccountId = prospectAccount.Id, Related_Site__c = accountID);
    
    
        insert opportunity;
        
    if(isLineItemNeeded) {
      PricebookEntry priceEntry = CreatePricebookEntry();
      OpportunityLineItem lineItem = CreateOpportunityLineItem(opportunity.id, priceEntry.Id);
    }

    return opportunity;
  }



  //===========================================================//
  //Create Opportunity with defaults
  //===========================================================//
  public static Opportunity CreateOpportunity(Boolean isLineItemNeeded) {
    return CreateOpportunity(isLineItemNeeded,null);
  }



  //===========================================================//
  //Create OpportunityLineItem with defaults
  //===========================================================//
  private static OpportunityLineItem CreateOpportunityLineItem(Id oppId, Id priceId) {
    OpportunityLineItem lineItem = new OpportunityLineItem(OpportunityId = oppId,PricebookEntryId = priceId,TotalPrice = 200,Quantity = 1 );
    insert lineItem;
    return lineItem;
  }

  //===========================================================//
  //Create PricebookEntry with defaults
  //===========================================================//
  private static PricebookEntry CreatePricebookEntry() {
    Product2 p = new product2(name='DPS',ProductCode='DPS');
    insert p;
    Pricebook2 stdPb = [select Id from Pricebook2 where isStandard=true limit 1];
    insert new PricebookEntry(pricebook2id = stdPb.id, product2id = p.id,unitprice=1.0, isActive=true);
    Pricebook2 pb = new pricebook2(name='test');
    insert pb;
    PricebookEntry priceEntry = new PricebookEntry(pricebook2id=pb.id, product2id=p.id,unitprice=500, isActive=true);
    insert priceEntry;
    return priceEntry;
  }
  /*
  public static Account CreateSite(Id accId) {
    Account Site = new Account(Related_Account__c = accId,city__c = 'city' ,state__c = 'state' ,country__c = 'country',zip__c = '1234456',CPD_LY__c = 2,CPD_TY__c = 4,CPD_POT__c = 5);
    insert Site;
    List<Account> lstSite = [Select CPD_LY__c,CPD_TY__c,CPD_POT__c,CPD_Diff__c,id from Account where id =: Site.id];
    return lstSite[0];
  }*/

  public static Opportunity CreateOpportunityWAccount(Boolean isLineItemNeeded,Id accId) {
    
    
     Account   account = CreateAccount();
    //account.Opportunity_Amt__c = 200;
    
    
        update account;
    //System.debug('--------------rec id -----'+ account.RecordTypeId);


    Opportunity opportunity = new Opportunity(Amount=200,AccountId = account.Id, Related_Site__c = accId,  Name = 'TEST',CloseDate = System.today(),StageName = 'Open');

    
        insert opportunity;
    if(isLineItemNeeded) {
      PricebookEntry priceEntry = CreatePricebookEntry();
      OpportunityLineItem lineItem = CreateOpportunityLineItem(opportunity.id, priceEntry.Id);
    }
    return opportunity;
  }

  public static Assignment_Rule__c CreateAssignmentRule() {
    List<User> lstUser = new List<User>([select id from User limit 1]);
    Sales_Person__c salesPerson = new Sales_Person__c(ExtIDSalesPerson__c = 'ext12345',primary__c=true,isActive__c=true,User__c = lstUser[0].Id,Name = 'New Sales Person');
    insert salesPerson;
    Assignment_Rule__c assignmentRule = new Assignment_Rule__c(Sales_Rep_ID__c = 'ext12345', WCW_count__c = '0to500' ,  Zip_Code__c= '999999', Industry_Group__c = 'other' , Access_ID__c ='test');
    insert assignmentRule;
    return assignmentRule;
  }

  public static User CreateUser() {
    List<User> lstUser= [select id, roleId__c from user where isActive = true And profile.userLicense.name = 'Salesforce' /*AND isRoleChanged__c = false*/ limit 1];
    if(lstUser.size() > 0) {
      return lstUser[0];
    }
    return null;
  }

   public static User createTestUser(String usrName,String odEmpId){
     User stdTestUser = new User();
     stdTestUser.firstName = 'stdTestUser';
     stdTestUser.LastName = 'test'+usrName;
     stdTestUser.Alias = '12'+usrName;
     stdTestUser.Email = usrName+'stdTestUser@officedepot.com';
     stdTestUser.UserName= usrName+'stdTestUser@metacube.com';
     stdTestUser.ProfileId = [Select id from profile where name = 'System Administrator' limit 1].Id;
     stdTestUser.CommunityNickname = stdTestUser.firstname+'_'+stdTestUser.lastName;
     stdTestUser.EmailEncodingKey ='ISO-8859-1';
     stdTestUser.LanguageLocaleKey = 'en_US';
     //stdTestUser.TimeZoneSidKey ='America/Indianapolis';
     stdTestUser.TimeZoneSidKey ='America/New_York';
     stdTestUser.LocaleSidKey = 'en_US';
     stdTestUser.Country = 'USA';
     stdTestUser.OD_Employee_ID__c =odEmpId;
     return stdTestUser;
  }

  //===============================================================
  // To create a AccountTeamMember
  //===============================================================
  public static AccountTeamMember createAccountTeamMember(Account account, User user){
    AccountTeamMember accountTeamMember = new AccountTeamMember(AccountId = account.Id,
                                                                UserId = user.Id, TeamMemberRole = user.roleid__c );
    insert accountTeamMember;
    return accountTeamMember;
  }

  //===============================================================
  // To create a AccountTeamMember
  //===============================================================
  public static AccountTeamMember createAccountTeamMemberForOverlays(Account account, Id userId){
    AccountTeamMember accountTeamMember = new AccountTeamMember(AccountId = account.Id,
                                                                UserId = userId );
    insert accountTeamMember;
    return accountTeamMember;
  }



  public static Opportunity CreateOpportunityWAccountWithoutSite(Boolean isLineItemNeeded,Id accId) {
    /*Account account = CreateAccount();
    //account.Opportunity_Amt__c = 200;
    update account;*/

    Opportunity opportunity = new Opportunity(Amount=200,AccountId = accId, Name = 'TEST',CloseDate = System.today(),StageName = 'Open');

    insert opportunity;
    if(isLineItemNeeded) {
      PricebookEntry priceEntry = CreatePricebookEntry();
      OpportunityLineItem lineItem = CreateOpportunityLineItem(opportunity.id, priceEntry.Id);
    }
    return opportunity;
  }

  //===================================================================//
  // To get ContractDivisionRole
  //===================================================================//
  public static User getUserWithContractDivisionRole(){
    UserRole ContractDivisionRoleId = [SELECT Id from UserRole WHERE Name = 'Contract Division' limit 1];
    return [SELECT Id, Name FROM User WHERE UserRoleId = :ContractDivisionRoleId.Id AND isActive = true limit 1];
  }

  //===================================================================//
  // To get EmergingChannelRole
  //===================================================================//
  public static User getUserWithEmergingChannelRole(){
    UserRole EmergingChannelRoleId = [SELECT Id from UserRole WHERE Name = 'Emerging Channels' limit 1];
    return [SELECT Id, Name FROM User WHERE UserRoleId = :EmergingChannelRoleId.Id AND isActive = true limit 1];
  }

  public static Sales_Person__c createTestSalesPersonNew(String userId,String extId){
    Sales_Person__c testSalesPerson = new Sales_Person__c();
    testSalesPerson.ExtIDSalesPerson__c = extId;
    testSalesPerson.Name=  extId;
    testSalesPerson.IsActive__c = true;
    testSalesPerson.Primary__c = true;
    testSalesPerson.User__c = userId;
    return testSalesPerson;
  }
  /*public static Sales_Person__c createTestSalesPersonNew1(String userId,String extId){
    Sales_Person__c testSalesPerson = new Sales_Person__c();
    testSalesPerson.ExtIDSalesPerson__c = extId;
    testSalesPerson.IsActive__c = true;
    testSalesPerson.Primary__c = true;
    testSalesPerson.User__c = userId;
    //testSalesPerson.product__c = 'CPD-Promo';
    return testSalesPerson;
  }*/

  public static Assignment_Rule__c createTestAssignmentRule(String usrId,String SalesRepIdc,String wcwCount,String zipCode) {
    Sales_Person__c salesPerson = new Sales_Person__c(ExtIDSalesPerson__c = 'ext12345',primary__c=true,isActive__c=true,User__c = usrId,Name = usrId+'New Sales Person');
    insert salesPerson;
    Assignment_Rule__c assignmentRule = new Assignment_Rule__c(Emp_ID__c='21344',Industry_Group__c = 'Government',Sales_Rep_ID__c = SalesRepIdc, WCW_count__c = wcwCount ,  Zip_Code__c= zipCode, Access_ID__c ='test');
    insert assignmentRule;
    return assignmentRule;
  }

  // Insert Account_Setup_Request__c record
   public static Account_Setup_Request__c createAccountSetupReq(Account account) {
    Account_Setup_Request__c accSetupReq = new Account_Setup_Request__c(Survey_Complete__c = true,Account__c = account.Id);
    return accSetupReq;
  }

  // Insert Store
   public static Store__c createStore() {
    User testUser1 = Test_Utils.createTestUser('Tst22','223344');
    Store__c testStore = new Store__c();
    //testStore.CPD_Sales_Rep__c = testUser1.Id;
    insert testStore;
    return testStore;
  }

  // To get record type
  public static Id getAccountRecordType(String recordType){
    Schema.DescribeSObjectResult descSchema = Schema.SObjectType.Account;

    Map<String,Schema.RecordTypeInfo> rtMapByName = descSchema.getRecordTypeInfosByName();
    Schema.RecordTypeInfo rtByName = rtMapByName.get(recordType);
    return rtByName.getRecordTypeId();
  }

  //-------------------------------------------------------------------------------------------//
   //Recursively iterate through the Role hierarchy, to retrieve all roles reporting this role
   //-------------------------------------------------------------------------------------------//
   public static Set<ID> getAllSubOrdinateRoleID(Set<ID> parentRoleIds) {
     Set<ID> currentRoleIds = new Set<ID>();
     for(UserRole userRole :[SELECT Id FROM UserRole WHERE ParentRoleId IN :parentRoleIds AND ParentRoleID != null]) {
       currentRoleIds.add(userRole.Id);
     }
     if(currentRoleIds.size() > 0) {
       currentRoleIds.addAll(getAllSubOrdinateRoleID(currentRoleIds));
     }
     return currentRoleIds;
   }


   //-------------------------------------------------------------------------------------------//
   //Create Quote
   //-------------------------------------------------------------------------------------------//
   public static Quote createQuote(Opportunity opportunity){
     Quote quote = new Quote(name='testQuote', OpportunityId = opportunity.id);
     insert quote;
     return quote;
   }

   //-------------------------------------------------------------------------------------------//
   // Create QuoteLineItemCust__c
   //-------------------------------------------------------------------------------------------//
   public static QuoteLineItemCust__c createQuoteLineItemCust(Quote quote){
     QuoteLineItemCust__c quoteLineItem = new QuoteLineItemCust__c(Name = 'testCore', UnitPrice__c = 100, multiplier__c = 2, Quantity__c = 5, QuoteID__c = quote.id);
     insert quoteLineItem;
     return quoteLineItem;
   }

  //-------------------------------------------------------------------------------------------//
  // Create Cadence__c
  //-------------------------------------------------------------------------------------------//
   public static Cadence__c createCadence(){
     Cadence__c cadence = new Cadence__c (Name = 'Test', Lifecycle_Stage__c = 'New', Cadence__c = 2);
     insert cadence;
     return cadence;
   }

   //-------------------------------------------------------------------------------------------//
  // Create Case
  //-------------------------------------------------------------------------------------------//
   public static Case createCase(){
     Case testCase = new Case ();
     insert testCase;
     return testCase;
   }

   // Create Test USer
   public static User getTestUser(String profileName,String userName,String empId){
        Profile profileObj = [select id from profile where name=: profileName];
        String profId = profileObj.id;

        string email = userName;
        string[] name = userName.split('@');
        user u = new user(Username=userName,FirstName =name[1], LastName=name[0], Alias=name[0], CommunityNickname=userName, LocaleSidKey='en_US', EmailEncodingKey='UTF-8', Profileid = profId, LanguageLocaleKey='en_US');
        u.email=email;
        u.MB_Expiration_Date__c = System.now().addminutes(1);
        u.OD_Employee_ID__c =empId;
        u.GT_Employee_ID__c =empId;
        u.IsActive=true;
        u.TimeZoneSidKey='America/Los_Angeles';
        u.Token_Market_Builder__c ='xyz';
        try{
            Insert u;
            system.debug('@@@User@@@ : '+u);
            return u;
        }
        catch(Exception e) {
            system.debug('Exception'+e);
        }
        return u;
    }

    // Create Account
    public static Account getTestAccount(User u, string accOtherId){
        //accOtherId for example 123654
        Account acc = new Account ();
        acc.name = 'SUN'+u.name;
        //acc.BillingStreet = '1040 N 326 W';
        acc.OMX_Primary_Key__c = accOtherId;
        //acc.billingcity = 'Orem';
        //acc.BillingState = 'UT';
        //acc.Billingcountry = 'USA';
        acc.Oracle_Party_Id__c = accOtherId ;
        acc.AOPS_Cust_Id__c = accOtherId ;
        acc.AOPS_Seq_ID__c = accOtherId ;
        acc.OwnerID = u.id;// This is the salesforce User ID
        acc.Address1__c = 'address';

        
         insert acc;
        system.debug('@@@Account@@@ : '+acc);
        return acc;
    }

    // Create GPO Template
    public static GPO_Template__c createGPOTemplate(String tempName, boolean isInsert){
        GPO_Template__c gpoTemplate = new GPO_Template__c();
        gpoTemplate.Name = tempName;
        gpoTemplate.Template_Name__c = tempName;

        if(isInsert)
            insert gpoTemplate;
        return gpoTemplate;
    }

    // Create GPO Group
    public static GPO_Group__c createGPOGroup(GPO_Template__c gpoTemplate, Account account,  boolean isInsert){
        GPO_Group__c gpoGroup = new GPO_Group__c();
        gpoGroup.Account__c = account.Id;
        gpoGroup.GPO_Template__c = gpoTemplate.Id;

        if(isInsert)
            insert gpoGroup;
        return gpoGroup;
    }
    
    // Create GPO Group
    public static GPO_Group__c createPrivateGPOGroup(GPO_Template__c gpoTemplate, Account account,  boolean grp_p,boolean isInsert){
        GPO_Group__c gpoGroup = new GPO_Group__c();
        gpoGroup.Account__c = account.Id;
        gpoGroup.GPO_Template__c = gpoTemplate.Id;
        
        gpogroup.Community_Name__c = 'Default Group';
        gpoGroup.Welcome_Title__c = 'Test GPO Group Title';
        gpoGroup.Private__c = grp_p;

        if(isInsert)
            insert gpoGroup;
        return gpoGroup;
    }
    
    

    // Create GPO Group Detail
    public static GPO_Group_Detail__c createGPOGroupDetail(GPO_Group__c gpoGroup, String groupDetailName,  boolean isInsert){
        GPO_Group_Detail__c gpoGroupDetail = new GPO_Group_Detail__c();
        gpoGroupDetail.GPO_Group__c = gpoGroup.Id;
        gpoGroupDetail.Name = groupDetailName;

        if(isInsert)
            insert gpoGroupDetail;
        return gpoGroupDetail;
    }

    // Create GPO Community Setup
    public static GPO_Community_Setup__c createGPOCommunitySetUp(GPO_Template__c gpoTemplate, Boolean isInsert){
        GPO_Community_Setup__c gpoCommunitySetUp = new GPO_Community_Setup__c();
            gpoCommunitySetUp.Name = 'default';
            gpoCommunitySetUp.defaultTemplate__c = gpoTemplate.Id;
            gpoCommunitySetUp.Admin_ProfileId__c = '00eE0000000IQxT';
            gpoCommunitySetUp.defaultRecordType__c = '012E000000093wNIAQ';

        if(isInsert)
            insert gpoCommunitySetUp;
        return gpoCommunitySetUp;
    }
    
    // Create GPO Community Setup
    public static GPO_Community_Setup__c createGPOCommunitycom2SetUp(GPO_Template__c gpoTemplate, Boolean isInsert){
        GPO_Community_Setup__c gpoCommunitySetUp = new GPO_Community_Setup__c();
            gpoCommunitySetUp.Name = 'com2Settings';
            gpoCommunitySetUp.defaultTemplate__c = gpoTemplate.Id;
            gpoCommunitySetUp.Admin_ProfileId__c = '00eE0000000IQxT';
            gpoCommunitySetUp.defaultRecordType__c = '012E000000093wNIAQ';

        if(isInsert)
            insert gpoCommunitySetUp;
        return gpoCommunitySetUp;
    }

    // Create GPO Lead
    public static GPO_Lead__c createGPOLead(Account account, Boolean isInsert){
        GPO_Lead__c gpoLead = new GPO_Lead__c();
            gpoLead.Account__c =  account.Id;
            gpoLead.first_name__c = 'Test First Name';
            gpoLead.last_name__c = 'Test Last Name';
            gpoLead.Phone__c = '(999) 999-3333';
            gpoLead.Email__c = 'test@test.com';
            gpoLead.Business_Name__c = 'testBusiness';
            gpoLead.Zip__c = '123456';

        if(isInsert)
            insert gpoLead ;
        return gpoLead ;
    }
    
     // Create GPO Lead
    public static GPO_Lead__c createGPOLead_for_privgrp(Account account, Boolean isInsert){
        GPO_Lead__c gpoLead = new GPO_Lead__c();
            gpoLead.Account__c =  account.Id;
            gpoLead.Login_Name__c = 'TESTING PRIVATE LEAD';
            gpoLead.first_name__c = 'Test First Name';
            gpoLead.last_name__c = 'Test Last Name';
            gpoLead.Phone__c = '(999) 999-3333';
            gpoLead.Email__c = 'test@test.com';
            gpoLead.Business_Name__c = 'testBusiness';
            gpoLead.Zip__c = '123456';
            gpoLead.Status__c = 'Pending';
            gpoLead.Private__c = true;

        if(isInsert)
            insert gpoLead ;
        return gpoLead ;
    }
    
    // createContactSA : This method is used to create test record of 'Contact_Staging_Area__c' object
    // Created by Mohit for S-386204 
    public static Contact_Staging_Area__c createContactSA(Boolean isInsert){
        Contact_Staging_Area__c contactSA = new Contact_Staging_Area__c();
            contactSA.Name = 'Test 27';
            contactSA.Phone__c = '2702702700';
            contactSA.DUNS_Enrichment__c = '270000270';
            contactSA.First_Name__c = 'Test Contact';
            contactSA.Last_Name__c = '27';
            contactSA.Lead_Source__c = 'Test Class 27';
            contactSA.Middle_Name__c = 'None';
            contactSA.Mobile_Phone__c = '2702702700';
            contactSA.MRC_Code__c = 'A27A';
            contactSA.Primary_Email_Address__c = 'test@gmail.com';
            contactSA.Title__c = 'Associate';
            contactSA.Type__c = 'Stage Test';

        if(isInsert)
            insert contactSA ;
        return contactSA ;
    }
    
    // createProspectSA : This method is used to create test record of 'Contact_Staging_Area__c' object
    // Created by Mohit for S-386205
    public static Prospect_Staging_Area__c createProspectSA(Boolean isInsert){
        Prospect_Staging_Area__c prospectSA = new Prospect_Staging_Area__c();
            prospectSA.Name = 'Test 27';
            prospectSA.Address_1__c = '2700 SW 27th st';
            prospectSA.Address_2__c = 'Suite 27';
            prospectSA.City__c = 'Jupiter';
            prospectSA.State__c = 'Fl';
            prospectSA.Zip__c = '33469';
            prospectSA.Source__c = 'DNB Acquisition';
            prospectSA.Duns_Enrichment__c = '270000270';
            prospectSA.Phone__c = '2702702700';
            prospectSA.WCW__c = 27;
            prospectSA.Auto_Assign__c = true;
            prospectSA.Type__c = 'GPO 27';
            prospectSA.DNB_Propensity_Score__c = 3;
            prospectSA.DNB_Dollar_Amount__c = 20789.00;
            prospectSA.DNB_Dollar_Deciles_Overall__c = 1;
            prospectSA.DNB_Propensity_Segment__c = 2;
            
        if(isInsert)
            insert prospectSA ;
        return prospectSA ;
    }

  @isTest
  private static void Test_Utils() {
    //CreateLead();
    //Account act = Test_Utils.CreateAccount();
    //Test_Utils.CreateSite(act.Id);
    //Util.DEBUG('Lead Creatd');
  }

  @isTest
  private static void Test_CreateAccount() {
    Account account = Test_Utils.CreateAccount();
    System.assertNotEquals(account, null);
  }

  @isTest
  private static void Test_CreateSalesDispositionTask() {
    Account account = Test_Utils.CreateAccount();
    Task task = Test_Utils.CreateSalesDispositionTask(account.id);
    System.assertNotEquals(task, null);
  }

  @isTest
  private static void Test_CreateAccountForSalesHistory() {
    Account account = Test_Utils.CreateAccountForSalesHistory();
    System.assertEquals(account.YTD_Sales_LY__c, 15);
  }

  @isTest
  private static void Test_createTestSalesPerson() {
    User testUser1 = Test_Utils.createTestUser('Tst22','223344');
    Sales_Person__c salesPerson = Test_Utils.createTestSalesPerson(testUser1.id, '21344');
    System.assertEquals(salesPerson.IsActive__c, true);
  }

  @isTest
  private static void Test_CreateContact() {
    Account account = Test_Utils.CreateAccount();
    Contact contact = Test_Utils.CreateContact(account.Id);
    System.assertEquals(contact.LastName, 'TEST');
  }

  @isTest
  private static void Test_CreateLead() {
    //Lead lead = Test_Utils.CreateLead();
    //System.assertEquals(lead.LastName, 'TEST');
  }

  /*@isTest
  private static void Test_CreateLeadForUser() {
    Store__c store = Test_Utils.createStore();
    Lead lead = Test_Utils.CreateLeadForUser(store);
    System.assertEquals(lead.LastName, 'LName1');
  } */


    // Added By Jyoitrmaya Rath
    // Create new Customer_Transition__c

    public static Customer_Transition__c CreateCustomerTransaction(boolean isInsert,Account account) {

        Customer_Transition__c customertrans = new Customer_Transition__c();
        customertrans.Account__c =  account.id;
        customertrans.Retrigger_Mod_5__c = false ;
        customertrans.Ready_for_Mod1__c = false ;
        customertrans.OMX_Primary_Key__c ='OMX003';
        customertrans.AOPS_Flag__c = 'Y';
        customertrans.Transition_Status__c = 'Active';
        customertrans.Split_Launching_Status__c = 'Submitted';
        customertrans.Final_Split_Decision__c  = 'Yes';
        customertrans.Ready_For_Mod_5__c =true;
          if(isInsert){
              insert customertrans;
          }
          return customertrans;
    }

    public static Split_Account_Detail__c  createSplitAccount(boolean isInsert,Customer_Transition__c  cusTrans,Account originalAccount) {

        Split_Account_Detail__c splitAcc = new Split_Account_Detail__c();
        splitAcc.Customer_Transition__c = cusTrans.id;
        splitAcc.Original_Account__c = originalAccount.id;
        splitAcc.Master_Account__c = '';
        splitAcc.Status__c ='Success';
          if(isInsert){
              insert splitAcc;
          }
          return splitAcc;
    }

    public static Customer_Transition_Dtls__c createCustomerTransDetails(String Recordtype){


        Customer_Transition_Dtls__c ctd = new Customer_Transition_Dtls__c();
        ctd.RecordTypeId = Schema.SObjectType.Customer_Transition_Dtls__c.getRecordTypeInfosByName().get(Recordtype).getRecordTypeId() ;
        ctd.Error_Code__c = 'Error';
        ctd.OMX_Primary_Key__c='1234';
        return ctd;
    }

    public static Pricing_template__c createPricingTemplate(){
        Pricing_template__c temp = new Pricing_template__c(name = 'Standard Web Match Test' ,
                                    Contract_Number_10__c='1',
                                    Contract_Number_1__c='1',
                                    Contract_Number_2__c='1',
                                    Contract_Number_3__c='1',
                                    Contract_Number_4__c='1',
                                    Contract_Number_5__c='1',
                                    Contract_Number_6__c='1',
                                    Contract_Number_7__c='1',
                                    Contract_Number_8__c='1',
                                    Contract_Number_9__c='1',
                                    Priority_1__c='1',
                                    Priority_2__c='1',
                                    Priority_3__c='1',
                                    Priority_4__c='1',
                                    Priority_5__c='1',
                                    Priority_6__c='1',
                                    Priority_7__c='1',
                                    Priority_8__c='1',
                                    Priority_9__c='1',
                                    Priority_10__c='1',
                                    Cust_Prod_Xref__c='1',
                                    Delivery_Code__c='1',
                                    Exclude_Universal_Pricing__c='1',
                                    GP_Floor_Percernt__c='1',
                                    Loyalty__c='No',
                                    Minimum_Order_Value__c='1',
                                    Off_Contract_Code__c='1',
                                    Off_Contract_Percent__c='1',
                                    Off_Wholesale_Code__c='1',
                                    Off_Wholesale_Percent__c='1',
                                    Price_Plan_Id__c='7200000-300',
                                    Account_Setup_Notes_c__c = 'This account will be auto setup within 10 mins. Comments will not be read.',
                                    Revenue_Band__c='STANDARD',
                                    Freight_Charge__c = 'Yes',
                                    Parent_Id__c = '123456');
        return temp;

    }



}
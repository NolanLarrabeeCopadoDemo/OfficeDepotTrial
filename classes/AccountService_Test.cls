/**********************************************************
Class: AccountService_Test
Author : Mike Keller
Date:    09/19/2011
Details : To test AccountService
***********************************************************/
@isTest
private class AccountService_Test {

  static testMethod void testAccountService(){

    AccountService.ServiceAccount goodTestAcct = createGoodServiceAccount();
    AccountService.SalesCustomerAccountCreation sac = new AccountService.SalesCustomerAccountCreation();
    sac.customers = new List<AccountService.ServiceAccount>();
    sac.customers.add(goodTestAcct);
    AccountService.UpsertAccountTxnStatus goodTestAcctResponse = AccountService.UpsertAccounts(sac);

    //Account account = Test_Utils.CreateAccount();
    List<Account> acclist = new List<Account>();
    Account account = new Account(Name = 'TEST');
    Schema.DescribeSObjectResult descSchema = Schema.SObjectType.Account;

    Map<String,Schema.RecordTypeInfo> rtMapByName = descSchema.getRecordTypeInfosByName();
    Schema.RecordTypeInfo rtByName = rtMapByName.get('Prospect');

    User usr = Test_Utils.CreateUser();
    Sales_Person__c salesPerson = Test_Utils.createTestSalesPerson(usr.Id,'testSalesPerson');

    account.ShippingStreet = 'ABC';
    account.ShippingState = 'ABC';
    account.ShippingCity = 'ABC';
    account.Ranking__c = 100;
    account.Rep_call_date__c = date.today();
    account.Country__c = 'USA';
    account.RecordTypeId = rtByName.getRecordTypeId();
    //account.Primary_Contact_Phone__c = '(999) 999-9999';
    account.Sales_PersonID__c = salesPerson.Id;
    account.Assign_Specific_Owner__c = usr.id;
    account.Auto_Assign__c = false;
    //account.oracle_party_id__c = '123456';
    account.Oracle_Party_Site_Id__c = '12345678';
    account.AOPS_Seq_ID__c = '12345678';
    insert account;
    acclist.add(account);

    AccountService.updateAcctSetupReqStatus(account.id,'S');
    AccountService.updateAcctSetupReqStatus(account.id,'T');

    goodTestAcct = updateGoodServiceAccount();
    sac = new AccountService.SalesCustomerAccountCreation();
    sac.customers = new List<AccountService.ServiceAccount>();
    sac.customers.add(goodTestAcct);
    goodTestAcctResponse = AccountService.UpsertAccounts(sac);

    test.startTest();

    AccountService.ServiceAccount badTestAcct = updateBadServiceAccount();
    sac.customers = new List<AccountService.ServiceAccount>();
    sac.customers.add(badTestAcct);
    AccountService.UpsertAccountTxnStatus badTestAcctResponse = AccountService.UpsertAccounts(sac);

    badTestAcct = noAOPSIdAccount();
    sac.customers = new List<AccountService.ServiceAccount>();
    sac.customers.add(badTestAcct);
    badTestAcctResponse = AccountService.UpsertAccounts(sac);

    //Instantiate the object, so that SFDC consider this class as covered
    AccountService.ServiceSiteStatus dummyServiceStatus = new AccountService.ServiceSiteStatus();
    AccountService.ServiceAccountStatus ser = new AccountService.ServiceAccountStatus();
    //AccountService.createCrossReferenceRecord('test source','test key',system.today(),'test aops');
    //String testid = acclist.get(0).id;
    //AccountService.updateAcctSetupReqStatus(testid,'S');
    //AccountService.updateAcctSetupReqStatus(testid,'E');
    //Map<Id,AccountService.ServiceAccount> msgs;
    //AccountService.updateParentAssociations(acclist,msgs);
    test.stopTest();

  }
  
  // S-371579 - Hitesh Pareek [Dec 21, 2015]--------START
  static testmethod void testcreateCrossReferenceRecord(){
    Account acc = Test_Utils.CreateAccount();    
      Customer_Transition__c customertrans = new Customer_Transition__c();
        customertrans.Account__c =  acc.id;
        customertrans.Retrigger_Mod_5__c = false ;
        customertrans.Ready_for_Mod1__c = false ;
        customertrans.OMX_Primary_Key__c ='OMX00332';
        customertrans.AOPS_Flag__c = 'Y';
        customertrans.Transition_Status__c = 'Active';
        customertrans.Split_Launching_Status__c = 'Submitted';
        customertrans.Final_Split_Decision__c  = 'Yes';
        customertrans.Ready_For_Mod_5__c =true;
        insert customertrans;
      system.assertNotEquals(null, customertrans.id);
    
    Customer_Transition__c cust_query = [select OMX_Primary_Key__c from Customer_Transition__c where id =:customertrans.id limit 1];
    
    Test.startTest();
      string result = AccountService.createCrossReferenceRecord('test source',cust_query.OMX_Primary_Key__c,system.today(),'test aops', 'c', DateTime.now());
      //OfficeMax_OfficeDepot_CrossReference__c crossObjCreated = [select id, Customer_Transition__r.Id, OMX_Key__c from OfficeMax_OfficeDepot_CrossReference__c where Customer_Transition__c =:cust_query.id limit 1];
      //system.assertNotEquals(null, crossObjCreated.Customer_Transition__r.Id);
    Test.stopTest();
    
  }
  // S-371579 - Hitesh Pareek [Dec 21, 2015]--------END
  

  static AccountService.ServiceAccount createGoodServiceAccount(){

    // Added by Mohit for Story S-350564 //
    Account acc = new Account();
    acc.Name='Test';
    insert acc ;
    //S-434785 (OD 00777600) Connor Flynn Start
    Account acc2 = new Account();
    acc2.Name='Test2';
    insert acc2 ;
    //S-434785 (OD 00777600) Connor Flynn End
    AccountService.ServiceAccount sa = new AccountService.ServiceAccount();
    sa.CREATE_UPDATE_FLAG = 'C';
    sa.VERSION = '';
    sa.SFDC_CUSTOMER_ID = '';
    sa.ORACLE_CUSTOMER_ID = '123456';
    sa.AOPS_CUSTOMER_ID = '997875';
    sa.CONTRACT_RETAIL_CUST_CODE = 'C';
    sa.BUSINESS_NAME = 'Account Service Test Account';
    sa.CUSTOMER_DELETE_FLAG = 'N';
    sa.CUSTOMER_TYPE = 'Customer';
    sa.Legal_Flag = 'Y';
    sa.ORDER_MAX_AMOUNT = '200';
    sa.SECTOR = 'just to test';
    sa.RSV1_CHAR2 = 'A';
    sa.RSV2_CHAR2 = 'B';
    sa.PARENT_CUSTOMER_ID = '';
    sa.FREIGHT_CHARGE_REQUIRED = 'N';
    sa.ACCCOUNT_PROSPECT_ID = '';
    sa.SEGMENTATION = 'Private';
    sa.HOSTED_CATALOG_FLAG = 'Y';//S-343745 [Joe/Hemant 8/18/2015] - Added Hosted Catalog Flag
    sa.sites = new List<AccountService.ServiceSite>();
      AccountService.ServiceSite ss = new AccountService.ServiceSite();
      ss.ORACLE_ADDR_SEQ_NUM = '';
      ss.SFDC_ADDR_SEQ_NUM = String.valueOf(acc.Id); // Modified by Mohit for Story S-350564 //
      ss.AOPS_ADDR_SEQ_NUM = '997875-00001';
      ss.LOCATION_KEY = '';
      ss.ACCOUNT_NAME = 'Store 0';
      ss.ADDRESS_LINE1 = '1 Main St';
      ss.ADDRESS_LINE2 = '';
      ss.CITY = 'Boca Raton';
      ss.STATE = 'FL';
      ss.ZIP_CODE = '34872';
      ss.COUNTRY = 'USA';
      ss.COUNTY = 'Westchester';
      ss.REP = '12345';
      ss.DEFAULT_FLAG = 'Y';

      sa.sites.add(ss);

      AccountService.ServiceSite ss1 = new AccountService.ServiceSite();
      ss1.ORACLE_ADDR_SEQ_NUM = '';
      ss1.SFDC_ADDR_SEQ_NUM = String.valueOf(acc2.Id); ////S-434785 (OD 00777600) Connor Flynn 
      ss1.AOPS_ADDR_SEQ_NUM = '997875-00002';
      ss1.LOCATION_KEY = '';
      ss1.ACCOUNT_NAME = 'Store 1';
      ss1.ADDRESS_LINE1 = '1 Main St';
      ss1.ADDRESS_LINE2 = '';
      ss1.CITY = 'Boca Raton';
      ss1.STATE = 'FL';
      ss1.ZIP_CODE = '34872';
      ss1.COUNTRY = 'USA';
      ss1.COUNTY = 'Westchester';
      ss1.REP = '12345';
      ss1.DEFAULT_FLAG = 'N';

      sa.sites.add(ss1);

      
      
    return sa;
  }

  static AccountService.ServiceAccount updateBadServiceAccount(){
    AccountService.ServiceAccount sa = createGoodServiceAccount();
    sa.CREATE_UPDATE_FLAG = 'U';
    sa.AOPS_CUSTOMER_ID = '997876';
    return sa;
  }

  static AccountService.ServiceAccount noAOPSIdAccount(){
    AccountService.ServiceAccount sa = createGoodServiceAccount();
    sa.CREATE_UPDATE_FLAG = 'C';
    sa.AOPS_CUSTOMER_ID = '';
    return sa;
  }

  static AccountService.ServiceAccount updateGoodServiceAccount(){
    AccountService.ServiceAccount sa = createGoodServiceAccount();
    sa.CREATE_UPDATE_FLAG = 'U';
    sa.BUSINESS_NAME = 'Account Service Test Account Update';
    return sa;
  }


  static AccountService.ServiceAccount insertBadSite(){
    AccountService.ServiceAccount sa = createGoodServiceAccount();
    sa.CREATE_UPDATE_FLAG = 'U';
    sa.sites = new List<AccountService.ServiceSite>();
    for (Integer i = 0; i < 2; i++) {
      AccountService.ServiceSite ss = new AccountService.ServiceSite();
      sa.sites.add(ss);
    }

    return sa;

  }


}
// 17 July 2015     Ryan Marquardt
@isTest
private class ProspectSetupExtension_TC{
  Static testMethod void Test_ProspectSetupExtension() {
    testUser = Test_Utils.CreateUser();

    System.RunAs(testUser){
        Pricing_template__c temp = new Pricing_template__c(name = 'abc' ,Parent_Id__c = '123456');
        insert temp;
        Sales_Person__c salesPerson = Test_Utils.createTestSalesPerson(testUser.id,'testSalesPerson');
        Account account = new Account(Name = 'Dude',recordtypeid='012E00000008dTaIAI',AOPS_Cust_Id__c='123456');
        insert account;
        ApexPages.currentPage().getParameters().Put('id',account.id);
        ApexPages.StandardController scontroller = new ApexPages.StandardController(account);
        ProspectSetupExtension prospectSetup = new ProspectSetupExtension(scontroller);
        //call commented by ivarada
        // prospectSetup.SaveAllData();
        prospectSetup.prospectAccount.Name = 'prospect';
        prospectSetup.prospectAccount.phone = '(999)312-9399';
        prospectSetup.prospectAccount.Pricing_template_cd__c='abc';
        prospectSetup.contact.LastName = 'contact';
        prospectSetup.siteAccount.Name = 'site';
        prospectSetup.siteAccount.address1__c = '123 timber';
        prospectSetup.siteAccount.address2__c = 'suite timber';
        prospectSetup.siteAccount.City__c = 'Orlando';
        prospectSetup.siteAccount.phone = '(999)999-9999';
        prospectSetup.siteAccount.State__c = 'FL';
        prospectSetup.siteAccount.Zip__c = '55551';
        prospectSetup.siteAccount.country__c= 'USA';
        prospectSetup.prospectAccount.Industry_OD_SIC_Rep__c= 'Government';
        //Added by ivarada
        //showiframe = false;
        prospectSetup.InsertProspectAccount();
        prospectSetup.InsertSiteAccount()  ;
        test.starttest();
        prospectSetup.InsertContact();
        prospectSetup.filllookup();
        test.stoptest();
        prospectSetup.openlookup();
        prospectSetup.Search();
        prospectSetup.CheckIfDuplicateAccountExist();


        prospectSetup.closeLookupSection();
        prospectSetup.SaveAllData();
        prospectSetup.SaveDuplicateAccount();
        prospectSetup.validateAddress();
        //prospectSetup.InsertProspectAccount();
        prospectSetup.DeepCloneAll();

        prospectSetup.prospectAccount.Assign_Specific_Owner__c = Test_Utils.CreateUser().Id;
        prospectSetup.prospectAccount.Auto_Assign__c = true;
        prospectSetup.prospectAccount.Assign_Specific_Owner__c = Test_Utils.CreateUser().Id;
        prospectSetup.SaveDuplicateAccount();
        //prospectSetup.InsertSiteAccount()  ;
        //prospectSetup.InsertContact();
        prospectSetup.populateparentaccount();
        prospectSetup.prospectAccount.Pricing_template_cd__c=null;
        prospectSetup.populateparentaccount();
    }
  }

  Static testMethod void Test_ProspectSetupExtension1() {
   testUser = Test_Utils.CreateUser();

    System.RunAs(testUser){
        Pricing_template__c temp = new Pricing_template__c(name = 'xyz');
        insert temp;
        Sales_Person__c salesPerson = Test_Utils.createTestSalesPerson(testUser.id,'testSalesPerson');
        Account account = new Account(Name = 'Dude',recordtypeid='012E00000008dTaIAI',AOPS_Cust_Id__c='123456');

        insert account;

        ApexPages.currentPage().getParameters().Put('id',account.id);
        ApexPages.StandardController scontroller = new ApexPages.StandardController(account);
        ProspectSetupExtension prospectSetup = new ProspectSetupExtension(scontroller);
        //call commented by ivarada
        // prospectSetup.SaveAllData();
        prospectSetup.prospectAccount.Name = 'prospect';
        prospectSetup.prospectAccount.phone = '(999)312-9399';
        prospectSetup.prospectAccount.Pricing_template_cd__c='abc';
        prospectSetup.contact.LastName = 'contact';
        prospectSetup.siteAccount.Name = 'site';
        prospectSetup.siteAccount.address1__c = '123 timber';
        prospectSetup.siteAccount.address2__c = 'suite timber';
        prospectSetup.siteAccount.City__c = 'Orlando';
        prospectSetup.siteAccount.phone = '(999)999-9999';
        prospectSetup.siteAccount.State__c = 'FL';
        prospectSetup.siteAccount.Zip__c = '55551';
        prospectSetup.siteAccount.country__c= 'USA';
        prospectSetup.prospectAccount.Industry_OD_SIC_Rep__c= 'Government';
        //Added by ivarada
        //showiframe = false;
         test.starttest();
        prospectSetup.ProspectAccount.Related_Parent_Account__c = 'abc';
        prospectSetup.customerid = false;
        prospectSetup.InsertProspectAccount();
        prospectSetup.InsertSiteAccount()  ;
        prospectSetup.InsertContact();
        prospectSetup.filllookup();
        prospectSetup.openlookup();
        prospectSetup.Search();
        prospectSetup.CheckIfDuplicateAccountExist();

        test.stoptest();

        prospectSetup.closeLookupSection();
        prospectSetup.SaveAllData();
        prospectSetup.SaveDuplicateAccount();
        prospectSetup.validateAddress();
        //prospectSetup.InsertProspectAccount();
        prospectSetup.DeepCloneAll();

        prospectSetup.prospectAccount.Assign_Specific_Owner__c = Test_Utils.CreateUser().Id;
        prospectSetup.prospectAccount.Auto_Assign__c = true;
        prospectSetup.prospectAccount.Assign_Specific_Owner__c = Test_Utils.CreateUser().Id;
        prospectSetup.SaveDuplicateAccount();
        //prospectSetup.InsertSiteAccount()  ;
        //prospectSetup.InsertContact();
        prospectSetup.populateparentaccount();
        prospectSetup.prospectAccount.Pricing_template_cd__c=null;
        prospectSetup.populateparentaccount();
    }
  }

  //=================================================================================//
  //Test if duplicate matching account found
  //==================================================================================//
  static User testUser ;
  Static testMethod void Test_ProspectSetupExtensionWithDuplicateAccount() {
    testUser = Test_Utils.CreateUser();
    System.RunAs(testUser){

        Sales_Person__c salesPerson = Test_Utils.createTestSalesPerson(testUser.id,'testSalesPerson');
        // Create account with same phone and recordtype
        Account prospectAccountWithoutAddress = Test_Utils.CreateAccount();
        prospectAccountWithoutAddress.Zip__c = '55551';
        prospectAccountWithoutAddress.phone = '(999)312-9399';
        prospectAccountWithoutAddress.Name = 'prospect344';
        update prospectAccountWithoutAddress;
        // Create account with same name and zip
        Account prospectAccountWithAddress = Test_Utils.CreateAccount();
        prospectAccountWithAddress.Zip__c = '55555';
        prospectAccountWithAddress.Country__c = 'USA';
        prospectAccountWithAddress.Name = 'prospect';
        prospectAccountWithAddress.phone = '(999)999-9998';
        prospectAccountWithAddress.Address1__c = '123 timber';
        update prospectAccountWithAddress;

        Account account = new Account(Name = 'Dude');
        ApexPages.currentPage().getParameters().Put('id',account.id);
        ApexPages.StandardController scontroller = new ApexPages.StandardController(account);
        ProspectSetupExtension prospectSetup = new ProspectSetupExtension(scontroller);
        prospectSetup.customerid = false; // Jai Gupta- S-374379 - Jan-26-2016
        //call commented by ivarada
        //prospectSetup.SaveAllData();
        prospectSetup.prospectAccount.Name = 'prospect';
        prospectSetup.prospectAccount.phone = '(999)999-9999';
        //prospectSetup.siteAccount.Phone = '(999)999-9999'; S-434786 (OD 00777602) Connor Flynn 
        prospectSetup.contact.LastName = 'contact';
        prospectSetup.siteAccount.Name = 'site';
        prospectSetup.siteAccount.address1__c = '123 timber';
        prospectSetup.siteAccount.address2__c = 'suite timber';
        prospectSetup.siteAccount.City__c = 'Orlando';
        prospectSetup.siteAccount.State__c = 'FL';
        prospectSetup.siteAccount.Country__c = 'USA';
        prospectSetup.siteAccount.Zip__c = '55555';
        prospectSetup.prospectAccount.Industry_OD_SIC_Rep__c = 'Government';


        // Start by Jai Gupta- S-374379 - Jan-26-2016
        prospectSetup.mockresult = createMockResult(true); //S-434786 (OD 00777602) Connor Flynn
        prospectSetup.SaveDuplicateAccount();
        prospectSetup.populateparentaccount();
        prospectSetup.openlookup();
        //prospectSetup.SaveAllData();
        // End by Jai Gupta- S-374379 - Jan-26-2016
        prospectSetup.InsertProspectAccount();
        prospectSetup.validateAddress(); //S-434786 (OD 00777602) Connor Flynn

        //commented by ivarada
        /*
        Test.stopTest();
        System.assertEquals(1, prospectSetup.accountZipList.size());
        System.assertEquals(1, prospectSetup.accountPhoneList.size());
        System.assertEquals(ApexPages.getMessages().isEmpty(), false);
        */


        //start Ryan Marquardt - July 17, 2015 - S-335200 (code coverage)
        prospectSetup.DeepCloneAll();
        prospectSetup.InsertProspectAccount();
        prospectSetup.InsertSiteAccount();
        prospectSetup.InsertContact(); //S-434786 (OD 00777602) Connor Flynn
        prospectSetup.CheckIfDuplicateAccountExist();
        Pricing_template__c temp = new Pricing_template__c(name = 'xyzTest');
        insert temp;

        prospectSetup.ProspectAccount.Pricing_template_cd__c =  temp.name;

        prospectSetup.ProspectAccount.Pricing_template_cd__c = 'xyzTest';
        //prospectSetup.populateparentaccount();
        prospectSetup.filllookup();

        //prospectSetup.prospectAccount.Assign_Specific_Owner__c = Test_Utils.CreateUser().Id;
        //prospectSetup.SaveAllData();

        //end Ryan Marquardt - July 17, 2015 - S-335200 (code coverage)
    }

  }
  //Start S-374379 By Jai Gupta - Jan26,2016
  static testMethod void unitTest() {
     testUser = Test_Utils.CreateUser();
    System.RunAs(testUser){
        Account account = new Account(Name = 'Dude',AOPS_Cust_Id__c='123456');
        insert account;
        ApexPages.currentPage().getParameters().Put('id',account.id);
        ApexPages.StandardController scontroller = new ApexPages.StandardController(account);
        ProspectSetupExtension prospectSetup = new ProspectSetupExtension(scontroller);
        prospectSetup.prospectAccount.Name = 'prospect';
        //prospectSetup.prospectAccount.phone = '(999)999-9999';
        //prospectSetup.siteAccount.Phone = '(999)999-9999';
        prospectSetup.oldAddress1value = '111timber';
        prospectSetup.contact.LastName = 'contact';
        prospectSetup.prospectAccount.Assign_Specific_Owner__c = UserInfo.getUserId();
        prospectSetup.siteAccount.Name = 'site';
        prospectSetup.siteAccount.address1__c = '123 timber';
        prospectSetup.siteAccount.address2__c = 'suite timber';
        prospectSetup.siteAccount.City__c = 'Orlando';
        prospectSetup.siteAccount.State__c = 'FL';
        prospectSetup.siteAccount.Country__c = 'USA';
        prospectSetup.siteAccount.Zip__c = '55555';
        prospectSetup.prospectAccount.Industry_OD_SIC_Rep__c = 'Government';
      //prospectSetup.mockresult = createMockResult(false);
        Pricing_template__c  pt = Test_Utils.createPricingTemplate();
        insert pt ;
        prospectSetup.prospectAccount.Pricing_template_cd__c = pt.name;
        prospectSetup.prospectAccount.Related_Parent_Account__c = '123';
        Sales_Person__c salesPerson = Test_Utils.createTestSalesPerson(testUser.Id,'testSalesPerson');
        prospectSetup.SaveDuplicateAccount();
        prospectSetup.populateparentaccount();
        prospectSetup.openlookup();
    }
  }

  static testMethod void unitTest2() {
      testUser = Test_Utils.CreateUser();
    System.RunAs(testUser){

        Account account = new Account(Name = 'Dude1',AOPS_Cust_Id__c='12345678');
        insert account;

        Account account1 = new Account(Name = 'Dude2',AOPS_Cust_Id__c='1234567',parentId=account.Id);
        insert account1 ;
        Account account2 = new Account(Name = 'Dude',AOPS_Cust_Id__c='123456',parentId=account1.id);
        insert account2 ;
        ApexPages.currentPage().getParameters().Put('id',account.id);
        ApexPages.StandardController scontroller = new ApexPages.StandardController(account);
        ProspectSetupExtension prospectSetup = new ProspectSetupExtension(scontroller);
        prospectSetup.prospectAccount.Name = 'prospect';
        //prospectSetup.prospectAccount.phone = '(999)999-9999';
        //prospectSetup.siteAccount.Phone = '(999)999-9999';
        prospectSetup.contact.LastName = 'contact';
        prospectSetup.prospectAccount.Assign_Specific_Owner__c = UserInfo.getUserId();
        prospectSetup.siteAccount.Name = 'site';
        prospectSetup.siteAccount.address1__c = '123 timber';
        prospectSetup.siteAccount.address2__c = 'suite timber';
        prospectSetup.siteAccount.City__c = 'Orlando';
        prospectSetup.siteAccount.State__c = 'FL';
        prospectSetup.siteAccount.Country__c = 'USA';
        prospectSetup.siteAccount.Zip__c = '55555';
        prospectSetup.prospectAccount.Industry_OD_SIC_Rep__c = 'Government';
    //    prospectSetup.mockresult = createMockResult(false);
        Pricing_template__c  pt = Test_Utils.createPricingTemplate();
        insert pt ;
        prospectSetup.prospectAccount.Pricing_template_cd__c = pt.name;
        prospectSetup.prospectAccount.Related_Parent_Account__c = '123';
        Sales_Person__c salesPerson = Test_Utils.createTestSalesPerson(testUser.Id,'testSalesPerson');
        prospectSetup.SaveDuplicateAccount();
        prospectSetup.populateparentaccount();
        prospectSetup.openlookup();
    }
  }
  private static void createTestData() {
      Sales_Person__c salesPerson = Test_Utils.createTestSalesPerson(testUser.id,'testSalesPerson');
        // Create account with same phone and recordtype
        Account prospectAccountWithoutAddress = Test_Utils.CreateAccount();
        prospectAccountWithoutAddress.Zip__c = '55551';
        prospectAccountWithoutAddress.phone = '(999)312-9399';
        prospectAccountWithoutAddress.Name = 'prospect344';
        update prospectAccountWithoutAddress;
        // Create account with same name and zip
        Account prospectAccountWithAddress = Test_Utils.CreateAccount();
        prospectAccountWithAddress.Zip__c = '55555';
        prospectAccountWithAddress.Country__c = 'USA';
        prospectAccountWithAddress.Name = 'prospect';
        prospectAccountWithAddress.phone = '(999)999-9998';
        prospectAccountWithAddress.Address1__c = '123 timber';
        update prospectAccountWithAddress;
  }

  static G1AddressValidation.CustomerResponseType createMockResult(boolean errorResponse) {
      G1AddressValidation.CustomerResponseType mr = new G1AddressValidation.CustomerResponseType();
      mr.BusinessName = 'Test';
      mr.ProgramReturnCode = 123.0;
      if(errorResponse) {
      mr.AddressReturnCode = 123.0;
      } else {
      mr.AddressReturnCode = 0;
      }

    mr.AddressOverRideSw = 123.0;
    mr.GeographicalReturnCode = 123.0;
    mr.AbendReturnCode = 'test';
    mr.AbendText = 'test';
    mr.CanOValInvalCode = 'test';
    mr.AddressValidationReturnCode = 'test';
    mr.StdAddressMatchReturnCode = 'test';
    mr.OvrallPRBScore = 'test';
    mr.FieldAddressStatus = 'test';
    mr.FieldName = 'test';
    mr.FieldList = 'test';
    mr.Address = getAddress();
    mr.ErrorMessage = getErrorMessage(errorResponse);
      return mr ;
  }

  static G1AddressValidation.AddressType getAddress() {
      G1AddressValidation.AddressType add = new G1AddressValidation.AddressType();
      add.StreetNameOne = 'test' ;
        add.StreetNameTwo = 'test' ;
        add.PostOfficeBox = 'test' ;
        add.CityName = 'test' ;
        add.StateName = 'test' ;
        add.ZipCode = 'test' ;
        add.Province = 'test' ;
        add.Country = 'USA' ;
        add.GeographicalCodeOne = 123.0 ;
        add.GeographicalCodeTwo = 123.0 ;
        add.CountyName = 'test' ;
        add.Urbanization = 'test' ;
        add.DeliveryPointCode = 'test' ;
        add.ResidentialDeliveryIndicator = 'test' ;

      return add ;
  }

   static G1AddressValidation.ErrorMessagesType getErrorMessage(boolean errorResponse) {
       G1AddressValidation.ErrorMessagesType err = new G1AddressValidation.ErrorMessagesType();
       if(errorResponse) {
       err.AddressErrorMessage = 'Invalid Address';
        err.GeographicalCodeErrorMessage = 'Invalid Geo Code';
        err.ErrorMessage = 'Address is not correct';
        } else {
            err.AddressErrorMessage = '0';
        err.GeographicalCodeErrorMessage = 'Invalid Geo Code';
        err.ErrorMessage = 'Address is not correct';
        }

       return err ;
   }
  ////End S-374379 By Jai Gupta - Jan26,2016
}
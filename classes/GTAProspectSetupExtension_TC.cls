@isTest
private class GTAProspectSetupExtension_TC{
  Static testMethod void GTAProspectSetupExtension_TC() {
    User testUser = Test_Utils.CreateUser();
    Profile p = [select id from profile where name='Standard User'];
        //LSLEVIN 2.10.16 S-376887 Updated be lines employee id to include OD
        User user=new User(alias = 'tester1',OD_Employee_ID__c='xxyyOD0', email='test135@wipro.com',emailencodingkey='UTF-8', lastname='Tester1', languagelocalekey='en_US',localesidkey='en_US', profileid = p.Id, country='United States',timezonesidkey='America/Los_Angeles', username='test157@sample.com');
        insert user;     
    
    System.RunAs(testUser){
        Pricing_template__c temp = new Pricing_template__c(name = 'abc' ,Parent_Id__c = '123456');
        insert temp;
        Sales_Person__c salesPerson = Test_Utils.createTestSalesPerson(testUser.id,'testSalesPerson');      
        Recordtype accRecordtype = [select id from recordtype where name = 'Prospect (GT)'];
        Account account = new Account(Name = 'Dude',recordtypeid=accRecordtype.id ,AOPS_Cust_Id__c='123456');
        insert account;
        ApexPages.currentPage().getParameters().Put('id',account.id);
        ApexPages.StandardController scontroller = new ApexPages.StandardController(account);   
        GTAProspectSetupExtension prospectSetup = new GTAProspectSetupExtension(scontroller);    
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
       // prospectSetup.InsertContact(); 
        prospectSetup.filllookup();
        prospectSetup.openlookup();
        prospectSetup.Search();
        
        prospectSetup.closeLookupSection();
        prospectSetup.SaveAllData();
        prospectSetup.SaveDuplicateAccount();   
       // prospectSetup.validateAddress();    
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
  Static testMethod void Test_ProspectSetupExtensionWithDuplicateAccount() {
    User testUser = Test_Utils.CreateUser();
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
        
        prospectSetup.prospectAccount.Name = 'prospect';
        prospectSetup.prospectAccount.phone = '(999)999-9999';
        prospectSetup.siteAccount.Phone = '(999)999-9999';
        prospectSetup.contact.LastName = 'contact';
        prospectSetup.siteAccount.Name = 'site';
        prospectSetup.siteAccount.address1__c = '123 timber';
        prospectSetup.siteAccount.address2__c = 'suite timber';
        prospectSetup.siteAccount.City__c = 'Orlando';
        prospectSetup.siteAccount.State__c = 'FL';
        prospectSetup.siteAccount.Country__c = 'USA';
        prospectSetup.siteAccount.Zip__c = '55555';    
        prospectSetup.prospectAccount.Industry_OD_SIC_Rep__c = 'Government';
   
   
        prospectSetup.SaveAllData();
        
    }
    }
    
     Static testMethod void Test_ProspectSetupExtensionWithDuplicateAccount1() {
    User testUser = Test_Utils.CreateUser();
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
        
        prospectSetup.prospectAccount.Name = 'prospect';
        prospectSetup.prospectAccount.phone = '(999)999-9999';
        prospectSetup.siteAccount.Phone = '(999)999-9999';
        prospectSetup.contact.LastName = 'contact';
        prospectSetup.siteAccount.Name = 'site';
        prospectSetup.siteAccount.address1__c = '123 timber';
        prospectSetup.siteAccount.address2__c = 'suite timber';
        prospectSetup.siteAccount.City__c = 'Orlando';
        prospectSetup.siteAccount.State__c = 'FL';
        prospectSetup.siteAccount.Country__c = 'USA';
        prospectSetup.siteAccount.Zip__c = '55555';    
        prospectSetup.prospectAccount.Industry_OD_SIC_Rep__c = 'Government';
        prospectSetup.prospectAccount.Pricing_Template_cd__c='Niraj';
   
   
        prospectSetup.SaveAllData();
        
    }
    
  }
}
/*************************************************************
*Name : Test_AccountManagement
*Created By : Akash (Appirio Off)
*Created Date : 26th August,2011
*Purpose : Test Account Management class via the Triggers
****************************************************************/
@isTest
private class Test_AccountManagement {
    

  @isTest
  static void Test_PrimaryOwnerOnAccount() {
  
    Profile p4 = [SELECT Id FROM profile WHERE name='System Administrator'];   
    User u1 = new User(alias = 'test123 ', email='proxy@proxy456.officedepot.com',OD_Employee_ID__c='562412',emailencodingkey='UTF-8', lastname='test123',languagelocalekey='en_US',localesidkey='en_US', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='proxy@proxy456.com',isactive=true);
    insert u1;  
    
    System.runAs(u1)
    {
       Map<String,Sales_Person__c> mpSalesRep= new Map<String,Sales_Person__c>();
      
           Map<Id,Account> mpProspectAccount = new Map<Id,Account>();
        //Assignment_Rule__c assignmentRule = Test_Utils.CreateAssignmentRule();
        Schema.DescribeSObjectResult d1 = Schema.SObjectType.Assignment_Rule__c; 
        Map<String,Schema.RecordTypeInfo> AssRuleRecType = d1.getRecordTypeInfosByName();
        User Usertest = Test_Utils.createTestUser('Tst','112233');
        insert Usertest; 
        User Usertest1 = Test_Utils.createTestUser('Tst22','445533');
        insert Usertest1; 
        Sales_Person__c salesPerson = new Sales_Person__c(ExtIDSalesPerson__c = 'ext12345',primary__c=true,isActive__c=true,User__c = Usertest.id,Name = 'New Sales Person');
        insert salesPerson;
        Sales_Person__c salesPerson1 = new Sales_Person__c(ExtIDSalesPerson__c = 'ext56345',primary__c=true,isActive__c=true,User__c = Usertest1.id,Name = 'New Sales Person1');
        insert salesPerson1;
      mpSalesRep.put('salesPerson', salesPerson);
        Assignment_Rule__c testAssignmentRule = new Assignment_Rule__c();
        //testAssignmentRule.User__c=testUser1.Id;
        testAssignmentRule.Sales_Rep_ID__c='ext12345';
        testAssignmentRule.WCW_Count__c='1to19';
        testAssignmentRule.Zip_Code__c='99999';
        //testAssignmentRule.Emp_ID__c='21344';
        //testAssignmentRule.Industry_Group__c = 'GV';
        testAssignmentRule.Access_ID__c ='test';
        testAssignmentRule.recordtypeid=AssRuleRecType.get('Zip Tracker').getRecordTypeId();
        testAssignmentRule.User__c = u1.id;
        insert testAssignmentRule;
         Assignment_Rule__c testAssignmentRule2 = new Assignment_Rule__c();
        //testAssignmentRule.User__c=testUser1.Id;
        testAssignmentRule2.Sales_Rep_ID__c='ext56345';
        testAssignmentRule2.WCW_Count__c='1to19';
        testAssignmentRule2.Zip_Code__c='12345';
        //testAssignmentRule.Emp_ID__c='21344';
        testAssignmentRule.Industry_Group__c = 'GV';
        testAssignmentRule2.Access_ID__c ='test11';
        testAssignmentRule2.recordtypeid=AssRuleRecType.get('Zip Tracker').getRecordTypeId();
        testAssignmentRule2.User__c = u1.id;
        insert testAssignmentRule2;
        Schema.DescribeSObjectResult d = Schema.SObjectType.Account;
        
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        Schema.RecordTypeInfo rtByName =  rtMapByName.get('Prospect');
        Account account = Test_Utils.GenerateAccount();
        account.RecordTypeId = rtByName.getRecordTypeId();
        account.Auto_Assign__c = true;
        account.zip__c='999999';
        account.aops_cust_id__c='12345677';
        account.Org_WCW_Count_Rep__c=501; 
        account.Legacy_CreatedDate__c = System.Today();
        account.Assign_Specific_Owner__c=null;
        account.Sales_PersonID__c = null;
        insert account; 
        Account account3 = Test_Utils.GenerateAccount();
        account3.RecordTypeId = rtByName.getRecordTypeId();
        account3.Auto_Assign__c = true;
        account3.zip__c='33433';
        account3.aops_cust_id__c='146001';
        account3.Org_WCW_Count_Rep__c=695; 
        account3.Legacy_CreatedDate__c = System.Today();
        account3.Assign_Specific_Owner__c=null;
        account3.Sales_PersonID__c = null;
        insert account3;
        Map<Id,Account> prspctAccnts = new Map<Id,Account> ();
        prspctAccnts.put(account.Id,account);
         prspctAccnts.put(account3.Id,account3);
      contact c = new contact(lastname='testpros1212',accountid=account.id);
         contact c2 = new contact(lastname='wpbdb2',accountid=account3.id);
       
        List<contact> cntclsttobupdtd = new List<contact> ();
         for(Contact contact : [select id,OwnerId,AccountId from Contact where AccountId IN :prspctAccnts.keySet()]) {
      Contact relContact = new Contact(Id = contact.id,OwnerId = mpProspectAccount.get(contact.AccountId).OwnerId);
      cntclsttobupdtd.add(relContact);
    }
        update cntclsttobupdtd;
       
       
            
        AccountManagement.ResetExecution();
        
        Map<String,Schema.RecordTypeInfo> rtMapByName2 = d.getRecordTypeInfosByName();
        Schema.RecordTypeInfo rtByName2 =  rtMapByName2.get('Customer');
        Account account2 = Test_Utils.GenerateAccount();
        account2.RecordTypeId = rtByName2.getRecordTypeId();
        account2.Auto_Assign__c = true;
        account2.zip__c='999999';
        account.aops_cust_id__c='12345678';
        account2.Org_WCW_Count_Rep__c=501; 
        account2.Legacy_CreatedDate__c = System.Today();
        account2.Assign_Specific_Owner__c=null;
        account2.Sales_PersonID__c = null;
        insert account2;  
        
        // Testing PropagateChangesToAccountSetupRequest method
        Account_Setup_Request__c asr = new Account_Setup_Request__c(Account__c=account2.id,AOPS_ID1__c='1234');
        insert asr;
        AccountManagement.ResetExecution();
        account2.name='test2';
        update account2;
        //AccountManagement.PropagateChangesToAccountSetupRequest();
        
        
        AccountManagement.ResetExecution();
        
        Account siteAccount = new Account(Name = 'SiteAccount',Related_Account__c = account.Id,RecordTypeId = rtMapByName.get('Site').getRecordTypeId());
        insert siteAccount;
     
                
        
        //added 2/4/2017 test coverage - updateChildSiteANDContact
        ID rid=[select id from recordtype where name='Site' and sobjecttype='Account' limit 1].ID;
        account amain = new account(name='mainacct',ownerid=userTest.id);
        insert amain;
        contact cmain = new contact(lastname='test',accountid=amain.id);
        account a=new account(recordtypeid=rid,name='test',related_account__c=amain.id,ownerid=userTest.id);
        insert a;
        Map<id,account> amap = new Map<id,account>();
        amap.put(amain.id,a);
        AccountManagement.updateChildSiteANDContact(amap);
        
        AccountManagement.ResetExecution();
        
test.startTest();
AccountManagement.AssignOwner(amain,testAssignmentRule,mpSalesRep,amap);
test.stopTest();        
    }    
  }
    
    //=====================================================================//
    //Test Primary sales person Assignment
    //=====================================================================//
    @isTest
    static void Test_PrimarySalesPersonAssignment() {
        Profile p4 = [SELECT Id FROM profile WHERE name='System Administrator'];   
        User u1 = new User(alias = 'test119', email='proxy@proxy156.officedepot.com',OD_Employee_ID__c='893446',emailencodingkey='UTF-8', lastname='test131',languagelocalekey='en_US',localesidkey='en_US', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='proxy@pxy456.com');
        insert u1;
        System.runAs(u1){ 
            AccountManagement.ResetExecution();
            // Creating salesPerson with passing current user for the User__c field 
            Sales_Person__c salesPerson = Test_Utils.createTestSalesPerson(UserInfo.getUserid(),'testSalesPerson');
            
            Account account = createProspectAccountWithSalesPerson(salesPerson, UserInfo.getUserId());
            // After insert trigger get the account 
            List<Account> lstAccount = [Select sales_personid__c From Account Where id =:account.id];
            // Accounts sales_personid__c field should be populated with the salesPerson.id field.
            //system.assertEquals(lstAccount[0].sales_personid__c, salesPerson.id);   
            
            account.Assign_Specific_Owner__c = Userinfo.getUserId();
            update account;
            
            AccountManagement.ResetExecution();
            //account.Auto_Assign__c = true;
            account.zip__c='12345';
            update account;
        }  
    }
    
    static Account createProspectAccountWithSalesPerson(Sales_Person__c salesPerson, String ownerid){
        
        Account account = Test_Utils.GenerateAccount();
        account.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
        account.Auto_Assign__c = false;
        account.OwnerId = ownerid; // Set the current user as a account owner.    
        insert account;
        return account;
    }
    
    
    //====================================================================//
    //Test the Trigger, which prevents updates to Account of type "Sites"
    //which are attached to a related "Customer" Account
    //====================================================================//
    @isTest
    static void Test_PreventUpdatesToSites() {
        
        Id userID = Test_Utils.CreateUser().Id;
        Id userID1 = Test_Utils.CreateUser().Id;
          Id userID2 = Test_Utils.CreateUser().Id;
        Sales_Person__c testSp = Test_Utils.createTestSalesPersonNew(userID,'921344');
         Sales_Person__c testSp2 = Test_Utils.createTestSalesPersonNew(userID1,'456987');
         Sales_Person__c testSp3 = Test_Utils.createTestSalesPersonNew(userID2,'561419');
        insert testSp;
        insert testSp2;
        insert testSp3;
        
        //Create A customer type Account
        Account relatedCustomerAccount = Test_Utils.GenerateAccount();
        //Populate RecordType for Customer
        Map<String,Schema.RecordTypeInfo> rtMapByName = Schema.SObjectType.Account.getRecordTypeInfosByName();
        list<Account> lstSite = [select id,Duns_Number__c from Account where RecordtypeId = :rtMapByName.get('Site').getRecordTypeId() AND Related_Account__r.RecordTypeId = :rtMapByName.get('Customer').getRecordTypeId() limit 1];
        if(lstSite.size() > 0) {      
            lstSite[0].Duns_Number__c = '9876';
            update lstSite[0];
        }
        
        relatedCustomerAccount.RecordTypeID = rtMapByName.get('Customer').getRecordTypeId();
        relatedCustomerAccount.OwnerId = userID1; 
        relatedCustomerAccount.Sales_PersonID__c = testSp.Id;
        insert relatedCustomerAccount ;
        
       // AccountManagement.ResetExecution();
        //Generate Site Account and set the RecordType as Site, Related Account to Parent  
        Account siteAccount = Test_Utils.GenerateAccount();
        siteAccount.RecordTypeId = rtMapByName.get('Site').getRecordTypeId();
        siteAccount.Related_Account__c = relatedCustomerAccount.ID;
        siteAccount.OwnerId = UserID;
        siteAccount.Sales_PersonId__c = testSp.Id;
        siteAccount.AOPS_Seq_ID__c = '15487487-00001';
        siteAccount.Primary_Site__c = true;
        try {
            insert siteAccount; //error should be thrown related to proper setup procedures.
            /*
            List<account> accntlstinsrtd = [Select Id, OwnerId, Sales_PersonID__c, Related_Account__c, Related_Account__r.OwnerId,
                                            Related_Account__r.Sales_PersonID__c from Account where Id =: siteAccount.ID];
            List<account> accntlsttobupdtd = new List<account> ();
            for(Account a:accntlstinsrtd) {
                if(a.Related_Account__c !=null) {
                    a.Related_Account__r.OwnerId= userID1;
                    a.Related_Account__r.Sales_PersonID__c = testSp.Id;
                    accntlsttobupdtd.add(a);
                }
            }
*/
           
            siteAccount.OwnerId = userID2;
            siteAccount.AOPS_Cust_Id__c = '154874872';
             test.startTest();
          //  AccountManagement.PropagateChangesToAccountSetupRequest();
            test.stopTest();
            System.assertEquals(siteAccount.AOPS_Seq_ID__c,'15487487-00001' );
            update siteAccount;
        }
        catch(DmlException ex) {
            System.debug('=====Error=====' + ex);
            System.assert(ex.getmessage().contains('You cannot edit core fields on a site record that is related to a customer account'));
        }
        
    }
    
    //====================================================================//
    //Test Cases Javelin Rules
    //====================================================================//
    @isTest
    static void Test_Javelin_Rules() {
        
        User testUser = Test_Utils.createTestUser('Tst','112233');
        insert testUser;
        
        User testUser1 = Test_Utils.createTestUser('Tst22','012233');
        insert testUser1;
        
        System.debug(':::Test User id ::'+testUser.id);
        System.debug(':::Test User1 id ::'+testUser1.id);
        
        System.RunAs(testUser){
            Account account = new Account(Name = 'NewAcc');
            
            Test.setCurrentPageReference(new PageReference('Page.ProspectSetup'));
            ApexPages.StandardController scontroller = new ApexPages.StandardController(account);   
            ProspectSetupExtension prospectSetup = new ProspectSetupExtension(scontroller);    
            //prospectSetup.SaveAllData();
            
            prospectSetup.prospectAccount.Name = 'sdsfsprospect1';
            
            prospectSetup.contact.LastName = 'contact';
            
            prospectSetup.siteAccount.Name = 'sdffsite';
            prospectSetup.siteAccount.address1__c = '123 timber';
            prospectSetup.siteAccount.address2__c = 'suite timber';
            prospectSetup.siteAccount.City__c = 'Orlando';
            prospectSetup.siteAccount.State__c = 'FL';
            prospectSetup.siteAccount.State__c = '434-342-2232';
            prospectSetup.prospectAccount.Industry_OD_SIC_Rep__c= 'Government';
            prospectSetup.prospectAccount.Zip__c = '55545';
            prospectSetup.prospectAccount.phone = '333-333-1243';
            
            try{
                prospectSetup.SaveAllData();
                //String vMessage = String.valueOf(ApexPages.getMessages().get(0));
                //System.assert(vMessage.contains('The person creating does not have valid Sales Rep ID - Please reassign to someone else or choose "Auto-Assign"'));
                System.debug('11 Inserted Account Id :::'+prospectSetup.prospectAccount.id);
            }catch(Exception ex){
                
            }
            
            try{
                prospectSetup.prospectAccount.Assign_Specific_Owner__c = Test_Utils.CreateUser().Id; 
                prospectSetup.prospectAccount.Auto_Assign__c = true; 
                prospectSetup.SaveAllData();
                //String validationMessage = String.valueOf(ApexPages.getMessages().get(1));
                //System.assert(validationMessage.contains('Please choose only Auto Assign or Assign Specific Owner'));
                System.debug('22 Inserted Account Id :::'+prospectSetup.prospectAccount.id);
                //System.assertEquals(null,prospectSetup.prospectAccount.id);
            }catch(Exception ex){
                
            }
            
            
            
            try{
                prospectSetup.prospectAccount.Auto_Assign__c = false;
                prospectSetup.SaveAllData();
            }catch(Exception ex){
                
            }
            
            
            System.debug('::: Messages 11::'+ApexPages.getMessages());
            System.debug('33 Owner Id Inserted Account Id :::'+prospectSetup.prospectAccount.OwnerId);
            
            try{
                prospectSetup.prospectAccount.Assign_Specific_Owner__c = testUser1.Id;    
                prospectSetup.prospectAccount.Auto_Assign__c = false;
                prospectSetup.SaveAllData();
            }catch(Exception ex){
                
            }
            
            //String validationMessage = String.valueOf(ApexPages.getMessages().get(2));
            //System.assert(validationMessage.contains('An active and primary matching Sales Person record could not be found for the selected User'));
            
            Sales_Person__c testSp = Test_Utils.createTestSalesPersonNew(testUser1.Id,'921344');
            insert testSp;
            
            try{
                prospectSetup.SaveAllData();
                //  System.assertEquals(prospectSetup.prospectAccount.OwnerId,testUser1.Id);
                // System.assertEquals(prospectSetup.prospectAccount.Sales_PersonID__c, testSp.id);
            }catch(Exception ex){
                
            }
            
            
            ProspectSetupExtension prospectSetup1 = new ProspectSetupExtension(scontroller);    
            prospectSetup1.prospectAccount.Name = 'prospect2jg';
            prospectSetup1.contact.LastName = 'contact2';
            prospectSetup1.siteAccount.Name = 'site2';
            prospectSetup1.siteAccount.address1__c = '123 timber';
            prospectSetup1.siteAccount.address2__c = 'suite timber';
            prospectSetup1.siteAccount.City__c = 'Orlando';
            prospectSetup1.siteAccount.State__c = 'FL';
            prospectSetup1.siteAccount.zip__C = '12445';
            
            prospectSetup1.prospectAccount.Industry_OD_SIC_Rep__c= 'Government';
            
            try{
                prospectSetup1.prospectAccount.Assign_Specific_Owner__c = null;   
                prospectSetup1.prospectAccount.Auto_Assign__c = true;
                //prospectSetup1.SaveAllData();
                //System.assertNotEquals(prospectSetup1.prospectAccount.OwnerId,testUser1.Id);
                //System.assertNotEquals(null, testSp.id);
            }catch(Exception ex){
                
            } 
            
            System.debug('::: Messages >>::'+ApexPages.getMessages());
            System.debug('Owner Id Inserted Account Id>> :::'+prospectSetup1.prospectAccount.OwnerId+':::TestUser1 Id ::'+testUser1.Id);
            System.debug('::Sales Person Id of Account is >>::'+prospectSetup1.prospectAccount.Sales_PersonID__c+'::: testSpId :::'+testSp.id);
            
        }   
    }
    
    
    //====================================================================//
    //To test accountSetupRequest populated field (AOPS_ID1__c)
    //====================================================================//
    @isTest
    static void TestAccountSetupRequestPopulatedField(){
        Account prospectAccount = Test_Utils.CreateAccount();
        Account_setup_request__c accountSetupRequest = Test_Utils.createAccountSetupReq(prospectAccount);
        insert accountSetupRequest; 
        
        prospectAccount.AOPS_Cust_Id__c = 'TestAOPS';  
        update prospectAccount;
        
        Test.startTest();
        Account_setup_request__c accountSetupRequest1 = [Select account__c, AOPS_ID1__c FROM Account_setup_request__c 
                                                         WHERE account__c = :prospectAccount.Id];
        //System.assertEquals(accountSetupRequest1.AOPS_ID1__c , prospectAccount.AOPS_Cust_Id__c); 
        Test.stopTest();                                                        
        
    }
    //Added by Najma Ateeq for Story #S-414431
    @isTest
    static void TestAssignmentForInActiveUser() {
        
        
        Profile p4 = [SELECT Id FROM profile WHERE name='System Administrator'];   
        User u = new User(alias = 'test1234 ', email='proxy@proxy45656.officedepot.com',OD_Employee_ID__c='5624121',emailencodingkey='UTF-8', lastname='test123',languagelocalekey='en_US',localesidkey='en_US', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='proxy@proxy4564.com',isactive=true);
        insert u;  
        User u1 = new User(alias = 'test123 ', email='proxy@proxy456.officedepot.com',OD_Employee_ID__c='562412',emailencodingkey='UTF-8', lastname='test123',languagelocalekey='en_US',localesidkey='en_US', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='proxy@proxy456.com',isactive=false);
        u1.ManagerId = u.Id;
        insert u1;  
        System.runAs(u)
        {    
            
            //Assignment_Rule__c assignmentRule = Test_Utils.CreateAssignmentRule();
            Schema.DescribeSObjectResult d1 = Schema.SObjectType.Assignment_Rule__c; 
            Map<String,Schema.RecordTypeInfo> AssRuleRecType = d1.getRecordTypeInfosByName();
            User Usertest = Test_Utils.createTestUser('Tst','112233');
            insert Usertest; 
            
            Sales_Person__c salesPerson = new Sales_Person__c(ExtIDSalesPerson__c = 'ext12345',primary__c=true,isActive__c=true,User__c = u1.id,Name = 'New Sales Person');
            insert salesPerson;
            Sales_Person__c salesPersonM = new Sales_Person__c(ExtIDSalesPerson__c = 'ext12345H',primary__c=true,isActive__c=true,User__c = u.id,Name = 'New Sales Person');
            insert salesPersonM;
            
            Assignment_Rule__c testAssignmentRule = new Assignment_Rule__c();
            //testAssignmentRule.User__c=testUser1.Id;
            testAssignmentRule.Sales_Rep_ID__c='ext12345';
            testAssignmentRule.WCW_Count__c='1to19';
            testAssignmentRule.Zip_Code__c='99999';
            //testAssignmentRule.Emp_ID__c='21344';
            //testAssignmentRule.Industry_Group__c = 'GV';
            testAssignmentRule.Access_ID__c ='test';
            testAssignmentRule.recordtypeid=AssRuleRecType.get('Zip Tracker').getRecordTypeId();
            testAssignmentRule.User__c = u1.id;
            insert testAssignmentRule;
            Schema.DescribeSObjectResult d = Schema.SObjectType.Account;
            
            Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
            Schema.RecordTypeInfo rtByName =  rtMapByName.get('Prospect');
            Account account = Test_Utils.GenerateAccount();
            account.RecordTypeId = rtByName.getRecordTypeId();
            account.Auto_Assign__c = true;//add false in starting
            account.zip__c='99999';
            account.Org_WCW_Count_Rep__c=300; 
            account.Assign_Specific_Owner__c = null;
            insert account;   
            
            
            
            Account siteAccount = new Account(Name = 'SiteAccount',Related_Account__c = account.Id,RecordTypeId = rtMapByName.get('Site').getRecordTypeId());
            insert siteAccount;
            
            AccountManagement.ResetExecution();
            account.Auto_Assign__c = true;
            account.zip__c = '999995';
            account.Assign_Specific_Owner__c = null;
            update account;
            
            account = [Select Id,OwnerId from Account where Id=: account.Id];
            //system.assertEquals(account.OwnerId,u.Id);
        }
    }
    //End - Added by Najma Ateeq for Story #S-414431
   
    
    @isTest
    public static void test1() {
        
        sales_person__c  SP=New sales_person__c();
        SP.Name='Test Sales Person';
        SP.User__c=userinfo.getuserid();
        Insert SP;
        
        DNBI_Credentials__c dnbi = new DNBI_Credentials__c(Name = 'Test123',DnB_Active__c=true);
         insert dnbi;
        
              
              
       account acc = [select id,Disposition__c from account limit 1];
            acc.Disposition__c='test1as';
        update acc;
                    //Insert acc1;
        
              
                
        
    }
    @isTest
     static void myUnitTest() 
    {
        Sales_Person__c salesPerson = new Sales_Person__c();
        salesPerson.Role_Relate_Id__c='14875236';
        insert salesPerson ;
        
        user u2=[SELECT id,ProfileId,OD_Employee_ID__c,TimeZoneSidKey FROM USER WHERE id =:UserInfo.getUserId()];
        user u = new user(email='abc.xyz@officedepot.com',Username='jasmet@acme.com',FirstName ='test123', LastName='xyz123', Alias='a', CommunityNickname='aa', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', ProfileId=u2.ProfileId, LanguageLocaleKey='en_US');
        //LSLEVIN 2.10.16 S-376887 Updated line below from '000000'
        u.OD_Employee_ID__c = 'xxyyOD0000';
        u.isActive = true;
        insert u ;
        
        Account acc = new Account ();
        acc.name = 'SUN Test Account';
        acc.BillingStreet = '1040 N 326 W';
        acc.billingcity = 'Orem';
        acc.BillingState = 'UT';
        acc.Billingcountry = 'USA';
        acc.Oracle_Party_Id__c = '123456';
        acc.AOPS_Cust_Id__c = '123456';
        acc.AOPS_Seq_ID__c = '123456';
        acc.OwnerID = '005E0000000lNbV';// This is the salesforce User ID
        acc.Sales_PersonID__c = 'a0AE0000000GGMn'; //Sales person Id for the Salesforce USer
        insert acc;
        
        Account accSite = new Account ();
        accSite.name = 'SUN Test Account';
        accSite.BillingStreet = '1040 N 326 W';
        accSite.billingcity = 'Orem';
        accSite.BillingState = 'UT';
        accSite.Billingcountry = 'USA';
        accSite.Oracle_Party_Site_Id__c = '12345678';
        accSite.AOPS_Cust_Id__c = '12345678';
        accSite.AOPS_Seq_ID__c = '12345678-00001';
        insert accSite;

        AccountAssignments__c assign1 = new AccountAssignments__c();
        assign1.AccountId__c = '123456';
        assign1.AccountType__c = 'A';
        assign1.Entity_Type__c = 'CUSTOMER';
        assign1.Entity_Id__c = '123456';
        assign1.PrimaryEmpId__c = '000000';
        assign1.PrimaryEmpRole__c = '000000';
        assign1.OverlayEmpID1__c = '179556';
        assign1.OverlayEmpRole1__c = '11111';
        assign1.OverlayEmpID2__c = '595673';
        assign1.OverlayEmpRole2__c = '22222';
        assign1.OverlayEmpID3__c = '601832';
        assign1.OverlayEmpRole3__c = '333333';
        assign1.OverlayEmpID4__c = '234567';
        assign1.OverlayEmpRole4__c = '44444';
        assign1.OverlayEmpID5__c = '234567';
        assign1.OverlayEmpRole5__c = '44444';
        assign1.OverlayEmpID6__c = '234567';
        assign1.OverlayEmpRole6__c = '44444';
        assign1.OverlayEmpID7__c = '234567';
        assign1.OverlayEmpRole7__c = '44444';
        assign1.OverlayEmpID8__c = '234567';
        assign1.OverlayEmpRole8__c = '44444';
        assign1.OverlayEmpID9__c = '234567';
        assign1.OverlayEmpRole9__c = '44444';
        assign1.OverlayEmpID10__c = '234567';
        assign1.OverlayEmpRole10__c = '44444';
        assign1.OverlayEmpID11__c = '234567';
        assign1.OverlayEmpRole11__c = '44444';
        assign1.OverlayEmpID12__c = '234567';
        assign1.OverlayEmpRole12__c = '44444';
        assign1.OverlayEmpID13__c = '234567';
        assign1.OverlayEmpRole13__c = '44444';
        assign1.OverlayEmpID14__c = '234567';
        assign1.OverlayEmpRole14__c = '44444';
        assign1.OverlayEmpID15__c = '234567';
        assign1.OverlayEmpRole15__c = '44444';
        
        assign1.OverlayEmpID16__c = '179556';
        assign1.OverlayEmpRole16__c = '11111';
        assign1.OverlayEmpID17__c = '595673';
        assign1.OverlayEmpRole17__c = '22222';
        assign1.OverlayEmpID18__c = '601832';
        assign1.OverlayEmpRole18__c = '333333';
        assign1.OverlayEmpID19__c = '234567';
        assign1.OverlayEmpRole19__c = '44444';
        assign1.OverlayEmpID20__c = '234567';
        assign1.OverlayEmpRole20__c = '44444';
        assign1.OverlayEmpID21__c = '234567';
        assign1.OverlayEmpRole21__c = '44444';
        assign1.OverlayEmpID22__c = '234567';
        assign1.OverlayEmpRole22__c = '44444';
        assign1.OverlayEmpID23__c = '234567';
        assign1.OverlayEmpRole23__c = '44444';
        assign1.OverlayEmpID24__c = '234567';
        assign1.OverlayEmpRole24__c = '44444';
        assign1.OverlayEmpID25__c = '234567';
        assign1.OverlayEmpRole25__c = '44444';
        assign1.OverlayEmpID26__c = '234567';
        assign1.OverlayEmpRole26__c = '44444';
        assign1.OverlayEmpID27__c = '234567';
        assign1.OverlayEmpRole27__c = '44444';
        assign1.OverlayEmpID28__c = '234567';
        assign1.OverlayEmpRole28__c = '44444';
        assign1.OverlayEmpID29__c = '234567';
        assign1.OverlayEmpRole29__c = '44444';
        assign1.OverlayEmpID30__c = '234567';
        assign1.OverlayEmpRole30__c = '44444';
        assign1.Status__c = 'open';
        
        insert assign1;

        AccountAssignments__c assign2 = new AccountAssignments__c();
        assign2.AccountId__c = '12345678';
        assign2.AccountType__c = 'S';
        assign2.Entity_Type__c = 'CUSTOMER';
        assign2.Entity_Id__c = '12345678';
        assign2.PrimaryEmpId__c = '000000';
        assign2.PrimaryEmpRole__c = '000000';
        assign2.OverlayEmpID1__c = '104344';
        assign2.OverlayEmpRole1__c = '111111';
        assign2.OverlayEmpID2__c = '595673';
        assign2.OverlayEmpRole2__c = '222222';
        assign2.OverlayEmpID3__c = '600980';
        assign2.OverlayEmpRole3__c = '333333';
        assign2.OverlayEmpID4__c = '';
        assign2.OverlayEmpRole4__c = '';
        assign2.Status__c = 'open';
        
       insert assign2;        
   
        AccountAssignments__c assign3 = new AccountAssignments__c();
        assign3.AccountId__c = '1234567890';
        assign3.AccountType__c = 'S';
        assign3.Entity_Type__c = 'PROSPECT';
        assign3.Entity_Id__c = '1234567890';
        assign3.PrimaryEmpId__c = '000000';
        assign3.PrimaryEmpRole__c = '000000';
        assign3.OverlayEmpID1__c = '104344';
        assign3.OverlayEmpRole1__c = '111111';        
        insert assign3; 
        Set<Id> assignmentIds = new Set<Id>();
        AssignmentIds.add(assign1.Id);
        AssignmentIds.add(assign3.Id);
        AssignmentIds.add(assign2.Id);
        Test.startTest();
        AccountPrimaryOwnerUpdate apou =new AccountPrimaryOwnerUpdate();
        apou.UpdatePrimary(assignmentIds);
        
        
        }
        @isTest
    public static void testSetup1(){
         RecordType rr = [select id from recordtype where sobjecttype='Account' and developername='Prospect'];
              Account acc = new Account();
              acc.name='test1';
              acc.recordtypeId=rr.id;
      acc.Oracle_Party_ID__c='03269745122';
        /*acc.Duns_Enrichment__c='asdaxz';
        acc.DNBI_CREDIT_OUTCOME__c='mzlkas';
       */
            Insert acc;
        
    }
    
    @isTest
    public static void test() {
        
        RecordType rpros = [select id from recordtype where sobjecttype='Account' and developername='Prospect'];
        sales_person__c  SP=New sales_person__c();
        SP.Name='Test Sales Person';
        SP.User__c=userinfo.getuserid();
        Insert SP;
        
        DNBI_Credentials__c dnbi = new DNBI_Credentials__c(Name = 'Test123',DnB_Active__c=true);
         insert dnbi;
        Account acct = Test_Utils.CreateAccount('Customer');
        acct.recordtypeid=rpros.id;
        acct.oracle_party_id__c='7103698412299';
        executeoncetest.DNBItrigger = true;
        insert acct;
        
        
       
        
        executeoncetest.DNBItrigger = true;
        update acct;
        
        RecordType r = [select id from recordtype where sobjecttype='Account' and developername='GrandParent'];
        RecordType r2 = [select id from recordtype where sobjecttype='Account' and developername='Site'];
        Account accgp = new Account();
              accgp.name='testGP';
              accgp.recordtypeId=r.id;
              accgp.description='old desc';
              accgp.aops_cust_id__c='754123698';
              accgp.status__c='Active';
              accgp.Sales_PersonID__c=SP.id;              
              insert accgp;
              
              accgp.description='new desc';
              accgp.status__c='Inactive';
              accgp.implementation_manager__c=userinfo.getuserid();
              update accgp;
              
              
        
              Account accgp3 = new Account();
              accgp3.name='testGP3';
              accgp3.recordtypeId=r2.id;
              accgp3.description='old desc';
              accgp3.Primary_Site__c=true;
              insert accgp3;
       
       
            
        
    }
    /*
    @isTest
    public static void test2() {
        
        sales_person__c  SP=New sales_person__c();
        SP.Name='Test Sales Person';
        SP.User__c=userinfo.getuserid();
        Insert SP;
        
        DNBI_Credentials__c dnbi = new DNBI_Credentials__c(Name = 'Test123',DnB_Active__c=true);
         insert dnbi;
        
              
              
       account acc = [select id,Disposition__c from account limit 1];
          acc.Disposition__c='test1as';
        update acc;
                    //Insert acc1;
        
              
            
        
    }
    */
}
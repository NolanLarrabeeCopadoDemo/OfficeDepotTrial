/*************************************************************
*Name            : Test_Lead_Management
*Created By      : Virendra (Appirio Off)
*Created Date    : 9th Nov,2011
*Purpose         : Test Lead_RoutingTo_ProperOwner class via the Triggers
*Modified        : 
                 : 11.16.15    NSHARP   S-364612
****************************************************************/
@isTest
private class Test_Lead_Management {  
  
  @isTest
  private static void Test_UpdateLeadOwnerAsAutoAssignFalse() {    
    
    //User testUser = [select id, name from user where name = 'Jen Bryant' limit 1];
    /*UserRole InsideSaleRole = [SELECT Id from UserRole WHERE Name = 'Inside Sales' limit 1];
    User testUser = [SELECT Id, Name FROM User WHERE UserRoleId = :InsideSaleRole.Id AND isActive = true limit 1];*/
    
    User testUser = Test_Utils.CreateUser();       
    
    User testUser1 = Test_Utils.createTestUser('Tst22','223344');
    insert testUser1;
    System.RunAs(testUser){      
     Sales_Person__c testSp = Test_Utils.createTestSalesPersonNew(testUser1.Id,'21344');
       insert testSp;
    
    Store__c testStore = new Store__c();
    //testStore.CPD_Sales_Rep__c = testUser1.Id;
    testStore.ID__c='98765';
    insert testStore;
  
    
       //Lead testLead = Test_Utils.CreateLeadForUser( testStore); 
       
    Lead testLead = new Lead();
    testLead.Company = 'testComp';
    testLead.Status = 'Open';
    testLead.amount__c = 25.00;
    testLead.LastName = 'LName1';
    testLead.Auto_Assign__c = true;
    testLead.zip__c = '12348';
    testLead.Store__c = testStore.Id;
    //START NSHARP S-364612 11.16.15
    //testLead.product__c = 'CPD-Promo';
    //END NSHARP S-364612 11.16.15
    testLead.Industry = null;
    testLead.WCW_Count__c = 771;
    testLead.storewebid__c='98765';
    testLead.User__c=testUser1.id;
    
    insert testLead;
               
       Test.startTest();       
       Lead tlead = [Select id, OwnerId from lead where id = :testLead.id];     // Get the id of inserted Lead
       // Get Store__c for inserted Lead
       Store__c leadStores = [Select ID__c
       //, CPD_Sales_Rep__c 
       From Store__c where 
       //CPD_Sales_Rep__c <> null and
        id  = :testLead.Store__c];
       // Verify that lead has some data
       if(leadStores != null) {
         // Test that inserted lead OwnerId is equals to store CPD_Sales_Rep__c value
         System.debug('::tlead.OwnerId::'+tlead.OwnerId+'::leadStores.CPD_Sales_Rep__c::'
         //+leadStores.CPD_Sales_Rep__c
         );
         //System.assertEquals(tlead.OwnerId, leadStores.CPD_Sales_Rep__c);
       }  
       Test.stopTest();
    }
  }
  
  @isTest
  private static void Test_UpdateLeadOwnerAsAutoAssign() {
   
    //User testUser = [select id, name from user where name = 'Jen Bryant' limit 1];
    UserRole InsideSaleRole = [SELECT Id from UserRole WHERE Name = 'Inside Sales' limit 1];
    User testUser = [SELECT Id, Name FROM User WHERE UserRoleId = :InsideSaleRole.Id AND isActive = true limit 1];       
    Schema.DescribeSObjectResult d1 = Schema.SObjectType.Assignment_Rule__c; 
    Map<String,Schema.RecordTypeInfo> AssRuleRecType = d1.getRecordTypeInfosByName(); 
    
    /*User testUser = Test_Utils.createTestUser('Tst','21344');
    insert testUser;*/
    //User testUser = Test_Utils.CreateUser();
    
    User testUser1 = Test_Utils.createTestUser('Tst22','223344');
    insert testUser1;
    System.RunAs(testUser){
       Sales_Person__c testSp = Test_Utils.createTestSalesPersonNew(testUser1.Id,'21344');
       insert testSp;
       
       // String usrId,String SalesRepIdc,String wcwCount,String zipCode
       //Assignment_Rule__c testAssignmentRule = Test_Utils.createTestAssignmentRule(testUser1.Id,'21344','500','12345666');     
       
        
       Assignment_Rule__c testAssignmentRule = new Assignment_Rule__c();
       testAssignmentRule.User__c=testUser1.Id;
       testAssignmentRule.Sales_Rep_ID__c='21344';
       testAssignmentRule.WCW_Count__c='500to999999';
       testAssignmentRule.Zip_Code__c='12345';
       testAssignmentRule.Emp_ID__c='21344';
       //testAssignmentRule.Industry_Group__c = 'GV';
       testAssignmentRule.Access_ID__c ='test';
       testAssignmentRule.recordtypeid=AssRuleRecType.get('Zip Tracker').getRecordTypeId();
       insert testAssignmentRule;
       
       
       // Creating lead with different parameters
       List<Lead> insertLeads = new List<Lead>();       
       Lead testLead = Test_Utils.GenerateLead('12345', 500, null, 'LName1', false);      
       insertLeads.add(testLead); 
       Lead testLead1 = Test_Utils.GenerateLead('12345', 500, null, 'LName2', true);       
       insertLeads.add(testLead1);       
       Lead testLead2 = Test_Utils.GenerateLead('12345', 500, 'Government', 'LName3', true);       
       insertLeads.add(testLead2);
       Lead testLead3 = Test_Utils.GenerateLead('12346', 100, null, 'LName3', true);     
       insertLeads.add(testLead3);        
       
       //This lead should be assigned to the default owner
       Lead testLead4 = Test_Utils.GenerateLead('xxxxxx', 100, null, 'LName3', true);     
       insertLeads.add(testLead4);  
       insert insertLeads;  
           
       Lead tlead = [Select id, OwnerId from lead where id = :testLead.id];       
       Test.startTest();
         
       List<Sales_Person__c> salespers = [ SELECT Id, User__c,ExtIDSalesPerson__c FROM Sales_Person__c WHERE Primary__c = true AND IsActive__c = true
                                            AND User__c = :tlead.OwnerID];
               
       List<Lead> tLeads = [Select id, Auto_Assign__c, Sales_Person_ID__c, OwnerId from lead where id in :insertLeads];
       
       //Test that Auto-Assign > route according to assignment rules 
       System.assertEquals(tLeads[0].Auto_Assign__c, false);
       //System.assertEquals(tLeads[1].Auto_Assign__c, false);       
       //System.assertEquals(tLeads[4].Auto_Assign__c, false);
       // Test that sales person id being set properly
       //System.assertEquals(tLeads[0].Sales_Person_ID__c, salespers[0].Id);
       // Test that owner id being set properly
      // System.assertEquals(tLeads[0].OwnerId,testUser.Id);
           
       Test.stopTest();
    }
  }
  
  //START S-309659 [Hemant 5/13/2015]
  //Method to test AssignTimeZone in LeadBeforeTrigger
  @isTest
  private static void Test_AssignTimeZoneOnLead() {   
        User testUser1 = Test_Utils.createTestUser('Tst22','223344');
        insert testUser1;
      system.runas(testUser1){

    //insert Location_Assignment__c data
    List<Location_Assignment__c> locAssignLst = new List<Location_Assignment__c>();
    Location_Assignment__c locAssignPacific = new Location_Assignment__c(Name = '94525',Time_Zone__c = 'Samoa');
    locAssignLst.add(locAssignPacific);
    Location_Assignment__c locAssignEastern = new Location_Assignment__c(Name = '94526',Time_Zone__c = 'Atlantic');
    locAssignLst.add(locAssignEastern);
    insert locAssignLst;
    
    List<Lead> insertLeads = new List<Lead>();
    Lead testLeadPacific = Test_Utils.GenerateLead('94525', 500, null, 'LName1', false);
    testLeadPacific.LeadSource = 'BSD NET';
    insertLeads.add(testLeadPacific);
    
    Lead testLeadEastern = Test_Utils.GenerateLead('94526', 500, null, 'LName2', true);
    testLeadEastern.LeadSource = 'BSD NET';
    insertLeads.add(testLeadEastern);       
    
    insert insertLeads;
    
    List<Lead> tLeads = [Select id, Time_Zone__c from lead where id in :insertLeads];
    System.assertEquals(tLeads[0].Time_Zone__c,'Pacific');
    System.assertEquals(tLeads[1].Time_Zone__c,'Eastern'); 
  }
  }
  //END S-309659 

  //START NSHARP S-364612 11.16.15
  @isTest
  private static void test_LeadTimeZone_Eastern(){
        Queue_Zones__c q1 = new Queue_Zones__c(Name='Central Time Zone');
        insert q1;
        Queue_Zones__c q2 = new Queue_Zones__c(Name='Eastern Time Zone');
        insert q2;
        Queue_Zones__c q3 = new Queue_Zones__c(Name='Government Leads');
        insert q3;
        Queue_Zones__c q4 = new Queue_Zones__c(Name='Mountain Time Zone');
        insert q4;
        Queue_Zones__c q5 = new Queue_Zones__c(Name='Pacific Time Zone');
        insert q5;
        
        User testUser1 = Test_Utils.createTestUser('Tst22','223344');
        insert testUser1;
      system.runas(testUser1){
        Store__c testStore = new Store__c();
        testStore.ID__c='98765';
        insert testStore;

        Lead testLead = new Lead();
        testLead.Company = 'testComp';
        testLead.Status = 'Open';
        testLead.amount__c = 25.00;
        testLead.LastName = 'LName1';
        testLead.Auto_Assign__c = true;
        testLead.zip__c = '12345';
        testLead.Store__c = testStore.Id;
        testLead.Industry = null;
        testLead.WCW_Count__c = 120;
        testLead.storewebid__c='98765';
        testLead.User__c=testUser1.id;
        testLead.Time_Zone__c = 'Eastern';
    
    insert testLead;
    system.assertEquals('Eastern',testLead.Time_Zone__c);
  }
  }
  //END NSHARP S-364612 11.16.15

  //START NSHARP S-364612 11.16.15
  @isTest
  private static void test_LeadTimeZone_Central(){
        Queue_Zones__c q1 = new Queue_Zones__c(Name='Central Time Zone');
        insert q1;
        Queue_Zones__c q2 = new Queue_Zones__c(Name='Eastern Time Zone');
        insert q2;
        Queue_Zones__c q3 = new Queue_Zones__c(Name='Government Leads');
        insert q3;
        Queue_Zones__c q4 = new Queue_Zones__c(Name='Mountain Time Zone');
        insert q4;
        Queue_Zones__c q5 = new Queue_Zones__c(Name='Pacific Time Zone');
        insert q5;
        
        User testUser1 = Test_Utils.createTestUser('Tst22','223344');
        insert testUser1;
      system.runas(testUser1){
        Store__c testStore = new Store__c();
        testStore.ID__c='98765';
        insert testStore;

        Lead testLead = new Lead();
        testLead.Company = 'testComp';
        testLead.Status = 'Open';
        testLead.amount__c = 25.00;
        testLead.LastName = 'LName1';
        testLead.Auto_Assign__c = true;
        testLead.zip__c = '12345';
        testLead.Store__c = testStore.Id;
        testLead.Industry = null;
        testLead.WCW_Count__c = 120;
        testLead.storewebid__c='98765';
        testLead.User__c=testUser1.id;
        testLead.Time_Zone__c = 'Central';
    
    insert testLead;
    system.assertEquals('Central',testLead.Time_Zone__c);
  }
  }
  //END NSHARP S-364612 11.16.15

  //START NSHARP S-364612 11.16.15
  @isTest
  private static void test_LeadTimeZone_Mountain(){
        Queue_Zones__c q1 = new Queue_Zones__c(Name='Central Time Zone');
        insert q1;
        Queue_Zones__c q2 = new Queue_Zones__c(Name='Eastern Time Zone');
        insert q2;
        Queue_Zones__c q3 = new Queue_Zones__c(Name='Government Leads');
        insert q3;
        Queue_Zones__c q4 = new Queue_Zones__c(Name='Mountain Time Zone');
        insert q4;
        Queue_Zones__c q5 = new Queue_Zones__c(Name='Pacific Time Zone');
        insert q5;
        
        User testUser1 = Test_Utils.createTestUser('Tst22','223344');
        insert testUser1;
      system.runAs(testUser1){
        Store__c testStore = new Store__c();
        testStore.ID__c='98765';
        insert testStore;

        Lead testLead = new Lead();
        testLead.Company = 'testComp';
        testLead.Status = 'Open';
        testLead.amount__c = 25.00;
        testLead.LastName = 'LName1';
        testLead.Auto_Assign__c = true;
        testLead.zip__c = '12345';
        testLead.Store__c = testStore.Id;
        testLead.Industry = null;
        testLead.WCW_Count__c = 120;
        testLead.storewebid__c='98765';
        testLead.User__c=testUser1.id;
        testLead.Time_Zone__c = 'Mountain';
    
    insert testLead;
    system.assertEquals('Mountain',testLead.Time_Zone__c);
      }
  }
  //END NSHARP S-364612 11.16.15

  //START NSHARP S-364612 11.16.15
  @isTest
  private static void test_LeadTimeZone_Pacific(){
        Queue_Zones__c q1 = new Queue_Zones__c(Name='Central Time Zone');
        insert q1;
        Queue_Zones__c q2 = new Queue_Zones__c(Name='Eastern Time Zone');
        insert q2;
        Queue_Zones__c q3 = new Queue_Zones__c(Name='Government Leads');
        insert q3;
        Queue_Zones__c q4 = new Queue_Zones__c(Name='Mountain Time Zone');
        insert q4;
        Queue_Zones__c q5 = new Queue_Zones__c(Name='Pacific Time Zone');
        insert q5;
        
        User testUser1 = Test_Utils.createTestUser('Tst22','223344');
        insert testUser1;
      system.runAs(testUser1){
        
        Store__c testStore = new Store__c();
        testStore.ID__c='98765';
        insert testStore;

        Lead testLead = new Lead();
        testLead.Company = 'testComp';
        testLead.Status = 'Open';
        testLead.amount__c = 25.00;
        testLead.LastName = 'LName1';
        testLead.Auto_Assign__c = true;
        testLead.zip__c = '12345';
        testLead.Store__c = testStore.Id;
        testLead.Industry = 'Accounting';
        testLead.WCW_Count__c = 120;
        testLead.storewebid__c='98765';
        testLead.User__c=testUser1.id;
        testLead.Time_Zone__c = 'Pacific';
    
    insert testLead;
    system.assertEquals('Pacific',testLead.Time_Zone__c);
  }
  }
  //END NSHARP S-364612 11.16.15
 
}
// 
// (c) 2015 Appirio, Inc.
//
//
// 17 July 2015     Ryan Marquardt     Added Test Coverage for S-335200

@isTest
private class CT_OnDeck_WRF_cls_Test {
    //Added by Najma Ateeq for Story #S-386202(OD Case Number - 00617674)
    public static  Set<Id> CTids = new Set<Id>();
    public static Set<Id> wrfSet = new Set<Id>();
    
    static{
    //createTestData();		//Case#00175758----Hitesh [Aug 10, 2016] 
    }
    //Added by Najma Ateeq for Story #S-386202(OD Case Number - 00617674)
    @isTest static void test_method_one() {
    	
    	//Case#00175758----START----Hitesh [Aug 10, 2016]
   		Schema.DescribeSObjectResult CR = Schema.SObjectType.Case;
     	Schema.DescribeSObjectResult WRF = Schema.SObjectType.WRF_Task__C;
     	Map<String,Schema.RecordTypeInfo> CRMapByName = CR.getRecordTypeInfosByName();
     	Map<String,Schema.RecordTypeInfo> WRFMapByName = WRF.getRecordTypeInfosByName();
     	
     	User u1 = [select id from User where email = 'testryan@proxy456.officedepot.com' limit 1];
        system.runAs(u1){
     	Account acc = [select id from account where name = 'Ank Test account1' limit 1];
     
   		Case WRCase1 = new Case();
         WRCase1.recordTypeId = CRMapByName .get('Work Request').getRecordTypeId();
         WRCase1.DUP_Acct_ID__c = '78906';
         WRCase1.DUP_Requestor_ID__c = '123456';
         WRCase1.accountId = acc.id;		//Case#00175758----Hitesh [Aug 09, 2016] 
         insert WRCase1;
         wrfSet.add(WRCase1.id);
         
         WRF_Task__c WRFTsk1 = new WRF_Task__C();
         WRFTsk1.RecordTypeId=WRFMapByName.get('WRF Task').getRecordTypeId();
         WRFTsk1.WRF__C=WRCase1.id;
         WRFTsk1.Assigned_To__C=u1.id;
         WRFTsk1.Disposition_Code__C='Bids';
         WRFTsk1.Status__c='New';   
         
         Test.startTest();		//Case#00175758----Hitesh [Aug 10, 2016] 
               
         Insert WRFTsk1;
         
         
          
          Account acc2 = new Account();
          acc2.name = 'Ank Test account2';
          acc2.BillingStreet = '1040 N 327 W';
          acc2.billingcity = 'Orem';
          acc2.BillingState = 'UT';
          acc2.Billingcountry = 'USA';
          acc2.Buying_Group__c = 'Buying Groups Federal';
          acc2.Sector__c = 'Public';
          acc2.Segment__c = 'Federal';
          acc2.parentid=acc.id;
          acc2.Oracle_Party_Id__c = '654321';
          acc2.AOPS_Cust_Id__c = '123457';
          acc2.AOPS_Seq_ID__c = '123457';
          insert acc2;

         Customer_Transition__c acc1CT = new Customer_Transition__c(name='test1',account__c = acc.id,Status__c='Scheduled');
         insert acc1CT;
         system.assert(acc1CT.Id != null);
         CTids.add(acc1CT.id);

         List<Customer_Transition__c> ctlist = new List<Customer_Transition__c>();
         ctlist.add(acc1CT);   		     
		//Case#00175758----END----Hitesh [Aug 10, 2016]
    	
    	
        CT_OnDeck_WRF_cls ctondeckclass = new CT_OnDeck_WRF_cls();
         
        

      //commenting out due to soql limits
        //CT_OnDeck_WRF_cls.futureUpdateWRF(wrfSet);
       CT_OnDeck_WRF_cls.getCustLostHeir(CTids);
       Test.stopTest(); 		//Case#00175758-------Hitesh [Aug 10, 2016]
      //CT_OnDeck_WRF_cls.getAllInHeirarchy(CTids);
   }
    }
   //Added by Najma Ateeq for Story #S-386202(OD Case Number - 00617674)
   
   //Case#00175758---START----Hitesh [Aug 10, 2016] 
   @isTest static void test_method_one1() {
   		
   		Schema.DescribeSObjectResult CR = Schema.SObjectType.Case;
     	Schema.DescribeSObjectResult WRF = Schema.SObjectType.WRF_Task__C;
     	Map<String,Schema.RecordTypeInfo> CRMapByName = CR.getRecordTypeInfosByName();
     	Map<String,Schema.RecordTypeInfo> WRFMapByName = WRF.getRecordTypeInfosByName();
     	
     	User u1 = [select id from User where email = 'testryan@proxy456.officedepot.com' limit 1];
       system.runAs(u1){
     	Account acc = [select id from account where name = 'Ank Test account1' limit 1];
     
   		Case WRCase1 = new Case();
         WRCase1.recordTypeId = CRMapByName .get('Work Request').getRecordTypeId();
         WRCase1.DUP_Acct_ID__c = '78906';
         WRCase1.DUP_Requestor_ID__c = '123456';
         WRCase1.accountId = acc.id;		//Case#00175758----Hitesh [Aug 09, 2016]                   
         insert WRCase1;                 
         
         wrfSet.add(WRCase1.id);
         
         /*WRF_Task__c WRFTsk1 = new WRF_Task__C();
         WRFTsk1.RecordTypeId=WRFMapByName.get('WRF Task').getRecordTypeId();
         WRFTsk1.WRF__C=WRCase1.id;
         WRFTsk1.Assigned_To__C=u1.id;
         WRFTsk1.Disposition_Code__C='Bids';
         WRFTsk1.Status__c='New'; */  
         
         
         Test.startTest();		//Case#00175758----Hitesh [Aug 10, 2016]      
         //Insert WRFTsk1;
               
          
          Account acc2 = new Account();
          acc2.name = 'Ank Test account2';
          acc2.BillingStreet = '1040 N 327 W';
          acc2.billingcity = 'Orem';
          acc2.BillingState = 'UT';
          acc2.Billingcountry = 'USA';
          acc2.Buying_Group__c = 'Buying Groups Federal';
          acc2.Sector__c = 'Public';
          acc2.Segment__c = 'Federal';
          acc2.parentid=acc.id;
          acc2.Oracle_Party_Id__c = '654321';
          acc2.AOPS_Cust_Id__c = '123457';
          acc2.AOPS_Seq_ID__c = '123457';
          //insert acc2;
   		
        CT_OnDeck_WRF_cls ctondeckclass = new CT_OnDeck_WRF_cls();                  
        CT_OnDeck_WRF_cls.futureUpdateWRF(wrfSet,CRMapByName.get('Work Request').getRecordTypeId()); 
        Test.stopTest();            
      //CT_OnDeck_WRF_cls.getCustLostHeir(CTids);
      //CT_OnDeck_WRF_cls.getAllInHeirarchy(CTids);
   }
   }
   //Case#00175758----END---Hitesh [Aug 10, 2016] 
   @isTest static void test_method_one2() {
   		//Case#00175758----START----Hitesh [Aug 10, 2016]
   		Schema.DescribeSObjectResult CR = Schema.SObjectType.Case;
     	Schema.DescribeSObjectResult WRF = Schema.SObjectType.WRF_Task__C;
     	Map<String,Schema.RecordTypeInfo> CRMapByName = CR.getRecordTypeInfosByName();
     	Map<String,Schema.RecordTypeInfo> WRFMapByName = WRF.getRecordTypeInfosByName();
     	
     	User u1 = [select id from User where email = 'testryan@proxy456.officedepot.com' limit 1];
       system.runas(u1){
     	Account acc = [select id from account where name = 'Ank Test account1' limit 1];
     
   		Case WRCase1 = new Case();
         WRCase1.recordTypeId = CRMapByName .get('Work Request').getRecordTypeId();
         WRCase1.DUP_Acct_ID__c = '78906';
         WRCase1.DUP_Requestor_ID__c = '123456';
         WRCase1.accountId = acc.id;		//Case#00175758----Hitesh [Aug 09, 2016] 
         insert WRCase1;
         wrfSet.add(WRCase1.id);
         
         WRF_Task__c WRFTsk1 = new WRF_Task__C();
         WRFTsk1.RecordTypeId=WRFMapByName.get('WRF Task').getRecordTypeId();
         WRFTsk1.WRF__C=WRCase1.id;
         WRFTsk1.Assigned_To__C=u1.id;
         WRFTsk1.Disposition_Code__C='Bids';
         WRFTsk1.Status__c='New';   
         
         Test.startTest();		//Case#00175758----Hitesh [Aug 10, 2016] 
               
         Insert WRFTsk1;
                
          
          Account acc2 = new Account();
          acc2.name = 'Ank Test account2';
          acc2.BillingStreet = '1040 N 327 W';
          acc2.billingcity = 'Orem';
          acc2.BillingState = 'UT';
          acc2.Billingcountry = 'USA';
          acc2.Buying_Group__c = 'Buying Groups Federal';
          acc2.Sector__c = 'Public';
          acc2.Segment__c = 'Federal';
          acc2.parentid=acc.id;
          acc2.Oracle_Party_Id__c = '654321';
          acc2.AOPS_Cust_Id__c = '123457';
          acc2.AOPS_Seq_ID__c = '123457';
          insert acc2;

         Customer_Transition__c acc1CT = new Customer_Transition__c(name='test1',account__c = acc.id,Status__c='Scheduled');
         insert acc1CT;
         system.assert(acc1CT.Id != null);
         CTids.add(acc1CT.id);

         List<Customer_Transition__c> ctlist = new List<Customer_Transition__c>();
         ctlist.add(acc1CT);
   		   		       
		//Case#00175758----END----Hitesh [Aug 10, 2016]
        

      //commenting out due to soql limits
       //CT_OnDeck_WRF_cls.futureUpdateWRF(wrfSet);
      //CT_OnDeck_WRF_cls.getCustLostHeir(CTids);
      CT_OnDeck_WRF_cls.getAllInHeirarchy(CTids);      
      Test.stopTest(); 		//Case#00175758-------Hitesh [Aug 10, 2016]      
   }
   }
   
   //Case#00175758----START----Hitesh [Aug 10, 2016]
   @testSetup static void setupData(){
   	 Schema.DescribeSObjectResult CR = Schema.SObjectType.Case;
     Schema.DescribeSObjectResult WRF = Schema.SObjectType.WRF_Task__C; 
     Map<String,Schema.RecordTypeInfo> WRFMapByName = WRF.getRecordTypeInfosByName();
         


      Profile p4 = [SELECT Id FROM profile WHERE name='System Administrator'];   
      Map<String,Schema.RecordTypeInfo> CRMapByName = CR.getRecordTypeInfosByName();
                  
         User u1 = new User(alias = 'test123 ', email='testryan@proxy456.officedepot.com',OD_Employee_ID__c='xxyyOD9876',emailencodingkey='UTF-8', lastname='test123',languagelocalekey='en_US',localesidkey='en_US', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='testryan@proxy456.officedepot.com',isactive=true);
         insert u1;
       system.runAs(u1){
         Account acc1 = new Account();
          acc1.name = 'Ank Test account1';
          acc1.BillingStreet = '1040 N 326 W';
          acc1.billingcity = 'Orem';
          acc1.BillingState = 'UT';
          acc1.Billingcountry = 'USA';
          acc1.Buying_Group__c = 'Buying Groups Federal';
          acc1.Sector__c = 'Public';
          acc1.Segment__c = 'Federal';
          acc1.Oracle_Party_Id__c = 'testdata';
          acc1.AOPS_Cust_Id__c = '123456';
          acc1.AOPS_Seq_ID__c = '123456';
          insert acc1;        
       }
         
   }
   //Case#00175758----END----Hitesh [Aug 10, 2016]
   
   //Case#00175758----START----Hitesh [Aug 11, 2016]
   // commented below method , added logic to @testSetup method
    /*
    static void createTestData(){
        
     

      Schema.DescribeSObjectResult CR = Schema.SObjectType.Case;
         Schema.DescribeSObjectResult WRF = Schema.SObjectType.WRF_Task__C; 
         Map<String,Schema.RecordTypeInfo> WRFMapByName = WRF.getRecordTypeInfosByName();
         


      Profile p4 = [SELECT Id FROM profile WHERE name='System Administrator'];   
               Map<String,Schema.RecordTypeInfo> CRMapByName = CR.getRecordTypeInfosByName();
         
         //LSLEVIN 2.10.16 S-376887 Updated below line Employee Id to include OD
         User u1 = new User(alias = 'test123 ', email='testryan@proxy456.officedepot.com',OD_Employee_ID__c='xxyyOD9876',emailencodingkey='UTF-8', lastname='test123',languagelocalekey='en_US',localesidkey='en_US', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='testryan@proxy456.officedepot.com',isactive=true);
         insert u1;
         
         Account acc1 = new Account();
          acc1.name = 'Ank Test account1';
          acc1.BillingStreet = '1040 N 326 W';
          acc1.billingcity = 'Orem';
          acc1.BillingState = 'UT';
          acc1.Billingcountry = 'USA';
          acc1.Buying_Group__c = 'Buying Groups Federal';
          acc1.Sector__c = 'Public';
          acc1.Segment__c = 'Federal';
          acc1.Oracle_Party_Id__c = 'testdata';
          acc1.AOPS_Cust_Id__c = '123456';
          acc1.AOPS_Seq_ID__c = '123456';
          insert acc1;

         
         Case WRCase1 = new Case();
         WRCase1.recordTypeId = CRMapByName .get('Work Request').getRecordTypeId();
         WRCase1.DUP_Acct_ID__c = '78906';
         WRCase1.DUP_Requestor_ID__c = '123456';
         WRCase1.accountId = acc1.id;		//Case#00175758----Hitesh [Aug 09, 2016] 
         insert WRCase1;
         wrfSet.add(WRCase1.id);//Najma
         
         WRF_Task__c WRFTsk1 = new WRF_Task__C();
         WRFTsk1.RecordTypeId=WRFMapByName.get('WRF Task').getRecordTypeId();
         WRFTsk1.WRF__C=WRCase1.id;
         WRFTsk1.Assigned_To__C=u1.id;
         WRFTsk1.Disposition_Code__C='Bids';
         WRFTsk1.Status__c='New';   
         
         //Test.startTest();		//Case#00175758----Hitesh [Aug 10, 2016] 
               
         Insert WRFTsk1;
         
        //Test.stopTest(); 
          
          Account acc2 = new Account();
          acc2.name = 'Ank Test account2';
          acc2.BillingStreet = '1040 N 327 W';
          acc2.billingcity = 'Orem';
          acc2.BillingState = 'UT';
          acc2.Billingcountry = 'USA';
          acc2.Buying_Group__c = 'Buying Groups Federal';
          acc2.Sector__c = 'Public';
          acc2.Segment__c = 'Federal';
          acc2.parentid=acc1.id;
          acc2.Oracle_Party_Id__c = '654321';
          acc2.AOPS_Cust_Id__c = '123457';
          acc2.AOPS_Seq_ID__c = '123457';
          insert acc2;

         Customer_Transition__c acc1CT = new Customer_Transition__c(name='test1',account__c = acc1.id,Status__c='Scheduled');
         insert acc1CT;
         system.assert(acc1CT.Id != null);
         CTids.add(acc1CT.id);

         List<Customer_Transition__c> ctlist = new List<Customer_Transition__c>();
         ctlist.add(acc1CT);

    }
    */    
    //Added by Najma Ateeq for Story #S-386202(OD Case Number - 00617674)
    //Case#00175758----END----Hitesh [Aug 11, 2016]
}
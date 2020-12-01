//
// 8/10/2016 Jessica Schilling Case 175803 Fixed test class failures
//
@isTest
private class Mod5Helper_Test {
    
    @isTest static void test_method_one() {
        Mod5Helper mod5class = new Mod5Helper();

        Set<Id> wrfSet = new Set<Id>();
      Set<Id> CTids = new Set<Id>();

      Schema.DescribeSObjectResult CR = Schema.SObjectType.Case;
         Schema.DescribeSObjectResult WRF = Schema.SObjectType.WRF_Task__C; 
         Map<String,Schema.RecordTypeInfo> WRFMapByName = WRF.getRecordTypeInfosByName();
         


      Profile p4 = [SELECT Id FROM profile WHERE name='System Administrator'];   
               Map<String,Schema.RecordTypeInfo> CRMapByName = CR.getRecordTypeInfosByName();
         
         //LSLEVIN 2.10.16 S-376887 Updated below lines employee id to include OD
         User u1 = new User(alias = 'test123 ', email='testryan@proxy456.officedepot.com',OD_Employee_ID__c='xxyyzzOD12',emailencodingkey='UTF-8', lastname='test123',languagelocalekey='en_US',localesidkey='en_US', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='testryan@proxy456.officedepot.com',isactive=true);
         insert u1;
         
         system.runas(u1){

         //START JSCHILLING Case 175803 8/10/2016
         //Moved Account to fix process builder error
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
         //END JSCHILLING Case 175803 8/10/2016

         Case WRCase1 = new Case();
         WRCase1.recordTypeId = CRMapByName .get('Work Request').getRecordTypeId();
         WRCase1.DUP_Acct_ID__c = '78906';
         WRCase1.DUP_Requestor_ID__c = '123456';
         //Added below line JSCHILLING Case 175803 8/10/2016 Added Account to fix process builder error
         WRCase1.AccountId = acc1.Id;         
         insert WRCase1;
        
        Test.startTest();       //Case#00175758 -----Hitesh[Aug 11, 2016]
         WRF_Task__c WRFTsk1 = new WRF_Task__C();
         WRFTsk1.RecordTypeId=WRFMapByName.get('WRF Task').getRecordTypeId();
         WRFTsk1.WRF__C=WRCase1.id;
         WRFTsk1.Assigned_To__C=u1.id;
         WRFTsk1.Disposition_Code__C='Bids';
         WRFTsk1.Status__c='New';
         WRFTsk1.Due_Date__c=System.today() + 14;
         Insert WRFTsk1;
         wrfSet.add(WRFTsk1.id);

         //START JSCHILLING Case 175803 8/10/2016
         //Moved Account to fix process builder error
         /*
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
          */
          //END JSCHILLING Case 175803 8/10/2016
          
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
         CTids.add(acc1CT.id);

         List<Customer_Transition__c> ctlist = new List<Customer_Transition__c>();
         ctlist.add(acc1CT);

        //Test.startTest(); //added for the story #S-355233

         mod5class.validateList(ctlist);
         
        Test.stopTest(); //added for the story #S-355233
    }
    
    }
    
}
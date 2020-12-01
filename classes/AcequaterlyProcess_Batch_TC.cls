@isTest
 Private class AcequaterlyProcess_Batch_TC{
      static testMethod void myTest(){ 

         ACE_Settings__c desettings = new ACE_Settings__c(BatchName__c = 'Q4-2014');
         insert desettings; 

          Account acc = new Account ();
          acc.name = 'Test Account';
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
          
          ACE_SKU_Changes_inbound__c ib = new ACE_SKU_Changes_inbound__c ();
          ib.Owning_Customer_ID2__c = '123456'; 
          ib.batchId__c= 'Q4-2014' ;
          ib.CoreList_ID__c = 'Core-1';
          ib.SKU__c = 'SKU1';
          insert ib;

         ACE_Customer_Price_Changes__c ace1 = new ACE_Customer_Price_Changes__c(
                                                Owning_Customer_Legal__c='T',
                                                name='Q4-2014',
                                                SRM_Differential__c=5,
                                                Item_12_Month_Qty__c = 50,
                                                Total_Spend_Impact_12_Month__c=5,
                                                Customer__c = acc.id, 
                                                Owning_Customer_ID__c ='123456',
                                                Approval_Type__c = 1,
                                                SFDC_Notification_Flag__c = '3');
         insert ace1;
            
           Test.startTest();
               AcequaterlyProcess_Batch batch = new AcequaterlyProcess_Batch (); 
               database.executebatch(batch , 100);
            Test.stopTest();
       
      }
 }
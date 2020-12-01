@isTest
private class ACE_ApprovalReminderEmails_TC
{

 static testMethod void ACE_ApprovalReminderEmails_method(){

        Profile p = [select id from Profile where name='System Administrator' limit 1];

        User mgruser = new User(TimeZoneSidKey='America/Los_Angeles',ProfileId = p.id,LastName = 'ACE', FirstName = 'Manager', Email = 'ACE.manager@officedepot.com',Username ='ACE.manager@officedepot.com', Alias='test', CommunityNickname='test Approver', LanguageLocaleKey='en_US', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', OD_Employee_ID__c='653466');
        Insert mgruser;

        User user = new User(TimeZoneSidKey='America/Los_Angeles',ProfileId = p.id,LastName = 'Rep', FirstName = 'ACE',Email='Rep.ACE@officedepot.com', Username ='Rep.ACE@officedepot.com', Alias='test12', CommunityNickname='test Approve', LanguageLocaleKey='en_US', EmailEncodingKey='UTF-8', LocaleSidKey='en_US',OD_Employee_ID__c='653486');
        Insert user;

 Account acc = new Account (name = 'SUN Test Account',AOPS_Seq_ID__c = '123456',AOPS_Cust_Id__c = '123456',Oracle_Party_Id__c = '123456',Billingcountry = 'USA',BillingState = 'UT',BillingStreet = '1040 N 326 W',billingcity = 'Orem');
 insert acc;

 Account acc2 = new Account (name = 'SUN Test Account2',AOPS_Seq_ID__c = '1234562',AOPS_Cust_Id__c = '1234562',Oracle_Party_Id__c = '1234562',Billingcountry = 'USA',BillingState = 'UT',BillingStreet = '1040 N 326 W',billingcity = 'Orem');
 insert acc2;

 ACE_Settings__c ASE = new ACE_Settings__c();
 ASE.trigger_by_pass__c='qwerty';
 insert ASE;

 List <ACE_Customer_Price_Changes__c> ACPC = new List<ACE_Customer_Price_Changes__c>();

 ACE_Customer_Price_Changes__c ace1 = new ACE_Customer_Price_Changes__c(Approval_Type__c = 1,DSM__c = mgruser.id,Sales_Price_Change_Effective_Date_Rep__c=Date.newInstance(1980, 10 ,20),name='test',Customer_Notification_Date_Approved__c=Date.newInstance(2013 , 10 ,20),Customer_Notification_Date__c=Date.newInstance(2013 , 12 ,20),Sales_Price_Change_Effective_Date_Approv__c=Date.newInstance(2013 , 12 ,20),OD_Revenue_Impact__c= 8989,Customer_Notification_Date_Rep__c=Date.newInstance(2012 , 10 ,20),SRM_Differential__c=5,record_unlock_Status__c='open',Item_12_Month_Qty__c = 50,Total_Spend_Impact_12_Month__c=80000,Sales_Price_Change_Effective_Date_Min__c=Date.newInstance(2020 , 12 ,20),Customer__c = acc.id, Owning_Customer_ID__c ='123456', SFDC_Notification_Flag__c = '3');
 ACE_Customer_Price_Changes__c ace2 = new ACE_Customer_Price_Changes__c(Approval_Type__c = 1,DSM__c = mgruser.id,Sales_Price_Change_Effective_Date_Rep__c=Date.newInstance(2080, 10 ,20),name='test',Customer_Notification_Date_Approved__c=Date.newInstance(2013 , 10 ,20),Customer_Notification_Date__c=Date.newInstance(2013 , 12 ,20),Sales_Price_Change_Effective_Date_Approv__c=Date.newInstance(2013 , 12 ,20),OD_Revenue_Impact__c= 8989,Customer_Notification_Date_Rep__c=Date.newInstance(2012 , 10 ,20),SRM_Differential__c=5,record_unlock_Status__c='open',Item_12_Month_Qty__c = 50,Total_Spend_Impact_12_Month__c=80000,Sales_Price_Change_Effective_Date_Min__c=Date.newInstance(2020 , 12 ,20),Customer__c = acc2.id, Owning_Customer_ID__c ='123456', SFDC_Notification_Flag__c = '3');

 ACPC.add(ace1);
 ACPC.add(ace2);
 insert ACPC ;

 //ApexPages.currentPage().getParameters().Put('id',ace1.id);
 ApexPages.currentPage().getParameters().Put('pid',ace1.id);
 Ace_Customer_Core_Changes__c CCCC = new Ace_Customer_Core_Changes__c();
 CCCC.ACE_Customer_Price_Changes__c=ace1.id;
 CCCC.CoreID__c='alpha';
 insert CCCC;
 ApexPages.currentPage().getParameters().Put('pid',ace2.id);
 Ace_Customer_Core_Changes__c CCCC2 = new Ace_Customer_Core_Changes__c();
 CCCC2.ACE_Customer_Price_Changes__c=ace2.id;
 CCCC2.CoreID__c='alpha';
 insert CCCC2;

         ACE_Customer_sku_Changes__c sku1 = new ACE_Customer_sku_Changes__c(Approval_Type__c = 1,DSM__c = mgruser.id,name='test',SKU__c='123456',Ace_Customer_Core_Changes__c = CCCC.id);
         insert sku1;
         ACE_Customer_sku_Changes__c sku2 = new ACE_Customer_sku_Changes__c(Approval_Type__c = 1,DSM__c = mgruser.id,name='test',SKU__c='123456',Ace_Customer_Core_Changes__c = CCCC2.id);
         insert sku2;


 ApexPages.StandardController con = new ApexPages.StandardController(ace1);

 aceDateChanges controller1 = new aceDateChanges();
 aceDateChanges controller = new aceDateChanges(con);

 controller.CalculateRevenueImpact();
 controller.saveChanges();
 controller.cancelChanges();



 ApexPages.StandardController con2 = new ApexPages.StandardController(ace2);

 aceDateChanges controller12 = new aceDateChanges();
 aceDateChanges controller2 = new aceDateChanges(con2);

 controller2.CalculateRevenueImpact();
 controller2.saveChanges();
 controller2.cancelChanges();

        // uncommented for S-423439
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval.');
        req1.setObjectId(ace1.id);

        Approval.ProcessResult result = Approval.process(req1);
        // S-423439
        
        /*
        Approval.ProcessSubmitRequest req2 = new Approval.ProcessSubmitRequest();
        req2.setComments('Submitting request for approval.');
        req2.setObjectId(ace2.id);

        Approval.ProcessResult result2 = Approval.process(req2);

        Approval.ProcessSubmitRequest req3 = new Approval.ProcessSubmitRequest();
        req3.setComments('Submitting sku request for approval.');
        req3.setObjectId(sku1.id);

        Approval.ProcessResult result3 = Approval.process(req3);

        Approval.ProcessSubmitRequest req4 = new Approval.ProcessSubmitRequest();
        req4.setComments('Submitting sku request for approval.');
        req4.setObjectId(sku2.id);

        Approval.ProcessResult result4 = Approval.process(req4); */
     

         system.runas(user){
         Test.startTest();
         integer batch_size = 5;
         ACE_ApprovalReminderEmails aceBatch = new ACE_ApprovalReminderEmails();
         database.executebatch(aceBatch,batch_size);
         String CRON_EXP = '0 0 0 3 9 ? 2022';
         System.schedule('TestBatch1',CRON_EXP , aceBatch );
         Test.stopTest();
        }

        ACE_ApprovalReminderEmails.FindEmailTemplateIDByDeveloperName('Customer_Transition_Rep_Email'); //S-420971 (OD 00731422) [Hemant 6/30/2016] - Increase code coverage

 }
 }
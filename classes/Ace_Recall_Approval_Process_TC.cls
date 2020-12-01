@isTest
private class Ace_Recall_Approval_Process_TC 
{
    static testMethod void myUnitTest() 
    {

        Profile p = [select id from Profile where name='System Administrator' limit 1];
               
        User mgruser = new User(TimeZoneSidKey='America/Los_Angeles',ProfileId = p.id,LastName = 'ACE', FirstName = 'Manager', Email = 'ACE.manager@officedepot.com',Username ='ACE.manager@officedepot.com', Alias='test', CommunityNickname='test Approver', LanguageLocaleKey='en_US', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', OD_Employee_ID__c='653466');
        Insert mgruser;

        User user = new User(TimeZoneSidKey='America/Los_Angeles',ProfileId = p.id,LastName = 'Rep', FirstName = 'ACE',Email='Rep.ACE@officedepot.com', Username ='Rep.ACE@officedepot.com', Alias='test12', CommunityNickname='test Approve', LanguageLocaleKey='en_US', EmailEncodingKey='UTF-8', LocaleSidKey='en_US',OD_Employee_ID__c='653486');
        Insert user;
        
        Set<ID> appids = new Set<ID>();

         ACE_Settings__c desettings = new ACE_Settings__c();
         insert desettings; 

         Account acc = new Account (
                         name = 'SUN Test Account',
                         AOPS_Seq_ID__c = '123456',
                         AOPS_Cust_Id__c = '123456',
                         Oracle_Party_Id__c = '123456',
                         Billingcountry = 'USA',
                         BillingState = 'UT',
                         BillingStreet = '1040 N 326 W',
                         ownerid = user.id,
                         billingcity = 'Orem');
         insert acc;

         ACE_Customer_Price_Changes__c ace11 = new ACE_Customer_Price_Changes__c(
                                                Owning_Customer_Legal__c='T',
                                                name='test',
                                                SRM_Differential__c=5,
                                                Item_12_Month_Qty__c = 50,
                                                Total_Spend_Impact_12_Month__c=5,
                                                Customer__c = acc.id, 
                                                Owning_Customer_ID__c ='123456',
                                                DSM__c = mgruser.id, 
                                                Approval_Type__c = 1,
                                                SFDC_Notification_Flag__c = '3');
         insert ace11;

         appids.add(ace11.id);

         ACE_Customer_Price_Changes__c ace12 = new ACE_Customer_Price_Changes__c(
                                                Owning_Customer_Legal__c='T',
                                                name='test',
                                                SRM_Differential__c=5,
                                                Item_12_Month_Qty__c = 50,
                                                Total_Spend_Impact_12_Month__c=5,
                                                Customer__c = acc.id, 
                                                Owning_Customer_ID__c ='123456',
                                                DSM__c = mgruser.id, 
                                                Approval_Type__c = 2,
                                                SFDC_Notification_Flag__c = '3');
         insert ace12;

         appids.add(ace12.id);

        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval.');
        req1.setObjectId(ace11.id);
        
        Approval.ProcessResult result = Approval.process(req1);
                        
        ACE_RECALL_APPROVAL_PROCESS controller = new ACE_RECALL_APPROVAL_PROCESS();
        ACE_RECALL_APPROVAL_PROCESS.ACERecallMethod(appids);
    
        ace11.Approval_Type__c = 1;
        update ace11;
        
        ace12.Approval_Type__c = 1;
        update ace12;

        Approval.ProcessSubmitRequest req2 = new Approval.ProcessSubmitRequest();
        req2.setComments('Submitting request for approval.');
        req2.setObjectId(ace11.id);

        Approval.ProcessSubmitRequest req3 = new Approval.ProcessSubmitRequest();
        req3.setComments('Submitting request for approval.');
        req3.setObjectId(ace12.id);

      /*  system.runas(user){
         Test.startTest();
         integer batch_size = 5;
         ACE_ApprovalReminderEmails aceBatch = new ACE_ApprovalReminderEmails();
         database.executebatch(aceBatch,batch_size);
         String CRON_EXP = '0 0 0 3 9 ? 2022';
         System.schedule('TestBatch1',CRON_EXP , aceBatch );
         Test.stopTest();
        }*/
        
        Approval.ProcessResult approveresult = Approval.process(req2);
        Approval.ProcessResult approveresult2 = Approval.process(req3);

        ACE_RECALL_APPROVAL_PROCESS.ACEApprRejMethod(ace11.id,'Approved','Approve');
        List<ID> bulkList = new List<ID>();
        bulkList.add(ace12.id);
        ACE_RECALL_APPROVAL_PROCESS.ACEApprRejMethodBulk(bulkList,'','Approve');
    }
}
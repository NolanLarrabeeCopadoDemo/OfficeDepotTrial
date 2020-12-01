@isTest
private class itemsToApprove_TC 
{
    static testMethod void myTest1() 
    {
         System.runas(new user(ID = UserInfo.getUserID())){
        Profile p = [select id from Profile where name='System Administrator' limit 1];
               
        User mgruser = new User(TimeZoneSidKey='America/Los_Angeles',ProfileId = p.id,LastName = 'ACE', FirstName = 'Manager', Email = 'ACE.manager@officedepot.com',Username ='ACE.manager@officedepot.com', Alias='test', CommunityNickname='test Approver', LanguageLocaleKey='en_US', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', OD_Employee_ID__c='653466');
        Insert mgruser;

        User user = new User(TimeZoneSidKey='America/Los_Angeles',ProfileId = p.id,LastName = 'Rep', FirstName = 'ACE',Email='Rep.ACE@officedepot.com', Username ='Rep.ACE@officedepot.com', Alias='test12', CommunityNickname='test Approve', LanguageLocaleKey='en_US', EmailEncodingKey='UTF-8', LocaleSidKey='en_US',OD_Employee_ID__c='653486');
        Insert user;
             system.runAs(user){

         ACE_Settings__c desettings = new ACE_Settings__c(ApprovalDays__c = 1);
         insert desettings; 

        Account acc = new Account ();
        acc.name = 'SUN Test Account';
        acc.BillingStreet = '1040 N 326 W';
        acc.billingcity = 'Orem';
        acc.BillingState = 'UT';
        acc.Billingcountry = 'USA';
        acc.Oracle_Party_Id__c = '123456';
        acc.AOPS_Cust_Id__c = '123456';
        acc.AOPS_Seq_ID__c = '123456';
        insert acc;


         ACE_Customer_Price_Changes__c ace = new ACE_Customer_Price_Changes__c(
                                                Owning_Customer_Legal__c='T',
                                                name='Q4-2014',
                                                SRM_Differential__c=5,
                                                Item_12_Month_Qty__c = 50,
                                                Total_Spend_Impact_12_Month__c=5,
                                                Customer__c = acc.id, 
                                                Owning_Customer_ID__c ='123456',
                                                Approval_Type__c = 1,
                                                DSM__c = mgruser.id, 
                                                Record_Unlock_Status__c = 'Approved',
                                                SFDC_Notification_Flag__c = '3');
         insert ace;
         
         ACE_Customer_Price_Changes__c ace12 = new ACE_Customer_Price_Changes__c(
                                                Owning_Customer_Legal__c='T',
                                                name='Q4-2014',
                                                SRM_Differential__c=5,
                                                Item_12_Month_Qty__c = 50,
                                                Total_Spend_Impact_12_Month__c=5,
                                                Customer__c = acc.id, 
                                                Owning_Customer_ID__c ='123456',
                                                Approval_Type__c = 1,
                                                DSM__c = mgruser.id, 
                                                Record_Unlock_Status__c = 'Pending',
                                                SFDC_Notification_Flag__c = '3');
         insert ace12;

         ACE_Customer_Price_Changes__c ace1 = new ACE_Customer_Price_Changes__c(
                                                Owning_Customer_Legal__c='T',
                                                name='Q4-2014',
                                                SRM_Differential__c=5,
                                                Item_12_Month_Qty__c = 50,
                                                Total_Spend_Impact_12_Month__c=5,
                                                Customer__c = acc.id, 
                                                Owning_Customer_ID__c ='123456',
                                                Approval_Type__c = 1,
                                                DSM__c = mgruser.id, 
                                                VP__c = mgruser.id,
                                                RSD__c = mgruser.id,
                                                L3_Mgr_Approval_Start_Date__c = system.today()+4,
                                                L2_Mgr_Approval_Start_Date__c = system.today()+3,
                                                L1_Mgr_Approval_Start_Date__c = system.today()+2,
                                                Record_Unlock_Status__c = 'Pending',
                                                SFDC_Notification_Flag__c = '3');
         insert ace1;

        Ace_Customer_Core_Changes__c ace2 = new Ace_Customer_Core_Changes__c(name = 'Test',CoreID__c = 'CL-9492090', ACE_Customer_Price_Changes__c = ace1.id);
        insert ace2;

        Ace_Customer_Core_Changes__c ace21 = new Ace_Customer_Core_Changes__c(name = 'Test',CoreID__c = 'CL-9492091', ACE_Customer_Price_Changes__c = ace.id);
        insert ace21;

        Ace_Customer_Core_Changes__c ace22 = new Ace_Customer_Core_Changes__c(name = 'Test',CoreID__c = 'CL-9492092', ACE_Customer_Price_Changes__c = ace12.id);
        insert ace22;

        Ace_Customer_SKU_Changes__c ace3 = new Ace_Customer_SKU_Changes__c(Approval_status__c = 'Pending',price_Changes_Type__c='A',Status__c='Active',SKU__c = '158849',name='158849',CoreList_ID__c='CL-9492090', Ace_Customer_Core_Changes__c = ace2.id);
        insert ace3;

        Ace_Customer_SKU_Changes__c ace31 = new Ace_Customer_SKU_Changes__c(DSM__c = mgruser.id,Approval_Type__c = 1,Approval_status__c = 'Pending',price_Changes_Type__c='A',Status__c='Active',SKU__c = '158859',name='158859',CoreList_ID__c='CL-9492091', Ace_Customer_Core_Changes__c = ace21.id);
        insert ace31;

        Ace_Customer_SKU_Changes__c ace32 = new Ace_Customer_SKU_Changes__c(Current_Sell_Price__c=5.5,Approved_Proposed_Price__c=20.5,DSM__c = mgruser.id,Approval_Type__c = 1,Approval_status__c = 'Pending',price_Changes_Type__c='A',Status__c='Active',SKU__c = '158858',name='158858',CoreList_ID__c='CL-9492092', Ace_Customer_Core_Changes__c = ace22.id);
        insert ace32;
        
        /*Approval.ProcessSubmitRequest req11 = new Approval.ProcessSubmitRequest();
        req11.setSubmitterId(user.Id); 
        req11.setComments('Submitting request for approval.');
        req11.setObjectId(ace.id);
        
        Approval.ProcessResult result11 = Approval.process(req11);*/
        
    test.starttest();
        Approval.ProcessSubmitRequest req11 = new Approval.ProcessSubmitRequest();
        req11.setSubmitterId(user.Id); 
        req11.setComments('Submitting request for approval.');
        req11.setObjectId(ace.id);
        
        Approval.ProcessResult result11 = Approval.process(req11);
        
        system.runas(mgruser){
        itemsToApprove test = new itemsToApprove();
        test.passthruCustID = ace1.id;
        test.passThruId = ace32.id;
        test.custdueFilter = 'PastDue';
        test.type='Price';
        test.ApproveFunc();
        test.CancelFunc();
        test.PriceType = 'Date';
        test.type='Price';
        test.UnlockComments = 'test';
        test.ApproveFunc();
        test.CancelFunc();
        test.PriceType = 'Price';
        test.type='Date';
        test.UnlockComments = 'test';
        test.RejectFunc();        
        test.AssignFunc();
        itemsToApprove.wrapperAppPendList wrap = new itemsToApprove.wrapperAppPendList();
        test.custdueFilterLogic();
        test.getDisablePrevious1();
        test.getDisableNext1();
        test.nextbtn();
        test.prevbtn();
        itemsToApprove.skuListTable wrap1 = new itemsToApprove.skuListTable();
        test.nextPage();
        test.prevPage();
        test.getDisablePrevious();
        test.getDisableNext();
        test.dueFilterLogic();
        test.approvePriceWithChange();
        test.updateDate();
        test.approveDateWithChange();
        test.dueFilter = 'PastDue';
        test.passthruCustID = ace12.id;
        //test.dueFilterLogic();
        test.custid = ace32.id;
        test.priceVal = '12.20';
        test.approvePriceWithChange();
        wrap1.ts = ace32;
        test.clsSKUListTable.add(wrap1);
        //test.clsSKUListTable[0].isselected = true;
        for(Integer a = 0; a < test.clsSKUListTable.size(); a++){
  		test.clsSKUListTable[a].isSelected = true;
		}
        test.approvePriceBulk();
        test.disablebtn();
        }
    test.stoptest();
    }
         }
    }

    static testMethod void myTest2() 
    {
         System.runas(new user(ID = UserInfo.getUserID())){

        Profile p = [select id from Profile where name='System Administrator' limit 1];
               
        User mgruser = new User(TimeZoneSidKey='America/Los_Angeles',ProfileId = p.id,LastName = 'ACE', FirstName = 'Manager', Email = 'ACE.manager@officedepot.com',Username ='ACE.manager@officedepot.com', Alias='test', CommunityNickname='test Approver', LanguageLocaleKey='en_US', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', OD_Employee_ID__c='653466');
        Insert mgruser;

        User user = new User(TimeZoneSidKey='America/Los_Angeles',ProfileId = p.id,LastName = 'Rep', FirstName = 'ACE',Email='Rep.ACE@officedepot.com', Username ='Rep.ACE@officedepot.com', Alias='test12', CommunityNickname='test Approve', LanguageLocaleKey='en_US', EmailEncodingKey='UTF-8', LocaleSidKey='en_US',OD_Employee_ID__c='653486');
        Insert user;

         ACE_Settings__c desettings = new ACE_Settings__c(ApprovalDays__c = 1);
         insert desettings; 

        Account acc = new Account ();
        acc.name = 'SUN Test Account';
        acc.BillingStreet = '1040 N 326 W';
        acc.billingcity = 'Orem';
        acc.BillingState = 'UT';
        acc.Billingcountry = 'USA';
        acc.Oracle_Party_Id__c = '123456';
        acc.AOPS_Cust_Id__c = '123456';
        acc.AOPS_Seq_ID__c = '123456';
        insert acc;


         ACE_Customer_Price_Changes__c ace = new ACE_Customer_Price_Changes__c(
                                                Owning_Customer_Legal__c='T',
                                                name='Q4-2014',
                                                SRM_Differential__c=5,
                                                Item_12_Month_Qty__c = 50,
                                                Total_Spend_Impact_12_Month__c=5,
                                                Customer__c = acc.id, 
                                                Owning_Customer_ID__c ='123456',
                                                Approval_Type__c = 1,
                                                DSM__c = mgruser.id, 
                                                Record_Unlock_Status__c = 'Approved',
                                                SFDC_Notification_Flag__c = '3');
         insert ace;
         
         ACE_Customer_Price_Changes__c ace12 = new ACE_Customer_Price_Changes__c(
                                                Owning_Customer_Legal__c='T',
                                                name='Q4-2014',
                                                SRM_Differential__c=5,
                                                Item_12_Month_Qty__c = 50,
                                                Total_Spend_Impact_12_Month__c=5,
                                                Customer__c = acc.id, 
                                                Owning_Customer_ID__c ='123456',
                                                Approval_Type__c = 1,
                                                DSM__c = mgruser.id, 
                                                Record_Unlock_Status__c = 'Pending',
                                                SFDC_Notification_Flag__c = '3');
         insert ace12;

         ACE_Customer_Price_Changes__c ace1 = new ACE_Customer_Price_Changes__c(
                                                Owning_Customer_Legal__c='T',
                                                name='Q4-2014',
                                                SRM_Differential__c=5,
                                                Item_12_Month_Qty__c = 50,
                                                Total_Spend_Impact_12_Month__c=5,
                                                Customer__c = acc.id, 
                                                Owning_Customer_ID__c ='123456',
                                                Approval_Type__c = 1,
                                                DSM__c = mgruser.id, 
                                                VP__c = mgruser.id,
                                                RSD__c = mgruser.id,
                                                L3_Mgr_Approval_Start_Date__c = system.today()+4,
                                                L2_Mgr_Approval_Start_Date__c = system.today()+3,
                                                L1_Mgr_Approval_Start_Date__c = system.today()+2,
                                                Record_Unlock_Status__c = 'Pending',
                                                SFDC_Notification_Flag__c = '3');
         insert ace1;

        Ace_Customer_Core_Changes__c ace2 = new Ace_Customer_Core_Changes__c(name = 'Test',CoreID__c = 'CL-9492090', ACE_Customer_Price_Changes__c = ace1.id);
        insert ace2;

        Ace_Customer_Core_Changes__c ace21 = new Ace_Customer_Core_Changes__c(name = 'Test',CoreID__c = 'CL-9492091', ACE_Customer_Price_Changes__c = ace.id);
        insert ace21;

        Ace_Customer_Core_Changes__c ace22 = new Ace_Customer_Core_Changes__c(name = 'Test',CoreID__c = 'CL-9492092', ACE_Customer_Price_Changes__c = ace12.id);
        insert ace22;

        Ace_Customer_SKU_Changes__c ace3 = new Ace_Customer_SKU_Changes__c(Approval_status__c = 'Pending',price_Changes_Type__c='A',Status__c='Active',SKU__c = '158849',name='158849',CoreList_ID__c='CL-9492090', Ace_Customer_Core_Changes__c = ace2.id);
        insert ace3;

        Ace_Customer_SKU_Changes__c ace31 = new Ace_Customer_SKU_Changes__c(DSM__c = mgruser.id,Approval_Type__c = 1,Approval_status__c = 'Pending',price_Changes_Type__c='A',Status__c='Active',SKU__c = '158859',name='158859',CoreList_ID__c='CL-9492091', Ace_Customer_Core_Changes__c = ace21.id);
        insert ace31;

        Ace_Customer_SKU_Changes__c ace32 = new Ace_Customer_SKU_Changes__c(Current_Sell_Price__c=5.5,Approved_Proposed_Price__c=20.5,DSM__c = mgruser.id,Approval_Type__c = 1,Approval_status__c = 'Pending',price_Changes_Type__c='A',Status__c='Active',SKU__c = '158858',name='158858',CoreList_ID__c='CL-9492092', Ace_Customer_Core_Changes__c = ace22.id);
        insert ace32;
        
    test.starttest();
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setSubmitterId(user.Id); 
        req1.setComments('Submitting request for approval.');
        req1.setObjectId(ace1.id);
        
        Approval.ProcessResult result1 = Approval.process(req1);
        system.runas(mgruser){
        itemsToApprove test = new itemsToApprove();
        test.passthruCustID = ace1.id;
        test.passThruId = ace32.id;
        test.custdueFilter = 'PastDue';
        test.type='Price';
        test.ApproveFunc();
        test.CancelFunc();
        test.PriceType = 'Date';
        test.type='Price';
        test.UnlockComments = 'test';
        test.ApproveFunc();
        test.CancelFunc();
        test.PriceType = 'Price';
        test.type='Date';
        test.UnlockComments = 'test';
        test.RejectFunc();        
        test.AssignFunc();
        itemsToApprove.wrapperAppPendList wrap = new itemsToApprove.wrapperAppPendList();
        test.custdueFilterLogic();
        test.getDisablePrevious1();
        test.getDisableNext1();
        test.nextbtn();
        test.prevbtn();
        itemsToApprove.skuListTable wrap1 = new itemsToApprove.skuListTable();
        test.nextPage();
        test.prevPage();
        test.getDisablePrevious();
        test.getDisableNext();
        test.dueFilterLogic();
        test.approvePriceWithChange();
        test.updateDate();
        test.approveDateWithChange();
        test.dueFilter = 'PastDue';
        test.passthruCustID = ace12.id;
        //test.dueFilterLogic();
        test.custid = ace32.id;
        test.priceVal = '12.20';
        test.approvePriceWithChange();
        test.UIList1[0].isSelected = true;
        test.approveDateBulk();
        }
    test.stoptest();
    }
/*
    static testMethod void myTest3() 
    {

        Profile p = [select id from Profile where name='System Administrator' limit 1];
               
        User mgruser = new User(TimeZoneSidKey='America/Los_Angeles',ProfileId = p.id,LastName = 'ACE', FirstName = 'Manager', Email = 'ACE.manager@officedepot.com',Username ='ACE.manager@officedepot.com', Alias='test', CommunityNickname='test Approver', LanguageLocaleKey='en_US', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', OD_Employee_ID__c='653466');
        Insert mgruser;

        User user = new User(TimeZoneSidKey='America/Los_Angeles',ProfileId = p.id,LastName = 'Rep', FirstName = 'ACE',Email='Rep.ACE@officedepot.com', Username ='Rep.ACE@officedepot.com', Alias='test12', CommunityNickname='test Approve', LanguageLocaleKey='en_US', EmailEncodingKey='UTF-8', LocaleSidKey='en_US',OD_Employee_ID__c='653486');
        Insert user;

         ACE_Settings__c desettings = new ACE_Settings__c(ApprovalDays__c = 1);
         insert desettings; 

        Account acc = new Account ();
        acc.name = 'SUN Test Account';
        acc.BillingStreet = '1040 N 326 W';
        acc.billingcity = 'Orem';
        acc.BillingState = 'UT';
        acc.Billingcountry = 'USA';
        acc.Oracle_Party_Id__c = '123456';
        acc.AOPS_Cust_Id__c = '123456';
        acc.AOPS_Seq_ID__c = '123456';
        insert acc;


         ACE_Customer_Price_Changes__c ace = new ACE_Customer_Price_Changes__c(
                                                Owning_Customer_Legal__c='T',
                                                name='Q4-2014',
                                                SRM_Differential__c=5,
                                                Item_12_Month_Qty__c = 50,
                                                Total_Spend_Impact_12_Month__c=5,
                                                Customer__c = acc.id, 
                                                Owning_Customer_ID__c ='123456',
                                                Approval_Type__c = 1,
                                                DSM__c = mgruser.id, 
                                                Record_Unlock_Status__c = 'Approved',
                                                SFDC_Notification_Flag__c = '3');
         insert ace;
         
         ACE_Customer_Price_Changes__c ace12 = new ACE_Customer_Price_Changes__c(
                                                Owning_Customer_Legal__c='T',
                                                name='Q4-2014',
                                                SRM_Differential__c=5,
                                                Item_12_Month_Qty__c = 50,
                                                Total_Spend_Impact_12_Month__c=5,
                                                Customer__c = acc.id, 
                                                Owning_Customer_ID__c ='123456',
                                                Approval_Type__c = 1,
                                                DSM__c = mgruser.id, 
                                                Record_Unlock_Status__c = 'Pending',
                                                SFDC_Notification_Flag__c = '3');
         insert ace12;

         ACE_Customer_Price_Changes__c ace1 = new ACE_Customer_Price_Changes__c(
                                                Owning_Customer_Legal__c='T',
                                                name='Q4-2014',
                                                SRM_Differential__c=5,
                                                Item_12_Month_Qty__c = 50,
                                                Total_Spend_Impact_12_Month__c=5,
                                                Customer__c = acc.id, 
                                                Owning_Customer_ID__c ='123456',
                                                Approval_Type__c = 1,
                                                DSM__c = mgruser.id, 
                                                VP__c = mgruser.id,
                                                RSD__c = mgruser.id,
                                                L3_Mgr_Approval_Start_Date__c = system.today()+4,
                                                L2_Mgr_Approval_Start_Date__c = system.today()+3,
                                                L1_Mgr_Approval_Start_Date__c = system.today()+2,
                                                Record_Unlock_Status__c = 'Pending',
                                                SFDC_Notification_Flag__c = '3');
         insert ace1;

        Ace_Customer_Core_Changes__c ace2 = new Ace_Customer_Core_Changes__c(name = 'Test',CoreID__c = 'CL-9492090', ACE_Customer_Price_Changes__c = ace1.id);
        insert ace2;

        Ace_Customer_Core_Changes__c ace21 = new Ace_Customer_Core_Changes__c(name = 'Test',CoreID__c = 'CL-9492091', ACE_Customer_Price_Changes__c = ace.id);
        insert ace21;

        Ace_Customer_Core_Changes__c ace22 = new Ace_Customer_Core_Changes__c(name = 'Test',CoreID__c = 'CL-9492092', ACE_Customer_Price_Changes__c = ace12.id);
        insert ace22;

        Ace_Customer_SKU_Changes__c ace3 = new Ace_Customer_SKU_Changes__c(Approval_status__c = 'Pending',price_Changes_Type__c='A',Status__c='Active',SKU__c = '158849',name='158849',CoreList_ID__c='CL-9492090', Ace_Customer_Core_Changes__c = ace2.id);
        insert ace3;

        Ace_Customer_SKU_Changes__c ace31 = new Ace_Customer_SKU_Changes__c(DSM__c = mgruser.id,Approval_Type__c = 1,Approval_status__c = 'Pending',price_Changes_Type__c='A',Status__c='Active',SKU__c = '158859',name='158859',CoreList_ID__c='CL-9492091', Ace_Customer_Core_Changes__c = ace21.id);
        insert ace31;

        Ace_Customer_SKU_Changes__c ace32 = new Ace_Customer_SKU_Changes__c(Current_Sell_Price__c=5.5,Approved_Proposed_Price__c=20.5,DSM__c = mgruser.id,Approval_Type__c = 1,Approval_status__c = 'Pending',price_Changes_Type__c='A',Status__c='Active',SKU__c = '158858',name='158858',CoreList_ID__c='CL-9492092', Ace_Customer_Core_Changes__c = ace22.id);
        insert ace32;
        
        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        req.setSubmitterId(user.Id); 
        req.setComments('Submitting request for approval.');
        req.setObjectId(ace31.id);
        
        Approval.ProcessResult result = Approval.process(req);
        
    test.starttest();
        system.runas(mgruser){
        itemsToApprove test = new itemsToApprove();
        test.passthruCustID = ace1.id;
        test.passThruId = ace32.id;
        test.custdueFilter = 'PastDue';
        test.type='Price';
        test.ApproveFunc();
        test.CancelFunc();
        test.PriceType = 'Date';
        test.type='Price';
        test.UnlockComments = 'test';
        test.ApproveFunc();
        test.CancelFunc();
        test.PriceType = 'Price';
        test.type='Date';
        test.UnlockComments = 'test';
        test.RejectFunc();        
        test.AssignFunc();
        itemsToApprove.wrapperAppPendList wrap = new itemsToApprove.wrapperAppPendList();
        test.custdueFilterLogic();
        test.getDisablePrevious1();
        test.getDisableNext1();
        test.nextbtn();
        test.prevbtn();
        itemsToApprove.skuListTable wrap1 = new itemsToApprove.skuListTable();
        test.nextPage();
        test.prevPage();
        test.getDisablePrevious();
        test.getDisableNext();
        test.dueFilterLogic();
        test.approvePriceWithChange();
        test.updateDate();
        test.approveDateWithChange();
        test.dueFilter = 'PastDue';
        test.passthruCustID = ace12.id;
        //test.dueFilterLogic();
        test.custid = ace32.id;
        test.priceVal = '12.20';
        test.approvePriceWithChange();
        }
    test.stoptest();
    }
*/
    }
    static testMethod void myTestClassDeclarCoverage() {
 System.runas(new user(ID = UserInfo.getUserID())){
        Profile p = [select id from Profile where name = 'System Administrator' limit 1];

        User mgruser = new User(TimeZoneSidKey = 'America/Los_Angeles', ProfileId = p.id, LastName = 'ACE', FirstName = 'Manager', Email = 'ACE.manager@officedepot.com', Username = 'ACE.manager@officedepot.com', Alias = 'test', CommunityNickname = 'test Approver', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', EmailEncodingKey = 'UTF-8', OD_Employee_ID__c = '653466');
        Insert mgruser;

        User user = new User(TimeZoneSidKey = 'America/Los_Angeles', ProfileId = p.id, LastName = 'Rep', FirstName = 'ACE', Email = 'Rep.ACE@officedepot.com', Username = 'Rep.ACE@officedepot.com', Alias = 'test12', CommunityNickname = 'test Approve', LanguageLocaleKey = 'en_US', EmailEncodingKey = 'UTF-8', LocaleSidKey = 'en_US', OD_Employee_ID__c = '653486');
        Insert user;

        ACE_Settings__c desettings = new ACE_Settings__c(ApprovalDays__c = 1);
        insert desettings;

        Account acc = new Account();
        acc.name = 'SUN Test Account';
        acc.BillingStreet = '1040 N 326 W';
        acc.billingcity = 'Orem';
        acc.BillingState = 'UT';
        acc.Billingcountry = 'USA';
        acc.Oracle_Party_Id__c = '123456';
        acc.AOPS_Cust_Id__c = '123456';
        acc.AOPS_Seq_ID__c = '123456';
        insert acc;


        ACE_Customer_Price_Changes__c ace = new ACE_Customer_Price_Changes__c(
                Owning_Customer_Legal__c = 'T',
                name = 'Q4-2014',
                SRM_Differential__c = 5,
                Item_12_Month_Qty__c = 50,
                Total_Spend_Impact_12_Month__c = 5,
                Customer__c = acc.id,
                Owning_Customer_ID__c = '123456',
                Approval_Type__c = 1,
                DSM__c = mgruser.id,
                Record_Unlock_Status__c = 'Approved',
                SFDC_Notification_Flag__c = '3');
        insert ace;

        ACE_Customer_Price_Changes__c ace12 = new ACE_Customer_Price_Changes__c(
                Owning_Customer_Legal__c = 'T',
                name = 'Q4-2014',
                SRM_Differential__c = 5,
                Item_12_Month_Qty__c = 50,
                Total_Spend_Impact_12_Month__c = 5,
                Customer__c = acc.id,
                Owning_Customer_ID__c = '123456',
                Approval_Type__c = 1,
                DSM__c = mgruser.id,
                Record_Unlock_Status__c = 'Pending',
                SFDC_Notification_Flag__c = '3');
        insert ace12;

        ACE_Customer_Price_Changes__c ace1 = new ACE_Customer_Price_Changes__c(
                Owning_Customer_Legal__c = 'T',
                name = 'Q4-2014',
                SRM_Differential__c = 5,
                Item_12_Month_Qty__c = 50,
                Total_Spend_Impact_12_Month__c = 5,
                Customer__c = acc.id,
                Owning_Customer_ID__c = '123456',
                Approval_Type__c = 1,
                DSM__c = mgruser.id,
                VP__c = mgruser.id,
                RSD__c = mgruser.id,
                L3_Mgr_Approval_Start_Date__c = system.today() + 4,
                L2_Mgr_Approval_Start_Date__c = system.today() + 3,
                L1_Mgr_Approval_Start_Date__c = system.today() + 2,
                Record_Unlock_Status__c = 'Pending',
                SFDC_Notification_Flag__c = '3');
        insert ace1;

        Ace_Customer_Core_Changes__c ace2 = new Ace_Customer_Core_Changes__c(name = 'Test', CoreID__c = 'CL-9492090', ACE_Customer_Price_Changes__c = ace1.id);
        insert ace2;

        Ace_Customer_Core_Changes__c ace21 = new Ace_Customer_Core_Changes__c(name = 'Test', CoreID__c = 'CL-9492091', ACE_Customer_Price_Changes__c = ace.id);
        insert ace21;

        Ace_Customer_Core_Changes__c ace22 = new Ace_Customer_Core_Changes__c(name = 'Test', CoreID__c = 'CL-9492092', ACE_Customer_Price_Changes__c = ace12.id);
        insert ace22;

        Ace_Customer_SKU_Changes__c ace3 = new Ace_Customer_SKU_Changes__c(Approval_status__c = 'Pending', price_Changes_Type__c = 'A', Status__c = 'Active', SKU__c = '158849', name = '158849', CoreList_ID__c = 'CL-9492090', Ace_Customer_Core_Changes__c = ace2.id);
        insert ace3;

        Ace_Customer_SKU_Changes__c ace31 = new Ace_Customer_SKU_Changes__c(DSM__c = mgruser.id, Approval_Type__c = 1, Approval_status__c = 'Pending', price_Changes_Type__c = 'A', Status__c = 'Active', SKU__c = '158859', name = '158859', CoreList_ID__c = 'CL-9492091', Ace_Customer_Core_Changes__c = ace21.id);
        insert ace31;

        Ace_Customer_SKU_Changes__c ace32 = new Ace_Customer_SKU_Changes__c(Current_Sell_Price__c = 5.5, Approved_Proposed_Price__c = 20.5, DSM__c = mgruser.id, Approval_Type__c = 1, Approval_status__c = 'Pending', price_Changes_Type__c = 'A', Status__c = 'Active', SKU__c = '158858', name = '158858', CoreList_ID__c = 'CL-9492092', Ace_Customer_Core_Changes__c = ace22.id);
        insert ace32;

        test.starttest();
     	Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setSubmitterId(user.Id);
        req1.setComments('Submitting request for approval.');
        req1.setObjectId(ace1.id);

        Approval.ProcessResult result1 = Approval.process(req1);
        system.runas(mgruser) {
            itemsToApprove test = new itemsToApprove();
            test.passthruCustID = ace1.id;
            test.passThruId = ace32.id;
            test.custdueFilter = 'PastDue';
            test.type = 'Price';
            test.ApproveFunc();
            test.CancelFunc();
            test.PriceType = 'Date';
            test.type = 'Price';
            test.UnlockComments = 'test';
            test.ApproveFunc();
            test.CancelFunc();
            test.PriceType = 'Price';
            test.type = 'Date';
            test.UnlockComments = 'test';
            test.RejectFunc();
            test.AssignFunc();
            test.PriceType = 'Price';
            test.type = 'Price';
            test.UnlockComments = 'test';
            test.RejectFunc();
            test.AssignFunc();
            itemsToApprove.wrapperAppPendList wrap = new itemsToApprove.wrapperAppPendList();
            test.custdueFilterLogic();
            test.getDisablePrevious1();
            test.getDisableNext1();
            test.nextbtn();
            test.prevbtn();
            itemsToApprove.skuListTable wrap1 = new itemsToApprove.skuListTable();
            test.nextPage();
            test.prevPage();
            test.getDisablePrevious();
            test.getDisableNext();
            test.dueFilterLogic();
            test.approvePriceWithChange();
            test.updateDate();
            test.approveDateWithChange();
            test.dueFilter = 'PastDue';
            test.passthruCustID = ace12.id;
            //test.dueFilterLogic();
            test.custid = ace32.id;
            test.priceVal = '12.20';
            test.approvePriceWithChange();
            test.UIList1[0].isSelected = true;
            test.prevbtn();
            test.approveDateBulk();
            //Coverage for skuListTable class, just get setting, no logic.
            wrap1.SKU = '123456';
            wrap1.skuid = acc.id;
            wrap1.DESCRP = 'Test';
            wrap1.CHANGETYP = 'Test';
            wrap1.CURRPRICE = .1;
            wrap1.APPPRICE = .1;
            wrap1.PROPPRICE = .1;
            wrap1.COMMENTS = 'Test comments';
            wrap1.REVIMPACT = .1;
            wrap1.PREVIMPACT = .1;
            wrap1.TOTIMPACT = .1;
            wrap1.CUSTNAME = 'Test';
            wrap1.JS_CUSTNAME = 'Test';
            wrap1.REPNAME = 'Test';
            wrap1.CHANGERED = false;
            wrap1.linkvisible = false;
            wrap.dateCheckboxDisabled = false;
            wrap.CheckSKU = false;
            wrap.DATETYPE = false;
            wrap.APPREJ = 'Test';
            test.total_size = 0;
            test.redirectURL = 'test';
            test.pchangeOb = new ACE_Customer_Price_Changes__c();

        }
        test.stoptest();
    }
    }
    //Test for RevImpact
    static testMethod void myTestRevImpact() {
 System.runas(new user(ID = UserInfo.getUserID())){
       Profile p = [select id from Profile where name='System Administrator' limit 1];
               
        User mgruser = new User(TimeZoneSidKey='America/Los_Angeles',ProfileId = p.id,LastName = 'ACE', FirstName = 'Manager', Email = 'ACE.manager@officedepot.com',Username ='ACE.manager@officedepot.com', Alias='test', CommunityNickname='test Approver', LanguageLocaleKey='en_US', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', OD_Employee_ID__c='653466');
        Insert mgruser;

        User user = new User(TimeZoneSidKey='America/Los_Angeles',ProfileId = p.id,LastName = 'Rep', FirstName = 'ACE',Email='Rep.ACE@officedepot.com', Username ='Rep.ACE@officedepot.com', Alias='test12', CommunityNickname='test Approve', LanguageLocaleKey='en_US', EmailEncodingKey='UTF-8', LocaleSidKey='en_US',OD_Employee_ID__c='653486');
        Insert user;

         ACE_Settings__c desettings = new ACE_Settings__c(ApprovalDays__c = 1);
         insert desettings; 

        Account acc = new Account ();
        acc.name = 'SUN Test Account';
        acc.BillingStreet = '1040 N 326 W';
        acc.billingcity = 'Orem';
        acc.BillingState = 'UT';
        acc.Billingcountry = 'USA';
        acc.Oracle_Party_Id__c = '123456';
        acc.AOPS_Cust_Id__c = '123456';
        acc.AOPS_Seq_ID__c = '123456';
        insert acc;


         ACE_Customer_Price_Changes__c ace = new ACE_Customer_Price_Changes__c(
                                                Owning_Customer_Legal__c='T',
                                                name='Q4-2014',
                                                SRM_Differential__c=5,
                                                Item_12_Month_Qty__c = 50,
                                                Total_Spend_Impact_12_Month__c=5,
                                                Customer__c = acc.id, 
                                                Owning_Customer_ID__c ='123456',
                                                Approval_Type__c = 1,
                                                DSM__c = mgruser.id, 
                                                Record_Unlock_Status__c = 'Approved',
                                                SFDC_Notification_Flag__c = '3',
     											OD_Revenue_Impact__c = null);
         insert ace;
         
         ACE_Customer_Price_Changes__c ace12 = new ACE_Customer_Price_Changes__c(
                                                Owning_Customer_Legal__c='T',
                                                name='Q4-2014',
                                                SRM_Differential__c=5,
                                                Item_12_Month_Qty__c = 50,
                                                Total_Spend_Impact_12_Month__c=5,
                                                Customer__c = acc.id, 
                                                Owning_Customer_ID__c ='123456',
                                                Approval_Type__c = 1,
                                                DSM__c = mgruser.id, 
                                                Record_Unlock_Status__c = 'Pending',
                                                SFDC_Notification_Flag__c = '3');
         insert ace12;

         ACE_Customer_Price_Changes__c ace1 = new ACE_Customer_Price_Changes__c(
                                                Owning_Customer_Legal__c='T',
                                                name='Q4-2014',
                                                SRM_Differential__c=5,
                                                Item_12_Month_Qty__c = 50,
                                                Total_Spend_Impact_12_Month__c=5,
                                                Customer__c = acc.id, 
                                                Owning_Customer_ID__c ='123456',
                                                Approval_Type__c = 1,
                                                DSM__c = mgruser.id, 
                                                VP__c = mgruser.id,
                                                RSD__c = mgruser.id,
                                                L3_Mgr_Approval_Start_Date__c = system.today()+4,
                                                L2_Mgr_Approval_Start_Date__c = system.today()+3,
                                                L1_Mgr_Approval_Start_Date__c = system.today()+2,
                                                Record_Unlock_Status__c = 'Pending',
                                                SFDC_Notification_Flag__c = '3');
         insert ace1;

        Ace_Customer_Core_Changes__c ace2 = new Ace_Customer_Core_Changes__c(name = 'Test',CoreID__c = 'CL-9492090', ACE_Customer_Price_Changes__c = ace1.id);
        insert ace2;

        Ace_Customer_Core_Changes__c ace21 = new Ace_Customer_Core_Changes__c(name = 'Test',CoreID__c = 'CL-9492091', ACE_Customer_Price_Changes__c = ace.id);
        insert ace21;

        Ace_Customer_Core_Changes__c ace22 = new Ace_Customer_Core_Changes__c(name = 'Test',CoreID__c = 'CL-9492092', ACE_Customer_Price_Changes__c = ace12.id);
        insert ace22;

        Ace_Customer_SKU_Changes__c ace3 = new Ace_Customer_SKU_Changes__c(Approval_status__c = 'Pending',price_Changes_Type__c='A',Status__c='Active',SKU__c = '158849',name='158849',CoreList_ID__c='CL-9492090', Ace_Customer_Core_Changes__c = ace2.id);
        insert ace3;

        Ace_Customer_SKU_Changes__c ace31 = new Ace_Customer_SKU_Changes__c(DSM__c = mgruser.id,Approval_Type__c = 1,Approval_status__c = 'Pending',price_Changes_Type__c='A',Status__c='Active',SKU__c = '158859',name='158859',CoreList_ID__c='CL-9492091', Ace_Customer_Core_Changes__c = ace21.id);
        insert ace31;

        Ace_Customer_SKU_Changes__c ace32 = new Ace_Customer_SKU_Changes__c(Current_Sell_Price__c=5.5,Approved_Proposed_Price__c=20.5,DSM__c = mgruser.id,Approval_Type__c = 1,Approval_status__c = 'Pending',price_Changes_Type__c='A',Status__c='Active',SKU__c = '158858',name='158858',CoreList_ID__c='CL-9492092', Ace_Customer_Core_Changes__c = ace22.id);
        insert ace32;
        
    test.starttest();
     	Approval.ProcessSubmitRequest req11 = new Approval.ProcessSubmitRequest();
        req11.setSubmitterId(user.Id); 
        req11.setComments('Submitting request for approval.');
        req11.setObjectId(ace.id);
        
        Approval.ProcessResult result11 = Approval.process(req11);
        system.runas(mgruser){
        itemsToApprove test = new itemsToApprove();
        test.passthruCustID = ace1.id;
        test.passThruId = ace32.id;
        test.custdueFilter = 'PastDue';
        test.type='Price';
        test.ApproveFunc();
        test.CancelFunc();
        test.PriceType = 'Date';
        test.type='Price';
        test.UnlockComments = 'test';
        test.ApproveFunc();
        test.CancelFunc();
        test.PriceType = 'Price';
        test.type='Date';
        test.UnlockComments = 'test';
        test.RejectFunc();        
        test.AssignFunc();
        itemsToApprove.wrapperAppPendList wrap = new itemsToApprove.wrapperAppPendList();
        test.custdueFilterLogic();
        test.getDisablePrevious1();
        test.getDisableNext1();
        test.nextbtn();
        test.prevbtn();
        itemsToApprove.skuListTable wrap1 = new itemsToApprove.skuListTable();
        test.nextPage();
        test.prevPage();
        test.getDisablePrevious();
        test.getDisableNext();
        test.dueFilterLogic();
        test.approvePriceWithChange();
        test.updateDate();
        test.approveDateWithChange();
        test.dueFilter = 'PastDue';
        test.passthruCustID = ace12.id;
        //test.dueFilterLogic();
        test.custid = ace32.id;
        test.priceVal = '12.20';
        test.approvePriceWithChange();
        wrap1.ts = ace32;
        test.clsSKUListTable.add(wrap1);
        test.clsSKUListTable[0].isselected = true;
        for(Integer a = 0; a < test.clsSKUListTable.size(); a++){
  		test.clsSKUListTable[a].isSelected = true;
		}
        test.approvePriceBulk();
        test.disablebtn();
        }
    test.stoptest();
    }
    }
    
    static testMethod void testsUI() {
 System.runas(new user(ID = UserInfo.getUserID())){
       Profile p = [select id from Profile where name='System Administrator' limit 1];
               
        User mgruser = new User(TimeZoneSidKey='America/Los_Angeles',ProfileId = p.id,LastName = 'ACE', FirstName = 'Manager', Email = 'ACE.manager@officedepot.com',Username ='ACE.manager@officedepot.com', Alias='test', CommunityNickname='test Approver', LanguageLocaleKey='en_US', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', OD_Employee_ID__c='653466');
        Insert mgruser;

        User user = new User(TimeZoneSidKey='America/Los_Angeles',ProfileId = p.id,LastName = 'Rep', FirstName = 'ACE',Email='Rep.ACE@officedepot.com', Username ='Rep.ACE@officedepot.com', Alias='test12', CommunityNickname='test Approve', LanguageLocaleKey='en_US', EmailEncodingKey='UTF-8', LocaleSidKey='en_US',OD_Employee_ID__c='653486');
        Insert user;

         ACE_Settings__c desettings = new ACE_Settings__c(ApprovalDays__c = 1);
         insert desettings; 

        Account acc = new Account ();
        acc.name = 'SUN Test Account';
        acc.BillingStreet = '1040 N 326 W';
        acc.billingcity = 'Orem';
        acc.BillingState = 'UT';
        acc.Billingcountry = 'USA';
        acc.Oracle_Party_Id__c = '123456';
        acc.AOPS_Cust_Id__c = '123456';
        acc.AOPS_Seq_ID__c = '123456';
        insert acc;


         ACE_Customer_Price_Changes__c ace = new ACE_Customer_Price_Changes__c(
                                                Owning_Customer_Legal__c='T',
                                                name='Q4-2014',
                                                SRM_Differential__c=5,
                                                Item_12_Month_Qty__c = 50,
                                                Total_Spend_Impact_12_Month__c=5,
                                                Customer__c = acc.id, 
                                                Owning_Customer_ID__c ='123456',
                                                Approval_Type__c = 1,
                                                DSM__c = mgruser.id, 
                                                Record_Unlock_Status__c = 'Approved',
                                                SFDC_Notification_Flag__c = '3',
     											OD_Revenue_Impact__c = null);
         insert ace;
         
         ACE_Customer_Price_Changes__c ace12 = new ACE_Customer_Price_Changes__c(
                                                Owning_Customer_Legal__c='T',
                                                name='Q4-2014',
                                                SRM_Differential__c=5,
                                                Item_12_Month_Qty__c = 50,
                                                Total_Spend_Impact_12_Month__c=5,
                                                Customer__c = acc.id, 
                                                Owning_Customer_ID__c ='123456',
                                                Approval_Type__c = 1,
                                                DSM__c = mgruser.id, 
                                                Record_Unlock_Status__c = 'Pending',
                                                SFDC_Notification_Flag__c = '3');
         insert ace12;

         ACE_Customer_Price_Changes__c ace1 = new ACE_Customer_Price_Changes__c(
                                                Owning_Customer_Legal__c='T',
                                                name='Q4-2014',
                                                SRM_Differential__c=5,
                                                Item_12_Month_Qty__c = 50,
                                                Total_Spend_Impact_12_Month__c=5,
                                                Customer__c = acc.id, 
                                                Owning_Customer_ID__c ='123456',
                                                Approval_Type__c = 1,
                                                DSM__c = mgruser.id, 
                                                VP__c = mgruser.id,
                                                RSD__c = mgruser.id,
                                                L3_Mgr_Approval_Start_Date__c = system.today()+4,
                                                L2_Mgr_Approval_Start_Date__c = system.today()+3,
                                                L1_Mgr_Approval_Start_Date__c = system.today()+2,
                                                Record_Unlock_Status__c = 'Pending',
                                                SFDC_Notification_Flag__c = '3');
         insert ace1;

        Ace_Customer_Core_Changes__c ace2 = new Ace_Customer_Core_Changes__c(name = 'Test',CoreID__c = 'CL-9492090', ACE_Customer_Price_Changes__c = ace1.id);
        insert ace2;

        Ace_Customer_Core_Changes__c ace21 = new Ace_Customer_Core_Changes__c(name = 'Test',CoreID__c = 'CL-9492091', ACE_Customer_Price_Changes__c = ace.id);
        insert ace21;

        Ace_Customer_Core_Changes__c ace22 = new Ace_Customer_Core_Changes__c(name = 'Test',CoreID__c = 'CL-9492092', ACE_Customer_Price_Changes__c = ace12.id);
        insert ace22;

        Ace_Customer_SKU_Changes__c ace3 = new Ace_Customer_SKU_Changes__c(Approval_status__c = 'Pending',price_Changes_Type__c='A',Status__c='Active',SKU__c = '158849',name='158849',CoreList_ID__c='CL-9492090', Ace_Customer_Core_Changes__c = ace2.id,L1_Mgr_Approval_Start_Date__c = System.now() );
        insert ace3;

        Ace_Customer_SKU_Changes__c ace31 = new Ace_Customer_SKU_Changes__c(DSM__c = mgruser.id,Approval_Type__c = 1,Approval_status__c = 'Pending',price_Changes_Type__c='A',Status__c='Active',SKU__c = '158859',name='158859',CoreList_ID__c='CL-9492091', Ace_Customer_Core_Changes__c = ace21.id,L1_Mgr_Approval_Start_Date__c = System.now());
        insert ace31;

        Ace_Customer_SKU_Changes__c ace32 = new Ace_Customer_SKU_Changes__c(Current_Sell_Price__c=5.5,Approved_Proposed_Price__c=20.5,DSM__c = mgruser.id,Approval_Type__c = 1,Approval_status__c = 'Pending',price_Changes_Type__c='A',Status__c='Active',SKU__c = '158858',name='158858',CoreList_ID__c='CL-9492092', Ace_Customer_Core_Changes__c = ace22.id,L1_Mgr_Approval_Start_Date__c = System.now());
        insert ace32;
        
        
    test.starttest();
     	Approval.ProcessSubmitRequest req11 = new Approval.ProcessSubmitRequest();
        req11.setSubmitterId(user.Id); 
        req11.setComments('Submitting request for approval.');
        req11.setObjectId(ace.id);
        
        Approval.ProcessResult result11 = Approval.process(req11);
        
        system.runas(mgruser){
        itemsToApprove test = new itemsToApprove();
        test.passthruCustID = ace1.id;
        test.passThruId = ace32.id;
        test.custdueFilter = 'PastDue';
        test.type='Price';
        test.ApproveFunc();
        test.CancelFunc();
        test.PriceType = 'Date';
        test.type='Price';
        test.UnlockComments = 'test';
        test.ApproveFunc();
        test.CancelFunc();
        test.PriceType = 'Price';
        test.type='Date';
        test.UnlockComments = 'test';
        test.RejectFunc();        
        test.AssignFunc();
        itemsToApprove.wrapperAppPendList wrap = new itemsToApprove.wrapperAppPendList();
        test.custdueFilterLogic();
        test.getDisablePrevious1();
        test.getDisableNext1();
        test.nextbtn();
        test.prevbtn();
        itemsToApprove.skuListTable wrap1 = new itemsToApprove.skuListTable();
        test.nextPage();
        test.prevPage();
        test.getDisablePrevious();
        test.getDisableNext();
        test.dueFilterLogic();
        test.approvePriceWithChange();
        test.updateDate();
        test.approveDateWithChange();
        test.dueFilter = 'PastDue';
        test.passthruCustID = ace12.id;
        //test.dueFilterLogic();
        test.custid = ace32.id;
        test.priceVal = '12.20';
        test.approvePriceWithChange();
        wrap1.ts = ace32;
        test.clsSKUListTable.add(wrap1);
        //test.clsSKUListTable[0].isselected = true;
        for(Integer a = 0; a < test.clsSKUListTable.size(); a++){
  		test.clsSKUListTable[a].isSelected = true;
		}
        test.approvePriceBulk();
        test.disablebtn();
        test.UIList1[0].isSelected = true;
        test.nextbtn();
        test.dueFilter = 'PastDue';
        test.generateSKU();
        }
    test.stoptest();
    }
    }
}
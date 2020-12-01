@IsTest
private Class ACE_Site_CustomerDetails_TC{
   
    static testMethod void Test_ACE_Site_CustomerDetails_Method1(){

        Map<String,Schema.RecordTypeInfo> CaseRecType = Schema.SObjectType.Case.getRecordTypeInfosByName();
        
        ACE_Settings__c desettings = new ACE_Settings__c(Expiry_Days__c=2,EsclationDays__c=1,processing_window__c=2,BatchName__c='Q4-2014',Vendavo_Update_Start_Date__c = system.today(), Vendavo_Update_End_Date__c = system.today()+5);
        insert desettings; 

        ACE_Batches__c batches = new ACE_Batches__c(name='Q4-2014',Batch__c='Q4-2014');
        insert batches;

        Account acc = new Account (name = 'SUN Test Account',AOPS_Seq_ID__c = '123456',AOPS_Cust_Id__c = '123456',Oracle_Party_Id__c = '123456',Billingcountry = 'USA',BillingState = 'UT',BillingStreet = '1040 N 326 W',billingcity = 'Orem');
        insert acc;
        
        Contact con1 = new Contact(firstname ='test con1', lastname ='b',accountId = acc.id,email = 'test@gmail.com',role__c ='Price Change Approver');
        insert con1;
        
        Contact con2 = new Contact(firstname ='test con2',LastName = 'a' ,accountId = acc.id,email = 'test1@gmail.com',role__c ='Price Change Notification/Viewer,Price Change Approver');
        insert con2;
        
        ACE_Customer_Price_Changes__c acep3 = new ACE_Customer_Price_Changes__c(name='test',SRM_Differential__c=5,Item_12_Month_Qty__c = 50,Total_Spend_Impact_12_Month__c=5,Customer__c = acc.id, Owning_Customer_ID__c ='123456',
                                              sfdc_notification_flag__c='3',Customer_Notification_Date_Approved__c  = date.today().AddDays(-2), Remediation_Hold__c = false , Reschduled_For_Reminder__c = true,
                                              Exception_Date_Lock__c = true, Hosted_Catalog__c = true , owning_customer_legal__c = 'T',
                                              Sales_Price_Change_Effective_Date_Approv__c = date.today(), Sales_Price_Change_Effective_Date_Min__c = date.Today());
        insert acep3;
        
        Ace_Customer_Core_Changes__c aceCoreChange3 = new Ace_Customer_Core_Changes__c(name = 'Test1',CoreID__c = '123456', ACE_Customer_Price_Changes__c = acep3.id);
        insert aceCoreChange3;        

        Ace_Customer_SKU_Changes__c aceSKU3 = new Ace_Customer_SKU_Changes__c(CoreList_ID__c = '123456', SKU__c = '123456',sku_alt__c = '1234', status__c='Active',batchId__c='abc',Item_3_Month_Qty__c=12.12,Item_6_Month_Qty__c=12.12,Item_9_Month_Qty__c=12.12,Item_6_Month_Sales__c=12.12,Item_3_Month_Sales__c=12.12,
        Item_9_Month_Sales__c=12.12,Total_Spend_Impact_3_Month__c=12.12,Total_Spend_Impact_6_Month__c=12.12,Total_Spend_Impact_9_Month__c=12.12,Item_12_Month_Qty__c = 50,Item_12_Month_Sales__c=12.12,Total_Spend_Impact_12_Month__c=123.12,name='test'
        , Ace_Customer_Core_Changes__c = aceCoreChange3.id,approval_status__c = 'Pending', update_timing_action__c = 'T',Approved_Proposed_Price__c = 25,
                                                                               Proposed_Price_with_Cap__c=30);
        insert aceSKU3 ;
        
        ACE_Vendavo_SKU_Prices__c acevdoskuprice = new ACE_Vendavo_SKU_Prices__c(Identifier__c= '123456123456', CoreList_ID__c = '1234567', SKU__c='123456', Vendavo_Price__c = 19.34 );
        insert acevdoskuprice;

        Test.startTest();
        Case WRFCase = new Case();
        WRFCase.RecordTypeId =CaseRecType.get('Work Request').getRecordTypeId();
        WRFCase.Status='New';
        WRFCase.WRF_Submission_Issue__c='Complete and Accurate';
        WRFCase.WRF_Request_Type__c='Automatic Toner Replenishment (ATR)';
        WRFCase.Customer_Core_Price_Changes__c=acep3.id;
        WRFCase.WRF_Request_Type__c = 'BSD Pricing';
        WRFCase.accountId = acc.id;    //00175758 ----Hitesh[Aug 09, 2016]
        insert WRFCase;
        
        
         integer batch_size = 10;
         ACE_Site_CustomerDetails aceBatch = new ACE_Site_CustomerDetails();
         database.executebatch(aceBatch,batch_size);
         Test.stopTest();
         String CRON_EXP = '0 0 0 3 9 ? 2022';
         System.schedule('TestBatch1',CRON_EXP , aceBatch );        
    }   
    
//mm        
    static testMethod void Test_ACE_Site_CustomerDetails_Method2(){

        Map<String,Schema.RecordTypeInfo> CaseRecType = Schema.SObjectType.Case.getRecordTypeInfosByName();
        
        ACE_Settings__c desettings = new ACE_Settings__c(Expiry_Days__c=2,EsclationDays__c=1,processing_window__c=2,BatchName__c='Q4-2014',Vendavo_Update_Start_Date__c = system.today(), Vendavo_Update_End_Date__c = system.today()+5);
        insert desettings; 

        ACE_Batches__c batches = new ACE_Batches__c(name='Q4-2014',Batch__c='Q4-2014');
        insert batches;

        Account acc = new Account (name = 'SUN Test Account',AOPS_Seq_ID__c = '123456',AOPS_Cust_Id__c = '123456',Oracle_Party_Id__c = '123456',Billingcountry = 'USA',BillingState = 'UT',BillingStreet = '1040 N 326 W',billingcity = 'Orem');
        insert acc;
        
        Contact con1 = new Contact(firstname ='test con1', lastname ='b',accountId = acc.id,email = 'test@gmail.com',role__c ='Price Change Approver');
        insert con1;
        
        Contact con2 = new Contact(firstname ='test con2',LastName = 'a' ,accountId = acc.id,email = 'test1@gmail.com',role__c ='Price Change Notification/Viewer,Price Change Approver');
        insert con2;
       
        ACE_Customer_Price_Changes__c acep4 = new ACE_Customer_Price_Changes__c(name='test',SRM_Differential__c=5,Item_12_Month_Qty__c = 50,Total_Spend_Impact_12_Month__c=5,Customer__c = acc.id, Owning_Customer_ID__c ='123457',
                                              sfdc_notification_flag__c='2',Customer_Notification_Date_Approved__c  = date.today().AddDays(-2), Remediation_Hold__c = false , Reschduled_For_Reminder__c = true,
                                              Exception_Date_Lock__c = true, Hosted_Catalog__c = true , owning_customer_legal__c = 'T',
                                              Sales_Price_Change_Effective_Date_Approv__c = date.today(), Sales_Price_Change_Effective_Date_Min__c = date.Today());
        insert acep4;     
       
        Ace_Customer_Core_Changes__c aceCoreChange4 = new Ace_Customer_Core_Changes__c(name = 'Test2',CoreID__c = '123457', ACE_Customer_Price_Changes__c = acep4.id);
        insert aceCoreChange4;
        
        Ace_Customer_SKU_Changes__c aceSKU4 = new Ace_Customer_SKU_Changes__c(CoreList_ID__c = '123457', SKU__c = '123457', price_changes_type__c = 'D', batchId__c='abc',
        name='test', Ace_Customer_Core_Changes__c = aceCoreChange4.id);
        insert aceSKU4 ;
        
        ACE_Vendavo_SKU_Prices__c acevdoskuprice = new ACE_Vendavo_SKU_Prices__c(Identifier__c= '123457123457', CoreList_ID__c = '1234578', SKU__c='123457', Vendavo_Price__c = 19.34 );
        insert acevdoskuprice;
        
        Test.startTest();
        integer batch_size = 10;
        ACE_Site_CustomerDetails aceBatch = new ACE_Site_CustomerDetails();
        database.executebatch(aceBatch,batch_size);
        Test.stopTest();
        String CRON_EXP = '0 0 0 3 9 ? 2022';
        System.schedule('TestBatch1',CRON_EXP , aceBatch );     
        
}
        static testMethod void Test_ACE_Site_CustomerDetails_Method3(){

        Map<String,Schema.RecordTypeInfo> CaseRecType = Schema.SObjectType.Case.getRecordTypeInfosByName();
        
        ACE_Settings__c desettings = new ACE_Settings__c(Expiry_Days__c=2,EsclationDays__c=1,processing_window__c=2,BatchName__c='Q4-2014',Vendavo_Update_Start_Date__c = system.today(), Vendavo_Update_End_Date__c = system.today()+5);
        insert desettings; 

        ACE_Batches__c batches = new ACE_Batches__c(name='Q4-2014',Batch__c='Q4-2014');
        insert batches;

        Account acc = new Account (name = 'SUN Test Account',AOPS_Seq_ID__c = '123456',AOPS_Cust_Id__c = '123452',Oracle_Party_Id__c = '123452',Billingcountry = 'USA',BillingState = 'UT',BillingStreet = '1040 N 326 W',billingcity = 'Orem');
        insert acc;
        
        Contact con1 = new Contact(firstname ='test con1', lastname ='b',accountId = acc.id,email = 'test@gmail.com',role__c ='Price Change Approver');
        insert con1;
        
        Contact con2 = new Contact(firstname ='test con2',LastName = 'a' ,accountId = acc.id,email = 'test1@gmail.com',role__c ='Price Change Notification/Viewer,Price Change Approver');
        insert con2;
          
        ACE_Customer_Price_Changes__c acep5 = new ACE_Customer_Price_Changes__c(name='test',SRM_Differential__c=5,Item_12_Month_Qty__c = 50,Total_Spend_Impact_12_Month__c=5,Customer__c = acc.id, Owning_Customer_ID__c ='123452',
                                              sfdc_notification_flag__c='1',Customer_Notification_Date_Approved__c  = date.today().AddDays(-2), Remediation_Hold__c = false , Reschduled_For_Reminder__c = true,
                                              Exception_Date_Lock__c = true, Hosted_Catalog__c = true , owning_customer_legal__c = 'T',
                                              Sales_Price_Change_Effective_Date_Approv__c = date.today(), Sales_Price_Change_Effective_Date_Min__c = date.Today());
        insert acep5;            
       
        Ace_Customer_Core_Changes__c aceCoreChange5 = new Ace_Customer_Core_Changes__c(name = 'Test2',CoreID__c = '123452', ACE_Customer_Price_Changes__c = acep5.id);
        insert aceCoreChange5;
           
        Ace_Customer_SKU_Changes__c aceSKU5 = new Ace_Customer_SKU_Changes__c(SKU__c = '123452',status__c='Active',batchId__c='abc',Item_3_Month_Qty__c=12.12,Item_6_Month_Qty__c=12.12,Item_9_Month_Qty__c=12.12,Item_6_Month_Sales__c=12.12,Item_3_Month_Sales__c=12.12,
        Total_Spend_Impact_3_Month__c=12.12,Total_Spend_Impact_6_Month__c=12.12,Total_Spend_Impact_9_Month__c=12.12,Item_12_Month_Qty__c = 50,Item_12_Month_Sales__c=12.12,Total_Spend_Impact_12_Month__c=123.12,name='test'
        , Ace_Customer_Core_Changes__c = aceCoreChange5.id,approval_status__c = 'Pending');
        insert aceSKU5 ;
            
        
            
        Test.startTest();
        integer batch_size = 10;
        ACE_Site_CustomerDetails aceBatch = new ACE_Site_CustomerDetails();
        database.executebatch(aceBatch,batch_size);
        Test.stopTest();
        String CRON_EXP = '0 0 0 3 9 ? 2022';
        System.schedule('TestBatch1',CRON_EXP , aceBatch );     
}
    
        static testMethod void Test_ACE_Site_CustomerDetails_Method4(){

        Map<String,Schema.RecordTypeInfo> CaseRecType = Schema.SObjectType.Case.getRecordTypeInfosByName();
        
        ACE_Settings__c desettings = new ACE_Settings__c(Expiry_Days__c=2,EsclationDays__c=1,processing_window__c=2,BatchName__c='Q4-2014',Vendavo_Update_Start_Date__c = system.today(), Vendavo_Update_End_Date__c = system.today()+5);
        insert desettings; 

        ACE_Batches__c batches = new ACE_Batches__c(name='Q4-2014',Batch__c='Q4-2014');
        insert batches;

        Account acc = new Account (name = 'SUN Test Account',AOPS_Seq_ID__c = '123456',AOPS_Cust_Id__c = '123459',Oracle_Party_Id__c = '123459',Billingcountry = 'USA',BillingState = 'UT',BillingStreet = '1040 N 326 W',billingcity = 'Orem');
        insert acc;
        
        Contact con1 = new Contact(firstname ='test con1', lastname ='b',accountId = acc.id,email = 'test@gmail.com',role__c ='Price Change Approver');
        insert con1;
        
        Contact con2 = new Contact(firstname ='test con2',LastName = 'a' ,accountId = acc.id,email = 'test1@gmail.com',role__c ='Price Change Notification/Viewer,Price Change Approver');
        insert con2;
            
        ACE_Customer_Price_Changes__c acep7 = new ACE_Customer_Price_Changes__c(name='test',SRM_Differential__c=5,Item_12_Month_Qty__c = 50,Total_Spend_Impact_12_Month__c=5,Customer__c = acc.id, Owning_Customer_ID__c ='123459',
                                              sfdc_notification_flag__c='1',Customer_Notification_Date_Approved__c  = date.today().AddDays(-2), Remediation_Hold__c = false , Reschduled_For_Reminder__c = true,
                                              Exception_Date_Lock__c = true, Hosted_Catalog__c = true , owning_customer_legal__c = 'T',
                                              Sales_Price_Change_Effective_Date_Approv__c = date.today(), Sales_Price_Change_Effective_Date_Min__c = date.Today());
        insert acep7;            
        
        Ace_Customer_Core_Changes__c aceCoreChange7 = new Ace_Customer_Core_Changes__c(name = 'Test2',CoreID__c = '123459', ACE_Customer_Price_Changes__c = acep7.id);
        insert aceCoreChange7;
            
        Ace_Customer_SKU_Changes__c aceSKU7 = new Ace_Customer_SKU_Changes__c(SKU__c = '123459',status__c='Active',batchId__c='abc',name='test'
        , Ace_Customer_Core_Changes__c = aceCoreChange7.id);
        insert aceSKU7 ; 
            
       
            
        Test.startTest();
        integer batch_size = 10;
        ACE_Site_CustomerDetails aceBatch = new ACE_Site_CustomerDetails();
        database.executebatch(aceBatch,batch_size);
        Test.stopTest();
        String CRON_EXP = '0 0 0 3 9 ? 2022';
        System.schedule('TestBatch1',CRON_EXP , aceBatch );     
}
    
        static testMethod void Test_ACE_Site_CustomerDetails_Method5(){

        Map<String,Schema.RecordTypeInfo> CaseRecType = Schema.SObjectType.Case.getRecordTypeInfosByName();
        
        ACE_Settings__c desettings = new ACE_Settings__c(Expiry_Days__c=2,EsclationDays__c=1,processing_window__c=2,BatchName__c='Q4-2014',Vendavo_Update_Start_Date__c = system.today(), Vendavo_Update_End_Date__c = system.today()+5);
        insert desettings; 

        ACE_Batches__c batches = new ACE_Batches__c(name='Q4-2014',Batch__c='Q4-2014');
        insert batches;

        Account acc = new Account (name = 'SUN Test Account',AOPS_Seq_ID__c = '123453',AOPS_Cust_Id__c = '123453',Oracle_Party_Id__c = '123453',Billingcountry = 'USA',BillingState = 'UT',BillingStreet = '1040 N 326 W',billingcity = 'Orem');
        insert acc;
        
        Contact con1 = new Contact(firstname ='test con1', lastname ='b',accountId = acc.id,email = 'test@gmail.com',role__c ='Price Change Approver');
        insert con1;
        
        Contact con2 = new Contact(firstname ='test con2',LastName = 'a' ,accountId = acc.id,email = 'test1@gmail.com',role__c ='Price Change Notification/Viewer,Price Change Approver');
        insert con2;
    
        ACE_Customer_Price_Changes__c acep8 = new ACE_Customer_Price_Changes__c(name='test',Customer__c = acc.id, Owning_Customer_ID__c ='123453',
                                                                                sfdc_notification_flag__c='2', Owning_Customer_Legal__c = 'T');
        insert acep8;
       
        Ace_Customer_Core_Changes__c aceCoreChange8 = new Ace_Customer_Core_Changes__c(name = 'Test2',CoreID__c = '123453', ACE_Customer_Price_Changes__c = acep8.id);
        insert aceCoreChange8;
            
        Ace_Customer_SKU_Changes__c aceSKU8 = new Ace_Customer_SKU_Changes__c(SKU__c = '123453',status__c='Inactive',batchId__c='abc',
        Item_9_Month_Sales__c=20,Total_Spend_Impact_6_Month__c=20,Total_Spend_Impact_9_Month__c=20,Item_12_Month_Qty__c = 70,Item_12_Month_Sales__c=20,Total_Spend_Impact_12_Month__c=20,name='test'
        , Ace_Customer_Core_Changes__c = aceCoreChange8.id,approval_status__c = 'Pending');
        insert aceSKU8 ;
            
       
            
        Test.startTest();
        integer batch_size = 10;
        ACE_Site_CustomerDetails aceBatch = new ACE_Site_CustomerDetails();
        database.executebatch(aceBatch,batch_size);
        Test.stopTest();
        String CRON_EXP = '0 0 0 3 9 ? 2022';
        System.schedule('TestBatch1',CRON_EXP , aceBatch );     
}
    
        static testMethod void Test_ACE_Site_CustomerDetails_Method7(){

        Map<String,Schema.RecordTypeInfo> CaseRecType = Schema.SObjectType.Case.getRecordTypeInfosByName();
        
        ACE_Settings__c desettings = new ACE_Settings__c(Expiry_Days__c=2,EsclationDays__c=1,processing_window__c=2,BatchName__c='Q4-2014',Vendavo_Update_Start_Date__c = system.today(), Vendavo_Update_End_Date__c = system.today()+5);
        insert desettings; 

        ACE_Batches__c batches = new ACE_Batches__c(name='Q4-2014',Batch__c='Q4-2014');
        insert batches;

        Account acc = new Account (name = 'SUN Test Account',AOPS_Seq_ID__c = '123454',AOPS_Cust_Id__c = '123454',Oracle_Party_Id__c = '123454',Billingcountry = 'USA',BillingState = 'UT',BillingStreet = '1040 N 326 W',billingcity = 'Orem');
        insert acc;
        
        Contact con1 = new Contact(firstname ='test con1', lastname ='b',accountId = acc.id,email = 'test@gmail.com',role__c ='Price Change Approver');
        insert con1;
        
        Contact con2 = new Contact(firstname ='test con2',LastName = 'a' ,accountId = acc.id,email = 'test1@gmail.com',role__c ='Price Change Notification/Viewer,Price Change Approver');
        insert con2;
    
        ACE_Customer_Price_Changes__c acep9 = new ACE_Customer_Price_Changes__c(name='test',Customer__c = acc.id, Owning_Customer_ID__c ='123454',
                                                                                sfdc_notification_flag__c='3', Owning_Customer_Legal__c = 'T');
        insert acep9;
        
        Ace_Customer_Core_Changes__c aceCoreChange9 = new Ace_Customer_Core_Changes__c(name = 'Test3',CoreID__c = '123454', ACE_Customer_Price_Changes__c = acep9.id);
        insert aceCoreChange9;
            
        Ace_Customer_SKU_Changes__c aceSKU9 = new Ace_Customer_SKU_Changes__c(SKU__c = '123454',status__c='Active',batchId__c='abc',
                                                                              name='test', Ace_Customer_Core_Changes__c = aceCoreChange9.id,approval_status__c = 'Approved');
        insert aceSKU9 ;    
            
        Test.startTest();
        integer batch_size = 10;
        ACE_Site_CustomerDetails aceBatch = new ACE_Site_CustomerDetails();
        database.executebatch(aceBatch,batch_size);
        Test.stopTest();
        String CRON_EXP = '0 0 0 3 9 ? 2022';
        System.schedule('TestBatch1',CRON_EXP , aceBatch );     
}
    
        static testMethod void Test_ACE_Site_CustomerDetails_Method8(){

        Map<String,Schema.RecordTypeInfo> CaseRecType = Schema.SObjectType.Case.getRecordTypeInfosByName();
        
        ACE_Settings__c desettings = new ACE_Settings__c(Expiry_Days__c=2,EsclationDays__c=1,processing_window__c=2,BatchName__c='Q4-2014',Vendavo_Update_Start_Date__c = system.today(), Vendavo_Update_End_Date__c = system.today()+5);
        insert desettings; 

        ACE_Batches__c batches = new ACE_Batches__c(name='Q4-2014',Batch__c='Q4-2014');
        insert batches;

        Account acc = new Account (name = 'SUN Test Account',AOPS_Seq_ID__c = '123454',AOPS_Cust_Id__c = '123454',Oracle_Party_Id__c = '123454',Billingcountry = 'USA',BillingState = 'UT',BillingStreet = '1040 N 326 W',billingcity = 'Orem');
        insert acc;
        
        Contact con1 = new Contact(firstname ='test con1', lastname ='b',accountId = acc.id,email = 'test@gmail.com',role__c ='Price Change Approver');
        insert con1;
        
        Contact con2 = new Contact(firstname ='test con2',LastName = 'a' ,accountId = acc.id,email = 'test1@gmail.com',role__c ='Price Change Notification/Viewer,Price Change Approver');
        insert con2;
    
        ACE_Customer_Price_Changes__c acep10 = new ACE_Customer_Price_Changes__c(name='test',Customer__c = acc.id, Owning_Customer_ID__c ='123454',
                                                                                sfdc_notification_flag__c='3', Owning_Customer_Legal__c = 'T');
        insert acep10;
        
        Ace_Customer_Core_Changes__c aceCoreChange10 = new Ace_Customer_Core_Changes__c(name = 'Test3',CoreID__c = '123454', ACE_Customer_Price_Changes__c = acep10.id);
        insert aceCoreChange10;
            
        Ace_Customer_SKU_Changes__c aceSKU10 = new Ace_Customer_SKU_Changes__c(SKU__c = '123454',status__c='Active',batchId__c='abc',
                                                                              name='test', Ace_Customer_Core_Changes__c = aceCoreChange10.id,approval_status__c = 'Pending');
        insert aceSKU10 ;    
            
        Test.startTest();
        integer batch_size = 10;
        ACE_Site_CustomerDetails aceBatch = new ACE_Site_CustomerDetails();
        database.executebatch(aceBatch,batch_size);
        Test.stopTest();
        String CRON_EXP = '0 0 0 3 9 ? 2022';
        System.schedule('TestBatch1',CRON_EXP , aceBatch );     
}
    
        
        static testMethod void Test_ACE_Site_CustomerDetails_Method9(){

//        Map<String,Schema.RecordTypeInfo> CaseRecType = Schema.SObjectType.Case.getRecordTypeInfosByName();
        
        ACE_Settings__c desettings = new ACE_Settings__c(Expiry_Days__c=2,EsclationDays__c=1,processing_window__c=2,BatchName__c='Q4-2014',Vendavo_Update_Start_Date__c = system.today(), Vendavo_Update_End_Date__c = system.today()+5);
        insert desettings; 

        ACE_Batches__c batches = new ACE_Batches__c(name='Q4-2014',Batch__c='Q4-2014');
        insert batches;

        Account acc = new Account (name = 'SUN Test Account',AOPS_Seq_ID__c = '123454',AOPS_Cust_Id__c = '123454',Oracle_Party_Id__c = '123454',Billingcountry = 'USA',BillingState = 'UT',BillingStreet = '1040 N 326 W',billingcity = 'Orem');
        insert acc;
        
        Contact con1 = new Contact(firstname ='test con1', lastname ='b',accountId = acc.id,email = 'test@gmail.com',role__c ='Price Change Approver');
        insert con1;
        
        Contact con2 = new Contact(firstname ='test con2',LastName = 'a' ,accountId = acc.id,email = 'test1@gmail.com',role__c ='Price Change Notification/Viewer,Price Change Approver');
        insert con2;
    
        ACE_Customer_Price_Changes__c acep11 = new ACE_Customer_Price_Changes__c(name='test',Customer__c = acc.id, Owning_Customer_ID__c ='123455',
                                                                                 Exception_Date_Lock__c = true, Hosted_Catalog__c = true , owning_customer_legal__c = 'T',
                                                                                Notification_Status_Code__c ='NOTIFY-CANCELLED',Implementation_Status_Code__c='NOTIFY-CANCELLED',Approval_Satus__c   ='NOTIFY-CANCELLED');
        insert acep11;
            
        Ace_Customer_Core_Changes__c aceCoreChange11 = new Ace_Customer_Core_Changes__c(name = 'Test3',CoreID__c = '123454', ACE_Customer_Price_Changes__c = acep11.id);
        insert aceCoreChange11;    
            
        Ace_Customer_SKU_Changes__c aceSKU11 = new Ace_Customer_SKU_Changes__c(SKU__c = '1234546',sku_alt__c = '12345', 
                                                                               //status__c='Approved',price_Changes_Type__c = 'D', 
                                                                               //batchId__c='abc', 
                                                                               //update_timing_action__c = 'T',
                                                                               name='test', Ace_Customer_Core_Changes__c = aceCoreChange11.id);//,approval_status__c = 'Pending');
        insert aceSKU11 ;     
            
        Test.startTest();
        integer batch_size = 10;
        ACE_Site_CustomerDetails aceBatch = new ACE_Site_CustomerDetails();
        database.executebatch(aceBatch,batch_size);
        Test.stopTest();
        String CRON_EXP = '0 0 0 3 9 ? 2022';
        System.schedule('TestBatch1',CRON_EXP , aceBatch );     
}
    
        static testMethod void Test_ACE_Site_CustomerDetails_Method10(){
        
        ACE_Settings__c desettings = new ACE_Settings__c(Expiry_Days__c=2,EsclationDays__c=1,processing_window__c=2,BatchName__c='Q4-2014',Vendavo_Update_Start_Date__c = system.today(), Vendavo_Update_End_Date__c = system.today()+1);
        insert desettings; 

        ACE_Batches__c batches = new ACE_Batches__c(name='Q4-2014',Batch__c='Q4-2014');
        insert batches;

        Account acc = new Account (name = 'SUN Test Account',AOPS_Seq_ID__c = '123459',AOPS_Cust_Id__c = '123454',Oracle_Party_Id__c = '123454',Billingcountry = 'USA',BillingState = 'UT',BillingStreet = '1040 N 326 W',billingcity = 'Orem');
        insert acc;
        
        Contact con1 = new Contact(firstname ='test con1', lastname ='b',accountId = acc.id,email = 'test@gmail.com',role__c ='Price Change Approver');
        insert con1;
        
        Contact con2 = new Contact(firstname ='test con2',LastName = 'a' ,accountId = acc.id,email = 'test1@gmail.com',role__c ='Price Change Notification/Viewer,Price Change Approver');
        insert con2;
    
        ACE_Customer_Price_Changes__c acep12 =new ACE_Customer_Price_Changes__c(name='test',SRM_Differential__c=5,Item_12_Month_Qty__c = 50,Total_Spend_Impact_12_Month__c=5,Customer__c = acc.id, Owning_Customer_ID__c ='123457',
                                              sfdc_notification_flag__c='1',Customer_Notification_Date_Approved__c  = date.today().AddDays(-2), Remediation_Hold__c = false , Reschduled_For_Reminder__c = true,
                                              Exception_Date_Lock__c = true, Hosted_Catalog__c = false , owning_customer_legal__c = 'T', 
                                              Sales_Price_Change_Effective_Date_Approv__c = date.today(), Sales_Price_Change_Effective_Date_Min__c = date.Today()
                                                                                );                                                                                
        insert acep12;
            
        Ace_Customer_Core_Changes__c aceCoreChange12 = new Ace_Customer_Core_Changes__c(name = 'Test3',CoreID__c = '123494',  ACE_Customer_Price_Changes__c = acep12.id);
        insert aceCoreChange12;    
            
        Ace_Customer_SKU_Changes__c aceSKU12 = new Ace_Customer_SKU_Changes__c(SKU__c = '123494', batchId__c='abc', Alternate_Chosen_Flag__c=true, 
                                                                               status__c = 'Deleted', price_Changes_Type__c = 'D', 
                                                                               name='test', 
                                                                               Ace_Customer_Core_Changes__c = aceCoreChange12.id);
        insert aceSKU12 ;     
            
        Test.startTest();
        integer batch_size = 10;
        ACE_Site_CustomerDetails aceBatch = new ACE_Site_CustomerDetails();
        database.executebatch(aceBatch,batch_size);
        Test.stopTest();
        String CRON_EXP = '0 0 0 3 9 ? 2022';
        System.schedule('TestBatch1',CRON_EXP , aceBatch );     
}    

        static testMethod void Test_ACE_Site_CustomerDetails_Method11(){
        
        ACE_Settings__c desettings = new ACE_Settings__c(Expiry_Days__c=2,EsclationDays__c=1,processing_window__c=2,BatchName__c='Q4-2014',Vendavo_Update_Start_Date__c = system.today(), Vendavo_Update_End_Date__c = system.today()+1);
        insert desettings; 

        ACE_Batches__c batches = new ACE_Batches__c(name='Q4-2014',Batch__c='Q4-2014');
        insert batches;

        Account acc = new Account (name = 'SUN Test Account',AOPS_Seq_ID__c = '123459',AOPS_Cust_Id__c = '123454',Oracle_Party_Id__c = '123454',Billingcountry = 'USA',BillingState = 'UT',BillingStreet = '1040 N 326 W',billingcity = 'Orem');
        insert acc;
        
        Contact con1 = new Contact(firstname ='test con1', lastname ='b',accountId = acc.id,email = 'test@gmail.com',role__c ='Price Change Approver');
        insert con1;
        
        Contact con2 = new Contact(firstname ='test con2',LastName = 'a' ,accountId = acc.id,email = 'test1@gmail.com',role__c ='Price Change Notification/Viewer,Price Change Approver');
        insert con2;
    
        ACE_Customer_Price_Changes__c acep13 =new ACE_Customer_Price_Changes__c(name='test',//SRM_Differential__c=5,Item_12_Month_Qty__c = 50,Total_Spend_Impact_12_Month__c=5,
                                              Customer__c = acc.id, Owning_Customer_ID__c ='123457',
                                              sfdc_notification_flag__c='2',
                                              Customer_Notification_Date_Approved__c  = date.today().AddDays(-2), 
                                              Reschduled_For_Reminder__c = false,
                                              Sales_Price_Change_Effective_Date_Approv__c = date.today(), Sales_Price_Change_Effective_Date_Min__c = date.Today()
                                                                                );                                                                                
        insert acep13;
            
        Ace_Customer_Core_Changes__c aceCoreChange13 = new Ace_Customer_Core_Changes__c(name = 'Test3',CoreID__c = '123494', ACE_Customer_Price_Changes__c = acep13.id);
        insert aceCoreChange13;    
            
        Ace_Customer_SKU_Changes__c aceSKU13 = new Ace_Customer_SKU_Changes__c(SKU__c = '123494', 
                                                                               batchId__c='abc',
                                                                               approval_status__c = 'Pending', 
                                                                               status__c = 'Deleted',
                                                                               sfdc_notification_flag__c = '2',
                                                                               Approved_Proposed_Price__c = 25,
                                                                               Proposed_Price_with_Cap__c=30,
                                                                               name='test', 
                                                                               Ace_Customer_Core_Changes__c = aceCoreChange13.id);
        insert aceSKU13 ;     
            
        Test.startTest();
        integer batch_size = 10;
        ACE_Site_CustomerDetails aceBatch = new ACE_Site_CustomerDetails();
        database.executebatch(aceBatch,batch_size);
        Test.stopTest();
        String CRON_EXP = '0 0 0 3 9 ? 2022';
        System.schedule('TestBatch1',CRON_EXP , aceBatch );     
}   
    
        static testMethod void Test_ACE_Site_CustomerDetails_Method12(){
        
        ACE_Settings__c desettings = new ACE_Settings__c(Expiry_Days__c=2,EsclationDays__c=1,processing_window__c=2,BatchName__c='Q4-2014',Vendavo_Update_Start_Date__c = system.today(), Vendavo_Update_End_Date__c = system.today()+1);
        insert desettings; 

        ACE_Batches__c batches = new ACE_Batches__c(name='Q4-2014',Batch__c='Q4-2014');
        insert batches;

        Account acc = new Account (name = 'SUN Test Account',AOPS_Seq_ID__c = '123459',AOPS_Cust_Id__c = '123454',Oracle_Party_Id__c = '123454',Billingcountry = 'USA',BillingState = 'UT',BillingStreet = '1040 N 326 W',billingcity = 'Orem');
        insert acc;
        
        Contact con1 = new Contact(firstname ='test con1', lastname ='b',accountId = acc.id,email = 'test@gmail.com',role__c ='Price Change Approver');
        insert con1;
        
        Contact con2 = new Contact(firstname ='test con2',LastName = 'a' ,accountId = acc.id,email = 'test1@gmail.com',role__c ='Price Change Notification/Viewer,Price Change Approver');
        insert con2;
    
        ACE_Customer_Price_Changes__c acep14 =new ACE_Customer_Price_Changes__c(name='test',SRM_Differential__c=5,Item_12_Month_Qty__c = 50,Total_Spend_Impact_12_Month__c=5,
                                              Customer__c = acc.id, Owning_Customer_ID__c ='123457',
                                              sfdc_notification_flag__c='2',
                                              Remediation_Hold__c= false,
                                              Price_not_Calculated__c = false,
                                              Notification_Status_Code__c = 'NOTIFY-FAILED',
                                              Update_Vendavo_Date__c = true,
                                              Notification_Error__c = 'No Pricing Contacts Found For Communication'
                                                                                );                                                                                
        insert acep14;
            
        Ace_Customer_Core_Changes__c aceCoreChange14 = new Ace_Customer_Core_Changes__c(name = 'Test3',CoreID__c = '123494', ACE_Customer_Price_Changes__c = acep14.id);
        insert aceCoreChange14;    
            
        Ace_Customer_SKU_Changes__c aceSKU14 = new Ace_Customer_SKU_Changes__c(SKU__c = '123494',
                                                                               approval_status__c = 'Pending', 
                                                                               price_changes_type__c = 'C',
                                                                               margin_play__c = 'A',
                                                                               status__c = 'Active',
                                                                               Approved_Proposed_Price__c = 25,
                                                                               Proposed_Price_with_Cap__c=30,
                                                                               Current_Sell_Price__c = 10,
                                                                               name='test', 
                                                                               Ace_Customer_Core_Changes__c = aceCoreChange14.id);
        insert aceSKU14 ;  
            
            
            
        Test.startTest();
        integer batch_size = 10;
        ACE_Site_CustomerDetails aceBatch = new ACE_Site_CustomerDetails();				
        database.executebatch(aceBatch,batch_size);
        Test.stopTest();
        String CRON_EXP = '0 0 0 3 9 ? 2022';
        System.schedule('TestBatch1',CRON_EXP , aceBatch );     
}    
   
        static testMethod void Test_ACE_Site_CustomerDetails_Method13(){
        
        ACE_Settings__c desettings = new ACE_Settings__c(Expiry_Days__c=2,EsclationDays__c=1,processing_window__c=2,BatchName__c='Q4-2014',Vendavo_Update_Start_Date__c = system.today(), Vendavo_Update_End_Date__c = system.today()+1);
        insert desettings; 

        ACE_Batches__c batches = new ACE_Batches__c(name='Q4-2014',Batch__c='Q4-2014');
        insert batches;

        Account acc = new Account (name = 'SUN Test Account',AOPS_Seq_ID__c = '123459',AOPS_Cust_Id__c = '123454',Oracle_Party_Id__c = '123454',Billingcountry = 'USA',BillingState = 'UT',BillingStreet = '1040 N 326 W',billingcity = 'Orem');
        insert acc;
        
        Contact con1 = new Contact(firstname ='test con1', lastname ='b',accountId = acc.id,email = 'test@gmail.com',role__c ='Price Change Approver');
        insert con1;
        
        Contact con2 = new Contact(firstname ='test con2',LastName = 'a' ,accountId = acc.id,email = 'test1@gmail.com',role__c ='Price Change Notification/Viewer,Price Change Approver');
        insert con2;
    
        ACE_Customer_Price_Changes__c acep15 =new ACE_Customer_Price_Changes__c(name='test',SRM_Differential__c=5,Item_12_Month_Qty__c = 50,Total_Spend_Impact_12_Month__c=5,
                                              Customer__c = acc.id, Owning_Customer_ID__c ='123457',                                 
                                              sfdc_notification_flag__c='2',
                                              Hosted_Catalog__c = false,
                                              Requirement_Window__c = 15.0,
                                              Exception_Date_Lock__c = false,
                                              Reschduled_For_Reminder__c = false,                                 
                                              Record_Lock__c = false,
                                              Customer_Notification_Date_Approved__c = system.today(),
                                              Remediation_Hold__c= false,
                                              Price_not_Calculated__c = false,
                                              Notification_Status_Code__c = 'NOTIFY-FAILED',
                                              Update_Vendavo_Date__c = true,
                                              Owning_Customer_Legal__c = 'T'
                                                                                );                                                                                
        insert acep15;
            
        Ace_Customer_Core_Changes__c aceCoreChange15 = new Ace_Customer_Core_Changes__c(name = 'Test3',CoreID__c = '123494', ACE_Customer_Price_Changes__c = acep15.id);
        insert aceCoreChange15;    
            
        Ace_Customer_SKU_Changes__c aceSKU15 = new Ace_Customer_SKU_Changes__c(SKU__c = '123498', batchId__c = 'Q1-2017',
                                                                               corelist_id__c = 'CL-1234567',
                                                                               Alt_SKU__c = false,
                                                                               Sales_Price_Change_Effective_Date_Approv__c = system.today(),
                                                                               Approval_Type__c = 1.0,
                                                                               sku_alt__c = '754321',
                                                                               Alternate_Chosen_Flag__c = false,
                                                                               Approval_Status__c = 'Pending', 
                                                                               price_changes_type__c = 'M',
                                                                               margin_play__c = 'L',
                                                                               status__c = 'Active',
                                                                               Approved_Proposed_Price__c = 25,
                                                                               Proposed_Price_with_Cap__c=30,
                                                                               Current_Sell_Price__c = 10,
                                                                               name= '123498', 
                                                                               Ace_Customer_Core_Changes__c = aceCoreChange15.id);
        insert aceSKU15 ;
            
       
            
        Test.startTest();
        integer batch_size = 10;
        ACE_Site_CustomerDetails aceBatch = new ACE_Site_CustomerDetails();				
        database.executebatch(aceBatch,batch_size);
        Test.stopTest();
        String CRON_EXP = '0 0 0 3 9 ? 2022';
        System.schedule('TestBatch1',CRON_EXP , aceBatch );     
}     
    
//mm
}
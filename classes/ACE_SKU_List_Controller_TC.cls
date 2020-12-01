@IsTest
private Class ACE_SKU_List_Controller_TC{
    static testMethod void Test_ACE_SKU_List_Controller_Method(){
        //test.start() ;
            List<Ace_Customer_SKU_Changes__c > lst_sku = new List<Ace_Customer_SKU_Changes__c >();

             Profile p = [select id from Profile where name='System Administrator' limit 1];
                   
             User mgruser = new User(TimeZoneSidKey='America/Los_Angeles',ProfileId = p.id,LastName = 'ACE', FirstName = 'Manager', Email = 'ACE.manager@officedepot.com',Username ='ACE.manager@officedepot.com', Alias='test', CommunityNickname='test Approver', LanguageLocaleKey='en_US', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', OD_Employee_ID__c='653466');
             Insert mgruser;
            
             User user = new User(TimeZoneSidKey='America/Los_Angeles',ProfileId = p.id,LastName = 'Rep', FirstName = 'ACE',Email='Rep.ACE@officedepot.com', Username ='Rep.ACE@officedepot.com', Alias='test12', CommunityNickname='test Approve', LanguageLocaleKey='en_US', EmailEncodingKey='UTF-8', LocaleSidKey='en_US',OD_Employee_ID__c='653486');
             Insert user;
            
             system.runas(user){
             
              ACE_Settings__c desettings = new ACE_Settings__c(BatchName__c='Q4-2014',trigger_by_pass__c=string.valueof(user.id));
             insert desettings; 

             Account gpacc = new Account (name = 'GP SUN Test Account',
                                     AOPS_Seq_ID__c = '123666',
                                     AOPS_Cust_Id__c = '123666',
                                     Oracle_Party_Id__c = '123666',
                                     Billingcountry = 'USA',
                                     BillingState = 'UT',
                                     BillingStreet = '1040 N 326 W',
                                     billingcity = 'Orem');
             insert gpacc;

             Account pacc = new Account (name = 'P SUN Test Account',
                                     AOPS_Seq_ID__c = '123466',
                                     AOPS_Cust_Id__c = '123466',
                                     Oracle_Party_Id__c = '123466',
                                     Billingcountry = 'USA',
                                     BillingState = 'UT',
                                     parentid=gpacc.id,
                                     BillingStreet = '1040 N 326 W',
                                     billingcity = 'Orem');
             insert pacc;

             Account acc = new Account (name = 'SUN Test Account',
                             AOPS_Seq_ID__c = '123456',
                             AOPS_Cust_Id__c = '123456',
                             Oracle_Party_Id__c = '123456',
                             Billingcountry = 'USA',
                             BillingState = 'UT',
                             BillingStreet = '1040 N 326 W',
                             parentid= pacc.id,
                             billingcity = 'Orem');
             insert acc;
    
            
             ACE_Customer_Price_Changes__c ace1 = new ACE_Customer_Price_Changes__c(name='Q4-2014',SRM_Differential__c=5,Item_12_Month_Qty__c = 50,Total_Spend_Impact_12_Month__c=5,Customer__c = acc.id, Owning_Customer_ID__c ='123456');
             insert ace1;
             
             ACE_Customer_Price_Changes__c ace12 = new ACE_Customer_Price_Changes__c(name='Q4-2014',SRM_Differential__c=5,Item_12_Month_Qty__c = 50,Total_Spend_Impact_12_Month__c=5,Customer__c = pacc.id, Owning_Customer_ID__c ='123456');
             insert ace12;

             ACE_Customer_Price_Changes__c ace13 = new ACE_Customer_Price_Changes__c(name='Q4-2014',SRM_Differential__c=5,Item_12_Month_Qty__c = 50,Total_Spend_Impact_12_Month__c=5,Customer__c = gpacc.id, Owning_Customer_ID__c ='123456');
             insert ace13;

             Ace_Customer_Core_Changes__c ace2 = new Ace_Customer_Core_Changes__c(name = 'Test1',CoreID__c = 'CL-123456', ACE_Customer_Price_Changes__c = ace1.id);
             insert ace2;
             
             Ace_Customer_SKU_Changes__c ace3 = new Ace_Customer_SKU_Changes__c(price_changes_type__c='D',SKU__c = '123456',status__c='Active',batchId__c='Q4-2014',Item_3_Month_Qty__c=12.12,Item_6_Month_Qty__c=12.12,Item_9_Month_Qty__c=12.12,Item_6_Month_Sales__c=12.12,Item_3_Month_Sales__c=12.12,
             Price_Change_ID__c=ace1.id,Item_9_Month_Sales__c=12.12,Total_Spend_Impact_3_Month__c=12.12,Total_Spend_Impact_6_Month__c=12.12,Total_Spend_Impact_9_Month__c=12.12,Item_12_Month_Qty__c = 50,Item_12_Month_Sales__c=12.12,Total_Spend_Impact_12_Month__c=123.12,name='test', Ace_Customer_Core_Changes__c = ace2.id,  update_timing_action__c = 'T');
             insert ace3;
            
             Ace_Customer_SKU_Changes__c ace4 = new Ace_Customer_SKU_Changes__c(SKU__c = '123556',batchId__c='Q4-2014',Item_3_Month_Qty__c=12.12,Item_6_Month_Qty__c=12.12,Item_9_Month_Qty__c=12.12,Item_3_Month_Sales__c=12.12,Item_6_Month_Sales__c=12.12,
             Price_Change_ID__c=ace12.id,Item_9_Month_Sales__c=12.12,Total_Spend_Impact_3_Month__c=12.12,Total_Spend_Impact_6_Month__c=12.12,Total_Spend_Impact_9_Month__c=12.12,Item_12_Month_Qty__c = 50,Item_12_Month_Sales__c=12.12,Total_Spend_Impact_12_Month__c=123.12,name='test', Ace_Customer_Core_Changes__c = ace2.id,  update_timing_action__c = 'T');
             insert ace4;
            
             Ace_Customer_SKU_Changes__c ace5 = new Ace_Customer_SKU_Changes__c(SKU__c = '124456',batchId__c='Q4-2014',Item_3_Month_Qty__c=12.12,Item_6_Month_Qty__c=12.12,Item_9_Month_Qty__c=12.12,Item_6_Month_Sales__c=12.12,Item_3_Month_Sales__c=12.12,
             Price_Change_ID__c=ace13.id,Item_9_Month_Sales__c=12.12,Total_Spend_Impact_3_Month__c=12.12,Total_Spend_Impact_6_Month__c=12.12,Total_Spend_Impact_9_Month__c=12.12,name='test',Item_12_Month_Qty__c = 50,Item_12_Month_Sales__c=12.12,Total_Spend_Impact_12_Month__c=123.12, Ace_Customer_Core_Changes__c = ace2.id,  update_timing_action__c = 'T');
             insert ace5;
             
            test.starttest();
            ACE_SKU_List_Controller aslc = new ACE_SKU_List_Controller();
            ApexPages.currentPage().getParameters().put('batch','Q4-2014');
            aslc.searchText = '1234';
            aslc.batch = 'Q4-2014';
            aslc.Refresh_rec();
            aslc.sortcust();
            aslc.SearchRecords();
            aslc.nextPage();
            aslc.prevPage();
            aslc.getDisablePrevious();
            aslc.getDisableNext() ;
            ACE_SKU_List_Controller.SKUListTable sku = new ACE_SKU_List_Controller.SKUListTable();
            test.stoptest();
            }
    
    }

    //START NSHARP S-437502 9.9.16 - CODE COVERAGE
    static testMethod void Test_ChangeType(){
        //test.start();
            List<Ace_Customer_SKU_Changes__c > lst_sku = new List<Ace_Customer_SKU_Changes__c >();

             Profile p = [select id from Profile where name='System Administrator' limit 1];
                   
             User mgruser = new User(TimeZoneSidKey='America/Los_Angeles',ProfileId = p.id,LastName = 'ACE', FirstName = 'Manager', Email = 'ACE.manager@officedepot.com',Username ='ACE.manager@officedepot.com', Alias='test', CommunityNickname='test Approver', LanguageLocaleKey='en_US', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', OD_Employee_ID__c='653466');
             Insert mgruser;
            
             User user = new User(TimeZoneSidKey='America/Los_Angeles',ProfileId = p.id,LastName = 'Rep', FirstName = 'ACE',Email='Rep.ACE@officedepot.com', Username ='Rep.ACE@officedepot.com', Alias='test12', CommunityNickname='test Approve', LanguageLocaleKey='en_US', EmailEncodingKey='UTF-8', LocaleSidKey='en_US',OD_Employee_ID__c='653486');
             Insert user;
            
             system.runas(user){
             
                          ACE_Settings__c desettings = new ACE_Settings__c(BatchName__c='Q4-2014',trigger_by_pass__c=string.valueof(user.id));
             insert desettings; 

             Account gpacc = new Account (name = 'GP SUN Test Account',
                                     AOPS_Seq_ID__c = '123666',
                                     AOPS_Cust_Id__c = '123666',
                                     Oracle_Party_Id__c = '123666',
                                     Billingcountry = 'USA',
                                     BillingState = 'UT',
                                     BillingStreet = '1040 N 326 W',
                                     billingcity = 'Orem');
             insert gpacc;

             Account pacc = new Account (name = 'P SUN Test Account',
                                     AOPS_Seq_ID__c = '123466',
                                     AOPS_Cust_Id__c = '123466',
                                     Oracle_Party_Id__c = '123466',
                                     Billingcountry = 'USA',
                                     BillingState = 'UT',
                                     parentid=gpacc.id,
                                     BillingStreet = '1040 N 326 W',
                                     billingcity = 'Orem');
             insert pacc;

             Account acc = new Account (name = 'SUN Test Account',
                             AOPS_Seq_ID__c = '123456',
                             AOPS_Cust_Id__c = '123456',
                             Oracle_Party_Id__c = '123456',
                             Billingcountry = 'USA',
                             BillingState = 'UT',
                             BillingStreet = '1040 N 326 W',
                             parentid= pacc.id,
                             billingcity = 'Orem');
             insert acc;
    
            
             ACE_Customer_Price_Changes__c ace1 = new ACE_Customer_Price_Changes__c(name='Q4-2014',SRM_Differential__c=5,Item_12_Month_Qty__c = 50,Total_Spend_Impact_12_Month__c=5,Customer__c = acc.id, Owning_Customer_ID__c ='123456');
             insert ace1;
             
             ACE_Customer_Price_Changes__c ace12 = new ACE_Customer_Price_Changes__c(name='Q4-2014',SRM_Differential__c=5,Item_12_Month_Qty__c = 50,Total_Spend_Impact_12_Month__c=5,Customer__c = pacc.id, Owning_Customer_ID__c ='123456');
             insert ace12;

             ACE_Customer_Price_Changes__c ace13 = new ACE_Customer_Price_Changes__c(name='Q4-2014',SRM_Differential__c=5,Item_12_Month_Qty__c = 50,Total_Spend_Impact_12_Month__c=5,Customer__c = gpacc.id, Owning_Customer_ID__c ='123456');
             insert ace13;

             Ace_Customer_Core_Changes__c ace2 = new Ace_Customer_Core_Changes__c(name = 'Test1',CoreID__c = 'CL-123456', ACE_Customer_Price_Changes__c = ace1.id);
             insert ace2;
             
             Ace_Customer_SKU_Changes__c ace3 = new Ace_Customer_SKU_Changes__c(price_changes_type__c='D',SKU__c = '123456',status__c='Active',batchId__c='Q4-2014',Item_3_Month_Qty__c=12.12,Item_6_Month_Qty__c=12.12,Item_9_Month_Qty__c=12.12,Item_6_Month_Sales__c=12.12,Item_3_Month_Sales__c=12.12,
             Price_Change_ID__c=ace1.id,Item_9_Month_Sales__c=12.12,Total_Spend_Impact_3_Month__c=12.12,Total_Spend_Impact_6_Month__c=12.12,Total_Spend_Impact_9_Month__c=12.12,Item_12_Month_Qty__c = 50,Item_12_Month_Sales__c=12.12,Total_Spend_Impact_12_Month__c=123.12,name='test', Ace_Customer_Core_Changes__c = ace2.id,  update_timing_action__c = 'T');
             insert ace3;
            
             Ace_Customer_SKU_Changes__c ace4 = new Ace_Customer_SKU_Changes__c(SKU__c = '123556',batchId__c='Q4-2014',Item_3_Month_Qty__c=12.12,Item_6_Month_Qty__c=12.12,Item_9_Month_Qty__c=12.12,Item_3_Month_Sales__c=12.12,Item_6_Month_Sales__c=12.12,
             Price_Change_ID__c=ace12.id,Item_9_Month_Sales__c=12.12,Total_Spend_Impact_3_Month__c=12.12,Total_Spend_Impact_6_Month__c=12.12,Total_Spend_Impact_9_Month__c=12.12,Item_12_Month_Qty__c = 50,Item_12_Month_Sales__c=12.12,Total_Spend_Impact_12_Month__c=123.12,name='test', Ace_Customer_Core_Changes__c = ace2.id,  update_timing_action__c = 'T');
             insert ace4;
            
             Ace_Customer_SKU_Changes__c ace5 = new Ace_Customer_SKU_Changes__c(SKU__c = '124456',batchId__c='Q4-2014',Item_3_Month_Qty__c=12.12,Item_6_Month_Qty__c=12.12,Item_9_Month_Qty__c=12.12,Item_6_Month_Sales__c=12.12,Item_3_Month_Sales__c=12.12,
             Price_Change_ID__c=ace13.id,Item_9_Month_Sales__c=12.12,Total_Spend_Impact_3_Month__c=12.12,Total_Spend_Impact_6_Month__c=12.12,Total_Spend_Impact_9_Month__c=12.12,name='test',Item_12_Month_Qty__c = 50,Item_12_Month_Sales__c=12.12,Total_Spend_Impact_12_Month__c=123.12, Ace_Customer_Core_Changes__c = ace2.id,  update_timing_action__c = 'T');
             insert ace5;
             
            test.starttest();
            ACE_SKU_List_Controller aslc = new ACE_SKU_List_Controller();
            ApexPages.currentPage().getParameters().put('batch','Q4-2014');
            aslc.getFieldName = 'ChangeType';
            aslc.searchText = '1234';
            aslc.batch = 'Q4-2014';
            aslc.Refresh_rec();
            aslc.sortcust();
            aslc.SearchRecords();
            aslc.nextPage();
            aslc.prevPage();
            aslc.getDisablePrevious();
            aslc.getDisableNext() ;
            ACE_SKU_List_Controller.SKUListTable sku = new ACE_SKU_List_Controller.SKUListTable();
            test.stoptest();
            }
    
    }

    static testMethod void Test_Percent(){
        //test.start();
            List<Ace_Customer_SKU_Changes__c > lst_sku = new List<Ace_Customer_SKU_Changes__c >();

             Profile p = [select id from Profile where name='System Administrator' limit 1];
                   
             User mgruser = new User(TimeZoneSidKey='America/Los_Angeles',ProfileId = p.id,LastName = 'ACE', FirstName = 'Manager', Email = 'ACE.manager@officedepot.com',Username ='ACE.manager@officedepot.com', Alias='test', CommunityNickname='test Approver', LanguageLocaleKey='en_US', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', OD_Employee_ID__c='653466');
             Insert mgruser;
            
             User user = new User(TimeZoneSidKey='America/Los_Angeles',ProfileId = p.id,LastName = 'Rep', FirstName = 'ACE',Email='Rep.ACE@officedepot.com', Username ='Rep.ACE@officedepot.com', Alias='test12', CommunityNickname='test Approve', LanguageLocaleKey='en_US', EmailEncodingKey='UTF-8', LocaleSidKey='en_US',OD_Employee_ID__c='653486');
             Insert user;
            
             system.runas(user){
             
                          ACE_Settings__c desettings = new ACE_Settings__c(BatchName__c='Q4-2014',trigger_by_pass__c=string.valueof(user.id));
             insert desettings; 

             Account gpacc = new Account (name = 'GP SUN Test Account',
                                     AOPS_Seq_ID__c = '123666',
                                     AOPS_Cust_Id__c = '123666',
                                     Oracle_Party_Id__c = '123666',
                                     Billingcountry = 'USA',
                                     BillingState = 'UT',
                                     BillingStreet = '1040 N 326 W',
                                     billingcity = 'Orem');
             insert gpacc;

             Account pacc = new Account (name = 'P SUN Test Account',
                                     AOPS_Seq_ID__c = '123466',
                                     AOPS_Cust_Id__c = '123466',
                                     Oracle_Party_Id__c = '123466',
                                     Billingcountry = 'USA',
                                     BillingState = 'UT',
                                     parentid=gpacc.id,
                                     BillingStreet = '1040 N 326 W',
                                     billingcity = 'Orem');
             insert pacc;

             Account acc = new Account (name = 'SUN Test Account',
                             AOPS_Seq_ID__c = '123456',
                             AOPS_Cust_Id__c = '123456',
                             Oracle_Party_Id__c = '123456',
                             Billingcountry = 'USA',
                             BillingState = 'UT',
                             BillingStreet = '1040 N 326 W',
                             parentid= pacc.id,
                             billingcity = 'Orem');
             insert acc;
    
            
             ACE_Customer_Price_Changes__c ace1 = new ACE_Customer_Price_Changes__c(name='Q4-2014',SRM_Differential__c=5,Item_12_Month_Qty__c = 50,Total_Spend_Impact_12_Month__c=5,Customer__c = acc.id, Owning_Customer_ID__c ='123456');
             insert ace1;
             
             ACE_Customer_Price_Changes__c ace12 = new ACE_Customer_Price_Changes__c(name='Q4-2014',SRM_Differential__c=5,Item_12_Month_Qty__c = 50,Total_Spend_Impact_12_Month__c=5,Customer__c = pacc.id, Owning_Customer_ID__c ='123456');
             insert ace12;

             ACE_Customer_Price_Changes__c ace13 = new ACE_Customer_Price_Changes__c(name='Q4-2014',SRM_Differential__c=5,Item_12_Month_Qty__c = 50,Total_Spend_Impact_12_Month__c=5,Customer__c = gpacc.id, Owning_Customer_ID__c ='123456');
             insert ace13;

             Ace_Customer_Core_Changes__c ace2 = new Ace_Customer_Core_Changes__c(name = 'Test1',CoreID__c = 'CL-123456', ACE_Customer_Price_Changes__c = ace1.id);
             insert ace2;
             
             Ace_Customer_SKU_Changes__c ace3 = new Ace_Customer_SKU_Changes__c(price_changes_type__c='D',SKU__c = '123456',status__c='Active',batchId__c='Q4-2014',Item_3_Month_Qty__c=12.12,Item_6_Month_Qty__c=12.12,Item_9_Month_Qty__c=12.12,Item_6_Month_Sales__c=12.12,Item_3_Month_Sales__c=12.12,
             Price_Change_ID__c=ace1.id,Item_9_Month_Sales__c=12.12,Total_Spend_Impact_3_Month__c=12.12,Total_Spend_Impact_6_Month__c=12.12,Total_Spend_Impact_9_Month__c=12.12,Item_12_Month_Qty__c = 50,Item_12_Month_Sales__c=12.12,Total_Spend_Impact_12_Month__c=123.12,name='test', Ace_Customer_Core_Changes__c = ace2.id,  update_timing_action__c = 'T');
             insert ace3;
            
             Ace_Customer_SKU_Changes__c ace4 = new Ace_Customer_SKU_Changes__c(SKU__c = '123556',batchId__c='Q4-2014',Item_3_Month_Qty__c=12.12,Item_6_Month_Qty__c=12.12,Item_9_Month_Qty__c=12.12,Item_3_Month_Sales__c=12.12,Item_6_Month_Sales__c=12.12,
             Price_Change_ID__c=ace12.id,Item_9_Month_Sales__c=12.12,Total_Spend_Impact_3_Month__c=12.12,Total_Spend_Impact_6_Month__c=12.12,Total_Spend_Impact_9_Month__c=12.12,Item_12_Month_Qty__c = 50,Item_12_Month_Sales__c=12.12,Total_Spend_Impact_12_Month__c=123.12,name='test', Ace_Customer_Core_Changes__c = ace2.id,  update_timing_action__c = 'T');
             insert ace4;
            
             Ace_Customer_SKU_Changes__c ace5 = new Ace_Customer_SKU_Changes__c(SKU__c = '124456',batchId__c='Q4-2014',Item_3_Month_Qty__c=12.12,Item_6_Month_Qty__c=12.12,Item_9_Month_Qty__c=12.12,Item_6_Month_Sales__c=12.12,Item_3_Month_Sales__c=12.12,
             Price_Change_ID__c=ace13.id,Item_9_Month_Sales__c=12.12,Total_Spend_Impact_3_Month__c=12.12,Total_Spend_Impact_6_Month__c=12.12,Total_Spend_Impact_9_Month__c=12.12,name='test',Item_12_Month_Qty__c = 50,Item_12_Month_Sales__c=12.12,Total_Spend_Impact_12_Month__c=123.12, Ace_Customer_Core_Changes__c = ace2.id,  update_timing_action__c = 'T');
             insert ace5;
             
            test.starttest();
            ACE_SKU_List_Controller aslc = new ACE_SKU_List_Controller();
            ApexPages.currentPage().getParameters().put('batch','Q4-2014');
            aslc.getFieldName = 'Percent';
            aslc.status = 'Active';
            aslc.OwnerValue = 'Test';
            aslc.batch = 'Q4-2014';
            aslc.Refresh_rec();
            aslc.sortcust();
            aslc.SearchRecords();
            aslc.nextPage();
            aslc.prevPage();
            aslc.getDisablePrevious();
            aslc.getDisableNext() ;
            ACE_SKU_List_Controller.SKUListTable sku = new ACE_SKU_List_Controller.SKUListTable();
            test.stoptest();
            }
    
    }

    static testMethod void Test_UnitVolume(){
        //test.start();
            List<Ace_Customer_SKU_Changes__c > lst_sku = new List<Ace_Customer_SKU_Changes__c >();

             Profile p = [select id from Profile where name='System Administrator' limit 1];
                   
             User mgruser = new User(TimeZoneSidKey='America/Los_Angeles',ProfileId = p.id,LastName = 'ACE', FirstName = 'Manager', Email = 'ACE.manager@officedepot.com',Username ='ACE.manager@officedepot.com', Alias='test', CommunityNickname='test Approver', LanguageLocaleKey='en_US', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', OD_Employee_ID__c='653466');
             Insert mgruser;
            
             User user = new User(TimeZoneSidKey='America/Los_Angeles',ProfileId = p.id,LastName = 'Rep', FirstName = 'ACE',Email='Rep.ACE@officedepot.com', Username ='Rep.ACE@officedepot.com', Alias='test12', CommunityNickname='test Approve', LanguageLocaleKey='en_US', EmailEncodingKey='UTF-8', LocaleSidKey='en_US',OD_Employee_ID__c='653486');
             Insert user;
            
             system.runas(user){
             
                          ACE_Settings__c desettings = new ACE_Settings__c(BatchName__c='Q4-2014',trigger_by_pass__c=string.valueof(user.id));
             insert desettings; 

             Account gpacc = new Account (name = 'GP SUN Test Account',
                                     AOPS_Seq_ID__c = '123666',
                                     AOPS_Cust_Id__c = '123666',
                                     Oracle_Party_Id__c = '123666',
                                     Billingcountry = 'USA',
                                     BillingState = 'UT',
                                     BillingStreet = '1040 N 326 W',
                                     billingcity = 'Orem');
             insert gpacc;

             Account pacc = new Account (name = 'P SUN Test Account',
                                     AOPS_Seq_ID__c = '123466',
                                     AOPS_Cust_Id__c = '123466',
                                     Oracle_Party_Id__c = '123466',
                                     Billingcountry = 'USA',
                                     BillingState = 'UT',
                                     parentid=gpacc.id,
                                     BillingStreet = '1040 N 326 W',
                                     billingcity = 'Orem');
             insert pacc;

             Account acc = new Account (name = 'SUN Test Account',
                             AOPS_Seq_ID__c = '123456',
                             AOPS_Cust_Id__c = '123456',
                             Oracle_Party_Id__c = '123456',
                             Billingcountry = 'USA',
                             BillingState = 'UT',
                             BillingStreet = '1040 N 326 W',
                             parentid= pacc.id,
                             billingcity = 'Orem');
             insert acc;
    
            
             ACE_Customer_Price_Changes__c ace1 = new ACE_Customer_Price_Changes__c(name='Q4-2014',SRM_Differential__c=5,Item_12_Month_Qty__c = 50,Total_Spend_Impact_12_Month__c=5,Customer__c = acc.id, Owning_Customer_ID__c ='123456');
             insert ace1;
             
             ACE_Customer_Price_Changes__c ace12 = new ACE_Customer_Price_Changes__c(name='Q4-2014',SRM_Differential__c=5,Item_12_Month_Qty__c = 50,Total_Spend_Impact_12_Month__c=5,Customer__c = pacc.id, Owning_Customer_ID__c ='123456');
             insert ace12;

             ACE_Customer_Price_Changes__c ace13 = new ACE_Customer_Price_Changes__c(name='Q4-2014',SRM_Differential__c=5,Item_12_Month_Qty__c = 50,Total_Spend_Impact_12_Month__c=5,Customer__c = gpacc.id, Owning_Customer_ID__c ='123456');
             insert ace13;

             Ace_Customer_Core_Changes__c ace2 = new Ace_Customer_Core_Changes__c(name = 'Test1',CoreID__c = 'CL-123456', ACE_Customer_Price_Changes__c = ace1.id);
             insert ace2;
             
             Ace_Customer_SKU_Changes__c ace3 = new Ace_Customer_SKU_Changes__c(price_changes_type__c='D',SKU__c = '123456',status__c='Active',batchId__c='Q4-2014',Item_3_Month_Qty__c=12.12,Item_6_Month_Qty__c=12.12,Item_9_Month_Qty__c=12.12,Item_6_Month_Sales__c=12.12,Item_3_Month_Sales__c=12.12,
             Price_Change_ID__c=ace1.id,Item_9_Month_Sales__c=12.12,Total_Spend_Impact_3_Month__c=12.12,Total_Spend_Impact_6_Month__c=12.12,Total_Spend_Impact_9_Month__c=12.12,Item_12_Month_Qty__c = 50,Item_12_Month_Sales__c=12.12,Total_Spend_Impact_12_Month__c=123.12,name='test', Ace_Customer_Core_Changes__c = ace2.id,  update_timing_action__c = 'T');
             insert ace3;
            
             Ace_Customer_SKU_Changes__c ace4 = new Ace_Customer_SKU_Changes__c(SKU__c = '123556',batchId__c='Q4-2014',Item_3_Month_Qty__c=12.12,Item_6_Month_Qty__c=12.12,Item_9_Month_Qty__c=12.12,Item_3_Month_Sales__c=12.12,Item_6_Month_Sales__c=12.12,
             Price_Change_ID__c=ace12.id,Item_9_Month_Sales__c=12.12,Total_Spend_Impact_3_Month__c=12.12,Total_Spend_Impact_6_Month__c=12.12,Total_Spend_Impact_9_Month__c=12.12,Item_12_Month_Qty__c = 50,Item_12_Month_Sales__c=12.12,Total_Spend_Impact_12_Month__c=123.12,name='test', Ace_Customer_Core_Changes__c = ace2.id,  update_timing_action__c = 'T');
             insert ace4;
            
             Ace_Customer_SKU_Changes__c ace5 = new Ace_Customer_SKU_Changes__c(SKU__c = '124456',batchId__c='Q4-2014',Item_3_Month_Qty__c=12.12,Item_6_Month_Qty__c=12.12,Item_9_Month_Qty__c=12.12,Item_6_Month_Sales__c=12.12,Item_3_Month_Sales__c=12.12,
             Price_Change_ID__c=ace13.id,Item_9_Month_Sales__c=12.12,Total_Spend_Impact_3_Month__c=12.12,Total_Spend_Impact_6_Month__c=12.12,Total_Spend_Impact_9_Month__c=12.12,name='test',Item_12_Month_Qty__c = 50,Item_12_Month_Sales__c=12.12,Total_Spend_Impact_12_Month__c=123.12, Ace_Customer_Core_Changes__c = ace2.id,  update_timing_action__c = 'T');
             insert ace5;
             
            test.starttest();
            ACE_SKU_List_Controller aslc = new ACE_SKU_List_Controller();
            ApexPages.currentPage().getParameters().put('batch','Q4-2014');
            aslc.getFieldName = 'UnitVolume';
            aslc.OwnerValue = 'All';
            aslc.batch = 'Q4-2014';
            aslc.Refresh_rec();
            aslc.sortcust();
            aslc.SearchRecords();
            aslc.nextPage();
            aslc.prevPage();
            aslc.getDisablePrevious();
            aslc.getDisableNext() ;
            ACE_SKU_List_Controller.SKUListTable sku = new ACE_SKU_List_Controller.SKUListTable();
            test.stoptest();
            }
    
    }

    static testMethod void Test_SpendImpact(){
        //test.start();
            List<Ace_Customer_SKU_Changes__c > lst_sku = new List<Ace_Customer_SKU_Changes__c >();

             Profile p = [select id from Profile where name='System Administrator' limit 1];
                   
             User mgruser = new User(TimeZoneSidKey='America/Los_Angeles',ProfileId = p.id,LastName = 'ACE', FirstName = 'Manager', Email = 'ACE.manager@officedepot.com',Username ='ACE.manager@officedepot.com', Alias='test', CommunityNickname='test Approver', LanguageLocaleKey='en_US', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', OD_Employee_ID__c='653466');
             Insert mgruser;
            
             User user = new User(TimeZoneSidKey='America/Los_Angeles',ProfileId = p.id,LastName = 'Rep', FirstName = 'ACE',Email='Rep.ACE@officedepot.com', Username ='Rep.ACE@officedepot.com', Alias='test12', CommunityNickname='test Approve', LanguageLocaleKey='en_US', EmailEncodingKey='UTF-8', LocaleSidKey='en_US',OD_Employee_ID__c='653486');
             Insert user;
            
             system.runas(user){
             
                          ACE_Settings__c desettings = new ACE_Settings__c(BatchName__c='Q4-2014',trigger_by_pass__c=string.valueof(user.id));
             insert desettings; 

             Account gpacc = new Account (name = 'GP SUN Test Account',
                                     AOPS_Seq_ID__c = '123666',
                                     AOPS_Cust_Id__c = '123666',
                                     Oracle_Party_Id__c = '123666',
                                     Billingcountry = 'USA',
                                     BillingState = 'UT',
                                     BillingStreet = '1040 N 326 W',
                                     billingcity = 'Orem');
             insert gpacc;

             Account pacc = new Account (name = 'P SUN Test Account',
                                     AOPS_Seq_ID__c = '123466',
                                     AOPS_Cust_Id__c = '123466',
                                     Oracle_Party_Id__c = '123466',
                                     Billingcountry = 'USA',
                                     BillingState = 'UT',
                                     parentid=gpacc.id,
                                     BillingStreet = '1040 N 326 W',
                                     billingcity = 'Orem');
             insert pacc;

             Account acc = new Account (name = 'SUN Test Account',
                             AOPS_Seq_ID__c = '123456',
                             AOPS_Cust_Id__c = '123456',
                             Oracle_Party_Id__c = '123456',
                             Billingcountry = 'USA',
                             BillingState = 'UT',
                             BillingStreet = '1040 N 326 W',
                             parentid= pacc.id,
                             billingcity = 'Orem');
             insert acc;
    
            
             ACE_Customer_Price_Changes__c ace1 = new ACE_Customer_Price_Changes__c(name='Q4-2014',SRM_Differential__c=5,Item_12_Month_Qty__c = 50,Total_Spend_Impact_12_Month__c=5,Customer__c = acc.id, Owning_Customer_ID__c ='123456');
             insert ace1;
             
             ACE_Customer_Price_Changes__c ace12 = new ACE_Customer_Price_Changes__c(name='Q4-2014',SRM_Differential__c=5,Item_12_Month_Qty__c = 50,Total_Spend_Impact_12_Month__c=5,Customer__c = pacc.id, Owning_Customer_ID__c ='123456');
             insert ace12;

             ACE_Customer_Price_Changes__c ace13 = new ACE_Customer_Price_Changes__c(name='Q4-2014',SRM_Differential__c=5,Item_12_Month_Qty__c = 50,Total_Spend_Impact_12_Month__c=5,Customer__c = gpacc.id, Owning_Customer_ID__c ='123456');
             insert ace13;

             Ace_Customer_Core_Changes__c ace2 = new Ace_Customer_Core_Changes__c(name = 'Test1',CoreID__c = 'CL-123456', ACE_Customer_Price_Changes__c = ace1.id);
             insert ace2;
             
             Ace_Customer_SKU_Changes__c ace3 = new Ace_Customer_SKU_Changes__c(price_changes_type__c='D',SKU__c = '123456',status__c='Active',batchId__c='Q4-2014',Item_3_Month_Qty__c=12.12,Item_6_Month_Qty__c=12.12,Item_9_Month_Qty__c=12.12,Item_6_Month_Sales__c=12.12,Item_3_Month_Sales__c=12.12,
             Price_Change_ID__c=ace1.id,Item_9_Month_Sales__c=12.12,Total_Spend_Impact_3_Month__c=12.12,Total_Spend_Impact_6_Month__c=12.12,Total_Spend_Impact_9_Month__c=12.12,Item_12_Month_Qty__c = 50,Item_12_Month_Sales__c=12.12,Total_Spend_Impact_12_Month__c=123.12,name='test', Ace_Customer_Core_Changes__c = ace2.id,  update_timing_action__c = 'T');
             insert ace3;
            
             Ace_Customer_SKU_Changes__c ace4 = new Ace_Customer_SKU_Changes__c(SKU__c = '123556',batchId__c='Q4-2014',Item_3_Month_Qty__c=12.12,Item_6_Month_Qty__c=12.12,Item_9_Month_Qty__c=12.12,Item_3_Month_Sales__c=12.12,Item_6_Month_Sales__c=12.12,
             Price_Change_ID__c=ace12.id,Item_9_Month_Sales__c=12.12,Total_Spend_Impact_3_Month__c=12.12,Total_Spend_Impact_6_Month__c=12.12,Total_Spend_Impact_9_Month__c=12.12,Item_12_Month_Qty__c = 50,Item_12_Month_Sales__c=12.12,Total_Spend_Impact_12_Month__c=123.12,name='test', Ace_Customer_Core_Changes__c = ace2.id,  update_timing_action__c = 'T');
             insert ace4;
            
             Ace_Customer_SKU_Changes__c ace5 = new Ace_Customer_SKU_Changes__c(SKU__c = '124456',batchId__c='Q4-2014',Item_3_Month_Qty__c=12.12,Item_6_Month_Qty__c=12.12,Item_9_Month_Qty__c=12.12,Item_6_Month_Sales__c=12.12,Item_3_Month_Sales__c=12.12,
             Price_Change_ID__c=ace13.id,Item_9_Month_Sales__c=12.12,Total_Spend_Impact_3_Month__c=12.12,Total_Spend_Impact_6_Month__c=12.12,Total_Spend_Impact_9_Month__c=12.12,name='test',Item_12_Month_Qty__c = 50,Item_12_Month_Sales__c=12.12,Total_Spend_Impact_12_Month__c=123.12, Ace_Customer_Core_Changes__c = ace2.id,  update_timing_action__c = 'T');
             insert ace5;
             
            test.starttest();
            ACE_SKU_List_Controller aslc = new ACE_SKU_List_Controller();
            ApexPages.currentPage().getParameters().put('batch','Q4-2014');
            aslc.getFieldName = 'SpendImpact';
            aslc.status = 'Active';
            aslc.OwnerValue = 'Owned by others';
            aslc.searchText = '1234';
            aslc.batch = 'Q4-2014';
            aslc.Refresh_rec();
            aslc.sortcust();
            aslc.SearchRecords();
            aslc.nextPage();
            aslc.prevPage();
            aslc.tabAsc = false;
            aslc.getFieldName = 'SKUDesc';
            aslc.sortcust();
            aslc.getFieldName = 'PrimVen';
            aslc.sortcust();
            aslc.getFieldName = 'ImpCust';
            aslc.sortcust();
            aslc.getDisablePrevious();
            aslc.getDisableNext() ;
            ACE_SKU_List_Controller.SKUListTable sku = new ACE_SKU_List_Controller.SKUListTable();
            test.stoptest();
            }
    
    }
    //END NSHARP S-437502 9.9.16

}
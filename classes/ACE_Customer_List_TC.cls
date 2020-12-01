@isTest (SeeAllData=false)
private class ACE_Customer_List_TC 
{
    static testMethod void ACE_Customer_List_CoverMethods()
    {
        Profile TestProfile= [select id from profile where name='System Administrator'];
        User TestUser = new User(Alias = 'newUser', Email='newuser@officedepot.com.uat', 
                 EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                 LocaleSidKey='en_US', ProfileId = TestProfile.Id, 
                 TimeZoneSidKey='America/Los_Angeles', UserName='newuser@test.officedepot.com', short_title__c='DSM');
        insert TestUser; 
         System.runAs(TestUser){
        User currentUser = new User();
        currentUser.id = Userinfo.getUserId();
        currentUser.short_title__c = 'RVP';
        update currentUser;
        
       
            Group Group1 = new Group(Name ='Remediation Team');
            insert Group1;
            GroupMember GroupMembers = new GroupMember(
                                 GroupId = Group1.Id,
                                 UserOrGroupId = currentUser.id
                                );
            insert GroupMembers;    
            Group Group2 = new Group(Name ='Hosted Catalog Team');
            insert Group2;
            GroupMember GroupMembers1 = new GroupMember(
                                 GroupId = Group2.Id,
                                 UserOrGroupId = currentUser.id
                                );
            insert GroupMembers1; 
        
                    ACE_Settings__c aceSettingCE = new ACE_Settings__c (Name ='test',Level1Access__c ='DSM',Level2Access__c='RSD',Level3Access__c='RVP');
        insert aceSettingCE ;
  
        
        Account acc = new Account(
                                    Name = 'Testing'    
                                    ,AOPS_Seq_ID__c = '123456',AOPS_Cust_Id__c = '123456',Oracle_Party_Id__c = '123456',
                                    Billingcountry = 'USA',BillingState = 'UT',BillingStreet = '1040 N 326 W',billingcity = 'Orem'                                
                                    );
        insert acc;
        List<ACE_Customer_Price_Changes__c> aceCustPriceChangesList = new List<ACE_Customer_Price_Changes__c>();
        ACE_Customer_Price_Changes__c aceCustPriceChanges = new ACE_Customer_Price_Changes__c (name='batch1',
                                         Customer__c = acc.id,
                                         Owning_Customer_ID__c = '123456',
                                         SRM_Differential__c =5,
                                         Item_12_Month_Qty__c =2,
                                         Total_Spend_Impact_12_Month__c=5000,
                                         SFDC_Notification_Flag__c  = '1',
                                         Hosted_Catalog__c = true                                     
                                        );
        aceCustPriceChangesList.add (aceCustPriceChanges );    
        insert      aceCustPriceChangesList ;  
        Ace_Customer_Core_Changes__c ace2 = new Ace_Customer_Core_Changes__c(name = 'Test1',CoreID__c = '123456', ACE_Customer_Price_Changes__c = aceCustPriceChangesList[0].id);
        insert ace2;

        List<Ace_Customer_SKU_Changes__c > lst_sku = new List<Ace_Customer_SKU_Changes__c >();
        Ace_Customer_SKU_Changes__c ace3 = new Ace_Customer_SKU_Changes__c(SKU__c = '123456',status__c='Active',batchId__c='abc',Item_3_Month_Qty__c=12.12,Item_6_Month_Qty__c=12.12,Item_9_Month_Qty__c=12.12,Item_6_Month_Sales__c=12.12,Item_3_Month_Sales__c=12.12,
                        Item_9_Month_Sales__c=12.12,Total_Spend_Impact_3_Month__c=12.12,Total_Spend_Impact_6_Month__c=12.12,Total_Spend_Impact_9_Month__c=12.12,Item_12_Month_Qty__c = 50,Item_12_Month_Sales__c=12.12,Total_Spend_Impact_12_Month__c=123.12,name='test', Ace_Customer_Core_Changes__c = ace2.id);
        insert ace3;
        
                                          
        
        
        
                                                             
        ApexPages.currentPage().getParameters().put('searchWord','TEst');
        ApexPages.currentPage().getParameters().put('batch','batch1');
        ApexPages.currentPage().getParameters().put('selectedCustomer',acc.id);       
        ApexPages.currentPage().getParameters().put('selectedCustomerName',acc.name);
        ACE_Customer_List ACECustomerListCls = new ACE_Customer_List();
        ACECustomerListCls.searchText = 'Testing';
        ACECustomerListCls.skuFilterSelection = 'Verified';
        ACECustomerListCls.renderUpload();
        ACECustomerListCls.findskus();
        ACECustomerListCls.SkunextPage();
        ACECustomerListCls.getskuDisableNext();
        
        ACECustomerListCls.SkuprevPage();
        ACECustomerListCls.getskuDisablePrevious();
        ACECustomerListCls.SearchRecords();

        test.startTest();        
        //sorting
        ACECustomerListCls.sortCust();
        ACECustomerListCls.getFieldName = 'Customer';
        ACECustomerListCls.sortCust();
        ACECustomerListCls.getFieldName = 'Cores';
        ACECustomerListCls.sortCust();
        ACECustomerListCls.getFieldName = 'effectiveDate';
        ACECustomerListCls.sortCust();
        ACECustomerListCls.getFieldName = 'notifydate';
        ACECustomerListCls.sortCust();
        ACECustomerListCls.getFieldName = 'customerid';
        ACECustomerListCls.sortCust();        
        ACECustomerListCls.getFieldName = 'notifStatus';
        ACECustomerListCls.sortCust();
        ACECustomerListCls.getFieldName = 'pricechangestatus';
        ACECustomerListCls.sortCust();
        ACECustomerListCls.getFieldName = 'sfdcBucket';
        ACECustomerListCls.sortCust();
        
        
        
        //end sorting
        
        ACECustomerListCls.releaseEarly();
        ACECustomerListCls.processSelected();
        
       
        ACECustomerListCls.ApproveRec();
        ACECustomerListCls.RejectRec();
        Test.StopTest();
         }
    }
    /* //access level : hosted nonverified
    static testMethod void ACE_Customer_List_CoverMethods1()
    {
        
        Profile TestProfile= [select id from profile where name='System Administrator'];
        User TestUser = new User(Alias = 'newUser', Email='newuser@officedepot.com.uat', 
                 EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                 LocaleSidKey='en_US', ProfileId = TestProfile.Id, 
                 TimeZoneSidKey='America/Los_Angeles', UserName='newuser@test.officedepot.com');
        insert TestUser; 
        User currentUser = new User();
        currentUser.id = Userinfo.getUserId();
        currentUser.short_title__c = 'RSD';
        update currentUser;
        System.runAs(TestUser){
            Group Group1 = new Group(Name ='Remediation Team');
            insert Group1;
            GroupMember GroupMembers = new GroupMember(
                                 GroupId = Group1.Id,
                                 UserOrGroupId = currentUser.id
                                );
            insert GroupMembers;    
            Group Group2 = new Group(Name ='Hosted Catalog Team');
            insert Group2;
            GroupMember GroupMembers1 = new GroupMember(
                                 GroupId = Group2.Id,
                                 UserOrGroupId = Userinfo.getUserId()
                                );
            insert GroupMembers1;   
        }
        ACE_Settings__c aceSettingCE = new ACE_Settings__c (Name ='test',Level1Access__c ='DSM',Level2Access__c='RSD',Level3Access__c='RVP');
        insert aceSettingCE ;
        Account acc = new Account(
                                    Name = 'Testing'    
                                    ,AOPS_Seq_ID__c = '123456',AOPS_Cust_Id__c = '123456',Oracle_Party_Id__c = '123456',
                                    Billingcountry = 'USA',BillingState = 'UT',BillingStreet = '1040 N 326 W',billingcity = 'Orem'                                
                                    );
        insert acc;
        List<ACE_Customer_Price_Changes__c> aceCustPriceChangesList = new List<ACE_Customer_Price_Changes__c>();
        ACE_Customer_Price_Changes__c aceCustPriceChanges = new ACE_Customer_Price_Changes__c (name='batch1',
                                         Customer__c = acc.id,
                                         Owning_Customer_ID__c = '123456',
                                         SRM_Differential__c =5,
                                         Item_12_Month_Qty__c =2,
                                         Total_Spend_Impact_12_Month__c=5000,
                                         SFDC_Notification_Flag__c  = '1',
                                         Hosted_Catalog__c = true                                     
                                        );
        aceCustPriceChangesList.add (aceCustPriceChanges );    
        insert      aceCustPriceChangesList ;  
        Ace_Customer_Core_Changes__c ace2 = new Ace_Customer_Core_Changes__c(name = 'Test1',CoreID__c = '123456', ACE_Customer_Price_Changes__c = aceCustPriceChangesList[0].id);
        insert ace2;

        List<Ace_Customer_SKU_Changes__c > lst_sku = new List<Ace_Customer_SKU_Changes__c >();
        Ace_Customer_SKU_Changes__c ace3 = new Ace_Customer_SKU_Changes__c(SKU__c = '123456',status__c='Active',batchId__c='abc',Item_3_Month_Qty__c=12.12,Item_6_Month_Qty__c=12.12,Item_9_Month_Qty__c=12.12,Item_6_Month_Sales__c=12.12,Item_3_Month_Sales__c=12.12,
                        Item_9_Month_Sales__c=12.12,Total_Spend_Impact_3_Month__c=12.12,Total_Spend_Impact_6_Month__c=12.12,Total_Spend_Impact_9_Month__c=12.12,Item_12_Month_Qty__c = 50,Item_12_Month_Sales__c=12.12,Total_Spend_Impact_12_Month__c=123.12,name='test', Ace_Customer_Core_Changes__c = ace2.id);
        insert ace3;
        
                                          
        
        
        
                                                             
        ApexPages.currentPage().getParameters().put('searchWord','TEst');
        ApexPages.currentPage().getParameters().put('batch','batch1');
        ApexPages.currentPage().getParameters().put('selectedCustomer',acc.id); 
        ApexPages.currentPage().getParameters().put('selectedCustomerName',acc.name);       
        ACE_Customer_List ACECustomerListCls = new ACE_Customer_List();
        ACECustomerListCls.getFieldName = 'notifStatus';
        ACECustomerListCls.searchText = 'Testing';
        ACECustomerListCls.skuFilterSelection = 'NotVerified';
        ACECustomerListCls.renderUpload();
        ACECustomerListCls.findskus();
        ACECustomerListCls.OwnerValue = 'PendingApproval'; //Owned by me
        ACECustomerListCls.SearchRecords();
        ACECustomerListCls.nextPage();
        ACECustomerListCls.getDisableNext();
        test.startTest();
        
        ACECustomerListCls.skuFilterSelection = 'Verified';
        ACECustomerListCls.findskus();
        
        ACECustomerListCls.prevPage();
        ACECustomerListCls.getDisablePrevious();
        //sorting
       
        ACECustomerListCls.getFieldName = 'annualspend';
        ACECustomerListCls.sortCust();
        //ACECustomerListCls.getFieldName = 'annualspndchange';
        //ACECustomerListCls.sortCust();
        //end sorting
        ACECustomerListCls.getFieldName = 'notifStatus';
        ACECustomerListCls.releaseEarly();
        ACECustomerListCls.processSelected();
        
        ACECustomerListCls.ApproveRec();
        ACECustomerListCls.RejectRec();
        Test.StopTest();
    }*/
    //access level : general
    static testMethod void ACE_Customer_List_CoverMethods2()
    {
        
         Profile TestProfile= [select id from profile where name='System Administrator'];
        User TestUser = new User(Alias = 'newUser', Email='newuser@officedepot.com.uat', 
                 EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                 LocaleSidKey='en_US', ProfileId = TestProfile.Id, 
                 TimeZoneSidKey='America/Los_Angeles', UserName='newuser@test.officedepot.com', short_title__c='DSM');
        insert TestUser; 
        system.runAs(TestUser){
        ACE_Settings__c aceSettingCE = new ACE_Settings__c (Name ='test',Level1Access__c ='DSM',Level2Access__c='RSD',Level3Access__c='RVP');
        insert aceSettingCE ;
        Account acc = new Account(
                                    Name = 'Testing'    
                                    ,AOPS_Seq_ID__c = '123456',AOPS_Cust_Id__c = '123456',Oracle_Party_Id__c = '123456',
                                    Billingcountry = 'USA',BillingState = 'UT',BillingStreet = '1040 N 326 W',billingcity = 'Orem'                                
                                    );
        insert acc;
        List<ACE_Customer_Price_Changes__c> aceCustPriceChangesList = new List<ACE_Customer_Price_Changes__c>();
        ACE_Customer_Price_Changes__c aceCustPriceChanges = new ACE_Customer_Price_Changes__c (name='batch1',
                                         Customer__c = acc.id,
                                         Owning_Customer_ID__c = '123456',
                                         SRM_Differential__c =5,
                                         Item_12_Month_Qty__c =2,
                                         Total_Spend_Impact_12_Month__c=5000,
                                         SFDC_Notification_Flag__c  = '1',
                                         Hosted_Catalog__c = true                                     
                                        );
        aceCustPriceChangesList.add (aceCustPriceChanges );    
        insert      aceCustPriceChangesList ;  
        Ace_Customer_Core_Changes__c ace2 = new Ace_Customer_Core_Changes__c(name = 'Test1',CoreID__c = '123456', ACE_Customer_Price_Changes__c = aceCustPriceChangesList[0].id);
        insert ace2;

        List<Ace_Customer_SKU_Changes__c > lst_sku = new List<Ace_Customer_SKU_Changes__c >();
        Ace_Customer_SKU_Changes__c ace3 = new Ace_Customer_SKU_Changes__c(SKU__c = '123456',status__c='Active',batchId__c='abc',Item_3_Month_Qty__c=12.12,Item_6_Month_Qty__c=12.12,Item_9_Month_Qty__c=12.12,Item_6_Month_Sales__c=12.12,Item_3_Month_Sales__c=12.12,
                        Item_9_Month_Sales__c=12.12,Total_Spend_Impact_3_Month__c=12.12,Total_Spend_Impact_6_Month__c=12.12,Total_Spend_Impact_9_Month__c=12.12,Item_12_Month_Qty__c = 50,Item_12_Month_Sales__c=12.12,Total_Spend_Impact_12_Month__c=123.12,name='test', Ace_Customer_Core_Changes__c = ace2.id);
        insert ace3;
        
                                          
        
        
        
                                                             
        ApexPages.currentPage().getParameters().put('searchWord','TEst');
        ApexPages.currentPage().getParameters().put('batch','batch1');
        ApexPages.currentPage().getParameters().put('selectedCustomer',acc.id);   
        ApexPages.currentPage().getParameters().put('selectedCustomerName',acc.name);       
        ACE_Customer_List ACECustomerListCls = new ACE_Customer_List();
        ACECustomerListCls.searchText = 'Testing';
        ACECustomerListCls.OwnerValue = 'All'; //All
        ACECustomerListCls.skuFilterSelection = 'NotVerified';
        ACECustomerListCls.renderUpload();
        ACECustomerListCls.findskus();
       
        ACECustomerListCls.SearchRecords();
        test.startTest();
        ACECustomerListCls.getFieldName = 'notifStatus';
        ACECustomerListCls.nextPage();
        ACECustomerListCls.getDisableNext();
        
        ACECustomerListCls.prevPage();
        ACECustomerListCls.getDisablePrevious();
        //sorting
       
        ACECustomerListCls.getFieldName = 'annualspend';
        ACECustomerListCls.sortCust();
        ACECustomerListCls.getFieldName = 'annualspndchange';
        ACECustomerListCls.sortCust();
        ACECustomerListCls.getFieldName = 'NoOfSKUGovernedByActiveWrittenAgreement';
        ACECustomerListCls.sortCust();
        ACECustomerListCls.getFieldName = 'reps';
        ACECustomerListCls.sortCust();
        //end sorting
        
        ACECustomerListCls.releaseEarly();
        ACECustomerListCls.processSelected();
        
        ACECustomerListCls.ApproveRec();
        ACECustomerListCls.RejectRec();        
        Test.StopTest();
        }
    }


static testMethod void ACE_Customer_List_CoverMethods3()
    {
        Profile TestProfile= [select id from profile where name='System Administrator'];
        User TestUser = new User(Alias = 'newUser', Email='newuser@officedepot.com.uat', 
                 EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                 LocaleSidKey='en_US', ProfileId = TestProfile.Id, 
                 TimeZoneSidKey='America/Los_Angeles', UserName='newuser@test.officedepot.com', short_title__c='DSM');
        insert TestUser; 
        system.runAs(TestUser){
        
        ACE_Settings__c aceSettingCE = new ACE_Settings__c (Name ='test',Level1Access__c ='DSM',Level2Access__c='RSD',Level3Access__c='RVP');
        insert aceSettingCE ;
        Account acc = new Account(
                                    Name = 'Testing'    
                                    ,AOPS_Seq_ID__c = '123456',AOPS_Cust_Id__c = '123456',Oracle_Party_Id__c = '123456',
                                    Billingcountry = 'USA',BillingState = 'UT',BillingStreet = '1040 N 326 W',billingcity = 'Orem'                                
                                    );
        insert acc;
        List<ACE_Customer_Price_Changes__c> aceCustPriceChangesList = new List<ACE_Customer_Price_Changes__c>();
        ACE_Customer_Price_Changes__c aceCustPriceChanges = new ACE_Customer_Price_Changes__c (name='batch1',
                                         Customer__c = acc.id,
                                         Owning_Customer_ID__c = '123456',
                                         SRM_Differential__c =5,
                                         Item_12_Month_Qty__c =2,
                                         Total_Spend_Impact_12_Month__c=5000,
                                         SFDC_Notification_Flag__c  = '1',
                                         Hosted_Catalog__c = true                                    
                                        );
        aceCustPriceChangesList.add (aceCustPriceChanges );    
        insert      aceCustPriceChangesList ;  
        Ace_Customer_Core_Changes__c ace2 = new Ace_Customer_Core_Changes__c(name = 'Test1',CoreID__c = '123456', ACE_Customer_Price_Changes__c = aceCustPriceChangesList[0].id);
        insert ace2;

        List<Ace_Customer_SKU_Changes__c > lst_sku = new List<Ace_Customer_SKU_Changes__c >();
        Ace_Customer_SKU_Changes__c ace3 = new Ace_Customer_SKU_Changes__c(SKU__c = '123456',status__c='Active',batchId__c='abc',Item_3_Month_Qty__c=12.12,Item_6_Month_Qty__c=12.12,Item_9_Month_Qty__c=12.12,Item_6_Month_Sales__c=12.12,Item_3_Month_Sales__c=12.12,
                        Item_9_Month_Sales__c=12.12,Total_Spend_Impact_3_Month__c=12.12,Total_Spend_Impact_6_Month__c=12.12,Total_Spend_Impact_9_Month__c=12.12,Item_12_Month_Qty__c = 50,Item_12_Month_Sales__c=12.12,Total_Spend_Impact_12_Month__c=123.12,name='test', Ace_Customer_Core_Changes__c = ace2.id);
        insert ace3;
        
                                          
        
        
        
                                                             
        ApexPages.currentPage().getParameters().put('searchWord','TEst');
        ApexPages.currentPage().getParameters().put('batch','batch1');
        ApexPages.currentPage().getParameters().put('selectedCustomer',acc.id);   
        ApexPages.currentPage().getParameters().put('selectedCustomerName',acc.name);       
        ACE_Customer_List ACECustomerListCls = new ACE_Customer_List();
        ACECustomerListCls.searchText = 'Testing';
        ACECustomerListCls.OwnerValue = 'Owned by me';
        ACECustomerListCls.skuFilterSelection = 'NotVerified';
        ACECustomerListCls.renderUpload();
        ACECustomerListCls.findskus();
       
        ACECustomerListCls.SearchRecords();
        test.startTest();
        ACECustomerListCls.nextPage();
        ACECustomerListCls.getDisableNext();
        
        ACECustomerListCls.prevPage();
        ACECustomerListCls.getDisablePrevious();
        //sorting
       
        ACECustomerListCls.getFieldName = 'annualspend';
        ACECustomerListCls.sortCust();
        ACECustomerListCls.getFieldName = 'annualspndchange';
        ACECustomerListCls.sortCust();
        ACECustomerListCls.getFieldName = 'NoOfSKUGovernedByActiveWrittenAgreement';
        ACECustomerListCls.sortCust();
        ACECustomerListCls.getFieldName = 'reps';
        ACECustomerListCls.sortCust();
        ACECustomerListCls.getFieldName = 'SKU';
        ACECustomerListCls.sortCust();
        //end sorting
        
        ACECustomerListCls.releaseEarly();
        ACECustomerListCls.processSelected();
        
        ACECustomerListCls.ApproveRec();
        ACECustomerListCls.RejectRec();        
        Test.StopTest();
        }
    }
    
    static testMethod void ACE_Customer_List_CoverMethods4()
    {
        Profile TestProfile= [select id from profile where name='System Administrator'];
        User TestUser = new User(Alias = 'newUser', Email='newuser@officedepot.com.uat', 
                 EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                 LocaleSidKey='en_US', ProfileId = TestProfile.Id, 
                 TimeZoneSidKey='America/Los_Angeles', UserName='newuser@test.officedepot.com', short_title__c='DSM');
        insert TestUser; 
          System.runAs(TestUser){
        User currentUser = new User();
        currentUser.id = Userinfo.getUserId();
        currentUser.short_title__c = 'RVP';
        update currentUser;
        
      
            Group Group1 = new Group(Name ='Remediation Team');
            insert Group1;
            GroupMember GroupMembers = new GroupMember(
                                 GroupId = Group1.Id,
                                 UserOrGroupId = currentUser.id
                                );
            insert GroupMembers;    
            Group Group2 = new Group(Name ='Hosted Catalog Team');
            insert Group2;
            GroupMember GroupMembers1 = new GroupMember(
                                 GroupId = Group2.Id,
                                 UserOrGroupId = currentUser.id
                                );
            insert GroupMembers1;  
            
                    ACE_Settings__c aceSettingCE = new ACE_Settings__c (Name ='test',Level1Access__c ='DSM',Level2Access__c='RSD',Level3Access__c='RVP');
        insert aceSettingCE ;
 
        
        Account acc = new Account(
                                    Name = 'Testing'    
                                    ,AOPS_Seq_ID__c = '123456',AOPS_Cust_Id__c = '123456',Oracle_Party_Id__c = '123456',
                                    Billingcountry = 'USA',BillingState = 'UT',BillingStreet = '1040 N 326 W',billingcity = 'Orem'                                
                                    );
        insert acc;
        List<ACE_Customer_Price_Changes__c> aceCustPriceChangesList = new List<ACE_Customer_Price_Changes__c>();
        ACE_Customer_Price_Changes__c aceCustPriceChanges = new ACE_Customer_Price_Changes__c (name='batch1',
                                         Customer__c = acc.id,
                                         Owning_Customer_ID__c = '123456',
                                         SRM_Differential__c =5,
                                         Item_12_Month_Qty__c =2,
                                         Total_Spend_Impact_12_Month__c=5000,
                                         SFDC_Notification_Flag__c  = '1',
                                         Hosted_Catalog__c = true                                     
                                        );
        aceCustPriceChangesList.add (aceCustPriceChanges );    
        insert      aceCustPriceChangesList ;  
        Ace_Customer_Core_Changes__c ace2 = new Ace_Customer_Core_Changes__c(name = 'Test1',CoreID__c = '123456', ACE_Customer_Price_Changes__c = aceCustPriceChangesList[0].id);
        insert ace2;

        List<Ace_Customer_SKU_Changes__c > lst_sku = new List<Ace_Customer_SKU_Changes__c >();
        Ace_Customer_SKU_Changes__c ace3 = new Ace_Customer_SKU_Changes__c(SKU__c = '123456',status__c='Active',batchId__c='abc',Item_3_Month_Qty__c=12.12,Item_6_Month_Qty__c=12.12,Item_9_Month_Qty__c=12.12,Item_6_Month_Sales__c=12.12,Item_3_Month_Sales__c=12.12,
                        Item_9_Month_Sales__c=12.12,Total_Spend_Impact_3_Month__c=12.12,Total_Spend_Impact_6_Month__c=12.12,Total_Spend_Impact_9_Month__c=12.12,Item_12_Month_Qty__c = 50,Item_12_Month_Sales__c=12.12,Total_Spend_Impact_12_Month__c=123.12,name='test', Ace_Customer_Core_Changes__c = ace2.id);
        insert ace3;
        
                                          
        
        
        
                                                             
        ApexPages.currentPage().getParameters().put('searchWord','TEst');
        ApexPages.currentPage().getParameters().put('batch','batch1');
        ApexPages.currentPage().getParameters().put('selectedCustomer',acc.id);       
        ApexPages.currentPage().getParameters().put('selectedCustomerName',acc.name);
        ACE_Customer_List ACECustomerListCls = new ACE_Customer_List();
        ACECustomerListCls.searchText = 'Testing';
        ACECustomerListCls.skuFilterSelection = 'Verified';
        ACECustomerListCls.OwnerValue = 'Owned by me';
        ACECustomerListCls.renderUpload();
        ACECustomerListCls.findskus();
        ACECustomerListCls.SkunextPage();
        ACECustomerListCls.getskuDisableNext();
        
        ACECustomerListCls.SkuprevPage();
        ACECustomerListCls.getskuDisablePrevious();
        ACECustomerListCls.SearchRecords();

        test.startTest();        
        //sorting
        ACECustomerListCls.sortCust();
        ACECustomerListCls.getFieldName = 'Customer';
        ACECustomerListCls.sortCust();
        ACECustomerListCls.getFieldName = 'Cores';
        ACECustomerListCls.sortCust();
        ACECustomerListCls.getFieldName = 'effectiveDate';
        ACECustomerListCls.sortCust();
        ACECustomerListCls.getFieldName = 'notifydate';
        ACECustomerListCls.sortCust();
        ACECustomerListCls.getFieldName = 'customerid';
        ACECustomerListCls.sortCust();        
        ACECustomerListCls.getFieldName = 'notifStatus';
        ACECustomerListCls.sortCust();
        ACECustomerListCls.getFieldName = 'pricechangestatus';
        ACECustomerListCls.sortCust();
        ACECustomerListCls.getFieldName = 'sfdcBucket';
        ACECustomerListCls.sortCust();
        
        
        
        //end sorting
        
        ACECustomerListCls.releaseEarly();
        ACECustomerListCls.processSelected();
        
       
        ACECustomerListCls.ApproveRec();
        ACECustomerListCls.RejectRec();
        Test.StopTest();
    }
    }
    
    static testMethod void ACE_Customer_List_CoverMethods5()
    {
        Profile TestProfile= [select id from profile where name='System Administrator'];
        User TestUser = new User(Alias = 'newUser', Email='newuser@officedepot.com.uat', 
                 EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                 LocaleSidKey='en_US', ProfileId = TestProfile.Id, 
                 TimeZoneSidKey='America/Los_Angeles', UserName='newuser@test.officedepot.com', short_title__c='DSM');
        insert TestUser; 
            System.runAs(TestUser){
        User currentUser = new User();
        currentUser.id = Userinfo.getUserId();
        currentUser.short_title__c = 'RVP';
        update currentUser;
        
    
            Group Group1 = new Group(Name ='Remediation Team');
            insert Group1;
            GroupMember GroupMembers = new GroupMember(
                                 GroupId = Group1.Id,
                                 UserOrGroupId = currentUser.id
                                );
            insert GroupMembers;    
            Group Group2 = new Group(Name ='Hosted Catalog Team');
            insert Group2;
            GroupMember GroupMembers1 = new GroupMember(
                                 GroupId = Group2.Id,
                                 UserOrGroupId = currentUser.id
                                );
            insert GroupMembers1;  
                    ACE_Settings__c aceSettingCE = new ACE_Settings__c (Name ='test',Level1Access__c ='DSM',Level2Access__c='RSD',Level3Access__c='RVP');
        insert aceSettingCE ;
 
        
        Account acc = new Account(
                                    Name = 'Testing'    
                                    ,AOPS_Seq_ID__c = '123456',AOPS_Cust_Id__c = '123456',Oracle_Party_Id__c = '123456',
                                    Billingcountry = 'USA',BillingState = 'UT',BillingStreet = '1040 N 326 W',billingcity = 'Orem'                                
                                    );
        insert acc;
        List<ACE_Customer_Price_Changes__c> aceCustPriceChangesList = new List<ACE_Customer_Price_Changes__c>();
        ACE_Customer_Price_Changes__c aceCustPriceChanges = new ACE_Customer_Price_Changes__c (name='batch1',
                                         Customer__c = acc.id,
                                         Owning_Customer_ID__c = '123456',
                                         SRM_Differential__c =5,
                                         Item_12_Month_Qty__c =2,
                                         Total_Spend_Impact_12_Month__c=5000,
                                         SFDC_Notification_Flag__c  = '1',
                                         Hosted_Catalog__c = true                                     
                                        );
        aceCustPriceChangesList.add (aceCustPriceChanges );    
        insert      aceCustPriceChangesList ;  
        Ace_Customer_Core_Changes__c ace2 = new Ace_Customer_Core_Changes__c(name = 'Test1',CoreID__c = '123456', ACE_Customer_Price_Changes__c = aceCustPriceChangesList[0].id);
        insert ace2;

        List<Ace_Customer_SKU_Changes__c > lst_sku = new List<Ace_Customer_SKU_Changes__c >();
        Ace_Customer_SKU_Changes__c ace3 = new Ace_Customer_SKU_Changes__c(SKU__c = '123456',status__c='Active',batchId__c='abc',Item_3_Month_Qty__c=12.12,Item_6_Month_Qty__c=12.12,Item_9_Month_Qty__c=12.12,Item_6_Month_Sales__c=12.12,Item_3_Month_Sales__c=12.12,
                        Item_9_Month_Sales__c=12.12,Total_Spend_Impact_3_Month__c=12.12,Total_Spend_Impact_6_Month__c=12.12,Total_Spend_Impact_9_Month__c=12.12,Item_12_Month_Qty__c = 50,Item_12_Month_Sales__c=12.12,Total_Spend_Impact_12_Month__c=123.12,name='test', Ace_Customer_Core_Changes__c = ace2.id);
        insert ace3;
        
                                          
        
        
        
                                                             
        ApexPages.currentPage().getParameters().put('searchWord','TEst');
        ApexPages.currentPage().getParameters().put('batch','batch1');
        ApexPages.currentPage().getParameters().put('selectedCustomer',acc.id);       
        ApexPages.currentPage().getParameters().put('selectedCustomerName',acc.name);
        ACE_Customer_List ACECustomerListCls = new ACE_Customer_List();
        ACECustomerListCls.searchText = 'Testing';
        ACECustomerListCls.skuFilterSelection = 'Verified';
        ACECustomerListCls.OwnerValue = 'Owned by others';
        ACECustomerListCls.renderUpload();
        ACECustomerListCls.findskus();
        ACECustomerListCls.SkunextPage();
        ACECustomerListCls.getskuDisableNext();
        
        ACECustomerListCls.SkuprevPage();
        ACECustomerListCls.getskuDisablePrevious();
        ACECustomerListCls.SearchRecords();

        test.startTest();        
        //sorting
        ACECustomerListCls.sortCust();
        ACECustomerListCls.getFieldName = 'Customer';
        ACECustomerListCls.sortCust();
        ACECustomerListCls.getFieldName = 'Cores';
        ACECustomerListCls.sortCust();
        ACECustomerListCls.getFieldName = 'effectiveDate';
        ACECustomerListCls.sortCust();
        ACECustomerListCls.getFieldName = 'notifydate';
        ACECustomerListCls.sortCust();
        ACECustomerListCls.getFieldName = 'customerid';
        ACECustomerListCls.sortCust();        
        ACECustomerListCls.getFieldName = 'notifStatus';
        ACECustomerListCls.sortCust();
        ACECustomerListCls.getFieldName = 'pricechangestatus';
        ACECustomerListCls.sortCust();
        ACECustomerListCls.getFieldName = 'sfdcBucket';
        ACECustomerListCls.sortCust();
        
        
        
        //end sorting
        
        ACECustomerListCls.releaseEarly();
        ACECustomerListCls.processSelected();
        
       
        ACECustomerListCls.ApproveRec();
        ACECustomerListCls.RejectRec();
        Test.StopTest();
    }
    }
}
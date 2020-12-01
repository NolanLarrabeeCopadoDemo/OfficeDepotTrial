@isTest
public with sharing class ACEComplianceVetting_Batch_Test
{
    @TestSetup
    static void makeData()
    {
        List<sObject> ls = Test.loadData(Ace_Compliance_Cross_Reference__c.sObjectType, 'Ace_Compliance_Cross_Reference_Test_Data');
        
        Account great_grand_parent_account = new Account(
            Name                = 'GreatGrandParent',
            AOPS_Cust_Id__c     = '1234',
            First_Order_Date__c = Date.today()
        );
        insert great_grand_parent_account;

        Account grand_parent_account = new Account(
            Name                = 'Grandparent',
            AOPS_Cust_Id__c     = '123',
            First_Order_Date__c = Date.today(),
            ParentId            = great_grand_parent_account.Id,
            Grand_Parent_Hosted_Catalog__c = true
        );
        insert grand_parent_account;

        Account parent_account = new Account(
            Name                = 'Parent',
            AOPS_Cust_Id__c     = '12',
            First_Order_Date__c = Date.today(),
            ParentId            = grand_parent_account.Id
        );
        insert parent_account;

        Account child_account = new Account();
        child_account.Name                      = 'Child';
        child_account.AOPS_Cust_Id__c           = '1';
        child_account.First_Order_Date__c       = Date.today();
        child_account.ParentId                  = parent_account.Id;
        child_account.Grand_Parent_Hosted_Catalog__c = false;
        insert child_account;
        
        
        
        
        
        
  Ace_Customer_List__c ac1 = new Ace_Customer_List__c(
     
      CustomerID__c = '1',
      status__c= 'New'
    );
    insert ac1 ;
    
    
      Ace_Customer_List__c ac2 = new Ace_Customer_List__c(
     
      CustomerID__c = '12',
      status__c= 'New'
    );
    insert ac2 ;
    
      Ace_Customer_List__c ac3 = new Ace_Customer_List__c(
     
      CustomerID__c = '123',
      status__c= 'New'
    );
    insert ac3 ;
    
    }
    
    @isTest
    public static void test_grandparent_no_private_brand()
    {
        Account child_account = [SELECT Id, AOPS_Cust_Id__c FROM Account WHERE Name = 'Child'];
        Account parent_account = [SELECT Id, AOPS_Cust_Id__c FROM Account WHERE Name = 'Parent'];
        Account grand_parent_account = [SELECT Id, AOPS_Cust_Id__c FROM Account WHERE Name = 'Grandparent'];

        ACE_Compliance_Vetting__c child_private_brand_ACV = new ACE_Compliance_Vetting__c(
            Type__c                     = '',
            IN_Owning_Customer_ID__c    = child_account.AOPS_Cust_Id__c,
            IN_SKU_Dept__c              = '1',
            IN_Owning_Customer_Type__c  = 'S',
            IN_Private_Brand__c         = 'Y'
        );
        insert child_private_brand_ACV;
        
        Contract child_contract = new Contract(
            Contract_Status__c  = 'Active',
            Primary__c          = true,
            AccountId           = child_account.Id
        );
        insert child_contract;

        ACE_Compliance_Vetting__c parent_private_brand_ACV = new ACE_Compliance_Vetting__c(
            Type__c                     = '',
            IN_Owning_Customer_ID__c    = parent_account.AOPS_Cust_Id__c,
            IN_SKU_Dept__c              = '1',
            IN_Owning_Customer_Type__c  = 'S',
            IN_Private_Brand__c         = 'N'
        );
        insert parent_private_brand_ACV;
        
        Contract parent_contract = new Contract(
            Contract_Status__c  = 'Active',
            Primary__c          = true,
            AccountId           = parent_account.Id
        );
        insert parent_contract;

        ACE_Compliance_Vetting__c grand_parent_private_brand_ACV = new ACE_Compliance_Vetting__c(
            Type__c                     = '',
            IN_Owning_Customer_ID__c    = grand_parent_account.AOPS_Cust_Id__c,
            IN_SKU_Dept__c              = '1',
            IN_Owning_Customer_Type__c  = 'S',
            IN_Private_Brand__c         = 'N'
        );
        insert grand_parent_private_brand_ACV;
        
        Contract grand_parent_contract = new Contract(
            Contract_Status__c  = 'Active',
            Primary__c          = true,
            AccountId           = grand_parent_account.Id
        );
        insert grand_parent_contract;

        Contract_Pricing_Terms__c grand_parent_cpt = new Contract_Pricing_Terms__c(
            Active__c                               = true,
            Contract__c                             = grand_parent_contract.Id,
            Relevant_Customer_Level__c              = 'Standalone',
            Private_Brand__c                        = false,
            CC_Initial_Freeze_Period_in_days__c     = 1,
            CC_Prc_Chg_Notice_Reqd_days__c          = 1,
            Price_Incr_Cap_App_Level__c             = 'Needs validation',
            CC_Pricing_Update_Frequency_in_days__c  = 1,
            Departments__c                          = '01 - FURNITURE',
            Required_Timing_Of_CC_Updates__c        = 'Need validation'
        );
        insert grand_parent_cpt;

        Test.startTest();
            ACEComplianceVetting_Batch batch_job = new ACEComplianceVetting_Batch();
            Database.executeBatch(batch_job);
        Test.stopTest();
        
        System.assert([SELECT count() FROM ACE_Compliance_Vetting__c WHERE Type__c = 'Response'] > 0);
    }
    
    @isTest
    public static void test_grandparent_private_brand()
    {
        Account child_account = [SELECT Id, AOPS_Cust_Id__c FROM Account WHERE Name = 'Child'];
        Account parent_account = [SELECT Id, AOPS_Cust_Id__c FROM Account WHERE Name = 'Parent'];
        Account grand_parent_account = [SELECT Id, AOPS_Cust_Id__c FROM Account WHERE Name = 'Grandparent'];

        ACE_Compliance_Vetting__c child_private_brand_ACV = new ACE_Compliance_Vetting__c(
            Type__c                     = '',
            IN_Owning_Customer_ID__c    = child_account.AOPS_Cust_Id__c,
            IN_SKU_Dept__c              = '1',
            IN_Owning_Customer_Type__c  = 'S',
            IN_Private_Brand__c         = 'Y'
        );
        insert child_private_brand_ACV;
        
        Contract child_contract = new Contract(
            Contract_Status__c  = 'Active',
            Primary__c          = true,
            AccountId           = child_account.Id
        );
        insert child_contract;

        ACE_Compliance_Vetting__c parent_private_brand_ACV = new ACE_Compliance_Vetting__c(
            Type__c                     = '',
            IN_Owning_Customer_ID__c    = parent_account.AOPS_Cust_Id__c,
            IN_SKU_Dept__c              = '1',
            IN_Owning_Customer_Type__c  = 'S',
            IN_Private_Brand__c         = 'N'
        );
        insert parent_private_brand_ACV;
        
        Contract parent_contract = new Contract(
            Contract_Status__c  = 'Active',
            Primary__c          = true,
            AccountId           = parent_account.Id
        );
        insert parent_contract;

        ACE_Compliance_Vetting__c grand_parent_private_brand_ACV = new ACE_Compliance_Vetting__c(
            Type__c                     = '',
            IN_Owning_Customer_ID__c    = grand_parent_account.AOPS_Cust_Id__c,
            IN_SKU_Dept__c              = '1',
            IN_Owning_Customer_Type__c  = 'S',
            IN_Private_Brand__c         = 'N'
        );
        insert grand_parent_private_brand_ACV;
        
        Contract grand_parent_contract = new Contract(
            Contract_Status__c  = 'Active',
            Primary__c          = true,
            AccountId           = grand_parent_account.Id
        );
        insert grand_parent_contract;

        Contract_Pricing_Terms__c grand_parent_cpt = new Contract_Pricing_Terms__c(
            Active__c                               = true,
            Contract__c                             = grand_parent_contract.Id,
            Relevant_Customer_Level__c              = 'Standalone',
            Private_Brand__c                        = true,
            CC_Initial_Freeze_Period_in_days__c     = 1,
            CC_Prc_Chg_Notice_Reqd_days__c          = 1,
            Price_Incr_Cap_App_Level__c             = 'Needs validation',
            CC_Pricing_Update_Frequency_in_days__c  = 1,
            Departments__c                          = '01 - FURNITURE',
            Comm_Req_CC_Price_Chg__c                = 'Needs validation'
        );
        insert grand_parent_cpt;

        Test.startTest();
            ACEComplianceVetting_Batch batch_job = new ACEComplianceVetting_Batch();
            Database.executeBatch(batch_job);
        Test.stopTest();
        
        System.assert([SELECT count() FROM ACE_Compliance_Vetting__c WHERE Type__c = 'Response'] > 0);
    }
    
    
    @isTest
    public static void test_parent_no_private_brand2()
    {
        Account child_account = [SELECT Id, AOPS_Cust_Id__c FROM Account WHERE Name = 'Child'];
        Account parent_account = [SELECT Id, AOPS_Cust_Id__c FROM Account WHERE Name = 'Parent'];

        ACE_Compliance_Vetting__c child_private_brand_ACV = new ACE_Compliance_Vetting__c(
            Type__c                     = '',
            IN_Owning_Customer_ID__c    = child_account.AOPS_Cust_Id__c,
            IN_SKU_Dept__c              = '1',
            IN_Owning_Customer_Type__c  = 'S',
            IN_Private_Brand__c         = 'N'
        );
        insert child_private_brand_ACV;
        
        Contract child_contract = new Contract(
            Contract_Status__c  = 'Active',
            Primary__c          = true,
            AccountId           = child_account.Id
        );
        insert child_contract;

        ACE_Compliance_Vetting__c parent_private_brand_ACV = new ACE_Compliance_Vetting__c(
            Type__c                     = '',
            IN_Owning_Customer_ID__c    = parent_account.AOPS_Cust_Id__c,
            IN_SKU_Dept__c              = '1',
            IN_Owning_Customer_Type__c  = 'S',
            IN_Private_Brand__c         = 'N'
        );
        insert parent_private_brand_ACV;
        
        Contract parent_contract = new Contract(
            Contract_Status__c  = 'Active',
            Primary__c          = true,
            AccountId           = parent_account.Id
        );
        insert parent_contract;

        Contract_Pricing_Terms__c parent_cpt = new Contract_Pricing_Terms__c(
            Active__c                               = true,
            Contract__c                             = parent_contract.Id,
            Relevant_Customer_Level__c              = 'Standalone',
            Private_Brand__c                        = true,
            CC_Initial_Freeze_Period_in_days__c     = 1,
            CC_Prc_Chg_Notice_Reqd_days__c          = 1,
            Price_Incr_Cap_App_Level__c             = 'Needs validation',
            CC_Pricing_Update_Frequency_in_days__c  = 1,
            Departments__c                          = '01 - FURNITURE',
            Comm_Req_CC_Price_Chg__c                = 'Needs validation'
        );
        insert parent_cpt;

        Test.startTest();
            ACEComplianceVetting_Batch batch_job = new ACEComplianceVetting_Batch();
            Database.executeBatch(batch_job);
        Test.stopTest();
    }
    

    @isTest
    public static void test_parent_no_private_brand()
    {
        Account child_account = [SELECT Id, AOPS_Cust_Id__c FROM Account WHERE Name = 'Child'];
        Account parent_account = [SELECT Id, AOPS_Cust_Id__c FROM Account WHERE Name = 'Parent'];

        ACE_Compliance_Vetting__c child_private_brand_ACV = new ACE_Compliance_Vetting__c(
            Type__c                     = '',
            IN_Owning_Customer_ID__c    = child_account.AOPS_Cust_Id__c,
            IN_SKU_Dept__c              = '1',
            IN_Owning_Customer_Type__c  = 'S',
            IN_Private_Brand__c         = 'Y'
        );
        insert child_private_brand_ACV;
        
        Contract child_contract = new Contract(
            Contract_Status__c  = 'Active',
            Primary__c          = true,
            AccountId           = child_account.Id
        );
        insert child_contract;

        ACE_Compliance_Vetting__c parent_private_brand_ACV = new ACE_Compliance_Vetting__c(
            Type__c                     = '',
            IN_Owning_Customer_ID__c    = parent_account.AOPS_Cust_Id__c,
            IN_SKU_Dept__c              = '1',
            IN_Owning_Customer_Type__c  = 'S',
            IN_Private_Brand__c         = 'N'
        );
        insert parent_private_brand_ACV;
        
        Contract parent_contract = new Contract(
            Contract_Status__c  = 'Active',
            Primary__c          = true,
            AccountId           = parent_account.Id
        );
        insert parent_contract;

        Contract_Pricing_Terms__c parent_cpt = new Contract_Pricing_Terms__c(
            Active__c                               = true,
            Contract__c                             = parent_contract.Id,
            Relevant_Customer_Level__c              = 'Standalone',
            Private_Brand__c                        = false,
            CC_Initial_Freeze_Period_in_days__c     = 1,
            CC_Prc_Chg_Notice_Reqd_days__c          = 1,
            Price_Incr_Cap_App_Level__c             = 'Needs validation',
            CC_Pricing_Update_Frequency_in_days__c  = 1,
            Departments__c                          = '01 - FURNITURE',
            Comm_Req_CC_Price_Chg__c                = 'Contract silent'
        );
        insert parent_cpt;

        Test.startTest();
            ACEComplianceVetting_Batch batch_job = new ACEComplianceVetting_Batch();
            Database.executeBatch(batch_job);
        Test.stopTest();
        
        System.assert([SELECT count() FROM ACE_Compliance_Vetting__c WHERE Type__c = 'Response'] > 0);
    }

    @isTest
    public static void test_parent_private_brand()
    {
        Account child_account = [SELECT Id, AOPS_Cust_Id__c FROM Account WHERE Name = 'Child'];
        Account parent_account = [SELECT Id, AOPS_Cust_Id__c FROM Account WHERE Name = 'Parent'];

        ACE_Compliance_Vetting__c child_private_brand_ACV = new ACE_Compliance_Vetting__c(
            Type__c                     = '',
            IN_Owning_Customer_ID__c    = child_account.AOPS_Cust_Id__c,
            IN_SKU_Dept__c              = '1',
            IN_Owning_Customer_Type__c  = 'S',
            IN_Private_Brand__c         = 'Y'
        );
        insert child_private_brand_ACV;
        
        Contract child_contract = new Contract(
            Contract_Status__c  = 'Active',
            Primary__c          = true,
            AccountId           = child_account.Id
        );
        insert child_contract;

        ACE_Compliance_Vetting__c parent_private_brand_ACV = new ACE_Compliance_Vetting__c(
            Type__c                     = '',
            IN_Owning_Customer_ID__c    = parent_account.AOPS_Cust_Id__c,
            IN_SKU_Dept__c              = '1',
            IN_Owning_Customer_Type__c  = 'S',
            IN_Private_Brand__c         = 'N'
        );
        insert parent_private_brand_ACV;
        
        Contract parent_contract = new Contract(
            Contract_Status__c  = 'Active',
            Primary__c          = true,
            AccountId           = parent_account.Id
        );
        insert parent_contract;

        Contract_Pricing_Terms__c parent_cpt = new Contract_Pricing_Terms__c(
            Active__c                               = true,
            Contract__c                             = parent_contract.Id,
            Relevant_Customer_Level__c              = 'Standalone',
            Private_Brand__c                        = true,
            CC_Initial_Freeze_Period_in_days__c     = 1,
            CC_Prc_Chg_Notice_Reqd_days__c          = 1,
            Price_Incr_Cap_App_Level__c             = 'Needs validation',
            CC_Pricing_Update_Frequency_in_days__c  = 1,
            Departments__c                          = '01 - FURNITURE',
            Comm_Req_CC_Price_Chg__c                = 'Notification only'
        );
        insert parent_cpt;

        Test.startTest();
            ACEComplianceVetting_Batch batch_job = new ACEComplianceVetting_Batch();
            Database.executeBatch(batch_job);
        Test.stopTest();
        
        System.assert([SELECT count() FROM ACE_Compliance_Vetting__c WHERE Type__c = 'Response'] > 0);
    }

    @isTest
    public static void test_child_private_brand()
    {
        Account child_account = [SELECT Id, AOPS_Cust_Id__c FROM Account WHERE Name = 'Child'];

        ACE_Compliance_Vetting__c child_private_brand_ACV = new ACE_Compliance_Vetting__c(
            Type__c                     = '',
            IN_Owning_Customer_ID__c    = child_account.AOPS_Cust_Id__c,
            IN_SKU_Dept__c              = '1',
            IN_Owning_Customer_Type__c  = 'C',
            IN_Private_Brand__c         = 'Y'
        );
        insert child_private_brand_ACV;
        
        Contract child_contract = new Contract(
            Contract_Status__c  = 'Active',
            Primary__c          = true,
            AccountId           = child_account.Id
        );
        insert child_contract;

        Contract_Pricing_Terms__c child_cpt = new Contract_Pricing_Terms__c(
            Active__c                               = true,
            Contract__c                             = child_contract.Id,
            Relevant_Customer_Level__c              = 'Child',
            Private_Brand__c                        = true,
            CC_Initial_Freeze_Period_in_days__c     = 1,
            CC_Prc_Chg_Notice_Reqd_days__c          = 1,
            Price_Incr_Cap_App_Level__c             = 'Needs validation',
            CC_Pricing_Update_Frequency_in_days__c  = 1,
            Departments__c                          = '01 - FURNITURE',
            Comm_Req_CC_Price_Chg__c                = 'Notification and customer approval'
            
        );
        insert child_cpt;

        Test.startTest();
            ACEComplianceVetting_Batch batch_job = new ACEComplianceVetting_Batch();
            Database.executeBatch(batch_job);
        Test.stopTest();
        
        System.assert([SELECT count() FROM ACE_Compliance_Vetting__c WHERE Type__c = 'Response'] > 0);
    }

    @isTest
    public static void test_child_no_private_brand()
    {
        Account child_account = [SELECT Id, AOPS_Cust_Id__c FROM Account WHERE Name = 'Child'];

        ACE_Compliance_Vetting__c child_private_brand_ACV = new ACE_Compliance_Vetting__c(
            Type__c                     = '',
            IN_Owning_Customer_ID__c    = child_account.AOPS_Cust_Id__c,
            IN_SKU_Dept__c              = '1',
            IN_Owning_Customer_Type__c  = 'C',
            IN_Private_Brand__c         = 'Y'
        );
        insert child_private_brand_ACV;
        
        Contract child_contract = new Contract(
            Contract_Status__c  = 'Active',
            Primary__c          = true,
            AccountId           = child_account.Id
        );
        insert child_contract;

        Contract_Pricing_Terms__c child_cpt = new Contract_Pricing_Terms__c(
            Active__c                               = true,
            Contract__c                             = child_contract.Id,
            Relevant_Customer_Level__c              = 'Child',
            Private_Brand__c                        = false,
            CC_Initial_Freeze_Period_in_days__c     = 1,
            CC_Prc_Chg_Notice_Reqd_days__c          = 1,
            Price_Incr_Cap_App_Level__c             = 'Needs validation',
            CC_Pricing_Update_Frequency_in_days__c  = 1,
            Departments__c                          = '01 - FURNITURE'
        );
        insert child_cpt;

        Test.startTest();
            ACEComplianceVetting_Batch batch_job = new ACEComplianceVetting_Batch();
            Database.executeBatch(batch_job);
        Test.stopTest();
        
        System.assert([SELECT count() FROM ACE_Compliance_Vetting__c WHERE Type__c = 'Response'] > 0);
    }

    @isTest
    public static void test_standalone_private_brand()
    {
        Account child_account = [SELECT Id, AOPS_Cust_Id__c FROM Account WHERE Name = 'Child'];

        ACE_Compliance_Vetting__c child_private_brand_ACV = new ACE_Compliance_Vetting__c(
            Type__c                     = '',
            IN_Owning_Customer_ID__c    = child_account.AOPS_Cust_Id__c,
            IN_SKU_Dept__c              = '1',
            IN_Owning_Customer_Type__c  = 'C',
            IN_Private_Brand__c         = 'Y'
        );
        insert child_private_brand_ACV;
        
        Contract child_contract = new Contract(
            Contract_Status__c  = 'Active',
            Primary__c          = true,
            AccountId           = child_account.Id
        );
        insert child_contract;

        Contract_Pricing_Terms__c child_cpt = new Contract_Pricing_Terms__c(
            Active__c                               = true,
            Contract__c                             = child_contract.Id,
            Relevant_Customer_Level__c              = 'Standalone',
            Private_Brand__c                        = true,
            CC_Initial_Freeze_Period_in_days__c     = 1,
            CC_Prc_Chg_Notice_Reqd_days__c          = 1,
            Price_Incr_Cap_App_Level__c             = 'Needs validation',
            CC_Pricing_Update_Frequency_in_days__c  = 1,
            Departments__c                          = '01 - FURNITURE'
        );
        insert child_cpt;

        Test.startTest();
            ACEComplianceVetting_Batch batch_job = new ACEComplianceVetting_Batch();
            Database.executeBatch(batch_job);
        Test.stopTest();
        
        System.assert([SELECT count() FROM ACE_Compliance_Vetting__c WHERE Type__c = 'Response'] > 0);
    }

    @isTest
    public static void test_standalone_no_private_brand()
    {
        Account child_account = [SELECT Id, AOPS_Cust_Id__c FROM Account WHERE Name = 'Child'];

        ACE_Compliance_Vetting__c child_private_brand_ACV = new ACE_Compliance_Vetting__c(
            Type__c                     = '',
            IN_Owning_Customer_ID__c    = child_account.AOPS_Cust_Id__c,
            IN_SKU_Dept__c              = '1',
            IN_Owning_Customer_Type__c  = 'C',
            IN_Private_Brand__c         = 'Y'
        );
        insert child_private_brand_ACV;
        
        Contract child_contract = new Contract(
            Contract_Status__c  = 'Active',
            Primary__c          = true,
            AccountId           = child_account.Id
        );
        insert child_contract;

        Contract_Pricing_Terms__c child_cpt = new Contract_Pricing_Terms__c(
            Active__c                               = true,
            Contract__c                             = child_contract.Id,
            Relevant_Customer_Level__c              = 'Standalone',
            Private_Brand__c                        = false,
            CC_Initial_Freeze_Period_in_days__c     = 1,
            CC_Prc_Chg_Notice_Reqd_days__c          = 1,
            Price_Incr_Cap_App_Level__c             = 'Needs validation',
            CC_Pricing_Update_Frequency_in_days__c  = 1,
            Departments__c                          = '01 - FURNITURE'
        );
        insert child_cpt;

        Test.startTest();
            ACEComplianceVetting_Batch batch_job = new ACEComplianceVetting_Batch();
            Database.executeBatch(batch_job);
        Test.stopTest();

        System.assert([SELECT count() FROM ACE_Compliance_Vetting__c WHERE Type__c = 'Response'] > 0);
    }
}
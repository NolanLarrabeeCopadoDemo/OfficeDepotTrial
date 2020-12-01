@isTest
public class SubmitDOAApproval_TC {

    @TestSetup
    static void makeData() {
        List<User> usrs = DataFactory.createUserTestRecords('SubmitDOAApprovalTest', 5);
        usrs[0].Job_Code_Level__c = 'Manager';
        usrs[1].Job_Code_Level__c = 'Director';
        usrs[2].Job_Code_Level__c = 'Senior Director';
        usrs[3].Job_Code_Level__c = 'VP';
        usrs[4].Job_Code_Level__c = 'SVP';
        usrs[0].ManagerId = usrs[1].Id;
        usrs[1].ManagerId = usrs[2].Id;
        usrs[2].ManagerId = usrs[3].Id;
        usrs[3].ManagerId = usrs[4].Id;
        update usrs;

        Id Prospect_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
        Id parentRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Parent').getRecordTypeId();
       
        Account acc = new Account();
        acc.Name = 'Test';
        acc.Address1__c = 'New Testing';
        acc.City__c = 'City Test';
        acc.State__c = 'TMO';
        acc.Country__c = 'USA';
        acc.Zip__c = '12321';
        acc.RecordtypeId = Prospect_RecordTypeId;

        Account acc2 = new Account();
        acc2.Name = 'Test2';
        acc2.Address1__c = 'New Testing';
        acc2.City__c = 'City Test';
        acc2.State__c = 'TMO';
        acc2.Country__c = 'USA';
        acc2.Zip__c = '12321';
        acc2.Hierarchy__c = 'P';
        acc2.RecordtypeId = parentRecordTypeId;

        Account acc3 = new Account();
        acc3.Name = 'Test3';
        acc3.Address1__c = 'New Testing';
        acc3.City__c = 'City Test';
        acc3.State__c = 'TMO';
        acc3.Country__c = 'USA';
        acc3.Zip__c = '12321';
        acc3.Hierarchy__c = 'P';
        acc3.RecordtypeId = parentRecordTypeId;
        insert new List<Account> { acc, acc2, acc3 };
        
        CameleonCPQ__QxSetup__c  c = new CameleonCPQ__QxSetup__c(Name='Master',CameleonCPQ__QuoteModelName__c='OfficeDepot',CameleonCPQ__MappingSetName__c='New_Written_Agreement',CameleonCPQ__LinesManagementPolicy__c=1);
        insert c;

        PROS_Access_Custom_Setting__c pacs1 = new PROS_Access_Custom_Setting__c(Name='In Review_VIEW', Profiles__c='Field Sales');
        PROS_Access_Custom_Setting__c pacs2 = new PROS_Access_Custom_Setting__c(Name='Draft_VIEW', Profiles__c='Field Sales');
        insert new List<PROS_Access_Custom_Setting__c> { pacs1, pacs2 };

        DOA_Approval_Paremeters__c doaApprovalParameters = new DOA_Approval_Paremeters__c();
        doaApprovalParameters.CPD_Director__c = UserInfo.getUserId();
        doaApprovalParameters.CBFS_Director__c = UserInfo.getUserId();
        doaApprovalParameters.EVP__c = UserInfo.getUserId();
        doaApprovalParameters.CFO__c = UserInfo.getUserId();
        doaApprovalParameters.Sales_Threshold_1__c = 250000;
        doaApprovalParameters.Sales_Threshold_2__c = 3000000;
        doaApprovalParameters.Sales_Threshold_3__c = 5000000;
        doaApprovalParameters.Sales_Threshold_4__c = 10000000;
        insert doaApprovalParameters;
        
        CameleonCPQ__QxQuote__c pq = new CameleonCPQ__QxQuote__c();
        pq.Name = 'Test_Quote_1';
        pq.CameleonCPQ__AccountId__c = acc.id;
        //pq.Agreement_Term__c = 1;
        //pq.CDM__c = UserInfo.getUserId();
        pq.Sales_Rep__c = usrs[0].Id;
        pq.CameleonCPQ__SyncStatus__c = 'COMPLETE';
         pq.Primary_Quote__c = True;
        
        insert pq;
       
    }
    
    public static testMethod void hardStopTest() {
        Account acc = [SELECT Id, Written_Agreement__c FROM Account WHERE Name = 'Test'];
        acc.Written_Agreement__c = true;
        update acc;
        CameleonCPQ__QxQuote__c pq = [SELECT Id, DOA_Approval_Status__c, Sales_Rep__c, CameleonCPQ__AccountId__c, Account_Hosted_Flag__c FROM CameleonCPQ__QxQuote__c WHERE Name = 'Test_Quote_1'];
        pq.No_customization_on_inherited_core_sku__c = true;
         pq.LF_Count_Hard_Stop_Follower__c = 1;
        update pq;
        
        Test.startTest();
        
        SubmitDOAApproval doa = new SubmitDOAApproval(new ApexPages.StandardController(pq));
        doa.OnloadPage();
        
        Test.stopTest();
    }
    
    public static testMethod void QLIErrorTest() {
    Id cptRTId = Schema.SObjectType.CameleonCPQ__QxQuoteLine__c.getRecordTypeInfosByName().get('CPT').getRecordTypeId();
        Account acc = [SELECT Id, Written_Agreement__c FROM Account WHERE Name = 'Test'];
        acc.Written_Agreement__c = true;
        update acc;
        CameleonCPQ__QxQuote__c pq = [SELECT Id, DOA_Approval_Status__c, Sales_Rep__c, CameleonCPQ__AccountId__c, Account_Hosted_Flag__c FROM CameleonCPQ__QxQuote__c WHERE Name = 'Test_Quote_1'];
        pq.No_customization_on_inherited_core_sku__c = true;
       
        update pq;
        
        CameleonCPQ__QxQuoteLine__c qline1=new CameleonCPQ__QxQuoteLine__c();
        qline1.Violation_Type__c='Compliance';
        qline1.Violation_Message__c='test';
        qline1.recordtypeId = cptRTId;
        qline1.CameleonCPQ__QuoteId__c=pq.id;
        qline1.Error_Message__c = 'Test Error';
        insert qline1;
        
        Test.startTest();
        
        SubmitDOAApproval doa = new SubmitDOAApproval(new ApexPages.StandardController(pq));
        doa.OnloadPage();
        
        Test.stopTest();
    }
    
     public static testMethod void Alreadysubmitted_test() {
        Account acc = [SELECT Id, Written_Agreement__c FROM Account WHERE Name = 'Test'];
        acc.Written_Agreement__c = true;
        update acc;
        
         CameleonCPQ__QxQuote__c pq = new CameleonCPQ__QxQuote__c();
        pq.Name = 'Test_Quote_1';
        pq.CameleonCPQ__AccountId__c = acc.id;
        pq.Agreement_Term__c = 1;
        pq.CDM__c = UserInfo.getUserId();
        pq.CameleonCPQ__SyncStatus__c = 'COMPLETE';
        pq.DOA_Approval_Status__c = 'Approval Submitted';
        pq.Customer_communication_requirements__c = 'Notification';
        insert pq;
        
        Test.startTest();
        
        SubmitDOAApproval doa = new SubmitDOAApproval(new ApexPages.StandardController(pq));
        doa.OnloadPage();
        
        Test.stopTest();
    }
    
     public static testMethod void SyncInProgress_test() {
        CameleonCPQ__QxQuote__c pq = [SELECT Id, DOA_Approval_Status__c, Sales_Rep__c, CameleonCPQ__AccountId__c, Account_Hosted_Flag__c FROM CameleonCPQ__QxQuote__c WHERE Name = 'Test_Quote_1'];
        pq.No_customization_on_inherited_core_sku__c = true;
         pq.CameleonCPQ__SyncStatus__c = 'IN_PROGRESS';
        
        update pq;
        
        Test.startTest();
        
        SubmitDOAApproval doa = new SubmitDOAApproval(new ApexPages.StandardController(pq));
        doa.OnloadPage();
        
        Test.stopTest();
    }
    
     public static testMethod void CoreDuplicate_test() {
        CameleonCPQ__QxQuote__c pq = [SELECT Id, DOA_Approval_Status__c, Sales_Rep__c, CameleonCPQ__AccountId__c, Account_Hosted_Flag__c FROM CameleonCPQ__QxQuote__c WHERE Name = 'Test_Quote_1'];
        pq.No_customization_on_inherited_core_sku__c = true;
         pq.Core_Duplicate__c = 1;
        
        update pq;
        
        Test.startTest();
        
        SubmitDOAApproval doa = new SubmitDOAApproval(new ApexPages.StandardController(pq));
        doa.OnloadPage();
        
        Test.stopTest();
    }
    
      public static testMethod void Potential_test() {
        Account acc = [SELECT Id, AOPS_Cust_ID__c FROM Account WHERE Name =: 'Test'];
        acc.AOPS_Cust_ID__c = '12345678';
        update acc;
        CameleonCPQ__QxQuote__c pq = [SELECT Id, DOA_Approval_Status__c, Sales_Rep__c, CameleonCPQ__AccountId__c FROM CameleonCPQ__QxQuote__c WHERE Name = 'Test_Quote_1'];
        pq.New_Contract_Amendment_DOA__c = true;
          
          pq.CDM_Approver__c = null;
           pq.Managing_Director__c = null;
           pq.CPD_Director__c = null;
           pq.CBFS_VP__c = null;
           pq.Senior_Director__c = null;
           pq.VP__c = null;
           pq.SVP__c = null;
           pq.EVP__c = null;         
           pq.CFO__c = null;
           pq.BSD_Queue__c = false;
           pq.Compliance__c = false;
           pq.Finance_Queue__c = false;
           pq.B2B_Integration_Queue__c = false;
        update pq;
          
          
        Test.startTest();
        
        SubmitDOAApproval doa = new SubmitDOAApproval(new ApexPages.StandardController(pq));
        doa.OnloadPage();
       // doa.updateQuoteDOA(pq);
          doa.hasWrittenAgreementInHierarchy();
              doa.hasNonWrittenAgreementInHierarchy();
            
            
        Test.stopTest();
    }
     public static testMethod void pricingComplianceTestHierarchyMismatchNoWrittenAgreement() {
        Account acc2 = [SELECT Id FROM Account WHERE Name = 'Test2'];
        Account acc3 = [SELECT Id FROM Account WHERE Name = 'Test3'];
        CameleonCPQ__QxQuote__c pq = [SELECT Id, DOA_Approval_Status__c, Sales_Rep__c, CameleonCPQ__AccountId__c, Account_Hosted_Flag__c FROM CameleonCPQ__QxQuote__c WHERE Name = 'Test_Quote_1'];
        pq.Default_Parent__c = acc2.Id;
        pq.Parent__c = acc3.Id;
        update pq;
        
        Test.startTest();
        SubmitDOAApproval doa = new SubmitDOAApproval(new ApexPages.StandardController(pq));
        doa.OnloadPage();
        //System.assertEquals(true, doa.quoteRecord.BSD_Queue__c);
        Test.stopTest();
    }

    public static testMethod void pricingComplianceTestHierarchyMismatchWithWrittenAgreement() {
        Account acc = [SELECT Id, Written_Agreement__c FROM Account WHERE Name = 'Test'];
        acc.Written_Agreement__c = true;
        acc.Legal_Flag__c ='Y';
        update acc;
        Account acc2 = [SELECT Id FROM Account WHERE Name = 'Test2'];
        Account acc3 = [SELECT Id FROM Account WHERE Name = 'Test3'];
        
        Test.startTest();
        CameleonCPQ__QxQuote__c pq = [SELECT Id, DOA_Approval_Status__c, Sales_Rep__c, CameleonCPQ__AccountId__c, Account_Hosted_Flag__c FROM CameleonCPQ__QxQuote__c WHERE Name = 'Test_Quote_1'];
        pq.Default_Parent__c = acc2.Id;
        pq.Parent__c = acc3.Id;
        update pq;
        SubmitDOAApproval doa = new SubmitDOAApproval(new ApexPages.StandardController(pq));
        doa.OnloadPage();
        //System.assertEquals(true, doa.quoteRecord.BSD_Queue__c);
        Test.stopTest();
    }
   /* public static testMethod void pricingComplianceTestNoCustomizationInheritedCoreSku() {
        Account acc = [SELECT Id, Written_Agreement__c FROM Account WHERE Name = 'Test'];
        acc.Written_Agreement__c = true;
        update acc;
        CameleonCPQ__QxQuote__c pq = [SELECT Id, DOA_Approval_Status__c, Sales_Rep__c, CameleonCPQ__AccountId__c, Account_Hosted_Flag__c FROM CameleonCPQ__QxQuote__c WHERE Name = 'Test_Quote_1'];
        pq.No_customization_on_inherited_core_sku__c = true;
        update pq;
        
        Test.startTest();
        SubmitDOAApproval doa = new SubmitDOAApproval(new ApexPages.StandardController(pq));
        doa.OnloadPage();
        //System.assertEquals(true, doa.quoteRecord.Compliance__c);
        Test.stopTest();
    } */
    
    public static testMethod void pricingComplianceTestForcedInheritance() {
        Account acc = [SELECT Id, Written_Agreement__c FROM Account WHERE Name = 'Test'];
        acc.Written_Agreement__c = true;
        update acc;
        CameleonCPQ__QxQuote__c pq = [SELECT Id, DOA_Approval_Status__c, Sales_Rep__c, CameleonCPQ__AccountId__c, Account_Hosted_Flag__c FROM CameleonCPQ__QxQuote__c WHERE Name = 'Test_Quote_1'];
        pq.DOA_Forced_Inheritance_Flag__c = true;
        update pq;
        
        Test.startTest();
        SubmitDOAApproval doa = new SubmitDOAApproval(new ApexPages.StandardController(pq));
        doa.OnloadPage();
        System.assertEquals(true, doa.quoteRecord.Compliance__c);
        Test.stopTest();
    }
    
    public static testMethod void maintenanceTestHierarchyMismatch() {
        List<User> usrs = [SELECT Id, Job_Code_Level__c FROM User WHERE LastName = 'SubmitDOAApprovalTest'];
        User director = getDirector(usrs);
        User vp = getVp(usrs);

        Account acc = [SELECT Id, Written_Agreement__c FROM Account WHERE Name = 'Test'];
        acc.Written_Agreement__c = true;
        update acc;
        Account acc2 = [SELECT Id FROM Account WHERE Name = 'Test2'];
        Account acc3 = [SELECT Id FROM Account WHERE Name = 'Test3'];

        Test.startTest();
        CameleonCPQ__QxQuote__c pq = [SELECT Id, DOA_Approval_Status__c, Sales_Rep__c, CameleonCPQ__AccountId__c FROM CameleonCPQ__QxQuote__c WHERE Name = 'Test_Quote_1'];
        pq.New_Contract_Amendment_DOA__c = false;
        pq.Default_Parent__c = acc2.Id;
        pq.Parent__c = acc3.Id;
        update pq;
        SubmitDOAApproval doa = new SubmitDOAApproval(new ApexPages.StandardController(pq));
        doa.OnloadPage();
        //System.assertEquals(director.Id, doa.quoteRecord.Managing_Director__c);
        Test.stopTest();
    }
    
    
    /*  public static testMethod void maintenanceTestPriceFreezeViolation() {
     List<User> usrs = [SELECT Id, Job_Code_Level__c FROM User WHERE LastName = 'SubmitDOAApprovalTest'];
        User director = getDirector(usrs);
        User vp = getVp(usrs);

        Account acc = [SELECT Id, Written_Agreement__c FROM Account WHERE Name = 'Test'];
        acc.AOPS_Cust_ID__c = '12345678';
        acc.Written_Agreement__c = true;
        update acc;
        CameleonCPQ__QxQuote__c pq = [SELECT Id, DOA_Approval_Status__c, Sales_Rep__c, CameleonCPQ__AccountId__c FROM CameleonCPQ__QxQuote__c WHERE Name = 'Test_Quote_1'];
       // pq.New_Contract_Amendment_DOA__c = false;
        pq.DOA_Price_Freeze_Violation__c = true;
        pq.CDM__c = UserInfo.getUserId();
        pq.Agreement_Term__c = 1;
        update pq;

        Test.startTest();
        SubmitDOAApproval doa = new SubmitDOAApproval(new ApexPages.StandardController(pq));
        doa.OnloadPage();
        //System.assertEquals(director.Id, doa.quoteRecord.Managing_Director__c);
        //System.assertEquals(vp.Id, doa.quoteRecord.VP__c);
        Test.stopTest();
    }
    */
   
    
   /* public static testMethod void maintenanceTestItemCountViolation() {
        List<User> usrs = [SELECT Id, Job_Code_Level__c FROM User WHERE LastName = 'SubmitDOAApprovalTest'];
        User director = getDirector(usrs);
        User vp = getVp(usrs);

        Account acc = [SELECT Id, Written_Agreement__c FROM Account WHERE Name = 'Test'];
        acc.Written_Agreement__c = true;
        update acc;
        CameleonCPQ__QxQuote__c pq = [SELECT Id, DOA_Approval_Status__c, Sales_Rep__c, CameleonCPQ__AccountId__c FROM CameleonCPQ__QxQuote__c WHERE Name = 'Test_Quote_1'];
       // pq.New_Contract_Amendment_DOA__c = false;
        pq.DOA_Item_Count_Violation__c = true;
        update pq;

        Test.startTest();
        SubmitDOAApproval doa = new SubmitDOAApproval(new ApexPages.StandardController(pq));
        doa.OnloadPage();
        //System.assertEquals(director.Id, doa.quoteRecord.Managing_Director__c);
        //System.assertEquals(vp.Id, doa.quoteRecord.VP__c);
        Test.stopTest();
    }
    */
    
    public static testMethod void maintenanceTestMarginImpactGreater100K() {
        List<User> usrs = [SELECT Id, Job_Code_Level__c FROM User WHERE LastName = 'SubmitDOAApprovalTest'];
        User director = getDirector(usrs);
        User vp = getVp(usrs);

        Account acc = [SELECT Id, Written_Agreement__c FROM Account WHERE Name = 'Test'];
        acc.Written_Agreement__c = true;
        update acc;
        CameleonCPQ__QxQuote__c pq = [SELECT Id, DOA_Approval_Status__c, Sales_Rep__c, CameleonCPQ__AccountId__c FROM CameleonCPQ__QxQuote__c WHERE Name = 'Test_Quote_1'];
        pq.New_Contract_Amendment_DOA__c = false;
        pq.Price_Change_Impact_Current_Only__c = 100001;
        update pq;

        Test.startTest();
        SubmitDOAApproval doa = new SubmitDOAApproval(new ApexPages.StandardController(pq));
        doa.OnloadPage();
       Test.stopTest();
    } 
 public static testMethod void maintenanceTestSkuBelowFloor() {
        List<User> usrs = [SELECT Id, Job_Code_Level__c FROM User WHERE LastName = 'SubmitDOAApprovalTest'];
        User director = getDirector(usrs);
        User vp = getVp(usrs);

        Account acc = [SELECT Id, Written_Agreement__c FROM Account WHERE Name = 'Test'];
        acc.Written_Agreement__c = true;
        update acc;
        CameleonCPQ__QxQuote__c pq = [SELECT Id, DOA_Approval_Status__c, Sales_Rep__c, CameleonCPQ__AccountId__c FROM CameleonCPQ__QxQuote__c WHERE Name = 'Test_Quote_1'];
        pq.New_Contract_Amendment_DOA__c = false;
        pq.DOA_SKU_Below_Floor_Flag__c = true;
        update pq;

        Test.startTest();
        SubmitDOAApproval doa = new SubmitDOAApproval(new ApexPages.StandardController(pq));
        doa.OnloadPage();
        Test.stopTest();
    }

    public static testMethod void maintenanceTestInheritedCoreSkuDecreases() {
        List<User> usrs = [SELECT Id, Job_Code_Level__c FROM User WHERE LastName = 'SubmitDOAApprovalTest'];
        User director = getDirector(usrs);
        User vp = getVp(usrs);

        Account acc = [SELECT Id, Written_Agreement__c FROM Account WHERE Name = 'Test'];
        acc.Written_Agreement__c = true;
        update acc;
        CameleonCPQ__QxQuote__c pq = [SELECT Id, DOA_Approval_Status__c, Sales_Rep__c, CameleonCPQ__AccountId__c FROM CameleonCPQ__QxQuote__c WHERE Name = 'Test_Quote_1'];
        pq.New_Contract_Amendment_DOA__c = false;
        pq.DOA_Custom_Price_Decrease_Flag__c = true;
        update pq;

        Test.startTest();
        SubmitDOAApproval doa = new SubmitDOAApproval(new ApexPages.StandardController(pq));
        doa.OnloadPage();
        Test.stopTest();
    }

    public static testMethod void maintenanceTestForcedInheritance() {
        List<User> usrs = [SELECT Id, Job_Code_Level__c FROM User WHERE LastName = 'SubmitDOAApprovalTest'];
        User director = getDirector(usrs);
        User vp = getVp(usrs);

        Account acc = [SELECT Id, Written_Agreement__c FROM Account WHERE Name = 'Test'];
        acc.Written_Agreement__c = true;
        update acc;
        CameleonCPQ__QxQuote__c pq = [SELECT Id, DOA_Approval_Status__c, Sales_Rep__c, CameleonCPQ__AccountId__c FROM CameleonCPQ__QxQuote__c WHERE Name = 'Test_Quote_1'];
        pq.New_Contract_Amendment_DOA__c = false;
        pq.DOA_Forced_Inheritance_Flag__c = true;
        update pq;

        Test.startTest();
        SubmitDOAApproval doa = new SubmitDOAApproval(new ApexPages.StandardController(pq));
        doa.OnloadPage();
        Test.stopTest();
    }

   /* public static testMethod void maintenanceTestCustomMoreThanInherited() {
        List<User> usrs = [SELECT Id, Job_Code_Level__c FROM User WHERE LastName = 'SubmitDOAApprovalTest'];
        User director = getDirector(usrs);
        User vp = getVp(usrs);

        Account acc = [SELECT Id, Written_Agreement__c FROM Account WHERE Name = 'Test'];
        acc.Written_Agreement__c = true;
        update acc;
        CameleonCPQ__QxQuote__c pq = [SELECT Id, DOA_Approval_Status__c, Sales_Rep__c, CameleonCPQ__AccountId__c FROM CameleonCPQ__QxQuote__c WHERE Name = 'Test_Quote_1'];
        pq.New_Contract_Amendment_DOA__c = false;
        pq.DOA_Custom_Price_More_Inherited_Flag__c = true;
        update pq;

        Test.startTest();
        SubmitDOAApproval doa = new SubmitDOAApproval(new ApexPages.StandardController(pq));
        doa.OnloadPage();
        Test.stopTest();
    }
    */

  /*  public static testMethod void maintenanceTestCustomMoreThanInherited() {
        List<User> usrs = [SELECT Id, Job_Code_Level__c FROM User WHERE LastName = 'SubmitDOAApprovalTest'];
        User director = getDirector(usrs);
        User vp = getVp(usrs);

        Account acc = [SELECT Id, Written_Agreement__c FROM Account WHERE Name = 'Test'];
        acc.Written_Agreement__c = true;
        update acc;
        
        Test.startTest();
        CameleonCPQ__QxQuote__c pq = [SELECT Id, DOA_Approval_Status__c, Sales_Rep__c, CameleonCPQ__AccountId__c FROM CameleonCPQ__QxQuote__c WHERE Name = 'Test_Quote_1'];
        pq.New_Contract_Amendment_DOA__c = false;
        pq.DOA_Custom_Price_Less_Inherited_Flag__c = true;
        update pq;

        
        SubmitDOAApproval doa = new SubmitDOAApproval(new ApexPages.StandardController(pq));
        doa.OnloadPage();
        //System.assertEquals(director.Id, doa.quoteRecord.Managing_Director__c);
        //System.assertEquals(vp.Id, doa.quoteRecord.VP__c);
        Test.stopTest();
    } */
    
    public static testMethod void maintenanceTestMarginImpact50KTo100K() {
        List<User> usrs = [SELECT Id, Job_Code_Level__c FROM User WHERE LastName = 'SubmitDOAApprovalTest'];
        User director = getDirector(usrs);
        User vp = getVp(usrs);

        Account acc = [SELECT Id, Written_Agreement__c FROM Account WHERE Name = 'Test'];
        acc.Written_Agreement__c = true;
        update acc;
        CameleonCPQ__QxQuote__c pq = [SELECT Id, DOA_Approval_Status__c, Sales_Rep__c, CameleonCPQ__AccountId__c FROM CameleonCPQ__QxQuote__c WHERE Name = 'Test_Quote_1'];
        pq.New_Contract_Amendment_DOA__c = false;
        pq.Price_Change_Impact_Current_Only__c = 75000;
        update pq;

        Test.startTest();
        SubmitDOAApproval doa = new SubmitDOAApproval(new ApexPages.StandardController(pq));
        doa.OnloadPage();
        Test.stopTest();
    }
    
    public static testMethod void cpmTestExistingCustAndSalesGreater500K() {
        List<User> usrs = [SELECT Id, Job_Code_Level__c FROM User WHERE LastName = 'SubmitDOAApprovalTest'];
        User manager = getManager(usrs);
        User director = getDirector(usrs);
        User seniorDirector = getSeniorDirector(usrs);
        User vp = getVp(usrs);
        User svp = getSvp(usrs);

        Account acc = [SELECT Id, AOPS_Cust_ID__c FROM Account WHERE Name =: 'Test'];
        acc.AOPS_Cust_ID__c = '12345678';
        update acc;
        CameleonCPQ__QxQuote__c pq = [SELECT Id, DOA_Approval_Status__c, Sales_Rep__c, CameleonCPQ__AccountId__c FROM CameleonCPQ__QxQuote__c WHERE Name = 'Test_Quote_1'];
        pq.New_Contract_Amendment_DOA__c = true;
        pq.Annual_Contract_Sales_Gross__c = 500001;
        update pq;

        Test.startTest();
        SubmitDOAApproval doa = new SubmitDOAApproval(new ApexPages.StandardController(pq));
        doa.OnloadPage();
       

        pq.Annual_Contract_Sales_Gross__c = 1000001;
        update pq;
        doa = new SubmitDOAApproval(new ApexPages.StandardController(pq));
        doa.OnloadPage();
       
        Test.stopTest();
    }
    
     public static testMethod void cpmTestExistingCustAndSalesGreater500K22() {
        List<User> usrs = [SELECT Id, Job_Code_Level__c FROM User WHERE LastName = 'SubmitDOAApprovalTest'];
        User manager = getManager(usrs);
        User director = getDirector(usrs);
        User seniorDirector = getSeniorDirector(usrs);
        User vp = getVp(usrs);
        User svp = getSvp(usrs);

        Account acc = [SELECT Id, AOPS_Cust_ID__c FROM Account WHERE Name =: 'Test'];
        acc.AOPS_Cust_ID__c = '12345678';
        update acc;
        CameleonCPQ__QxQuote__c pq = [SELECT Id, DOA_Approval_Status__c, Sales_Rep__c, CameleonCPQ__AccountId__c FROM CameleonCPQ__QxQuote__c WHERE Name = 'Test_Quote_1'];
        pq.New_Contract_Amendment_DOA__c = true;
       pq.Annual_Contract_Sales_Gross__c = 3000001;
        update pq;
        Test.startTest();
       
        SubmitDOAApproval doa = new SubmitDOAApproval(new ApexPages.StandardController(pq));
        doa.OnloadPage();
       


        
        doa = new SubmitDOAApproval(new ApexPages.StandardController(pq));
        doa.OnloadPage();
        //System.assertEquals(UserInfo.getUserId(), doa.quoteRecord.EVP__c);

       // pq.Annual_Contract_Sales_Gross__c = 500000100;
      //  update pq;
       // doa = new SubmitDOAApproval(new ApexPages.StandardController(pq));
      //  doa.OnloadPage();
        //System.assertEquals(UserInfo.getUserId(), doa.quoteRecord.CFO__c);
        Test.stopTest();
    }
    
    public static testMethod void cpmTestExistingCustAndSalesGreater500K23() {
        List<User> usrs = [SELECT Id, Job_Code_Level__c FROM User WHERE LastName = 'SubmitDOAApprovalTest'];
        User manager = getManager(usrs);
        User director = getDirector(usrs);
        User seniorDirector = getSeniorDirector(usrs);
        User vp = getVp(usrs);
        User svp = getSvp(usrs);

        Account acc = [SELECT Id, AOPS_Cust_ID__c FROM Account WHERE Name =: 'Test'];
        acc.AOPS_Cust_ID__c = '12345678';
        update acc;
        CameleonCPQ__QxQuote__c pq = [SELECT Id, DOA_Approval_Status__c, Sales_Rep__c, CameleonCPQ__AccountId__c FROM CameleonCPQ__QxQuote__c WHERE Name = 'Test_Quote_1'];
        pq.New_Contract_Amendment_DOA__c = true;
       pq.Annual_Contract_Sales_Gross__c = 500000100;
        update pq;
        Test.startTest();
       
        SubmitDOAApproval doa = new SubmitDOAApproval(new ApexPages.StandardController(pq));
        doa.OnloadPage();
       


        
        doa = new SubmitDOAApproval(new ApexPages.StandardController(pq));
        doa.OnloadPage();
        //System.assertEquals(UserInfo.getUserId(), doa.quoteRecord.EVP__c);

       // pq.Annual_Contract_Sales_Gross__c = 500000100;
      //  update pq;
       // doa = new SubmitDOAApproval(new ApexPages.StandardController(pq));
      //  doa.OnloadPage();
        //System.assertEquals(UserInfo.getUserId(), doa.quoteRecord.CFO__c);
        Test.stopTest();
    }
    
    public static testMethod void cpmTestExistingCustAndSalesGreater500K24() {
        List<User> usrs = [SELECT Id, Job_Code_Level__c FROM User WHERE LastName = 'SubmitDOAApprovalTest'];
        User manager = getManager(usrs);
        User director = getDirector(usrs);
        User seniorDirector = getSeniorDirector(usrs);
        User vp = getVp(usrs);
        User svp = getSvp(usrs);

        Account acc = [SELECT Id, AOPS_Cust_ID__c FROM Account WHERE Name =: 'Test'];
        acc.AOPS_Cust_ID__c = '12345678';
        update acc;
        CameleonCPQ__QxQuote__c pq = [SELECT Id, DOA_Approval_Status__c, Sales_Rep__c, CameleonCPQ__AccountId__c FROM CameleonCPQ__QxQuote__c WHERE Name = 'Test_Quote_1'];
        pq.New_Contract_Amendment_DOA__c = true;
       pq.Annual_Contract_Sales_Gross__c = 6000001;
        update pq;
        Test.startTest();
       
        SubmitDOAApproval doa = new SubmitDOAApproval(new ApexPages.StandardController(pq));
        doa.OnloadPage();
       


        
        doa = new SubmitDOAApproval(new ApexPages.StandardController(pq));
        doa.OnloadPage();
        //System.assertEquals(UserInfo.getUserId(), doa.quoteRecord.EVP__c);

       // pq.Annual_Contract_Sales_Gross__c = 500000100;
      //  update pq;
       // doa = new SubmitDOAApproval(new ApexPages.StandardController(pq));
      //  doa.OnloadPage();
        //System.assertEquals(UserInfo.getUserId(), doa.quoteRecord.CFO__c);
        Test.stopTest();
    }
    
    public static testMethod void cpmTestFailsCashFlow() {
        List<User> usrs = [SELECT Id, Job_Code_Level__c FROM User WHERE LastName = 'SubmitDOAApprovalTest'];
        User manager = getManager(usrs);
        User director = getDirector(usrs);
        User seniorDirector = getSeniorDirector(usrs);
        User vp = getVp(usrs);
        User svp = getSvp(usrs);

        CameleonCPQ__QxQuote__c pq = [SELECT Id, DOA_Approval_Status__c, Sales_Rep__c, CameleonCPQ__AccountId__c FROM CameleonCPQ__QxQuote__c WHERE Name = 'Test_Quote_1'];
        pq.New_Contract_Amendment_DOA__c = true;
        pq.Up_Front_Cash_Rebate__c = 1;
        //pq.CPM_Net_Inflow_Total_Contract__c = 1;
        pq.CPM_Net_Present_Value_Total_Contract__c = -1;
        pq.Annual_Contract_Sales_Gross__c = 100000;
       //pq.CPM_Cashflow_Test__c = 'FAILS CASHFLOW';
        update pq;

       test.starttest();
        SubmitDOAApproval doa = new SubmitDOAApproval(new ApexPages.StandardController(pq));
        doa.OnloadPage();
        test.stoptest();
        }
        
        public static testMethod void cpmTestFailsCashFlow2() {
        List<User> usrs = [SELECT Id, Job_Code_Level__c FROM User WHERE LastName = 'SubmitDOAApprovalTest'];
        User manager = getManager(usrs);
        User director = getDirector(usrs);
        User seniorDirector = getSeniorDirector(usrs);
        User vp = getVp(usrs);
        User svp = getSvp(usrs);

        CameleonCPQ__QxQuote__c pq = [SELECT Id, DOA_Approval_Status__c, Sales_Rep__c, CameleonCPQ__AccountId__c FROM CameleonCPQ__QxQuote__c WHERE Name = 'Test_Quote_1'];
        pq.New_Contract_Amendment_DOA__c = true;
        pq.Up_Front_Cash_Rebate__c = 1;
        //pq.CPM_Net_Inflow_Total_Contract__c = 1;
        pq.CPM_Net_Present_Value_Total_Contract__c = -1;
        pq.Annual_Contract_Sales_Gross__c = 1000000;
       //pq.CPM_Cashflow_Test__c = 'FAILS CASHFLOW';
        update pq;

       test.starttest();
        SubmitDOAApproval doa = new SubmitDOAApproval(new ApexPages.StandardController(pq));
        doa.OnloadPage();
        test.stoptest();
        }
        
        public static testMethod void cpmTestFailsCashFlow3() {
        List<User> usrs = [SELECT Id, Job_Code_Level__c FROM User WHERE LastName = 'SubmitDOAApprovalTest'];
        User manager = getManager(usrs);
        User director = getDirector(usrs);
        User seniorDirector = getSeniorDirector(usrs);
        User vp = getVp(usrs);
        User svp = getSvp(usrs);

        CameleonCPQ__QxQuote__c pq = [SELECT Id, DOA_Approval_Status__c, Sales_Rep__c, CameleonCPQ__AccountId__c FROM CameleonCPQ__QxQuote__c WHERE Name = 'Test_Quote_1'];
        pq.New_Contract_Amendment_DOA__c = true;
        pq.Up_Front_Cash_Rebate__c = 1;
        //pq.CPM_Net_Inflow_Total_Contract__c = 1;
        pq.CPM_Net_Present_Value_Total_Contract__c = -1;
        pq.Annual_Contract_Sales_Gross__c = 4000000;
       //pq.CPM_Cashflow_Test__c = 'FAILS CASHFLOW';
        update pq;

       test.starttest();
        SubmitDOAApproval doa = new SubmitDOAApproval(new ApexPages.StandardController(pq));
        doa.OnloadPage();
        test.stoptest();
        }
        public static testMethod void cpmTestFailsCashFlow4() {
        List<User> usrs = [SELECT Id, Job_Code_Level__c FROM User WHERE LastName = 'SubmitDOAApprovalTest'];
        User manager = getManager(usrs);
        User director = getDirector(usrs);
        User seniorDirector = getSeniorDirector(usrs);
        User vp = getVp(usrs);
        User svp = getSvp(usrs);

        CameleonCPQ__QxQuote__c pq = [SELECT Id, DOA_Approval_Status__c, Sales_Rep__c, CameleonCPQ__AccountId__c FROM CameleonCPQ__QxQuote__c WHERE Name = 'Test_Quote_1'];
        pq.New_Contract_Amendment_DOA__c = true;
        pq.Up_Front_Cash_Rebate__c = 1;
        //pq.CPM_Net_Inflow_Total_Contract__c = 1;
        pq.CPM_Net_Present_Value_Total_Contract__c = -1;
        pq.Annual_Contract_Sales_Gross__c = 7000000;
       //pq.CPM_Cashflow_Test__c = 'FAILS CASHFLOW';
        update pq;

       test.starttest();
        SubmitDOAApproval doa = new SubmitDOAApproval(new ApexPages.StandardController(pq));
        doa.OnloadPage();
        test.stoptest();
        }
        
         public static testMethod void cpmTestFailsCashFlow5() {
        List<User> usrs = [SELECT Id, Job_Code_Level__c FROM User WHERE LastName = 'SubmitDOAApprovalTest'];
        User manager = getManager(usrs);
        User director = getDirector(usrs);
        User seniorDirector = getSeniorDirector(usrs);
        User vp = getVp(usrs);
        User svp = getSvp(usrs);

        CameleonCPQ__QxQuote__c pq = [SELECT Id, DOA_Approval_Status__c, Sales_Rep__c, CameleonCPQ__AccountId__c FROM CameleonCPQ__QxQuote__c WHERE Name = 'Test_Quote_1'];
        pq.New_Contract_Amendment_DOA__c = true;
        pq.Up_Front_Cash_Rebate__c = 1;
        //pq.CPM_Net_Inflow_Total_Contract__c = 1;
        pq.CPM_Net_Present_Value_Total_Contract__c = -1;
        pq.Annual_Contract_Sales_Gross__c = 700000000;
       //pq.CPM_Cashflow_Test__c = 'FAILS CASHFLOW';
        update pq;

       test.starttest();
        SubmitDOAApproval doa = new SubmitDOAApproval(new ApexPages.StandardController(pq));
        doa.OnloadPage();
        test.stoptest();
        }
        
        public static testMethod void cpmTestCbfsSales() {
        List<User> usrs = [SELECT Id, Job_Code_Level__c FROM User WHERE LastName = 'SubmitDOAApprovalTest'];
        User manager = getManager(usrs);
        User director = getDirector(usrs);
        User seniorDirector = getSeniorDirector(usrs);
        User vp = getVp(usrs);
        User svp = getSvp(usrs);

        CameleonCPQ__QxQuote__c pq = [SELECT Id, DOA_Approval_Status__c, Sales_Rep__c, CameleonCPQ__AccountId__c FROM CameleonCPQ__QxQuote__c WHERE Name = 'Test_Quote_1'];
        pq.New_Contract_Amendment_DOA__c = true;
        pq.CBFS_Core_Sales__c = 500001;
        pq.Annual_Contract_Sales_Gross__c = 100000;
        update pq;
         
         Test.starttest();
        
        SubmitDOAApproval doa = new SubmitDOAApproval(new ApexPages.StandardController(pq));
        doa.OnloadPage();
        
        test.stoptest();
        
        }
        
         public static testMethod void cpmTestCbfsSales2() {
        List<User> usrs = [SELECT Id, Job_Code_Level__c FROM User WHERE LastName = 'SubmitDOAApprovalTest'];
        User manager = getManager(usrs);
        User director = getDirector(usrs);
        User seniorDirector = getSeniorDirector(usrs);
        User vp = getVp(usrs);
        User svp = getSvp(usrs);

        CameleonCPQ__QxQuote__c pq = [SELECT Id, DOA_Approval_Status__c, Sales_Rep__c, CameleonCPQ__AccountId__c FROM CameleonCPQ__QxQuote__c WHERE Name = 'Test_Quote_1'];
        pq.New_Contract_Amendment_DOA__c = true;
        pq.CBFS_Core_Sales__c = 500001;
        pq.Annual_Contract_Sales_Gross__c = 1000000;
        update pq;
         
         Test.starttest();
        
        SubmitDOAApproval doa = new SubmitDOAApproval(new ApexPages.StandardController(pq));
        doa.OnloadPage();
        
        test.stoptest();
        
        }
        
        public static testMethod void cpmTestCbfsSales3() {
        List<User> usrs = [SELECT Id, Job_Code_Level__c FROM User WHERE LastName = 'SubmitDOAApprovalTest'];
        User manager = getManager(usrs);
        User director = getDirector(usrs);
        User seniorDirector = getSeniorDirector(usrs);
        User vp = getVp(usrs);
        User svp = getSvp(usrs);

        CameleonCPQ__QxQuote__c pq = [SELECT Id, DOA_Approval_Status__c, Sales_Rep__c, CameleonCPQ__AccountId__c FROM CameleonCPQ__QxQuote__c WHERE Name = 'Test_Quote_1'];
        pq.New_Contract_Amendment_DOA__c = true;
        pq.CBFS_Core_Sales__c = 500001;
        pq.Annual_Contract_Sales_Gross__c = 4000000;
        update pq;
         
         Test.starttest();
        
        SubmitDOAApproval doa = new SubmitDOAApproval(new ApexPages.StandardController(pq));
        doa.OnloadPage();
        
        test.stoptest();
        
        }
        public static testMethod void cpmTestCbfsSales4() {
        List<User> usrs = [SELECT Id, Job_Code_Level__c FROM User WHERE LastName = 'SubmitDOAApprovalTest'];
        User manager = getManager(usrs);
        User director = getDirector(usrs);
        User seniorDirector = getSeniorDirector(usrs);
        User vp = getVp(usrs);
        User svp = getSvp(usrs);

        CameleonCPQ__QxQuote__c pq = [SELECT Id, DOA_Approval_Status__c, Sales_Rep__c, CameleonCPQ__AccountId__c FROM CameleonCPQ__QxQuote__c WHERE Name = 'Test_Quote_1'];
        pq.New_Contract_Amendment_DOA__c = true;
        pq.CBFS_Core_Sales__c = 500001;
        pq.Annual_Contract_Sales_Gross__c = 7000000;
        update pq;
         
         Test.starttest();
        
        SubmitDOAApproval doa = new SubmitDOAApproval(new ApexPages.StandardController(pq));
        doa.OnloadPage();
        
        test.stoptest();
        
        }
        public static testMethod void cpmTestCbfsSales5() {
        List<User> usrs = [SELECT Id, Job_Code_Level__c FROM User WHERE LastName = 'SubmitDOAApprovalTest'];
        User manager = getManager(usrs);
        User director = getDirector(usrs);
        User seniorDirector = getSeniorDirector(usrs);
        User vp = getVp(usrs);
        User svp = getSvp(usrs);

        CameleonCPQ__QxQuote__c pq = [SELECT Id, DOA_Approval_Status__c, Sales_Rep__c, CameleonCPQ__AccountId__c FROM CameleonCPQ__QxQuote__c WHERE Name = 'Test_Quote_1'];
        pq.New_Contract_Amendment_DOA__c = true;
        pq.CBFS_Core_Sales__c = 500001;
        pq.Annual_Contract_Sales_Gross__c = 70000000;
        update pq;
         
         Test.starttest();
        
        SubmitDOAApproval doa = new SubmitDOAApproval(new ApexPages.StandardController(pq));
        doa.OnloadPage();
        
        test.stoptest();
        
        }
        
        public static testMethod void cpmTestMostFavoredCustomer() {
        List<User> usrs = [SELECT Id, Job_Code_Level__c FROM User WHERE LastName = 'SubmitDOAApprovalTest'];
        User manager = getManager(usrs);
        User director = getDirector(usrs);
        User seniorDirector = getSeniorDirector(usrs);
        User vp = getVp(usrs);
        User svp = getSvp(usrs);

        CameleonCPQ__QxQuote__c pq = [SELECT Id, DOA_Approval_Status__c, Sales_Rep__c, CameleonCPQ__AccountId__c FROM CameleonCPQ__QxQuote__c WHERE Name = 'Test_Quote_1'];
        pq.New_Contract_Amendment_DOA__c = true;
        pq.MFN__c = true;
        pq.Annual_Contract_Sales_Gross__c = 100000;
        update pq;

        Test.StartTest();
        
        SubmitDOAApproval doa = new SubmitDOAApproval(new ApexPages.StandardController(pq));
        doa.OnloadPage();
        
        Test.StopTest();
        
        }
        
         public static testMethod void cpmTestMostFavoredCustomer2() {
        List<User> usrs = [SELECT Id, Job_Code_Level__c FROM User WHERE LastName = 'SubmitDOAApprovalTest'];
        User manager = getManager(usrs);
        User director = getDirector(usrs);
        User seniorDirector = getSeniorDirector(usrs);
        User vp = getVp(usrs);
        User svp = getSvp(usrs);

        CameleonCPQ__QxQuote__c pq = [SELECT Id, DOA_Approval_Status__c, Sales_Rep__c, CameleonCPQ__AccountId__c FROM CameleonCPQ__QxQuote__c WHERE Name = 'Test_Quote_1'];
        pq.New_Contract_Amendment_DOA__c = true;
        pq.MFN__c = true;
        pq.Annual_Contract_Sales_Gross__c = 1000000;
        update pq;

        Test.StartTest();
        
        SubmitDOAApproval doa = new SubmitDOAApproval(new ApexPages.StandardController(pq));
        doa.OnloadPage();
        
        Test.StopTest();
        
        }
         public static testMethod void cpmTestMostFavoredCustomer3() {
        List<User> usrs = [SELECT Id, Job_Code_Level__c FROM User WHERE LastName = 'SubmitDOAApprovalTest'];
        User manager = getManager(usrs);
        User director = getDirector(usrs);
        User seniorDirector = getSeniorDirector(usrs);
        User vp = getVp(usrs);
        User svp = getSvp(usrs);

        CameleonCPQ__QxQuote__c pq = [SELECT Id, DOA_Approval_Status__c, Sales_Rep__c, CameleonCPQ__AccountId__c FROM CameleonCPQ__QxQuote__c WHERE Name = 'Test_Quote_1'];
        pq.New_Contract_Amendment_DOA__c = true;
        pq.MFN__c = true;
        pq.Annual_Contract_Sales_Gross__c = 4000000;
        update pq;

        Test.StartTest();
        
        SubmitDOAApproval doa = new SubmitDOAApproval(new ApexPages.StandardController(pq));
        doa.OnloadPage();
        
        Test.StopTest();
        
        }
        public static testMethod void cpmTestMostFavoredCustomer4() {
        List<User> usrs = [SELECT Id, Job_Code_Level__c FROM User WHERE LastName = 'SubmitDOAApprovalTest'];
        User manager = getManager(usrs);
        User director = getDirector(usrs);
        User seniorDirector = getSeniorDirector(usrs);
        User vp = getVp(usrs);
        User svp = getSvp(usrs);

        CameleonCPQ__QxQuote__c pq = [SELECT Id, DOA_Approval_Status__c, Sales_Rep__c, CameleonCPQ__AccountId__c FROM CameleonCPQ__QxQuote__c WHERE Name = 'Test_Quote_1'];
        pq.New_Contract_Amendment_DOA__c = true;
        pq.MFN__c = true;
        pq.Annual_Contract_Sales_Gross__c = 7000000;
        update pq;

        Test.StartTest();
        
        SubmitDOAApproval doa = new SubmitDOAApproval(new ApexPages.StandardController(pq));
        doa.OnloadPage();
        
        Test.StopTest();
        
        }
        
        public static testMethod void cpmTestMostFavoredCustomer5() {
        List<User> usrs = [SELECT Id, Job_Code_Level__c FROM User WHERE LastName = 'SubmitDOAApprovalTest'];
        User manager = getManager(usrs);
        User director = getDirector(usrs);
        User seniorDirector = getSeniorDirector(usrs);
        User vp = getVp(usrs);
        User svp = getSvp(usrs);

        CameleonCPQ__QxQuote__c pq = [SELECT Id, DOA_Approval_Status__c, Sales_Rep__c, CameleonCPQ__AccountId__c FROM CameleonCPQ__QxQuote__c WHERE Name = 'Test_Quote_1'];
        pq.New_Contract_Amendment_DOA__c = true;
        pq.MFN__c = true;
        pq.Annual_Contract_Sales_Gross__c = 70000000;
        update pq;

        Test.StartTest();
        
        SubmitDOAApproval doa = new SubmitDOAApproval(new ApexPages.StandardController(pq));
        doa.OnloadPage();
        
        Test.StopTest();
        
        }
    
    private static User getManager(List<User> usrs) {
        for(User usr : usrs) {
            if(usr.Job_Code_Level__c == 'Manager') {
                return usr;
            }
        }
        return null;
    }

    private static User getDirector(List<User> usrs) {
        for(User usr : usrs) {
            if(usr.Job_Code_Level__c == 'Director') {
                return usr;
            }
        }
        return null;
    }

    private static User getSeniorDirector(List<User> usrs) {
        for(User usr : usrs) {
            if(usr.Job_Code_Level__c == 'Senior Director') {
                return usr;
            }
        }
        return null;
    }

    private static User getVp(List<User> usrs) {
        for(User usr : usrs) {
            if(usr.Job_Code_Level__c == 'VP') {
                return usr;
            }
        }
        return null;
    }

    private static User getSvp(List<User> usrs) {
        for(User usr : usrs) {
            if(usr.Job_Code_Level__c == 'SVP') {
                return usr;
            }
        }
        return null;
    }
    
    
    
    }
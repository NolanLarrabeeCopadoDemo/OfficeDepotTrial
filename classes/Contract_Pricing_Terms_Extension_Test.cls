/**@@
#CLASS NAME  :  Contract_Pricing_Terms_Extension_Test
#DESCRIPTION :  Test class for "Contract_Pricing_Terms_Extension" 
#CREATEDDATE :  16-09-2019 (DD-MM-YYYY) 
@@**/
@Istest
public class Contract_Pricing_Terms_Extension_Test {
    
    @TestSetup public static void setup(){
        List<User> userList = DataFactory.createUserTestRecords('Test User',2);
        List<Account> accountList = DataFactory.createAccountTestRecords('Test acc', 5, '');
        List<Account> childAccountList = DataFactory.createAccountTestRecords('Test acc', 1, accountList[0].id);
        if(accountList != null && accountList.size() > 0){
            List<Contract> contractList =  DataFactory.createContractTestRecords('Test contract', childAccountList [0].id, 5);
            List<Contract_Pricing_Terms__c> cptList = DataFactory.createContractPriceTermsTestRecords('Testing', contractList[0].id, 5);
        }
    }
    
    static testmethod void cptExtensionTestMethod(){
        List<Contract> contractList = [Select id,Contract_Status__c,Other_contract_type__c From Contract Limit 10];
        List<Contract_Pricing_Terms__c> cptList =  [Select id, Departments__c from Contract_Pricing_Terms__c];
        cptList[0].Relevant_Customer_Level__c= 'abc' ;
        cptList[0].Contract__c = contractList [0].Id;
        cptList[0].Departments__c= 'test';
        cptList[0].Active__c=true;
        cptList[0].Required_Timing_Of_CC_Updates__c = 'testing';
        cptList[0].Vendor_Letter_Required_For_CC_Increase__c = 'trial';
        cptList[0].Comm_Req_CC_Price_Chg__c = 'Notification and customer approval';
        cptList[0].CC_Prc_Chg_Notice_Reqd_days__c = 3;
        cptList[0].CC_Price_Incr_Cap_Pegd_To__c= 'Consumer Price Index (CPI)';
        cptList[0].CC_Price_Incr_Capped__c = 'Yes';
        update cptList; 
        
        Merch_Dept_Group__c md = new Merch_Dept_Group__c();
        md.Department__c = cptList[0].Departments__c ;
        md.Dept_Group_Name__c = 'Select All';
        md.Active__c = true; 
        insert md;
        List<User> userList = [Select id from user Limit 10];
        
        test.startTest();
        System.runAs(userList[0])
        {
            
            ApexPages.currentPage().getParameters().Put('id','\\?'+cptList[0].Id);
            ApexPages.StandardController con = new ApexPages.StandardController(cptList[0]);    
            Contract_Pricing_Terms_Extension cpt = new Contract_Pricing_Terms_Extension(new ApexPages.StandardController(cptList[0]));
            
            
            cpt.PopulateCheckBox();
            cpt.disableDepartment();
            cpt.saveAndNew() ;
            cpt.backToContract();
            cpt.saveRecord();
            
            cpt.Populatevalue();
            
            cptList[0].Required_Timing_Of_CC_Updates__c = null;
            cptList[0].Vendor_Letter_Required_For_CC_Increase__c = null;
            cptList[0].Comm_Req_CC_Price_Chg__c = null;
            
            
            
            cptList[0].CC_Prc_Chg_Notice_Reqd_days__c = null;
            
            
            
            cptList[0].CC_Price_Incr_Cap_Pegd_To__c= null;
            
            
            cptList[0].CC_Price_Incr_Capped__c =null;
            
            
            
            cptList[0].Relevant_Customer_Level__c = null;
            update cptList[0];
            cpt.saveRecord();
            
            ApexPages.currentPage().getParameters().Put('clone','1');    
            cpt.saveRecord();
            cptList[0].Department_Groups__c = 'Select All';
            update cptList[0];
            
            cpt.PopulateCheckBox();
            
            
            cptList[0].CC_Price_Incr_Cap_Pegd_To__c= 'Static Amount';
            update cptList[0];
            cpt.Populatevalue();
            
            cpt.conditionaldisplay();
            cpt.Deleterecord();
            List<Contract_Pricing_Terms__c> fetchedCP = new List<Contract_Pricing_Terms__c>();
            fetchedCP = [select id from Contract_Pricing_Terms__c where id = :cptList[0].id];
            System.assert(fetchedCP.size() == 0);
            
        }
        test.stopTest();
        
    }
    
}
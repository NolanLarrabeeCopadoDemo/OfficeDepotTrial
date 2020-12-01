/**@@
#CLASS NAME                    :    ContractPricingTermsClass_Test 
#DESCRIPTION                   :    Test class for "ContractPricingTermsClass"   
@@**/
@IsTest
public class ContractPricingTermsClass_Test {
    
    
    public static testmethod void cptTestMethod(){
        Test.startTest();
        List<User> listUser = DataFactory.createUserTestRecords('Test User',2);
        List<Account> accList = DataFactory.createAccountTestRecords('Test acc', 5,'');
        List<Contract> conList = DataFactory.createContractTestRecords('Test con',accList[0].Id, 5);
        List<Contract_Pricing_Terms__c> cptList = DataFactory.createContractPriceTermsTestRecords('Test CPT',conList[0].Id, 5);
        system.runAs(listUser[0]){
            
            
            cptList[0].Relevant_Customer_Level__c= 'abc' ;
            cptList[0].Departments__c= 'test';
            cptList[0].Active__c=true;
            cptList[0].Required_Timing_Of_CC_Updates__c = 'testing';
            cptList[0].Vendor_Letter_Required_For_CC_Increase__c = 'trial';
            cptList[0].Comm_Req_CC_Price_Chg__c = 'Notification and customer approval';
            cptList[0].CC_Prc_Chg_Notice_Reqd_days__c = 3;
            cptList[0].CC_Price_Incr_Cap_Pegd_To__c= 'Consumer Price Index (CPI)';
            cptList[0].CC_Price_Incr_Capped__c = 'Yes';
            Update cptList;
            
            Merch_Dept_Group__c md = new Merch_Dept_Group__c();
            //md.Name= 'test2';
            md.Department__c = cptList[0].Departments__c ;
            md.Dept_Group_Name__c = 'Select All';
            md.Active__c = true; 
            insert md;
            
            ContractPricingTermsClass.startInit(cptList[0].id);
            ContractPricingTermsClass.startInit_New();
            ContractPricingTermsClass.deparments1('test',cptList[0].id);
            ContractPricingTermsClass.upsert_CPT(cptList[0]);
            ContractPricingTermsClass.deparments('test',cptList[0].id, 'cust',true, conList[0].Id) ;
            ContractPricingTermsClass.custDepartment(cptList[0].id);
            
        }
        Test.stopTest();
    }
    
}
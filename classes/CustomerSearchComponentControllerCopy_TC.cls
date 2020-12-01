@isTest
public class CustomerSearchComponentControllerCopy_TC {
    private static testMethod void MyunitTest() { 
        string acc;
        Account testAccount = new Account();
        testAccount.Name='test' ;
        testAccount.Account_Type__c='Prospect';
        testAccount.Country__c='USA';
        testAccount.State__c='LA';
        insert testAccount;
        Profile p4 = [SELECT Id FROM profile WHERE name = 'GT - Field Sales' limit 1];
        User u1 = new User(alias = 'test123 ', email='proxy@proxy456.officedepot.com',OD_Employee_ID__c='123886',emailencodingkey='UTF-8', lastname='test123',languagelocalekey='en_US',localesidkey='en_US', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='proxy@7895.com',isactive=true);
        insert u1;
        Lead leads=new Lead();
        leads.LastName='Test name';
        leads.FirstName='Test name2';
        leads.Status='Open';
        leads.Company='Test Company';
        insert leads;
        CustomerSearchComponentControllerCopy.validateLeadData(leads.Id);
        system.runAs(u1){
            CustomerSearchComponentControllerCopy.validateLeadData(leads.Id);
            CustomerSearchComponentControllerCopy.getStateList(acc,testAccount.Country__c, testAccount.State__c, testAccount.Country__c);
            CustomerSearchComponentControllerCopy.ValidateRequiredFields(leads.Id);
            
        }
    }
    private static testMethod void MyunitTest2(){
        Lead leads=new Lead();
        leads.LastName='Test name';
        leads.FirstName='Test name2';
        leads.Status='Open';
        leads.Company='Test Company';
        leads.RecordTypeId='012E000000093HIIAY';
        leads.Country__c='USA';
        leads.State__c='LA';
        insert leads;
        
       /*Account testAccount2 = new Account();
        testAccount2.Name='Test Company' ;
        testAccount2.RecordType.Name='Prospect';
        testAccount2.Country__c='USA';
        testAccount2.State__c='LA';
        
        
        Sales_Person__c salesPersonList = new Sales_Person__c();
            salesPersonList = [select id,name,user__r.name from Sales_Person__c where user__r.id=:Userinfo.getuserid() limit 1];
        if(salesPersonList !=null)
         testAccount2.Sales_PersonID__c = salesPersonList.id;
        insert testAccount2;*/
        
        
        CustomerSearchComponentControllerCopy.validateLeadData(leads.Id);
        CustomerSearchComponentControllerCopy.getAccountInstance(leads.Id);
        
    }
    private static testMethod void MyunitTest3(){
        Test.setMock(HttpCalloutMock.class, new OrgssHttpCalloutMock());
        CustomerSearchComponentControllerCopy.searchCustInformation('{"Sales_PersonID__c":"a0A1k000000dUNjEAM","Country__c":"USA","Status__c":"Active","RecordTypeId":"012E00000008dTbIAI","State__c":"C","Name":"PUBLIC SAFETY, COLORADO DEPARTMENT OF","Address1__c":"15075 S GOLDEN RD","Zip__c":"80401","City__c":"Golden","Location_Decision_Making__c":"Yes","Type":"Prospect","Website":null,"Sector__c":"Private","Org_WCW_Count_Rep__c":"0","Segment__c":"Medium $75K-$150K","Est_Spend__c":"17","Buying_Group__c":"Buying Groups Medium $75K-$150K","Payment_Term__c":"Credit Card","Pricing_template_cd__c":"Arthur J Gallagher Risk Mgmt","Primary_Product__c":"Furniture","Industry_OD_SIC_Rep__c":"Engineering/Architecture/Consulting"}');

        //system.debug('======12========='+resp);

       // List<Org__C> response = new List<Org__C>();
       //response = CustomerSearchComponentControllerCopy.searchCustInformation(s);
        

        }

}
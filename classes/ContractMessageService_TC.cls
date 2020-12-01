/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest(seealldata=true)
private class ContractMessageService_TC 
{

    static testMethod void myUnitTest() 
    {
       
       Profile p4 = [SELECT Id FROM profile WHERE name='System Administrator'];   
        User u1 = new User(alias = 'test123 ', email='proxy@proxy456.officedepot.com',OD_Employee_ID__c='123355',emailencodingkey='UTF-8', lastname='test123',languagelocalekey='en_US',localesidkey='en_US', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='proxy@proxy456.com');
        insert u1;
        
        User u2 = new User(alias = 'test1234 ', email='proxyy@proxy.officedepot.com',OD_Employee_ID__c='413466',emailencodingkey='UTF-8', lastname='test1223',languagelocalekey='en_US',localesidkey='en_US', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='proxyy@proxy.com');
        insert u2; 
       
       System.runAs(u1)
       {
           Schema.DescribeSObjectResult d1 = Schema.SObjectType.Case; 
           Map<String,Schema.RecordTypeInfo> rtMapByName = d1.getRecordTypeInfosByName(); 
           
           Account acc1=new Account();
           acc1.name='abcd';
           acc1.type = 'Customer';
           acc1.Primary_Product__c = 'MPS'; 
           acc1.Oracle_Party_ID__c = '1245';
           insert acc1;
           
           opportunity opp1 = new opportunity ();
           opp1.Accountid = acc1.id;
           opp1.Amount = 10000;
           opp1.CloseDate  = system.today();
           opp1.Description = 'Test class opp';
           opp1.Name = 'Test class opp';
           opp1.Probability = 90; 
           opp1.StageName = '100%-Won';
           opp1.Product__c = 'MPS';
           opp1.Ownerid = u1.id;
           insert opp1;
           
           Test.startTest();
           Case ca1 = new case ();
           ca1 = [Select id from case limit 1];
           ca1.Description = 'Case Test';
           ca1.Subject = 'Case Test';
           ca1.Status='Open';
           //ca1.IT_Assignment__c=u1.id;
           //ca1.IT_BU_Reviewer__c=u1.id; 
           ca1.RecordTypeId = rtMapByName.get('Work Request').getRecordTypeId(); 
           ca1.DUP_Acct_Type__c = 'Current Customer';
           ca1.DUP_Acct_ID__c = '123456';
           ca1.IT_Track__c = 'Production Fix';
           ca1.DUP_Acct_ID__c='123';
           ca1.DUP_Acct_Type__c='Current Customer';
           ca1.AccountId=acc1.id;
           ca1.WRF_Opportunity_Id__c = opp1.id;
           update ca1;
            
            
            ContractMessage__c cm1 = new ContractMessage__c();
            cm1.Contract_Type__c = 'Work request';
            //Exception__c   =
            cm1.Opportunity_Id__c = opp1.id;
            cm1.OraclePartyId__c = '1245';
            //SalesPersonId__c    Text
            //Send_request__c Checkbox 
            //Status__c   Text
            cm1.Support__c = ca1.id;
            insert cm1;
            
            Sales_Person__c s = new Sales_Person__c ();
            s.Name = 'Test User';
            s.user__c =  u1.id;
            insert s;
    
            boolean UCRS;
            String contractMsgId = cm1.id;
            String status = 'accepted';
            string SysException = 'NO';
            UCRS = ContractMessageService.updateContractReqStatus(contractMsgId,status,SysException);
            
            
            String Case_opptyid = opp1.id;
            String Case_caseid = ca1.id;
            String Case_contract = Case_Contract_Create.Case_Contract_Create (Case_opptyid,Case_caseid);
            system.debug('>>>>>>>>>>>>>>'+Case_contract);
            Test.stopTest();
        }
    }
}
@isTest
public class CaseApproval_TC
{

    
static testMethod void CaseApproval_Test() 
    {
    try{
         Profile p4 = [SELECT Id FROM profile WHERE name='System Administrator']; 
         List<User> insertuser= new List<User>();  
         User u1 = new User(alias = 'test123 ', email='proxy@proxy456.officedepot.com',OD_Employee_ID__c='123456',emailencodingkey='UTF-8', lastname='test123',languagelocalekey='en_US',localesidkey='en_US', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='proxy@proxy456.com',isactive=true);
         insertuser.add(u1);
         User u2 = new User(alias = 'test123 ', email='proxy@proxy4567.officedepot.com',OD_Employee_ID__c='123457',emailencodingkey='UTF-8', lastname='test1234',languagelocalekey='en_US',localesidkey='en_US', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='proxy@proxy457.com',isactive=true);
         insertuser.add(u2); 
         insert insertuser; 
         
         Schema.DescribeSObjectResult d1 = Schema.SObjectType.Case; 
        //Schema.DescribeSObjectResult prcstep = Schema.SObjectType.ProcessInstanceStep ; 
         Map<String,Schema.RecordTypeInfo> CaseRecType = d1.getRecordTypeInfosByName();
         
         List<Case> InsrtCseList = new List<Case>();
         Case WRCase1 = new Case();
         WRCase1.WRF_Source__c='GMILL';
         
         //WRCase1.WRF_Requestor__c=u1.id;
         WRCase1.recordTypeId = CaseRecType.get('Account Maintenance').getRecordTypeId();
         WRCase1.DUP_Acct_ID__c = '78906';
         WRCase1.DUP_Requestor_ID__c = '123456';
         WRCase1.AM_Assigned_TO__C=u1.id;
         WRCase1.DUP_Acct_Type__c = 'New Prospect';
         WRCase1.WRF_Request_Type__C='Catalog Update';
         //insert WRCase1;
         InsrtCseList.add(WRCase1);
         
         Case WRCase2 = new Case();
         WRCase2.recordTypeId = CaseRecType.get('Account Maintenance').getRecordTypeId();
         WRCase2.DUP_Acct_ID__c = '78907';
         WRCase2.DUP_Requestor_ID__c = '123456';
         WRCase2.Approval_Status__C='Pending Approval';
         WRCase2.WRF_Date_CPM_Launched__C=System.today();
         WRCase2.Related_Case_Number__C='12345';
         WRCase2.DUP_Acct_Type__c = 'New Prospect';
        // WRCase2.Compliance_Mgr_Action_Date__c=System.today()-1;
         //insert WRCase2;
         InsrtCseList.add(WRCase2);
          test.starttest();
         System.RunAs(u1){
        
            // insert InsrtCseList;
         
         }
         WRCase2.Approval_Status__C='Pending Approval';
         WRCase2.recordTypeId = CaseRecType.get('Work Request').getRecordTypeId();
         WRCase1.Approval_Status__C='Pending Approval';
         WRCase1.recordTypeId = CaseRecType.get('Work Request').getRecordTypeId();
         WRCase1.Next_ApproverId__c='Finance';
         InsrtCseList.clear();
         InsrtCseList.add(WRCase1);
         InsrtCseList.add(WRCase2);
         System.RunAs(u1){
         
        // update InsrtCseList;
         
         }
         test.stoptest();
         }catch(Exception e){}
    }
    
  
}
@isTest

public class CustomerTransitionErrorServiceBatch_TC
{
    static testmethod void testMethod1()
    {  
        List<Transition_Error_Service_Dump__c> tcList = new List<Transition_Error_Service_Dump__c>();
        Account accObj = new Account();
        accObj.Name = 'Test Account';
        insert accObj;
        
        Customer_Transition__c custObj = new Customer_Transition__c();
        custObj.OMX_Primary_Key__c = '001122';
        custObj.Account__c = accObj.id;
        custobj.AOPS_Error_Id__c='123456';
        custobj.Error_Message_Type__c='System Failure';
        insert custObj;
        
        Customer_Transition__c custObj1 = new Customer_Transition__c();
        custObj1.OMX_Primary_Key__c = '001133';
        custObj1.Account__c = accObj.id;
        custObj1.AOPS_Error_Id__c='123456';
        custObj1 .Error_Message_Type__c='System Failure';
        custObj1.Error_Message_Type__c = null; 
        custObj1.Error_Message__c = null;
        custObj1.Error_Message_Level__c = null;
        custObj1.Error_code__c ='Success';
        insert custObj1 ;
        
        CustTransParentChildLevel__c PCLevel2 = new CustTransParentChildLevel__c(name='test',
                                                    AddSeconds__c = 200,
                                                    AddHours__c = 200,
                                                    Parent_Child_Level__c = 'Parent',
                                                    CronID_DTL__c = '',
                                                    SOA_EndPoint__c='https://osbuat01.officedepot.com/',
                                                    soa_user__c='SVC-SFDCWS:SVC4sfd3');
        insert PCLevel2;
       
        
        Customer_Transition_Dtls__c ctDtlsObj = new Customer_Transition_Dtls__c();
        ctDtlsObj.AOPS_Flag__c = 'Y';
        ctDtlsObj.Customer_Transition_ID__c = custObj.id;
        ctDtlsObj.Status__c = 'Active';
        ctDtlsObj.OMX_Primary_Key__c = '001122';
        ctDtlsObj.AOPS_Error_Id__c='abc';
        insert ctDtlsObj;
        
        Transition_Error_Service_Dump__c tcobj = new Transition_Error_Service_Dump__c ();
        tcObj.SFDC_Id__c = String.valueOf(custObj1.id);
        tcobj.Operation_Type__C = 'INITIAL_ACCOUNT_SETUP';
        tcobj.AOPS_Customer_Id__c='123456';
        tcobj.status__c='01';
        tcobj.Request_Type__c='SY';
        tcList.add(tcObj);
        
        Transition_Error_Service_Dump__c tcobj1 = new Transition_Error_Service_Dump__c ();
        tcobj1.SFDC_Id__c = String.valueOf(custObj.id);
        tcobj1.Operation_Type__C = 'INITIAL_ACCOUNT_SETUP';
        tcobj1.AOPS_Customer_Id__c='12345';
        tcobj1.status__c='00';
        tcobj1.Request_Type__c='SY';
        tcList.add(tcObj1);
        
        
        Transition_Error_Service_Dump__c tcobj2 = new Transition_Error_Service_Dump__c ();
        tcobj2.SFDC_Id__c = String.valueOf(ctDtlsObj.id);
        tcobj2.Operation_Type__C = 'NOT INITIAL_ACCOUNT_SETUP';
        tcobj2.AOPS_Customer_Id__c='1234';
        tcobj2.AOPS_Error_Id__c='abc';
        tcobj2.status__c='01';
        tcobj2.Request_Type__c='SY';
        
        tcList.add(tcobj2);
        
       insert tcList ;
        
        
        
        
        test.startTest();
        CustomerTransitionErrorServiceBatch ct = new CustomerTransitionErrorServiceBatch ();
        database.executeBatch(ct);
        test.StopTest();
        
    }
}
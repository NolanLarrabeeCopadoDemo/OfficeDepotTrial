@isTest
public class CustomerTransitionErrorService_tc
{
static testmethod void method1()
    {

    Id DtlsSiteRcdTypeID = Schema.SObjectType.Customer_Transition_Dtls__c.getRecordTypeInfosByName().get('Sites').getRecordTypeId();
    Id DtlsPOsRcdTypeID = Schema.SObjectType.Customer_Transition_Dtls__c.getRecordTypeInfosByName().get('Purchase Order').getRecordTypeId();
    Id DtlsCCsRcdTypeID = Schema.SObjectType.Customer_Transition_Dtls__c.getRecordTypeInfosByName().get('Cost Center').getRecordTypeId();
       
    Account pacc = new Account ();
        pacc.name = 'SUN Test Account1';
        pacc.BillingStreet = '1040 N 326 W';
        pacc.billingcity = 'Orem';
        pacc.BillingState = 'UT';
        pacc.Billingcountry = 'USA';
        pacc.Oracle_Party_Id__c = '543456';
        pacc.AOPS_Cust_Id__c = '003456';
        insert pacc;
        
        Customer_Transition__c CT = new Customer_Transition__c(name='test',account__c = pacc.id,Status__c='Launched');
        insert CT;
        
        List<Customer_Transition_Dtls__c> ctdList = new List<Customer_Transition_Dtls__c>();
        Customer_Transition_Dtls__c ctd1 = new Customer_Transition_Dtls__c(Customer_Transition_ID__c=CT.id,Status__c='Active',OMX_Primary_Key__c='543456',Dept_Dollar_Limit__c = 123,recordtypeid=DtlsSiteRcdTypeID);
        ctdList.add(ctd1);
        Customer_Transition_Dtls__c ctd2 = new Customer_Transition_Dtls__c(Customer_Transition_ID__c=CT.id,Status__c='Active',OMX_Primary_Key__c='5434236',Dept_Dollar_Limit__c = 123,recordtypeid=DtlsPOsRcdTypeID ,PO_Expiration_Date__c=Date.valueOf('2014-11-04') , PO_Limit__c=12);
        ctdList.add(ctd2);
        Customer_Transition_Dtls__c ctd3 = new Customer_Transition_Dtls__c(account_id__c = pacc.id,Customer_Transition_ID__c=CT.id,Status__c='Active',OMX_Primary_Key__c='5434',Dept_Dollar_Limit__c = 123,recordtypeid=DtlsCCsRcdTypeID ,aops_flag__c='Y');
        ctdList.add(ctd3);
        insert ctdList;
    
    CustomerTransitionErrorService ctes = new CustomerTransitionErrorService();
    CustomerTransitionErrorService.CustomerTransitionErrorSynch errSynch = new CustomerTransitionErrorService.CustomerTransitionErrorSynch();
    CustomerTransitionErrorService.CustomerTransitionErrorSynch errSynch1 = new CustomerTransitionErrorService.CustomerTransitionErrorSynch();
    CustomerTransitionErrorService.CustomerTransitionHeaderErrorSynch headerErrorSynch = new CustomerTransitionErrorService.CustomerTransitionHeaderErrorSynch();
    CustomerTransitionErrorService.CustomerTransitionHeaderErrorSynch headerErrorSynch1 = new CustomerTransitionErrorService.CustomerTransitionHeaderErrorSynch();
    CustomerTransitionErrorService.CustomerTransitionHeaderErrorSynch headerErrorSynch2 = new CustomerTransitionErrorService.CustomerTransitionHeaderErrorSynch();
    
    headerErrorSynch.AOPS_Error_Id='Error';    
    headerErrorSynch.Request_Id='';
    headerErrorSynch.Request_Time_Stamp='';    
    headerErrorSynch.Error_Time_Stamp='';
    headerErrorSynch.Requestor_Name='';
    headerErrorSynch.AOPS_Customer_Id='';
    headerErrorSynch.File_Name='';
    headerErrorSynch.Operation_Type='INITIAL_ACCOUNT_SETUP';
    headerErrorSynch.SFDC_Id = ct.id;
    headerErrorSynch.Error_Message='System Failure';
    headerErrorSynch.Request_Type='SY';
    headerErrorSynch.Status='01';
    
    headerErrorSynch1.AOPS_Error_Id='Error';    
    headerErrorSynch1.Request_Id='';
    headerErrorSynch1.Request_Time_Stamp='';    
    headerErrorSynch1.Error_Time_Stamp='';
    headerErrorSynch1.Requestor_Name='';
    headerErrorSynch1.AOPS_Customer_Id='';
    headerErrorSynch1.File_Name='';
    headerErrorSynch1.Operation_Type='INITIAL_ACCOUNT_SETUP';
    headerErrorSynch1.SFDC_Id = ct.id;
    headerErrorSynch1.Error_Message='System Failure';
    headerErrorSynch1.Request_Type='ER';
    headerErrorSynch1.Status='01';
    
    headerErrorSynch2.AOPS_Error_Id='Error';    
    headerErrorSynch2.Request_Id='';
    headerErrorSynch2.Request_Time_Stamp='';    
    headerErrorSynch2.Error_Time_Stamp='';
    headerErrorSynch2.Requestor_Name='';
    headerErrorSynch2.AOPS_Customer_Id='';
    headerErrorSynch2.File_Name='';
    headerErrorSynch2.Operation_Type='INITIAL_ACCOUNT_SETUP';
    headerErrorSynch2.SFDC_Id = ct.id;
    headerErrorSynch2.Error_Message='System Failure';
    headerErrorSynch2.Request_Type='ER';
    headerErrorSynch2.Status='00';
    
    List<CustomerTransitionErrorService.CustomerTransitionHeaderErrorSynch> customerTransitionRecs1 = new List<CustomerTransitionErrorService.CustomerTransitionHeaderErrorSynch>();
    customerTransitionRecs1.add(headerErrorSynch);
    customerTransitionRecs1.add(headerErrorSynch1);
    customerTransitionRecs1.add(headerErrorSynch2);
    errSynch.customerTransitionRecs = customerTransitionRecs1 ;
    
    Boolean testBool = CustomerTransitionErrorService.CustomerTransitionErrorSync(errSynch);
    Boolean testBool1 = CustomerTransitionErrorService.CustomerTransitionErrorSync(errSynch);
    Boolean testBool2 = CustomerTransitionErrorService.CustomerTransitionErrorSync(errSynch);
    }

    static testmethod void method2()
    {
    
    Id DtlsSiteRcdTypeID = Schema.SObjectType.Customer_Transition_Dtls__c.getRecordTypeInfosByName().get('Sites').getRecordTypeId();
    Id DtlsPOsRcdTypeID = Schema.SObjectType.Customer_Transition_Dtls__c.getRecordTypeInfosByName().get('Purchase Order').getRecordTypeId();
    Id DtlsCCsRcdTypeID = Schema.SObjectType.Customer_Transition_Dtls__c.getRecordTypeInfosByName().get('Cost Center').getRecordTypeId();
    
        Account pacc = new Account ();
        pacc.name = 'SUN Test Account1';
        pacc.BillingStreet = '1040 N 326 W';
        pacc.billingcity = 'Orem';
        pacc.BillingState = 'UT';
        pacc.Billingcountry = 'USA';
        pacc.Oracle_Party_Id__c = '543456';
        pacc.AOPS_Cust_Id__c = '003456';
        insert pacc;
        
        Customer_Transition__c CT = new Customer_Transition__c(name='test',account__c = pacc.id,Status__c='Launched');
        insert CT;
        
        List<Customer_Transition_Dtls__c> ctdList = new List<Customer_Transition_Dtls__c>();
        Customer_Transition_Dtls__c ctd1 = new Customer_Transition_Dtls__c(Customer_Transition_ID__c=CT.id,Status__c='Active',OMX_Primary_Key__c='543456',Dept_Dollar_Limit__c = 123,recordtypeid=DtlsSiteRcdTypeID );
        ctdList.add(ctd1);
        Customer_Transition_Dtls__c ctd2 = new Customer_Transition_Dtls__c(Customer_Transition_ID__c=CT.id,Status__c='Active',OMX_Primary_Key__c='5434236',Dept_Dollar_Limit__c = 123,recordtypeid=DtlsPOsRcdTypeID ,PO_Expiration_Date__c=Date.valueOf('2014-11-04') , PO_Limit__c=12);
        ctdList.add(ctd2);
        Customer_Transition_Dtls__c ctd3 = new Customer_Transition_Dtls__c(account_id__c = pacc.id,Customer_Transition_ID__c=CT.id,Status__c='Active',OMX_Primary_Key__c='5434',Dept_Dollar_Limit__c = 123,recordtypeid=DtlsCCsRcdTypeID ,aops_flag__c='Y',Error_code__c='Error');
        ctdList.add(ctd3);
        
        insert ctdList;
        
    CustomerTransitionErrorService ctes = new CustomerTransitionErrorService();
    CustomerTransitionErrorService.CustomerTransitionErrorSynch errSynch = new CustomerTransitionErrorService.CustomerTransitionErrorSynch();
    CustomerTransitionErrorService.CustomerTransitionHeaderErrorSynch headerErrorSynch = new CustomerTransitionErrorService.CustomerTransitionHeaderErrorSynch();
        
    headerErrorSynch.AOPS_Error_Id='Error';    
    headerErrorSynch.Request_Id='';
    headerErrorSynch.Request_Time_Stamp='';    
    headerErrorSynch.Error_Time_Stamp='';
    headerErrorSynch.Requestor_Name='';
    headerErrorSynch.AOPS_Customer_Id='';
    headerErrorSynch.File_Name='';
    headerErrorSynch.Operation_Type='ADD_SHIP_TO_ADDRESS';
    headerErrorSynch.SFDC_Id = pacc.id;
    headerErrorSynch.Error_Message='System Failure';
    headerErrorSynch.Request_Type='SY';
    headerErrorSynch.Status='01';
    List<CustomerTransitionErrorService.CustomerTransitionHeaderErrorSynch> customerTransitionRecs1 = new List<CustomerTransitionErrorService.CustomerTransitionHeaderErrorSynch>();
    customerTransitionRecs1.add(headerErrorSynch);
    errSynch.customerTransitionRecs = customerTransitionRecs1 ;
    Boolean testBool = CustomerTransitionErrorService.CustomerTransitionErrorSync(errSynch);
    
    CustomerTransitionErrorService.CustomerTransitionHeaderErrorSynch headerErrorSynch1 = new CustomerTransitionErrorService.CustomerTransitionHeaderErrorSynch();
    headerErrorSynch1.AOPS_Error_Id='Error';    
    headerErrorSynch1.Request_Id='';
    headerErrorSynch1.Request_Time_Stamp='';    
    headerErrorSynch1.Error_Time_Stamp='';
    headerErrorSynch1.Requestor_Name='';
    headerErrorSynch1.AOPS_Customer_Id='';
    headerErrorSynch1.File_Name='';
    headerErrorSynch1.Operation_Type='ADD_SHIP_TO_ADDRESS';
    headerErrorSynch1.SFDC_Id = ct.id;
    headerErrorSynch1.Error_Message='System Failure';
    headerErrorSynch1.Request_Type='ER';
    headerErrorSynch1.Status='01';
    customerTransitionRecs1.add(headerErrorSynch1);
    errSynch.customerTransitionRecs = customerTransitionRecs1 ;
    Boolean testBool1 = CustomerTransitionErrorService.CustomerTransitionErrorSync(errSynch);
    }
    
    static testmethod void method3()
    {
    
        Account pacc = new Account ();
        pacc.name = 'SUN Test Account1';
        pacc.BillingStreet = '1040 N 326 W';
        pacc.billingcity = 'Orem';
        pacc.BillingState = 'UT';
        pacc.Billingcountry = 'USA';
        pacc.Oracle_Party_Id__c = '543456';
        pacc.AOPS_Cust_Id__c = '003456';
        insert pacc;
        
        Customer_Transition__c CT = new Customer_Transition__c(name='test',account__c = pacc.id,Status__c='Launched');
        insert CT;
        
        
    CustomerTransitionErrorService ctes = new CustomerTransitionErrorService();
    CustomerTransitionErrorService.CustomerTransitionErrorSynch errSynch = new CustomerTransitionErrorService.CustomerTransitionErrorSynch();        
    
    List<CustomerTransitionErrorService.CustomerTransitionHeaderErrorSynch> customerTransitionRecs1 = new List<CustomerTransitionErrorService.CustomerTransitionHeaderErrorSynch>();   
    CustomerTransitionErrorService.CustomerTransitionHeaderErrorSynch headerErrorSynch1 = new CustomerTransitionErrorService.CustomerTransitionHeaderErrorSynch();
    headerErrorSynch1.AOPS_Error_Id='Error';    
    headerErrorSynch1.Request_Id='';
    headerErrorSynch1.Request_Time_Stamp='';    
    headerErrorSynch1.Error_Time_Stamp='';
    headerErrorSynch1.Requestor_Name='';
    headerErrorSynch1.AOPS_Customer_Id='';
    headerErrorSynch1.File_Name='';
    headerErrorSynch1.Operation_Type='ADD_BILL_TO_ADDRESS';
    headerErrorSynch1.SFDC_Id = ct.id;
    headerErrorSynch1.Error_Message='System Failure';
    headerErrorSynch1.Request_Type='SY';
    headerErrorSynch1.Status='01';
    customerTransitionRecs1.add(headerErrorSynch1);
    errSynch.customerTransitionRecs = customerTransitionRecs1 ;
    Boolean testBool = CustomerTransitionErrorService.CustomerTransitionErrorSync(errSynch);
    }
    
    static testmethod void method4()
    {
    
    Id DtlsSiteRcdTypeID = Schema.SObjectType.Customer_Transition_Dtls__c.getRecordTypeInfosByName().get('Sites').getRecordTypeId();
    Id DtlsPOsRcdTypeID = Schema.SObjectType.Customer_Transition_Dtls__c.getRecordTypeInfosByName().get('Purchase Order').getRecordTypeId();
    Id DtlsCCsRcdTypeID = Schema.SObjectType.Customer_Transition_Dtls__c.getRecordTypeInfosByName().get('Cost Center').getRecordTypeId();
    
        Account pacc = new Account ();
        pacc.name = 'SUN Test Account1';
        pacc.BillingStreet = '1040 N 326 W';
        pacc.billingcity = 'Orem';
        pacc.BillingState = 'UT';
        pacc.Billingcountry = 'USA';
        pacc.Oracle_Party_Id__c = '543456';
        pacc.AOPS_Cust_Id__c = '003456';
        insert pacc;
        
        Customer_Transition__c CT = new Customer_Transition__c(name='test',account__c = pacc.id,Status__c='Launched');
        insert CT;
        
        List<Customer_Transition_Dtls__c> ctdList = new List<Customer_Transition_Dtls__c>();
        Customer_Transition_Dtls__c ctd1 = new Customer_Transition_Dtls__c(Customer_Transition_ID__c=CT.id,Status__c='Active',OMX_Primary_Key__c='543456',Dept_Dollar_Limit__c = 123,recordtypeid=DtlsSiteRcdTypeID );
        ctdList.add(ctd1);
        Customer_Transition_Dtls__c ctd2 = new Customer_Transition_Dtls__c(Customer_Transition_ID__c=CT.id,Status__c='Active',OMX_Primary_Key__c='5434236',Dept_Dollar_Limit__c = 123,recordtypeid=DtlsPOsRcdTypeID ,PO_Expiration_Date__c=Date.valueOf('2014-11-04') , PO_Limit__c=12);
        ctdList.add(ctd2);
        Customer_Transition_Dtls__c ctd3 = new Customer_Transition_Dtls__c(account_id__c = pacc.id,Customer_Transition_ID__c=CT.id,Status__c='Active',OMX_Primary_Key__c='5434',Dept_Dollar_Limit__c = 123,recordtypeid=DtlsCCsRcdTypeID ,aops_flag__c='Y',Error_code__c='Error');
        ctdList.add(ctd3);
        
        insert ctdList;
        
    CustomerTransitionErrorService ctes = new CustomerTransitionErrorService();
    CustomerTransitionErrorService.CustomerTransitionErrorSynch errSynch = new CustomerTransitionErrorService.CustomerTransitionErrorSynch();
    CustomerTransitionErrorService.CustomerTransitionHeaderErrorSynch headerErrorSynch = new CustomerTransitionErrorService.CustomerTransitionHeaderErrorSynch();
        
    headerErrorSynch.AOPS_Error_Id='';    
    headerErrorSynch.Request_Id='';
    headerErrorSynch.Request_Time_Stamp='';    
    headerErrorSynch.Error_Time_Stamp='';
    headerErrorSynch.Requestor_Name='';
    headerErrorSynch.AOPS_Customer_Id='';
    headerErrorSynch.File_Name='';
    headerErrorSynch.Operation_Type='ADD_SHIP_TO_ADDRESS';
    headerErrorSynch.SFDC_Id = pacc.id;
    headerErrorSynch.Error_Message='';
    headerErrorSynch.Request_Type='';
    headerErrorSynch.Status='00';
    List<CustomerTransitionErrorService.CustomerTransitionHeaderErrorSynch> customerTransitionRecs1 = new List<CustomerTransitionErrorService.CustomerTransitionHeaderErrorSynch>();
    customerTransitionRecs1.add(headerErrorSynch);
    errSynch.customerTransitionRecs = customerTransitionRecs1 ;
    Boolean testBool = CustomerTransitionErrorService.CustomerTransitionErrorSync(errSynch);
    
    
    }

}
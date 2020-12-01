@isTest
public class CustTransDtl_Batch3_TC
{
static testmethod void method1()
    {
       /* Account pacc = new Account ();
        pacc.name = 'SUN Test Account1';
        pacc.BillingStreet = '1040 N 326 W';
        pacc.billingcity = 'Orem';
        pacc.BillingState = 'UT';
        pacc.Billingcountry = 'USA';
        pacc.Oracle_Party_Id__c = '543456';
        pacc.AOPS_Cust_Id__c = '003456';
        insert pacc;
        
        Account acc = new Account ();
        acc.name = 'SUN Test Account';
        acc.BillingStreet = '1040 N 326 W';
        acc.billingcity = 'Orem';
        acc.BillingState = 'UT';
        acc.Billingcountry = 'USA';
        acc.Oracle_Party_Id__c = '123456';
        acc.AOPS_Cust_Id__c = '123456';
        acc.parentid=pacc.id;
        insert acc;   
        
        Customer_Transition__c CT = new Customer_Transition__c(name='test',account__c = pacc.id,Status__c='Scheduled');
        CT.Account__c = acc.id;
        insert CT;
        
        CT.name='testupdate';
        CT.Status__c='Scheduled';
      //  update CT;
        */
        
        CustTransParentChildLevel__c PCLevel2 = new CustTransParentChildLevel__c(name='test',
                                                    AddSeconds__c = 200,
                                                    AddHours__c = 200,
                                                    Parent_Child_Level__c = 'Parent',
                                                    CronID_DTL__c = '',
                                                    SOA_EndPoint__c='https://osbuat01.officedepot.com/',
                                                    soa_user__c='SVC-SFDCWS:SVC4sfd3');
        insert PCLevel2;
        
        Account pacc = new Account ();
        pacc.name = 'SUN Test Account1';
        pacc.BillingStreet = '1040 N 326 W';
        pacc.billingcity = 'Orem';
        pacc.BillingState = 'UT';
        pacc.Billingcountry = 'USA';
        pacc.Oracle_Party_Id__c = '543456';
        pacc.AOPS_Cust_Id__c = '003456';
        insert pacc;
        Customer_Transition__c CT = new Customer_Transition__c(omx_primary_key__c='919293',name='test',account__c = pacc.id,Status__c='Launched');
        insert CT;
        
        Customer_Transition_Dtls__c ctd = new Customer_Transition_Dtls__c(Customer_Transition_ID__c=CT.id,Status__c='Active',OMX_Primary_Key__c='543456');
        
        insert ctd;
        CustTransDtl_Batch3 cth = new CustTransDtl_Batch3();
        database.executebatch(cth, 100);   
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
        
        CustTransParentChildLevel__c PCLevel2 = new CustTransParentChildLevel__c(name='test',
                                                    AddSeconds__c = 200,
                                                    AddHours__c = 200,
                                                    Parent_Child_Level__c = 'Parent',
                                                    CronID_DTL__c = '',
                                                    SOA_EndPoint__c='https://osbuat01.officedepot.com/',
                                                    soa_user__c='SVC-SFDCWS:SVC4sfd3');
        insert PCLevel2;
        Customer_Transition__c CT = new Customer_Transition__c(omx_primary_key__c='929394',name='test',account__c = pacc.id,Status__c='Launched');
        insert CT;
        List<Customer_Transition_Dtls__c> ctdList = new List<Customer_Transition_Dtls__c>();
        Customer_Transition_Dtls__c ctd1 = new Customer_Transition_Dtls__c(Customer_Transition_ID__c=CT.id,Status__c='Active',OMX_Primary_Key__c='543456',Dept_Dollar_Limit__c = 123,recordtypeid=DtlsCCsRcdTypeID);
        ctdList.add(ctd1);
        Customer_Transition_Dtls__c ctd2 = new Customer_Transition_Dtls__c(Customer_Transition_ID__c=CT.id,Status__c='Active',OMX_Primary_Key__c='5434236',Dept_Dollar_Limit__c = 123,recordtypeid=DtlsPOsRcdTypeID,PO_Expiration_Date__c=Date.valueOf('2014-11-04') , PO_Limit__c=12);
        ctdList.add(ctd2);
        Customer_Transition_Dtls__c ctd3 = new Customer_Transition_Dtls__c(account_id__c = pacc.id,Customer_Transition_ID__c=CT.id,Status__c='Active',OMX_Primary_Key__c='5434',Dept_Dollar_Limit__c = 123,recordtypeid=DtlsSiteRcdTypeID,aops_flag__c='Y');
        ctdList.add(ctd3);
        insert ctdList;
        String strNullQuery = '';
        CustTransDtl_Batch3 cth = new CustTransDtl_Batch3(strNullQuery);
        database.executebatch(cth, 100);   
        
//        string strquery='SELECT id,Fax_back_phone_number__c,aops_flag__c,BO_Allowed_Cancel__c,recordtype.name,recordtypeid,Account_ID__c,Dept_Dollar_Limit__c,Dept_Addtl_Instructions__c,Dept_Description__c,Dept_Key__c,Cost_Center_ID__c,Cost_Center_Descr__c,PO_Limit__c,PO_Comment__c,PO_Expiration_Date__c, PO_Number__c,PO_ID__c,Customer_assigned_location__c,MIPAL_alternate_location_flag__c,Drop_Ship__c, Customer_Transition_ID__r.Status__c, Customer_Transition_ID__r.account__r.AOPS_Cust_Id__c FROM Customer_Transition_Dtls__c where Customer_Transition_ID__r.account__r.AOPS_Cust_Id__c != null and Status__c=\'Active\' and Customer_Transition_ID__r.Status__c=\'Launched\' and (Error_Code__c = \'Error\' or Error_Code__c = \'\' or Error_Code__c = null) limit 100000';
        
        Account_Setup_Request__c acs = new Account_Setup_Request__c (Account__c = pacc.id, name='abc');
        insert acs;
        string strquery= 'SELECT id, Fax_back_phone_number__c, aops_flag__c, BO_Allowed_Cancel__c, recordtype.name, recordtypeid, Account_ID__c, Dept_Dollar_Limit__c, Dept_Addtl_Instructions__c, Dept_Description__c, Dept_Key__c, Cost_Center_ID__c, Cost_Center_Descr__c, PO_Limit__c, PO_Comment__c, PO_Expiration_Date__c, PO_Number__c, PO_ID__c, Customer_assigned_location__c, MIPAL_alternate_location_flag__c, Drop_Ship__c, Customer_Transition_ID__r.Status__c, Customer_Transition_ID__r.account__r.AOPS_Cust_Id__c, Customer_Transition_ID__r.Ready_For_Mod_5__c, Tax_Exemption__c, Split_Driven__c, Customer_Transition_ID__r.Final_Split_Decision__c FROM Customer_Transition_Dtls__c ';
        CustTransDtl_Batch3 cth1 = new CustTransDtl_Batch3(strquery);
        database.executebatch(cth1, 100);  
    }
    
    static testmethod void method3()
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
        /*
        Account acc = new Account ();
        acc.name = 'SUN Test Account';
        acc.BillingStreet = '1040 N 326 W';
        acc.billingcity = 'Orem';
        acc.BillingState = 'UT';
        acc.Billingcountry = 'USA';
        acc.Oracle_Party_Id__c = '123456';
        acc.AOPS_Cust_Id__c = '123456';
        acc.parentid=pacc.id;
        insert acc;   
        */
        CustTransParentChildLevel__c PCLevel2 = new CustTransParentChildLevel__c(name='test',
                                                    AddSeconds__c = 200,
                                                    AddHours__c = 200,
                                                    Parent_Child_Level__c = 'Parent',
                                                    CronID_DTL__c = '',
                                                    SOA_EndPoint__c='https://osbuat01.officedepot.com/',
                                                    soa_user__c='SVC-SFDCWS:SVC4sfd3');
        insert PCLevel2;
        Customer_Transition__c CT = new Customer_Transition__c(omx_primary_key__c='991122',name='test',account__c = pacc.id,Status__c='Launched');
        insert CT;
        
        Customer_Transition_Dtls__c ctd = new Customer_Transition_Dtls__c(account_Id__c = pacc.id,Customer_Transition_ID__c=CT.id,Status__c='Active',OMX_Primary_Key__c='543456',Dept_Dollar_Limit__c = 123,recordtypeid=DtlsCCsRcdTypeID);
        
        insert ctd;
        String strNullQuery = '';
        CustTransDtl_Batch3 cth = new CustTransDtl_Batch3(strNullQuery);
        database.executebatch(cth, 100);   
        
//        string strquery='SELECT id,Fax_back_phone_number__c,aops_flag__c,BO_Allowed_Cancel__c,recordtype.name,recordtypeid,Account_ID__c,Dept_Dollar_Limit__c,Dept_Addtl_Instructions__c,Dept_Description__c,Dept_Key__c,Cost_Center_ID__c,Cost_Center_Descr__c,PO_Limit__c,PO_Comment__c,PO_Expiration_Date__c, PO_Number__c,PO_ID__c,Customer_assigned_location__c,MIPAL_alternate_location_flag__c,Drop_Ship__c, Customer_Transition_ID__r.Status__c, Customer_Transition_ID__r.account__r.AOPS_Cust_Id__c FROM Customer_Transition_Dtls__c where Customer_Transition_ID__r.account__r.AOPS_Cust_Id__c != null and Status__c=\'Active\' and Customer_Transition_ID__r.Status__c=\'Launched\' and (Error_Code__c = \'Error\' or Error_Code__c = \'\' or Error_Code__c = null) limit 100000';
        
        Account_Setup_Request__c acs = new Account_Setup_Request__c (Account__c = pacc.id, name='abc');
        insert acs;
        string strquery='SELECT id,Fax_back_phone_number__c,aops_flag__c,BO_Allowed_Cancel__c,recordtype.name,recordtypeid,Account_ID__c,Dept_Dollar_Limit__c,Dept_Addtl_Instructions__c,Dept_Description__c,Dept_Key__c,Cost_Center_ID__c,Cost_Center_Descr__c,PO_Limit__c,PO_Comment__c,PO_Expiration_Date__c, PO_Number__c,PO_ID__c,Customer_assigned_location__c,MIPAL_alternate_location_flag__c,Drop_Ship__c, Customer_Transition_ID__r.Status__c, Customer_Transition_ID__r.account__r.AOPS_Cust_Id__c FROM Customer_Transition_Dtls__c';
         String CRON_EXP = '0 0 0 3 9 ? 2022';
        CustTransDtl_Batch3 cth1 = new CustTransDtl_Batch3 (strQuery);
       String jobId = System.schedule('testBasicScheduledApex',CRON_EXP ,new CustTransDtl_Batch3());
       CustTransDtl_Batch3 cthc = new CustTransDtl_Batch3();
       cthc.trunc30('test ');
       cthc.trunc30('');
       cthc.trunc30('test test test test test test test test test test test test test test');
       cthc.nvlYN('');
       cthc.nvlYN('test');
       cthc.splChar('@<&>\"\'');
       cthc.nvlNumeric('');
       cthc.nvlNumeric('test');
        
        }
}
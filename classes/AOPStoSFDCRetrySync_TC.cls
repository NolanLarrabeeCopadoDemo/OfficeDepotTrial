@IsTest
public class AOPStoSFDCRetrySync_TC {

    @IsTest
    static void launchesJob() {

        AOPS_STG_CONTACT_MASTER__c masterRec = new AOPS_STG_CONTACT_MASTER__c(Unique_Record_ID__c='11111111', CCU300F_CONTACT_ID__c='11111111', CXTCNTM_TIMESTAMP__c='2020-07-17-09.24.19.799200', Number_Of_Attempts__c = null, Record_Updated__c=false, Sync_Status_Message__c = null);
        insert masterRec;
        AOPS_Account_Master__c cm = new AOPS_Account_Master__c(Unique_Record_ID__c='66666666', FCU000P_Customer_ID__c='66666666', CXTF000P_TIMESTAMP__c='2020-07-17-09.24.19.799200', Number_Of_Attempts__c = null, Sync_Status_Message__c = null,  Record_Updated__c=false);
        insert cm;
        AOPS_Contact_Email__c ce = new AOPS_Contact_Email__c(Unique_Record_ID__c='22222222', CCU340F_CONTACT_ID__c='22222222', CXTCNTE_AOPS_KEY1__c='22222222', CXTCNTE_TIMESTAMP__c = '2020-07-17-09.24.19.799200', Number_Of_Attempts__c = 1, Record_Updated__c=false, Sync_Status_Message__c = null);
        insert ce;
        AOPS_Contact_Phone__c cp = new AOPS_Contact_Phone__c(Unique_Record_ID__c='22222222', CCU320F_CONTACT_ID__c='22222222', CXTCNTP_AOPS_KEY1__c='22222222', CXTCNTP_TIMESTAMP__c = '2020-07-17-09.24.19.799200', Record_Updated__c=false, Sync_Status_Message__c = null);
        insert cp;
        AOPS_Contact_Web_User__c cwu = new AOPS_Contact_Web_User__c(Unique_Record_ID__c='44444444', CCU330F_CONTACT_ID__c='44444444',CCU330F_CUSTOMER_ID__c='12345677', CXTCNTW_TIMESTAMP__c = '2020-07-17-09.24.19.799200', Record_Updated__c=false, Sync_Status_Message__c = null);
        insert cwu;
        AOPS_Contact_Ship_Address__c csa = new AOPS_Contact_Ship_Address__c(Unique_Record_ID__c='44444444', CXTCNTS_TIMESTAMP__c = '2020-07-17-09.24.19.799200', CCU310F_CONTACT_ID__c='44444444',CCU310F_CUSTOMER_ID__c='12345666', Record_Updated__c=false, Sync_Status_Message__c = null);
        insert csa;
        AOPS_CONTACT_OPT_IN__c coi = new AOPS_CONTACT_OPT_IN__c(Unique_Record_ID__c='55555555', CXTCNTO_TIMESTAMP__c = '2020-07-17-09.24.19.799200', CCU380F_CONTACT_ID__c='55555555',CCU380F_CUSTOMER_ID__c='12345555', Record_Updated__c=false, Sync_Status_Message__c = null);
        insert coi;
        AOPS_Account_Addendum_Community__c adcRec = new AOPS_Account_Addendum_Community__c(Unique_Record_ID__c='33333333', CXTC043F_TIMESTAMP__c = '2020-07-17-09.24.19.799200', CCU043F_AECUST__c='33333333', Record_Updated__c=false, Sync_Status_Message__c = null);
        insert adcRec;
        AOPS_Account_Addendum_Legal_Other__c aalRec = new AOPS_Account_Addendum_Legal_Other__c(Unique_Record_ID__c='44444444', CXTC044F_TIMESTAMP__c = '2020-07-17-09.24.19.799200', CCU044F_CUSTOMER_ID__c='44444444', Record_Updated__c=false, Sync_Status_Message__c = null);
        insert aalRec;
        AOPS_Account_BSD_Addendum__c abaRec = new AOPS_Account_BSD_Addendum__c(Unique_Record_ID__c='55555555', CXTC007F_TIMESTAMP__c = '2020-07-17-09.24.19.799200', CCU007F_CUSTOMER_ID__c='55555555', Record_Updated__c=false, Sync_Status_Message__c = null);
        insert abaRec;
        AOPS_Address_Master__c amRec = new AOPS_Address_Master__c(Unique_Record_ID__c='66666666', CXTF001P_TIMESTAMP__c = '2020-07-17-09.24.19.799200',FCU001P_CUSTOMER_ID__c='66666666', FCU001P_ADDRESS_SEQ__c = '0001', Record_Updated__c=false, Sync_Status_Message__c = null);
        insert amRec; 
        AOPS_Address_BSD_A__c abRec = new AOPS_Address_BSD_A__c(Unique_Record_ID__c='77777777', CXTC009F_TIMESTAMP__c = '2020-07-17-09.24.19.799200', CCU009F_CUSTOMER_ID__c='77777777', Record_Updated__c=true);
        insert abRec;
        AOPS_Account_Preferences__c apRec = new AOPS_Account_Preferences__c(Unique_Record_ID__c='99999999', CXTF370P_TIMESTAMP__c = '2020-07-17-09.24.19.799200', FCU370P_CUSTOMER_ID__c='99999999', Record_Updated__c=false, Sync_Status_Message__c = null);
        insert apRec;
        AOPS_Account_Child_Parent_Relationship__c cprRec = new AOPS_Account_Child_Parent_Relationship__c(Unique_Record_ID__c='22222222', CXTF005P_TIMESTAMP__c = '2020-07-17-09.24.19.799200', FCU005P_CUSTOMER_ID__c='22222222', 
        FCU005P_PARENT_ID__c = '11111111', Record_Updated__c=false, Sync_Status_Message__c = null);

        Contact_Final_Staging__c cf = new Contact_Final_Staging__c(Unique_Record_ID__c='01111112', Is_Contact_Master_Changed__c=true,
            AOPS_Contact_Number__c = '11111112', AOPS_Account_Number__c='21111112', Sync_Failed__c = true, Number_Of_Attempts__c = 1);
        insert cf;

        Contact_Final_Staging__c cf2 = new Contact_Final_Staging__c(Unique_Record_ID__c='01111111', Is_Contact_Master_Changed__c=true,
            AOPS_Contact_Number__c = '11111111', AOPS_Account_Number__c='21111111', Sync_Failed__c = true, Number_Of_Attempts__c = null);
        insert cf2;

        SiteContacts_Final_Staging__c scf = new SiteContacts_Final_Staging__c (Unique_Record_ID__c='01111112', Is_Changed__c=true,
        AOPS_Contact_Number__c = '11111112', AOPS_Account_Number__c='21111112', Sync_Failed__c = true, Number_Of_Attempts__c = 1);
        insert scf;

        SiteContacts_Final_Staging__c scf2 = new SiteContacts_Final_Staging__c (Unique_Record_ID__c='01111111', Is_Changed__c=true, 
        AOPS_Contact_Number__c = '11111111', AOPS_Account_Number__c='21111111', Sync_Failed__c = true, Number_Of_Attempts__c = null);
        insert scf2;
        
        Account_Final_Staging__c af = new Account_Final_Staging__c(Is_Account_Master_Changed__c=true, 
        AOPS_Cust_Id__c ='21111111', Sync_Failed__c = true, Number_Of_Attempts__c = 1);
        insert af; 

        Account_Final_Staging__c af2 = new Account_Final_Staging__c(Is_Account_Master_Changed__c=true, 
        AOPS_Cust_Id__c ='21111112', Sync_Failed__c = true, Number_Of_Attempts__c = null);
        insert af2; 

        Account_Site_Final_Staging__c asf = new Account_Site_Final_Staging__c(Is_Address_Master_Changed__C = true, FCU001P_ADDRESS_SEQ__c = '00001',
        AOPS_Cust_Id__c ='21111112', Sync_Failed__c = true, Number_Of_Attempts__c = null);
        insert asf;

        Account_Site_Final_Staging__c asf2 = new Account_Site_Final_Staging__c(Is_Address_Master_Changed__C = true, FCU001P_ADDRESS_SEQ__c = '00002',
        AOPS_Cust_Id__c ='21111112', Sync_Failed__c = true, Number_Of_Attempts__c = null);
        insert asf2;

        Test.startTest();
        AOPStoSFDCRetrySync retry = new AOPStoSFDCRetrySync();
        retry.run();

        List<AsyncApexJob> contactJob = [SELECT Id FROM AsyncApexJob
            WHERE ApexClass.Name = 'AOPSContactRetryProcessor' AND Status IN ('Holding', 'Queued', 'Preparing', 'Processing')];

        List<AsyncApexJob> accountJob = [SELECT Id FROM AsyncApexJob
            WHERE ApexClass.Name = 'AOPSAccountRetryProcessor' AND Status IN ('Holding', 'Queued', 'Preparing', 'Processing')];
        Test.stopTest();
            
       System.assertEquals(1, contactJob.size());
       System.assertEquals(1, accountJob.size());
    }
}
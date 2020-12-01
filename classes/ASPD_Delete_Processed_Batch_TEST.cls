/***************************************************************
*Name : ASPD_Delete_Processed_Batch_Test
*Created By : Shubham Gavhane (CompuCom)
*Created Date : 21st Nov,2019
*Purpose : Test ASPD_Delete_Processed_Batch
*Last Modified :
****************************************************************/

@isTest
public class ASPD_Delete_Processed_Batch_TEST {
    
    public testmethod static void testAccountServiceDataBatch(){
        Test.startTest();
        //CS for Scheduling batch class AccountServiceBatch class
        CustTransParentChildLevel__c custSettingRecord = new CustTransParentChildLevel__c();
        custSettingRecord.name = 'Parent';
        custSettingRecord.AccountServiceBatchInterval__c = 600;
        insert custSettingRecord;
        //Account Extension
        Account_Extension__c accExtn = new Account_Extension__c();
        accExtn.AOPS_Cust_Id__c = '90254922';
        accExtn.Original_Account_ID__c = '0011k000004gU9HAAU';
        //insert accExtn;
        //User Record
        Profile pf = [Select Id from Profile where Name = 'System Administrator'];
        User u1 = new User();
        u1.FirstName = 'Test';
        u1.LastName = 'User';
        u1.Email = 'testuser@officedepot.com';
        u1.CompanyName = 'test.com';
        u1.Title = 'Test User';
        u1.Username = 'nitishuser1@officedepot.com';
        u1.Alias = 'testuser';
        u1.CommunityNickname = 'Test User';
        u1.TimeZoneSidKey = 'America/Mexico_City';
        u1.LocaleSidKey = 'en_US';
        u1.EmailEncodingKey = 'ISO-8859-1';
        u1.ProfileId = pf.Id;
        u1.LanguageLocaleKey = 'en_US';
        u1.isActive = true;
        u1.OD_Employee_ID__c = '248484';
        insert u1;
        
        //sales person Record
        sales_person__c salesPerRec= new sales_person__c();
        salesPerRec.ExtIDSalesPerson__c = 'C502007';
        salesPerRec.user__c = u1.id;
        insert  salesPerRec;
        
        //Account Dormant
        Account_Dormant__c accDormantRec= new Account_Dormant__c();
        accDormantRec.AOPS_Cust_Id__c = '90254922';
        //accDormantRec.AccountExtension__c = accExtn.id;
        insert accDormantRec;
        
        //Create Account Service Data
        List<Account_Service_Proc_Data__c> accServiceDataList = new List<Account_Service_Proc_Data__c>();
        Account_Service_Proc_Data__c  custRec= new   Account_Service_Proc_Data__c (); 
        custRec.CREATE_UPDATE_FLAG__C='C';
        custRec.STATUS__C='SUCCESS';
        custRec.CONTRACT_RETAIL_CUST_CODE__C='C';
        custRec.BUSINESS_NAME__C='DID INC GSA ?';
        custRec.CUSTOMER_DELETE_FLAG__C='Active';
        custRec.CUSTOMER_TYPE__C='RG';
        custRec.FREIGHT_CHARGE_REQUIRED__C='N';
        custRec.SEGMENTATION__C='Federal';
        custRec.SECTOR__C='Public';
        custRec.ORDER_MAX_AMOUNT__C='0';
        custRec.REP__C='C502007';
        custRec.EMP_ID__C='175050';
        custRec.HOSTED_CATALOG_FLAG__c='N';
        custRec.Legal_Flag__C='N';
        custRec.Account_Type__c='Customer';
        custRec.Batch_Processed__c  = true;
        custRec.ORACLE_CUSTOMER_ID__C = '346105743';
        custRec.AOPS_CUSTOMER_ID__c = '90254922';
        custRec.SPC_Indicator__c = 'Y';
        //custRec.RSV2_CHAR2__c = 'Test';
        accServiceDataList.add(custRec);
        Account_Service_Proc_Data__c  siteRec= new   Account_Service_Proc_Data__c  (); 
        siteRec.CREATE_UPDATE_FLAG__C='C';
        siteRec.AOPS_CUSTOMER_ID__C = '90254922';
        siteRec.STATUS__C='SUCCESS';
        siteRec.CONTRACT_RETAIL_CUST_CODE__C='C';
        siteRec.BUSINESS_NAME__C='DID INC GSA ?';
        siteRec.CUSTOMER_DELETE_FLAG__C='Active';
        siteRec.CUSTOMER_TYPE__C='RG';
        siteRec.FREIGHT_CHARGE_REQUIRED__C='N';
        siteRec.SEGMENTATION__C='Federal';
        siteRec.SECTOR__C='Public';
        siteRec.ORDER_MAX_AMOUNT__C='0';
        siteRec.REP__C='C502007';
        siteRec.EMP_ID__C='248484';
        siteRec.HOSTED_CATALOG_FLAG__c='N';
        siteRec.Legal_Flag__C='N';
        siteRec.Account_Type__c='Site'; 
        siteRec.AOPS_ADDR_SEQ_NUM__c = '90254922-00001';
        siteRec.LOCATION_KEY__c = '1520381978250';
        siteRec.ACCOUNT_NAME__c = '18DEC12';
        siteRec.ADDRESS_LINE1__c = '6600 N MILITARY TRL';
        siteRec.ADDRESS_LINE2__c = 'Test';
        siteRec.CITY__c = 'BOCA RATON';
        siteRec.STATE__c = 'FL';
        siteRec.ZIP_CODE__c = '33496-2434';
        siteRec.COUNTRY__c = 'USA';
        siteRec.SITE_REP__c = 'C502007';
        siteRec.REP_EMP_ID__c = '175050';
        siteRec.Batch_Processed__c  = true;
        siteRec.SPC_Indicator__c = 'Y';
        //siteRec.RSV2_CHAR2__c = 'Test';

        accServiceDataList.add(siteRec);
        insert accServiceDataList;
        Database.executeBatch(new ASPD_Delete_Processed_Batch());
        Test.stopTest();
    }

}
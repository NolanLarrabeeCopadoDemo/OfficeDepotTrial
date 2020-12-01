@IsTest
public class AOPSAccountPreferencesFinalProcessor_TC {
    @isTest
    public static void makedata() {
      List<AOPS_Account_Preferences__c> contactMasterRecs = new List<AOPS_Account_Preferences__c> {
         new AOPS_Account_Preferences__c(Unique_Record_ID__c='111111111', FCU370P_VEHICLE_CODE__c ='MB', FCU370P_ENABLE_CNT_OPTIN__c='N', FCU370P_UPDATE_DATE__c ='0001-01-01', CXTF370P_ACTION__c='D', CXTF370P_TIMESTAMP__c='2020-06-30-01.03.14.3151', FCU370P_CUSTOMER_ID__c='05364606' ,Record_Updated__c=true),
         new AOPS_Account_Preferences__c(Unique_Record_ID__c='111111112', FCU370P_VEHICLE_CODE__c ='PH', FCU370P_ENABLE_CNT_OPTIN__c='Y', FCU370P_CREATE_ID__c ='XHCR', CXTF370P_ACTION__c='C', CXTF370P_TIMESTAMP__c='2020-06-30-01.03.14.3151', FCU370P_CUSTOMER_ID__c='05364605' ,Record_Updated__c=true),
         new AOPS_Account_Preferences__c(Unique_Record_ID__c='111111113', FCU370P_VEHICLE_CODE__c ='ML', FCU370P_ENABLE_CNT_OPTIN__c='Y', CXTF370P_ACTION__c='U', CXTF370P_TIMESTAMP__c='2020-06-30-01.03.14.3151', FCU370P_CUSTOMER_ID__c='05364604' ,Record_Updated__c=true),
         new AOPS_Account_Preferences__c(Unique_Record_ID__c='111111114', FCU370P_VEHICLE_CODE__c ='EM', FCU370P_ENABLE_CNT_OPTIN__c='N', CXTF370P_ACTION__c='D', CXTF370P_TIMESTAMP__c='2020-06-30-01.03.14.3151', FCU370P_CUSTOMER_ID__c='05364603' ,Record_Updated__c=true) };
         
       insert contactMasterRecs;
    
     test.startTest();
     System.enqueueJob(new AOPSAccountPreferencesFinalProcessor(contactMasterRecs));
     test.stopTest();
 }  
}
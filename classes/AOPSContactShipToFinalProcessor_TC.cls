@IsTest
public class AOPSContactShipToFinalProcessor_TC {
    @isTest
    public static void makedata() {
         List<AOPS_Contact_Ship_Address__c> contactMasterRecs = new List<AOPS_Contact_Ship_Address__c> {
            new AOPS_Contact_Ship_Address__c(Unique_Record_ID__c='111111111', CCU310F_CONTACT_ID__c='111111111', CCU310F_ADDR_SEQ__c='0001', CCU310F_DFT_SHIP_CONT__c='Y', CCU310F_ALLOW_BUY__c='N', CXTCNTS_TIMESTAMP__c='2020-06-30-01.03.14.3151', CCU310F_CUSTOMER_ID__c='9558038' ,Record_Updated__c=true),
            new AOPS_Contact_Ship_Address__c(Unique_Record_ID__c='111111112', CCU310F_CONTACT_ID__c='111111112', CCU310F_ADDR_SEQ__c='0002', CCU310F_DFT_SHIP_CONT__c='Y', CCU310F_ALLOW_BUY__c='N', CXTCNTS_TIMESTAMP__c='2020-06-30-01.03.14.3151', CCU310F_CUSTOMER_ID__c='9558037' ,Record_Updated__c=true),
            new AOPS_Contact_Ship_Address__c(Unique_Record_ID__c='111111113', CCU310F_CONTACT_ID__c='111111113', CCU310F_ADDR_SEQ__c='0003', CCU310F_DFT_SHIP_CONT__c='Y', CCU310F_ALLOW_BUY__c='N', CXTCNTS_TIMESTAMP__c='2020-06-30-01.03.14.3151', CCU310F_CUSTOMER_ID__c='9558036' ,Record_Updated__c=true) };
            
          insert contactMasterRecs;

        List<Contact_Final_Staging__c> finalStagingRec = new List<Contact_Final_Staging__c>{
            new Contact_Final_Staging__c  (Unique_Record_ID__c='111111111', AOPS_Contact_Number__c='111111111' ,AOPS_Account_Number__c='9558038'),
            new Contact_Final_Staging__c  (Unique_Record_ID__c='111111112', AOPS_Contact_Number__c='111111112' ,AOPS_Account_Number__c='9558037'),
            new Contact_Final_Staging__c  (Unique_Record_ID__c='111111113', AOPS_Contact_Number__c='111111113' ,AOPS_Account_Number__c='9558036')};
            
        insert finalStagingRec;
       
        test.startTest();
        System.enqueueJob(new AOPSContactShipToFinalProcessor(contactMasterRecs));
        test.stopTest();
    }
}
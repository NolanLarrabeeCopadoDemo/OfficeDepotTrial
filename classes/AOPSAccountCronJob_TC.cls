@IsTest
public class AOPSAccountCronJob_TC {
    
    @IsTest
    static void launchesJob() {
        Account acc = new Account(); 
        acc.aops_cust_id__c ='11111111';
        acc.Name='test';
        insert acc;
				Account acc7 = new Account();
				acc7.Aops_cust_id__c='124666';
				acc7.Name='Google';
				insert acc7;
				
        AOPS_Account_Master__c masterRec = new AOPS_Account_Master__c(Unique_Record_ID__c='11111111', FCU000P_CUSTOMER_ID__c='11111111', Record_Updated__c=true);
        insert masterRec;
        AOPS_Account_Child_Parent_Relationship__c cprRec = new AOPS_Account_Child_Parent_Relationship__c(Unique_Record_ID__c='22222222', FCU005P_CUSTOMER_ID__c='22222222', 
        FCU005P_PARENT_ID__c = '11111111', Record_Updated__c=true);
        insert cprRec;
        AOPS_Account_Addendum_Community__c adcRec = new AOPS_Account_Addendum_Community__c(Unique_Record_ID__c='33333333', CCU043F_AECUST__c='33333333', Record_Updated__c=true);
        insert adcRec;
        AOPS_Account_Addendum_Legal_Other__c aalRec = new AOPS_Account_Addendum_Legal_Other__c(Unique_Record_ID__c='44444444', CCU044F_CUSTOMER_ID__c='44444444', Record_Updated__c=true);
        insert aalRec;
        AOPS_Account_BSD_Addendum__c abaRec = new AOPS_Account_BSD_Addendum__c(Unique_Record_ID__c='55555555', CCU007F_CUSTOMER_ID__c='55555555', Record_Updated__c=true);
        insert abaRec;
        AOPS_Address_BSD_A__c abRec = new AOPS_Address_BSD_A__c(Unique_Record_ID__c='77777777', CCU009F_CUSTOMER_ID__c='77777777', Record_Updated__c=true);
        insert abRec;
        AOPS_Address_Master__c amRec = new AOPS_Address_Master__c(Unique_Record_ID__c='66666666', FCU001P_CUSTOMER_ID__c='66666666', FCU001P_ADDRESS_SEQ__c = '0001', Record_Updated__c=true);
        insert amRec; 
        AOPS_Address_Master__c amRecForRetry = new AOPS_Address_Master__c(Unique_Record_ID__c='66666665', FCU001P_CUSTOMER_ID__c='66666665', FCU001P_ADDRESS_SEQ__c = '0001', Record_Updated__c=false, sync_status_message__c=null);
        insert amRecForRetry; 
        AOPS_Account_Preferences__c apRec = new AOPS_Account_Preferences__c(Unique_Record_ID__c='99999999', FCU370P_CUSTOMER_ID__c='99999999', Record_Updated__c = true);
        insert apRec;
        Test.startTest();
        AOPSAccountCronJob cron = new AOPSAccountCronJob();
        cron.run();

        List<AsyncApexJob> jobs = [SELECT Id FROM AsyncApexJob
            WHERE ApexClass.Name = 'AOPSAccountFullProcessor' AND Status IN ('Holding', 'Queued', 'Preparing', 'Processing')];
        Test.stopTest();
            
        System.assertEquals(1, jobs.size());
    }
}
public class AOPSAccountRetryProcessor implements Queueable {

    private List<String> accountIdList;
    private static Integer NO_OF_RETRIES = 1;

    public AOPSAccountRetryProcessor(List<String> accountIdList) {
        this.accountIdList = accountIdList;
    }

    public void execute(QueueableContext context) {
        Savepoint sp = Database.setSavepoint();
        list<sync_batch_setting__mdt> sbs= [SELECT Id, batch_size__c, delay_next_job__c from sync_batch_setting__mdt where DeveloperName='number_of_retries' limit 1];
        if(sbs.size()>0) {
            NO_OF_RETRIES =sbs[0].batch_size__c.intValue();
        }     

        try {
            List<Account_Final_Staging__c> accountFinalStagingList = [SELECT Id, aops_cust_id__c, Sync_Failed__c, Number_Of_Attempts__c FROM Account_Final_Staging__c 
            WHERE Sync_Failed__c = true and (Number_Of_Attempts__c = null or Number_Of_Attempts__c < :NO_OF_RETRIES) AND aops_cust_id__c IN :accountIdList];
            for (Account_Final_Staging__c acctRec : accountFinalStagingList) {
                acctRec.Sync_Failed__c = false;
                if (acctRec.Number_Of_Attempts__c == null) 
                    acctRec.Number_Of_Attempts__c = 1;
                else
                    acctRec.Number_Of_Attempts__c = acctRec.Number_Of_Attempts__c + 1;
            }
            update accountFinalStagingList;
        } catch(Exception ex) {
            System.debug('AOPSAccountCronJob: Exception while retrying failed records for account final staging records.'+ ex.getMessage());
        }

        try {
            List<Account_Site_Final_Staging__c> siteList = [SELECT Id, aops_cust_id__c, Sync_Failed__c, Number_Of_Attempts__c FROM Account_Site_Final_Staging__c 
            WHERE ((Is_Address_Master_Changed__c = true and sync_failed__c = false) or sync_failed__c = true) and (Number_Of_Attempts__c = null or Number_Of_Attempts__c < :NO_OF_RETRIES) AND aops_cust_id__c IN :accountIdList];
            for (Account_Site_Final_Staging__c site : siteList) {
                site.Sync_Failed__c = false;
                if (site.Number_Of_Attempts__c == null) 
                    site.Number_Of_Attempts__c = 1;
                else
                    site.Number_Of_Attempts__c = site.Number_Of_Attempts__c + 1;
            }
            update siteList;
        } catch(Exception ex) {
            System.debug('AOPSAccountCronJob: Exception while retrying failed records for account site final staging records.'+ ex.getMessage());
        }
    }
}
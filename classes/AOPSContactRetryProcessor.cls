public class AOPSContactRetryProcessor implements Queueable {

    private List<String> contactIdList;
    private static Integer WEBUSER_BATCH_SIZE = 50;
    private static Integer SITECONTACT_BATCH_SIZE = 50;
    private static Integer NO_OF_RETRIES = 1;

    public AOPSContactRetryProcessor(List<String> contactIdList) {
        this.contactIdList = contactIdList;
    }

    public void execute(QueueableContext context) {
        Savepoint sp = Database.setSavepoint();

        list<sync_batch_setting__mdt> sbs= [SELECT Id, batch_size__c, delay_next_job__c from sync_batch_setting__mdt where DeveloperName='number_of_retries' limit 1];
        if(sbs.size()>0) {
            NO_OF_RETRIES =sbs[0].batch_size__c.intValue();
        }
        try{        
            List<contact_final_staging__c> cntFinalStagingList = [SELECT Id, aops_contact_number__c, Sync_Failed__c, Number_Of_Attempts__c, Sync_Status_Message__c, Contact_Sync_Message__c FROM contact_final_staging__c 
            where Sync_Failed__c = true and (Number_Of_Attempts__c = null or Number_Of_Attempts__c <= :NO_OF_RETRIES) AND aops_contact_number__c IN :contactIdList];
            for (contact_final_staging__c cntFinalStaging : cntFinalStagingList) {
            cntFinalStaging.Sync_Failed__c = false;
            cntFinalStaging.Contact_Sync_Message__c = null;
            cntFinalStaging.Sync_Status_Message__c = null;
            if (cntFinalStaging.Number_Of_Attempts__c == null) 
                cntFinalStaging.Number_Of_Attempts__c = 1;
            else
                 cntFinalStaging.Number_Of_Attempts__c = cntFinalStaging.Number_Of_Attempts__c + 1;
            }
            update cntFinalStagingList;
        } catch(Exception ex) {
            System.debug('AOPSContactCronJob: Exception while retrying failed records for contact final staging records.'+ ex.getMessage());
        }

        try{
            List<SiteContacts_Final_Staging__c> siteContactList = [SELECT Id, aops_contact_number__c, Sync_Failed__c, Is_Changed__c, Number_Of_Attempts__c, Sync_Message__c FROM SiteContacts_Final_Staging__c 
            WHERE Sync_Failed__c = true and is_changed__c = true and Number_Of_Attempts__c <= :NO_OF_RETRIES AND aops_contact_number__c IN :contactIdList];
            for (SiteContacts_Final_Staging__c siteContact : siteContactList) {
                siteContact.Sync_Failed__c = false;
                siteContact.Sync_Message__c = null;
                if (siteContact.Number_Of_Attempts__c == null) 
                    siteContact.Number_Of_Attempts__c = 1;
                else
                    siteContact.Number_Of_Attempts__c = siteContact.Number_Of_Attempts__c + 1;
            }
            update siteContactList;
        } catch(Exception ex) {
            System.debug('AOPSContactCronJob: Exception while retrying failed records for sitecontact final staging records.'+ ex.getMessage());
        }
    }
}
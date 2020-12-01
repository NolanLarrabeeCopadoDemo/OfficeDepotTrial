global class AOPSContactCronJob implements Schedulable {

    private static Integer BATCH_SIZE = 50;
    private static Integer SECONDS_UNTIL_NEXT_RUN = 15;
    private static Integer NO_OF_RETRIES = 1;
    private static Integer CONTACT_NUMBER_LIMIT_FOR_ALL_TABS = 2000;

    global void execute(SchedulableContext sc) {
        run();
    }

    public void run() {

        list<sync_batch_setting__mdt> sbs= [SELECT Id, batch_size__c, delay_next_job__c from sync_batch_setting__mdt where DeveloperName='contact_number_limit_for_all_tabs' limit 1];
        if(sbs.size()>0) {
            CONTACT_NUMBER_LIMIT_FOR_ALL_TABS =sbs[0].batch_size__c.intValue();
        }

        sbs= [SELECT Id, batch_size__c, delay_next_job__c from sync_batch_setting__mdt where DeveloperName='number_of_retries' limit 1];
        if(sbs.size()>0) {
            NO_OF_RETRIES =sbs[0].batch_size__c.intValue();
        }

        sbs= [SELECT Id, batch_size__c, delay_next_job__c from sync_batch_setting__mdt where DeveloperName='Contact' limit 1];
        //Integer  BATCH_SIZE=BATCH_SIZE;
        Integer  v_delay_job=SECONDS_UNTIL_NEXT_RUN ;
        
        if(sbs.size() > 0) {
            BATCH_SIZE =sbs[0].batch_size__c.intValue();
            v_delay_job = sbs[0].delay_next_job__c.intValue();
        }

        retryFailedAOPSStagingRecords();
        retryFailedFinalStagingRecords();       
         
        if(jobAlreadyRunning() == false) {
            Map<String,string> contactNumbers = getContactNumbers();
            List<List<String>> contactNumberLists = splitContactNumbers(contactNumbers,BATCH_SIZE);

            for(List<String> contactNumberList : contactNumberLists)
                enqueueJob(new AOPSContactFullProcessor(contactNumberList));
        }

        scheduleNextRun(v_delay_job);
    }

    private Boolean jobAlreadyRunning() {
        List<AsyncApexJob> jobs = [SELECT Id FROM AsyncApexJob
            WHERE ApexClass.Name = 'AOPSContactFullProcessor' AND Status IN ('Holding', 'Queued', 'Preparing', 'Processing')];
        return jobs.size() > 0;
    }

    private Map<String,string> getContactNumbers() {
        Map<String,string> contactNumbers = new Map<String,string> ();
        addMasterContactNumbers(contactNumbers);
        addEmailContactNumbers(contactNumbers);
        addPhoneContactNumbers(contactNumbers);
        addWebUserContactNumbers(contactNumbers);
        addShipToContactNumbers(contactNumbers);
        addOptInContactNumbers(contactNumbers);
        return contactNumbers;
    }

    private void addMasterContactNumbers(Map<String,string> contactNumbers) {
        List<AOPS_STG_CONTACT_MASTER__c> stagingRecs = [SELECT Id, CCU300F_CONTACT_ID__c,CCU300F_CUSTOMER_ID__c
            FROM AOPS_STG_CONTACT_MASTER__c WHERE Record_Updated__c = true LIMIT :CONTACT_NUMBER_LIMIT_FOR_ALL_TABS];
        
        for(AOPS_STG_CONTACT_MASTER__c stagingRec : stagingRecs)
            contactNumbers.put(stagingRec.CCU300F_CONTACT_ID__c, stagingRec.CCU300F_CUSTOMER_ID__c);
    }

    private void addEmailContactNumbers(Map<String,string> contactNumbers) {
        List<AOPS_Contact_Email__c> stagingRecs = [SELECT Id, CCU340F_CONTACT_ID__c,CXTCNTE_AOPS_KEY1__c
            FROM AOPS_Contact_Email__c WHERE Record_Updated__c = true LIMIT :CONTACT_NUMBER_LIMIT_FOR_ALL_TABS];
        
        for(AOPS_Contact_Email__c stagingRec : stagingRecs)
            contactNumbers.put(stagingRec.CCU340F_CONTACT_ID__c, stagingRec.CXTCNTE_AOPS_KEY1__c);
    }
    
    private void addPhoneContactNumbers(Map<String,string> contactNumbers) {
        List<AOPS_Contact_Phone__c> stagingRecs = [SELECT Id, CCU320F_CONTACT_ID__c,CCU320F_CUSTOMER_ID__c
            FROM AOPS_Contact_Phone__c WHERE Record_Updated__c = true LIMIT :CONTACT_NUMBER_LIMIT_FOR_ALL_TABS];
        
        for(AOPS_Contact_Phone__c stagingRec : stagingRecs)
            contactNumbers.put(stagingRec.CCU320F_CONTACT_ID__c, stagingRec.CCU320F_CUSTOMER_ID__c);
    }
    
    private void addWebUserContactNumbers(Map<String,string> contactNumbers) {
        List<AOPS_Contact_Web_User__c> stagingRecs = [SELECT Id, CCU330F_CONTACT_ID__c,CCU330F_CUSTOMER_ID__c
            FROM AOPS_Contact_Web_User__c WHERE Record_Updated__c = true LIMIT :CONTACT_NUMBER_LIMIT_FOR_ALL_TABS];
        
        for(AOPS_Contact_Web_User__c stagingRec : stagingRecs)
            contactNumbers.put(stagingRec.CCU330F_CONTACT_ID__c, stagingRec.CCU330F_CUSTOMER_ID__c);
    }
    
    private void addShipToContactNumbers(Map<String,string> contactNumbers) {
        List<AOPS_Contact_Ship_Address__c> stagingRecs = [SELECT Id, CCU310F_CONTACT_ID__c,CCU310F_CUSTOMER_ID__c
            FROM AOPS_Contact_Ship_Address__c WHERE Record_Updated__c = true LIMIT :CONTACT_NUMBER_LIMIT_FOR_ALL_TABS];
        
        for(AOPS_Contact_Ship_Address__c stagingRec : stagingRecs)
            contactNumbers.put(stagingRec.CCU310F_CONTACT_ID__c, stagingRec.CCU310F_CUSTOMER_ID__c);
    }
    
    private void addOptInContactNumbers(Map<String,string> contactNumbers) {
        List<AOPS_CONTACT_OPT_IN__c> stagingRecs = [SELECT Id, CCU380F_CONTACT_ID__c,CCU380F_CUSTOMER_ID__c
            FROM AOPS_CONTACT_OPT_IN__c WHERE Record_Updated__c = true LIMIT :CONTACT_NUMBER_LIMIT_FOR_ALL_TABS];
        
        for(AOPS_CONTACT_OPT_IN__c stagingRec : stagingRecs)
            contactNumbers.put(stagingRec.CCU380F_CONTACT_ID__c, stagingRec.CCU380F_CUSTOMER_ID__c);
    }

    private List<List<String>> splitContactNumbers(Map<String,string> contactNumbers , Integer batch_size) {
        if(contactNumbers.size() == 0)
            return new List<List<String>>();
        Integer list_size =0; 
        List<List<String>> contactNumberLists = new List<List<String>>();
        contactNumberLists.add(new List<String>());
        List<String> currentList = contactNumberLists[0];
        Map<String,List<string>> acctcnctmap =  new Map<String,List<string>>();
        
        for(String cnct: contactNumbers.keySet()) {
            if(acctcnctmap.containsKey(contactNumbers.get(cnct))) {
                acctcnctmap.get(contactNumbers.get(cnct)).add(cnct);
            } else {
                acctcnctmap.put(contactNumbers.get(cnct),new List<String>{cnct});
            }
        }
        
        for(String acctnum: acctcnctmap.keySet()) {
            for(String cnct:acctcnctmap.get(acctnum)) {
                currentList.add(cnct);
                list_size =list_size +1;
                  
                if(list_size  >= batch_size ) {
                    currentList = new List<String>();
                    contactNumberLists.add(currentList);
                    list_size =0;
                    break;
                }
            }
        }
        
        return contactNumberLists;
    }

    private void enqueueJob(Queueable qJob) {
        if(limitsExceeded() == false) {
            Id jobId = System.enqueueJob(qJob);
        }
    }

    private Boolean limitsExceeded() {
        return Limits.getQueueableJobs() >= Limits.getLimitQueueableJobs();
    }

    private void scheduleNextRun(Integer delay_job) {
        Datetime nextRunTime = System.now().addSeconds(delay_job);
        String chronExpression = nextRunTime.second() + ' ' + nextRunTime.minute() + ' ' +
            nextRunTime.hour() + ' ' + nextRunTime.day() + ' ' + nextRunTime.month() + ' ? ' + nextRunTime.year();
        
        if(Test.isRunningTest() == false)
            System.schedule('AOPS Contact Job' + nextRunTime, chronExpression, new AOPSContactCronJob());
    }

    private void retryFailedFinalStagingRecords() {

        try {
            List<contact_final_staging__c> cntFinalStagingList = [SELECT Id, Sync_Failed__c, Number_Of_Attempts__c, Sync_Status_Message__c, Contact_Sync_Message__c from contact_final_staging__c where Sync_Failed__c = true and (Number_Of_Attempts__c = null or Number_Of_Attempts__c <= :NO_OF_RETRIES) limit :BATCH_SIZE];
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

        try {
            List<SiteContacts_Final_Staging__c> siteContactList = [SELECT Id, Sync_Failed__c, Is_Changed__c, Number_Of_Attempts__c, Sync_Message__c from SiteContacts_Final_Staging__c where Sync_Failed__c = true and is_changed__c = true and Number_Of_Attempts__c <= :NO_OF_RETRIES limit :BATCH_SIZE];
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

    private void retryFailedAOPSStagingRecords() {

        try {
            List<aops_stg_contact_master__c> contactMasterList = [select id, record_updated__c, CXTCNTM_TIMESTAMP__c, Number_Of_Attempts__c from aops_stg_contact_master__c where Sync_Status_Message__c = null and record_updated__c = false and (Number_Of_Attempts__c = null or  Number_Of_Attempts__c < :NO_OF_RETRIES) limit :BATCH_SIZE];
            for (aops_stg_contact_master__c contactMaster : contactMasterList) {
                List<String> parts = contactMaster.CXTCNTM_TIMESTAMP__c.split('\\.');
                String newLast = String.valueOf(Integer.valueOf(parts[3]) + 1).leftPad(6, '0');
                String newTS = parts[0] + '.' + parts[1] + '.' + parts[2] + '.' + newLast;
                contactMaster.CXTCNTM_TIMESTAMP__c = newTS;
                contactMaster.Record_Updated__c = true;
                if (contactMaster.Number_Of_Attempts__c == null) 
                    contactMaster.Number_Of_Attempts__c = 1;
                else
                    contactMaster.Number_Of_Attempts__c = contactMaster.Number_Of_Attempts__c + 1;
            }
            update contactMasterList;
        } catch(Exception ex) {
            System.debug('AOPSContactCronJob: Exception while retrying failed records for contact master staging records.'+ ex.getMessage());
        }

        try {
            List<aops_contact_web_user__c> webUserList = [select id, record_updated__c, CXTCNTW_TIMESTAMP__c, Number_Of_Attempts__c from aops_contact_web_user__c  where Sync_Status_Message__c = null and record_updated__c = false and (Number_Of_Attempts__c = null or  Number_Of_Attempts__c < :NO_OF_RETRIES) limit :BATCH_SIZE];
            for (aops_contact_web_user__c webUser : webUserList) {
                List<String> parts = webUser.CXTCNTW_TIMESTAMP__c.split('\\.');
                String newLast = String.valueOf(Integer.valueOf(parts[3]) + 1).leftPad(6, '0');
                String newTS = parts[0] + '.' + parts[1] + '.' + parts[2] + '.' + newLast;
                webUser.CXTCNTW_TIMESTAMP__c = newTS;
                webUser.Record_Updated__c = true;
                if (webUser.Number_Of_Attempts__c == null) 
                    webUser.Number_Of_Attempts__c = 1;
                else
                    webUser.Number_Of_Attempts__c = webUser.Number_Of_Attempts__c + 1;
            }
            update webUserList;
        } catch(Exception ex) {
            System.debug('AOPSContactCronJob: Exception while retrying failed records for contact webuser staging records.'+ ex.getMessage());
        }
    }
}
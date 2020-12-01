global class AOPSAccountCronJob implements Schedulable {

    private static Integer BATCH_SIZE = 50;
    private static Integer SECONDS_UNTIL_NEXT_RUN = 15;
    private static Integer NO_OF_RETRIES = 1;
   
    global void execute(SchedulableContext sc) {
        run();
    }

    public void run() {
    
        list<sync_batch_setting__mdt> sbs= [SELECT Id, batch_size__c, delay_next_job__c from sync_batch_setting__mdt where DeveloperName='number_of_retries' limit 1];
        if(sbs.size()>0) {
            NO_OF_RETRIES =sbs[0].batch_size__c.intValue();
        }        

        sbs= [SELECT Id, batch_size__c, delay_next_job__c from sync_batch_setting__mdt where DeveloperName='Account' limit 1];
        //Integer BATCH_SIZE = BATCH_SIZE;
        Integer v_delay_job = SECONDS_UNTIL_NEXT_RUN;
        if(sbs.size()>0) {
            BATCH_SIZE =sbs[0].batch_size__c.intValue();
            v_delay_job = sbs[0].delay_next_job__c.intValue();
        }

        retryFailedAOPSStagingRecords();
        retryFailedFinalStagingRecords();

        if(jobAlreadyRunning() == false) {
            System.debug('Here');
            Map<String, list< map<String,Integer>>>  parent_child_site = getAccountNumbers();
            System.debug('parent_child_site: ' + parent_child_site);
            List<List<String>> accountNumberLists = splitAccountNumbers(parent_child_site ,BATCH_SIZE );
            System.debug('accountNumberLists: ' + accountNumberLists);

            for(List<String> accountNumberList : accountNumberLists) {
                System.debug('AccountCron:AcctNumbers:' + accountNumberList);
                enqueueJob(new AOPSAccountFullProcessor(accountNumberList));
            }
        }
       
        scheduleNextRun(v_delay_job );
    }

    private Boolean jobAlreadyRunning() {
        List<AsyncApexJob> jobs = [SELECT Id FROM AsyncApexJob
            WHERE ApexClass.Name = 'AOPSAccountFullProcessor' AND Status IN ('Holding', 'Queued', 'Preparing', 'Processing')];
        return jobs.size() > 0;
    }

    private Map<String, list< map<String,Integer>>>  getAccountNumbers() {
        Set<String> accountNumbers = new Set<String>();
        Set<String> accountNumberslpad = new Set<String>();
        Map<String, list< map<String,Integer>>>  parent_child_site = new Map<String,list< map<String,Integer>> > ();
        Map<String,list<string>> child_site = new map<String,list<string>>();
        Map<String,string> child_parent = new map<String,string>();
        addAddressMasterAccountNumbers(accountNumbers,child_site);
        addChildParentRelAccountNumbers(accountNumbers,child_parent);
        addMasterAccountNumbers(accountNumbers);
        addAddendumCommunityAccountNumbers(accountNumbers);
        addLegalAddendumAccountNumbers(accountNumbers);
        addBSDAddendumAccountNumbers(accountNumbers);
        addPreferencesAccountNumbers(accountNumbers);
        
        addAddressBSDAddendumAccountNumbers(accountNumbers);

        for(String accnum: accountNumbers) {
            accountNumberslpad.add(accnum.leftPad(8, '0'));
            //System.debug('accountNumberslpad=' + accnum.leftPad(8, '0'));
        }
        Integer iterCount = 0;
        for ( Account acc: [select id,parent.aops_cust_id__C, aops_cust_id__C from Account where aops_cust_id__C =:accountNumberslpad LIMIT 49990]) {
            String parentid = '-1';
           
            if(!child_parent.containsKey(String.valueOf(integer.valueof(acc.aops_cust_id__C)))) {                
                if (acc.parent.aops_cust_id__C != null) {
                    parentid =String.valueOf(integer.valueof(acc.parent.aops_cust_id__C));
                } else {
                    parentid =String.valueOf(integer.valueof(acc.aops_cust_id__C));
                }
                child_parent.put(String.valueOf(integer.valueof(acc.aops_cust_id__C)),parentid);  
                //System.debug('inside acc =' + String.valueOf(integer.valueof(acc.aops_cust_id__C))+' : ' + parentid );              
            }
            if (iterCount > 49990) break;
            iterCount++;
        }
        
        for(String child:accountNumbers) {
            map<String,Integer> num_sites = new map<String,Integer>();
            if(!child_parent.containsKey(child)) {                
                child_parent.put(child,child);   
                //System.debug('miss parent acc =' + child+ ' : ' + child );                
            }
            
            
            if(child_site.containsKey(child)) {
                num_sites.put(child , child_site.get(child).size());
            } else {
                num_sites.put(child , 0);
            }

            if(child_parent.containsKey(child)) {
                if(parent_child_site.containsKey(child_parent.get(child))) {                
                     parent_child_site.get(child_parent.get(child)).add(num_sites);
                     System.debug(' child with sites =' +child+' : '+ parent_child_site.get(child_parent.get(child)).size() );  
                } else {
                   parent_child_site.put(child_parent.get(child),new List<map<String,Integer>>{num_sites});
                   System.debug(' child with sites =' +child+' : '+  parent_child_site.get(child_parent.get(child)).size() );  
                }            
            }
        }
        
        return parent_child_site;
    }

    private void addMasterAccountNumbers(Set<String> accountNumbers) {
        List<AOPS_Account_Master__c> stagingRecs = [SELECT Id, FCU000P_CUSTOMER_ID__c
            FROM AOPS_Account_Master__c WHERE Record_Updated__c = true LIMIT 2500];

        for(AOPS_Account_Master__c stagingRec : stagingRecs)
            accountNumbers.add(stagingRec.FCU000P_CUSTOMER_ID__c);
    }

    private void addAddendumCommunityAccountNumbers(Set<String> accountNumbers) {
        List<AOPS_Account_Addendum_Community__c> stagingRecs = [SELECT Id, CCU043F_AECUST__c
            FROM AOPS_Account_Addendum_Community__c WHERE Record_Updated__c = true LIMIT 2500];

        for(AOPS_Account_Addendum_Community__c stagingRec : stagingRecs)
            accountNumbers.add(stagingRec.CCU043F_AECUST__c);
    }
    
    private void addLegalAddendumAccountNumbers(Set<String> accountNumbers) {
        List<AOPS_Account_Addendum_Legal_Other__c> stagingRecs = [SELECT Id, CCU044F_CUSTOMER_ID__c
            FROM AOPS_Account_Addendum_Legal_Other__c WHERE Record_Updated__c = true LIMIT 2500];

        for(AOPS_Account_Addendum_Legal_Other__c stagingRec : stagingRecs)
            accountNumbers.add(stagingRec.CCU044F_CUSTOMER_ID__c);
    }

    private void addBSDAddendumAccountNumbers(Set<String> accountNumbers) {
        List<AOPS_Account_BSD_Addendum__c> stagingRecs = [SELECT Id, CCU007F_CUSTOMER_ID__c
            FROM AOPS_Account_BSD_Addendum__c WHERE Record_Updated__c = true LIMIT 2500];

        for(AOPS_Account_BSD_Addendum__c stagingRec : stagingRecs)
            accountNumbers.add(stagingRec.CCU007F_CUSTOMER_ID__c);
    }

    private void addChildParentRelAccountNumbers(Set<String> accountNumbers,Map<String ,String> child_parent ) {
        List<AOPS_Account_Child_Parent_Relationship__c> stagingRecs = [SELECT Id, FCU005P_CUSTOMER_ID__c   ,FCU005P_PARENT_ID__c
            FROM AOPS_Account_Child_Parent_Relationship__c WHERE Record_Updated__c = true LIMIT 2500];

        for(AOPS_Account_Child_Parent_Relationship__c stagingRec : stagingRecs)
        {
            accountNumbers.add(stagingRec.FCU005P_CUSTOMER_ID__c);
            child_parent.put(stagingRec.FCU005P_CUSTOMER_ID__c,stagingRec.FCU005P_PARENT_ID__c);
            
        }
            
            
    }

    private void addPreferencesAccountNumbers(Set<String> accountNumbers) {
        List<AOPS_Account_Preferences__c> stagingRecs = [SELECT Id, FCU370P_CUSTOMER_ID__c
            FROM AOPS_Account_Preferences__c WHERE Record_Updated__c = true LIMIT 2500];

        for(AOPS_Account_Preferences__c stagingRec : stagingRecs)
            accountNumbers.add(stagingRec.FCU370P_CUSTOMER_ID__c);
    }

    private void addAddressMasterAccountNumbers(Set<String> accountNumbers, Map<String,list<string>> child_site) {
        List<AOPS_Address_Master__c> stagingRecs = [SELECT Id, FCU001P_CUSTOMER_ID__c,  FCU001P_ADDRESS_SEQ__c
            FROM AOPS_Address_Master__c WHERE Record_Updated__c = true LIMIT 2500];

        for(AOPS_Address_Master__c stagingRec : stagingRecs) {
            accountNumbers.add(stagingRec.FCU001P_CUSTOMER_ID__c);
            
            if(child_site.containsKey(stagingRec.FCU001P_CUSTOMER_ID__c)) {
                child_site.get(stagingRec.FCU001P_CUSTOMER_ID__c).add(stagingRec.FCU001P_ADDRESS_SEQ__c);
            } else {
                child_site.put(stagingRec.FCU001P_CUSTOMER_ID__c,new List<String>{stagingRec.FCU001P_ADDRESS_SEQ__c});
            }
        }
    }

    private void addAddressBSDAddendumAccountNumbers(Set<String> accountNumbers) {
        List<AOPS_Address_BSD_A__c> stagingRecs = [SELECT Id, CCU009F_CUSTOMER_ID__c
            FROM AOPS_Address_BSD_A__c WHERE Record_Updated__c = true LIMIT 2500];

        for(AOPS_Address_BSD_A__c stagingRec : stagingRecs)
            accountNumbers.add(stagingRec.CCU009F_CUSTOMER_ID__c);
    }

    private List<List<String>> splitAccountNumbers( Map<String, list< map<String,Integer>>>  parent_child_site, Integer batch_size ) {
        if(parent_child_site.size() == 0)
            return new List<List<String>>();
        Integer list_size =0;
        List<List<String>> accountNumberLists = new List<List<String>>();
        accountNumberLists.add(new List<String>());
        List<String> currentList = accountNumberLists[0];

        for(String parentNumber : parent_child_site.keySet()) {
            for(Map<String,Integer> customermap :parent_child_site.get(parentNumber) ) {
                for(String customer:  customermap.keySet()) {
                    if(list_size  >= batch_size ) {
                        currentList = new List<String>();
                        accountNumberLists.add(currentList);
                        list_size =0;
                        break;
                    }

                    currentList.add(customer);
                    list_size =list_size +1+customermap.get(customer );
                }

                if(list_size == 0) {
                    break;
                }
            }
        }
        
        return accountNumberLists;
    }

    private void enqueueJob(Queueable qJob) {
        if(limitsExceeded() == false) {
            System.debug('Starting a job.');
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
            System.schedule('AOPS Account Job' + nextRunTime, chronExpression, new AOPSAccountCronJob());
    }

    private void retryFailedAOPSStagingRecords() {
        try {
            List<aops_account_master__c> accountMasterList = [select id, record_updated__c, CXTF000P_TIMESTAMP__c, Number_Of_Attempts__c from aops_account_master__c where Sync_Status_Message__c = null and record_updated__c = false and (Number_Of_Attempts__c = null or  Number_Of_Attempts__c < :NO_OF_RETRIES) limit :BATCH_SIZE];
            for (aops_account_master__c accountMaster : accountMasterList) {
                if (accountMaster.CXTF000P_TIMESTAMP__c != null) {
                    List<String> parts = accountMaster.CXTF000P_TIMESTAMP__c.split('\\.');
                    String newLast = String.valueOf(Integer.valueOf(parts[3]) + 1).leftPad(6, '0');
                    String newTS = parts[0] + '.' + parts[1] + '.' + parts[2] + '.' + newLast;
                    accountMaster.CXTF000P_TIMESTAMP__c = newTS;
                } else {
                	accountMaster.CXTF000P_TIMESTAMP__c = String.valueOf(DateTime.now());
                }
                accountMaster.Record_Updated__c = true;
                if (accountMaster.Number_Of_Attempts__c == null) 
                    accountMaster.Number_Of_Attempts__c = 1;
                else
                    accountMaster.Number_Of_Attempts__c = accountMaster.Number_Of_Attempts__c + 1;
            }
			update accountMasterList;
        } catch(Exception ex) {
            System.debug('AOPSAccountCronJob: Exception while retrying failed records for account master staging records.'+ ex.getMessage());
        }
        try {
            List<aops_address_master__c> addressMasterList = [select id, record_updated__c, CXTF001P_TIMESTAMP__c, Number_Of_Attempts__c from aops_address_master__c where Sync_Status_Message__c = null and record_updated__c = false and (Number_Of_Attempts__c = null or  Number_Of_Attempts__c < :NO_OF_RETRIES) limit :BATCH_SIZE];
            for (aops_address_master__c addressMaster : addressMasterList) {
                if (addressMaster.CXTF001P_TIMESTAMP__c != null) {
                    List<String> parts = addressMaster.CXTF001P_TIMESTAMP__c.split('\\.');
                    String newLast = String.valueOf(Integer.valueOf(parts[3]) + 1).leftPad(6, '0');
                    String newTS = parts[0] + '.' + parts[1] + '.' + parts[2] + '.' + newLast;
                    addressMaster.CXTF001P_TIMESTAMP__c = newTS;
                } else {
                	addressMaster.CXTF001P_TIMESTAMP__c = String.valueOf(DateTime.now());
                }
                addressMaster.Record_Updated__c = true;
                if (addressMaster.Number_Of_Attempts__c == null) 
                    addressMaster.Number_Of_Attempts__c = 1;
                else
                    addressMaster.Number_Of_Attempts__c = addressMaster.Number_Of_Attempts__c + 1;
            }
			update addressMasterList;
        } catch(Exception ex) {
            System.debug('AOPSAccountCronJob: Exception while retrying failed records for address master staging records.'+ ex.getMessage());
        }
    }

    private void retryFailedFinalStagingRecords() {

        try {
            List<Account_Final_Staging__c> accountFinalStagingList = [SELECT Id, Sync_Failed__c, Number_Of_Attempts__c from Account_Final_Staging__c where (Sync_Failed__c = true or Sync_Failed_Reason__c like ':UNABLE_TO_LOCK_ROW%') and (Number_Of_Attempts__c = null or Number_Of_Attempts__c < :NO_OF_RETRIES) limit :BATCH_SIZE];
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
            List<Account_Site_Final_Staging__c> siteList = [SELECT Id, Sync_Failed__c, Number_Of_Attempts__c from Account_Site_Final_Staging__c where ((Is_Address_Master_Changed__c = true and sync_failed__c = false) or sync_failed__c = true) and (Number_Of_Attempts__c = null or Number_Of_Attempts__c < :NO_OF_RETRIES) limit :BATCH_SIZE];
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
global class AOPStoSFDCRetrySync implements Schedulable {

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
        Integer v_delay_job = SECONDS_UNTIL_NEXT_RUN;
        if(sbs.size()>0) {
            BATCH_SIZE =sbs[0].batch_size__c.intValue();
            v_delay_job = sbs[0].delay_next_job__c.intValue();
        }

        retryFailedAOPSStagingRecords();
        retryFailedFinalStagingRecords();

        scheduleNextRun(v_delay_job);
    }

    private void retryFailedAOPSStagingRecords() {

        try {
            List<aops_stg_contact_master__c> contactMasterList = [SELECT id, record_updated__c, CXTCNTM_TIMESTAMP__c, Number_Of_Attempts__c FROM aops_stg_contact_master__c 
             WHERE Sync_Status_Message__c = null and record_updated__c = false and (Number_Of_Attempts__c = null or  Number_Of_Attempts__c < :NO_OF_RETRIES) limit 10000];
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
            List<aops_contact_web_user__c> webUserList = [SELECT id, record_updated__c, CXTCNTW_TIMESTAMP__c, Number_Of_Attempts__c FROM aops_contact_web_user__c
             WHERE Sync_Status_Message__c = null and record_updated__c = false and (Number_Of_Attempts__c = null or  Number_Of_Attempts__c < :NO_OF_RETRIES) limit 10000];
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

        try {
            List<aops_contact_phone__C> contactPhoneList = [SELECT id, record_updated__c, CXTCNTP_TIMESTAMP__c, Number_Of_Attempts__c FROM aops_contact_phone__C 
             WHERE Sync_Status_Message__c = null and record_updated__c = false and (Number_Of_Attempts__c = null or  Number_Of_Attempts__c < :NO_OF_RETRIES) limit 10000];
            for (aops_contact_phone__C contactPhone : contactPhoneList) {
                List<String> parts = contactPhone.CXTCNTP_TIMESTAMP__c.split('\\.');
                String newLast = String.valueOf(Integer.valueOf(parts[3]) + 1).leftPad(6, '0');
                String newTS = parts[0] + '.' + parts[1] + '.' + parts[2] + '.' + newLast;
                contactPhone.CXTCNTP_TIMESTAMP__c = newTS;
                contactPhone.Record_Updated__c = true;
                if (contactPhone.Number_Of_Attempts__c == null) 
                    contactPhone.Number_Of_Attempts__c = 1;
                else
                    contactPhone.Number_Of_Attempts__c = contactPhone.Number_Of_Attempts__c + 1;
            }
            update contactPhoneList;
        } catch(Exception ex) {
            System.debug('AOPSContactCronJob: Exception while retrying failed records for contact phone staging records.'+ ex.getMessage());
        }

        try {
            List<aops_contact_email__C> contactEmailList = [SELECT id, record_updated__c, CXTCNTE_TIMESTAMP__c, Number_Of_Attempts__c FROM aops_contact_email__C 
             WHERE Sync_Status_Message__c = null and record_updated__c = false and (Number_Of_Attempts__c = null or  Number_Of_Attempts__c < :NO_OF_RETRIES) limit 10000];
            for (aops_contact_email__c contactEmail : contactEmailList) {
                List<String> parts = contactEmail.CXTCNTE_TIMESTAMP__c.split('\\.');
                String newLast = String.valueOf(Integer.valueOf(parts[3]) + 1).leftPad(6, '0');
                String newTS = parts[0] + '.' + parts[1] + '.' + parts[2] + '.' + newLast;
                contactEmail.CXTCNTE_TIMESTAMP__c = newTS;
                contactEmail.Record_Updated__c = true;
                if (contactEmail.Number_Of_Attempts__c == null) 
                    contactEmail.Number_Of_Attempts__c = 1;
                else
                    contactEmail.Number_Of_Attempts__c = contactEmail.Number_Of_Attempts__c + 1;
            }
            update contactEmailList;
        } catch(Exception ex) {
            System.debug('AOPSContactCronJob: Exception while retrying failed records for contact email staging records.'+ ex.getMessage());
        }

        try {
            List<AOPS_Contact_Opt_In__c> contactOptInList = [SELECT id, record_updated__c, CXTCNTO_TIMESTAMP__c, Number_Of_Attempts__c FROM AOPS_Contact_Opt_In__c 
            WHERE Sync_Status_Message__c = null and record_updated__c = false and (Number_Of_Attempts__c = null or  Number_Of_Attempts__c < :NO_OF_RETRIES) limit 10000];
            for (AOPS_Contact_Opt_In__c contactOptIn : contactOptInList) {
                List<String> parts = contactOptIn.CXTCNTO_TIMESTAMP__c.split('\\.');
                String newLast = String.valueOf(Integer.valueOf(parts[3]) + 1).leftPad(6, '0');
                String newTS = parts[0] + '.' + parts[1] + '.' + parts[2] + '.' + newLast;
                contactOptIn.CXTCNTO_TIMESTAMP__c = newTS;
                contactOptIn.Record_Updated__c = true;
                if (contactOptIn.Number_Of_Attempts__c == null) 
                    contactOptIn.Number_Of_Attempts__c = 1;
                else
                    contactOptIn.Number_Of_Attempts__c = contactOptIn.Number_Of_Attempts__c + 1;
            }
            update contactOptInList;
        } catch(Exception ex) {
            System.debug('AOPSContactCronJob: Exception while retrying failed records for contact opt in staging records.'+ ex.getMessage());
        }

        try {
            List<AOPS_Contact_Ship_Address__c> contactShipList = [SELECT id, record_updated__c, CXTCNTS_TIMESTAMP__c, Number_Of_Attempts__c FROM AOPS_Contact_Ship_Address__c 
            WHERE Sync_Status_Message__c = null and record_updated__c = false and (Number_Of_Attempts__c = null or  Number_Of_Attempts__c < :NO_OF_RETRIES) limit 10000];
            for (AOPS_Contact_Ship_Address__c contactShip : contactShipList) {
                List<String> parts = contactShip.CXTCNTS_TIMESTAMP__c.split('\\.');
                String newLast = String.valueOf(Integer.valueOf(parts[3]) + 1).leftPad(6, '0');
                String newTS = parts[0] + '.' + parts[1] + '.' + parts[2] + '.' + newLast;
                contactShip.CXTCNTS_TIMESTAMP__c = newTS;
                contactShip.Record_Updated__c = true;
                if (contactShip.Number_Of_Attempts__c == null) 
                    contactShip.Number_Of_Attempts__c = 1;
                else
                    contactShip.Number_Of_Attempts__c = contactShip.Number_Of_Attempts__c + 1;
            }
            update contactShipList;
        } catch(Exception ex) {
            System.debug('AOPSContactCronJob: Exception while retrying failed records for contact ship staging records.'+ ex.getMessage());
        }

        try {
            List<aops_account_master__c> accountMasterList = [SELECT id, record_updated__c, CXTF000P_TIMESTAMP__C, Number_Of_Attempts__c FROM aops_account_master__c 
            WHERE Sync_Status_Message__c != 'Success' and record_updated__c = false and (Number_Of_Attempts__c = null or  Number_Of_Attempts__c < :NO_OF_RETRIES) limit 10000];
            for (aops_account_master__c accountMaster : accountMasterList) {
                if (accountMaster.CXTF000P_TIMESTAMP__C != null) {
                    List<String> parts = accountMaster.CXTF000P_TIMESTAMP__C.split('\\.');
                    String newLast = String.valueOf(Integer.valueOf(parts[3]) + 1).leftPad(6, '0');
                    String newTS = parts[0] + '.' + parts[1] + '.' + parts[2] + '.' + newLast;
                    accountMaster.CXTF000P_TIMESTAMP__C = newTS;
                } else {
                	accountMaster.CXTF000P_TIMESTAMP__C = String.valueOf(DateTime.now());
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
            List<aops_account_preferences__C > accountPreferencesList = [SELECT id, record_updated__c, CXTF370P_TIMESTAMP__c, Number_Of_Attempts__c FROM aops_account_preferences__C  
            WHERE Sync_Status_Message__c != 'Success' and record_updated__c = false and (Number_Of_Attempts__c = null or  Number_Of_Attempts__c < :NO_OF_RETRIES) limit 10000];
            for (aops_account_preferences__C  accountPreference : accountPreferencesList) {
                if (accountPreference.CXTF370P_TIMESTAMP__c != null) {
                    List<String> parts = accountPreference.CXTF370P_TIMESTAMP__c.split('\\.');
                    String newLast = String.valueOf(Integer.valueOf(parts[3]) + 1).leftPad(6, '0');
                    String newTS = parts[0] + '.' + parts[1] + '.' + parts[2] + '.' + newLast;
                    accountPreference.CXTF370P_TIMESTAMP__c = newTS;
                } else {
                	accountPreference.CXTF370P_TIMESTAMP__c = String.valueOf(DateTime.now());
                }
                accountPreference.Record_Updated__c = true;
                if (accountPreference.Number_Of_Attempts__c == null) 
                    accountPreference.Number_Of_Attempts__c = 1;
                else
                    accountPreference.Number_Of_Attempts__c = accountPreference.Number_Of_Attempts__c + 1;
            }
			update accountPreferencesList;
        } catch(Exception ex) {
            System.debug('AOPSAccountCronJob: Exception while retrying failed records for account preferences staging records.'+ ex.getMessage());
        }

        try {
            List<AOPS_Account_Addendum_Community__c > accountAddendumComList = [SELECT id, record_updated__c, CXTC043F_TIMESTAMP__c, Number_Of_Attempts__c FROM AOPS_Account_Addendum_Community__c  
            WHERE Sync_Status_Message__c != 'Success' and record_updated__c = false and (Number_Of_Attempts__c = null or  Number_Of_Attempts__c < :NO_OF_RETRIES) limit 10000];
            for (AOPS_Account_Addendum_Community__c  accountCommunity : accountAddendumComList) {
                if (accountCommunity.CXTC043F_TIMESTAMP__c	!= null) {
                    List<String> parts = accountCommunity.CXTC043F_TIMESTAMP__c.split('\\.');
                    String newLast = String.valueOf(Integer.valueOf(parts[3]) + 1).leftPad(6, '0');
                    String newTS = parts[0] + '.' + parts[1] + '.' + parts[2] + '.' + newLast;
                    accountCommunity.CXTC043F_TIMESTAMP__c = newTS;
                } else {
                	accountCommunity.CXTC043F_TIMESTAMP__c	= String.valueOf(DateTime.now());
                }
                accountCommunity.Record_Updated__c = true;
                if (accountCommunity.Number_Of_Attempts__c == null) 
                    accountCommunity.Number_Of_Attempts__c = 1;
                else
                    accountCommunity.Number_Of_Attempts__c = accountCommunity.Number_Of_Attempts__c + 1;
            }
			update accountAddendumComList;
        } catch(Exception ex) {
            System.debug('AOPSAccountCronJob: Exception while retrying failed records for account addendum community staging records.'+ ex.getMessage());
        }

        try {
            List<AOPS_Account_Addendum_Legal_Other__c > accountAddendumLegalList = [SELECT id, record_updated__c, CXTC044F_TIMESTAMP__c, Number_Of_Attempts__c FROM AOPS_Account_Addendum_Legal_Other__c  
            WHERE Sync_Status_Message__c != 'Success' and record_updated__c = false and (Number_Of_Attempts__c = null or  Number_Of_Attempts__c < :NO_OF_RETRIES) limit 10000];
            for (AOPS_Account_Addendum_Legal_Other__c  accountLegal : accountAddendumLegalList) {
                if (accountLegal.CXTC044F_TIMESTAMP__c	!= null) {
                    List<String> parts = accountLegal.CXTC044F_TIMESTAMP__c.split('\\.');
                    String newLast = String.valueOf(Integer.valueOf(parts[3]) + 1).leftPad(6, '0');
                    String newTS = parts[0] + '.' + parts[1] + '.' + parts[2] + '.' + newLast;
                    accountLegal.CXTC044F_TIMESTAMP__c = newTS;
                } else {
                	accountLegal.CXTC044F_TIMESTAMP__c	= String.valueOf(DateTime.now());
                }
                accountLegal.Record_Updated__c = true;
                if (accountLegal.Number_Of_Attempts__c == null) 
                    accountLegal.Number_Of_Attempts__c = 1;
                else
                    accountLegal.Number_Of_Attempts__c = accountLegal.Number_Of_Attempts__c + 1;
            }
			update accountAddendumLegalList;
        } catch(Exception ex) {
            System.debug('AOPSAccountCronJob: Exception while retrying failed records for account addendum legal staging records.'+ ex.getMessage());
        }

        try {
            List<AOPS_Account_Child_Parent_Relationship__c > accountChildParentRelList = [SELECT id, record_updated__c, CXTF005P_TIMESTAMP__c, Number_Of_Attempts__c FROM AOPS_Account_Child_Parent_Relationship__c 
            WHERE Sync_Status_Message__c != 'Success' and record_updated__c = false and (Number_Of_Attempts__c = null or  Number_Of_Attempts__c < :NO_OF_RETRIES) limit 10000];
            for (AOPS_Account_Child_Parent_Relationship__c  accountChildParentRel : accountChildParentRelList) {
                if (accountChildParentRel.CXTF005P_TIMESTAMP__c	!= null) {
                    List<String> parts = accountChildParentRel.CXTF005P_TIMESTAMP__c.split('\\.');
                    String newLast = String.valueOf(Integer.valueOf(parts[3]) + 1).leftPad(6, '0');
                    String newTS = parts[0] + '.' + parts[1] + '.' + parts[2] + '.' + newLast;
                    accountChildParentRel.CXTF005P_TIMESTAMP__c = newTS;
                } else {
                	accountChildParentRel.CXTF005P_TIMESTAMP__c	= String.valueOf(DateTime.now());
                }
                accountChildParentRel.Record_Updated__c = true;
                if (accountChildParentRel.Number_Of_Attempts__c == null) 
                    accountChildParentRel.Number_Of_Attempts__c = 1;
                else
                    accountChildParentRel.Number_Of_Attempts__c = accountChildParentRel.Number_Of_Attempts__c + 1;
            }
			update accountChildParentRelList;
        } catch(Exception ex) {
            System.debug('AOPSAccountCronJob: Exception while retrying failed records for account child parent relationship staging records.'+ ex.getMessage());
        }

        try {
            List<AOPS_Address_Master__c > addressMasterList = [SELECT id, record_updated__c, CXTF001P_TIMESTAMP__c, Number_Of_Attempts__c FROM AOPS_Address_Master__c 
            WHERE Sync_Status_Message__c != 'Success' and record_updated__c = false and (Number_Of_Attempts__c = null or  Number_Of_Attempts__c < :NO_OF_RETRIES) limit 10000];
            for (AOPS_Address_Master__c  addressMaster : addressMasterList) {
                if (addressMaster.CXTF001P_TIMESTAMP__c	!= null) {
                    List<String> parts = addressMaster.CXTF001P_TIMESTAMP__c.split('\\.');
                    String newLast = String.valueOf(Integer.valueOf(parts[3]) + 1).leftPad(6, '0');
                    String newTS = parts[0] + '.' + parts[1] + '.' + parts[2] + '.' + newLast;
                    addressMaster.CXTF001P_TIMESTAMP__c = newTS;
                } else {
                	addressMaster.CXTF001P_TIMESTAMP__c	= String.valueOf(DateTime.now());
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

        try {
            List<AOPS_Address_BSD_A__c > addressBSDAList = [SELECT id, record_updated__c, CXTC009F_TIMESTAMP__c, Number_Of_Attempts__c FROM AOPS_Address_BSD_A__c  
            WHERE Sync_Status_Message__c != 'Success' and record_updated__c = false and (Number_Of_Attempts__c = null or  Number_Of_Attempts__c < :NO_OF_RETRIES) limit 10000];
            for (AOPS_Address_BSD_A__c  addressBSDA : addressBSDAList) {
                if (addressBSDA.CXTC009F_TIMESTAMP__c	!= null) {
                    List<String> parts = addressBSDA.CXTC009F_TIMESTAMP__c.split('\\.');
                    String newLast = String.valueOf(Integer.valueOf(parts[3]) + 1).leftPad(6, '0');
                    String newTS = parts[0] + '.' + parts[1] + '.' + parts[2] + '.' + newLast;
                    addressBSDA.CXTC009F_TIMESTAMP__c = newTS;
                } else {
                	addressBSDA.CXTC009F_TIMESTAMP__c	= String.valueOf(DateTime.now());
                }
                addressBSDA.Record_Updated__c = true;
                if (addressBSDA.Number_Of_Attempts__c == null) 
                    addressBSDA.Number_Of_Attempts__c = 1;
                else
                    addressBSDA.Number_Of_Attempts__c = addressBSDA.Number_Of_Attempts__c + 1;
            }
			update addressBSDAList;
        } catch(Exception ex) {
            System.debug('AOPSAccountCronJob: Exception while retrying failed records for address BSD addendum staging records.'+ ex.getMessage());
        }
    }

    private void retryFailedFinalStagingRecords() {
        if(contactJobAlreadyRunning() == false) {
            Map<String,string> contactNumbers = getContactNumbers();
            List<List<String>> contactNumberLists = splitContactNumbers(contactNumbers, BATCH_SIZE);

            for(List<String> contactNumberList : contactNumberLists){
                enqueueJob(new AOPSContactRetryProcessor(contactNumberList));
            }
        }

        if(accountJobAlreadyRunning() == false){
            Map<String, list< map<String,Integer>>>  parent_child_site = getAccountNumbers();
            List<List<String>> accountNumberLists = splitAccountNumbers(parent_child_site, BATCH_SIZE);

            for(List<String> accountNumberList : accountNumberLists){
                enqueueJob(new AOPSAccountRetryProcessor(accountNumberList));
            }
        }
    }

    private Map<String,string> getContactNumbers() {
        Map<String,string> contactNumbers = new Map<String,string> ();
        addContactFinalStagingNumbers(contactNumbers);
        addSiteContactsFinalStagingNumbers(contactNumbers);
        return contactNumbers;
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

    private Map<String, list< map<String,Integer>>>  getAccountNumbers() {
        Set<String> accountNumbers = new Set<String>();
        Set<String> accountNumberslpad = new Set<String>();
        Map<String, list< map<String,Integer>>>  parent_child_site = new Map<String,list< map<String,Integer>> > ();
        Map<String,list<string>> child_site = new map<String,list<string>>();
        Map<String,string> child_parent = new map<String,string>();
        addAccountFinalStagingNumbers(accountNumbers);
        addAccountSiteFinalStagingNumbers(accountNumbers, child_site);

        Integer iterCount = 0;
        for ( Account acc: [select id, parent.aops_cust_id__C, aops_cust_id__C from Account where aops_cust_id__C =:accountNumberslpad LIMIT 49990]) {
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

    private void addContactFinalStagingNumbers(Map<String,string> contactNumbers){
        List<contact_final_staging__c> cntFinalStagingList = [SELECT Id, AOPS_Contact_Number__c, AOPS_Account_Number__c, Sync_Failed__c, Number_Of_Attempts__c, Sync_Status_Message__c, Contact_Sync_Message__c 
        FROM contact_final_staging__c WHERE Sync_Failed__c = true and (Number_Of_Attempts__c = null or Number_Of_Attempts__c <= :NO_OF_RETRIES) limit :BATCH_SIZE];

        for(contact_final_staging__c stagingRec : cntFinalStagingList)
            contactNumbers.put(stagingRec.AOPS_Contact_Number__c, stagingRec.AOPS_Account_Number__c);
    }

    private void addSiteContactsFinalStagingNumbers(Map<String,string> contactNumbers){
        List<sitecontacts_final_staging__c> siteContactsStagingList = [SELECT Id, AOPS_Contact_Number__c, AOPS_Account_Number__c, Sync_Failed__c, Number_Of_Attempts__c, Sync_Message__c 
        FROM sitecontacts_final_staging__c WHERE Sync_Failed__c = true and (Number_Of_Attempts__c = null or Number_Of_Attempts__c <= :NO_OF_RETRIES) limit :BATCH_SIZE];

        for(sitecontacts_final_staging__c stagingRec : siteContactsStagingList)
            contactNumbers.put(stagingRec.AOPS_Contact_Number__c, stagingRec.AOPS_Account_Number__c);
    }

    private void addAccountFinalStagingNumbers(Set<String> accountNumbers){
        List<account_final_Staging__C> acctFinalStagingList = [SELECT Id, AOPS_Cust_Id__c, Sync_Failed__c, Number_Of_Attempts__c, Sync_Failed_Reason__C 
        FROM account_final_Staging__C WHERE Sync_Failed__c = true and (Number_Of_Attempts__c = null or Number_Of_Attempts__c <= :NO_OF_RETRIES) limit :BATCH_SIZE];

        for(account_final_Staging__C stagingRec : acctFinalStagingList)
            accountNumbers.add(stagingRec.AOPS_Cust_Id__c);
    }

    private void addAccountSiteFinalStagingNumbers(Set<String> accountNumbers, Map<String,list<string>> child_site){
        List<account_site_final_Staging__C> acctSiteFinalStagingList = [SELECT Id, AOPS_Cust_Id__c, FCU001P_ADDRESS_SEQ__c, Sync_Failed__c, Number_Of_Attempts__c, Sync_Failed_Reason__C 
        FROM account_site_final_Staging__C WHERE Sync_Failed__c = true and (Number_Of_Attempts__c = null or Number_Of_Attempts__c <= :NO_OF_RETRIES) limit :BATCH_SIZE];

        for(account_site_final_Staging__C stagingRec : acctSiteFinalStagingList){
            accountNumbers.add(stagingRec.AOPS_Cust_Id__c);

            if(child_site.containsKey(stagingRec.AOPS_Cust_Id__c)) {
                child_site.get(stagingRec.AOPS_Cust_Id__c).add(stagingRec.FCU001P_ADDRESS_SEQ__c);
            } else {
                child_site.put(stagingRec.AOPS_Cust_Id__c, new List<String>{stagingRec.FCU001P_ADDRESS_SEQ__c});
            } 
        }
    }

    private void scheduleNextRun(Integer delay_job) {
        Datetime nextRunTime = System.now().addSeconds(delay_job);
        String chronExpression = nextRunTime.second() + ' ' + nextRunTime.minute() + ' ' +
            nextRunTime.hour() + ' ' + nextRunTime.day() + ' ' + nextRunTime.month() + ' ? ' + nextRunTime.year();
        
        if(Test.isRunningTest() == false)
            System.schedule('AOPS to SFDC Retry Job' + nextRunTime, chronExpression, new AOPStoSFDCRetrySync());
    } 

    private Boolean contactJobAlreadyRunning() {
        List<AsyncApexJob> jobs = [SELECT Id FROM AsyncApexJob
            WHERE ApexClass.Name = 'AOPSContactRetryProcessor' AND Status IN ('Holding', 'Queued', 'Preparing', 'Processing')];
        return jobs.size() > 0;
    }

    private Boolean accountJobAlreadyRunning() {
        List<AsyncApexJob> jobs = [SELECT Id FROM AsyncApexJob
            WHERE ApexClass.Name = 'AOPSAccountRetryProcessor' AND Status IN ('Holding', 'Queued', 'Preparing', 'Processing')];
        return jobs.size() > 0;
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
}
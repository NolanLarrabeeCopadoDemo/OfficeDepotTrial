public class AOPSSyncToAccountProcessor {

    List<Account_Final_Staging__c> stagingRecordsToSync; // The staging records that have changed to be synced.
    Map<String, String> syncFailedMessageMap = new Map<String,String>();
    List<String> existingSFDCKey1List = new List<String>();

    public AOPSSyncToAccountProcessor(List<Account_Final_Staging__c> finalStagingRecords) {
        stagingRecordsToSync = finalStagingRecords;
    }
    
    public static Boolean isFailedRecord(Account_Final_Staging__c finalStagingRec) {
        return finalStagingRec.Sync_Failed__c;
    }
    
    /**
     * Syncs the staging records from the instance variable stagingRecordsToSync to corresponding
     * Account records.
     * Additionally, the staging records are marked as having been synced.
     */
    public void sync() {

        try {
            boolean isAccountMasterFlagChanged = true;
            //1. Handle staging records with master flag changed.
            List<Account_Final_Staging__c> stagingRecList = getStagingRecList(stagingRecordsToSync, isAccountMasterFlagChanged);
            //populateAccountType(stagingRecList);

            // Validate if Staging Record SFDC IDs from AOPS exits in SFDC else set to null.  
            manageSFDCIds(stagingRecList);
            
            // 1.1 Process accounts coming from AOPS with SFDC ID - Scenario: Account setup sync.
            List<Account> accountList = getAccountList(stagingRecList, true);
            Database.UpsertResult[] upsertAcctList = Database.upsert(accountList, Account.Id, false);
			List<Account> acctSuccessList = getSuccessfulAccounts(upsertAcctList, accountList);
            List<Account> acctFailedList = getFailedAccounts(upsertAcctList, accountList);
            markStagingRecordsWithSyncStatus(acctSuccessList, acctFailedList, stagingRecList);
            retryFailedAssociatedContacts(acctSuccessList);

            // 1.2. Process accounts coming from AOPS without SFDC ID but with AOPS ID
            accountList = getAccountList(stagingRecList, false);
            upsertAcctList = Database.upsert(accountList, Account.AOPS_Cust_Id__c, false);
			acctSuccessList = getSuccessfulAccounts(upsertAcctList, accountList);
            acctFailedList = getFailedAccounts(upsertAcctList, accountList);
            markStagingRecordsWithSyncStatus(acctSuccessList, acctFailedList, stagingRecList);
            
            //2. Handle staging records where master flag is not changed but the secondary flags are changed.
            isAccountMasterFlagChanged = false;
            stagingRecList = getStagingRecList(stagingRecordsToSync, isAccountMasterFlagChanged);
            accountList = getExistingAccountList(stagingRecList);
            upsertAcctList = Database.upsert(accountList, Account.AOPS_Cust_Id__c, false);
			acctSuccessList = getSuccessfulAccounts(upsertAcctList, accountList);
            acctFailedList = getFailedAccounts(upsertAcctList, accountList);
            markStagingRecordsWithSyncStatus(acctSuccessList, acctFailedList, stagingRecList);
        } catch(Exception e) {
            handleSyncFailure(e);
        }
    }
    
    private List<Account> getExistingAccountList(List<Account_Final_Staging__c> stagingRecList) {
        
        Map<String, Account_Final_Staging__c> stagingRecMap = new Map<String, Account_Final_Staging__c>();
        for (Account_Final_Staging__c stagingRec : stagingRecList) {
            stagingRecMap.put(stagingRec.AOPS_Cust_Id__c, stagingRec);
        }               
        
        List<Account> acctList = [SELECT id, AOPS_Cust_Id__c, Community_Postscript__c, Small_Order_Dlv_Fees__c, Freight_forwarder_account__c, DEPT_REQUIRED_CODE__c, 
                                  	LOCATION_REQ_CODE_7__c, PO_REQUIRED_CODE__c, RELEASE_REQUIRED_CODE__c, Future_Use_Reserved__c,
									Mobile_Opt_In__c, Phone_Opt_In__c, Mail_Opt_In__c, Email_Opt_In__c, Max_Order_Limit__c
                                  FROM account 
                                  WHERE aops_cust_id__c in :stagingRecMap.keySet()];
    	
        Account_Final_Staging__c stageRec;
        for (Account acct : acctList) {
            stageRec = stagingRecMap.get(acct.AOPS_Cust_Id__c);
            acct = getAccountFromStagingRec(stageRec, acct);
        }
        
        return acctList;
    }
    
    private List<Account> getSuccessfulAccounts(Database.UpsertResult[] upsertAcctList, List<Account> accountList) {
        
        List<Account> successAcctList = new List<Account>();
        for(Integer i=0; i < upsertAcctList.size(); i++) {
            if(upsertAcctList[i].isSuccess()) {
                successAcctList.add(accountList[i]);
            }            
        }
        return successAcctList;
    }
    
    private List<Account> getFailedAccounts(Database.UpsertResult[] upsertAcctList, List<Account> accountList) {
        
        List<Account> failedAcctList = new List<Account>();
        
        
        for(Integer i=0; i < upsertAcctList.size(); i++) {
            if(!upsertAcctList[i].isSuccess()) {
                failedAcctList.add(accountList[i]);
            }
            String message = '';
            if(!upsertAcctList[i].isSuccess()) {
                Database.Error[] errors = upsertAcctList[i].getErrors();
                for (Database.Error err : errors) {
                    message = message + ':' + err.statuscode + ':' + err.message;
                }
                syncFailedMessageMap.put(accountList[i].AOPS_Cust_ID__c, message);
            }
        }
        return failedAcctList;
    }
    
    private List<Account_Final_Staging__c> getStagingRecList(List<Account_Final_Staging__c> stagingRecordsToSync, boolean isAccountMasterFlagChanged) {
        
		List<Account_Final_Staging__c> stageRecList = new List<Account_Final_Staging__c>();
        
        for (Account_Final_Staging__c accountStaging : stagingRecordsToSync) {
            if (isAccountMasterFlagChanged) {
                if (accountStaging.Is_Account_Master_Changed__c) {
                	stageRecList.add(accountStaging);
            	}                
            } else {
                if ((!accountStaging.Is_Account_Master_Changed__c) && (
                            accountStaging.Is_Account_Master_Changed__c ||
                            accountStaging.Is_Account_Addendum_Community_Changed__c ||
                            accountStaging.Is_Account_BSD_Addendum_Changed__c ||
                            accountStaging.Is_Account_OptIn_Changed__c ||
                            accountStaging.Is_Parent_Account_Changed__c ||
                            accountStaging.Is_Account_Addendum_Legal_Changed__c)) {
                	stageRecList.add(accountStaging);
            	}
            }
        }

        return stageRecList;
    }
    
    private List<Account> getAccountList(List<Account_Final_Staging__c> stagingRecordsToSync, boolean withSfdcId) {
        
        List<Account> accountList = new List<Account>();
        Account account;
        for (Account_Final_Staging__c stagingRec : stagingRecordsToSync) {
            // SFDC Key 1 should exist in Account Object.
            if (withSfdcId && stagingRec.CXTF005P_SFDC_KEY1__c != null && existingSFDCKey1List.contains(stagingRec.CXTF005P_SFDC_KEY1__c)) {
                try {
                    account = getAccountFromStagingRec(stagingRec, new Account());
                    accountList.add(account);
                } catch(Exception e) {
                    System.debug('There is an exception in getAccountFromStagingRec() method with sfdcId condition. ');
                    //e.getStackTraceString();
                }
            } 
            // SFDC Key 1 was provided By AOPS but it does not exist in Account Object.
            else if (!withSfdcId && (stagingRec.CXTF005P_SFDC_KEY1__c == null || !existingSFDCKey1List.contains(stagingRec.CXTF005P_SFDC_KEY1__c))) {
                try {
                    account = getAccountFromStagingRec(stagingRec, new Account());
                    accountList.add(account);
                } catch(Exception e) {
                    System.debug('There is an exception in getAccountFromStagingRec() method without sfdcId condition. ');
                    //e.getStackTraceString();
                }
            }
        }
        return accountList;
    }
        
    private Account getAccountFromStagingRec(Account_Final_Staging__c stagingRec, Account custAcct) {
            
        custAcct.AOPS_Cust_Id__c = stagingRec.AOPS_Cust_Id__c;
        if(existingSFDCKey1List.contains(stagingRec.CXTF005P_SFDC_KEY1__c)){
            custAcct.Id = stagingRec.CXTF005P_SFDC_KEY1__c;
        }
        if(stagingRec.AOPS_Cust_Id__c != null)
        {            
            custAcct.Account_Setup_Request_Status__c = 'Express Setup Complete';
        }
        
        if (stagingRec.Is_Account_Master_Changed__c) {            
            custAcct.Hierarchy__c = stagingRec.Hierarchy__c;
            if (stagingRec.Hierarchy__c == 'P') {
            	custAcct.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Parent').getRecordTypeId();
            } else {
            	custAcct.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
                if (String.isEmpty(custAcct.Hierarchy__c)) {
                    custAcct.Hierarchy__c = 'C';
                }                
            }
            
            custAcct.CONTRACT_RETAIL_CUST_CODE__c = stagingRec.CONTRACT_RETAIL_CUST_CODE__c;
            custAcct.Name = stagingRec.Name;
            custAcct.Address1__c = stagingRec.Address1__c;
            custAcct.Address2__c = stagingRec.Address2__c;
            custAcct.City__c = stagingRec.City__c;
            custAcct.State__c = stagingRec.State__c;
            custAcct.Zip__c = stagingRec.Zip__c;
            custAcct.Country__c = stagingRec.Country__c;
            custAcct.Tax_Exempt__c = stagingRec.Tax_Exempt__c;            
            custAcct.Status__c = stagingRec.Status__c;
            custAcct.Loyalty_Type__c = stagingRec.Loyalty_Type__c;
            custAcct.Segment__c = stagingRec.Segment__c;
            custAcct.Deliver_Charge__c = stagingRec.Deliver_Charge__c;
            //custAcct.Sector__c = stagingRec.Sector__c;
            //custAcct.ownerId = Label.Dataloader_Id_Trigger;
            custAcct.Legacy_CreatedDate__c = stagingRec.Legacy_Created_Date__c;
            custAcct.Freight_forwarder_account__c = stagingRec.Freight_forwarder_account__c;
        }
        if (stagingRec.Is_Account_Addendum_Community_Changed__c) {
            custAcct.Community_Postscript__c = stagingRec.Community_Postscript__c;
        }
        if (stagingRec.Is_Account_BSD_Addendum_Changed__c) {
            custAcct.Forms_Customer_Flag__c = stagingRec.Forms_Customer_Flag__c;
            custAcct.Max_Order_Limit__c = stagingRec.Max_Order_Limit__c;
            custAcct.Small_Order_Dlv_Fees__c = stagingRec.Small_Order_Dlv_Fees__c;
            custAcct.DEPT_REQUIRED_CODE__c = stagingRec.Dept_Req_Code__c;
            custAcct.LOCATION_REQ_CODE_7__c = stagingRec.Location_Req_Code__c;
            custAcct.PO_REQUIRED_CODE__c = stagingRec.PO_Req_Code__c;
            custAcct.RELEASE_REQUIRED_CODE__c = stagingRec.Release_Req_Code__c;
            custAcct.Future_Use_Reserved__c = stagingRec.Future_Use_Reserved__c;
        }
        if (stagingRec.Is_Account_OptIn_Changed__c) {
            markOptDates(custAcct, stagingRec);
            custAcct.Mobile_Opt_In__c = stagingRec.Mobile_Opt_In__c;
            custAcct.Phone_Opt_In__c = stagingRec.Phone_Opt_In__c;
            custAcct.Mail_Opt_In__c = stagingRec.Mail_Opt_In__c;
            custAcct.Email_Opt_In__c = stagingRec.Email_Opt_In__c;
        }
        if (stagingRec.Is_Parent_Account_Changed__c && stagingRec.Parent_ID__c != null) {
            
            if (stagingRec.Parent_Account_Changed_Action__c == 'D') {
                custAcct.ParentId = null;
                custAcct.Related_Parent_Account__c = null;
            } else {
                Id sfdcId = getAccountSFDCId(stagingRec.Parent_ID__c);
                if (sfdcId != null) {
                    custAcct.ParentId = sfdcId;
                    custAcct.Related_Parent_Account__c = stagingRec.Parent_ID__c;
                } else {
                    System.debug('AOPSSyncToAccountProcessor - SFDC ID not found for parent account id: '+ stagingRec.Parent_ID__c);
                    syncFailedMessageMap.put(stagingRec.AOPS_Cust_ID__c, 'AOPSSyncToAccountProcessor - SFDC ID not found for parent account id: '+ stagingRec.Parent_ID__c);
                }                    
            }
        }
        if (stagingRec.Is_Account_Addendum_Legal_Changed__c) {
            custAcct.Customer_Restriction__c = stagingRec.Customer_Restriction__c;
            custAcct.PPP_Flag__c = stagingRec.PPP_Flag__c;
            custAcct.Legal_Flag__c = stagingRec.Legal_Flag__c;
            custAcct.Hosted_Catalog_Flag__c = stagingRec.Hosted_Catalog_Flag__c;
            custAcct.SPC_Allowed__c = stagingRec.SPC_Allowed__c;
        }
        
        return custAcct;
    }
    
    private Id getAccountSFDCId(String aopsParentId) {
        
        List<Account> acctList = [select id from account where aops_cust_id__c = :aopsParentId limit 1];
        if (acctList == null || acctList.size() == 0) {
            return null;
        }
        return acctList[0].Id;
    }

    private void markOptDates(Account acct, Account_Final_Staging__c stagingRec) {
        if(stagingRec.Mobile_Opt_In__c == null)
            acct.Mobile_Opt_Date__c = null;
        else if(stagingRec.Mobile_Opt_In__c != acct.Mobile_Opt_In__c)
            acct.Mobile_Opt_Date__c = stagingRec.OptIn_Change_Timestamp__c;
        
        if(stagingRec.Phone_Opt_In__c == null)
            acct.Phone_Opt_Date__c = null;
        else if(stagingRec.Phone_Opt_In__c != acct.Phone_Opt_In__c)
            acct.Phone_Opt_Date__c = stagingRec.OptIn_Change_Timestamp__c;

        if(stagingRec.Mail_Opt_In__c == null)
            acct.Mail_Opt_Date__c = null;
        else if(stagingRec.Mail_Opt_In__c != acct.Mail_Opt_In__c)
            acct.Mail_Opt_Date__c = stagingRec.OptIn_Change_Timestamp__c;

        if(stagingRec.Email_Opt_In__c == null)
            acct.Email_Opt_Date__c = null;
        else if(stagingRec.Email_Opt_In__c != acct.Email_Opt_In__c)
            acct.Email_Opt_Date__c = stagingRec.OptIn_Change_Timestamp__c;
    }
    
    /**
     * Sets the "Is Changed" fields on the staging records to false, effectively
     * marking them as in sync with their corresponding Contacts.
     */
    private void markStagingRecordsWithSyncStatus(List<Account> successList, List<Account> failedList, List<Account_Final_Staging__c> syncedStagingRecList) {
        
        Map<String, Account_Final_Staging__c> stagingRecMap = new Map<String, Account_Final_Staging__c>();
        
        for (Account_Final_Staging__c afs : syncedStagingRecList) {
            stagingRecMap.put(afs.AOPS_Cust_Id__c, afs);
        }
        
        List<Account_Final_Staging__c> clonedRecords = new List<Account_Final_Staging__c>();        
        Account_Final_Staging__c stagingRec;
        
        for(Account acct : successList) {
            stagingRec = stagingRecMap.get(acct.AOPS_Cust_Id__c);
            Account_Final_Staging__c clonedRecord = new Account_Final_Staging__c(Id=stagingRec.Id);
            clonedRecord.Is_Account_Master_Changed__c = false;
            clonedRecord.Is_Account_Addendum_Community_Changed__c = false;
            clonedRecord.Is_Account_BSD_Addendum_Changed__c = false;
            clonedRecord.Is_Account_OptIn_Changed__c = false;
            clonedRecord.Is_Parent_Account_Changed__c = false;
            clonedRecord.Is_Account_Addendum_Legal_Changed__c = false;
            clonedRecord.Sync_Failed__c = false;
            clonedRecord.Sync_Failed_Reason__c = '';
            clonedRecord.Number_Of_Attempts__c = 0;
            clonedRecords.add(clonedRecord);
        }
        
        for(Account acct : failedList) {
            stagingRec = stagingRecMap.get(acct.AOPS_Cust_Id__c);
            Account_Final_Staging__c clonedRecord = new Account_Final_Staging__c(Id=stagingRec.Id);
            clonedRecord.Sync_Failed__c = true;
            System.debug('Updating failed message '+ syncFailedMessageMap.get(acct.AOPS_Cust_Id__c));
            clonedRecord.Sync_Failed_Reason__c = syncFailedMessageMap.get(acct.AOPS_Cust_Id__c);
            clonedRecords.add(clonedRecord);
        }
        
        update clonedRecords;
    }

    private void retryFailedAssociatedContacts(List<Account> accts) {
        Set<String> accountNumbers = new Set<String>();
        for(Account acct : accts)
            accountNumbers.add(acct.AOPS_Cust_ID__c);

        List<Contact_Final_Staging__c> stagingRecs = [SELECT Id FROM Contact_Final_Staging__c
                                                        WHERE AOPS_Account_Number__c IN: accountNumbers AND
                                                        Sync_Failed__c = true];
        for(Contact_Final_Staging__c stagingRec : stagingRecs)
            stagingRec.Sync_Failed__c = false;
        if(stagingRecs.size() > 0)
            update stagingRecs;
    }
    
    private void handleSyncFailure(Exception e) {
        System.debug('Exception in AOPSSyncToAccountProcessor = ' + e.getMessage());
        System.debug(e.getStackTraceString());        
    }

    private void manageSFDCIds(List<Account_Final_Staging__c> stagingRecList){
        List<String> accountIDToSync = new List<String>();
        
        for(Account_Final_Staging__c stagingRec: stagingRecList){
            if(stagingRec.CXTF005P_SFDC_KEY1__c != null)
                accountIDToSync.add(stagingRec.CXTF005P_SFDC_KEY1__c);
        }

        if(accountIDToSync != null && accountIDToSync.size() > 0){
            List<Account> accountIDList = [SELECT id FROM account
                                           WHERE id IN :accountIDToSync];

            for(Account acct : accountIDList){
                existingSFDCKey1List.add(acct.id);
            } 
        }
    }
}
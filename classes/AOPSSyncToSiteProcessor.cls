public class AOPSSyncToSiteProcessor {

    List<Account_Site_Final_Staging__c> stagingRecordsToSync; // The staging records that have changed to be synced.
    Map<String, String> syncFailedMessageMap;
    Map<String, String> accountOwnerIdByAopsIdMap;

    public AOPSSyncToSiteProcessor(List<Account_Site_Final_Staging__c> finalStagingRecords) {
        stagingRecordsToSync = finalStagingRecords;
    }
    
    public static Boolean isFailedRecord(Account_Site_Final_Staging__c finalStagingRec) {
        return finalStagingRec.Sync_Failed__c;
    }
    
    /**
     * Syncs the staging records from the instance variable stagingRecordsToSync to corresponding
     * Site records.
     * Additionally, the staging records are marked as having been synced.
     */
    public void sync() {
     
		try {
            boolean isAddressMasterFlagChanged = true;
            boolean isDelete = false;
            Database.UpsertResult[] upsertSiteResultList = null;
            List<Account> siteSuccessList = null;
            List<Account> siteFailedList = null;

            getAccountOwnerList(stagingRecordsToSync);
            // 1. Handle staging records with master flag changed.
            List<Account_Site_Final_Staging__c> stagingRecList = getStagingRecList(stagingRecordsToSync, isAddressMasterFlagChanged, isDelete);
            System.debug('Total number of staging recs = '+ stagingRecList.size());
            // 1.1 Handle sites with SFDC id during account setup
            List<Account> accountSiteList = getStagingRecListWithSfdcId(stagingRecList);
            System.debug('Site list in getStagingRecListWithSfdcId=============================================='+ accountSiteList.size());
            System.debug(accountSiteList);
            if (accountSiteList.size() > 0) {
                upsertSiteResultList = Database.upsert(accountSiteList, Account.Id, false);
                siteSuccessList = getSuccessfulUpsertedSites(upsertSiteResultList, accountSiteList);
                siteFailedList = getFailedUpsertedSites(upsertSiteResultList, accountSiteList);
                markStagingRecordsWithSyncStatus(siteSuccessList, siteFailedList, stagingRecList);
                updateAccountsWithPrimarySiteAddress(siteSuccessList, stagingRecList);
            }
            
            System.debug('Before calling without sfdc id, size ==='+ stagingRecList.size());
            // 1.2 Handle sites without SFDC id
            accountSiteList = getStagingRecListWithoutSfdcId(stagingRecList);
            System.debug('Site list in getStagingRecListWithoutSfdcId=============================================='+ accountSiteList.size());
            if (accountSiteList.size() > 0) {
                upsertSiteResultList = Database.upsert(accountSiteList, Account.AOPS_Seq_ID__c, false);
                siteSuccessList = getSuccessfulUpsertedSites(upsertSiteResultList, accountSiteList);
                siteFailedList = getFailedUpsertedSites(upsertSiteResultList, accountSiteList);
                markStagingRecordsWithSyncStatus(siteSuccessList, siteFailedList, stagingRecList);
                updateAccountsWithPrimarySiteAddress(siteSuccessList, stagingRecList);
            }
            // Handle staging records where master flag is not changed but the secondary flags are changed.
            isAddressMasterFlagChanged = false;
            stagingRecList = getStagingRecList(stagingRecordsToSync, isAddressMasterFlagChanged, isDelete);
            accountSiteList = getExistingSiteList(stagingRecList);
            if (accountSiteList.size() > 0) {
                upsertSiteResultList = Database.upsert(accountSiteList, Account.AOPS_Seq_ID__c, false);
                siteSuccessList = getSuccessfulUpsertedSites(upsertSiteResultList, accountSiteList);
                siteFailedList = getFailedUpsertedSites(upsertSiteResultList, accountSiteList);
                markStagingRecordsWithSyncStatus(siteSuccessList, siteFailedList, stagingRecList);
            }
            // Handle staging records with a delete action.
            isDelete = true;
            stagingRecList = getStagingRecList(stagingRecordsToSync, isAddressMasterFlagChanged, isDelete);
            accountSiteList = getExistingSiteList(stagingRecList);
            if (accountSiteList.size() > 0) {
                Database.DeleteResult[] deleteSiteResultList = Database.delete(accountSiteList, false);
                siteSuccessList = getSuccessfulUpsertedSites(upsertSiteResultList, accountSiteList);
                siteFailedList = getFailedUpsertedSites(upsertSiteResultList, accountSiteList);
                markStagingRecordsWithSyncStatus(siteSuccessList, siteFailedList, stagingRecList);
            }
        } catch(Exception e) {
            handleSyncFailure(e);
        }        
        
    }

    private void getAccountOwnerList(List<Account_Site_Final_Staging__c> stagingRecordsToSync) {

        accountOwnerIdByAopsIdMap = new Map<String, String>();
        List<String> aopsCustIdList = new List<String>();
        for (Account_Site_Final_Staging__c finalStageRec : stagingRecordsToSync) {
            aopsCustIdList.add(finalStageRec.AOPS_Cust_Id__c);
        }

        if (aopsCustIdList.size() > 0) {
            List<Account>  accountList = [select AOPS_Cust_Id__c, ownerid from account where AOPS_Cust_Id__c IN :aopsCustIdList and type='Customer'];
            for (Account acct : accountList) {
                accountOwnerIdByAopsIdMap.put(acct.AOPS_Cust_Id__c, acct.ownerid);
            }
        }
    }
    
    private void updateAccountsWithPrimarySiteAddress(List<Account> siteList, List<Account_Site_Final_Staging__c> stagingRecList) {
        
        Map<String, Account_Site_Final_Staging__c> primarySiteStagingRecMap = new Map<String, Account_Site_Final_Staging__c>();
        List<String> aopsCustIdList = new List<String>();
        
        for (Account_Site_Final_Staging__c stageRec : stagingRecList) {
            if (stageRec.AOPS_Seq_ID__c.contains('-00001')) {
                primarySiteStagingRecMap.put(stageRec.AOPS_Cust_Id__c, stageRec);
                aopsCustIdList.add(stageRec.aops_cust_id__c);
            }
        }
                
        List<Account> acctList = [SELECT id, aops_cust_id__c FROM account where aops_cust_id__c in :primarySiteStagingRecMap.keySet()];
        
        Account_Site_Final_Staging__c stageRec;
        for (Account acct : acctList) {
            stageRec = primarySiteStagingRecMap.get(acct.AOPS_Cust_Id__c);
            copyAddress(stageRec, acct);
        }
        
    }
    
    private void copyAddress(Account_Site_Final_Staging__c source, Account target) {
        target.Address1__c = source.Address1__c;
        target.Address2__c = source.Address2__c;
        target.City__c = source.City__c;
        target.State__c = source.State__c;
        target.Zip__c = source.Zip__c;
        target.Country__c = source.Country__c;        
    }
    
    private Account getSiteFromStagingRec(Account_Site_Final_Staging__c stagingRec, Account custSite) {
            
        //custSite.AOPS_Cust_Id__c = stagingRec.AOPS_Cust_Id__c;
        custSite.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();
        custSite.AOPS_Seq_Id__c = stagingRec.AOPS_Seq_ID__c;
        custSite.Address_Key__c = stagingRec.Address_Key__c;
        
        if (stagingRec.Is_Address_Master_Changed__c) {            
            custSite.Name = stagingRec.Account_Name__c;
            custSite.Address1__c = stagingRec.Address1__c;
            custSite.Address2__c = stagingRec.Address2__c;
            custSite.City__c = stagingRec.City__c;
            custSite.State__c = stagingRec.State__c;
            custSite.Zip__c = stagingRec.Zip__c;
            custSite.Country__c = stagingRec.Country__c;
            custSite.Date_Status_Modified__c = stagingRec.Date_Status_Modified__c;
            custSite.ShipTo_Status__c = stagingRec.ShipTo_Status__c;
            custSite.Bill_To__c = stagingRec.Bill_To__c;
            custSite.Mail_To__c = stagingRec.Mail_To__c;
            custSite.County__c = stagingRec.County__c;           
            String accountOwnerId = (String) accountOwnerIdByAopsIdMap.get(stagingRec.aops_cust_id__c);
            if (accountOwnerId != null)
                custSite.ownerId = accountOwnerId;
            else
                custSite.ownerId = Label.Dataloader_Id_Trigger;
            System.debug('Account owner id ========='+ custSite.ownerId);
        }
        if (stagingRec.Is_Address_Addendum_Changed__c) {
            
        }        
        
        return custSite;
    }
    
    private List<Account_Site_Final_Staging__c> getStagingRecList(List<Account_Site_Final_Staging__c> stagingRecordsToSync, boolean isAddressMasterFlagChanged, boolean isDelete) {
        
		List<Account_Site_Final_Staging__c> stageRecList = new List<Account_Site_Final_Staging__c>();
        
        for (Account_Site_Final_Staging__c siteStaging : stagingRecordsToSync) {
            if (isDelete) {
                if(siteStaging.Action__c == 'D') {
                    stageRecList.add(siteStaging);
                }
            } else if (isAddressMasterFlagChanged) {
                if (siteStaging.Is_Address_Master_Changed__c) {
                	stageRecList.add(siteStaging);
            	}                
            } else {
                if (!siteStaging.Is_Address_Master_Changed__c && siteStaging.Is_Address_Addendum_Changed__c) {
                	stageRecList.add(siteStaging);
            	}
            }
        }
    	return stageRecList;
	}
    
    private List<Account> getStagingRecListWithoutSfdcId(List<Account_Site_Final_Staging__c> stagingRecList) {
        
        List<Account> accountList = new List<Account>();
        Account account;
        
        List<Account_Site_Final_Staging__c> stagingRecListWithoutSfdcId = new List<Account_Site_Final_Staging__c>();
        List<String> aopsCustIdList = new List<String>();
        
        for (Account_Site_Final_Staging__c stagingRec : stagingRecList) {
            if (!doesSfdcIdExist(stagingRec)) {
            	//stagingRecMap.put(stagingRec.AOPS_Cust_Id__c, stagingRec);    
            	aopsCustIdList.add(stagingRec.AOPS_Cust_Id__c);
                stagingRecListWithoutSfdcId.add(stagingRec);
            }
        }
        
        // Accounts have to exist to sync sites.
        List<Account> existingAcctList = [select Id, AOPS_Cust_Id__c from account where AOPS_Cust_Id__c in :aopsCustIdList];
        Map<String,String> existAcctIdMap = new Map<String,String>();
        for (Account acct : existingAcctList) {
            existAcctIdMap.put(acct.AOPS_Cust_Id__c, acct.Id);
        }
        
        List<Account_Site_Final_Staging__c> stagingRecListWithAccounts = new List<Account_Site_Final_Staging__c>();
        for (Account_Site_Final_Staging__c stagingRec : stagingRecListWithoutSfdcId) {
            if (existAcctIdMap.get(stagingRec.AOPS_Cust_Id__c) != null) {
            	stagingRecListWithAccounts.add(stagingRec);
            }
        }
                
        for (Account_Site_Final_Staging__c stagingRec : stagingRecListWithAccounts) {
            account = getSiteFromStagingRec(stagingRec, new Account());
            account.Related_Account__c = existAcctIdMap.get(stagingRec.AOPS_Cust_Id__c);
            accountList.add(account);
        }
        return accountList;
    }
    
    private boolean doesSfdcIdExist(Account_Site_Final_Staging__c stagingRec) {
    
        boolean exist = false;
        
        if (stagingRec != null) {
            if(String.isNotEmpty(stagingRec.CXTF001P_SFDC_KEY1__c) && String.isNotEmpty(stagingRec.CXTF001P_SFDC_KEY2__c)) {
                exist = true;
            }
        }
        return exist;
    }
        
    private List<Account> getStagingRecListWithSfdcId(List<Account_Site_Final_Staging__c> stagingRecList) {
        
        List<Account> accountList = new List<Account>();
        Account account;
        for (Account_Site_Final_Staging__c stagingRec : stagingRecList) {
            if(doesSfdcIdExist(stagingRec)) {
                account = getSiteFromStagingRec(stagingRec, new Account());
                account.Related_Account__c = stagingRec.CXTF001P_SFDC_KEY1__c;
                account.Id = stagingRec.CXTF001P_SFDC_KEY2__c;
                accountList.add(account);
            }
        }
        return accountList;
    }
    
    private List<Account> getExistingSiteList(List<Account_Site_Final_Staging__c> stagingRecList) {
        
        List<Account> siteList = new List<Account>();
        
        Map<String, Account_Site_Final_Staging__c> stagingRecMap = new Map<String, Account_Site_Final_Staging__c>();
        for (Account_Site_Final_Staging__c stagingRec : stagingRecList) {
            stagingRecMap.put(stagingRec.AOPS_Seq_Id__c, stagingRec);
        }               
        
        List<Account> existingSiteList = [SELECT id, AOPS_Cust_Id__c, Community_Postscript__c, Freight_Charge__c, DEPT_REQUIRED_CODE__c, 
                                  	LOCATION_REQ_CODE_7__c, PO_REQUIRED_CODE__c, RELEASE_REQUIRED_CODE__c, Future_Use_Reserved__c,
									Mobile_Opt_In__c, Phone_Opt_In__c, Mail_Opt_In__c, Email_Opt_In__c, Max_Order_Limit__c, AOPS_Seq_Id__c
                                  FROM account 
                                  WHERE aops_seq_id__c in :stagingRecMap.keySet()];
    	
        Account_Site_Final_Staging__c stageRec;
        for (Account acct : existingSiteList) {
            stageRec = stagingRecMap.get(acct.AOPS_Seq_Id__c);
            acct = getSiteFromStagingRec(stageRec, acct);
            siteList.add(acct);
        }
        
        return siteList;
    }
    
    private List<Account> getSuccessfulUpsertedSites(Database.UpsertResult[] upsertAcctList, List<Account> accountList) {
        
        List<Account> successAcctList = new List<Account>();
        for(Integer i=0; i < upsertAcctList.size(); i++) {
            if(upsertAcctList[i].isSuccess()) {
                successAcctList.add(accountList[i]);
            }
        }
        return successAcctList;
    }
    
    private List<Account> getFailedUpsertedSites(Database.UpsertResult[] upsertAcctList, List<Account> accountList) {
        
        List<Account> failedAcctList = new List<Account>();
        syncFailedMessageMap = new Map<String,String>();
        
        for(Integer i=0; i < upsertAcctList.size(); i++) {
            if(!upsertAcctList[i].isSuccess()) {
                failedAcctList.add(accountList[i]);
            }
            if(!upsertAcctList[i].isSuccess()) {
                Database.Error[] errors = upsertAcctList[i].getErrors();
                syncFailedMessageMap.put(accountList[i].AOPS_Seq_ID__c, getErrorMessage(errors));
            }
        }
        return failedAcctList;
    }

    private List<Account> getSuccessfulDeletedSites(Database.DeleteResult[] deleteAcctList, List<Account> accountList) {
        
        List<Account> successAcctList = new List<Account>();
        for(Integer i=0; i < deleteAcctList.size(); i++) {
            if(deleteAcctList[i].isSuccess()) {
                successAcctList.add(accountList[i]);
            }
        }
        return successAcctList;
    }
    
    private List<Account> getFailedDeletedSites(Database.DeleteResult[] deleteAcctList, List<Account> accountList) {
        
        List<Account> failedAcctList = new List<Account>();
        syncFailedMessageMap = new Map<String,String>();
        
        for(Integer i=0; i < deleteAcctList.size(); i++) {
            if(!deleteAcctList[i].isSuccess()) {
                failedAcctList.add(accountList[i]);
            }
            if(!deleteAcctList[i].isSuccess()) {
                Database.Error[] errors = deleteAcctList[i].getErrors();
                syncFailedMessageMap.put(accountList[i].AOPS_Seq_ID__c, getErrorMessage(errors));
            }
        }
        return failedAcctList;
    }

    private String getErrorMessage(Database.Error[] errors) {
        String message = '';
        for (Database.Error err : errors) {
            System.debug('Error message '+ err.getMessage());
            message = message + ':' + err.statuscode + ':' + err.message;
        }
        return message;
    }
    
    /**
     * Sets the "Is Changed" fields on the staging records to false, effectively
     * marking them as in sync with their corresponding Sites.
     */
    private void markStagingRecordsWithSyncStatus(List<Account> successList, List<Account> failedList, List<Account_Site_Final_Staging__c> syncedStagingRecList) {
        
        Map<String, Account_Site_Final_Staging__c> stagingRecMap = new Map<String, Account_Site_Final_Staging__c>();
        
        for (Account_Site_Final_Staging__c afs : syncedStagingRecList) {
            stagingRecMap.put(afs.AOPS_Seq_ID__c, afs);
        }
        
        List<Account_Site_Final_Staging__c> clonedRecords = new List<Account_Site_Final_Staging__c>();        
        Account_Site_Final_Staging__c stagingRec;
        
        for(Account acct : successList) {
            stagingRec = stagingRecMap.get(acct.AOPS_Seq_ID__c);
            Account_Site_Final_Staging__c clonedRecord = new Account_Site_Final_Staging__c(Id=stagingRec.Id);
            clonedRecord.Is_Address_Master_Changed__c = false;
            clonedRecord.Is_Address_Addendum_Changed__c = false;
            clonedRecord.Sync_Failed__c = false;
            clonedRecord.Sync_Failed_Reason__c = '';
            clonedRecord.Number_Of_Attempts__c = 0;
            clonedRecords.add(clonedRecord);
        }
        
        for(Account acct : failedList) {
            stagingRec = stagingRecMap.get(acct.AOPS_Seq_ID__c);
            Account_Site_Final_Staging__c clonedRecord = new Account_Site_Final_Staging__c(Id=stagingRec.Id);
            clonedRecord.Sync_Failed__c = true;
            clonedRecord.Sync_Failed_Reason__c = syncFailedMessageMap.get(acct.AOPS_Seq_ID__c);
            clonedRecords.add(clonedRecord);
        }
        
        update clonedRecords;
    }
    
    private void handleSyncFailure(Exception e) {
        System.debug('Exception in AOPSSyncToSiteProcessor = ' + e.getMessage());
        System.debug('Exception occurred: ' + e.getStackTraceString());        
    }   
}
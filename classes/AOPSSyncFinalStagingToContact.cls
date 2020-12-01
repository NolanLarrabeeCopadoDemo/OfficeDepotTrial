public class AOPSSyncFinalStagingToContact {

    private List<Contact_Final_Staging__c> stagingRecordsToSync; // The staging records that have changed to be synced.
    private Map<String, Contact_Final_Staging__c> stagingRecsMap; // The staging records mapped by their contact number.
    private List<Contact_Final_Staging__c> syncedStagingRecords;
    private List<Contact_Final_Staging__c> failedStagingRecords;
    private Map<String, Account> accountsMappedByAopsId;
    private Map<String, String> contactNumberMap;
    private List<Contact> contactsToInsert;
    private List<Contact> contactsToUpdate;
    private List<Contact> contactListToUpdatePreferenceDefaults;
    private Pattern p = Pattern.compile('^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$');

    public AOPSSyncFinalStagingToContact(List<Contact_Final_Staging__c> stagingRecordsToSync) {
        this.stagingRecordsToSync = getStagingRecordsWithChanges(stagingRecordsToSync);
        this.stagingRecsMap = new Map<String, Contact_Final_Staging__c>();
        this.syncedStagingRecords = new List<Contact_Final_Staging__c>();
        this.failedStagingRecords = new List<Contact_Final_Staging__c>();
        this.accountsMappedByAopsId = new Map<String, Account>();
        this.contactNumberMap = new Map<String, String>();
        this.contactsToInsert = new List<Contact>();
        this.contactsToUpdate = new List<Contact>();
        this.contactListToUpdatePreferenceDefaults = new List<Contact>();
    }

    /**
     * Filters the provided list of staging records, including only those to which changes
     * have been made, since if changes have not been made no syncing is necessary.
     */
    private List<Contact_Final_Staging__c> getStagingRecordsWithChanges(List<Contact_Final_Staging__c> stagingRecords) {
        List<Contact_Final_Staging__c> stagingRecsWithDataToUpdate = new List<Contact_Final_Staging__c>();
        for(Contact_Final_Staging__c finalStagingRec : stagingRecords) {
            if(finalStagingRec.Is_Contact_Master_Changed__c == true || finalStagingRec.Is_Contact_Phone_Changed__c == true ||
                    finalStagingRec.Is_Contact_Email_Changed__c == true || finalStagingRec.Is_Contact_OptIn_Changed__c == true ||
                    finalStagingRec.Is_Contact_WebUser_Changed__c == true) {
                stagingRecsWithDataToUpdate.add(finalStagingRec);
            }
        }
        return stagingRecsWithDataToUpdate;
    }

    /**
     * Returns the Staging Records that have been synced by the instance of this class.
     */
    public List<Contact_Final_Staging__c> getSyncedStagingRecs() {
        return syncedStagingRecords;
    }

    public List<Contact_Final_Staging__c> getFailedStagingRecs() {
        return failedStagingRecords;
    }

    /**
     * Syncs the staging records in instance variable stagingRecordsToSync to corresponding Contact records.
     */
    public void sync() {
        mapStagingRecsByContactNumber();
        populateAccountsMappedByAopsId(); // We need Account info to properly populate the Contacts.
        generateContacts();
        upsertContacts();
    }

    private void mapStagingRecsByContactNumber() {
        for(Contact_Final_Staging__c stagingRec : stagingRecordsToSync) {
            stagingRecsMap.put(stagingRec.AOPS_Contact_Number__c, stagingRec);
        }
    }

    /**
     * Retrieves the Accounts associated with the staging records and maps them by their AOPS IDs.
     */
    private void populateAccountsMappedByAopsId() {
        Set<String> aopsIds = new Set<String>();
        for(Contact_Final_Staging__c stagingRecs : stagingRecordsToSync)
            aopsIds.add(stagingRecs.AOPS_Account_Number__c);

        List<Account> accts = [SELECT Id, AOPS_Cust_ID__c, OwnerId FROM Account WHERE AOPS_Cust_ID__c IN: aopsIds];
        for(Account acct : accts)
            accountsMappedByAopsId.put(acct.AOPS_Cust_ID__c, acct);
    }

    /**
     * Divides the staging records into Contacts that need to be updated
     * and Contacts that need to be inserted. If a contact needs to be inserted
     * but does not have enough information yet, it isn't added to the list.
     * 
     * Also ensures the Contacts are updated with the proper information from the staging records. 
     */
    private void generateContacts() {
        List<Contact> existingContacts = getExistingContacts();
        // Map Contacts by their Contact Number before they are modified, since it's possible the Contact Number will be removed.
        populateContactNumberMap(existingContacts);
        
        for(Contact_Final_Staging__c stagingRec : stagingRecordsToSync) {
            try {
                Contact matchingContact = getMatch(existingContacts, stagingRec);
                // Make a list of contacts for which you will stamp contact number the first time in SFDC.
                if (matchingContact != null && matchingContact.aops_contact_number__c == null) {
                    contactListToUpdatePreferenceDefaults.add(matchingContact);
                }
                // If a matching contact exists in SFDC.
                if(matchingContact != null) {
                    contactsToUpdate.add(populateContact(matchingContact, stagingRec));
                } else if(stagingRec.Is_Contact_Master_Changed__c == true) {
                    contactsToInsert.add(populateContact(new Contact(), stagingRec));
                }
            } catch(Exception e) {
                String errorMessage = e.getMessage();
                addToFailureList(stagingRec, errorMessage);
            }
        }
    }
    
    /**
     * Queries Contacts that could be a match for one of the staging records.
     */
    private List<Contact> getExistingContacts() {
        Set<String> aopsContactNumbers = getStagingRecordFieldValues('AOPS_Contact_Number__c', null, null);
        Set<String> aopsAccountNumbers = getStagingRecordFieldValues('AOPS_Account_Number__c', null, null);
        Set<String> names = getStagingRecordFieldValues('First_Name__c', 'Last_Name__c', ' ');
        System.debug('Account numbers='+ aopsAccountNumbers);
        System.debug('Contact numbers='+ aopsContactNumbers);
        System.debug('Names ='+ names);
        System.debug('Account numbers size='+ aopsAccountNumbers.size());
        System.debug('Contact numbers size='+ aopsContactNumbers.size());
        System.debug('Names size='+ names.size());
        List<Contact> existingContacts = [SELECT Id, AOPS_Contact_Number__c, AOPS_Account_Number__c, Account.AOPS_Cust_ID__c, Phone, Phone_Ext__c,
                Phone_1_Type_AOPS__c, SFDC_Phone_Number__c, SFDC_Phone_Ext__c, SFDC_Phone_Type__c, Phone_Changed_By_AOPS__c, Email, Email_1_AOPS__c,
                Email_2_AOPS__c, Email_3_AOPS__c, Name, AccountId, OwnerId, RecordTypeId, SFDC_Email_Address__c, Legacy_CreatedDate__c
                FROM Contact
                WHERE (AOPS_Contact_Number__c IN: aopsContactNumbers OR
                (AOPS_Contact_Number__c = null AND Account.AOPS_Cust_ID__c IN: aopsAccountNumbers AND Name IN: names))
                AND Status__c != 'InActive' AND Status__c != 'Delete']; 
        
        return existingContacts;
    }

    private void populateContactNumberMap(List<Contact> cntcts) {
        for(Contact cntct : cntcts)
            contactNumberMap.put(cntct.Id, cntct.AOPS_Contact_Number__c);
    }

    /**
     * Given a field name (fieldName1), returns a list of all values for that field in the staging records.
     * 
     * If the fieldName2 and separator parameters are provided, the values for the second field are contatenated
     * to the first with the separator in between. This is useful for name fields (i.e. FirstName LastName).
     */
    private Set<String> getStagingRecordFieldValues(String fieldName1, String fieldName2, String separator) {
        Set<String> recordFieldValues = new Set<String>();
        for(Contact_Final_Staging__c stagingRec : stagingRecordsToSync) {
            String value = (String) stagingRec.get(fieldName1);
            if(fieldName2 != null && separator != null)
                value += (separator + stagingRec.get(fieldName2));
            if(value != null && value != '')
                recordFieldValues.add(value);
        }
        return recordFieldValues;
    }

    /**
     * Checks if the list of Contacts contains a match for the provided staging record.
     * If so, the matching Contact is returned. Otherwise, returns null.
     */
    private Contact getMatch(List<Contact> cntcts, Contact_Final_Staging__c stagingRec) {
        for(Contact cntct : cntcts) {
            if(cntct.AOPS_Contact_Number__c == stagingRec.AOPS_Contact_Number__c)
                return cntct;

            if(cntct.AOPS_Contact_Number__c == null && cntct.Account.AOPS_Cust_ID__c == stagingRec.AOPS_Account_Number__c) {
                // if(cntct.Email != null && getPrimaryEmail(stagingRec) != null && cntct.Email.toLowerCase() == getPrimaryEmail(stagingRec).toLowerCase())
                //     return cntct;

                if(cntct.Name.toLowerCase() == (stagingRec.First_Name__c + ' ' + stagingRec.Last_Name__c).toLowerCase())
                    return cntct;
            }
        }
        return null;
    }

    /**
     * Populates the provided Contact with field values from the provided staging record.
     * Note that only the fields marked as changed in AOPS will be set.
     */
    private Contact populateContact(Contact cntct, Contact_Final_Staging__c finalStagingRec) {
        if(cntct == null) cntct = new Contact();
        
        if(finalStagingRec.Is_Contact_Master_Changed__c) setMasterFields(cntct, finalStagingRec);
        if(finalStagingRec.Is_Contact_Phone_Changed__c) setPhoneFields(cntct, finalStagingRec);
        if(finalStagingRec.Is_Contact_Email_Changed__c) setEmailFields(cntct, finalStagingRec);
        if(finalStagingRec.Is_Contact_OptIn_Changed__c) setOptInFields(cntct, finalStagingRec);
        if(finalStagingRec.Is_Contact_WebUser_Changed__c) setWebUserFields(cntct, finalStagingRec);

        if(cntct.AccountId == null) setAccountId(cntct);
        if(cntct.OwnerId == null) setOwnerId(cntct);
        if(cntct.RecordTypeId == null) setRecordTypeId(cntct);

        cntct.Override_Duplicate_Check__c = true;

        if(finalStagingRec.Status__c == 'Delete')
            cntct.AOPS_Contact_Number__c = null;

        return cntct;
    }

    private void setMasterFields(Contact cntct, Contact_Final_Staging__c finalStagingRec) {
        
        cntct.AOPS_Contact_Number__c = finalStagingRec.AOPS_Contact_Number__c;
        cntct.AOPS_Account_Number__c = finalStagingRec.AOPS_Account_Number__c;
        cntct.Default_Shipto__c = finalStagingRec.Default_Shipto__c;
        cntct.Default_Mailto__c = finalStagingRec.Default_Mailto__c;
        cntct.FirstName = finalStagingRec.First_Name__c;
        cntct.LastName = finalStagingRec.Last_Name__c;
        cntct.Middle_Name_Initial__c = finalStagingRec.Middle_Name_Initial__c;
        cntct.Salutation__c = finalStagingRec.Salutation__c;
        cntct.Contact_Type__c = finalStagingRec.Contact_Type__c;
        cntct.Status__c = finalStagingRec.Status__c;
        cntct.Primary_Contact__c = finalStagingRec.Primary_Contact__c;
        cntct.Title = finalStagingRec.Title__c;
        cntct.AOPS_Role__c = finalStagingRec.AOPS_Role__c;
        cntct.Authorized_Buyer__c = finalStagingRec.Authorized_Buyer__c;
        cntct.Polybag_Green__c = finalStagingRec.Polybag_Green__c;
        cntct.Min_Order_Value_Ind__c = finalStagingRec.Min_Order_Value_Ind__c;
        cntct.Legacy_CreatedDate__c = finalStagingRec.Legacy_CreatedDate__c;
    }

	@testvisible
    private void setPhoneFields(Contact cntct, Contact_Final_Staging__c finalStagingRec) {
        cntct.AOPS_Contact_Number__c = finalStagingRec.AOPS_Contact_Number__c;
        cntct.AOPS_Account_Number__c = finalStagingRec.AOPS_Account_Number__c;

        cntct.Fax = finalStagingRec.Fax__c;

        cntct.Phone_1_AOPS_Seq__c = finalStagingRec.Phone1_AOPS_Seq__c;
        cntct.Phone_1_AOPS__c = finalStagingRec.Phone1__c;
        cntct.Phone_1_Ext_AOPS__c = finalStagingRec.Phone_EXT__c;
        cntct.Phone_1_Type_AOPS__c = finalStagingRec.Phone1_Type__c;
        cntct.Default_Phone_1_AOPS__c = finalStagingRec.Default_Phone1__c;
        if (finalStagingRec.Phone1__c != null && finalStagingRec.P_OptIn1__c == null) {
            //cntct.Phone_1_OptIn_AOPS__c = 'Y';
            //cntct.M_OptIn1__c = 'Y';
        }

        cntct.Phone_2_AOPS_Seq__c = finalStagingRec.Phone2_AOPS_Seq__c;
        cntct.Phone_2_AOPS__c = finalStagingRec.Phone2__c;
        cntct.Phone_2_Ext_AOPS__c = finalStagingRec.Phone_2_Ext__c;
        cntct.Phone_2_Type_AOPS__c = finalStagingRec.Phone2_Type__c;
        cntct.Default_Phone_2_AOPS__c = finalStagingRec.Default_Phone2__c;
        if (finalStagingRec.Phone2__c != null && finalStagingRec.P_OptIn2__c == null) {
            //cntct.Phone_2_OptIn_AOPS__c = 'Y';
            //cntct.M_OptIn2__c = 'Y';
        }

        cntct.Phone_3_AOPS_Seq__c = finalStagingRec.Phone3_AOPS_Seq__c;
        cntct.Phone_3_AOPS__c = finalStagingRec.Phone3__c;
        cntct.Phone_3_Ext_AOPS__c = finalStagingRec.Phone_3_Ext__c;
        cntct.Phone_3_Type_AOPS__c = finalStagingRec.Phone3_Type__c;
        cntct.Default_Phone_3_AOPS__c = finalStagingRec.Default_Phone3__c;
        if (finalStagingRec.Phone3__c != null && finalStagingRec.P_OptIn3__c == null) {
            //cntct.Phone_3_OptIn_AOPS__c = 'Y';
            //cntct.M_OptIn3__c = 'Y';
        }
    }

	@testvisible
    private void setEmailFields(Contact cntct, Contact_Final_Staging__c finalStagingRec) {
        cntct.AOPS_Contact_Number__c = finalStagingRec.AOPS_Contact_Number__c;

        //if(cntct.Email_1_AOPS__c == cntct.Email && String.isBlank(finalStagingRec.Email1__c))
        //    cntct.Email = null;
        cntct.Email_1_AOPS_Seq__c = finalStagingRec.Email1_AOPS_Seq__c;
        cntct.Email_1_AOPS__c = finalStagingRec.Email1__c;
        cntct.Email_1_Type_AOPS__c = finalStagingRec.Email1_Type__c;
        cntct.Default_Email_1_AOPS__c = finalStagingRec.Default_Email1__c;
        //if (finalStagingRec.Email1__c != null && (finalStagingRec.E_OptIn1__c == null))  
            //cntct.Email_1_OptIn_AOPS__c = 'Y';

        //if(cntct.Email_2_AOPS__c == cntct.Email && String.isBlank(finalStagingRec.Email2__c))
        //    cntct.Email = null;
        cntct.Email_2_AOPS_Seq__c = finalStagingRec.Email2_AOPS_Seq__c;
        cntct.Email_2_AOPS__c = finalStagingRec.Email2__c;
        cntct.Email_2_Type_AOPS__c = finalStagingRec.Email2_Type__c;
        cntct.Default_Email_2_AOPS__c = finalStagingRec.Default_Email2__c;
        //if (finalStagingRec.Email2__c != null && (finalStagingRec.E_OptIn2__c == null))  
            //cntct.Email_2_OptIn_AOPS__c = 'Y';

        //if(cntct.Email_3_AOPS__c == cntct.Email && String.isBlank(finalStagingRec.Email3__c))
        //    cntct.Email = null;
        cntct.Email_3_AOPS_Seq__c = finalStagingRec.Email3_AOPS_Seq__c;
        cntct.Email_3_AOPS__c = finalStagingRec.Email3__c;
        cntct.Email_3_Type_AOPS__c = finalStagingRec.Email3_Type__c;
        cntct.Default_Email_3_AOPS__c = finalStagingRec.Default_Email3__c;
        //if (finalStagingRec.Email3__c != null && (finalStagingRec.E_OptIn3__c == null))  
            //cntct.Email_3_OptIn_AOPS__c = 'Y';

        String defaultEmail = null;
        if(cntct.Default_Email_1_AOPS__c == 'Y') defaultEmail = cntct.Email_1_AOPS__c;
        else if(cntct.Default_Email_2_AOPS__c == 'Y') defaultEmail = cntct.Email_2_AOPS__c;
        else if(cntct.Default_Email_3_AOPS__c == 'Y') defaultEmail = cntct.Email_3_AOPS__c;
        
        if(defaultEmail != null && defaultEmail.length() <= 80) { // Standard email field max length:80
            if(cntct.Email != null && cntct.SFDC_Email_Address__c == null) cntct.SFDC_Email_Address__c = cntct.Email;
            Matcher m = p.matcher(defaultEmail);
            if (m.matches()) {
                cntct.Email = defaultEmail;
                cntct.Email_Changed_By_AOPS__c = true;
            }
        }
        // Delete contact.email if the default email is deleted in AOPS.
        if((defaultEmail == null) && (cntct.Default_Email_1_AOPS__c == 'Y' || cntct.Default_Email_2_AOPS__c == 'Y' || cntct.Default_Email_3_AOPS__c == 'Y')) {
            cntct.Email = '';
        }
    }

	@testvisible
    private void setOptInFields(Contact cntct, Contact_Final_Staging__c finalStagingRec) {
        cntct.AOPS_Contact_Number__c = finalStagingRec.AOPS_Contact_Number__c;
        cntct.AOPS_Account_Number__c = finalStagingRec.AOPS_Account_Number__c;

        /*if (finalStagingRec.Phone1__c != null && finalStagingRec.P_OptIn1__c == null) {
            //cntct.Phone_1_OptIn_AOPS__c = 'Y';
        } else
        */
        if (finalStagingRec.P_OptIn1__c != null) {
            cntct.Phone_1_OptIn_AOPS__c = finalStagingRec.P_OptIn1__c;
        }
        
        /*if (finalStagingRec.Phone2__c != null && finalStagingRec.P_OptIn2__c == null) {
            //cntct.Phone_2_OptIn_AOPS__c = 'Y';
        } else
        */
        if (finalStagingRec.P_OptIn2__c != null) {
            cntct.Phone_2_OptIn_AOPS__c = finalStagingRec.P_OptIn2__c;
        }
        
        /*if (finalStagingRec.Phone3__c != null && finalStagingRec.P_OptIn3__c == null) {
            //cntct.Phone_3_OptIn_AOPS__c = 'Y';
        } else        
        */
        if (finalStagingRec.P_OptIn3__c != null) {
            cntct.Phone_3_OptIn_AOPS__c = finalStagingRec.P_OptIn3__c;
        }
        /* Mobile is out of scope for now so commenting out.
        if (finalStagingRec.Phone1__c != null && finalStagingRec.M_OptIn1__c == null) {
            cntct.M_OptIn1__c = 'Y';
        } else        
            cntct.M_OptIn1__c = finalStagingRec.M_OptIn1__c;

        if (finalStagingRec.Phone2__c != null && finalStagingRec.M_OptIn2__c == null) {
            cntct.M_OptIn2__c = 'Y';
        } else        
            cntct.M_OptIn2__c = finalStagingRec.M_OptIn2__c;
        
        if (finalStagingRec.Phone3__c != null && finalStagingRec.M_OptIn3__c == null) {
            cntct.M_OptIn3__c = 'Y';
        } else         
            cntct.M_OptIn3__c = finalStagingRec.M_OptIn3__c;
        */
        /*
        if(finalStagingRec.Email1__c != null && finalStagingRec.E_OptIn1__c == null) {
            cntct.Email_1_OptIn_AOPS__c = 'Y';
        } else
        */
        if (finalStagingRec.E_OptIn1__c != null) {
            cntct.Email_1_OptIn_AOPS__c = finalStagingRec.E_OptIn1__c;
        }
        
        /*if(finalStagingRec.Email2__c != null && finalStagingRec.E_OptIn2__c == null) {
            cntct.Email_2_OptIn_AOPS__c = 'Y';
        } else*/
        if (finalStagingRec.E_OptIn2__c != null) {
            cntct.Email_2_OptIn_AOPS__c = finalStagingRec.E_OptIn2__c;
        }
        
        /*if(finalStagingRec.Email3__c != null && finalStagingRec.E_OptIn3__c == null) {
            cntct.Email_3_OptIn_AOPS__c = 'Y';
        } else
        */
        if (finalStagingRec.E_OptIn3__c != null) {
            cntct.Email_3_OptIn_AOPS__c = finalStagingRec.E_OptIn3__c;
        }
        
        if (finalStagingRec.Mail_OptIn__c != null) {
            cntct.AOPS_Mail_OptIn__c  = finalStagingRec.Mail_OptIn__c;
        }
    }

	@testvisible
    private void setWebUserFields(Contact cntct, Contact_Final_Staging__c finalStagingRec) {
        cntct.AOPS_Contact_Number__c = finalStagingRec.AOPS_Contact_Number__c;
        cntct.AOPS_Account_Number__c = finalStagingRec.AOPS_Account_Number__c;

        cntct.Web_User_Acct_Code__c = finalStagingRec.Web_User_Acct_Code__c;
        cntct.Acct_Code_Value__c = finalStagingRec.Acct_Code_Value__c;
        cntct.Web_Username__c = finalStagingRec.Web_Username__c;
        cntct.Web_User_Seq__c = finalStagingRec.Web_User_Seq__c;
        cntct.User_Type__c = finalStagingRec.User_Type__c;
        cntct.AB_Flag__c = finalStagingRec.AB_Flag__c;
        cntct.Default_Postal_Code__c = finalStagingRec.Default_Postal_Code__c;
        cntct.Last_Website_Visit__c = finalStagingRec.Last_Website_Visit__c;
        //cntct.Legacy_CreatedDate__c = finalStagingRec.Legacy_CreatedDate__c;
    }

    private void setAccountId(Contact cntct) {
        Account acct = accountsMappedByAopsId.get(cntct.AOPS_Account_Number__c);
        if(acct == null)
            throw new NotFoundException('AOPSSyncFinalStagingToContact.apxc: Associated account not found with Customer ID ' + cntct.AOPS_Account_Number__c);
        cntct.AccountId = acct.Id;
    }

    private void setOwnerId(Contact cntct) {
        Account acct = accountsMappedByAopsId.get(cntct.AOPS_Account_Number__c);
        cntct.OwnerId = acct.OwnerId;
    }

    private void setRecordTypeId(Contact cntct) {
        Id recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact(US)').getRecordTypeId();
        cntct.RecordTypeId = recordTypeId;
    }

    /**
     * Persist the generated contacts in instance variables contactsToInsert and contactsToUpsert.
     */
    private void upsertContacts() {
        Database.DMLOptions options = new Database.DMLOptions();
        options.OptAllOrNone = false;
        if(contactsToInsert.size() > 0) {
            addDefaultOptInfoToContact(contactsToInsert);//Add defaults for brand new contacts.
            Database.SaveResult[] insertResults = Database.insert(contactsToInsert, options);
            addToSyncResults(insertResults, contactsToInsert);
            addDefaultOptPrefDates(contactsToInsert);// Add pref object defaults for brand new contacts.
        }
        if(contactsToUpdate.size() > 0) {
            addDefaultOptInfoToContact(contactListToUpdatePreferenceDefaults);//Add defaults for contacts before stamping aops number the first time.
            Database.SaveResult[] insertResults = Database.update(contactsToUpdate, options);
            addToSyncResults(insertResults, contactsToUpdate);
            addDefaultOptPrefDates(contactListToUpdatePreferenceDefaults);//Add pref object defaults for contacts before stamping aops number the first time.
        }
    }

    private void addToSyncResults(Database.SaveResult[] saveResults, List<Contact> correspondingContacts) {
        for(Integer i = 0; i < saveResults.size(); i++) {
            Contact cntct = correspondingContacts[i];
            // If a Contact is being created, it won't exist in contactNumberMap, so we use the saved Contact.
            // We need to use contactNumberMap in other scenarios because of the possibility that AOPS_Contact_Number__c is removed during the sync.
            String contactNumber = null;
            // Note that this condition will be true if the key cntct.Id doesn't exist, or if the Contact did not previously have a Contact Number.
            if(contactNumberMap.get(cntct.Id) == null)
                contactNumber = cntct.AOPS_Contact_Number__c;
            else
                contactNumber = contactNumberMap.get(cntct.Id);
            Contact_Final_Staging__c finalStagingRec = stagingRecsMap.get(contactNumber);
            if(saveResults[i].isSuccess()) {
                if(finalStagingRec != null)
                    syncedStagingRecords.add(finalStagingRec);
            } else {
                if(finalStagingRec != null)
                    addToFailureList(finalStagingRec, getFailureMessage(saveResults[i]));
            }
        }
    }

    private String getFailureMessage(Database.SaveResult result) {
        String err = '';
        for(Database.Error e : result.getErrors()) {
            if(String.isBlank(err) == false) err += ' ';
            err += e.getMessage();
        }
        return err;
    }

    private void addToFailureList(Contact_Final_Staging__c finalStagingRec, String errorMessage) {
        Contact_Final_Staging__c clonedRec = new Contact_Final_Staging__c(Id=finalStagingRec.Id);
        clonedRec.Contact_Sync_Message__c = errorMessage;
        failedStagingRecords.add(clonedRec);
    }

    private void addDefaultOptPrefDates(List<Contact> contactsToInsert) {

        List<AOPSContactOptInOut__c> optInOutList = new List<AOPSContactOptInOut__c>();
        for (Contact cntct : contactsToInsert) {            
            if (cntct.Id != null) {
                AOPSContactOptInOut__c optInOut = new AOPSContactOptInOut__c();
                optInOut.Contact_ID__c = cntct.Id;
                optInOut.AOPS_Contact_Number__c = cntct.AOPS_Contact_Number__c;
                setOptInInfo(optInOut, cntct);
                optInOutList.add(optInOut);
            }
        }
        if (optInOutList.size() > 0) {
            Database.DMLOptions options = new Database.DMLOptions();
            options.OptAllOrNone = false;
            Database.SaveResult[] insertResults = Database.insert(optInOutList, options);
        }
    }

	@testvisible
    private void setOptInInfo(AOPSContactOptInOut__c optInOut, Contact cntct) {
        
        // Set Email Opt dates.        
        optInOut.Email_1_Opt_Date__c = cntct.Legacy_CreatedDate__c;
        optInOut.Email_2_Opt_Date__c = cntct.Legacy_CreatedDate__c;
        optInOut.Email_3_Opt_Date__c = cntct.Legacy_CreatedDate__c;

        optInOut.Email_1_OptIn_AOPS__c = 'Y';
        optInOut.Email_2_OptIn_AOPS__c = 'Y';
        optInOut.Email_3_OptIn_AOPS__c = 'Y';
        

        // Set Phone Opt dates.
        optInOut.Phone_1_Opt_Date__c = cntct.Legacy_CreatedDate__c;
        optInOut.Phone_2_Opt_Date__c = cntct.Legacy_CreatedDate__c;
        optInOut.Phone_3_Opt_Date__c = cntct.Legacy_CreatedDate__c;

        optInOut.Phone_1_OptIn_AOPS__c = 'Y';
        optInOut.Phone_2_OptIn_AOPS__c = 'Y';
        optInOut.Phone_3_OptIn_AOPS__c = 'Y';

        // Set Mobile Opt dates.
        optInOut.Mobile_1_Opt_Date__c = cntct.Legacy_CreatedDate__c;
        optInOut.Mobile_2_Opt_Date__c = cntct.Legacy_CreatedDate__c;
        optInOut.Mobile_3_Opt_Date__c = cntct.Legacy_CreatedDate__c;

        // Set Mail Opt Date
        optInOut.Mail_Opt_Date__c = cntct.Legacy_CreatedDate__c;
        optInOut.Mail_OptIn_AOPS__c = 'Y';

        optInOut.M_OptIn1__c = 'N';
        optInOut.M_OptIn2__c = 'N';
        optInOut.M_OptIn3__c = 'N';

        
    }

    private void addDefaultOptInfoToContact(List<Contact> contactsToInsert) {

        for (Contact cntct: contactsToInsert) {
            // Add defaults on creation
            cntct.AOPS_Mail_OptIn__c = 'Y';
            cntct.M_OptIn1__c = 'N';
            cntct.M_OptIn2__c = 'N';
            cntct.M_OptIn3__c = 'N';

            cntct.Phone_1_OptIn_AOPS__c = 'Y';
            cntct.Phone_2_OptIn_AOPS__c = 'Y';
            cntct.Phone_3_OptIn_AOPS__c = 'Y';

            cntct.Email_1_OptIn_AOPS__c = 'Y';
            cntct.Email_2_OptIn_AOPS__c = 'Y';
            cntct.Email_3_OptIn_AOPS__c = 'Y';
        }

    }
    
    class NotFoundException extends Exception {}
}
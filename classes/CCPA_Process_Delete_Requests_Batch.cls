global without sharing class CCPA_Process_Delete_Requests_Batch implements Database.Batchable<SObject>, Schedulable {
    
    private String query;

    public CCPA_Process_Delete_Requests_Batch() {
        query = 'SELECT Id, CCPA_Request__c, Key_Name__c, Key_Value__c, Sales_Cloud_Complete__c, Marketing_Cloud_Status__c FROM CCPA_Action__c WHERE CCPA_Request__r.Sales_Cloud_Complete__c != true OR CCPA_Request__r.Marketing_Cloud_Complete__c != true';
    }

    public CCPA_Process_Delete_Requests_Batch(String query) {
        this.query = query;
    }

    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, SObject[] scope) {
        List<CCPA_Action__c> actions = scope;
        Savepoint sp = Database.setSavepoint();
        try {
            processActions(actions);
        } catch(Exception e) {
            Database.rollback(sp);
            throw e;
        }
    }

    /**
     * Handles deletion process for a set of actions.
     */
    public void processActions(List<CCPA_Action__c> actions) {
        performDeletions(actions);
        updateStatuses(actions);
    }

    /**
     * Performs deletion/obfuscation for incomplete actions.
     */
    private void performDeletions(List<CCPA_Action__c> actions) {
        List<CCPA_Action__c> incompleteActions = getActionsWithSalesCloudCompleteFiltered(actions);

        List<String> contactIds = getContactIdsFromActions(incompleteActions);
        List<String> leadIds = getLeadIdsFromActions(incompleteActions);
        deleteDataBasedOnSfdcIds(contactIds, leadIds);

        Set<String> emails = getEmailsFromActions(incompleteActions);
        Set<String> phoneNumbers = getPhoneNumbersFromActions(incompleteActions);
        deleteDataBasedOnFieldValues(emails, phoneNumbers);
    }

    /**
     * Given a set of CCPA Actions, returns a list of the actions that are Sales Cloud incomplete.
     */
    private List<CCPA_Action__c> getActionsWithSalesCloudCompleteFiltered(List<CCPA_Action__c> actions) {
        List<CCPA_Action__c> filteredActions = new List<CCPA_Action__c>();
        for(CCPA_Action__c action : actions) {
            if(action.Sales_Cloud_Complete__c != true) {
                filteredActions.add(action);
            }
        }
        return filteredActions;
    }

    /**
     * Given a set of CCPA Actions, returns a List of IDs of Contacts that need to be deleted.
     */
    private List<String> getContactIdsFromActions(List<CCPA_Action__c> actions) {
        List<String> contactIds = new List<String>();
        for(CCPA_Action__c action : actions) {
            if(action.Key_Name__c == 'SFDC_CONTACT_PROSPECT') {
                contactIds.add(action.Key_Value__c);
            }
        }
        return contactIds;
    }

    /**
     * Given a set of CCPA Actions, returns a List of IDs of Leads that need to be deleted.
     */
    private List<String> getLeadIdsFromActions(List<CCPA_Action__c> actions) {
        List<String> leadIds = new List<String>();
        for(CCPA_Action__c action : actions) {
            if(action.Key_Name__c == 'SFDC_LEAD') {
                leadIds.add(action.Key_Value__c);
            }
        }
        return leadIds;
    }

    /**
     * Given the IDs of Contacts and Leads, deletes the Contacts and Leads,
     * as well as any records with PII associated with them. This includes
     * Support, LeadStaging, and Referrals.
     */
    private void deleteDataBasedOnSfdcIds(List<String> contactIds, List<String> leadIds) {
        List<Contact> contactsToDelete = getContactsToDelete(contactIds);
        List<String> contactIdsToDelete = getIds(contactsToDelete);
        List<Case> supportToDelete = getSupportToDelete(contactIdsToDelete);
        List<Lead> leadsToDelete = getLeadsToDelete(leadIds);
        List<LeadStaging__c> leadStagingToDelete = getLeadStagingToDelete(leadIds);
        List<Referral__c> referralsToDelete = getReferralsToDelete(contactIdsToDelete, leadIds);

        // Note that support must be deleted before associated contacts. Otherwise a DMLException may be thrown.
        if(supportToDelete.size() > 0) { delete supportToDelete; }
        if(contactsToDelete.size() > 0) { delete contactsToDelete; }
        if(leadsToDelete.size() > 0) { delete leadsToDelete; }
        if(leadStagingToDelete.size() > 0) { delete leadStagingToDelete; }
        if(referralsToDelete.size() > 0) { delete referralsToDelete; }
    }

    private List<Contact> getContactsToDelete(List<String> contactIds) {
        if(contactIds.size() == 0) { return new List<Contact>(); }

        Id prospectRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
        Id techZoneProspectRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect (Tech-Zone)').getRecordTypeId();
        List<String> recordTypeIds = new List<String> { prospectRecordTypeId, techZoneProspectRecordTypeId };

        // Pull in contacts from the list, but exclude those that are not associated with a Prospect, since only Prospect Accounts are in scope.
        List<Contact> cntcts = [SELECT Id FROM Contact WHERE Id IN: contactIds AND Account.RecordTypeId IN: recordTypeIds];
        // Exclude Contacts associated with a portal (community) User.
        cntcts = getContactsWithPortalUsersFiltered(cntcts);
        return cntcts;
    }

    private List<Case> getSupportToDelete(List<String> contactIds) {
        if(contactIds.size() == 0) { return new List<Case>(); }

        return [SELECT Id FROM Case WHERE ContactId IN: contactIds];
    }

    private List<Lead> getLeadsToDelete(List<String> leadIds) {
        if(leadIds.size() == 0) { return new List<Lead>(); }

        return [SELECT Id FROM Lead WHERE Id IN: leadIds];
    }
    
    private List<LeadStaging__c> getLeadStagingToDelete(List<String> leadIds) {
        if(leadIds.size() == 0) { return new List<LeadStaging__c>(); }

        return [SELECT Id FROM LeadStaging__c WHERE CreatedLead__c IN: leadIds];
    }
    
    private List<Referral__c> getReferralsToDelete(List<String> contactIds, List<String> leadIds) {
        if(contactIds.size() == 0 && leadIds.size() == 0) { return new List<Referral__c>(); }

        return [SELECT Id FROM Referral__c
                WHERE Referred_Contact__c IN: contactIds OR Resulting_Lead__c IN: leadIds OR Referred_Lead__c IN: leadIds];
    }

    /**
     * Given a List of CCPA Actions, returns a Set of emails that need to be obfuscated.
     */
    private Set<String> getEmailsFromActions(List<CCPA_Action__c> actions) {
        Set<String> emails = new Set<String>();
        for(CCPA_Action__c action : actions) {
            if(action.Key_Name__c == 'EMAIL') {
                emails.add(action.Key_Value__c);
            }
        }
        return emails;
    }

    /**
     * Given a List of CCPA Actions, returns a Set of phone numbers that need to be obfuscated.
     */
    private Set<String> getPhoneNumbersFromActions(List<CCPA_Action__c> actions) {
        Set<String> phoneNumbers = new Set<String>();
        for(CCPA_Action__c action : actions) {
            if(action.Key_Name__c == 'PHONE') {
                phoneNumbers.add(action.Key_Value__c);
            }
        }
        return phoneNumbers;
    }

    /**
     * Obfuscates emails and phone numbers on records from relevant objects.
     */
    private void deleteDataBasedOnFieldValues(Set<String> emails, Set<String> phoneNumbers) {
        if(emails.size() > 0) {
            obfuscateEmails(emails);
        }

        if(phoneNumbers.size() > 0) {
            obfuscatePhoneNumbers(phoneNumbers);
        }
    }

    private void obfuscateEmails(Set<String> emails) {
        obfuscateContactEmails(emails);
        obfuscateSupportEmails(emails);
        obfuscateLeadStagingEmails(emails);
        obfuscateLeadEmails(emails);
        obfuscateReferralEmails(emails);
    }

    private void obfuscateContactEmails(Set<String> emails) {
        Id prospectRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
        Id techZoneProspectRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect (Tech-Zone)').getRecordTypeId();
        List<String> acctRecordTypes = new List<String> { prospectRecordTypeId, techZoneProspectRecordTypeId };

        // Email is an indexed field and so can be used to query records. Note that we exclude Contacts not linked to Prospects.
        List<Contact> cntcts1 = [SELECT Email, Email1__c, Email2__c, Email3__c FROM Contact WHERE Account.RecordTypeId IN: acctRecordTypes AND Email IN: emails];
        // Because there are so many Contacts in our instance, we had to create an indexed field (Email_Concatenation__c) to query based on the custom email fields.
        Set<String> queryEmailList = new Set<String>();
        for(String email : emails) {
            queryEmailList.add('%' + email + '%');
        }
        List<Contact> cntcts2 = [SELECT Id, Email, Email1__c, Email2__c, Email3__c FROM Contact WHERE Account.RecordTypeId IN: acctRecordTypes AND Email_Concatenation__c LIKE: queryEmailList];

        // We need to concatenate the two lists of Contacts, and ensure there aren't duplicates so update issues don't occur.
        List<Contact> contactsToUpdate = new List<Contact>();
        addRecordsExcludingDuplicates(contactsToUpdate, cntcts1);
        addRecordsExcludingDuplicates(contactsToUpdate, cntcts2);
        // We don't want to update Contacts associated with a portal (community) user.
        contactsToUpdate = getContactsWithPortalUsersFiltered(contactsToUpdate);
        // Obfuscate the email fields that contain emails in the provided list.
        for(Contact cntct : contactsToUpdate) {
            if(emails.contains(cntct.Email)) { cntct.Email = 'zzz@zzz.com'; }
            if(emails.contains(cntct.Email1__c)) { cntct.Email1__c = 'zzz@zzz.com'; }
            if(emails.contains(cntct.Email2__c)) { cntct.Email2__c = 'zzz@zzz.com'; }
            if(emails.contains(cntct.Email3__c)) { cntct.Email3__c = 'zzz@zzz.com'; }
        }

        if(contactsToUpdate.size() > 0) {
            update contactsToUpdate;
        }
    }

    private void obfuscateSupportEmails(Set<String> emails) {
        Id prospectRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
        Id techZoneProspectRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect (Tech-Zone)').getRecordTypeId();
        List<String> acctRecordTypeIds = new List<String> { prospectRecordTypeId, techZoneProspectRecordTypeId };

        // Query support records associated with a Prospect based on their email fields.
        List<Case> support = [SELECT Id, AM_Contact_Email__c, WRF_Eproc_Email__c, WRF_IT_Contact_Email__c, Requestor_Email_2__c FROM Case
                                WHERE Account.RecordTypeId IN: acctRecordTypeIds AND
                                (AM_Contact_Email__c IN: emails OR WRF_Eproc_Email__c IN: emails OR WRF_IT_Contact_Email__c IN: emails OR
                                Requestor_Email_2__c IN: emails)];
        // Obfuscate the email fields that contain emails in the provided list.
        for(Case s : support) {
            if(emails.contains(s.AM_Contact_Email__c)) { s.AM_Contact_Email__c = 'zzz@zzz.com'; }
            if(emails.contains(s.WRF_Eproc_Email__c)) { s.WRF_Eproc_Email__c = 'zzz@zzz.com'; }
            if(emails.contains(s.WRF_IT_Contact_Email__c)) { s.WRF_IT_Contact_Email__c = 'zzz@zzz.com'; }
            if(emails.contains(s.Requestor_Email_2__c)) { s.Requestor_Email_2__c = 'zzz@zzz.com'; }
        }
        if(support.size() > 0) {
            update support;
        }
    }

    private void obfuscateLeadStagingEmails(Set<String> emails) {
        List<LeadStaging__c> ldStaging = [SELECT Id, Email__c FROM LeadStaging__c WHERE Email__c IN: emails];
        for(LeadStaging__c l : ldStaging) {
            l.Email__c = 'zzz@zzz.com';
        }
        if(ldStaging.size() > 0) {
            update ldStaging;
        }
    }

    private void obfuscateLeadEmails(Set<String> emails) {
        // Query Leads based on the email fields.
        List<Lead> lds = [SELECT Id, Email, Referrer_Email__c FROM Lead WHERE Email IN: emails OR Referrer_Email__c IN: emails];
        // Obfuscate the email fields that contain emails in the provided list.
        for(Lead ld : lds) {
            if(emails.contains(ld.Email)) { ld.Email = 'zzz@zzz.com'; }
            if(emails.contains(ld.Referrer_Email__c)) { ld.Referrer_Email__c = 'zzz@zzz.com'; }
        }
        if(lds.size() > 0) {
            update lds;
        }
    }

    private void obfuscateReferralEmails(Set<String> emails) {
        Id prospectRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
        Id techZoneProspectRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect (Tech-Zone)').getRecordTypeId();

        // Query Referrals that are either associated with a Lead or with a Prospect's contact, that have an email in the provided List.
        List<Referral__c> refs = [SELECT Id, Email__c FROM Referral__c
                                    WHERE (Referred_Lead__c != null OR
                                        Referred_Contact__r.Account.RecordTypeId =: prospectRecordTypeId OR
                                        Referred_Contact__r.Account.RecordTypeId =: techZoneProspectRecordTypeId) AND
                                        Email__c IN: emails];
        for(Referral__c ref : refs) {
            ref.Email__c = 'zzz@zzz.com';
        }
        if(refs.size() > 0) {
            update refs;
        }
    }

    private void obfuscatePhoneNumbers(Set<String> phoneNumbers) {
        obfuscateContactPhoneNumbers(phoneNumbers);
        obfuscateSupportPhoneNumbers(phoneNumbers);
        obfuscateLeadPhoneNumbers(phoneNumbers);
        obfuscateLeadStagingPhoneNumbers(phoneNumbers);
        obfuscateReferralPhoneNumbers(phoneNumbers);
    }

    private void obfuscateContactPhoneNumbers(Set<String> phoneNumbers) {
        // Convert the provided phone numbers to the proper format.
        Set<String> formattedPhoneNumbers = getFormattedPhoneNumbers(phoneNumbers, '(###) ###-####');
        Id prospectRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
        Id techZoneProspectRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect (Tech-Zone)').getRecordTypeId();
        List<String> acctRecordTypeIds = new List<String> { prospectRecordTypeId, techZoneProspectRecordTypeId };
        
        // In order to avoid query timeout errors, we separate the query into one for each phone field. We wil then concatenate the results together.
        List<Contact> cntcts1 = [SELECT Id, Phone, Fax, NPX_contact_phone_2__c, Phone1__c, Phone2__c, Phone3__c, OtherPhone, HomePhone,
                                 	AssistantPhone, MobilePhone, Phone1_Rep__c, Phone2_Rep__c, Phone3_Rep__c FROM Contact
                                	WHERE Account.RecordTypeId IN: acctRecordTypeIds AND Phone IN: formattedPhoneNumbers];
        List<Contact> cntcts2 = [SELECT Id, Phone, Fax, NPX_contact_phone_2__c, Phone1__c, Phone2__c, Phone3__c, OtherPhone, HomePhone,
                                 	AssistantPhone, MobilePhone, Phone1_Rep__c, Phone2_Rep__c, Phone3_Rep__c FROM Contact
                                	WHERE Account.RecordTypeId IN: acctRecordTypeIds AND Fax IN: formattedPhoneNumbers];
        List<Contact> cntcts3 = [SELECT Id, Phone, Fax, NPX_contact_phone_2__c, Phone1__c, Phone2__c, Phone3__c, OtherPhone, HomePhone,
                                 	AssistantPhone, MobilePhone, Phone1_Rep__c, Phone2_Rep__c, Phone3_Rep__c FROM Contact
                                	WHERE Account.RecordTypeId IN: acctRecordTypeIds AND NPX_contact_phone_2__c IN: formattedPhoneNumbers];
        List<Contact> cntcts4 = [SELECT Id, Phone, Fax, NPX_contact_phone_2__c, Phone1__c, Phone2__c, Phone3__c, OtherPhone, HomePhone,
                                 	AssistantPhone, MobilePhone, Phone1_Rep__c, Phone2_Rep__c, Phone3_Rep__c FROM Contact
                                	WHERE Account.RecordTypeId IN: acctRecordTypeIds AND Phone1__c IN: formattedPhoneNumbers];
        List<Contact> cntcts5 = [SELECT Id, Phone, Fax, NPX_contact_phone_2__c, Phone1__c, Phone2__c, Phone3__c, OtherPhone, HomePhone,
                                 	AssistantPhone, MobilePhone, Phone1_Rep__c, Phone2_Rep__c, Phone3_Rep__c FROM Contact
                                	WHERE Account.RecordTypeId IN: acctRecordTypeIds AND Phone2__c IN: formattedPhoneNumbers];
        List<Contact> cntcts6 = [SELECT Id, Phone, Fax, NPX_contact_phone_2__c, Phone1__c, Phone2__c, Phone3__c, OtherPhone, HomePhone,
                                 	AssistantPhone, MobilePhone, Phone1_Rep__c, Phone2_Rep__c, Phone3_Rep__c FROM Contact
                                	WHERE Account.RecordTypeId IN: acctRecordTypeIds AND Phone3__c IN: formattedPhoneNumbers];
        List<Contact> cntcts7 = [SELECT Id, Phone, Fax, NPX_contact_phone_2__c, Phone1__c, Phone2__c, Phone3__c, OtherPhone, HomePhone,
                                 	AssistantPhone, MobilePhone, Phone1_Rep__c, Phone2_Rep__c, Phone3_Rep__c FROM Contact
                                	WHERE Account.RecordTypeId IN: acctRecordTypeIds AND OtherPhone IN: formattedPhoneNumbers];
        List<Contact> cntcts8 = [SELECT Id, Phone, Fax, NPX_contact_phone_2__c, Phone1__c, Phone2__c, Phone3__c, OtherPhone, HomePhone,
                                 	AssistantPhone, MobilePhone, Phone1_Rep__c, Phone2_Rep__c, Phone3_Rep__c FROM Contact
                                	WHERE Account.RecordTypeId IN: acctRecordTypeIds AND HomePhone IN: formattedPhoneNumbers];
        List<Contact> cntcts9 = [SELECT Id, Phone, Fax, NPX_contact_phone_2__c, Phone1__c, Phone2__c, Phone3__c, OtherPhone, HomePhone,
                                 	AssistantPhone, MobilePhone, Phone1_Rep__c, Phone2_Rep__c, Phone3_Rep__c FROM Contact
                                	WHERE Account.RecordTypeId IN: acctRecordTypeIds AND AssistantPhone IN: formattedPhoneNumbers];
        List<Contact> cntcts10 = [SELECT Id, Phone, Fax, NPX_contact_phone_2__c, Phone1__c, Phone2__c, Phone3__c, OtherPhone, HomePhone,
                                 	AssistantPhone, MobilePhone, Phone1_Rep__c, Phone2_Rep__c, Phone3_Rep__c FROM Contact
                                	WHERE Account.RecordTypeId IN: acctRecordTypeIds AND MobilePhone IN: formattedPhoneNumbers];
        List<Contact> cntcts11 = [SELECT Id, Phone, Fax, NPX_contact_phone_2__c, Phone1__c, Phone2__c, Phone3__c, OtherPhone, HomePhone,
                                 	AssistantPhone, MobilePhone, Phone1_Rep__c, Phone2_Rep__c, Phone3_Rep__c FROM Contact
                                	WHERE Account.RecordTypeId IN: acctRecordTypeIds AND Phone1_Rep__c IN: formattedPhoneNumbers];
        List<Contact> cntcts12 = [SELECT Id, Phone, Fax, NPX_contact_phone_2__c, Phone1__c, Phone2__c, Phone3__c, OtherPhone, HomePhone,
                                 	AssistantPhone, MobilePhone, Phone1_Rep__c, Phone2_Rep__c, Phone3_Rep__c FROM Contact
                                	WHERE Account.RecordTypeId IN: acctRecordTypeIds AND Phone2_Rep__c IN: formattedPhoneNumbers];
        List<Contact> cntcts13 = [SELECT Id, Phone, Fax, NPX_contact_phone_2__c, Phone1__c, Phone2__c, Phone3__c, OtherPhone, HomePhone,
                                 	AssistantPhone, MobilePhone, Phone1_Rep__c, Phone2_Rep__c, Phone3_Rep__c FROM Contact
                                	WHERE Account.RecordTypeId IN: acctRecordTypeIds AND Phone3_Rep__c IN: formattedPhoneNumbers];

        // Concatenate the Lists of Contacts together. We make sure we don't add duplicates, in order to avoid update errors.
        List<Contact> contactsToUpdate = new list<Contact>();
        addRecordsExcludingDuplicates(contactsToUpdate, cntcts1);
        addRecordsExcludingDuplicates(contactsToUpdate, cntcts2);
        addRecordsExcludingDuplicates(contactsToUpdate, cntcts3);
        addRecordsExcludingDuplicates(contactsToUpdate, cntcts4);
        addRecordsExcludingDuplicates(contactsToUpdate, cntcts5);
        addRecordsExcludingDuplicates(contactsToUpdate, cntcts6);
        addRecordsExcludingDuplicates(contactsToUpdate, cntcts7);
        addRecordsExcludingDuplicates(contactsToUpdate, cntcts8);
        addRecordsExcludingDuplicates(contactsToUpdate, cntcts9);
        addRecordsExcludingDuplicates(contactsToUpdate, cntcts10);
        addRecordsExcludingDuplicates(contactsToUpdate, cntcts11);
        addRecordsExcludingDuplicates(contactsToUpdate, cntcts12);
        addRecordsExcludingDuplicates(contactsToUpdate, cntcts13);
        // We don't want to update portal (community) users.
        contactsToUpdate = getContactsWithPortalUsersFiltered(contactsToUpdate);
        // Obfuscate the phone fields that contain phone numbers in the provided list.
        for(Contact cntct : contactsToUpdate) {
            if(formattedPhoneNumbers.contains(cntct.Phone)) {
                cntct.Phone = '(000) 000-0000';
                cntct.Phone_Ext__c = null;
            }
            if(formattedPhoneNumbers.contains(cntct.Fax)) { cntct.Fax = '(000) 000-0000'; }
            if(formattedPhoneNumbers.contains(cntct.NPX_contact_phone_2__c)) { cntct.NPX_contact_phone_2__c = '(000) 000-0000'; }
            if(formattedPhoneNumbers.contains(cntct.Phone1__c)) { cntct.Phone1__c = '(000) 000-0000'; }
            if(formattedPhoneNumbers.contains(cntct.Phone2__c)) { cntct.Phone2__c = '(000) 000-0000'; }
            if(formattedPhoneNumbers.contains(cntct.Phone3__c)) { cntct.Phone3__c = '(000) 000-0000'; }
            if(formattedPhoneNumbers.contains(cntct.OtherPhone)) { cntct.OtherPhone = '(000) 000-0000'; }
            if(formattedPhoneNumbers.contains(cntct.HomePhone)) { cntct.HomePhone = '(000) 000-0000'; }
            if(formattedPhoneNumbers.contains(cntct.AssistantPhone)) { cntct.AssistantPhone = '(000) 000-0000'; }
            if(formattedPhoneNumbers.contains(cntct.MobilePhone)) { cntct.MobilePhone = '(000) 000-0000'; }
            if(formattedPhoneNumbers.contains(cntct.Phone1_Rep__c)) { cntct.Phone1_Rep__c = '(000) 000-0000'; }
            if(formattedPhoneNumbers.contains(cntct.Phone2_Rep__c)) { cntct.Phone2_Rep__c = '(000) 000-0000'; }
            if(formattedPhoneNumbers.contains(cntct.Phone3_Rep__c)) { cntct.Phone3_Rep__c = '(000) 000-0000'; }
        }

        if(contactsToUpdate.size() > 0) {
            update contactsToUpdate;
        }
    }

    private void obfuscateSupportPhoneNumbers(Set<String> phoneNumbers) {
        // Convert the provided phone numbers to the proper format.
        Set<String> formattedPhoneNumbers = getFormattedPhoneNumbers(phoneNumbers, '(###) ###-####');
        Id prospectRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
        Id techZoneProspectRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect (Tech-Zone)').getRecordTypeId();
        List<String> acctRecordTypeIds = new List<String> { prospectRecordTypeId, techZoneProspectRecordTypeId };

        // Query Support associated to a Prospect based on the phone number fields.
        List<Case> cases = [SELECT Id, Venue_Phone__c, AM_Contact_Phone__c, WRF_Decision_Maker_Phone__c, WRF_Eproc_Phone__c,
                            WRF_IT_Contact_Phone__c, AM_Contact_Fax__c, WRF_Consultant_Phone__c, SuppliedPhone, DUP_Requestor_Mobile__c
                            FROM Case
                            WHERE Account.RecordTypeId IN: acctRecordTypeIds AND
                            (Venue_Phone__c IN: formattedPhoneNumbers OR AM_Contact_Phone__c IN: formattedPhoneNumbers OR
                             WRF_Decision_Maker_Phone__c IN: formattedPhoneNumbers OR WRF_Eproc_Phone__c IN: formattedPhoneNumbers OR
                             WRF_IT_Contact_Phone__c IN: formattedPhoneNumbers OR AM_Contact_Fax__c IN: formattedPhoneNumbers OR
                             WRF_Consultant_Phone__c IN: formattedPhoneNumbers OR SuppliedPhone IN: formattedPhoneNumbers OR
                             DUP_Requestor_Mobile__c IN: formattedPhoneNumbers)];
        // Obfuscate the phone fields that contain phone numbers in the provided list.
        for(Case c : cases) {
            if(formattedPhoneNumbers.contains(c.Venue_Phone__c)) { c.Venue_Phone__c = '(000) 000-0000'; }
            if(formattedPhoneNumbers.contains(c.AM_Contact_Phone__c)) { c.AM_Contact_Phone__c = '(000) 000-0000'; }
            if(formattedPhoneNumbers.contains(c.WRF_Decision_Maker_Phone__c)) { c.WRF_Decision_Maker_Phone__c = '(000) 000-0000'; }
            if(formattedPhoneNumbers.contains(c.WRF_Eproc_Phone__c)) { c.WRF_Eproc_Phone__c = '(000) 000-0000'; }
            if(formattedPhoneNumbers.contains(c.WRF_IT_Contact_Phone__c)) { c.WRF_IT_Contact_Phone__c = '(000) 000-0000'; }
            if(formattedPhoneNumbers.contains(c.AM_Contact_Fax__c)) { c.AM_Contact_Fax__c = '(000) 000-0000'; }
            if(formattedPhoneNumbers.contains(c.WRF_Consultant_Phone__c)) { c.WRF_Consultant_Phone__c = '(000) 000-0000'; }
            if(formattedPhoneNumbers.contains(c.SuppliedPhone)) { c.SuppliedPhone = '(000) 000-0000'; }
            if(formattedPhoneNumbers.contains(c.DUP_Requestor_Mobile__c)) { c.DUP_Requestor_Mobile__c = '(000) 000-0000'; }
        }
        if(cases.size() > 0) {
            update cases;
        }
    }
    
    private void obfuscateLeadPhoneNumbers(Set<String> phoneNumbers) {
        // Convert the provided phone numbers to the proper format.
        Set<String> formattedPhoneNumbers = getFormattedPhoneNumbers(phoneNumbers, '(###) ###-####');
        // Query Leads based on the phone number fields.
        List<Lead> lds = [SELECT Id, Phone, Fax, MobilePhone FROM Lead
                            WHERE Phone IN: formattedPhoneNumbers OR Fax IN: formattedPhoneNumbers OR MobilePhone IN: formattedPhoneNumbers];
        // Obfuscate the phone fields that contain phone numbers in the provided list.
        for(Lead ld : lds) {
            if(formattedPhoneNumbers.contains(ld.Phone)) { ld.Phone = '(000) 000-0000'; }
            if(formattedPhoneNumbers.contains(ld.Fax)) { ld.Fax = '(000) 000-0000'; }
            if(formattedPhoneNumbers.contains(ld.MobilePhone)) { ld.MobilePhone = '(000) 000-0000'; }
        }
        if(lds.size() > 0) {
            update lds;
        }
    }
    
    private void obfuscateLeadStagingPhoneNumbers(Set<String> phoneNumbers) {
        // Convert the provided phone numbers to the proper format.
        Set<String> formattedPhoneNumbers = getFormattedPhoneNumbers(phoneNumbers, '(###) ###-####');
        List<LeadStaging__c> ldStaging = [SELECT Id, Phone__c FROM LeadStaging__c WHERE Phone__c IN: formattedPhoneNumbers];
        for(LeadStaging__c l : ldStaging) {
            l.Phone__c = '(000) 000-0000';
        }
        if(ldStaging.size() > 0) {
            update ldStaging;
        }
    }
    
    private void obfuscateReferralPhoneNumbers(Set<String> phoneNumbers) {
        // Convert the provided phone numbers to the proper format.
        Set<String> formattedPhoneNumbers = getFormattedPhoneNumbers(phoneNumbers, '(###) ###-####');
        Id prospectRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
        Id techZoneProspectRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect (Tech-Zone)').getRecordTypeId();

        // Query Referrals that are either associated with a Lead or with a Prospect's contact, that have a phone number in the provided List.
        List<Referral__c> refs = [SELECT Id, Phone__c FROM Referral__c
                                    WHERE (Referred_Lead__c != null OR
                                            Referred_Contact__r.Account.RecordTypeId =: prospectRecordTypeId OR
                                            Referred_Contact__r.Account.RecordTypeId =: techZoneProspectRecordTypeId) AND
                                    Phone__c IN: formattedPhoneNumbers];
        for(Referral__c ref : refs) {
            ref.Phone__c = '(000) 000-0000';
        }
        if(refs.size() > 0) {
            update refs;
        }
    }

    /**
     * Given a set of phone numbers and a specified format (#'s represent numbers. i.e. (###) ###-####),
     * returns a Set of phone numbers in the given format.
     */
    private Set<String> getFormattedPhoneNumbers(Set<String> phoneNumbers, String format) {
        Set<String> formattedNumbers = new Set<String>();
        for(String phoneNumber : phoneNumbers) {
            String formattedNumber = getFormattedPhoneNumber(phoneNumber, format);
            formattedNumbers.add(formattedNumber);
        }
        return formattedNumbers;
    }

    /**
     * Formats a phone number based on the specified format (#'s represent numbers. i.e. (###) ###-####)
     */
    private String getFormattedPhoneNumber(String phoneNumber, String format) {
        // Strips out any non-numerical characters in the phone number.
        String strippedPhoneNumber = getStrippedPhoneNumber(phoneNumber);

        String formattedPhoneNumber = '';
        Integer i = 0;
        Integer j = 0;
        while(i < strippedPhoneNumber.length() && j < format.length()) {
            if(format.substring(j, j+1) == '#') {
                formattedPhoneNumber = formattedPhoneNumber + strippedPhoneNumber.substring(i, i+1);
                i++;
            } else {
                formattedPhoneNumber = formattedPhoneNumber + format.substring(j, j+1);
            }
            j++;
        }
        return formattedPhoneNumber;
    }

    /**
     * Strips non-numerical characters from the given phone number.
     */
    private String getStrippedPhoneNumber(String phoneNumber) {
        String strippedNumber = '';
        for(Integer i = 0; i < phoneNumber.length(); i++) {
            String c = phoneNumber.substring(i, i+1);
            if(c == '0' || c == '1' || c == '2' || c == '3' || c == '4' || c == '5' || c == '6' || c == '7' || c == '8' || c == '9') {
                strippedNumber = strippedNumber + c;
            }
        }
        return strippedNumber;
    }
    
    /**
     * Appends the List newRecords to currentRecords, ensuring no duplicates are added.
     */
    private void addRecordsExcludingDuplicates(List<SObject> currentRecords, List<SObject> newRecords) {
        Set<String> ids = new Set<String>();
        for(SObject currentRecord : currentRecords) {
            ids.add(currentRecord.Id);
        }
        for(SObject newRecord : newRecords) {
            if(!ids.contains(newRecord.Id)) {
                currentRecords.add(newRecord);
                ids.add(newRecord.Id);
            }
        }
    }

    private List<String> getIds(List<SObject> records) {
        List<String> ids = new List<String>();
        for(SObject record : records) {
            ids.add(record.Id);
        }
        return ids;
    }

    /**
     * Given a list of Contacts, returns a List with portal (community) Users filtered out.
     */
    private List<Contact> getContactsWithPortalUsersFiltered(List<Contact> cntcts) {
        Set<String> contactIds = new Set<String>();
        for(Contact cntct : cntcts) { contactIds.add(cntct.Id); }

        // Portal Users have their ContactId field set with the associated Contact.
        List<User> portalUsers = [SELECT Id, ContactId FROM User WHERE ContactId IN: contactIds];
        
        // Create a Set of Contact IDs associated with portal Users.
        Set<String> portalContactIds = new Set<String>();
        for(User portalUser : portalUsers) { portalContactIds.add(portalUser.ContactId); }

        List<Contact> filteredContacts = new List<Contact>();
        for(Contact cntct : cntcts) {
            if(portalContactIds.contains(cntct.Id) == false) {
                filteredContacts.add(cntct);
            }
        }
        return filteredContacts;
    }

    /**
     * Updates the Sales and Marketing Cloud statuses of the given CCPA Actions and associated CCPA Requests.
     * Note that all Actions will be marked as complete.
     */
    private void updateStatuses(List<CCPA_Action__c> actions) {
        updateActionStatuses(actions);
        updateRequestStatuses(actions);
    }

    /**
     * We mark ALL given Actions as complete. 
     */
    private void updateActionStatuses(List<CCPA_Action__c> actions) {
        for(CCPA_Action__c action : actions) {
            action.Sales_Cloud_Complete__c = true;
        }
        update actions;
    }

    /**
     * We mark CCPA Requests complete that have all associated CCPA Actions marked as complete.
     * This is done separately for Sales Cloud and Marketing Cloud status fields.
     */
    private void updateRequestStatuses(List<CCPA_Action__c> actions) {
        Map<String, CCPA_Request__c> requestsMappedById = getRequestsMappedById(actions);

        // This must be done because it is possible (or likely depending on the batch size)
        // that not all Actions associated with these Requests will be here in the local
        // context. We need to make sure we pull in all of them to properly check their status.
        List<CCPA_Action__c> actionsForRequests = getActionsForRequests(requestsMappedById);

        Map<String, List<CCPA_Action__c>> actionsMappedByRequestId = getActionsMappedByRequestId(actionsForRequests);

        updateSalesCloudRequestStatuses(actionsMappedByRequestId, requestsMappedById);
        updateMarketingCloudRequestStatuses(actionsMappedByRequestId, requestsMappedById);
    }

    /**
     * Given a set of CCPA Actions, returns all associated CCPA Requests mapped by their SFDC ID.
     */
    private Map<String, CCPA_Request__c> getRequestsMappedById(List<CCPA_Action__c> actions) {
        List<CCPA_Request__c> requests = getRequests(actions);

        Map<String, CCPA_Request__c> requestsMappedById = new Map<String, CCPA_Request__c>();
        for(CCPA_Request__c request : requests) {
            requestsMappedById.put(request.Id, request);
        }
        return requestsMappedById;
    }
    
    /**
     * Retrieves the CCPA Requests associated with the given CCPA Actions.
     */
    private List<CCPA_Request__c> getRequests(List<CCPA_Action__c> actions) {
        Set<String> requestIds = new Set<String>();
        for(CCPA_Action__c action : actions) {
            requestIds.add(action.CCPA_Request__c);
        }
        List<CCPA_Request__c> requests = [
            SELECT Id, Sales_Cloud_Complete__c, Sales_Cloud_Delete_Timestamp__c,
                    Marketing_Cloud_Complete__c, Marketing_Cloud_Delete_Timestamp__c
            FROM CCPA_Request__c WHERE Id IN: requestIds];
        return requests;
    }

    /**
     * Given a Map of Requests with the SFDC ID as the key, returns all associated CCPA Actions.
     */
    private List<CCPA_Action__c> getActionsForRequests(Map<String, CCPA_Request__c> requestsMappedById) {
        Set<String> requestIds = requestsMappedById.keySet();
        List<CCPA_Action__c> actions = [
            SELECT Id, Sales_Cloud_Complete__c, Marketing_Cloud_Status__c, CCPA_Request__c
            FROM CCPA_Action__c WHERE CCPA_Request__c IN: requestIds];
        return actions;
    }

    /**
     * Given a List of CCPA Actions, returns a Map with Key: CCPA Request SFDC ID, Value: CCPA Action.
     */
    private Map<String, List<CCPA_Action__c>> getActionsMappedByRequestId(List<CCPA_Action__c> actionsForRequests) {
        Map<String, List<CCPA_Action__c>> actionsMappedByRequestId = new Map<String, List<CCPA_Action__c>>();
        for(CCPA_Action__c action : actionsForRequests) {
            if(!actionsMappedByRequestId.containsKey(action.CCPA_Request__c)) {
                actionsMappedByRequestId.put(action.CCPA_Request__c, new List<CCPA_Action__c>());
            }
            actionsMappedByRequestId.get(action.CCPA_Request__c).add(action);
        }
        return actionsMappedByRequestId;
    }

    /**
     * Given Lists of Actions mapped by their Request SFDC ID, and Requests mapped by their SFDC ID,
     * checks if the Requests are Sales Cloud complete. If so, sets the Sales Cloud Complete
     * flag to true, and sets the Sales Cloud Delete timestamp.
     */
    private void updateSalesCloudRequestStatuses(Map<String, List<CCPA_Action__c>> actionsMappedByRequestId, Map<String, CCPA_Request__c> requestsMappedById) {
        List<CCPA_Request__c> requestsToUpdate = new List<CCPA_Request__c>();
        Datetime dt = Datetime.now();
        for(String requestId : actionsMappedByRequestId.keySet()) {
            CCPA_Request__c request = requestsMappedById.get(requestId);
            if(request.Sales_Cloud_Complete__c != true && requestSalesCloudComplete(actionsMappedByRequestId, requestId)) {
                request.Sales_Cloud_Complete__c = true;
                request.Sales_Cloud_Delete_Timestamp__c = dt;
                requestsToUpdate.add(request);
            }
        }
        update requestsToUpdate;
    }

    /**
     * Given Lists of Actions mapped by their Request SFDC ID, and a Request SFDC ID,
     * determines whether the Request is Sales Cloud complete or not. Returns a Boolean value accordingly.
     */
    private Boolean requestSalesCloudComplete(Map<String, List<CCPA_Action__c>> actionsMappedByRequestId, String requestId) {
        List<CCPA_Action__c> actions = actionsMappedByRequestId.get(requestId);
        Boolean complete = true;
        for(CCPA_Action__c action : actions) {
            if(action.Sales_Cloud_Complete__c == false) {
                complete = false;
            }
        }
        return complete;
    }

    /**
     * Given Lists of Actions mapped by their Request SFDC ID, and Requests mapped by their SFDC ID,
     * checks if the Requests are Marketing Cloud complete. If so, sets the Marketing Cloud Complete
     * flag to true, and sets the Marketing Cloud Delete timestamp.
     */
    private void updateMarketingCloudRequestStatuses(Map<String, List<CCPA_Action__c>> actionsMappedByRequestId, Map<String, CCPA_Request__c> requestsMappedById) {
        List<CCPA_Request__c> requestsToUpdate = new List<CCPA_Request__c>();
        Datetime dt = Datetime.now();
        for(String requestId : actionsMappedByRequestId.keySet()) {
            CCPA_Request__c request = requestsMappedById.get(requestId);
            if(request.Marketing_Cloud_Complete__c != true && requestMarketingCloudComplete(actionsMappedByRequestId, requestId)) {
                request.Marketing_Cloud_Complete__c = true;
                request.Marketing_Cloud_Delete_Timestamp__c = dt;
                requestsToUpdate.add(request);
            }
        }
        update requestsToUpdate;
    }

    /**
     * Given Lists of Actions mapped by their Request SFDC ID, and a Request SFDC ID,
     * determines whether the Request is Marketing Cloud complete or not. Returns a Boolean value accordingly.
     */
    private Boolean requestMarketingCloudComplete(Map<String, List<CCPA_Action__c>> actionsMappedByRequestId, String requestId) {
        List<CCPA_Action__c> actions = actionsMappedByRequestId.get(requestId);
        Boolean complete = true;
        for(CCPA_Action__c action : actions) {
            if(action.Marketing_Cloud_Status__c != 'Completed' && action.Marketing_Cloud_Status__c != 'No Action') {
                complete = false;
            }
        }
        return complete;
    }

    global void finish(Database.BatchableContext bc) {}

    global void execute(SchedulableContext sc) {
        Database.executeBatch(new CCPA_Process_Delete_Requests_Batch(), 1);
    }
}
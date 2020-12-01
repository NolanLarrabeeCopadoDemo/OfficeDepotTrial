public with sharing class SearchOrCreateSiteContact {

    class CreateSiteContactException extends Exception {}

    @AuraEnabled
    public static SiteContacts__c createSiteExistingContact(
        String site_account_id, String contact_id){
        SiteContacts__c my_site_contact = new SiteContacts__c(
            Account__c=site_account_id, Contact__c=contact_id);
        try{
            insert my_site_contact;
        } catch (Exception e) {
            throw new AuraHandledException(
                      'Creating the new Site Contact failed: ' + e);
        }

        return my_site_contact;
    }

    @AuraEnabled
    public static Account getSiteInfo(String site_account_id){
        Account site_account = [
            SELECT 
                Id, 
                ParentId,
                Related_Account__c 
            FROM Account 
            WHERE Id = :site_account_id 
            LIMIT 1
        ];
        System.debug(LoggingLevel.INFO, site_account);
        return site_account;
    }

    @AuraEnabled
    public static List<Contact> getSiteContacts(String account_id, String site_account_id){

        Map<Id, Contact> my_contacts = new Map<Id, Contact>([
            SELECT 
                Id, 
                Name, 
                Title, 
                Decision_Maker__c, 
                Role__c, 
                Email, 
                Phone, 
                Phone_Ext__c, 
                MobilePhone, 
                LastActivityDate 
            FROM Contact 
            WHERE AccountId =: account_id ORDER BY Name
        ]);
        List<SiteContacts__c> site_contacts = [
            SELECT 
                Id,
                Name,
                Account__c,
                Contact__c 
            FROM SiteContacts__c 
            WHERE Contact__c IN :my_contacts.keySet() AND Account__c =: site_account_id
        ];

        Set<Id> contact_ids = new Set<Id>();
        for(SiteContacts__c site: site_contacts)
           contact_ids.add(site.Contact__c);

        List<Contact> my_contacts_list = new List<Contact>();

        for (Id cont: my_contacts.keySet())
            if(contact_ids.contains(cont))
                my_contacts_list.add(my_contacts.get(cont));

        System.debug(LoggingLevel.INFO, my_contacts);
        return my_contacts_list;
    }

    @AuraEnabled
    public static SiteContacts__c createSiteNewContact(String site_account_id,
                                                       Contact contact_data){
        contact_data.Override_Duplicate_Check__c = true;
        Account site_account = [
            SELECT 
                Id, 
                Related_Account__c,
                RecordType.DeveloperName 
            FROM Account 
            WHERE Id = :site_account_id 
            LIMIT 1
        ];
        contact_data.AccountId = site_account.Related_Account__c;

        Map<String,Schema.RecordTypeInfo> recordtype_describe =
            Schema.getGlobalDescribe().get('Contact').getDescribe().
            getRecordTypeInfosByDeveloperName();

        Id us_contact;

        if (site_account.RecordType.DeveloperName == 'Site') {
            contact_data.RecordTypeId =
                recordtype_describe.get('Contact_US').getRecordTypeId();

        } else if (site_account.RecordType.DeveloperName == 'Site_GT') {
            contact_data.RecordTypeId =
                recordtype_describe.get('GT_Contact').getRecordTypeId();
        } else {
            throw new CreateSiteContactException(
                      'Creatings sites for ' + site_account.RecordType.DeveloperName +
                      ' is not supported.');
        }

        try{
            insert contact_data;
        } catch (Exception e) {
            throw new AuraHandledException('' + e);
        }

        SiteContacts__c my_site_contact = new SiteContacts__c(
            Account__c=site_account_id, Contact__c=contact_data.Id);
        try{
            insert my_site_contact;
        } catch (Exception e) {
            throw new AuraHandledException(
                      'Creating the new Site Contact failed:  ' + e);
        }

        return my_site_contact;
    }

}
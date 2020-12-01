// Apex Class for the RelatedLeads lightning component on the Lead record page
public with sharing class RelatedLeads {

    @AuraEnabled(cacheable = true)
    public static List<Lead> getLeads(String recId, String masterLead) {
        String searchId;

        // If lead has master then get all other leads with the master lead
        if ( !String.isBlank(masterLead) ) { 
            searchId = masterLead;
        } else { 
            // If lead does not have master it might be a parent, search for leads that have it as parent
            searchId = recId;
        }

        List<Lead> leads = [SELECT Id, Name, FirstName, Master_Lead__r.Name, Company, Phone, Email, Address, State__c, Address1__c, Address2__c, City__c, Industry, 
        LeadSource, Owner.Name, Status, Notes__c, Comments__c, Record_Page_Link__c FROM Lead WHERE Master_Lead__c = :searchId];

        if ( !leads.isEmpty() ) {
            return leads;
        } else {
            return null;
        }
    }

    @AuraEnabled(cacheable = true)
    public static Boolean writeLead() {
        Lead newLead = new Lead();
        return true;
    }
}
@RestResource(urlMapping='/Lead/*')
global with sharing class LeadWebService {

    @HttpPost
    global static ID createLead(String firstname, String lastname,
            String companyname, string email, string source, string address1, string address2,
            string city, string state, string zip, string phone, string product, string externalrefid,string campaign_url, string companysize, string website) {
        String finSource;
        if (source == null) {
            finSource = 'BizBox Web';
        } else {
            finSource = source;
        }
        LeadStaging__c thisLeadStaging = new LeadStaging__c(
                First_Name__c = firstname,
                Last_Name__c = lastname,
                Company__c = companyname,
                Email__c = email,
                Source__c = finSource,
                State__c = state,
                Address1__c = address1,
                Address2__c = address2,
                Zip__c = zip,
                City__c = city,
                Phone__c = phone,
                Product__c = product,
                ExternalRefID__c = externalrefid,
                URL_Reference__c = campaign_url,
                Website__c = website,
                company_size__c = companysize


        );
        thisLeadStaging.Status__c = 'Staged';
        insert thisLeadStaging;
        return thisLeadStaging.Id;
    }
}
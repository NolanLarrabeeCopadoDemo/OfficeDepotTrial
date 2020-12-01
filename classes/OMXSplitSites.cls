global class OMXSplitSites {
 
 webservice static siteResponse getSplitSites (ID sfAcctID) {
   
   siteResponse PartySiteIDs = new siteResponse ();
   list<String> psIds = new list<String>();
   system.debug('Inside SiteResponse');
   Prospect_message__c pm = [select account__c from prospect_message__c where id = :sfAcctID];
   for (Account a: [select id,related_account__r.oracle_party_id__c,oracle_party_site_id__c,omx_primary_key__c from account where related_account__c = :pm.account__c and Split_Record__c = false]) {
       
       if (a.related_account__r.oracle_party_id__c == null) {
         system.debug('Party IDs not found for SFDC ID - ' + sfAcctID);
         break;
       }
       else if (PartySiteIDs.oracle_party_id == null) {
         PartySiteIDs.oracle_party_id = a.related_account__r.oracle_party_id__c;
         system.debug('Party ID Found - ' + PartySiteIDs.oracle_party_id);
       }
       
       if (a.oracle_party_site_id__c != null && !a.omx_primary_key__c.contains('OMX'))
        psIds.add(a.oracle_party_site_id__c);

   }
   if (psIds.size() > 0) {
     PartySiteIDs.oracle_party_sites = psIds;
     system.debug('PartySites Found - Total Sites:' +  psIds.size());
  }
   
   return PartySiteIDs;
 }
 
 global class siteResponse {
    webservice String ORACLE_PARTY_ID;
    webservice List<String> ORACLE_PARTY_SITES;
  }
}
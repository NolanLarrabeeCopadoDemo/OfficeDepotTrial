global class OMXsiteSplitStatus {
 
 webservice static boolean getSplitSites (String partyID,String statusCode, String statusMessage) {
   account a = [select id,Mod_5_EBS_Sync_Error__c,Mod_5_EBS_Sync_Status__c from account where oracle_party_id__c = :partyid];
   a.Mod_5_EBS_Sync_Status__c = statusCode;
   if (statusMessage != null) {
    if (statusMessage.length() > 5000)
     a.Mod_5_EBS_Sync_Error__c = statusMessage.substring(0,5000);
    else
     a.Mod_5_EBS_Sync_Error__c = statusMessage;
   }
   update a;
   return true;
 }
 
}
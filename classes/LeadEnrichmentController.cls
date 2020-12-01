/**
* CreatedBy: Shravya Channamadhavuni
* Date:04/01/2019
* Description: Lead enrichment class is about retrieveing the D & B data and populating it on the fields
*/

public class LeadEnrichmentController {
    
    @AuraEnabled
    public static List < Org__c > retrieveDBData(String recordid) {
        Map < String, String > mapOfValues = new Map < String, String > ();
        List < AggroMatchResultV2 > lstOfAggroResults = new List < AggroMatchResultV2 > ();
         List < Org__c > lstOfOrgs = new List < Org__c > ();
        String Fullname;
        String Address;
        String employyecount;
        String primaryIndustry;
        String Phone;
        String ceoname;
        System.debug('Record Id from component is:' + recordid);
        Lead l = [select Company, city__c, Address1__c, State__c, Zip__c from lead where id =: recordid];
        // Getting the results from the service
        lstOfAggroResults =AggroServiceRunner.search_for_matches(l.Company, l.Address1__c, l.City__c, l.State__c, l.Zip__c);
        for(AggroMatchResultV2 orgs:lstOfAggroResults) {
          lstOfOrgs.add(orgs.toOrg());
        }
       system.debug('Lead D&b data:'+lstOfOrgs);
         return lstOfOrgs;
      
    }
}
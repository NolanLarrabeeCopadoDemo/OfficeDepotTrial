public class SalesHistoryTriggers {

    public static void beforeUpsert(List<Sales_History__c> triggerNew) {
        List<string> omxKeys = new List<string>();
        
        // Get OMX primary keys
        for (Sales_History__c sh : triggerNew) {        
            omxKeys.add(sh.OMX_Primary_Key__c);     
        }
    
        // Get customer transitions and accounts
        Map<string, Id> acctsMap = new Map<string, Id>();
        Map<string, Id> custTransMap = new Map<string, Id>();
         
        for (Customer_Transition__c ct : [SELECT Id, OMX_Primary_Key__c, Account__r.Id FROM Customer_Transition__c WHERE OMX_Primary_Key__c IN :omxKeys]) {
            acctsMap.put(ct.OMX_Primary_Key__c, ct.Account__r.Id);
            custTransMap.put(ct.OMX_Primary_Key__c, ct.Id);
        }
        
        // Get crossreference (Story #582322)
        Map<string, OfficeMax_OfficeDepot_Crossreference__c> selectedXrefs = new Map<string, OfficeMax_OfficeDepot_Crossreference__c>();
        List<OfficeMax_OfficeDepot_Crossreference__c> xRefs = [SELECT OMX_Key__c, Source_Desc__c, Created_Date__c, LastModifiedDate 
                                                               FROM OfficeMax_OfficeDepot_Crossreference__c 
                                                               WHERE OMX_Key__c IN :omxKeys
                                                               ORDER BY LastModifiedDate DESC];
        
        for (OfficeMax_OfficeDepot_Crossreference__c xref : xRefs) {
            if (!selectedXrefs.containsKey(xref.OMX_Key__c)) {
                selectedXrefs.put(xref.OMX_Key__c, xref);
            }
        }
        // End Story #582322
        
        // Set IDs in Sales History object
        for (Sales_History__c sh : triggerNew) {        
            sh.Account__c = acctsMap.get(sh.OMX_Primary_Key__c);
            sh.Customer_Transition__c = custTransMap.get(sh.OMX_Primary_Key__c);
            
            // Set crossref in Sales History object (Story #582322)
            if (selectedXrefs.containsKey(sh.OMX_Primary_Key__c)) {
                sh.Xref_Source__c = selectedXrefs.get(sh.OMX_Primary_Key__c).Source_Desc__c;
                sh.Xref_Created_Date__c = selectedXrefs.get(sh.OMX_Primary_Key__c).Created_Date__c;
                sh.Xref_Updated_Date__c = (selectedXrefs.get(sh.OMX_Primary_Key__c).LastModifiedDate).date();
            }
            // End Story #582322
        }
    }
    //copied from production
    public static void beforeInsert(List<Sales_History__c> triggerNew) {
        List<string> omxKeys = new List<string>();
        
        // Get OMX primary keys
        for (Sales_History__c sh : triggerNew) {        
            omxKeys.add(sh.OMX_Primary_Key__c);     
        }
    
        // Get customer transitions and accounts
        Map<string, Id> acctsMap = new Map<string, Id>();
        Map<string, Id> custTransMap = new Map<string, Id>();
         
        for (Customer_Transition__c ct : [SELECT Id, OMX_Primary_Key__c, Account__r.Id FROM Customer_Transition__c WHERE OMX_Primary_Key__c IN :omxKeys]) {
            acctsMap.put(ct.OMX_Primary_Key__c, ct.Account__r.Id);
            custTransMap.put(ct.OMX_Primary_Key__c, ct.Id);
        }
        
        // Set IDs in Sales History object
        for (Sales_History__c sh : triggerNew) {        
            sh.Account__c = acctsMap.get(sh.OMX_Primary_Key__c);
            sh.Customer_Transition__c = custTransMap.get(sh.OMX_Primary_Key__c);
        }
    }
}
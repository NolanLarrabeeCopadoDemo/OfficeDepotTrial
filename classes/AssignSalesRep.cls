// Class to Update Sales Reps based on owner Change
public without sharing class AssignSalesRep {
    public static void updateLeadSalesRep(List<Lead> leadOwnerChange) {
    	List<Id> ownerId = new List<Id>();
        
        for (Lead l : leadOwnerChange) {
            ownerId.add(l.ownerId);
        }
        
        // Get Users and related Sales Person
		Map<Id, Id> userToSalesperson = new Map<Id, Id>();
        for (Sales_Person__c sp : [SELECT User__c, Id FROM Sales_Person__c WHERE User__c IN :ownerId AND IsActive__c = TRUE AND Primary__c = TRUE]) {
            userToSalesperson.put(sp.User__c, sp.Id);
        }
        
        // Assign Sales Persons to Leads
		for (Lead l : leadOwnerChange) {
            if (userToSalesperson.containsKey(l.ownerId)) {
            	l.Sales_Person_ID__c = userToSalesperson.get(l.ownerId);
            }
            else {
                l.Sales_Person_ID__c = null;
            }
        }
    }
}
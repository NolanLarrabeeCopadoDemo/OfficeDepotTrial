public class SharingUtils {
    
    public static Map<Id, Id> getMasterAccountGroupsForLeads(List<Lead> leads) {
        
        Set<Id> leadsToQuery = new Set<Id>(); 
        for (Lead currentLead : leads) {
            leadsToQuery.add(currentLead.Id); 
        }
          
        Map<Id,Id> leadsToParentAccounts = new Map<Id,Id>(); 
        List<Lead> leadsWithParentAccountNames = [Select Id, Sub_Agent__r.Parent.Id, Sub_Agent__r.Parent.Sharing_Group__c from Lead where Id in :leadsToQuery];  
        system.debug('leads retrieved: ' + leadsWithParentAccountNames); 
        Set<String> groupNames = new Set<String>(); 
        Map<Id, String> accountIdsToGroupNames = new Map<Id, String>(); 
        for (Lead currentLead : leadsWithParentAccountNames) {
            String accountId = currentLead.Sub_Agent__r.Parent.Id; 
            String groupName = currentLead.Sub_Agent__r.Parent.Sharing_Group__c;
            system.debug('account id: ' + accountId);
            system.debug('group name: ' + groupName); 
            if (!String.isEmpty(accountId) && !String.isEmpty(groupName)) {
            	accountIdsToGroupNames.put(currentLead.Sub_Agent__r.Parent.Id, currentLead.Sub_Agent__r.Parent.Sharing_Group__c); 
            	groupNames.add(currentLead.Sub_Agent__r.Parent.Sharing_Group__c);
            }
        }
        Map<String, Id> groupNamesToIds = getGroupsForMasterAccounts(groupNames);
		         
        Map<Id,Id> leadsToGroups = new Map<Id,Id>(); 
        for (Lead currentLead : leadsWithParentAccountNames) {
        	String masterAccountId = currentLead.Sub_Agent__r.Parent.Id;
		    Id leadId = currentLead.Id; 
            if (!String.isEmpty(masterAccountId)) {
                String groupName = accountIdsToGroupNames.get(masterAccountId); 
            	Id groupId = groupNamesToIds.get(groupName); 
                leadsToGroups.put(leadId, groupId); 
            }
        }
        
        return leadsToGroups; 
    }
    
    public static Map<Id, Id> getMasterAccountGroupsForOpportunities(List<Opportunity> opps) {
        Set<Id> oppsToQuery = new Set<Id>(); 
        for (Opportunity currentOpp : opps) {
            oppsToQuery.add(currentOpp.Id); 
        }
          
        List<Opportunity> oppsWithParentAccountInfo = 
            [Select Id, Partner_Sub_Agent_Account__r.Parent.Id, Partner_Sub_Agent_Account__r.Parent.Sharing_Group__c from Opportunity where Id in :oppsToQuery];  
        
        Set<String> groupNames = new Set<String>(); 
        Map<Id, String> accountIdsToGroupNames = new Map<Id, String>(); 
        for (Opportunity currentOpp : oppsWithParentAccountInfo) {
            String accountId = currentOpp.Partner_Sub_Agent_Account__r.Parent.Id; 
            String groupName = currentOpp.Partner_Sub_Agent_Account__r.Parent.Sharing_Group__c;
            system.debug('account id: ' + accountId);
            system.debug('group name: ' + groupName); 
            if (!String.isEmpty(accountId) && !String.isEmpty(groupName)) {
            	accountIdsToGroupNames.put(currentOpp.Partner_Sub_Agent_Account__r.Parent.Id, currentOpp.Partner_Sub_Agent_Account__r.Parent.Sharing_Group__c); 
            	groupNames.add(currentOpp.Partner_Sub_Agent_Account__r.Parent.Sharing_Group__c);
            }
        }
        Map<String, Id> groupNamesToIds = getGroupsForMasterAccounts(groupNames);
		         
        Map<Id,Id> oppsToGroups = new Map<Id,Id>(); 
        for (Opportunity currentOpp : oppsWithParentAccountInfo) {
        	String masterAccountId = currentOpp.Partner_Sub_Agent_Account__r.Parent.Id;
		    Id oppId = currentOpp.Id; 
            if (!String.isEmpty(masterAccountId)) {
                String groupName = accountIdsToGroupNames.get(masterAccountId); 
            	Id groupId = groupNamesToIds.get(groupName); 
                oppsToGroups.put(oppId, groupId); 
            }
        }
        return oppsToGroups; 
    }
    
    public static Map<String, Id> getGroupsForMasterAccounts(Set<String> groupNames) {
        List<Group> groups = ([ Select Id, Name from Group where Name in: groupNames]); 
        Map<String, Id> groupNameToId = new Map<String,Id>(); 
        for (Group currentGroup : groups) {
            groupNameToId.put(currentGroup.Name, currentGroup.Id); 
        }
        return groupNameToId; 
    }
    
}
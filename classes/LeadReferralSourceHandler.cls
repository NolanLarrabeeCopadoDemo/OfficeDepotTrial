/*
 * Handler for LeadReferralSourceTrigger.  
 * Processes changes to Leads and copies values to Referral object where Lead in Resulting_Lead__c field on Referral.
 * Skips processing of Leads converted into an Opportunity OR where Referral already has an Opportunity in the  Resulting_Opportunity__c field.
 * Also used by other classes to set the Lead ID on the Referral object.
 *
 * @author: Andrew Smith (6/10/2018)
 */ 
 
 public without sharing class LeadReferralSourceHandler {
    
    public void processLeads(Map<Id, Lead> oldRecMap, Map<Id, Lead> newRecMap){     
        List<Lead> changedLeads = new List<Lead>();
        Map<Id, Lead> referralToAllLeadMap = new Map<Id, Lead>();
        Map<Id, Lead> referralToConvertedLeadMap = new Map<Id, Lead>();
        Map<Id, Lead> referralToNonConvertedLeadMap = new Map<Id, Lead>();
        
        changedLeads = getChangedLeads(oldRecMap, newRecMap);       
        referralToAllLeadMap = getReferralToLeadMap(changedLeads);
        
        referralToConvertedLeadMap = getReferralToConvertedLeadMap(referralToAllLeadMap);
        referralToNonConvertedLeadMap = getReferralToNonConvertedLeadMap(referralToAllLeadMap);
        
        setReferralConvertedOppIds(referralToConvertedLeadMap);
        setReferralLeadValues(referralToNonConvertedLeadMap);       
    }
    
    public List<Lead> getChangedLeads(Map<Id, Lead> oldRecMap, Map<Id, Lead> newRecMap){
        List<Lead> changedLeads =  new List<Lead>();
    
        for(Lead ld : newRecMap.values()){
            if( ld.isConverted != oldRecMap.get(ld.Id).isConverted || 
                ld.Status != oldRecMap.get(ld.Id).Status || 
                ld.OwnerId != oldRecMap.get(ld.Id).OwnerId || 
                ld.Close_Reason__c != oldRecMap.get(ld.Id).Close_Reason__c || 
                ld.Unqualified_Reason__c != oldRecMap.get(ld.Id).Unqualified_Reason__c
               ){
                    changedLeads.add(ld);
            }
        }
        
        return changedLeads;    
    }
    
    // Method filters out leads not connected to a referral record.  
    // Also filters out leads already converted to an opportunity OR where the referral has an opportunity record.  
    public Map<Id, Lead> getReferralToLeadMap(List<Lead> newRecs){
        Map<Id, Lead> referralLeadMap = new Map<Id, Lead>();
        Map<Id, Lead> leadMap = new Map<Id, Lead>();
        
        if(newRecs.isEmpty()){
            return referralLeadMap;
        }   
        
        for(Lead ld : newRecs){
            leadMap.put(ld.Id, ld);
        }
        
        List<Referral__c> referrals = new List<Referral__c>([SELECT Id, Resulting_Lead__c FROM Referral__c WHERE Resulting_Lead__c IN :leadMap.keyset() AND Resulting_Opportunity__c = NULL]);
        
        for(Referral__c ref : referrals){
            referralLeadMap.put(ref.Id, leadMap.get(ref.Resulting_Lead__c));
        }
        
        return referralLeadMap;
    }
    
    // Method returns newly converted leads WITH a converted opportunity.
    // These will only be processed once as future lead update invocations will filter them out in the getReferralToLeadMap() call based on Resulting_Opportunity__c.
    public Map<Id, Lead> getReferralToConvertedLeadMap(Map<Id, Lead> referralLeadMap){
        Map<Id, Lead> referralToConvertedLeadMap = new Map<Id, Lead>();
        
        if(referralLeadMap.isEmpty()){
            return referralToConvertedLeadMap;
        }
        
        for(Id refId : referralLeadMap.keySet()){
            Lead ld = referralLeadMap.get(refId);
    
            if(ld.ConvertedOpportunityId != NULL){
                referralToConvertedLeadMap.put(refId, ld);
            }
        }
        
        return referralToConvertedLeadMap;
    }
    
    // Method return can include converted leads WITHOUT a converted opportunity.  
    public Map<Id, Lead> getReferralToNonConvertedLeadMap(Map<Id, Lead> referralLeadMap){
        Map<Id, Lead> referralToNonConvertedLeadMap = new Map<Id, Lead>();
        
        if(referralLeadMap.isEmpty()){
            return referralToNonConvertedLeadMap;
        }
        
        for(Id refId : referralLeadMap.keySet()){
            Lead ld = referralLeadMap.get(refId);
            
            if(ld.ConvertedOpportunityId == NULL){
                referralToNonConvertedLeadMap.put(refId, ld);
            }
        }
        
        return referralToNonConvertedLeadMap;
    }
    
    public void setReferralConvertedOppIds(Map<Id, Lead> referralLeadMap){
        if(referralLeadMap.isEmpty()){
            return;
        }
        
        Map<Id, Id> referralToOppIdMap = new Map<Id, Id>();
        
        for(Id refId : referralLeadMap.keySet()){
            referralToOppIdMap.put(refId, referralLeadMap.get(refId).ConvertedOpportunityId);
        }
        
        OppReferralSourceHandler handler = new OppReferralSourceHandler();
        handler.setReferralOppId(referralToOppIdMap); 
        
    }
        
    public void setReferralLeadValues(Map<Id, Lead> referralLeadMap){
        if(referralLeadMap.isEmpty()){
            return;
        }
        
        List<Referral__c> referralsToUpdate = new List<Referral__c>();
                
        Set<Id> userIds = new Set<Id>();
        Set<Id> queueIds = new Set<Id>();
        
        for(Id refId : referralLeadMap.keySet()){
            Lead relatedLead = referralLeadMap.get(refId);
            
            if(String.valueOf(relatedLead.OwnerId).startsWith('00G')){
                queueIds.add(relatedLead.OwnerId);
            }
            else{
                userIds.add(relatedLead.OwnerId);
            }
        }
        
        Map<ID, User> userMap = new Map<ID, User>([SELECT Id, Name, Phone, Email FROM User WHERE ID IN :userIds]);
        Map<ID, Group> queueMap = new Map<ID, Group>([SELECT Id, Name FROM Group WHERE ID IN :queueIds]);   
        
        for(Id refId : referralLeadMap.keySet()){ 
            Lead ld = referralLeadMap.get(refId);
            
            Referral__c ref = new Referral__c();
            
            ref.Id = refId;
            ref.Resulting_Lead__c = ld.Id;
            
            if(ld.Unqualified_Reason__c == NULL){
                ref.Loss_No_Action_Reason__c = ld.Close_Reason__c;
            }
            else{
                ref.Loss_No_Action_Reason__c = ld.Unqualified_Reason__c;
            }
            
            if(String.valueOf(ld.OwnerId).startsWith('00G')){   
                ref.Rep_Name__c = 'Queue: ' + queueMap.get(ld.OwnerId).Name; 
                ref.Rep_Phone__c = NULL;
                ref.Rep_Email__c = NULL;
            }
            else if(userMap.containsKey(ld.OwnerId)){
                ref.Rep_Name__c =  userMap.get(ld.OwnerId).Name; 
                ref.Rep_Phone__c = userMap.get(ld.OwnerId).Phone;
                ref.Rep_Email__c = userMap.get(ld.OwnerId).Email;
            }
            else{
                ref.Rep_Name__c = 'To Be Assigned';
            }
            
            //Status of "Closed" is for all record types except Tech-Zone.  "Unqualified" is for Tech-Zone.  
            if(ld.Status != 'Closed' && ld.Status != 'Unqualified' && ld.Status != 'Converted'){   
                ref.Status__c = 'Working';
            }
            else if(ld.Status == 'Closed' && ld.Close_Reason__c == 'Duplicate Record'){  
                ref.Status__c = 'Duplicate';
            }
            else if(ld.Status == 'Closed' || ld.Status == 'Unqualified' || ld.Status == 'Converted'){  
                ref.Status__c = 'Closed No Action';
            }
            
            referralsToUpdate.add(ref); 
        }
        
        update referralsToUpdate;
    }
    
    public void setReferralLeadId(Map<Id, Id> referralToLeadIdMap){
        if(referralToLeadIdMap.isEmpty()){
            return;
        }
        
        List<Referral__c> referralsToUpdate = new List<Referral__c>();
                        
        for(Id refId : referralToLeadIdMap.keySet()){           
            Referral__c ref = new Referral__c();
            
            ref.Id = refId;
            ref.Resulting_Lead__c = referralToLeadIdMap.get(refId);
            //Required to ensure update to Referral isn't treated as a newly "Submitted" referral.
            ref.Status__c = 'Working';
            
            referralsToUpdate.add(ref); 
        }
        
        update referralsToUpdate;
    }
    
    public Map<ID, Lead> getLeadObjectsForReferralToLeadIdMap(Map<Id, Id> referralToLeadIdMap){
        Map<Id, Lead> referralLeadMap = new Map<Id, Lead>();
        
        Map<Id, Lead> leadMap = new Map<Id, Lead>([SELECT Id, Status, isConverted, ConvertedOpportunityId, OwnerId, Close_Reason__c, Unqualified_Reason__c FROM Lead WHERE Id IN :referralToLeadIdMap.values()]);
        
        for(Id refId : referralToLeadIdMap.keySet()){
            referralLeadMap.put(refId, leadMap.get(referralToLeadIdMap.get(refId))); 
        }   
        
        return referralLeadMap;
    }
    
}
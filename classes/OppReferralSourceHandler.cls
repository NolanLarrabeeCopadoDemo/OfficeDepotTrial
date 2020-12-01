/*
 * Handler for OppReferralSourceTrigger.  
 * Processes changes to Opportunities and copies values to Referral object where Opportunity in Resulting_Opportunity__c field on Referral.
 * Also used by other classes to set the Opportunity ID on the Referral object.
 *
 * @author: Andrew Smith (6/10/2018)
 */ 
 
 public without sharing class OppReferralSourceHandler {
 	
 	public void processOpps(Map<Id, Opportunity> oldRecMap, Map<Id, Opportunity> newRecMap){	 	
		List<Opportunity> changedOpps = new List<Opportunity>();
		Map<Id, Opportunity> referralToOppMap = new Map<Id, Opportunity>();
		
		changedOpps = getChangedOpps(oldRecMap, newRecMap);	
		referralToOppMap = getReferralToOppMap(changedOpps);
	
		setReferralOppValues(referralToOppMap);		
	}
	
	public List<Opportunity> getChangedOpps(Map<Id, Opportunity> oldRecMap, Map<Id, Opportunity> newRecMap){		
		List<Opportunity> changedOpps =  new List<Opportunity>();
		
		for(Opportunity rec : newRecMap.values()){
			if( rec.StageName != oldRecMap.get(rec.Id).StageName || 
				rec.OwnerId != oldRecMap.get(rec.Id).OwnerId || 
				rec.Amount != oldRecMap.get(rec.Id).Amount || 
				rec.CloseDate != oldRecMap.get(rec.Id).CloseDate || 
				rec.Close_Reason__c != oldRecMap.get(rec.Id).Close_Reason__c || 
				rec.Loss_Reason__c != oldRecMap.get(rec.Id).Loss_Reason__c 
				){
					changedOpps.add(rec);
			}
		}
		
		return changedOpps;
	}
	
	// Method filters out opps not connected to a referral record.  
	public Map<Id, Opportunity> getReferralToOppMap(List<Opportunity> newRecs){
		Map<Id, Opportunity> referralOppMap = new Map<Id, Opportunity>();
		Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>();
		
		if(newRecs.isEmpty()){
			return referralOppMap;
		}	
		
		for(Opportunity opp : newRecs){
			oppMap.put(opp.Id, opp);
		}
		
		List<Referral__c> referrals = new List<Referral__c>([SELECT Id, Resulting_Opportunity__c FROM Referral__c WHERE Resulting_Opportunity__c IN :oppMap.keyset()]);
		
		for(Referral__c ref : referrals){
			referralOppMap.put(ref.Id, oppMap.get(ref.Resulting_Opportunity__c));
		}
		
		return referralOppMap;
	}
	
	public void setReferralOppValues(Map<Id, Opportunity> referralOppMap){
		if(referralOppMap.isEmpty()){
			return;
		}
		
		List<Referral__c> referralsToUpdate = new List<Referral__c>();
						
		Set<Id> userIds = new Set<Id>();
		
		for(Id refId : referralOppMap.keySet()){
			userIds.add(referralOppMap.get(refId).OwnerId);
		}
		
		Map<ID, User> userMap = new Map<ID, User>([SELECT Id, Name, Phone, Email FROM User WHERE ID IN :userIds]);
		
		for(Id refId : referralOppMap.keySet()){ 
			Opportunity opp = referralOppMap.get(refId);
			
			Referral__c ref = new Referral__c();
			
			ref.Id = refId;
			ref.Resulting_Opportunity__c = opp.Id;
			ref.Opportunity_Name__c = opp.Name;
			ref.Opportunity_Amount__c = opp.Amount;
			ref.Opportunity_Close_Date__c = opp.CloseDate;
			ref.Opportunity_Stage__c = opp.StageName;
			
				
			if(opp.Loss_Reason__c == NULL){
				ref.Loss_No_Action_Reason__c = opp.Close_Reason__c;
			}
			else{
				ref.Loss_No_Action_Reason__c = opp.Loss_Reason__c;
			}
			
			ref.Rep_Name__c = userMap.get(opp.OwnerId).Name;
			ref.Rep_Phone__c = userMap.get(opp.OwnerId).Phone;
			ref.Rep_Email__c = userMap.get(opp.OwnerId).Email;
			
			if(opp.StageName == 'Close' || opp.StageName == 'Closed Won'){   // "Close" is used by record types except Tech-Zone.  "Closed Won" is for Tech-Zone.
				ref.Status__c = 'Closed Won';
			}
			else if(opp.StageName == 'Dead - Lost' || opp.StageName == 'Lost'){   // "Lost" is used by all record types except Tech-Zone.  "Dead - Lost" is for Tech-Zone.
				ref.Status__c = 'Closed Lost';
			}
			else if(opp.StageName == 'Walkaway' || opp.StageName == 'Dead - Never Materialized'){   // "Walkaway" is used by all record types except Tech-Zone.  "Dead - Never Materialized" is for Tech-Zone.
				ref.Status__c = 'Closed No Action';
			}
			else if(opp.StageName == 'Duplicate/Cancelled'){  //  "Duplicate/Cancelled" is used by all record types except Tech-Zone.
				ref.Status__c = 'Duplicate';
			}
			else{
				ref.Status__c = 'Qualified';
			}
			
			referralsToUpdate.add(ref);	
		}
		
		update referralsToUpdate;
	}
	
	public void setReferralOppId(Map<Id, Id> referralToOppIdMap){ 
		if(referralToOppIdMap.isEmpty()){
			return;
		}
		
		List<Referral__c> referralsToUpdate = new List<Referral__c>();
						
		for(Id refId : referralToOppIdMap.keySet()){ 			
			Referral__c ref = new Referral__c();
			
			ref.Id = refId;
			ref.Resulting_Opportunity__c = referralToOppIdMap.get(refId);			
			
			referralsToUpdate.add(ref);	
		}
		
		update referralsToUpdate;
	}
	
	public Map<ID, Opportunity> getOppObjectsForReferralToOppIdMap(Map<Id, Id> referralToOppIdMap){
		Map<Id, Opportunity> referralOppMap = new Map<Id, Opportunity>();
		
		Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>([SELECT Id, Name, StageName, Amount, CloseDate, OwnerId, Close_Reason__c, Loss_Reason__c FROM Opportunity WHERE Id IN :referralToOppIdMap.values()]);
		
		for(Id refId : referralToOppIdMap.keySet()){
			referralOppMap.put(refId, oppMap.get(referralToOppIdMap.get(refId))); 
		}	
		
		return referralOppMap;
	}
    
}
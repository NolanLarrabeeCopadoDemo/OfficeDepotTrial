/*
 * Handler for ReferralDestinationTrigger.  
 * Runs destination side logic for Referral records going to a group in this org.  
 * Note input to handler is filtered down to only Referrals destined to a group in this org. 
 * Also updates Last Update Date on Referral object each time a destination owned field is changed on Referral object.
 *
 * @author: Andrew Smith (6/10/2018)
 */ 
 
public without sharing class ReferralDestinationHandler {
	
	public void createLeads(List<Referral__c>  destRecs){
		List<Referral__c> newSubmittedReferrals = new List<Referral__c>();
		List<Referral__c> updateReferrals = new List<Referral__c>();
		Map<Id, Lead> referralLeadMap = new Map<Id, Lead>();
		
		newSubmittedReferrals = ReferralUtility.getNewSubmittedReferrals(destRecs);
				
		for(Referral__c ref : newSubmittedReferrals){
			Lead ld = new Lead();
			
			ld.RecordTypeId = ReferralUtility.getLeadRecordTypeID(ref.Referred_To__c);
			ld.FirstName = ref.First_Name__c;
			ld.Company = ref.Company__c;
			ld.Title = ref.Title__c;
			ld.Phone = ref.Phone__c;
			ld.Email = ref.Email__c;
			ld.Employee_Name__c = ref.Referrer_Name__c;
			ld.Referrer_Phone__c = ref.Referrer_Phone__c;
			ld.Referrer_Email__c = ref.Referrer_Email__c;
			ld.Employee_ID__c = ref.Referrer_Employee_ID__c;
			ld.Referral_Client_Type__c = ref.Type__c;
			ld.Referral_Lead_Source__c = ref.Lead_Source__c;
			ld.Referral_Origin__c = ref.Referred_By__c;
			ld.NumberOfEmployees = Integer.valueOf(ref.Employees__c);
			ld.WCW_Count__c = ref.Employees__c;
			
			if(ref.Referred_To__c != 'Tech-Zone' && ref.Referred_By__c != 'CompuCom' && ref.Referred_By__c != 'Tech-Zone'){
 				if(ref.Street__c != NULL){
	 				if(ref.Street__c.length() > 30){
	 					ld.Address1__c = ref.Street__c.substring(0,30);
	 				}
	 				else{
	 					ld.Address1__c = ref.Street__c;
	 				}
 				}
 				
 				ld.City__c = ref.City__c;
 				ld.State__c = ref.State__c;
 				ld.Country__c = ref.Country__c;
 				
 				if(ref.Postal_Code__c != NULL){
	 				if(ref.Postal_Code__c.length() > 11){
	 					ld.Zip__c = ref.Postal_Code__c.substring(0,11);
	 				}
	 				else{
	 					ld.Zip__c = ref.Postal_Code__c;
	 				}
 				}
 			}
 			else if(ref.Referred_To__c != 'Tech-Zone'){
 				ld.City__c = ref.City__c;
 				if(ref.Postal_Code__c != NULL){
	 				if(ref.Postal_Code__c.length() > 11){
	 					ld.Zip__c = ref.Postal_Code__c.substring(0,11);
	 				}
	 				else{
	 					ld.Zip__c = ref.Postal_Code__c;
	 				}
 				}
 			}
 			else if(ref.Referred_To__c == 'Tech-Zone'){
 				ld.Street =	ref.Street__c;
 				ld.City = ref.City__c;
 				ld.State = ref.State__c;
 				ld.PostalCode = ref.Postal_Code__c;
 				ld.Country = ref.Country__c; 
 			}
			
			if(ref.Referred_To__c == 'Tech-Zone'){
				ld.Discovery_Notes__c = ref.Referrer_Comments__c;
			}
			else if(ref.Referred_To__c == 'BizBox'){
				ld.Comments__c = ref.Referrer_Comments__c;
			}
			else{
				ld.Notes__c = ref.Referrer_Comments__c;
			}
			
			if(ref.Last_Name__c == NULL){
				ld.LastName = '[not provided]';
			}
			else{
				ld.LastName = ref.Last_Name__c;
			}
			
			referralLeadMap.put(ref.Id, ld);
		}
		
		insert referralLeadMap.values();
		
		Map<Id, Id> referralToLeadIdMap = new Map<Id, Id>();
		
		for(Id refId : referralLeadMap.keySet()){
			referralToLeadIdMap.put(refId, referralLeadMap.get(refId).Id);
		}
				
		LeadReferralSourceHandler handler = new LeadReferralSourceHandler();	
		handler.setReferralLeadId(referralToLeadIdMap);
		
	}
	
	public void processChangedLeadOrOpp(Map<ID, Referral__c> oldRecMap, List<Referral__c> newRecs){
		List<Referral__c> submittedReferrals = new List<Referral__c>();
		Map<Id, Id> referralToLeadIdMap = new Map<Id, Id>();
		Map<Id, Id> referralToOppIdMap = new Map<Id, Id>();
		
		submittedReferrals = ReferralUtility.getAllSubmittedReferrals(newRecs);
		
		for(Referral__c newRef : submittedReferrals){
			if(newRef.Status__c != 'Submitted'){ 
				if(oldRecMap != NULL){
					if(oldRecMap.get(newRef.Id).Resulting_Opportunity__c != newRef.Resulting_Opportunity__c && newRef.Resulting_Opportunity__c != NULL){
						referralToOppIdMap.put(newRef.Id, newRef.Resulting_Opportunity__c);
					}
					else if(oldRecMap.get(newRef.Id).Resulting_Lead__c != newRef.Resulting_Lead__c && newRef.Resulting_Lead__c != NULL){ 
						referralToLeadIdMap.put(newRef.Id, newRef.Resulting_Lead__c);

					}
				}
				else{
					if(newRef.Resulting_Opportunity__c != NULL){
						referralToOppIdMap.put(newRef.Id, newRef.Resulting_Opportunity__c);

					}
					else if(newRef.Resulting_Lead__c != NULL){
						referralToLeadIdMap.put(newRef.Id, newRef.Resulting_Lead__c);
					}
				}
			}
		}
				
		LeadReferralSourceHandler handlerLead = new LeadReferralSourceHandler();	
		handlerLead.setReferralLeadValues(handlerLead.getLeadObjectsForReferralToLeadIdMap(referralToLeadIdMap));
		
		OppReferralSourceHandler handlerOpp = new OppReferralSourceHandler();	
		handlerOpp.setReferralOppValues(handlerOpp.getOppObjectsForReferralToOppIdMap(referralToOppIdMap));
	}
	
	public void updateTimestamps(Map<ID, Referral__c> oldRecMap, List<Referral__c> newRecs){
		List<Referral__c> changedReferrals = new List<Referral__c>();
		
		for(Referral__c ref : newRecs){
			Referral__c oldRec = oldRecMap.get(ref.Id);
			
			if( ref.Opportunity_Amount__c != oldRec.Opportunity_Amount__c || 
			    ref.Opportunity_Close_Date__c != oldRec.Opportunity_Close_Date__c ||
				ref.Opportunity_Stage__c != oldRec.Opportunity_Stage__c || 
				ref.Rep_Name__c != oldRec.Rep_Name__c || 
				ref.Status__c != oldRec.Status__c || 
				ref.Loss_No_Action_Reason__c != oldRec.Loss_No_Action_Reason__c){
				
				changedReferrals.add(ref);
			}
		}
		
		ReferralUtility.setLastUpdateDate(changedReferrals);
	}
}
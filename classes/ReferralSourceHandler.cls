/*
 * Handler for ReferralSourceTrigger.  
 * Runs source side logic for Referral records originating in this org.  
 * Note input to handler is filtered down to only Referrals originating in this org.  
 *
 * @author: Andrew Smith (6/10/2018)
 */ 
 
public without sharing class ReferralSourceHandler { 
	
	public void processReferrals(List<Referral__c> sourceRecs){		 
		List<Referral__c> unsubmittedReferrals = new List<Referral__c>();
		List<Referral__c> readyToSubmitReferrals = new List<Referral__c>();
		
		unsubmittedReferrals = ReferralUtility.getUnsubmittedReferrals(sourceRecs);
		unsubmittedReferrals = validateInput(unsubmittedReferrals);
		unsubmittedReferrals = validateTypeAndSetSource(unsubmittedReferrals);
				
		if(!unsubmittedReferrals.isEmpty()){
			populateContactInfo(unsubmittedReferrals);
			populateReferrer(unsubmittedReferrals);
			
			ReferralUtility.setLockedRecordType(unsubmittedReferrals); 
			
			readyToSubmitReferrals = ReferralUtility.getReadyToSubmitReferrals(unsubmittedReferrals);				
					
			ReferralUtility.setSubmittedStatus(readyToSubmitReferrals);
			ReferralUtility.setSubmittedRecordType(readyToSubmitReferrals);
			ReferralUtility.setSubmittedDate(readyToSubmitReferrals);
			ReferralUtility.setLastUpdateDate(readyToSubmitReferrals);
		}
	}
	
	public void sendExternalReferrals(List<Referral__c> sourceRecs){
    	List<PartnerNetworkRecordConnection> newExternalShares = new List<PartnerNetworkRecordConnection>();
    	List<Referral__c> newSubmittedReferrals = ReferralUtility.getNewSubmittedReferrals(sourceRecs);
    	
    	for(Referral__c ref : newSubmittedReferrals){
			if(ReferralUtility.isDestinationExternal(ref) && Label.Referral_S2S_Connection_ID.startsWith('04P')){ 
				PartnerNetworkRecordConnection newShare = new PartnerNetworkRecordConnection();
	            newShare.ConnectionId = Label.Referral_S2S_Connection_ID;
	            newShare.LocalRecordId = ref.Id;
	            newShare.SendClosedTasks = false;
	            newShare.SendOpenTasks = false;
	            newShare.SendEmails = false;
				
				newExternalShares.add(newShare);			
			} 
		}
		
		upsert newExternalShares;
    }
		
    public List<Referral__c> validateInput(List<Referral__c> recs){
    	List<Referral__c> validRecs = new List<Referral__c>();
    	
    	for(Referral__c ref : recs){
    		Boolean hasErrors = false;
    		
			if(ref.Referred_Lead__c == NULL && ref.Referred_Contact__c == NULL) {
				ref.Referred_Lead__c.addError('A Lead or Contact is required to submit referral.');
				ref.Referred_Contact__c.addError('A Lead or Contact is required to submit referral.');
				hasErrors = true;
			}
			else if(ref.Referred_Lead__c != NULL && ref.Referred_Contact__c != NULL) {
				ref.Referred_Contact__c.addError('Contact must be blank when referring a Lead.');
				hasErrors = true;
			}
			
			if(ref.Referred_To__c == NULL) {
				ref.Referred_To__c.addError('Complete this field.');
				hasErrors = true;
			}
		
			if(!hasErrors){
				validRecs.add(ref);
			}
		}
		
		return validRecs;
    }
    
    public List<Referral__c> validateTypeAndSetSource(List<Referral__c> recs){
    	List<Referral__c> validRecs = new List<Referral__c>();
    	
 		Set<ID> leadIds = new Set<ID>();
 		Set<ID> contactIds = new Set<ID>();
 	
 		for(Referral__c ref : recs){
 			if(ref.Referred_Lead__c !=NULL){
 				leadIds.add(ref.Referred_Lead__c);
 			}
 			else{
 				contactIds.add(ref.Referred_Contact__c);
 			}
 		}
 		
 		Map<ID, Lead> leadMap = new Map<ID, Lead>([SELECT Id, RecordTypeId FROM Lead WHERE ID IN :leadIds]);
 		Map<ID, Contact> contactMap = new Map<ID, Contact>([SELECT Id, RecordTypeId FROM Contact WHERE ID IN :contactIds]);
 		
 		for(Referral__c ref : recs){
 			Boolean hasErrors = false;
 			
 			if(ref.Referred_Lead__c !=NULL){
 				ID recordTypeId = leadMap.get(ref.Referred_Lead__c).RecordTypeId;
 				
 				if(ReferralUtility.getValidLeadRecordTypesById().containsKey(recordTypeId)){
 					ref.Referred_By__c = ReferralUtility.getValidLeadRecordTypesById().get(recordTypeId);
 				}
 				else{
 					ref.Referred_Lead__c.addError('This Lead type is not supported for referral.');
 					hasErrors = true;
 				}
 			}
 			else{
 				ID recordTypeId = contactMap.get(ref.Referred_Contact__c).RecordTypeId;
 				
 				if(ReferralUtility.getValidContactRecordTypesById().containsKey(recordTypeId)){
 					ref.Referred_By__c = ReferralUtility.getValidContactRecordTypesById().get(recordTypeId);
 				}
 				else{
 					ref.Referred_Contact__c.addError('This Contact type is not supported for referral.');
 					hasErrors = true;
 				}
 			}
 			
 			if(ref.Referred_By__c == ref.Referred_To__c){
 				if(ref.Referred_Lead__c != NULL){
 					ref.Referred_To__c.addError('This Lead is already referred to this organization.');
 					hasErrors = true;
 				}
 				else{
 					ref.Referred_To__c.addError('This Contact is already referred to this organization.');
 					hasErrors = true;
 				}
 			}
 			
 			if(!hasErrors){
				validRecs.add(ref);
			}
 		}
 		
 		return validRecs;
    }
    
    public void populateContactInfo(List<Referral__c> recs){
    	Set<ID> leadIds = new Set<ID>();
 		Set<ID> contactIds = new Set<ID>();
 	
 		for(Referral__c ref : recs){
 			if(ref.Referred_Lead__c !=NULL){
 				leadIds.add(ref.Referred_Lead__c);
 			}
 			else{
 				contactIds.add(ref.Referred_Contact__c);
 			} 
 		}
 		
 		Map<ID, Lead> leadMap = new Map<ID, Lead>([SELECT Id, FirstName, LastName, Company, Phone, Email, LeadSource, Title, OwnerId, Owner.Type, RecordTypeId, NumberOfEmployees, WCW_Count__c,
 															Street, City, State, PostalCode, Country,
 															Address1__c, City__c, State__c, Zip__c, Country__c   
 												   FROM Lead 
 												   WHERE ID IN :leadIds]);
 		Map<ID, Contact> contactMap = new Map<ID, Contact>([SELECT Id, FirstName, LastName, 
 																	Account.Name, Account.RecordTypeId, RecordTypeId, Account.OwnerId, Account.NumberOfEmployees, Account.Org_WCW_Count_Rep__c,
 																	Account.BillingStreet, Account.BillingCity, Account.BillingState, Account.BillingPostalCode, Account.BillingCountry,
 																	Account.Address1__c, Account.City__c, Account.State__c, Account.Zip__c, Account.Country__c,   
 																	Title, Phone, Phone1_Rep__c, Email, LeadSource 
 															FROM Contact 
 															WHERE ID IN :contactIds]);
 		
 		for(Referral__c ref : recs){
 			if(ref.Referred_Lead__c !=NULL){
 				Lead ld = leadMap.get(ref.Referred_Lead__c);
 				ref.First_Name__c = ld.FirstName;
 				ref.Last_Name__c = ld.LastName;
 				ref.Company__c = ld.Company;
 				ref.Phone__c = ld.Phone;
 				ref.Email__c = ld.Email;
 				ref.Title__c = ld.Title;
 				ref.Lead_Source__c = ld.LeadSource; 
 				ref.Type__c = 'Prospect';
 				
 				if(ref.Referred_By__c != 'Tech-Zone'){
 					ref.Employees__c = ld.WCW_Count__c;
 					ref.Street__c = ld.Address1__c;
 					ref.City__c = ld.City__c;
 					ref.State__c = ld.State__c;
 					ref.Postal_Code__c = ld.Zip__c;
 					ref.Country__c = ld.Country__c;
 				}
 				else{
 					ref.Employees__c = ld.NumberOfEmployees;
 					ref.Street__c = ld.Street;
 					ref.City__c = ld.City;
 					ref.State__c = ld.State;
 					ref.Postal_Code__c = ld.PostalCode;
 					ref.Country__c = ld.Country; 
 				}
 			}
 			else{
 				Contact ct = contactMap.get(ref.Referred_Contact__c);
 				ref.First_Name__c = ct.FirstName;
 				ref.Last_Name__c = ct.LastName;
 				ref.Company__c = ct.Account.Name;
 				ref.Email__c = ct.Email;
 				ref.Title__c = ct.Title;
 				ref.Lead_Source__c = ct.LeadSource;
 				
 				if(ref.Referred_By__c != 'Tech-Zone'){
 					ref.Phone__c = ct.Phone1_Rep__c;
 				}
 				else{
 					ref.Phone__c = ct.Phone;
 				}
 				
 				if(ref.Referred_By__c != 'Tech-Zone'){
 					ref.Employees__c = ct.Account.Org_WCW_Count_Rep__c;
 					ref.Street__c = ct.Account.Address1__c;
 					ref.City__c = ct.Account.City__c;
 					ref.State__c = ct.Account.State__c;
 					ref.Postal_Code__c = ct.Account.Zip__c;
 					ref.Country__c = ct.Account.Country__c;
 				}
 				else{
 					ref.Employees__c = ct.Account.NumberOfEmployees;
 					ref.Street__c = ct.Account.BillingStreet;
 					ref.City__c = ct.Account.BillingCity;
 					ref.State__c = ct.Account.BillingState;
 					ref.Postal_Code__c = ct.Account.BillingPostalCode;
 					ref.Country__c = ct.Account.BillingCountry;
 				}
 				
 				if(ReferralUtility.isCustomerAccount(ct.Account)){
 					ref.Type__c = 'Customer';
 				}
 				else{
 					ref.Type__c = 'Prospect';
 				}
 			}
 		}
    }
    
    public void populateReferrer(List<Referral__c> recs){ 	
    	Set<ID> userIds = new Set<ID>(); 
 		userIds.add(UserInfo.getUserId());
 	
 		for(Referral__c ref : recs){
 			if(ref.Referrer__c != NULL){
 				userIds.add(ref.Referrer__c);
 			}
 		}
 		
 		Map<ID, User> userMap = new Map<ID, User>([SELECT Id, Name, Phone, Email, Region__c, OD_Employee_ID__c FROM User WHERE ID IN :userIds]);
 		
 		for(Referral__c ref : recs){
 			User usr;
 			
 			if(ref.Referrer__c != NULL){
	 			usr = userMap.get(ref.Referrer__c);
 			}
 			else{
 				usr = userMap.get(UserInfo.getUserId());
 				ref.Referrer__c = usr.Id;
 			}
 				
 			ref.Referrer_Name__c = usr.Name;
 			ref.Referrer_Phone__c = usr.Phone;
 			ref.Referrer_Email__c = usr.Email;	
 			ref.Referrer_Employee_ID__c = usr.OD_Employee_ID__c;	 
 			ref.Referrer_Region__c = usr.Region__c;	 	
 		}
    }

}
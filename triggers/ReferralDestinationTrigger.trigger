/*
 * Trigger to run destination side logic for Referral records going to a group in this org.  
 * Note input to handler is filtered down to only Referrals destined to a group in this org.  
 *
 * @author: Andrew Smith (6/10/2018)
 */
 
trigger ReferralDestinationTrigger on Referral__c (before insert, before update, after insert, after update) {
	
	if((Trigger.isInsert || Trigger.isUpdate) && Trigger.isAfter){
		ReferralDestinationHandler handler = new ReferralDestinationHandler();
 		handler.createLeads(ReferralUtility.getDestinationReferrals(trigger.new));
 		handler.processChangedLeadOrOpp(trigger.oldMap, ReferralUtility.getDestinationReferrals(trigger.new));
	}
	else if(Trigger.isUpdate && Trigger.isBefore){
		ReferralDestinationHandler handler = new ReferralDestinationHandler();
 		handler.updateTimestamps(trigger.oldMap, ReferralUtility.getDestinationReferrals(trigger.new));
 		ReferralUtility.setSubmittedRecordType(ReferralUtility.getDestinationReferrals(trigger.new)); 		 
	}   
    else if(Trigger.isInsert && Trigger.isBefore){
		ReferralUtility.setSubmittedRecordType(ReferralUtility.getDestinationReferrals(trigger.new));
	}  
    
}
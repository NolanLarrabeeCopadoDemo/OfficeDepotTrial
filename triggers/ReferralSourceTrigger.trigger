/*
 * Trigger to run source side logic for Referral records originating in this org.  
 * Note input to handler is filtered down to only Referrals originating in this org.  
 *
 * @author: Andrew Smith (6/10/2018)
 */

trigger ReferralSourceTrigger on Referral__c (before insert, before update, after insert, after update) {

	if((Trigger.isInsert || Trigger.isUpdate) && Trigger.isBefore){
		ReferralSourceHandler handler = new ReferralSourceHandler();
 		handler.processReferrals(ReferralUtility.getSourceReferrals(Trigger.new));
	}
	else if((Trigger.isInsert || Trigger.isUpdate) && Trigger.isAfter){
		ReferralSourceHandler handler = new ReferralSourceHandler();
 		handler.sendExternalReferrals(ReferralUtility.getSourceReferrals(Trigger.new)); 
	} 
}
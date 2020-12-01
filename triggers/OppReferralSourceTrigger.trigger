/*
 * Trigger to run destination side logic for Opps created in response to a Referral record.  
 * Copies information from Opp record to Referral record based on Opp record changes. 
 *
 * @author: Andrew Smith (6/10/2018)
 */
 
trigger OppReferralSourceTrigger on Opportunity (after update) {
 	
 	if(Trigger.isUpdate && Trigger.isAfter){
		OppReferralSourceHandler handler = new OppReferralSourceHandler();
 		handler.processOpps(Trigger.oldMap, Trigger.newMap);
	}
    
}
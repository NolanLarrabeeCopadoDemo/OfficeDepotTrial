// Appirio 2015 
// Universal trigger handler for Customer_Transition__c object
//
// NBOCK - Original - 7.15.2015 - S-335210

public class customerTransitionTriggerHandler{ 
	public Customer_Transition__c[] newLst = new Customer_Transition__c[]{}; 
	public Customer_Transition__c[] oldLst = new Customer_Transition__c[]{}; 
	public Map <ID, Customer_Transition__c> newMap = new Map<ID, Customer_Transition__c>{}; 
	public Map <ID, Customer_Transition__c> oldMap = new Map<ID, Customer_Transition__c>{}; 

	public customerTransitionTriggerHandler(Customer_Transition__c[] triggered, Customer_Transition__c[] triggeredFrom, Map<ID,Customer_Transition__c> triggerNewMap, Map<ID,Customer_Transition__c> triggerOldMap){ 
		newLst = triggered; 
		oldLst = triggeredFrom; 
		newMap = triggerNewMap; 
		oldMap = triggerOldMap; 
	} 

	public void onBeforeInsert(){ 
		//no methods defined at this time
	}

	public void onAfterInsert(){ 
		updateRelatedWRF();
	}

	public void onBeforeUpdate(){ 
		//no methods defined at this time
	}

	public void onAfterUpdate(){ 
		updateRelatedWRF();
	}

	//currently not in use
	/*
	public void onBeforeDelete(){ 
		//no methods defined at this time
	}
	public void onAfterDelete(){ 

	} */

	//if customer transition record status is On Deck, set the Approved For Assignment field on any related WRFs
	public void updateRelatedWRF(){
		//create set of case Ids 
		List<Id> caseIds = new List<Id>();

		//get on deck records with WRF cases
		for(Customer_Transition__c ct : newLst){
			if(ct.Status__c == 'On Deck' && ct.Related_WRF_Case__c != null && oldMap.get(ct.id).Status__c != 'On Deck'){
				caseIds.add(ct.Related_WRF_Case__c);	
			}
		}

		//get case records to update
		if(!caseIds.isEmpty()){
			List<Case> relatedCases = new List<Case>();
			relatedCases = [SELECT Id, Approved_for_Analyst_Assignment__c FROM Case WHERE Id IN :caseIds];

			//update case records
			if(!relatedCases.isEmpty()){
				for(Case rc : relatedCases){
					rc.Approved_for_Analyst_Assignment__c = true;
				}
				update relatedCases;
			}
		}
	}
}
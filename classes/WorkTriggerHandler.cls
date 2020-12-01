/*****************************************************************
Author			: Appirio India (Hitesh Pareek)
Date(original)	: Jan 14, 2016
Purpose			: Trigger handler created as part of - S-374368
******************************************************************/
public without sharing class WorkTriggerHandler {
	public static void afterUpdateHandler(Map<Id, agf__ADM_Work__c> oldRecords, Map<Id, agf__ADM_Work__c> newRecords){
		//check if agf__Status__c is being updated , then process for updating the related support case	
			syncSupportCase(oldRecords,newRecords);					
	}
	
	private static void syncSupportCase(Map<Id, agf__ADM_Work__c> oldRecords, Map<Id, agf__ADM_Work__c> newRecords){
		List<case> casesToBeUpdated = new List<case>();
			for(agf__ADM_Work__c work :newRecords.values()){
				if(oldRecords.get(work.id).agf__Status__c != work.agf__Status__c && work.Case_ID__c != null){
					if(work.agf__Status__c.equalsIgnoreCase('In Progress'))
						casesToBeUpdated.add(new case(id=work.Case_ID__c, Status = 'In Progress'));						
					else if(work.agf__Status__c.equalsIgnoreCase('Ready for Review'))
						casesToBeUpdated.add(new case(id=work.Case_ID__c, Status = 'In Progress'));
					else if(work.agf__Status__c.equalsIgnoreCase('QA In Progress'))
						casesToBeUpdated.add(new case(id=work.Case_ID__c, Status = 'In Progress'));
					else if(work.agf__Status__c.equalsIgnoreCase('Waiting'))
						casesToBeUpdated.add(new case(id=work.Case_ID__c, Status = 'Awaiting Information'));						
					else if(work.agf__Status__c.equalsIgnoreCase('Pending Release'))
						casesToBeUpdated.add(new case(id=work.Case_ID__c, Status = 'In Progress'));
					else
						continue;																					
				}
			}
			
			if(casesToBeUpdated.size() > 0)
				update casesToBeUpdated;
	}	
}
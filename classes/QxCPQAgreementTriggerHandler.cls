public class QxCPQAgreementTriggerHandler {

    /**
    * Main method called on an after update trigger on the PROS_Agreement__c object (PROS Quote)
    */
    public void handleAfterUpdate(List<PROS_Agreement__c> agreementsOld, List<PROS_Agreement__c> agreementsNew){
        for (PROS_Agreement__c agreementNew : agreementsNew) {
            for (PROS_Agreement__c agreementOld : agreementsOld)
            {
                if(agreementOld.Id==agreementNew.Id){
                    
              		//Check if there is a change of Active Flag
                    if (agreementOld.Active__c != agreementNew.Active__c){
                        
                       //If Active flag becomes true; unflag other agreements from same account
                        if(agreementNew.Active__c == true){
                            Id accountId = agreementNew.Account__c;
            				List<PROS_Agreement__c> activeAgreements = [SELECT Id,Name,Quote__r.CameleonCPQ__AccountId__c,Active__c FROM PROS_Agreement__c WHERE Active__c = true AND Quote__r.CameleonCPQ__AccountId__c =: accountId AND Id !=: agreementNew.Id ];
                            for(PROS_Agreement__c ag : activeAgreements){
                                ag.Active__c = false;
                            }
                            update activeAgreements;
                        }
                    }
                }
        	}
    	}
	}
    
}
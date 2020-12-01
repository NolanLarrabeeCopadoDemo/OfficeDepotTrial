global class GT_UpdateCanadaFieldsOnExchangeRate{ 

    @future 
    public static void updateLead(String newExchangeRate){

        List<Lead> leadList = new List<Lead>();
        
        List<Lead> updatedLeadList = new List<Lead>();
            
        if(newExchangeRate != null) {

            //Prepaing List for Open Leads for Canada
            leadList = [select id,Amount_CAD__c,Amount__c from Lead where recordtype.name = 'Lead (Canada)' and isConverted = false];
         
            //Updating Leads as per new Exchange Rate
            if(leadList!=null && !leadList.isEmpty()) {
                for(Lead leadToUpdate: leadList) {
                    if(leadToUpdate.Amount_CAD__c != null) {
                    system.debug('Current Values@@@id : Amount_CAD__c : Amount__c@@@'+leadToUpdate.id+leadToUpdate.Amount_CAD__c+'@@@'+leadToUpdate.Amount__c );
                    
                    leadToUpdate.Amount__c = Double.valueof(leadToUpdate.Amount_CAD__c) / Double.valueof(newExchangeRate);
                    updatedLeadList.add(leadToUpdate);
                    
                    system.debug('Updated Values@@@ Amount_CAD__c : Amount__c@@@'+leadToUpdate.Amount_CAD__c+'@@@'+leadToUpdate.Amount__c );
                    }
                }
            }
            
            
            try {
                if(updatedLeadList!=null && !updatedLeadList.isEmpty()) {
                system.debug('updatedLeadList@@@@'+updatedLeadList);
                Database.update(updatedLeadList, false);
                }
            }
            catch(Exception e){
                system.debug('Exception occured while updating records'+e);
            }   
        }
    }
    
    @future
    public static void updateOpportunity(String newExchangeRate){
   
        List<Opportunity> opptyList = new List<Opportunity>();
        
        List<Opportunity> updatedOpptyList = new List<Opportunity>();
            
        if(newExchangeRate != null) {

            //Prepaing List for Open Opportunities for Canada
            opptyList = [select id,Committed_Forecast_CAD__c,Committed_Forecast__c,Amount_CAD__c,Amount from Opportunity where recordtype.name = 'GT Field Sales' and status__c = 'Open'];
                 
            //Updating Opportunities as per new Exchange Rate
             if(opptyList!=null && !opptyList.isEmpty()) {
            for(Opportunity opptToUpdate: opptyList) {
                if(opptToUpdate.Committed_Forecast_CAD__c != null || opptToUpdate.Amount_CAD__c != null) {
                
                system.debug('Current Values@@@ID : Amount_CAD__c : Amount@@@'+opptToUpdate.id+opptToUpdate.Amount_CAD__c+'@@@'+opptToUpdate.Amount);
                system.debug('Current Values@@@ Committed_Forecast_CAD__c : Committed_Forecast__c@@@'+opptToUpdate.Committed_Forecast_CAD__c+'@@@'+opptToUpdate.Committed_Forecast__c );
                
                if(opptToUpdate.Amount_CAD__c != null)
                opptToUpdate.Amount = Double.valueof(opptToUpdate.Amount_CAD__c) / Double.valueof(newExchangeRate);
                if(opptToUpdate.Committed_Forecast_CAD__c!= null)
                opptToUpdate.Committed_Forecast__c = Double.valueof(opptToUpdate.Committed_Forecast_CAD__c) / Double.valueof(newExchangeRate);
                updatedOpptyList.add(opptToUpdate);
                
                system.debug('Updated Values@@@ Amount_CAD__c : Amount@@@'+opptToUpdate.Amount_CAD__c+'@@@'+opptToUpdate.Amount);
                system.debug('Updated Values@@@ Committed_Forecast_CAD__c : Committed_Forecast__c@@@'+opptToUpdate.Committed_Forecast_CAD__c+'@@@'+opptToUpdate.Committed_Forecast__c );
                
                }
            }
            }
            try {
                if(updatedOpptyList!=null && !updatedOpptyList.isEmpty()) {
                system.debug('updatedOpptyList@@@@'+updatedOpptyList);
                Database.update(updatedOpptyList, false);
                }
            }
            catch(Exception e){
                system.debug('Exception occured while updating records'+e);
            }   
        }
    }
}
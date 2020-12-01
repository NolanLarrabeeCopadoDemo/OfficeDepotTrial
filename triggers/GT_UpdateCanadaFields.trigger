trigger GT_UpdateCanadaFields on Exchange_Rate__c (after update) {
    if (trigger.isUpdate) {
        String newExchangeRate;
        
        for (Exchange_Rate__c ExchangeRateObj : Trigger.new) {
            newExchangeRate = ExchangeRateObj.Rate__c;
        }
        if(newExchangeRate != null) {
        //commenting the update of Lead amount as US Lead amount field is used in the convert page for GT
        ///////////GT_UpdateCanadaFieldsOnExchangeRate.updateLead(newExchangeRate);
        GT_UpdateCanadaFieldsOnExchangeRate.updateOpportunity(newExchangeRate);
        }
    }
}
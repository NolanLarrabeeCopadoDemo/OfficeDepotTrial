public class CPTRelatedListController {
    @AuraEnabled
    public static List<Contract_Pricing_Terms__c> fetchCPT(id contractId) {
        
        List<Contract_Pricing_Terms__c> cptList = [SELECT Id,Contract__c, Name, Relevant_Customer_Level__c, CC_Pricing_Update_Frequency_in_days__c, Active__c,
                                                   CC_Prc_Chg_Notice_Reqd_days__c, Comm_Req_CC_Price_Chg__c, CC_Price_Incr_Capped__c, Private_Brand__c, Calendar_period__c, In_days__c,Addition_communication_requirements__c, Deletion_communication_requirements__c from Contract_Pricing_Terms__c where Contract__c =: ContractId];
        system.debug('cptList--->>>>'+cptList);
        return cptList;
        
    }
    @AuraEnabled
    public static Void deleteCPT(id cptId) {
        
        if(cptId!=null){
        Contract_Pricing_Terms__c ContractPricing_alias=[Select id from Contract_Pricing_Terms__c where id=:cptId];
        delete ContractPricing_alias;
        }
        
    }

}